#!/bin/bash

echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 z.localdomain z" > /etc/hosts;

echo z > /etc/hostname;

yes z | passwd root;

useradd -m -g users -G wheel z;

yes z | passwd z;

echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen;
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf;
locale-gen;
hwclock --systohc;

echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;

echo "alias i='yay -S --noconfirm'
alias d='sudo pacman -Rsc'
alias nano='sudo nano'
alias addsuporte-bluetooth='yay -S --noconfirm bluez bluez-tools bluez-utils blueman && sudo systemctl start bluetooth.service && sudo systemctl enable bluetooth.service'
sudo rm -rf /home/z/.bash_history;
sudo pacman -Syyu --noconfirm;
sudo pacman -Scc --noconfirm;
clear;
fastfetch
git clone https://aur.archlinux.org/yay.git && sudo chmod 777 yay && cd yay && makepkg -si --noconfirm && cd .. && sudo rm -rf yay && yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake && sed -i '\$d' /home/z/.bashrc" > /home/z/.bashrc;

echo "[options]
Architecture=auto
CheckSpace
ParallelDownloads=5
SigLevel=Required DatabaseOptional
LocalFileSigLevel=Optional
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist
[multilib]
Include=/etc/pacman.d/mirrorlist
[community]
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf;

pacman -Syyu --noconfirm;

if lspci | grep -i amd; then
pacman -Sy --noconfirm \
amd-ucode \
xf86-video-amdgpu \
vulkan-radeon \
lib32-vulkan-radeon
fi;

if lspci | grep -i intel; then
pacman -Sy --noconfirm \
intel-ucode \
xf86-video-intel \
vulkan-intel \
lib32-vulkan-intel
fi;

if lspci | grep -i nvidia; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings
fi;

if lspci | grep -i virtualbox; then
pacman -Sy --noconfirm \
virtualbox-guest-utils \
virtualbox-guest-modules-arch;
systemctl enable vboxservice;
fi;

systemctl enable \
NetworkManager \
sddm;

systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd;

mkinitcpio -P;

echo "[Autologin]
Relogin=false
User=z
Session=xfce
EnableWayland=true" > /etc/sddm.conf;

echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"z\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub;
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=z --recheck;
grub-mkconfig -o /boot/grub/grub.cfg;

echo "z ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers;
sed -i "/^\s*#/d; /^\s*$/d" \
/home/z/.bash_profile \
/home/z/.bash_logout \
/etc/sudoers \
/etc/sudo.conf \
/etc/host.conf \
/etc/healthd.conf \
/etc/mkinitcpio.conf \
/etc/libva.conf \
/etc/vconsole.conf \
/etc/fuse.conf \
/etc/ts.conf \
/etc/fstab;
sed -i "/^UUID=.* \/boot .*$/! s/rw/rw,noatime,discard,/" /etc/fstab;
echo "none /home/z/.cache tmpfs defaults,size=0 0 0" >> /etc/fstab;
echo "none /var/log tmpfs defaults,size=0 0 0" >> /etc/fstab;
echo "none /tmp tmpfs defaults,size=0 0 0" >> /etc/fstab;
rm -rf /boot/initramfs-linux-fallback.img;
rm -rf 2.sh;
