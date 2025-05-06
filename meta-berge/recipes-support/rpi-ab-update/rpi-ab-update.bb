SUMMARY = "Raspberry Pi A/B update script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://update.sh"
S = "${WORKDIR}"

do_install() {
    install -Dm0755 ${WORKDIR}/update.sh ${D}${sbindir}/update.sh
}

FILES:${PN} += "${sbindir}/update.sh"
