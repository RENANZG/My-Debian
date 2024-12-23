# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       none
:platform:      all

Salt file path utilities for locating file paths and converting paths.

Convert paths types to:
    - relpath(path, saltenv): |
        'topd/init.sls'

    - salt_path(path, saltenv):  |
        'salt://topd/init.sls'

    - cache_path(path, saltenv): |
        '/var/cache/salt/minion/files/base/topd/init.sls'
        'file:///var/cache/salt/minion/files/base/topd/init.sls'

    - local_path(path, saltenv): |
        '/srv/formulas/base/topd-formula/topd/init.sls'
        'file:///srv/formulas/base/topd-formula/topd/init.sls'

    - sls(path, saltenv): |
        'topd'

Determine current path type:
    - is_relpath(path, saltenv) -> boolean
    - is_salt_path(path, saltenv) -> boolean
    - is_cache_path(path, saltenv) -> boolean
    - is_local_path(path, saltenv) -> boolean
    - is_slspath(path, saltenv) -> boolean

Utils:
    - Get cache directory for given salt environment: |
        cache_dir(saltenv):  |
            '/var/cache/salt/minion/files/base'

    - Loacte file_root for any path:
        file_root(path, saltenv='base')

Filter:
    by env and/or pattern
'''

from __future__ import absolute_import

# Import python libs
import collections
import copy
import logging
import os

from itertools import (chain, product, starmap, )

# Import salt libs
import salt.fileclient

from salt.exceptions import SaltRenderError
from salt.utils.odict import (OrderedDict, DefaultOrderedDict)
from salt.utils.url import urlparse

# Import custom libs
import matcher
import fileinfo

from pathinfo import PathInfo

# Enable logging
log = logging.getLogger(__name__)

try:
    __context__['salt.loaded.ext.util.pathutils'] = True
except NameError:
    __context__ = {}

# Define the module's virtual name
__virtualname__ = 'pathutils'


def __virtual__():
    '''
    '''
    return __virtualname__


class PathUtils(object):
    '''
    Mapping and various utility functions for salt paths.
    '''

    def __init__(
        self,
        opts,
        pillar=False,
        *varargs,
        **kwargs
    ):  # pylint: disable=W0613
        self.opts = opts
        self.pillar = pillar

        if pillar and not self.is_pillar():
            opts = dict(opts)
            opts['file_roots'] = opts['pillar_roots']
            self.opts = opts

        self.client = salt.fileclient.get_file_client(
            self.opts, self.is_pillar()
        )

        self._states = DefaultOrderedDict(list)
        self._saltenvs = self.client.envs()

    def saltenv(self, path, saltenv=None):
        '''
        Returns the saltenv for path if saltenv is None and path is found.

        :param path:
        :param saltenv:
        '''
        if saltenv:
            return saltenv

        relpath = self.relpath(path)
        files = self.find(relpath=relpath)
        saltenvs = list(map(lambda s: self.get(s, 'saltenv'), files))

        if saltenvs:
            return saltenvs[0]

        return None

    @staticmethod
    def get(element, key):
        return matcher.getter(key, element)(element)

    def saltenvs(self, saltenv=None):
        '''
        Return either the passed saltenv as a list or client.envs if saltenv
        is None.

        Also move 'base' env to start of list since list is used to find paths
        when no saltenv is passed or known to make sure 'base' is searched
        first.

        :param saltenv:
        '''
        if saltenv:
            saltenvs = saltenv
            if isinstance(saltenv, str):
                saltenvs = [saltenvs]
        else:
            if not self._saltenvs:
                self._saltenvs = self.client.envs()
            saltenvs = self._saltenvs

        if 'base' in saltenvs and saltenvs[0] != 'base':
            saltenvs.insert(0, saltenvs.pop(saltenvs.index('base')))

        return saltenvs

    def pathinfo_roots(self, saltenvs=None, include=None):
        '''
        Returns a dictionary of pillar roots which will contain both the
        saltenv and directories used when gathering files.

        :param saltenvs:
            List of salt environments to include within roots.

        :param include:
            List of roots to include (cache_roots, file_roots and/or
            pillar_roots).  If include is None, all roots are included.
        '''
        if isinstance(include, str):
            include = [include]

        default_includes = ['cache_roots', 'file_roots', 'pillar_roots']
        include = include if include else default_includes
        saltenvs = self.saltenvs(saltenvs)
        roots = set()
        Roots = collections.namedtuple('Roots', 'saltenv root')

        def to_named_tuple(element):
            return list(
                Roots(saltenv, path)
                for saltenv, paths in element.items() for path in paths
                if saltenv in saltenvs
            )

        if 'cache_roots' in include:
            roots.update(
                set(
                    starmap(
                        lambda *x: Roots(x[-1], os.path.join(*x)), product(
                            [self.opts['cachedir']], ['files', 'localfiles'],
                            saltenvs
                        )
                    )
                )
            )

        if 'file_roots' in include:
            roots.update(to_named_tuple(self.opts['file_roots']))

        if 'pillar_roots' in include:
            roots.update(to_named_tuple(self.opts['pillar_roots']))

        return fileinfo.reduceby('saltenv', 'root', roots)

    def files(
        self,
        saltenv=None,
        roots=None,
        view=None,
        files=None,
        flat=None,
        pathinfo=None,
        **patterns
    ):
        '''
        Return a list of the files in the file server's specified environment
        or a dictionary of all results if saltenv is None.

        All files will be filtered if a pattern is supplied.

        :param saltenv:
            Can be a single saltenv such as 'base', a list of saltenv's such
            as ['base', 'all'], or None in which case all saltenv's will be
            set.

        :param roots:

        :param view:

        :param files:

        :param patterns:
            Only return files that match wildcard pattern filter such as
            '*.tops'.

        :param flat:
            If True, a list of all environment values will be returned,
            otherwise a dictionary with the passed saltenv will be returned.
            The default for a single salt environment is to flatten.

        :param pathinfo:
            FileInfo instance to use to parse filelist.
        '''
        if files:
            return self.find(files, **patterns)

        # Convert saltenv to list; include all environments if saltenv is None
        saltenvs = self.saltenvs(saltenv)

        # XXX: Test with get_top; maybe don't need cache_roots / file_roots
        #      if pillar is True
        #
        # Get default file_roots, pillar_roots and cache_roots if roots is None
        if not roots:
            roots = self.pathinfo_roots(saltenvs)

        # Select patterns to use for filtering file list or default to selected
        # saltenvs
        patterns = patterns or dict(saltenv=saltenvs)

        # XXX: Add a way to determine which object to use?
        #      topinfo may want to have different object; maybe a routine
        #      that calls this one first so as not to overload file signature
        #
        # Walk roots to retrieve a listing of all files
        pathinfo = pathinfo or PathInfo(match_each=True, **patterns)

        # Extra kwargs for pathinfo
        extra_kwargs = {
            'cachedir': self.opts.get('cachedir', None),
            'is_pillar': self.is_pillar()
        }

        # Generate filtered pathinfo list
        files = pathinfo.filelist(roots=roots, **extra_kwargs)

        # Determine and return pathinfo view which can be one of flattened,
        # reduceby (dictionary) or all (un-modified).
        if len(saltenvs) == 1 and flat is None:
            flat = True

        view = view or ['saltenv', 'relpath']

        return fileinfo.fileinfo_view(files, view=view, flat=flat)

    def find(self, files=None, **patterns):
        '''
        Search files based on one or more patterns, where patterns consist of
        the files 'index_name = pattern' such as:

            relpath = ['*.sls']

        :param files:
        '''
        if files is None:
            files = self.files(view='raw')

        return fileinfo.find(files, **patterns)

    def states(self, saltenv=None):
        '''
        Return a list of state files in the specified environment
        or a dictionary of all results if saltenv is None.

        :param saltenv:
        '''
        states = {}

        # Cache states
        for env in self.saltenvs(saltenv):
            if env not in self._states:
                self._states[env] = self.client.list_states(env)
            states[env] = copy.deepcopy(self._states[env])

        if saltenv:
            return {saltenv: states[saltenv]}
        return states

    def report(self, files=None, saltenv=None, patterns=None):
        if not files:
            saltenvs = self.saltenvs(saltenv)
            files = self.files(saltenvs, view='raw', **patterns)

        report = OrderedDict()

        for pathinfo in files:
            report[self.get(pathinfo, 'abspath')] = self.info(pathinfo)

        return report

    def info(self, pathinfo):
        '''
        Returns a mapping of paths if found or '' if not found.

        :param pathinfo:
        '''
        info = OrderedDict()
        try:
            info['pathinfo'] = pathinfo._asdict()
        except AttributeError:
            info['pathinfo'] = pathinfo

        info['saltenv'] = self.get(pathinfo, 'saltenv')
        info['file_root'] = self.get(pathinfo, 'file_root')
        info['relpath'] = self.get(pathinfo, 'relpath')
        info['abspath'] = self.get(pathinfo, 'abspath')
        info['cache_path'] = self.cache_path(pathinfo)

        if info['cache_path']:
            info['cache_path_exists'] = os.path.exists(info['cache_path'])

        info['local_path'] = self.local_path(pathinfo)

        if info['local_path']:
            info['local_path_exists'] = os.path.exists(info['local_path'])

        info['salt_path'] = self.salt_path(pathinfo)
        info['slspath'] = self.slspath(pathinfo)
        info['is_pillar'] = self.get(pathinfo, 'is_pillar')

        return info

    @staticmethod
    def _normpath(path):
        if not urlparse(path).scheme:
            return os.path.normpath(path)
        return path

    def is_pillar(self):
        opts = self.opts
        return True if opts['file_roots'] is opts['pillar_roots'] else False

    def path_type(self, path, saltenv=None):
        '''
        Return path type.

        :param path:
        :param saltenv:
        '''
        path = self._normpath(path)

        if self.is_relpath(path, saltenv):
            return 'relpath'

        elif self.is_slspath(path, saltenv):
            return 'sls'

        elif self.is_cache_path(path):
            return 'cache_path'

        elif self.is_local_path(path):
            return 'local_path'

        elif self.is_salt_path(path):
            return 'salt_path'

        else:
            return 'unknown'

    def path(self, path, saltenv=None, path_type=None):
        '''
        Relative salt path is the base path that all paths rely on.  Any
        conversions from formats that are not relative will happen here.

        :param path:
        :param saltenv:
        :param path_type:
        '''
        if isinstance(path, list):
            return [self.path(p, saltenv) for p in path]

        path = self._normpath(path)
        url = urlparse(path)
        path_type = path_type or self.path_type(path, saltenv)

        if path_type in ['relpath']:
            return path

        if path_type in ['slspath']:
            source = self.client.get_state(url.path, saltenv).get('source')
            return salt.utils.url.parse(source)[0]

        if path_type in ['cache_path']:
            return os.path.relpath(url.path, self.cache_dir(saltenv))

        if path_type in ['local_path']:
            roots = self.file_root(url.path, saltenv)
            for root in roots:
                if not self.is_cache_path(root):
                    return os.path.relpath(url.path, root)
            return ''

        if path_type in ['salt_path']:
            return url.netloc + url.path

        raise SaltRenderError('Could not find relpath for {0}'.format(path))

    def is_relpath(self, path, saltenv=None):
        '''
        path:      'topd/init.sls'
        relpath:   'topd/init.sls'

        :param path:
        :param saltenv:
        '''
        try:
            url = urlparse(path)
            if not salt.utils.url.validate(
                path, [
                    ''
                ]
            ) or os.path.isabs(url.path):
                return False
            return not self.is_slspath(url.path, saltenv)

        except AttributeError:
            return False

    def relpath(self, path, saltenv=None):
        '''
        path:      'topd/init.sls'
        relpath:   'topd/init.sls'

        :param path:
        :param saltenv:
        '''
        if isinstance(path, list):
            return [self.relpath(p, saltenv) for p in path]
        try:
            return self.get(path, 'relpath')
        except AttributeError:
            pass

        if self.is_relpath(path, saltenv):
            return path

        return self.path(path, saltenv)

    @staticmethod
    def is_salt_path(path):
        '''
        salt_path: 'salt://topd/init.sls'

        :param path:
        '''
        if isinstance(path, str):
            return salt.utils.url.validate(path, ['salt'])
        return False

    def salt_path(self, path, saltenv=None):
        '''
        salt_path: 'salt://topd/init.sls'

        :param path:
        :param saltenv:
        '''
        if isinstance(path, list):
            return [self.salt_path(p, saltenv) for p in path]

        if self.is_salt_path(path):
            return path

        try:
            relpath = self.get(path, 'relpath')
        except AttributeError:
            saltenv = saltenv or self.saltenv(path, saltenv)
            relpath = self.relpath(path, saltenv)

        if not relpath:
            return ''

        return salt.utils.url.create(relpath)

    def cache_dir(self, saltenv):
        '''
        cache_dir: '/var/cache/salt/minion/files/base'

        :param saltenv:
        '''
        return salt.utils.path_join(self.opts['cachedir'], 'files', saltenv)

    def is_cache_path(self, path):
        '''
        cache_path: '/var/cache/salt/minion/files/base/topd/init.sls'
                    'file:///var/cache/salt/minion/files/base/topd/init.sls'

        :param path:
        '''
        try:
            return os.path.commonprefix(
                [self.get(path, 'abspath'), self.opts['cachedir']]
            ) == self.opts['cachedir']

        except AttributeError:
            if salt.utils.url.validate(path, ['', 'file']):
                url = urlparse(path)
                return os.path.commonprefix(
                    [url.path, self.opts['cachedir']]
                ) == self.opts['cachedir']

        return False

    def cache_path(self, path, saltenv=None):
        '''
        cache_path: '/var/cache/salt/minion/files/base/topd/init.sls'
                    'file:///var/cache/salt/minion/files/base/topd/init.sls'

        :param path:
        :param saltenv:
        '''
        if isinstance(path, list):
            return [self.cache_path(p, saltenv) for p in path]

        try:
            if self.is_cache_path(self.get(path, 'abspath')):
                return self.get(path, 'abspath')
            return ''

        except AttributeError:
            pass

        if self.is_cache_path(path):
            return path

        saltenv = saltenv or self.saltenv(path, saltenv)
        relpath = self.relpath(path, saltenv)
        cache_path = salt.utils.path_join(self.cache_dir(saltenv), relpath)

        if os.path.exists(cache_path):
            return cache_path

        return ''

    def is_local_path(self, path):
        '''
        local_path: '/srv/formulas/base/topd-formula/topd/init.sls'
                    'file:///srv/formulas/base/topd-formula/topd/init.sls'

        :param path:
        '''
        try:
            path = self.get(path, 'abspath')
        except AttributeError:
            pass

        if salt.utils.url.validate(path, ['', 'file']):
            url = urlparse(path)
            return not self.is_cache_path(path) and os.path.isabs(url.path)

        return False

    def local_path(self, path, saltenv=None):
        '''
        local_path: '/srv/formulas/base/topd-formula/topd/init.sls'
                    'file:///srv/formulas/base/topd-formula/topd/init.sls'

        :param path:
        :param saltenv:
        '''
        if isinstance(path, list):
            return [self.local_path(p, saltenv) for p in path]

        try:
            if self.is_local_path(self.get(path, 'abspath')):
                return self.get(path, 'abspath')
            return ''

        except AttributeError:
            if self.is_local_path(path):
                return path

            saltenv = saltenv or self.saltenv(path, saltenv)
            relpath = self.relpath(path, saltenv)

            files = self.find(relpath=relpath, saltenv=saltenv)

            abspaths = list(map(lambda s: self.get(s, 'abspath'), files))
            for abspath in abspaths:
                if not self.is_cache_path(abspath):
                    return abspath
            return ''

    def is_slspath(self, path, saltenv=None):
        '''
        slspath: 'topd'

        :param path:
        :param saltenv:
        '''
        return bool(
            set(
                filter(
                    lambda x: x == path, chain.from_iterable(
                        self.states(saltenv).values()
                    )
                )
            )
        )

    def slspath(self, path, saltenv=None):
        '''
        slspath: 'topd'

        :param path:
        :param saltenv:
        '''
        if isinstance(path, list):
            return [self.slspath(p, saltenv) for p in path]
        try:
            saltenv = self.get(path, 'saltenv')
            relpath = self.get(path, 'relpath')

        except AttributeError:
            saltenv = saltenv or self.saltenv(path, saltenv)
            relpath = self.relpath(path, saltenv)

        if not relpath:
            return ''

        sls = relpath.lower().split('/init.sls')[0]  # pylint: disable=E1101
        sls = os.path.splitext(sls)[0].replace('/', '.')

        if self.is_slspath(sls, saltenv):
            return sls

        return ''

    def file_root(self, path, saltenv=None):
        '''
        Return the file_root for a given path.

        :param path:
        :param saltenv:
        '''
        if isinstance(path, list):
            return [self.file_root(p, saltenv) for p in path]

        try:
            return self.get(path, 'root')
        except AttributeError:
            pass

        saltenv = saltenv or self.saltenv(path, saltenv)
        relpath = self.relpath(path, saltenv)

        files = self.find(relpath=relpath, saltenv=saltenv)
        roots = set(map(lambda s: s.file_root, files))
        return sorted(roots)


def pathutils(opts, *varargs, **kwargs):
    return PathUtils(opts, *varargs, **kwargs)
