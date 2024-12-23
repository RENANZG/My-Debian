# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:platform:      all

==========================
Qubes test state functions
==========================
'''

from __future__ import absolute_import

# Import python libs
import logging

# Salt libs
from salt.exceptions import (CommandExecutionError, SaltInvocationError)

# Salt + Qubes libs
from qubes_utils import Status  # pylint: disable=E0401

log = logging.getLogger(__name__)


def __virtual__():
    '''
    '''
    return 'debug.mode' in __salt__


def _state_action(_action, *varargs, **kwargs):
    '''
    '''
    try:
        status = __salt__[_action](*varargs, **kwargs)

    except (SaltInvocationError, CommandExecutionError) as e:
        status = Status(retcode=1, stderr=e.message + '\n')

    return vars(status)


def mode(name, *varargs, **kwargs):
    '''
    Sets debug mode for all or specific states status.

    :param name:
    '''
    return _state_action('debug.mode', name, *varargs, **kwargs)
