# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :

from __future__ import print_function
import subprocess
import re

# Import salt libs
import salt.config
import salt.grains.core
import salt.utils


# Handle legacy salt 2017.7.1
try:
    from salt.utils.path import which as _which
except ImportError:
    from salt.utils import which as _which

__opts__ = salt.config.minion_config('/etc/salt/minion')
salt.grains.core.__opts__ = __opts__


def pci_devs():
    '''
    Useful PCI devices lists.
    '''

    def find_devices_of_class(klass):
        lspci = _which('lspci')

        if lspci:
            p = subprocess.Popen([lspci, "-mm", "-n"], stdout=subprocess.PIPE)
            result = p.communicate()
            retcode = p.returncode

            if retcode != 0:
                print("ERROR when executing lspci!")
                raise IOError

            rx_netdev = re.compile(
                r"^([0-9a-f]{2}:[0-9a-f]{2}.[0-9a-f]) \"" + klass
            )

            for dev in str(result[0].decode()).splitlines():
                match = rx_netdev.match(dev)
                if match is not None:
                    dev_bdf = match.group(1)
                    assert dev_bdf is not None
                    yield dev_bdf

    grains = {
        'pci_net_devs': list(find_devices_of_class("02")),
        'pci_usb_devs': list(find_devices_of_class("0c03")),
        'pci_audio_devs': list(find_devices_of_class("0403")),
    }

    return grains
