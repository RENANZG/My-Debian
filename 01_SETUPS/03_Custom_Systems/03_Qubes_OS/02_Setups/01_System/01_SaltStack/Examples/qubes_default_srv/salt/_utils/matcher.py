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
import collections.abc
import functools
import logging
import operator
import re

from itertools import (chain, compress, )  # pylint: disable=E0598

# Import salt libs
from salt.utils.odict import OrderedDict

# Enable logging
log = logging.getLogger(__name__)

try:
    __context__['salt.loaded.ext.util.matcher'] = True
except NameError:
    __context__ = {}

# Define the module's virtual name
__virtualname__ = 'matcher'

DEFAULT_PATTERN = [r'.*']


def __virtual__():
    '''
    '''
    return __virtualname__


class Regex(str):
    '''
    Wrapper to be able to identify regex expressions
    '''
    pass


def getter(index, element, *ignored):  # pylint: disable=W0613
    if isinstance(element, collections.abc.Mapping):
        getter_ = operator.itemgetter
    else:
        getter_ = operator.attrgetter

    if not index:
        return lambda x: ()
    if isinstance(index, list):
        return getter_(*index)
    else:
        return getter_(index)


def extract_labels(element=None, *ignored):  # pylint: disable=W0613
    '''
    Return an element's labels.

    Uses dictionary keys for a dictionary, _fields for a namedtuple and
    index number for list or regular tuple.

    Args:
        element:
    '''
    if not element:
        return []

    try:
        # OrderedDict
        return element.keys()
    except AttributeError:
        try:
            # namedtuple
            return element._fields
        except AttributeError:
            pass

    return element


def generate_selectors(labels=None, *fields, **kwargs):
    '''
    Create an element list based in another objects labels that will create
    a value of True in the corresponding element if in either selectors
    or kwargs, otherwise False.

    Args:
        labels:

    Example:
        >>> labels = ['one', 'two', 'three', 'four']
        >>> fields = ['two', 'three']
        >>> generate_selectors(labels, fields)
        [False, True, True, False]
    '''
    if not labels:
        return []

    enabled = True if 'all' in fields or 'all' in kwargs else False
    selectors = [enabled for i in range(len(labels))]  # pylint: disable=W0612

    if enabled:
        return selectors

    for index, selector in enumerate(labels):
        if selector in fields or selector in kwargs:
            selectors[index] = True
    return selectors


def translate(pattern):
    '''
    Translate a shell PATTERN to a regular expression. Based on
    'fnmatch.translate'.

    Args:
        pattern:

    Note:
        There is no way to quote meta-characters.
    '''
    i, n = 0, len(pattern)
    res = ''
    while i < n:
        c = pattern[i]
        i += 1
        if c == '*':
            res += '.*'
        elif c == '?':
            res += '.'
        elif c == '[':
            j = i
            if j < n and pattern[j] == '!':
                j += 1
            if j < n and pattern[j] == ']':
                j += 1
            while j < n and pattern[j] != ']':
                j += 1
            if j >= n:
                res += '\\['
            else:
                stuff = pattern[i:j].replace('\\', '\\\\')
                i = j + 1
                if stuff[0] == '!':
                    stuff = '^' + stuff[1:]
                elif stuff[0] == '^':
                    stuff = '\\' + stuff
                res = '{0}[{1}]'.format(res, stuff)
        else:
            res = res + re.escape(c)
    return res


def escape_text(text, regex=False):
    '''
    Escape text for regex pattern match.

    Args:
        text:
        regex:
    '''
    # Don't escape regex strings as they are assumed to be proper syntax
    if isinstance(text, Regex):
        return text

    elif regex:
        return re.escape(text)

    return translate(text)


def get_default_pattern(regex):  # pylint: disable=W0613
    return DEFAULT_PATTERN


def compile(labels, **patterns):  # pylint: disable=W0622
    '''
    Compile patterns.

    Args:
        labels:
    '''
    pattern = patterns.pop('_pattern', None)
    if pattern:
        return pattern

    regex = patterns.pop('_regex', False)
    escape = patterns.pop('_escape', [])

    if not patterns or not labels:
        return None

    for pattern in list(patterns.keys()):
        if pattern not in labels:
            patterns.pop(pattern)

    default_pattern = get_default_pattern(regex)
    escape = escape if escape else []
    _escape_text = functools.partial(escape_text, regex=regex)

    # Set default values and join patterns for each field
    pattern = OrderedDict.fromkeys(labels, None)
    for label in labels:
        if label in patterns and patterns[label]:
            field = patterns[label]
            if isinstance(field, re.Pattern):  # pylint: disable=W0212
                field = [field.pattern]
            if isinstance(field, str):
                field = [field]
            if label in escape or not regex:
                field = [_escape_text(text) for text in field]
        else:
            field = default_pattern
        pattern[label] = r'(?:{0})'.format(r'|'.join(field))

    try:
        return re.compile(
            r'\n'.join(pattern.values()), re.MULTILINE | re.DOTALL
        )
    except NameError:
        raise


def itext(element):
    '''
    Converts element to a text string suitable for regex parsing.

    Args:
        element:
    '''
    # Dictionary
    if isinstance(element, collections.abc.Mapping):
        return '\n'.join(map(str, element.values()))

    # Tuple / list
    else:
        return '\n'.join(map(str, element))


def match(sequence, pattern):
    '''
    Regex match.

    Args:
        sequence:
            Either a string, list of strings or list of lists / tuples

        pattern:
    '''
    if not pattern:
        return chain(sequence)

    # Match to text string created from element
    return map(pattern.match, map(itext, sequence))


def get_pattern(sequence=None, *ignored, **patterns):  # pylint: disable=W0613
    if '_pattern' in patterns:
        return patterns['_pattern']
    labels = extract_labels(sequence)
    return compile(labels, **patterns)


def ifilter(sequence, **patterns):
    pattern = get_pattern(*sequence, **patterns)
    return compress(sequence, match(sequence, pattern))


def filter(sequence, **patterns):  # pylint: disable=W0622
    return list(ifilter(sequence, **patterns))
