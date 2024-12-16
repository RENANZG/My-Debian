# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# WIP: Not Implemented
#      (Manually added in mgmt-salt-base-config/pillar/config/init.sls)
#

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 
# config.sls
# ==========
#
# Topd configuration path locations
#
# Extra configuration to be added by the config module to Salt's configuration
# file located at:
#   /etc/salt/minion.d/f_defaults.conf
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 

salt-modules:
  topd:
    topd_dir_name: _tops
    topd_base_pillar: /srv/pillar
    topd_base_state: /srv/salt
