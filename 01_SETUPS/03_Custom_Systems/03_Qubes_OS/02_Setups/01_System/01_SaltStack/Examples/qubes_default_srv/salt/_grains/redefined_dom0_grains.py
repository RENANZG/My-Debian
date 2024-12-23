# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :

from __future__ import absolute_import

import salt.config
import salt.grains.core

__opts__ = salt.config.minion_config('/etc/salt/minion')
salt.grains.core.__opts__ = __opts__


def qubes_dom0():
    '''
    Redefine qubes grains.
    '''
    grains = {}
    if salt.grains.core.os_data()['os'] in ('Qubes', 'Qubes OS'):
        grains = {'virtual': 'Qubes', 'os': 'Fedora', 'os_family': 'RedHat'}
    return grains
