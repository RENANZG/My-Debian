#!/bin/bash

#
# Enable cups printers.
# Sometimes for unknown reason cups printers disable themselfs.
# This script finds the disabled printers and re-enables them.
# or run it manualy or setup with the systemd-timers also.
#

# Code checked on Debian Bullseye
# ShellCheck - shell script analysis tool
# version: 0.7.1


# V0.1 d.d 2022-08-11 By LvB initial program setup.
# Todo, add show output of disabled/skipped printers.

### User variables.
# The location where the program is placed.
ENABLE_PRINTERS_FILE="/usr/local/sbin/cups-enable-printers.sh"

# If you want to exclude printers from the output of the program.
# Add there use | as separator. (caps independent)
# By default "idle" as i preffer not to touch working/idle printers.
ENABLE_PRINTER_EXCLUDE="idle"

# info : https://www.freedesktop.org/software/systemd/man/systemd.timer.html
# Enable The timer to run it 'after a reboot and with timer' or do it manualy.
# To enable the systemd config, set to yes.
ENABLE_SYSTEMD_TIMER="no"
# sets : OnBootSec=
CUPS_ENABLE_TIMER_DELAY="5min"
# sets : OnUnitActiveSec
CUPS_ENABLE_TIMER_ACTSEC="300"

# if yes, then the systemd Timer will be setup to run the
# cups-enable-printer.sh at boot after Xmin delay.
if [ "${ENABLE_SYSTEMD_TIMER}" = "yes" ]
then
    if [ ! -f "${ENABLE_PRINTERS_FILE}" ]
    then

        {
        echo "[Unit]
Description = Forcibly enable printer occassionally. Why CUPS disables printers in the first place has yet to be determined.

[Service]
Type = simple
ExecStart = ${ENABLE_PRINTERS_FILE}

[Install]
WantedBy = multi-user.wants"
        } >> /etc/systemd/system/cups.enable.printers.service

    fi

    if [ ! -f /etc/systemd/system/cups.enable.printers.timer ]
    then
        {
        echo "[Unit]
Description=Run enable printers frequently to ensure connection difficulties are remedied.

[Timer]
# Defines a timer relative to when the machine was booted up.
# OnBootSec=5min means 5 minutes after boot-up
OnBootSec=${CUPS_ENABLE_TIMER_DELAY}

# Defines a timer relative to when the unit the timer unit is activating was last activated.
# run/repeat after .. seconds.
OnUnitActiveSec=${CUPS_ENABLE_TIMER_ACTSEC}

[Install]
WantedBy = timers.target"
        } >> /etc/systemd/system/cups.enable.printers.timer

    fi

    echo
    echo "Cups Enable Times setup on systemd"
    echo
    echo "Now run the following commands
    sudo systemctl daemon-reload
    sudo systemctl enable cups.enable.printers.timer
    sudo systemctl start cups.enable.printers.timer
    sudo systemctl restart cups.enable.printers.timer
    systemctl list-timers"
    echo

fi

# Command to enable goes to the pre-set location /usr/local/sbin
if [ ! -f "${ENABLE_PRINTERS_FILE}" ]
then
    {
    echo "#!/bin/bash"
    echo
    echo "## Enable all disabled printer, (* optional with excluded filters if set.)"
    echo "for PRINTERS in \$(lpstat -p|grep -iEv \"${ENABLE_PRINTER_EXCLUDE}\"|awk '{print \$2}')"
    echo "do"
    echo "    echo \"(Re-)enabling printer: \${PRINTERS}\""
    echo "    cupsenable \"\${PRINTERS}\""
    echo
    echo "done"
    } >> "${ENABLE_PRINTERS_FILE}"

    # set execute rights.
    chmod +x "${ENABLE_PRINTERS_FILE}"

    # run it. *( enable if you like)
    echo "Test the output with : lpstat -p"
    echo "and run the program. : ${ENABLE_PRINTERS_FILE}"

fi
