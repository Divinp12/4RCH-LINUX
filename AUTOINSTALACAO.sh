#!/bin/bash

+() {
echo "$@"
}

?() {
sleep 5;
clear; "$@"
}

%() {
"$@" > /dev/null 2>&1;
}

clear;





if + "INICIANDO FORMATACAO EM 10 SEGUNDOS,
ESTEJA CIENTE DO QUE ESTA FAZENDO,
POIS TODOS OS DADOS SERAO APAGADOS
PARA QUE A INSTALACAO SEJA BEM SUCEDIDA..."; then
sleep 10; clear
fi;





+ "ADICIONANDO ESPELHO BRASILEIRO"
if + "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
+ "ESPELHO BRASILEIRO ADICIONADO COM SUCESSO"
else
+ "ERRO AO ADICIONAR O ESPELHO BRASILEIRO"
fi;

?

+ "SOBSCREVENDO ARQUIVO pacman.conf"
if + "[options]
Architecture=auto
CheckSpace
ParallelDownloads=1
SigLevel=Required DatabaseOptional
LocalFileSigLevel=Optional
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist
[multilib]
Include=/etc/pacman.d/mirrorlist
[community]
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf; then
+ "ARQUIVO pacman.conf SOBSCRITO COM SUCESSO"
else
+ "ERRO AO SOBSCREVER ARQUIVO pacman.conf"
fi;

?

+ "SINCRONIZANDO REPOSITORIOS DO PACMAN"
if % pacman -Sy --noconfirm --quiet; then
+ "REPOSITORIOS DO PACMAN SINCRONIZADOS COM SUCESSO"
else
+ "ERRO AO SINCRONIZAR REPOSITORIOS DO PACMAN"
fi;

?

+ "FORMATANDO DISPOSITIVO DE ARMAZENAMENTO DE DADOS VALIDO"
if % fdisk /dev/nvme0n1; then <<EOF > /dev/null 2>&1
o
w
EOF

% fdisk /dev/nvme0n1 <<EOF > /dev/null 2>&1
n
p
1

+2G
t
4
w
EOF

% fdisk /dev/nvme0n1 <<EOF > /dev/null 2>&1
n
p
2

+30G
w
EOF

% fdisk /dev/nvme0n1 <<EOF > /dev/null 2>&1
n
p
3


w
EOF

% partprobe
% mkfs.fat -F32 /dev/nvme0n1p1
% mkfs.ext4 -F /dev/nvme0n1p2
% mkfs.ext4 -F /dev/nvme0n1p3
% mount /dev/nvme0n1p2 /mnt
% mkdir /mnt/boot
% mkdir /mnt/boot/EFI
% mkdir /mnt/home
% mount /dev/nvme0n1p1 /mnt/boot/EFI
% mount /dev/nvme0n1p3 /mnt/home

else

% fdisk /dev/sda <<EOF > /dev/null 2>&1
o
w
EOF

% fdisk /dev/sda <<EOF > /dev/null 2>&1
n
p
1

+2G
t
4
w
EOF

% fdisk /dev/sda <<EOF > /dev/null 2>&1
n
p
2

+30G
w
EOF

% fdisk /dev/sda <<EOF > /dev/null 2>&1
n
p
3


w
EOF

% partprobe
% mkfs.fat -F32 /dev/sda1
% mkfs.ext4 -F /dev/sda2
% mkfs.ext4 -F /dev/sda3
% mount /dev/sda2 /mnt
% mkdir /mnt/boot
% mkdir /mnt/boot/EFI
% mkdir /mnt/home
% mount /dev/sda1 /mnt/boot/EFI
% mount /dev/sda3 /mnt/home
fi;

?

+ "INSTALANDO PACOTES DO SISTEMA";
if % pacstrap /mnt --noconfirm --quiet \
base \
base-devel \
linux \
linux-firmware \
linux-headers \
networkmanager \
sudo \
git \
fastfetch \
mesa \
lib32-mesa \
mesa-vdpau \
lib32-mesa-vdpau \
libva-mesa-driver \
lib32-libva-mesa-driver \
vulkan-icd-loader \
lib32-vulkan-icd-loader \
vulkan-validation-layers \
lib32-vulkan-validation-layers \
vulkan-mesa-layers \
lib32-vulkan-mesa-layers \
vulkan-headers \
plasma-desktop \
dolphin \
kscreen \
flatpak \
plasma-nm \
foot \
wayland \
lib32-wayland \
pipewire \
pipewire-pulse \
pipewire-media-session \
pavucontrol \
sddm \
grub-efi-x86_64 \
efibootmgr; then
+ "PACOTES DO SISTEMA INSTALADOS COM SUCESSO"
else
+ "ERRO AO INSTALAR PACOTES DO SISTEMA"
fi;

?

+ "AUTOGERANDO E AUTOCONFIGURANDO PARTICOES NO ARQUIVO fstab"
if genfstab -U -p /mnt > /mnt/etc/fstab; then
+ "ARQUIVO fstab AUTOGERADO E AUTOCONFIGURADO COM SUCESSO"
else
+ "ERRO AO AUTOGERAR E AUTOCONFIGURAR ARQUIVO fstab"
fi;

?

+ "ENTRANDO NO AMBIENTE arch-chroot"
arch-chroot /mnt bash -c '

+() {
echo "$@"
}

?() {
sleep 5;
clear; "$@"
}

%() {
"$@" > /dev/null 2>&1;
}



?

+ "ADICIONANDO NOME 4RCH AO USUARIO ROOT NO ARQUIVO hostname";
if + 4RCH > /etc/hostname; then
+ "NOME 4RCH DO USUARIO ROOT ADICIONADO NO ARQUIVO hostname COM SUCESSO"
else
+ "ERRO AO ADICIONAR NOME 4RCH AO USUARIO ROOT NO ARQUIVO hostname"
fi;

?

+ "ADICIONANDO SENHA 4RCH AO USUARIO ROOT"
if + -e "4RCH\n4RCH" | passwd root; then
+ "SENHA 4RCH ADICIONADO AO USUARIO ROOT COM SUCESSO"
else
+ "ERRO AO ADICIONAR SENHA 4RCH AO USUARIO ROOT"
fi;

?

+ "ADICIONANDO USUARIO NORMAL COM NOME 4RCH"
if useradd -m -g users -G wheel 4RCH; then
+ "USUARIO NORMAL COM NOME 4RCH ADICIONADO COM SUCESSO"
else
+ "ERRO AO ADICIONAR USUARIO NORMAL COM NOME 4RCH"
fi;

?

+ "ADICIONANDO SENHA 4RCH AO USUARIO NORMAL"
if + -e "4RCH\n4RCH" | passwd 4RCH; then
+ "SENHA 4RCH ADICIONADO AO USUARIO NORMAL ADICIONADO COM SUCESSO"
else
+ "ERRO AO ADICIONAR SENHA 4RCH AO USUARIO NORMAL"
fi;

?

+ "ADICIONANDO CARACTERES PORTUGUES BRASILEIRO E INGLES AMERICANO"
if + "pt_BR.UTF-8 UTF-8
en_US.UTF-8 UTF-8" > /etc/locale.gen; then
+ "CARACTERES PORTUGUES BRASILEIROS E INGLES AMERICANO ADICIONADO COM SUCESSO"
else
+ "ERRO AO ADICIONAR CARACTERES PORTUGUES BRASILEIRO E INGLES AMERICANO"
fi;

?

+ "APLICANDO IDIOMA PORTUGUES BRASILEIRO NO SISTEMA"
if + "LANG=pt_BR.UTF-8" > /etc/locale.conf; then
+ "IDIOMA PORTUGUES BRASILEIRO APLICADO NO SISTEMA COM SUCESSO"
else
+ "ERRO AO APLICAR IDIOMA PORTUGUES BRASILEIRO NO SISTEMA"
fi;

?

+ "APLICANDO CARACTERES PORTUGUES BRASILEIRO E INGLES AMERICANO"
if % locale-gen; then
+ "CARACTERES PORTUGUES BRASILEIRO E INGLES AMERICANO APLICADO COM SUCESSO"
else
+ "ERRO AO APLICAR CARACTERES PORTUGUES BRASILEIRO E INGLES AMERICANO"
fi;

?

+ "SINCRONIZANDO RELOGIO DO HARDWARE E DO SISTEMA VIA WIFI"
if % hwclock --systohc; then
+ "RELOGIO DO HARDWARE E DO SISTEMA SINCRONIZADO VIA WIFI COM SUCESSO"
else
+ "ERRO AO SINCRONIZAR RELOGIO DO HARDWARE E DO SISTEMA VIA WIFI"
fi;

?

+ "ADICIONANDO ESPELHO BRASILEIRO"
if + "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
+ "ESPELHO BRASILEIRO ADICIONADO COM SUCESSO"
else
+ "ERRO AO ADICIONAR ESPELHO BRASILEIRO"
fi;

?

+ "SOBSCREVENDO ARQUIVO .bashrc"
if + "alias i=\"yay -S --noconfirm --quiet\"
alias d=\"sudo pacman -Rsc\"
sudo rm -rf /home/4RCH/.bash_history /home/4RCH/.cache /var/log;
sudo pacman -Syyu --noconfirm --quiet;
sudo pacman -Scc --noconfirm --quiet;
clear;
fastfetch;
echo \"
INSTALAR PACOTES (i nome-do-pacote)
DESISTALAR PACOTES (d nome-do-pacote)
EXEMPLO: i google-chrome
\";
git clone https://aur.archlinux.org/yay.git && \\
chmod 777 yay && \\
cd yay && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf yay && \\
yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake && \\
sudo sed -i \"13,\\\$d\" /home/4RCH/.bashrc" > /home/4RCH/.bashrc; then
+ "ARQUIVO .bashrc SOBSCRITO COM SUCESSO"
else
+ "ERRO AO SOBSCREVER ARQUIVO .bashrc"
fi;

?

+ "SOBSCREVENDO ARQUIVO pacman.conf"
if + "[options]
Architecture=auto
CheckSpace
ParallelDownloads=1
SigLevel=Required DatabaseOptional
LocalFileSigLevel=Optional
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist
[multilib]
Include=/etc/pacman.d/mirrorlist
[community]
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf; then
+ "ARQUIVO pacman.conf SOBSCRITO COM SUCESSO"
else
+ "ERRO AO SOBSCREVER ARQUIVO pacman.conf"
fi;

?

+ "SINCRONIZANDO REPOSITORIOS DO PACMAN"
if % pacman -Sy --noconfirm --quiet; then
+ "REPOSITORIOS DO PACMAN SINCRONIZADOS COM SUCESSO"
else
+ "ERRO AO SINCRONIZAR REPOSITORIOS DO PACMAN"
fi;

?

+ "ESCANEANDO HARDWARE AMD E INSTALANDO DRIVERS AMD"
if lspci | grep -i amd > /dev/null 2>&1; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon > /dev/null 2>&1
else
+ "ERRO AO INSTALAR DRIVERS AMD"
fi;

?

+ "ESCANEANDO HARDWARE INTEL E INSTALANDO DRIVERS INTEL"
if lspci | grep -i intel > /dev/null 2>&1; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel > /dev/null 2>&1
else
+ "ERRO AO INSTALAR DRIVERS INTEL"
fi;

?

+ "ESCANEANDO HARDWARE NVIDIA E INSTALANDO DRIVERS NVIDIA"
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings > /dev/null 2>&1
else
+ "ERRO AO INSTALAR DRIVERS NVIDIA"
fi;

?

+ "ESCANEANDO HARDWARE VIRTUALBOX E INSTALANDO DRIVERS VIRTUALBOX"
if lspci | grep -i virtualbox > /dev/null 2>&1; then
pacman -Sy --noconfirm \
virtualbox-guest-utils \
virtualbox-guest-modules-arch > /dev/null 2>&1
else
+ "ERRO AO INSTALAR DRIVERS VIRTUALBOX"
fi;

?

+ "HABILITANDO DRIVER DE INTERNET E DISPLAY MANAGER (SDDM) NA INICIALIZACAO DO SISTEMA"
if % systemctl enable \
NetworkManager \
sddm; then
+ "DRIVER DE INTERNET E DISPLAY MANAGER (SDDM) HABILITADO NA INICIALIZACAO DO SISTEMA COM SUCESSO"
else
+ "ERRO AO HABILITAR DRIVER DE INTERNET E DISPLAY MANAGER (SDDM) NA INICIALIZACAO DO SISTEMA"
fi;

?

+ "DESATIVANDO SERVICOS DESNECESSARIOS NA INICIALIZACAO DO SISTEMA"
if % systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd; then
+ "SERVICOS DESNESSARIOS DESATIVADOS NA INICIALIZACAO DO SISTEMA COM SUCESSO"
else
+ "ERRO AO DESATIVAR SERVICOS DESNECESSARIOS NA INICIALIZACAO DO SISTEMA"
fi;

?

+ "GERANDO IMAGENS NO INICIALIZADOR DO SISTEMA"
if % mkinitcpio -P; then
+ "IMAGENS GERADAS NA INICIALIZACAO DO SISTEMA COM SUCESSO"
else
+ "ERRO AO GERAR IMAGENS NA INICIALIZACAO DO SISTEMA"
fi;

?

+ "SOBSCREVENDO ARQUIVO sddm.conf"
if + "[Autologin]
Relogin=false
User=4RCH
Session=plasma
EnableWayland=true" > /etc/sddm.conf; then
+ "ARQUIVO sddm.conf SOBSCRITO COM SUCESSO"
else
+ "ERRO AO SOBSCREVER ARQUIVO sddm.conf"
fi;

?

+ "SOBSCREVENDO ARQUIVO grub"
if + "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"4RCH\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub; then
+ "ARQUIVO grub SOBSCRITO COM SUCESSO"
else
+ "ERRO AO SOBSCREVER ARQUIVO grub"
fi;

?

+ "CONFIGURANDO GRUB"
if % grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=4RCH --recheck; then
+ "GRUB CONFIGURADO COM SUCESSO"
else
+ "ERRO AO CONFIGURAR GRUB"
fi;

?

+ "ADICIONANDO GRUB NA INICIALIZACAO"
if % grub-mkconfig -o /boot/grub/grub.cfg; then
+ "GRUB ADICIONADO NA INICIALIZACAO COM SUCESSO"
else
+ "ERRO AO ADICIONAR GRUB NA INICIALIZACAO"
fi;

?

+ "ADICIONANDO USUARIO NORMAL (4RCH) AO SUDO NO ARQUIVO sudoers"
if + "4RCH ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers; then
+ "USUARIO NORMAL (4RCH) ADICIONADO AO SUDO NO ARQUIVO sudoers COM SUCESSO"
else
+ "ERRO AO ADICIONAR USUARIO NORMAL (4RCH) AO SUDO NO ARQUIVO sudoers"
fi;

?

+ "ADICIONANDO OPÇÕES NOATIME E DISCARD NAS PARTIÇÕES EXT4"
if sed -i "/^UUID=.* \/boot .*$/! s/rw/rw,noatime,discard,/" /etc/fstab; then
+ "OPÇÕES NOATIME E DISCARD ADICIONADAS NAS PARTIÇÕES EXT4 COM SUCESSO"
else
+ "ERRO AO ADICIONAR OPÇÕES NOATIME E DISCARD NAS PARTIÇÕES EXT4"
fi;

?

+ "ADICIONANDO CONEXAO IPV6 NO SISTEMA"
if + "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 4RCH.localdomain 4RCH" > /etc/hosts; then
+ "CONEXAO IPV6 ADICIONADA NO SISTEMA COM SUCESSO"
else
+ "ERRO AO ADICIONAR CONEXAO IPV6 NO SISTEMA"
fi;

?

+ "REMOVENDO LINHAS QUE COMECAM COM JOGO DA VELHA E ESPACOS VAZIOS"
if sed -i "/^\s*#/d; /^\s*$/d" \
/home/4RCH/.bash_profile \
/home/4RCH/.bash_logout \
/etc/sudoers \
/etc/sudo.conf \
/etc/host.conf \
/etc/healthd.conf \
/etc/mkinitcpio.conf \
/etc/libva.conf \
/etc/vconsole.conf \
/etc/fuse.conf \
/etc/ts.conf \
/etc/fstab; then
+ "LINHAS QUE COMECAM COM JOGO DA VELHA E ESPACOS VAZIOS REMOVIDAS COM SUCESSO"
else
+ "ERRO AO REMOVER LINHAS QUE COMECAM COM JOGO DA VELHA E ESPACOS VAZIOS"
fi;

?

+ "REMOVENDO ARQUIVO initramfs-linux-fallback.img"
if rm -rf /boot/initramfs-linux-fallback.img; then
+ "ARQUIVO initramfs-linux-fallback.img REMOVIDO COM SUCESSO"
else
+ "ERRO AO REMOVER ARQUIVO initramfs-linux-fallback.img"
fi';

?

+ "GRAVANDO DADOS DA MEMORIA NO DISCO"
if sync; then
+ "DADOS DA MEMORIA GRAVADOS NO DISCO COM SUCESSO"
else
+ "ERRO AO GRAVAR DADOS DA MEMORIA NO DISCO"
fi;

?

+ "REINICIANDO"
reboot -f;
