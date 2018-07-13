#!/bin/bash

sed -i 's/.*tmp.*//g' /etc/fstab
sed -i 's/.*proc.*/proc\t\t\/proc\t\tproc\t\t\tdefaults\t\t0\t0/g' /etc/fstab
sed -i 's/.*BOOTDEV.*/\/dev\/mmcblk0p1\t\/boot\t\tvfat\t\t\tro,defaults\t\t0\t2/g' /etc/fstab
sed -i 's/.*ROOTDEV.*/\/dev\/mmcblk0p2\t\/\t\text4\t\t\tro,defaults,noatime\t0\t1/g' /etc/fstab
sed -i '/^$/d' /etc/fstab
echo "tmpfs		/var/log		tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/var/tmp		tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/var/lib/alsa		tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp			tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp/.local-pi		tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp/.config-pi		tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp/.cache-pi		tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp/.local-root	tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp/.config-root	tmpfs			nodev,nosuid		0	0" >> /etc/fstab
echo "tmpfs		/tmp/.cache-root	tmpfs			nodev,nosuid		0	0" >> /etc/fstab

sed -i 's/root=ROOTDEV/root=\/dev\/mmcblk0p2/' /boot/cmdline.txt

sed -i "s/#Storage=auto/Storage=volatile/" /etc/systemd/journald.conf

# Link dirs for read only
rm -rf /var/spool /var/lock /var/lib/dhcp /var/lib/dhcpcd5 /var/cache/apt/
rm /etc/resolv.conf

ln -s /tmp /var/lib/dhcp
ln -s /tmp /var/lib/dhcpcd5
ln -s /tmp /var/spool
ln -s /tmp /var/lock
ln -s /tmp/.config-pi /home/pi/.config
ln -s /tmp/.local-pi /home/pi/.local
ln -s /tmp/.cache-pi /home/pi/.cache
ln -s /tmp/.config-root /root/.config
ln -s /tmp/.local-root /root/.local
ln -s /tmp/.cache-root /root/.cache
ln -s /tmp/openauto.ini /home/pi/openauto.ini
ln -s /tmp/resolv.conf /etc/resolv.conf

# Change spool permissions in var.conf (rondie/Margaret fix)
sed -i 's/spool 0755/spool 1777/' /usr/lib/tmpfiles.d/var.conf