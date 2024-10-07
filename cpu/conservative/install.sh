#!/bin/bash

echo "Installing conservative CPU scheduler frequency..."

cat << EOF | sudo tee /etc/systemd/system/cpu_performance.service
[Unit]
Description=CPU conservative governor
[Service]
Type=oneshot
ExecStart=/usr/bin/cpupower frequency-set -g conservative
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable cpu_performance.service
cat << EOF | sudo tee /etc/tmpfiles.d/mglru.conf
w /sys/kernel/mm/lru_gen/enabled - - - - 7
w /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 0
EOF
cat << EOF | sudo tee /etc/security/limits.d/memlock.conf
* hard memlock 2147484
* soft memlock 2147484
EOF
cat << EOF | sudo tee /etc/udev/rules.d/64-ioschedulers.rules
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
EOF
sudo sed -i -e '/home/s/\bdefaults\b/&,noatime/' /etc/fstab
sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&mitigations=off nowatchdog nmi_watchdog=0 /' /etc/default/grub
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg

echo "Installation completed...Please reboot!"
