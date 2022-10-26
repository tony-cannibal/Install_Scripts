#!/bin/bash

home="/home/luis/"
confdir="/home/luis/.media1/Config_Files/"
hdd="/home/luis/.media1"


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
  xdg-utils base-devel nfs-utils inetutils dnsutils alsa-utils pulseaudio alacritty \
  gvfs gvfs-mtp os-prober terminus-font xorg xorg-xinit bspwm sxhkd lightdm \
  lightdm-gtk-greeter lightdm-gtk-greeter-settings pcmanfm neovim python-neovim \
  wget curl git unzip tar gzip npm rustup cargo libx11 libxft libxinerama freetype2 \
  fontconfig lxsession udisks2 udiskie feh xsel exa bat ueberzug numlockx ark p7zip \
  unrar unarchiver lzop lrzip file-roller xmlstarlet xfce4-settings

# Grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
sed -i 's/GRUB_GFXMODE=.*/GRUB_GFXMODE=1440x900x32,auto/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager 

useradd luis -mG wheel
echo luis:310013 | chpasswd

cp /etc/skel/.bash_profile $home
cp /etc/skel/.bash_logout $home

mkdir -p /home/luis/.config/{alacritty,bspwm,sxhkd,nvim}
mkdir /home/luis/{Documents,Music,Pictures,Videos,Downloads}

cp /usr/share/doc/bspwm/examples/bspwmrc /home/luis/.config/bspwm/bspwmrc
chmod +x /home/luis/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc /home/luis/.config/sxhkd/sxhkdrc
sed -i 's/urxvt/alacritty/' /home/luis/.config/sxhkd/sxhkdrc 
cp /usr/share/doc/alacritty/example/alacritty.yml /home/luis/.config/alacritty/

cp /etc/X11/xinit/xinitrc /home/luis/.xinitrc


for i in {1..6}
  do
    sed -i '$d' ~/.xinitrc
  done

echo 'exec bspwm' >> /home/luis/.xinitrc

echo "Checking for second Hard Drive"
echo "********************************\n"
sleep 2

if [ -d $hdd ]
then
  echo "***********************************"
  echo "Copying Custom Config"
  echo "***********************************"
  cp /home/luis/.media1/Config_Files/.bashrc $home
  cp /home/luis/.media1/Config_Files/.Xresources $home
  cp -r "${confdir}lf" "${home}.config"
  cp -r "${confdir}suckless" "${home}.config"
  cp -r "${confdir}termcolors" "${home}.config"
  cp -r "${confdir}.bin" "${home}"

else
  echo "***********************************"
  echo "The hard drive is not set up"
  echo "will copy default files instead"
  echo "***********************************"
  cp /etc/skel/.bashrc $home
fi
chown -R luis:luis /home/luis
