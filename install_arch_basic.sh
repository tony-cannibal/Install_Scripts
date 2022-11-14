#!/bin/bash

HDIR="/home/luis"

# TimeZone
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc

# Localization
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf\

# Network Specific
echo "cannibal" >> /etc/hostname
echo "127.0.0.1        localhost" >> /etc/hosts
echo "::1              localhost" >> /etc/hosts
echo "127.0.1.1        myhostname.localdomain  myhostname" >> /etc/hosts

echo root:260593 | chpasswd

pacman -Sy --noconfirm grub efibootmgr networkmanager mtools dosfstools xdg-user-dirs \
  xdg-utils base-devel nfs-utils inetutils dnsutils pulseaudio pamixer alacritty \
  gvfs gvfs-mtp os-prober terminus-font xorg xorg-xinit bspwm sxhkd lightdm \
  lightdm-gtk-greeter lightdm-gtk-greeter-settings pcmanfm neovim python-neovim \
  wget curl git unzip tar gzip npm lxsession udisks2 udiskie feh xsel exa bat \
  ueberzug numlockx ark p7zip unrar unarchiver lzop lrzip file-roller libx11 \
  libxft libxinerama freetype2 fontconfig arc-gtk-theme papirus-icon-theme polybar \
  rxvt-unicode rofi

# Grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
sed -i 's/GRUB_GFXMODE=.*/GRUB_GFXMODE=1440x900x32,auto/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager 

#Add User
useradd luis -mG wheel
echo luis:310013 | chpasswd


