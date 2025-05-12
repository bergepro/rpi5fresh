SUMMARY = "One-shot service to clear U-Boot recovery_success flag"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f38b4f608a3a50c10170d5b5ce9f9c73"
RDEPENDS:${PN} = "u-boot-fw-utils"

SRC_URI += "file://LICENSE \
            file://clear-recovery-flag.sh \
            file://clear-recovery-flag.service"
S = "${WORKDIR}"
do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/clear-recovery-flag.sh ${D}${bindir}/clear-recovery-flag.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/clear-recovery-flag.service ${D}${systemd_system_unitdir}/clear-recovery-flag.service
}

SYSTEMD_SERVICE:${PN} = "clear-recovery-flag.service"
inherit systemd
