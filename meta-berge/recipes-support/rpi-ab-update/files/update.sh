#!/bin/sh

[ $# -lt 1 ] && exit 0;

# Parse arguments KEY=VALUE
for ARGUMENT in "$@"; do
   KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
   VALUE=$(echo "$ARGUMENT" | cut -f2 -d=)
   export "$KEY"="$VALUE"
done

get_slot() {
    for i in $(cat /proc/cmdline); do
        if [[ $i == bootslot=* ]]; then
            CURRENT_SLOT="${i: -1}"
        fi
    done
    if [ "$CURRENT_SLOT" = "0" ]; then
        UPDATE_SLOT="1"
    else
        UPDATE_SLOT="0"
    fi
}

if [ "$1" = "preinst" ]; then
    get_slot

    mkdir -p /tmp/storage /tmp/update_boot /tmp/update_bsp

    mount /dev/disk/by-label/storage /tmp/storage || exit 1
    mount /dev/disk/by-label/boot /tmp/update_boot || exit 1

    ln -sfT "/tmp/storage/bsp/${UPDATE_SLOT}" /tmp/update_bsp
    rm -rf /tmp/update_bsp/*
    mkdir -p /tmp/update_bsp/mounts

    rm -rf /tmp/storage/overlay/*

    ln -sfT "/tmp/update_boot/bsp${UPDATE_SLOT}/" /tmp/update_boot_dir
    rm -rf /tmp/update_boot_dir/*

elif [ "$1" = "postinst" ]; then
    get_slot

    echo "$UPDATE_SLOT" > /tmp/update_boot/slot$UPDATE_SLOT
    if which fw_setenv >/dev/null 2>&1; then
        fw_setenv bootslot $UPDATE_SLOT
        fw_setenv fdt_file default.dtb
    fi

    if [ -n "$DEFAULT_DTB" ]; then
        ln -sfT "bsp${UPDATE_SLOT}/devicetree/${DEFAULT_DTB}" /tmp/update_boot/devicetree/default.dtb || \
            cp -f "/tmp/update_boot_dir/devicetree/${DEFAULT_DTB}" /tmp/update_boot_dir/devicetree/default.dtb
        ln -sfT "bsp${UPDATE_SLOT}/boot.scr" /tmp/update_boot/boot.scr
    fi
fi
