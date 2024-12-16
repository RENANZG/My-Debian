# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :

import os

def boot_mode():
    '''
    Boot mode ('efi' or 'legacy').
    '''

    if os.path.exists('/sys/firmware/efi'):
        return { 'boot_mode': 'efi' }
    else:
        return { 'boot_mode': 'legacy' }
