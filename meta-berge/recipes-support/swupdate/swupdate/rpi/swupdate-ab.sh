#!/bin/sh

rootfs=$(swupdate -g)
if [ "$rootfs" = "/dev/mmcblk0p2" ]; then
    selection="-e stable,copy2"
else
    selection="-e stable,copy1"
fi

if [ -e /media/etc/swupdate.cfg ]; then
    CFGFILE="/media/etc/swupdate.cfg"
else
    CFGFILE="/etc/swupdate.cfg"
fi

# Web UI only — no Suricatta
exec /usr/bin/swupdate -v -H raspberrypi5:1.0 $selection -p 'sync && reboot -f' -f "$CFGFILE" -w "-r /www -p 8080"
