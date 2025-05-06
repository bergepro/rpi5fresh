SUMMARY = "U-Boot boot script for squashfs A/B"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "raspberrypi5"

DEPENDS = "u-boot-mkimage-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://boot.cmd"

S = "${WORKDIR}"

inherit deploy

do_compile() {
    mkimage -C none -A arm -T script -d "${WORKDIR}/boot.cmd" boot-ab.scr
}

do_install() {
    install -d ${D}${datadir}/boot-script
    install -m 0644 boot-ab.scr ${D}${datadir}/boot-script/
}

FILES:${PN} = "${datadir}/boot-script"
