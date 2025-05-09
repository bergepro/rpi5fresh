# meta-berge/recipes-connectivity/openssh/openssh_%.bbappend

PACKAGECONFIG:remove = "systemd-sshd-socket-mode"
PACKAGECONFIG:append = " systemd-sshd-service-mode"

SYSTEMD_SERVICE:openssh-sshd = "sshd.service"
SYSTEMD_AUTO_ENABLE:openssh-sshd = "enable"
