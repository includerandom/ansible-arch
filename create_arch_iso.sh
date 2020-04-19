#!/usr/bin/bash

if [ $UID != 0 ]; then
    echo "$0 must be run as root"
    exit 1
fi

archisodir="/tmp/archiso$RANDOM"

bootentrydir="$archisodir/efiboot/loader/entries/"

bootentrycd="$bootentrydir/archiso-x86_64-cd.conf"
bootentryusb="$bootentrydir/archiso-x86_64-usb.conf"

# Create directory
mkdir $archisodir

# Copy archiso contents to directory
cp -r /usr/share/archiso/configs/releng/* $archisodir

# Add console device
for i in {$bootentrycd,$bootentryusb}; do
    sed -i '/^options/ s/$/ console=ttyS0/' $i
done

# Set root password
echo 'echo "root:archiso" | chpasswd' \
  >> $archisodir/airootfs/root/customize_airootfs.sh

# Enable sshd.service
echo 'systemctl enable sshd.service' \
  >> $archisodir/airootfs/root/customize_airootfs.sh

# Optionally. Uncomment if you use wifi. Add wifi point
#cat << EOF >> $archisodir/airootfs/root/customize_airootfs.sh
#cat << EOF2 >> '/etc/wpa_supplicant/wpa_supplicant-wlan0.conf'
#ctrl_interface=/run/wpa_supplicant"
#update_config=1
#fast_reauth=1
#ap_scan=1
#network={
#        ssid="WiFiPoint"
#        psk="PasswordWiFiPointHere"
#}
#EOF2
#EOF

# Optionally. Uncomment if you use wifi. Enable wpa_supplicant service
#echo 'systemctl enable wpa_supplicant@wlan0' \
#  >> $archisodir/airootfs/root/customize_airootfs.sh

# Enable dhcpcd service
echo 'systemctl enable dhcpcd' \
  >> $archisodir/airootfs/root/customize_airootfs.sh

# Optionally. Uncomment if you use wifi. Enable rfkill-unblock service
#echo 'systemctl enable rfkill-unblock@all.service' \
#  >> $archisodir/airootfs/root/customize_airootfs.sh

# Copy mirrorlist to /root
cp /etc/pacman.d/mirrorlist $archisodir/airootfs/root/

# Build image
mkdir $archisodir/out
cd $archisodir
./build.sh -v

echo "Arch installation ISO created in $archisodir/out/"
