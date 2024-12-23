# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       none
:platform:      all

'''

from __future__ import absolute_import

# Import python libs
import logging
import os

# Import salt libs
from salt.utils.odict import OrderedDict

# Import custom libs
import matcher
import fileinfo

# Enable logging
log = logging.getLogger(__name__)

try:
    __context__['salt.loaded.ext.util.pathinfo'] = True
except NameError:
    __context__ = {}

PATHINFO_FIELDS = (
    'saltenv', 'file_root', 'cache_root', 'abspath', 'relpath', 'is_pillar'
)

# Define the module's virtual name
__virtualname__ = 'pathinfo'


def __virtual__():
    '''
    '''
    return __virtualname__


class PathInfo(fileinfo.FileInfo):
    def __init__(self, fields=None, match_each=True, **patterns):
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
        super(PathInfo, self).__init__(
            fields=PATHINFO_FIELDS,
            match_each=match_each,
            **patterns
        )

    def element(self, root=None, abspath=None, **kwargs):
        '''
        This method must return a valid empty object if no vars are passed
        to allow introspection to create patterns.

        :param root:
        :param abspath:

        kwargs contain extra information for custom methods.
        '''
        if root is None and abspath is None:
            root = os.path.abspath('.')
            abspath = os.path.abspath('.')
        relpath = os.path.relpath(abspath, root)

        cachedir = kwargs.get('cachedir', '')
        if cachedir and os.path.commonprefix([abspath, cachedir]) == cachedir:
            file_root = ''
            cache_root = root
        else:
            file_root = root
            cache_root = ''

        # ('saltenv','file_root','cache_root','abspath','relpath','is_pillar')
        element = self.Info(
            saltenv=kwargs.get('saltenv', 'base'),
            file_root=file_root,
            cache_root=cache_root,
            abspath=abspath,
            relpath=relpath,
            is_pillar=kwargs.get('is_pillar', False),
        )

        return element

    def add_element(self, element, **kwargs):
        self._elements.add(element)

    def filelist(self, roots, **kwargs):
        '''
        :param roots:
            file_roots, pillar_roots, cache_roots, etc to walk.

        kwargs:
            Contains any extra variables to pass to element.

        '''
        for env, destdirs in roots.items():
            kwargs['saltenv'] = env
            super(PathInfo, self).filelist(destdirs, **kwargs)

        return self.as_sequence


class PathInfoDict(fileinfo.FileInfo):
    def __init__(self, match_each=True, **patterns):
        '''
        match_each:
            If True, each file path is matched which prevents uses less memory
            but sacrifices performance a little bit.  If False, the complete
            list is matched after all the file information has been added to
            pathinfo.

        patterns:
            Contains the patterns to match.
            Example:
                { 'saltenv': 'base', 'relpath': ['*.sls'] }
        '''
        super(PathInfoDict, self).__init__(
            fields=PATHINFO_FIELDS,
            match_each=match_each,
            **patterns
        )
        self._elements = OrderedDict()

    @property
    def as_sequence(self):
        if self.pattern and not self.match_each:
            return list(
                matcher.ifilter(
                    self._elements.values(),
                    _pattern=self.pattern
                )
            )
        return self._elements.values()

    def element(self, root=None, abspath=None, **kwargs):
        '''
        kwargs contain extra information for custom methods.

        This method must return a valid empty object if no vars are passed
        to allow introspection to create patterns.

        :param root:
        :param abspath:
        '''
        if root is None and abspath is None:
            root = os.path.abspath('.')
            abspath = os.path.abspath('.')
        relpath = os.path.relpath(abspath, root)

        try:
            element = self._elements.get(relpath, OrderedDict())
        except AttributeError:
            element = OrderedDict()

        if not element:
            for field in PATHINFO_FIELDS:
                element.setdefault(field, '')
            element['saltenv'] = kwargs.get('saltenv', 'base')
            element['relpath'] = relpath
            element['abspath'] = abspath
            element['is_pillar'] = kwargs.get('is_pillar', False)

        cachedir = kwargs.get('cachedir', '')
        if cachedir and os.path.commonprefix([abspath, cachedir]) == cachedir:
            element['cache_root'] = root
        else:
            element['file_root'] = root

        element_hook = kwargs.get('_element_hook', None)
        if element_hook:
            element = element_hook(self, element, **kwargs)

        return element

    def add_element(self, element, **kwargs):
        add_hook = kwargs.get('_add_hook', None)
        if add_hook:
            element = add_hook(self, element, **kwargs)

        if element['relpath'] not in self._elements:
            self._elements[element['relpath']] = element

    def filelist(self, roots, **kwargs):
        '''
        :param roots:
            file_roots, pillar_roots, cache_roots, etc to walk.

        kwargs:
            Contains any extra variables to pass to element.

        '''
        for env, destdirs in roots.items():
            kwargs['saltenv'] = env
            super(PathInfoDict, self).filelist(destdirs, **kwargs)

        return self.as_sequence
