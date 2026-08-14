#!/bin/bash
# this is intended to run on a cubic environment of lubuntu
echo Note: the builder is still in an early stage of dev and for now will maybe still require user interview, i wouldnt recommend going for a coffee and wait haha, maybe u will see timeout messages
echo OmegaLinux Build ¡START!
sleep 2

# remove all lubuntu junk
echo Processing "remove all lubuntu junk"...
# we do some shit here
apt update
apt --purge autoremove lubuntu-desktop -y
apt --purge autoremove qt* qt5* qt6* qml* lxqt* libqt5* libqt6* libqt* libkf5* gnome* -y
apt --purge autoremove lubuntu* -y
apt --purge autoremove calamares* -y
rm -rf /usr/share/qt* /usr/share/qt5* /usr/share/qt6 /usr/share/qml* /usr/share/lxqt* /usr/share/sddm*
rm -rf /usr/lib/qt* /usr/lib/qt5* /usr/lib/qt6 /usr/lib/qml* /usr/lib/lxqt* /usr/lib/sddm*
rm -rf /usr/lib/qt* /etc/qt5* /etc/qt6 /etc/qml* /etc/lxqt* /etc/sddm*
rm -rf /usr/lib/calamares* /usr/share/calamares* /etc/calamares*
echo Done processing "remove all lubuntu junk".

# Install LXDE and some other goodies
echo Processing "Install LXDE and some other stuff"...
apt upgrade -y
apt install lxde-core lightdm slick-greeter celluloid xinit lxsession -y
apt install lxde --no-install-recommends -y
apt install libllvm19 -y
apt remove lxpanel lxpanel-data -y
apt install ./pcks/lxpanel/lxpanel_0.11.1-olinux_amd64.deb -y
apt install libwnck-3-0 libwnck-3-common -y
apt install lxde --no-install-recommends -y
apt install lightdm slick-greeter --no-install-recommends -y
echo Done processing "Install LXDE and some other stuff".

# Install fastfetch and add its olinux configs
echo Processing "Install fastfetch and add its olinux configs"...
apt --purge autoremove neofetch -y
cp -rf pcks/fastfetch/fastfetch /usr/bin/
mkdir /etc/skel/.config
mkdir /etc/skel/.config/fastfetch
cp -rf mods/fastfetch-olinux/config.jsonc /etc/skel/.config/fastfetch/
mkdir /root/.config
mkdir /root/.config/fastfetch
cp -rf mods/fastfetch-olinux/config.jsonc /root/.config/fastfetch/
mkdir /usr/fancy-stuff
cp -rf mods/fastfetch-olinux/olinuxlogo /usr/fancy-stuff/
echo Done processing "Install fastfetch and add its olinux configs".

# Replace kernel with Loc-OS's (refer to mods/locoskernel/info.txt)
echo Processing "Replace kernel with Loc-OS's (refer to mods/locoskernel/info.txt)"...
apt remove linux-image* linux-headers* linux-modules-* linux-hwe* -y
apt install ./mods/locoskernel/*.deb -y --allow-downgrades
apt-mark hold linux-libc-dev
apt install amd64-microcode bpfcc-tools bpftrace hwdata ieee-data intel-microcode iucode-tool libbpfcc libc-dev-bin libc-devtools libc6-dev libclang-cpp18 libclang1-18 libcrypt-dev libdebuginfod-common libdebuginfod1t64 libllvm18 libupower-glib3 linux-tools-common manpages-dev python3-bpfcc python3-netaddr rpcsvc-proto thermald ubuntu-kernel-accessories upower
echo Done processing "Replace kernel with Loc-OS's (refer to mods/locoskernel/info.txt)".

# Nuke snap and install deb firefox
echo Processing "Nuke snap and install deb firefox"...
apt --purge autoremove snapd -y
apt install squashfs-tools -y
apt install software-properties-common --no-install-recommends -y
cp -rf mods/ffox-conf/fucksnap /etc/apt/preferences.d/
sudo install -d -m 0755 /etc/apt/keyrings 
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
apt update && apt install firefox -y
echo Done processing "Nuke snap and install deb firefox".

# OmegaLinux theming
echo Processing "OmegaLinux theming"...
cp -rf mods/theming/theme/Orchis /usr/share/themes/
cp -rf mods/theming/theme/Orchis-Dark /usr/share/themes/
cp -rf mods/theming/icons/Tela /usr/share/icons/
cp -rf mods/theming/icons/Tela-dark /usr/share/icons/
cp -rf mods/theming/icons/Tela-light /usr/share/icons/
cp -rf mods/theming/cur/volantes_light_cursors /usr/share/icons/
mkdir /etc/skel/.config/lxsession
mkdir /etc/skel/.config/lxsession/LXDE
cp -rf mods/theming/cfg/desktop.conf /etc/skel/.config/lxsession/LXDE
echo Done processing "OmegaLinux theming".

# cursor fixup
echo Processing "cursor fixup"
rm -rf /usr/share/icons/Adwaita/cursors/*
cp -rf /usr/share/icons/volantes_light_cursors/cursors/* /usr/share/icons/Adwaita/cursors/
echo Done processing "cursor fixup"

# OLinux Wallpapers
echo Processing "OLinux Wallpapers"...
cp -rf mods/walls/art/* /usr/fancy-stuff/
mkdir /etc/skel/.config/pcmanfm
mkdir /etc/skel/.config/pcmanfm/LXDE
cp -rf mods/walls/desktop-items-0.conf /etc/skel/.config/pcmanfm/LXDE/
echo Done processing "OLinux Wallpapers".

# Install OmegaLinux Tutorial App
echo Processing "Install OmegaLinux Tutorial App"...
apt install python3-gi -y
cp -rf pcks/tutorial/app/olinux-tutorial /usr/fancy-stuff/
cp -rf pcks/tutorial/olinux-tutorial.desktop /usr/share/applications/
echo Done processing "Install OmegaLinux Tutorial App".

# OmegaLinux Panel theming
echo Processing "OmegaLinux Panel theming"...
mkdir /etc/skel/.config/lxpanel
mkdir /etc/skel/.config/lxpanel/LXDE
mkdir /etc/skel/.config/lxpanel/LXDE/panels
cp -rf mods/panel/panel /etc/skel/.config/lxpanel/LXDE/panels
cp -rf mods/panel/ics/* /usr/fancy-stuff/
echo Done processing "OmegaLinux Panel theming".

# OL Sounds
echo Processing "OL Sounds"...
apt install sox -y
cp -rf mods/snds/sounds/* /usr/fancy-stuff/
cp -rf mods/snds/autostart /etc/skel/.config/lxsession/LXDE/
echo Done processing "OL Sounds".

# Logout Banner
echo Processing "Logout Banner"...
rm -rf /usr/share/lxde/images/logout-banner.png
cp -rf mods/lgbanner/logout-banner.png /usr/share/lxde/images/
echo Done processing "Logout Banner".

# LDM Slick Greeter
echo Processing "LDM Slick Greeter"...
cp -rf mods/greet/slick-greeter.conf /etc/lightdm/
echo Done processing "LDM Slick Greeter".

# Openbox theme
echo Processing "Openbox theme"...
apt install gnome-themes-extra -y
rm -rf /usr/share/themes/Onyx
rm -rf /usr/share/themes/Clearlooks* /usr/share/themes/Mikachu /usr/share/themes/Natura /usr/share/themes/Nightmare* /usr/share/themes/Onyx-Citrus /usr/share/themes/Orang /usr/share/themes/Syscrash /usr/share/themes/Bear2 /usr/share/themes/Breeze-ob
cp -rf mods/obtheme/Onyx /usr/share/themes/
echo Done processing "Openbox theme"

# fixups
echo Processing "fixups"...
apt install xdg-desktop-portal-gtk libdbusmenu-gtk3-4 gtk2-engines-murrine gir1.2-gtksource-4 libxapp-gtk3-module libpipewire-0.3-0t64 libpipewire-0.3-common -y
echo Done processing "fixups".

# replace pulseaudio with pipewire
echo Processing "replace pulseaudio with pipewire"...
apt autoremove pulseaudio pulseaudio-utils  -y
apt install pipewire wireplumber pipewire-audio-client-libraries pipewire-alsa  -y
echo Done processing "replace pulseaudio with pipewire".

# Splash Screen
echo Processing "Splash Screen"...
cp -rf mods/splash/DEEPIN-15-LOGINSPINNER-TUX-LOGO-BLACK-BGRD_V1.0_PLYMOUTH-THEME /usr/share/plymouth/themes/
sleep 5
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/DEEPIN-15-LOGINSPINNER-TUX-LOGO-BLACK-BGRD_V1.0_PLYMOUTH-THEME/DEEPIN-15-LOGINSPINNER-TUX-LOGO-BLACK-BGRD_V1.0_PLYMOUTH-THEME.plymouth 200
update-alternatives --auto default.plymouth
update-initramfs -uk all
update-grub
echo Done processing "Splash Screen".

# Install ubiquity installer
echo Processing "Install ubiquity installer"...
apt install ubiquity ubiquity-slideshow-ubuntu ubiquity-frontend-gtk --no-install-recommends -y
apt install ubuntu-drivers-common -y
echo Done processing "Install ubiquity installer".

# olinux os release file
echo Processing "olinux os release file"...
rm -rf /usr/lib/os-release
cp mods/osrel/os-release /usr/lib/
echo Done processing "olinux os release file".

# Installing and removing packages and final adjustments before cleaning
echo Processing "Installing and removing packages and final adjustments before cleaning"...
apt --purge remove libreoffice* -y
apt install fonts-opensymbol gstreamer1.0-plugins-good gstreamer1.0-x libaa1 libabsl20220623t64 libavc1394-0 libboost-locale1.83.0 libboost-thread1.83.0 libcaca0 libclucene-contribs1t64 libclucene-core1t64 libdv4t64 libeot0 libexttextcat-2.0-0 libexttextcat-data libgpgmepp6t64 libgstreamer-plugins-good1.0-0 libharfbuzz-icu0 libhyphen0 libiec61883-0 liblangtag-common liblangtag1 libmhash2 libmythes-1.2-0 liborcus-0.18-0 liborcus-parser-0.18-0 libraptor2-0 librasqal3t64 libraw1394-11 librdf0t64 librevenge-0.0-0 libshout3 libtag1v5 libtag1v5-vanilla libuno-cppu3t64 libuno-cppuhelpergcc3-3t64 libuno-purpenvhelpergcc3-3t64 libuno-sal3t64 libuno-salhelpergcc3-3t64 libv4l-0t64 libv4lconvert0t64 libxmlsec1t64 libxmlsec1t64-nss libxslt1.1 libyajl2 uno-libs-private ure
apt install blueman --no-install-recommends -y
apt install lxtask --no-install-recommends -y
apt install network-manager-gnome --no-install-recommends -y
echo Done processing "Installing and removing packages and final adjustments before cleaning".

# Final cleanup and finish
echo Processing "Final cleanup and finish"
apt clean
apt autoclean
rm -rf /root/.bash_history
echo Done processing "Final cleanup and finish"

echo OmegaLinux Build ¡FINISH!
echo OmegaBuilder has finished building an omegalinux copy. You may consider nuking the omega-builder folder before building the final iso file.
echo Quiting...

((sec=SECONDS%60, min=SECONDS/60%60, hrs=SECONDS/3600))
timestamp=$(printf "OL Build took %02d hours, %02d minutes, and %02d seconds." $hrs $min $sec)
echo $timestamp
