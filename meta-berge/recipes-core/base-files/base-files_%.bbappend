FILESEXTRAPATHS:prepend := "${THISDIR}:"

do_install:append() {
    install -m 0644 ${WORKDIR}/fstab ${D}${sysconfdir}/fstab
}
