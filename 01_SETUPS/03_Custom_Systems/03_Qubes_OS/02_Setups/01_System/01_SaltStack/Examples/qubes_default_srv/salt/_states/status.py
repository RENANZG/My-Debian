# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:platform:      all

==========================
Qubes misc state functions
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
    return True


def _state_action(_action, *varargs, **kwargs):
    '''
    '''
    try:
        status = __salt__[_action](*varargs, **kwargs)

    except (SaltInvocationError, CommandExecutionError) as e:
        status = Status(retcode=1, result=False, comment=e.message + '\n')

    return vars(status)


def create(name, comment, result=None):
    '''
    Used to show an alert message when a condition is met not to include a
    state.

    :param name:
    :param comment:
    :param result:
    '''
    return dict(Status(name=name, result=result, comment=comment))
