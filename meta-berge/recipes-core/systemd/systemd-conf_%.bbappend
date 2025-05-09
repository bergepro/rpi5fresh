FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

THIS_MACHINE_NETWORK_FILE_1 ??= "38-rpi5-dhcp.network"
THIS_MACHINE_NETWORK_FILE_2 ??= "39-rpi5-static.network"

SRC_URI:append = " \
    file://${THIS_MACHINE_NETWORK_FILE_1} \
    file://${THIS_MACHINE_NETWORK_FILE_2} \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/${THIS_MACHINE_NETWORK_FILE_1} ${D}${sysconfdir}/systemd/network/${THIS_MACHINE_NETWORK_FILE_1}
    install -m 0644 ${WORKDIR}/${THIS_MACHINE_NETWORK_FILE_2} ${D}${sysconfdir}/systemd/network/${THIS_MACHINE_NETWORK_FILE_2}
}

FILES:${PN}:append = " ${sysconfdir}/systemd/network/"
