#!yamlscript
# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qubes-dom0-updae.tests
# ======================
#
# Qubes state, and module tests
#
# Execute:
#   qubesctl state.sls qubes-dom0-updae.tests
##


$python: |
    tests = [
        'qubes-dom0-update',
    ]


#===============================================================================
# Test qubes-dom0-update                                       qubes-dom0-update
#===============================================================================
$if 'qubes-dom0-update' in tests:
  git:
    pkg.installed:
      - name: git
