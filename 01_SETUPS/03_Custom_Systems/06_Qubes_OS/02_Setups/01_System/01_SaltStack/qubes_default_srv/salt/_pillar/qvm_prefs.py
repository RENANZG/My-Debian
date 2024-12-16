#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# The Qubes OS Project, http://www.qubes-os.org
#
# Copyright (C) 2016  Marek Marczykowski-Górecki
#                                   <marmarek@invisiblethingslab.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
# USA.

admin_available = True
try:
    import qubesadmin
    import qubesadmin.vm
except ImportError:
    admin_available = False


def __virtual__():
    return admin_available


def ext_pillar(minion_id, pillar, *args, **kwargs):
    app = qubesadmin.Qubes()
    try:
        vm = app.domains[minion_id]
    except KeyError:
        return {}

    qvm_pillar = {}
    if vm.qid == 0:
        qvm_pillar['type'] = 'admin'
    elif vm.klass == 'TemplateVM':
        qvm_pillar['type'] = 'template'
    elif vm.klass == 'StandaloneVM':
        qvm_pillar['type'] = 'standalone'
    else:
        qvm_pillar['type'] = 'app'

    if hasattr(vm, 'template'):
        qvm_pillar['template'] = vm.template.name

    if hasattr(vm, 'netvm'):
        qvm_pillar['netvm'] = str(vm.netvm)

    # TODO: consider other properties; target VM will learn them!

    return {'qubes': qvm_pillar}
