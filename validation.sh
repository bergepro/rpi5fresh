WIC=$(find build/tmp/deploy/images/raspberrypi5 -name "*.wic.bz2" | sort | tail -n1)
bunzip2 -fk "$WIC"  # creates .wic alongside it

LOOPDEV=$(sudo losetup --show -Pf $(echo "$WIC" | sed 's/.bz2$//'))
sudo mkdir -p /mnt/rpi-boot
sudo mount "${LOOPDEV}p1" /mnt/rpi-boot

echo "==== BOOT PARTITION CONTENT ===="
ls -l /mnt/rpi-boot
echo "==== config.txt ===="
cat /mnt/rpi-boot/config.txt || echo "config.txt missing!"
echo "==== DONE ===="
