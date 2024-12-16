# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :

from __future__ import absolute_import

import salt.config
import salt.grains.core

__opts__ = salt.config.minion_config('/etc/salt/minion')
salt.grains.core.__opts__ = __opts__


def whonix():
    '''
    Redefine whonix grains.
    '''
    grains = {}
    if salt.grains.core.os_data()['os'] == 'Whonix':
        grains = {
            'virtual': 'Qubes+Whonix',
            'os': 'Debian',
            'os_family': 'Debian'
        }
    return grains
