#!/bin/bash
# this is intended to run on a cubic environment of lubuntu
echo Note: the builder is still in an early stage of dev and for now will maybe still require user interview, i wouldnt recommend going for a coffee and wait haha, maybe u will see timeout messages
echo OmegaLinux Build ¡START!
sleep 2

# remove all lubuntu junk
echo Processing "remove all lubuntu junk"...
# we do some shit here
apt update
apt --purge autoremove lubuntu-desktop-minimal -y
apt --purge autoremove qt* qt5* qt6* qml* lxqt* libqt5* libqt6* libqt* libkf5* gnome* -y
rm -rf /usr/share/qt* /usr/share/qt5* /usr/share/qt6 /usr/share/qml* /usr/share/lxqt* /usr/share/sddm*
rm -rf /usr/lib/qt* /usr/lib/qt5* /usr/lib/qt6 /usr/lib/qml* /usr/lib/lxqt* /usr/lib/sddm*
rm -rf /usr/lib/qt* /etc/qt5* /etc/qt6 /etc/qml* /etc/lxqt* /etc/sddm*
rm -rf /usr/lib/calamares* /usr/share/calamares* /etc/calamares*
apt install initramfs-tools casper -y
apt install cryptsetup -y
apt autoremove dracut-core -y
echo Done processing "remove all lubuntu junk".

# Install LXDE and some other goodies
echo Processing "Install LXDE and some other goodies"...
apt upgrade -y
apt install lxde-core lightdm slick-greeter celluloid xinit lxsession -y
apt install lxde --no-install-recommends -y
apt install libllvm19 -y
apt remove lxpanel lxpanel-data -y
apt install ./pcks/lxpanel/lxpanel_0.11.1-olinux_amd64.deb -y
apt install libwnck-3-0 libwnck-3-common -y
apt install lxde --no-install-recommends -y
echo Done processing "Install LXDE and some other goodies".

# Install fastfetch and add its olinux configs
echo Processing "Install fastfetch and add its olinux configs"...
apt --purge autoremove fastfetch -y
apt install libwnck-3-0 libwnck-3-common -y
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
apt remove linux-image* linux-headers* linux-modules-* linux-tools* -y
apt install ./mods/locoskernel/*.deb -y --allow-downgrades
apt-mark hold linux-libc-dev
apt install amd64-microcode grub-pc-bin libc-dev-bin thermald bpfcc-tools grub2-common libc6-dev manpages-dev ubuntu-kernel-accessories bpftrace ieee-data libclang-cpp21 os-prober grub-common intel-microcode libclang1-21 python3-bpfcc grub-gfxpayload-lists iucode-tool libefiboot1t64 python3-netaddr grub-pc libbpfcc libefivar1t64 rpcsvc-proto bpftool hwdata libdebuginfod-common libdebuginfod1t64 linux-perf pnp.ids
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
cp -rf mods/theming/theme/Obsidian-2 /usr/share/themes/
cp -rf mods/theming/icons/Obsidian /usr/share/icons/
cp -rf mods/theming/cur/DMZ-White /usr/share/icons/
mkdir /etc/skel/.config/lxsession
mkdir /etc/skel/.config/lxsession/LXDE
cp -rf mods/theming/cfg/desktop.conf /etc/skel/.config/lxsession/LXDE
echo Done processing "OmegaLinux theming".

# cursor fixup
echo Processing "cursor fixup"
rm -rf /usr/share/icons/Adwaita/cursors/*
cp -rf /usr/share/icons/DMZ-White/cursors/* /usr/share/icons/Adwaita/cursors/
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
apt install xdg-desktop-portal-gtk libdbusmenu-gtk3-4 gtk2-engines-murrine gir1.2-gtksource-4 libxapp-gtk3-module -y
echo Done processing "fixups".

# install pipewire deps
echo Processing "install pipewire deps"...
apt install pipewire-audio-client-libraries pipewire-alsa  -y
echo Done processing "install pipewire deps".

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
# echo Processing "olinux os release file"...
# rm -rf /usr/lib/os-release
# cp mods/osrel/os-release /usr/lib/
# echo Done processing "olinux os release file".

# Installing and removing packages and final adjustments before cleaning
echo Processing "Installing and removing packages and final adjustments before cleaning"...
apt --purge remove libreoffice* -y
apt autoremove yt-dlp -y # not necessary and can be installed manually
apt install fonts-opensymbol bluez gstreamer1.0-x libdv4t64 libopengl0 gstreamer1.0-plugins-good libcaca0 libglu1-mesa libwavpack1 -y
# install some utilities and essential stuff
apt install blueman --no-install-recommends -y
apt install lxtask --no-install-recommends -y
apt install network-manager-gnome --no-install-recommends -y
apt install gnome-disk-utility -y
apt install rar unrar zip unzip 7zip xz-utils -y
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
