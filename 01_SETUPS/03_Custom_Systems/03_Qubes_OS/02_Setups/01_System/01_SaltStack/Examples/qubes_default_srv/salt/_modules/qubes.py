# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       none
:platform:      all

=====================
Misc Helper Functions
=====================
'''

from __future__ import absolute_import

# Import python libs
import collections
import logging

# Enable logging
log = logging.getLogger(__name__)


def merge(target, source, create=False, allowed=None, append=False):
    '''
    Merges the values of a nested dictionary of varying depth without over-
    writing the targets root nodes.

    :param target:
        Target dictionary to update.

    :param source:
        Source dictionary that will be used to update `target`.

    :param create:
        If True then new keys can be created during update, otherwise they will
        be tossed if they do not exist in `target`.

    :param allowed:
        List of allowed keys that can be created even if create is False.

    :param append: [True] or ['list_of_keys', 'key4']
        Appends to strings or lists if append is True or key in list.
    '''
    if not allowed:
        allowed = []

    for key, value in source.items():
        if isinstance(value, collections.Mapping):
            if key in target.keys() or create or key in allowed:
                replace = merge(
                    target.get(key, {}),
                    value,
                    create=create,
                    allowed=allowed,
                    append=append
                )
                target[key] = replace

        else:
            if key in target.keys() or create or key in allowed:
                if append and (append is True or key in append):
                    if isinstance(source[key], str) and isinstance(
                        target.get(key, ''), str
                    ):
                        target.setdefault(key, '')
                        target[key] += source[key]

                    elif isinstance(source[key], list) and isinstance(
                        target.get(key, []), list
                    ):
                        target.setdefault(key, [])
                        target[key].extend(source[key])

                    else:
                        target[key] = source[key]

                else:
                    target[key] = source[key]
    return target
