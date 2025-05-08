FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:raspberrypi5 = " \
    file://rpi/swupdate.cfg \
"

do_install:append:raspberrypi5() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${WORKDIR}/rpi/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg
}
