FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://bootdelay.cfg"

UBOOT_CONFIG_FRAGMENT = "bootdelay.cfg"
