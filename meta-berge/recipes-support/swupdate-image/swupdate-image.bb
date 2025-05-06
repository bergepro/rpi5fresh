DESCRIPTION = "SWUpdate image for A/B updates"
LICENSE = "MIT"

inherit swupdate-image

SRC_URI += "file://sw-description \
            file://update.sh \
            file://boot-ab.scr"

SWUPDATE_IMAGES = "core-image-full-cmdline"
SWUPDATE_IMAGES_FSTYPES[core-image-full-cmdline] = ".squashfs"

S = "${WORKDIR}"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${DEPLOY_DIR_IMAGE}
    cp ${WORKDIR}/sw-description ${D}${DEPLOY_DIR_IMAGE}
    cp ${WORKDIR}/boot-ab.scr ${D}${DEPLOY_DIR_IMAGE}
    cp ${WORKDIR}/update.sh ${D}${DEPLOY_DIR_IMAGE}
}
