FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:raspberrypi5 = " \
    file://rpi/swupdate.cfg \
    file://rpi/swupdate-ab.sh \
    file://rpi/swupdate.service \
"

do_install:append:raspberrypi5() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/rpi/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg

    install -m 0755 ${WORKDIR}/rpi/swupdate-ab.sh ${D}${bindir}/swupdate-ab.sh
    install -m 0644 ${WORKDIR}/rpi/swupdate.service ${D}${systemd_system_unitdir}/swupdate.service
}

SYSTEMD_SERVICE:${PN} = "swupdate.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
