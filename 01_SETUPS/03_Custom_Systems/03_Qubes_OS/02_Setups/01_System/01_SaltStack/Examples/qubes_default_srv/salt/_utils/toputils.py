# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       none
:platform:      all

Salt file path utilities for managing top configurations.

*** WORK IN PROGRESS ***

=====
TODO:
=====

masked values (/dev/null) could fail the virtual()
  - Not sure how to handle that; monkey patch? or add into the section
    where the modules initially loads

enabled; disabled should be same as is_enabled; IE only print status
                  - Use reporting / status  for path details or provide
                    options for more detail

symlinks = client.symlink_list(saltenv='base',  prefix='')
enabled = top in symlinks
'''

from __future__ import absolute_import

# Import python libs
import collections
import itertools
import logging
import os
import re

from itertools import (chain, )

# Import salt libs
from salt.exceptions import SaltRenderError
from salt.utils.odict import (OrderedDict, DefaultOrderedDict)
from salt.utils.jinja import PrintableDict

# Import custom libs
import matcher
import fileinfo

from pathutils import PathUtils
from pathinfo import PathInfo

# Enable logging
log = logging.getLogger(__name__)

try:
    __context__['salt.loaded.ext.util.toputils'] = True
except NameError:
    __context__ = {}

# Define the module's virtual name
__virtualname__ = 'toputils'

TOPINFO_FIELDS = (
    'saltenv', 'file_root', 'cache_root', 'abspath', 'relpath', 'is_pillar',
    'toppath', 'realpath'
)


def __virtual__():
    '''
    '''
    return __virtualname__


def coerce_to_list(value):
    '''Converts value to a list.

    :param value:
    '''
    if not value:
        value = []

    elif isinstance(value, str):
        value = [value, ]

    elif isinstance(value, tuple):
        value = list(value)

    return value


class TopInfo(PathInfo):
    def __init__(self, parent, match_each=True, **patterns):
        '''
        match_each:
            If True, each file path is matched which prevents uses less memory
            but sacrifices performance a little bit.  If False, the complete
            list is matched after all the file information has been added to
            pathinfo

        patterns:
            Contains the patterns to match.
            Example:
                { 'saltenv': 'base', 'relpath': ['*.sls'] }
        '''
        super(TopInfo, self).__init__(match_each=match_each, **patterns)
        self.parent = parent
        self.TopInfo = collections.namedtuple('Info', TOPINFO_FIELDS)

    def topinfo_element(self, element, **kwargs):  # pylint: disable=W0613
        '''
        Check to see if element is a top file and re-create element if saltenv
        is incorrect.

        This is done here instead of when initially creating the element so
        this regex match would not need to happen on every file; only matched
        ones.

        :param element:

        kwargs will swallow any extra args.
        '''
        # TODO: Gid rid of requiring parent
        pattern = self.parent.pattern_all
        element = element._asdict()

        relpath = element['relpath']
        match = pattern.match(relpath)
        if match:
            info = match.groupdict()
            if element['saltenv'] != info['saltenv']:
                element['saltenv'] = info['saltenv']

        element['toppath'] = self.parent.toppath(element, verify=False)

        if os.path.islink(element['abspath']):
            element['realpath'] = os.path.realpath(element['abspath'])
        else:
            element['realpath'] = ''

        return self.TopInfo(**element)

    def add_element(self, element, **kwargs):
        element = self.topinfo_element(element, **kwargs)
        self._elements.add(element)


class TopUtils(PathUtils):
    '''
    List status of one or all top files.  If saltenv is not provided, all
    environments will be searched
    '''

    def __init__(self, opts, pillar=False, **kwargs):
        super(TopUtils, self).__init__(opts=opts, pillar=pillar, **kwargs)

        topd_dir = None
        if kwargs.get('topd_dir', None):
            pathutils = PathUtils(opts, pillar=pillar)
            topd_dir = pathutils.relpath(
                kwargs['topd_dir'], kwargs.get('saltenv', 'base')
            )
        self.topd_directory = str(
            topd_dir or self.opts.get(
                u'topd_dir', u'_tops'
            )
        )
        self.verbose = kwargs.get('verbose', False)

        if pillar:
            self.topd_base = self.opts.get(u'topd_base_pillar', u'/srv/pillar')
            include = ['pillar_roots']

        else:
            self.topd_base = self.opts.get(u'topd_base_state', u'/srv/salt')
            include = ['file_roots']

        # All enabled tops pattern
        self.pattern_enable = re.compile(
            r'{0}{1}*.top'.format(
                os.path.join(self.topd_base, self.topd_directory), os.sep
            )
        )

        # All tops pattern
        self.pattern_all = re.compile(
            matcher.Regex(
                r'''(?ix)
            (?P<dir> .*? )
            (?P<saltenv> {0} )
            (?P<sep> [{1}] | [|] )
            (?P<top>.*(?=[.]top$)|.*)
            (?P<ext>[.]top|)
            '''.format('|'.join(self.saltenvs()), os.sep)
            )
        )

        self._topinfo_roots = self.pathinfo_roots(include=include)
        self._toplist = self.files()
        self._tops = self.tops()

    def tops(self, saltenv=None):
        '''
        Return a list of tops files in the specified environment or a dictionary
        of all results if saltenv is None.

        :param saltenv:
        '''
        # Only return SALTENV if provided, otherwise ALL
        try:
            if saltenv:
                return {saltenv: self._tops[saltenv]}
            return self._tops
        except AttributeError:
            pass

        tops = DefaultOrderedDict(list)
        toplist = self.files(saltenv=saltenv)

        for info in toplist:
            toppath = self.toppath(info, verify=False)
            tops[self.get(info, 'saltenv')].append(toppath)

        if saltenv:
            return {saltenv: tops[saltenv]}

        return tops

    def path_type(self, path, saltenv=None):
        '''
        Return path type.

        :param path:
        :param saltenv:
        '''
        if self.is_toppath(path, saltenv):
            return 'toppath'

        return super(TopUtils, self).path_type(path, saltenv)

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

        path_type = path_type or self.path_type(path, saltenv)

        # XXX: Grabs 1st entry.  Maybe need more logic
        if path_type in ['toppath']:
            tops = self.files(saltenv=saltenv, toppath=path)
            try:
                topinfo = next(iter(tops))
                relpath = matcher.getter('relpath', topinfo)
                return relpath(topinfo)

            except StopIteration:
                return ''

        return super(TopUtils, self).path(path, saltenv, path_type=path_type)

    def is_relpath(self, path, saltenv=None):
        '''
        path:      'topd/init.sls'
        relpath:   'topd/init.sls'

        :param path:
        :param saltenv:
        '''
        try:
            if path.endswith('.top'):
                return False

        except AttributeError:
            pass

        return super(TopUtils, self).is_relpath(path, saltenv)

    def is_toppath(self, path, saltenv=None):
        '''
        toppath: 'salt'        (relpath: salt/init.top)
        toppath: 'salt.minion' (relpath: salt/minion.top)
        toppath: 'salt.minion' (relpath: topd/base|salt.minion)

        :param path:
        :param saltenv:
        '''
        return bool(
            set(
                filter(
                    lambda x: x == path, chain.from_iterable(
                        self.tops(saltenv).values()
                    )
                )
            )
        )

    def toppath(self, path, saltenv=None, verify=True):
        '''
        toppath: 'salt'        (relpath: salt/init.top)
        toppath: 'salt.minion' (relpath: salt/minion.top)
        toppath: 'salt.minion' (relpath: topd/base|salt.minion)

        :param path:
        :param saltenv:
        :param verify:
        '''
        if isinstance(path, list):
            return [self.toppath(p, saltenv) for p in path]

        try:
            saltenv = self.get(path, 'saltenv')
            relpath = self.get(path, 'relpath')

        except AttributeError:
            if not path.endswith('.top'):
                path += '.top'

            if self.is_toppath(path, saltenv):
                return path
            saltenv = saltenv or self.saltenv(path, saltenv)

            try:
                relpath = self.relpath(path, saltenv)
            except SaltRenderError:
                return ''

        if relpath.startswith(self.topd_directory):  # pylint: disable=E1101
            relpath = relpath.split(self.topd_directory + os.sep)[
                1
            ]  # pylint: disable=E1101

        match = self.pattern_all.match(relpath)
        if match:
            info = match.groupdict()
            relpath = info['top'] + info['ext']

        top = relpath.lower().split('/init.top')[0]  # pylint: disable=E1101
        top = os.path.splitext(top)[0].replace('/', '.')
        top += '.top'

        if not verify or self.is_toppath(top, saltenv):
            return top

        return ''

    def files(
        self,
        saltenv=None,
        roots=None,
        files=None,
        view=None,
        flat=None,
        force=False,
        **patterns
    ):
        '''
        Return a list of top files in the specified environment or a dictionary
        of all results if saltenv is None matching the given patterns.

        :type saltenv: str
        :type patterns: [str]
        :type flat: [str]
        :rtype : [str] | {str: [str]}

        :param saltenv:
            Can be a single saltenv such as 'base', a list of saltenv's such
            as ['base', 'all'], or None in which case all saltenv's will be
            set.

        :param roots:
        :param files:
        :param view:

        :param patterns:
            Patterns of files to search for. Defaults to ["*"].

            Example: ["*.top", "*.sls"]

        :param flat:
            If True, a list of all environment values will be returned,
            otherwise a dictionary with the passed saltenv will be returned.

            The default for a single salt environment is to flatten

        :param force:
        '''
        # Reset cache
        if force:
            self._toplist = None

        try:
            files = files or self._toplist
        except AttributeError:
            pass

        if files:
            if saltenv:
                patterns['saltenv'] = saltenv
            return self.find(files, **patterns)

        roots = roots or self._topinfo_roots

        # TODO:
        #   - Consider ALWAYS returning 'raw'
        #   - Same for ALL methods; so remove that feature from ALL methods
        #     and have display methods like status and report handle views
        view = view if view else 'raw'
        default_pattern = {'relpath': ['*.top'], }

        # Compress patterns values to make sure all patterns have values,
        # otherwise use default_pattern
        if not list(
            itertools.compress(
                patterns.values(), patterns.values(
                )
            )
        ):  # pylint: disable=E0598
            patterns = default_pattern

        topinfo = TopInfo(parent=self, match_each=True, **patterns)

        self._toplist = super(TopUtils, self).files(
            saltenv=saltenv,
            roots=roots,
            view=view,
            flat=flat,
            pathinfo=topinfo,
            **patterns
        )

        return self._toplist

    def prepare_paths(self, paths):
        seen = set()
        unseen = set()

        if not paths:
            unseen.add('No top files provided')
        else:
            for path in paths:
                toppath = self.toppath(path)
                if toppath:
                    seen.add(toppath)
                else:
                    unseen.add(path)

        return list(seen), list(unseen)

    def include_links(self, tops):
        includes = []
        try:
            top = next(iter(tops))
            saltenv = matcher.getter('saltenv', top)
            abspath = matcher.getter('abspath', top)

        except StopIteration:
            return includes

        for topinfo in tops:
            if os.path.islink(abspath(topinfo)):
                realpath = os.path.realpath(abspath(topinfo))
                includes.extend(
                    self.files(
                        saltenv=saltenv(topinfo),
                        abspath=realpath
                    )
                )

        return includes

    def is_enabled(self, paths=None, saltenv=None):
        '''
        :param paths:
        :param saltenv:
        '''
        tops = self.files(saltenv, view='raw')
        enabled = self.enabled(paths, saltenv, files=tops, view='raw')
        disabled = self.disabled(paths, saltenv, files=tops, view='raw')
        return self._status(disabled=disabled, enabled=enabled)

    def enabled(
        self,
        paths=None,
        saltenv=None,
        files=None,
        view=None,
        flat=False
    ):
        '''
        :param paths:
        :param saltenv:
        :param files:
        :param view:
        :param flat:
        '''
        # Convert paths to top_paths
        toppaths = self.prepare_paths(paths)[0]

        enabled = self.files(
            saltenv=saltenv,
            files=files,
            view='raw',
            toppath=toppaths,
            abspath=self.pattern_enable
        )

        view = view or ['saltenv', 'abspath']
        return fileinfo.fileinfo_view(enabled, view=view, flat=flat)

    def disabled(
        self,
        paths=None,
        saltenv=None,
        files=None,
        view=None,
        flat=False
    ):
        '''
        :param paths:
        :param saltenv:
        :param files:
        :param view:
        :param flat:
        '''
        # Convert paths to top_paths
        toppaths = self.prepare_paths(paths)[0]

        all_tops = self.files(
            saltenv=saltenv,
            files=files,
            view='raw',
            toppath=toppaths
        )

        # Don't include enabled tops
        enabled = set(
            self.enabled(
                paths=paths,
                saltenv=saltenv,
                files=files,
                view='raw'
            )
        )

        # Don't include tops link target
        enabled.update(set(self.include_links(enabled)))

        disabled = set(all_tops).difference(enabled)
        view = view or ['saltenv', 'abspath']
        return fileinfo.fileinfo_view(list(disabled), view=view, flat=flat)

    def enable(self, paths=None, saltenv='base'):
        '''
        Enable top.

        *** Work in progress ***

        The following are possible top patterns that may exist within the _top
        directory:

        ========================================================================
        Legend
        ========================================================================
        E: Enabled system directory
             - Any top file in a system dir IS enabled AND deletable?
        D: Distribution dir
             - tops or sls files provided by formula author
        A: Admin dir
             - Local administrator OVERRIDES
        R: Removable
        ------------------------------------------------------------------------
        EA  /srv/salt/_tops/<saltenv>/top_name.top.d/filename.conf
        E R /srv/salt/_tops/<saltenv>/top_name.top

        EAR /srv/salt/_tops/<saltenv>|top_name.top.d/filename.conf
        EAR /srv/salt/_tops/<saltenv>|top_name.top

        E R /srv/salt/_tops/top_name.top.d/filename.conf
        EAR /srv/salt/_tops/top_name.top

        D  /srv/salt_or_formula/_tops/top_name.top  -- Dunno if should support
        D  /srv/salt_or_formula/state_dir/top_name.top
        D  /srv/salt_or_formula/state_dir/top_name.sls
        :param paths:
        :param saltenv:
        '''
        results = PrintableDict()
        toppaths, unseen = self.prepare_paths(paths)

        if unseen:
            for path in unseen:
                results['error'] = 'Top path not found: {0}'.format(path)
                log.error(results['error'])

        if not toppaths:
            message = 'No valid top names provided: {0}'.format(paths)
            results['error'] = message
            log.error(results['error'])
            return results

        for toppath in toppaths:
            # All tops filtered by toppaths
            tops = self.files(saltenv=saltenv, view='raw', toppath=toppath)

            # All disabled tops
            disabled = self.disabled(files=tops, view='raw')

            # All enabled tops
            enabled = self.enabled(files=tops, view='raw')

            # XXX: This will change?
            if enabled:
                topinfo = enabled[0]

            elif disabled:
                topinfo = disabled[0]

            else:
                message = 'No valid top names found: {0}'.format(toppath)
                results[toppath] = message
                log.error(results[toppath])
                continue

            topdir = os.path.join(
                self.topd_base, self.topd_directory, topinfo.saltenv
            )

            if not os.path.exists(topdir):
                os.makedirs(topdir)

            message = PrintableDict()
            path = os.path.join(topdir, toppath)
            exists = os.path.exists(path) or os.path.islink(path)

            if topinfo in enabled and os.path.exists(path):
                message['status'] = 'unchanged'

            elif topinfo in enabled and os.path.islink(path):
                realpath = os.path.realpath(path)
                if os.path.islink(path) and not os.path.exists(realpath):
                    message['error'] = 'Broken link!  Disable state to remove.'

            elif topinfo in disabled and not exists:
                os.symlink(topinfo.abspath, path)
                message['status'] = 'enabled'

            else:
                message['error'] = 'Unknown error'

            if self.verbose or 'error' in message:
                message['topdir'] = topdir
                message['toppath'] = toppath
                message['path'] = path
                message['topinfo'] = topinfo
                message['paths'] = paths
                message['saltenv'] = saltenv
                message['toppaths'] = toppaths
                message['unseen'] = unseen
                message['pillar'] = self.pillar
                message['roots'] = self._topinfo_roots

            results[toppath] = message

            if 'error' in message:
                log.error('{0}: {1}'.format(toppath, results[toppath]))

            else:
                log.info('{0}: {1}'.format(toppath, results[toppath]))

        return results

    def disable(self, paths=None, saltenv='base'):
        '''
        :param paths:
        :param saltenv:
        '''
        results = DefaultOrderedDict(list)
        toppaths, unseen = self.prepare_paths(paths)

        if toppaths:
            tops = self.enabled(paths=paths, saltenv=saltenv, view='raw')

            for topinfo in tops:
                if os.path.exists(topinfo.abspath):
                    os.remove(topinfo.abspath)
                    results['disabled'].append(topinfo.toppath)

        if toppaths:
            tops = self.disabled(paths=toppaths, saltenv=saltenv, view='raw')
            for topinfo in tops:
                results['unchanged'].append(topinfo.toppath)
                toppaths.remove(topinfo.toppath)

        if unseen:
            for path in unseen:
                results['error'].append(path)

        return results

    @staticmethod
    def _status(view=None, flat=None, **kwargs):
        view = view or ['saltenv', 'abspath']
        status = {}

        for key, topinfo in kwargs.items():
            if topinfo:
                status[key] = fileinfo.fileinfo_view(
                    topinfo,
                    view=view,
                    flat=flat
                )

        return status

    def _report(self, files=None, saltenv=None, patterns=None):
        if not files:
            saltenvs = self.saltenvs(saltenv)
            files = self.files(saltenvs, view='raw', **patterns)

        report = OrderedDict()

        for pathinfo in files:
            info = self.info(pathinfo)
            info['is_toppath'] = self.is_toppath(pathinfo)
            info['toppath'] = self.toppath(pathinfo)
            report[self.get(pathinfo, 'abspath')] = info

        return report

    # XXX: Signature of method 'TopUtils.report()' does not match signature of
    #      base method in class 'PathUtils'
    def report(self, paths=None, saltenv=None):
        return self._report(files=self.files(saltenv, flat=False))
