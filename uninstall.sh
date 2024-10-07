#!/bin/bash

echo "Uninstalling & reverting to back stock cpu frequency..."

sudo systemctl disable cpu_performance.service
sudo rm /etc/tmpfiles.d/mglru.conf
sudo rm /etc/security/limits.d/memlock.conf
sudo rm /etc/udev/rules.d/64-ioschedulers.rules
sudo sed -i -e 's/,noatime//' /etc/fstab
sudo sed -i -e 's/mitigations=off nowatchdog nmi_watchdog=0 //' /etc/default/grub
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg

echo "Uninstalling completed...Please reboot!"
