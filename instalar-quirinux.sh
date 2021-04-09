#!/bin/bash

# Nombre:	instalar-quirinux.sh
# Autor:	Charlie Martínez® <cmartinez@quirinux.org>
# Licencia:	https://www.gnu.org/licenses/gpl-3.0.txt
# Descripción:	Convierte una instalación limpia de Debian Buster XFCE 64 Bits en Quirinux 2.0
# Versión:	2.0 RC_3

function _inicio() # Verifica si está instalado dialog, wget y git
{

if [ -f /usr/bin/dialog ] && [ -f /usr/bin/git ] && [ -f /usr/bin/wget ] && [ -f /usr/local/bin/quirinux-sudoers ] && [ -f /etc/apt/sources.list.d/linux-libre.list ]; then # Cumple con los requisitos, continúa
clear
_menuPrincipal

else # No cumple con los requisitos, los instala y continúa
clear
_avisoInicio

fi

}

function _instalarSueltos()
{
cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 22 76 16)
options=(1 "Software de hogar y oficina" off 
2 "Software gráfico y de edición multimedia" off 
3 "GIMP Edición Quirinux" off 
4 "Tipografías adicionales (incluye las de Windows)" off 
5 "Temas y salvapantallas de Quirinux" off 
6 "Centro de software sencillo de usar" off 
7 "Compatibilidad con carpetas compartidas" off 
8 "Herramientas para virtualizar otros sistemas" off 
9 "Utilidad para usar digitalizadoras con 2 monitores" off 
10 "Firmware para placas de red Wifi" off 
11 "Controladores libres para hardware de red - excepto wifi" off 
12 "Controladores libres para escáneres e impresoras" off 
13 "Codecs privativos multimedia y RAR" off
14 "Controladores libres para aceleradoras NVIDEA" off 
15 "Controladores libres para aceleradoras AMD" off 
16 "Controladores libres para WACOM" off 
17 "Controladores libres para tabletas GENIUS" off 
18 "Utilidades de backup y puntos de restauración" off 
19 "Corrección de bugs (recomendado)" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
case $choice in

1) # "Programas para usuarios en general"
_baseBusterGeneral 
_utiles 
_olive 
_widd
;;

2) # "Programas para realizadores audiovisuales" 
_baseBusterPro
;;

3) # "GIMP Edición Quirinux (con opción de atajos e íconos de Phoshop"
_GIMP
;;

4) # "Tipografías adicionales (incluye las de Windows)
_fuentes
_tipografiasPro
;;

5) # "Temas y salvapantallas de Quirinux" 
_temas 
_salvapantallas
;;

6) # "Centro de software sencillo de usar (estilo Android)"
_centro
;;

7) # "Compatibilidad con carpetas compartidas y redes de Microsoft" 
_samba
;;

8) # "Herramientas para virtualizar otros sistemas operativos (AQEMU)" 
_aqemu
;;

9) # "Utilidad para usar digitalizadoras con 2 monitores (para XFCE)"
_ptxconf
;;

10) # "Firmware para placas de red Wifi"
_firmwareWifi
;;

11) # "Controladores libres para hardware de red - excepto wifi"
_libresRed
;;

12) # "Controladores libres para escáneres e impresoras" 
_libresImpresoras
;;

13) # "Codecs privativos multimedia y RAR"
_codecs
;;

14) # "Controladores libres para aceleradoras gráficas nVidia"
_libresNvidia
;;

15) # "Controladores libres para aceleradoras gráficas AMD" 
_libresAMD
;;

16) # "Controladores libres para digitalizadoras Wacom"
_libresWacom
;;

17) # "Controladores libres para tabletas digitalizadoras Genius"
_libresGenius
;;

18) # "Utilidades de backup y puntos de restauración"
_mint
;;

19) # "Corrección de bugs (recomendado)"
_pulseaudio
;;

esac
done

_menuPrincipal

}

function _menuPrincipal()

{

opPrincipal=$(dialog --title "MENÚ PRINCIPAL" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
--stdout \
--menu "Elije una opción" 16 50 5 \
1 "Instalar Quirinux Edición General" \
2 "Instalar Quirinux Edición Pro" \
3 "Instalar componentes sueltos" \
4 "Ayuda" \
5 "Salir" )

echo $opPrincipal

if [[ $opPrincipal == 1 ]]; then # Instalar Quirinux Edición General 
_instalarGeneral
_menuPrincipal
fi

if [[ $opPrincipal == 2 ]]; then # Instalar Quirinux Edición Pro 
_instalarPro
_menuPrincipal
fi

if [[ $opPrincipal == 3 ]]; then # Instalar componentes sueltos
_instalarSueltos
fi

if [[ $opPrincipal == 4 ]]; then # Ayuda
_ayuda
fi

if [[ $opPrincipal == 5 ]]; then # Salir
clear
_salir
fi
}

function _instalarDialog()
{
sudo apt-get install dialog -y
}

function _ayuda()
{

dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
--title "AYUDA" \
--msgbox "\nEl sistema operativo Quirinux GNU/Linux Versión 2.0 está basado en Debian GNU/Linux versión 10 (Buster) XFCE, por lo que instalar la ISO de Quirinux o instalar este script sobre un sistema Debian recién instalado es prácticamente lo mismo. Recuerda que Quirinux está hecho sobre el escritorio XFCE (podrías usar otro, como el Gnome que viene con la ISO live oficial de Debian, pero nosotros no hemos probado su funcionamiento).\n\nINSTALAR QUIRINUX EDICIÓN GENERAL:\nOficina, internet, compresión de archivos, pdf y editores básicos de gráficos, redes, virtualización, audio y video.\n\nINSTALAR QUIRINUX EDICIÓN PRO:\nHerramientas de la edición General + Software profesional para la edición de gráficos, animación 2D, 3D y Stop-Motion, audio y video.\n\nINSTALAR COMPONENTES SUELTOS:\nPermite instalar las cosas por separado y de manera optativa (controladores, programas, codecs, etc).\n\nACERCA DEL KERNEL:\n Este programa no instalará los núcleos AVL de baja latencia y Linux-Libre con los que viene Quirinux, sólo instalará controladores sobre el kernel que estés utilizando en este momento." 23 100
_menuPrincipal
}

function _salir()
{

clear
exit 0

}

function _preRequisitos()
{

# INSTALAR WGET Y GIT

clear
sudo apt-get update -y
for paquetes_wget in wget git; do sudo apt-get install -y $paquetes_wget; done

}

function _instalarGeneral()
{
clear
_centro
_firmwareWifi
_codecs
_controladoresLibres
_programasGeneral
_pulseaudio
_remover
_limpiar
}

function _controladoresLibres()
{
clear
_libresNvidia 
_libresAMD 
_libresWacom 
_libresGenius 
_libresImpresoras 
_libresRed

}

function _config()
{
	
# CONFIGURACIÓN PREDETERMINADA DE SUDOERS DE QUIRINUX

sudo mkdir -p /opt/tmp/sudoers
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/QiGdK8pC4SjKL8p/download' -O /opt/tmp/sudoers/quirinux-sudoers-1.0-q2_amd64.deb
sudo apt install /opt/tmp/sudoers/./quirinux-sudoers-1.0-q2_amd64.deb -y
sudo chown root:root -R /etc/sudoers.d
sudo chmod 755 -R /etc/sudoers.d/

# ESTABLECE SOPORTE MULTIARQUITECTURA PARA 32 BITS

sudo dpkg --add-architecture i386

# AGREGA REPOSITORIOS LIBRES ADICIONALES

if [ -e "/etc/apt/sources.list.d/debian.list" ]; then
sudo rm /etc/apt/sources.list.d/debian.list
fi

if [ -e "/etc/apt/apt.conf.d" ]; then
sudo mv /etc/apt/apt.conf.d /etc/apt/apt.conf.d.bk
fi
if [ -e "/etc/apt/auth.conf.d" ]; then
sudo mv /etc/apt/auth.conf.d /etc/apt/auth.conf.d.bk
fi
if [ -e "/etc/apt/preferences.d" ]; then
sudo mv /etc/apt/preferences.d /etc/apt/preferences.d.bk
fi
if [ -e "/etc/apt/sources.list.d" ]; then
sudo mv /etc/apt/sources.list.d /etc/apt/sources.list.d.bk
fi
if [ -e "trusted.gpg.d" ]; then
sudo mv /etc/apt/trusted.gpg.d /etc/apt/trusted.gpg.d.bk
fi
sudo mkdir -p /opt/tmp/apt
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/tyCN3iK2mAdJAEm/download' -O /opt/tmp/apt/quirinux-apt.tar
sudo tar -xvf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

if [ -e "/etc/apt/sources.list.d/debian.list" ]; then
sudo rm /etc/apt/sources.list.d/debian.list
fi

chown -R root:root /etc/apt

# INSTALAR REPO-CONFIG

sudo mkdir -p /opt/tmp/repo-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/qoP844Zns8niQqK/download' -O /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo apt install /opt/tmp/repo-config/./repo-config-1.0-q2_amd64.deb -y

# ACTIVA REPOSITORIOS NON-FREE CONTRIB Y BACKPORTS DE DEBIAN 

sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/

# INSTALAR COMANDO QUIRINUX-LIBRE

sudo mkdir -p /opt/tmp/quirinux-libre
sudo wget --no-check-certificate 'http://my.opendesktop.org/s/MzGBGDzeLDZHKzS/download' -O /opt/tmp/quirinux-libre/quirinux-libre.deb
sudo apt install /opt/tmp/quirinux-libre/./quirinux-libre.deb -y

sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
sudo apt-get update -y

# BORRA REPO REPETIDO

if [ -e "/etc/apt/sources.list.d/debian.list" ]; then
sudo rm /etc/apt/sources.list.d/debian.list
fi

}

function _firmwareWifi()
{

# INSTALAR FIRMWARE (CONTROLADORES PRIVATIVOS)

sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/fMd6psxCXepG9fd/download' -O /opt/tmp/quirinux-firmware.tar
sudo tar -xvf /opt/tmp/quirinux-firmware.tar -C /opt/tmp/
sudo apt install /opt/tmp/quirinux-firmware/./* -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Nsa3B5GkeDp3yRk/download' -O /opt/tmp/quirinux-i915-q2_amd64.deb
sudo apt install /opt/tmp/./quirinux-i915-q2_amd64.deb -y
for paquetes_firmware in firmware-linux firmware-linux-nonfree hdmi2usb-fx2-firmware firmware-ralink firmware-realtek firmware-intelwimax firmware-iwlwifi firmware-b43-installer firmware-b43legacy-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-atheros dahdi-firmware-nonfree dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 hdmi2usb-fx2-firmware nxt-firmware sigrok-firmware-fx2lafw dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 dahdi-firmware-nonfree nxt-firmware sigrok-firmware-fx2lafw; do sudo apt-get install -y $paquetes_firmware; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _codecs()
{

# INSTALAR CODECS Y FORMATOS PRIVATIVOS

sudo mkdir -p /opt/tmp/rar
sudo wget  --no-check-certificate 'https://my.opendesktop.org/s/AyRyqwg67fRmCJF/download' -O /opt/tmp/rar/rar.deb
sudo apt install /opt/tmp/rar/./rar.deb -y

for paquetes_codecs in mint-meta-codecs unace-nonfree rar unrar; do sudo apt-get install -y $paquetes_codecs; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresNvidia()
{

# INSTALAR CONTROLADORES LIBRES DE NVIDIA

for paquetes_nvidia in bumblebee; do sudo apt-get install -y $paquetes_nvidia; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _libresWacom()
{

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS WACOM

sudo apt-get install build-essential autoconf linux-headers-$uname -u -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Cp4yR3tt9gHeFEH/download' -O /opt/tmp/input-wacom-0.46.0.tar.bz2
cd /opt/tmp
tar -xjvf /opt/tmp/input-wacom-0.46.0.tar.bz2 
cd input-wacom-0.46.0 
if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresGenius()
{

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS GENIUS

sudo mkdir -p /opt/tmp/quirinux-genius
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/LD8wnWefdNpDsSo/download' -O /opt/tmp/quirinux-genius/quirinux-genius-1.0-q2_amd64.deb
sudo apt install /opt/tmp/./quirinux-genius/quirinux-genius-1.0-q2_amd64.deb -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/X6S6zKycQEy9ygd/download' -O /opt/tmp/quirinux-genius/wizardpen_0.7.0-alpha2_i386.deb
sudo apt install /opt/tmp/./quirinux-genius/wizardpen_0.7.0-alpha2_i386.deb -y

}

function _libresImpresoras()
{

# INSTALAR PAQUETES DE IMPRESIÓN Y ESCANEO LIBRES

for paquetes_scaner_impresion in cups cups-pdf ink autoconf git wget avahi-utils system-config-printer-udev colord  flex g++ libtool python-dev sane sane-utils system-config-printer system-config-printer-udev unpaper xsltproc zlibc foomatic-db-compressed-ppds ghostscript-x ghostscript-cups gocr-tk gutenprint-locales openprinting-ppds printer-driver-brlaser printer-driver-all printer-driver-cups-pdf cups-client cups-bsd cups-filters cups-pdf cups-ppdc printer-driver-c2050 printer-driver-c2esp printer-driver-cjet printer-driver-dymo printer-driver-escpr  printer-driver-fujixerox printer-driver-gutenprint printer-driver-m2300w printer-driver-min12xxw printer-driver-pnm2ppa printer-driver-ptouch printer-driver-pxljr printer-driver-sag-gdi printer-driver-splix; do sudo apt-get install -y $paquetes_scaner_impresion; done
sudo apt-get install -f -y

sudo apt-get remove --purge hplip cups-filters cups hplip-data system-config-printer-udev -y
sudo apt-get remove --purge hplip -y
sudo rm -rf /var/lib/hp
sudo apt-get install printer-driver-foo2zjs printer-driver-foo2zjs-common -y
sudo apt-get install tix groff dc cups cups-filters -y
sudo getweb 1018
sudo getweb 2430   
sudo getweb 2300  
sudo getweb 2200    
sudo getweb cpwl    
sudo getweb 1020  
sudo getweb 1018    
sudo getweb 1005     
sudo getweb 1000
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

sudo mkdir -p /opt/tmp/epson
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/BD3dowKgjdsPw9W/download' -O /opt/tmp/epson/epsonscan.tar
cd /opt/tmp/epson
sudo tar -xvf epsonscan.tar 
./install.sh
sudo rm -rf /opt/tmp/*

}

function _libresRed()
{

# INSTALAR PAQUETES DE RED LIBRES

for paquetes_red in mobile-broadband-provider-info pppconfig hardinfo modemmanager modem-manager-gui modem-manager-gui-help usb-modeswitch usb-modeswitch-data wvdial; do sudo apt-get install -y $paquetes_red; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresAMD()
{

# INSTALAR CONTROLADORES DE VIDEO AMD LIBRES

for paquetes_amd in mesa-opencl-icd mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers libdrm-amdgpu1 xserver-xorg-video-amdgpu; do sudo apt-get install -y $paquetes_amd; done
sudo apt-get install -f
sudo apt-get autoremove --purge -y

}

function _programasGeneral()
{

_baseBusterGeneral
_ptxconf
_chimiboga
_samba
_utiles
_olive
_GIMP
_aqemu
_widc
_mint
_salvapantallas
_fuentes
_temas
_red
_pulseaudio

}

function _instalarPro()
{
clear
_instalarGeneral		
_baseBusterPro
_tipografiasPro
_especializadosPro
}

function _baseBusterGeneral()
{

# INSTALAR PAQUETES BASE DE BUSTER

for paquetes_buster in firefox firefox-l10n-de firefox-l10n-es firefox-l10n-fr firefox-l10n-gl firefox-l10n-ru firefox-l10n-it firefox-l10n-pt converseen bluetooth h264enc bluez gvfs-backends bluez-cups bluez-obexd libbluetooth-dev libbluetooth3 blueman connman bluez-firmware conky conky-all libimobiledevice-utils kcharselect kpat thunderbird thunderbid-l10n-de thunderbid-l10n-es-es thunderbid-l10n-fr thunderbid-l10n-gl thunderbid-l10n-it thunderbid-l10n-pt-br thunderbid-l10n-pt-ptthunderbid-l10n-ru thunderbid-l10n-es-ar xdemineur default-jre cairo-dock cairo-dock-plug-ins chromium dia tumbler tumbler-plugins-extra ffmpegthumbnailer xpat ktorrent photopc usermode go-mtpfs pdfarranger build-essential gtk3-engines-xfce make automake cmake engrampa python-glade2 shotwell xinput-calibrator libsox-fmt-mp3 gvfs-fuse breeze-icon-theme-rcc libsmbclient python-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs smbclient python-smbc breeze lightdm liblensfun-bin galculator gufw pacpl kde-config-tablet imagemagick x264 vlc-plugin-vlsub gnome-system-tools ffmpeg audacity onboard kolourpaint mtp-tools   xinput gparted font-manager hdparm prelink unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full p7zip-rar gzip lzip screenkey kazam gdebi bumblebee brasero breeze-icon-theme zip abr2gbr gtkam-gimp gphoto2 gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings vlc gdebi simple-scan ifuse kdeconnect menulibre catfish bleachbit prelink packagekit packagekit-tools; do sudo apt-get install -y $paquetes_buster; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _ptxconf()
{

# INSTALAR UTILIDAD PTXCONF (MAPPING)

sudo mkdir -p /opt/tmp/ptxtemp
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/ajaj7dRJFp8PJFK/download' -O /opt/tmp/ptxtemp/ptxconf.tar
sudo tar -xvf /opt/tmp/ptxtemp/ptxconf.tar -C /opt/
cd /opt/ptxconf
sudo python setup.py install
sudo apt-get install -f -y
sudo apt-get install libappindicator1 -y
sudo mkdir -p /opt/tmp/python-appindicator
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/gfCdMmfLaX627rj/download' -O /opt/tmp/python-appindicator/python-appindicator_0.4.92-4_amd64.deb
sudo apt install /opt/tmp/python-appindicator/./python-appindicator_0.4.92-4_amd64.deb -y

# Agrega entrada al inicio para PTXCONFIG

for usuarios_ptx in /home/*; do sudo yes | sudo cp -r -a -f /opt/ptxconf/.config $usuarios_ptx; done

}

function _chimiboga()
{

# INSTALAR CHIMIBOGA - CHIMI VIDEOJUEGO

sudo mkdir -p /opt/tmp/chimiboga
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Hmy6qMkGcR8TZdE/download' -O /opt/tmp/chimiboga/chimiboga.deb
sudo apt install /opt/tmp/chimiboga/./chimiboga.deb -y

}

function _samba()
{

# INSTALAR SAMBA Y CONFIGURADOR PARA SAMBA DE UBUNTU

sudo apt-get install samba -y
sudo mkdir -p /opt/tmp/samba
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DH3fbW6oMXPQfqF/download' -O /opt/tmp/samba/system-config-samba_1.2.63-0ubuntu6_all.deb
sudo apt install /opt/tmp/samba/./system-config-samba_1.2.63-0ubuntu6_all.deb -y
sudo touch /etc/libuser.conf

}

function _utiles()
{

# INSTALAR MUGSHOT

sudo mkdir -p /opt/tmp/mugshot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/gQydJFz5qcYBXYf/download' -O /opt/tmp/mugshot/mugshot_0.4.2-1_all.deb
sudo apt install /opt/tmp/mugshot/./mugshot_0.4.2-1_all.deb -y

# INSTALAR CONVERSOR MYSTIQ DESDE OPENSUSE

for paquetes_mystiq in mystiq; do sudo apt-get install -y $paquetes_mystiq; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR PLUGIN PARA DESCARGAR VIDEOS EN FIREFOX

sudo mkdir -p /opt/tmp/video-downloader
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DHsA7oxmBQw8adb/download' -O /opt/tmp/video-downloader/net.downloadhelper.coapp-1.5.0-1_amd64.deb
sudo apt install /opt/tmp/video-downloader/./net.downloadhelper.coapp-1.5.0-1_amd64.deb -y

# INSTALAR DENSIFY (para reducir archivos PDF)

sudo mkdir -p /opt/tmp/densify
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/bp8pYAKSXKQ7dFZ/download' -O /opt/tmp/densify/densify-0.3.1-q2_amd64.deb
sudo apt install /opt/tmp/densify/./densify-0.3.1-q2_amd64.deb -y

# INSTALAR IMAGINE (para reducir imágenes)

sudo mkdir -p /opt/tmp/imagine
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/xeTmnR4JGgzJnTE/download' -O /opt/tmp/imagine/imagine-0.5.1-q2_amd64.deb
sudo apt install /opt/tmp/imagine/./imagine-0.5.1-q2_amd64.deb -y

# INSTALAR OPENBOARD (Convierte la pantalla en una pizarra)

sudo mkdir -p /opt/tmp/openboard
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/t7rC79ZSXwpipRW/download' -O /opt/tmp/openboard/openboard_1.3.0_amd64.deb
sudo apt install /opt/tmp/openboard/./openboard_1.3.0_amd64.deb -y

# INSTALAR PROGRAMA PARA CONFIGURAR EL RENDIMIENTO DEL PROCESADOR

for paquetes_cpu in cpufrequtils; do sudo apt-get install -y $paquetes_cpu; done 
sudo apt-get install -f
sudo mkdir -p /opt/tmp/cpu
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/KkH8atxtWTPLXdy/download' -O /opt/tmp/cpu/cpufreq_42-1_all.deb
sudo apt install /opt/tmp/cpu/./*.deb -y

}

function _olive()
{

# INSTALAR EDITOR DE VIDEO OLIVE

sudo mkdir -p /opt/tmp/olive
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Tg9AZJf6R8ffFqD/download' -O /opt/tmp/olive/olive-quirinux.deb
sudo apt install /opt/tmp/olive/./olive-quirinux.deb -y
}

function _GIMP()
{

# Desinstalar GIMP desde snap y flatpak

sudo snap remove gimp -y
sudo flatpak uninstall org.gimp.GIMP && flatpak uninstall --unused -y

# INSTALAR GIMP 2.10 DESDE BUSTER

for paquetes_gimp in gimp gimp-data gimp-gap gimp-gluas gimp-gmic gimp-gutenprint gimp-plugin-registry gimp-python gimp-texturize gimp-ufraw; do sudo apt-get install -y $paquetes_gimp; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR CONVERSOR PARA GIMP EDICIÓN QUIRINUX

sudo mkdir -p /opt/tmp/gimp/
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GHyPZZz9MgX7sdJ/download' -O /opt/tmp/gimp/gimp-quirinux.deb
sudo apt install /opt/tmp/gimp/./gimp-quirinux.deb -y

sudo chmod 755 -R /home/

sudo rm -rf /home/*/.config/GIMP
sudo rm -rf /root/.config/GIMP 
sudo rm -rf /usr/share/gimp 
sudo rm -rf /etc/skel/.config/GIMP 

for usuarios in /home/*; do sudo yes | sudo cp -r /opt/gimp-quirinux/gimp-shop/.config $usuarios; done

sudo yes | sudo cp -rf /opt/gimp-quirinux/gimp-shop/.config /root/ 
sudo yes | sudo cp -rf /opt/gimp-quirinux/gimp-shop/.config /etc/skel/ 
sudo yes | sudo cp -rf /opt/gimp-quirinux/gimp-shop/usr/share /usr/

sudo chmod 755 -R /home/
}

function _aqemu()
{

# INSTALAR PAQUETES DE VIRTUALIZACIÓN

for paquetes_virtualizacion in aqemu qemu-kvm qemu-system-data qemu-block-extra intel-microcode amd-microcode qemu-system libvirt; do sudo apt-get install -y $paquetes_virtualizacion; done
sudo apt-get install -f -y

}

function _wicd()
{

# INSTALAR WICD

for paquetes_wicd in wicd; do sudo apt-get install -y $paquetes_wicd; done
for paquetes_nm in network-manager; do sudo apt-get autoremove --purge -y $paquetes_nm; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _mint()
{

# INSTALAR MINTBACKUP, MINTUPDATE y TIMESHIFT

for paquetes_extra in mintbackup mintupdate timeshift; do sudo apt-get install -y $paquetes_extra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y


# REINSTALA REPOS LIBRES (por si minstources los desconfiguró).

if [ -e "/etc/apt/sources.list.d/debian.list" ]; then
sudo rm /etc/apt/sources.list.d/debian.list
fi

if [ -e "/etc/apt/apt.conf.d" ]; then
sudo mv /etc/apt/apt.conf.d /etc/apt/apt.conf.d.bk
fi
if [ -e "/etc/apt/auth.conf.d" ]; then
sudo mv /etc/apt/auth.conf.d /etc/apt/auth.conf.d.bk
fi
if [ -e "/etc/apt/preferences.d" ]; then
sudo mv /etc/apt/preferences.d /etc/apt/preferences.d.bk
fi
if [ -e "/etc/apt/sources.list.d" ]; then
sudo mv /etc/apt/sources.list.d /etc/apt/sources.list.d.bk
fi
if [ -e "trusted.gpg.d" ]; then
sudo mv /etc/apt/trusted.gpg.d /etc/apt/trusted.gpg.d.bk
fi
sudo mkdir -p /opt/tmp/apt
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/tyCN3iK2mAdJAEm/download' -O /opt/tmp/apt/quirinux-apt.tar
sudo tar -xvf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

if [ -e "/etc/apt/sources.list.d/debian.list" ]; then
sudo rm /etc/apt/sources.list.d/debian.list
fi

}

function _centro()

{
# INSTALAR GESTOR DE PAQUETES DE MINT SIN FLATPAK

sudo apt-get upgrade -y
sudo apt-get dist-ugprade -y
sudo apt-get install mintinstall -y
sudo apt-get autoremove --purge flatpak -y

# INSTALAR FLATPAK-CONFIG

sudo mkdir -p /opt/tmp/flatpak-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/wwBY7B6rayeGQEw/download' -O /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo apt install /opt/tmp/flatpak-config/./quirinux-flatpak-1.0-q2_amd64.deb -y

}

function _salvapantallas()
{

# INSTALAR SCREENSAVER GLUCLO

for paquetes_screensaver in xscreensaver xscreensaver-gl-extra xscreensaver-data-extra build-essential libsdl1.2-dev libsdl-ttf2.0-dev libsdl-gfx1.2-dev libx11-dev; do sudo apt-get install -y $paquetes_screensaver; done
for paquetes_gnome_screensaver in gnome-screensaver; do sudo apt-get remove --purge -y $paquetes_gnome_screensaver; done
sudo mkdir -p /opt/tmp/screensaver
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/mEEcg2a7GrcLAx3/download' -O /opt/tmp/screensaver/gluqlo-master.tar
cd /opt/tmp/screensaver
sudo tar -xvf /opt/tmp/screensaver/gluqlo-master.tar
cd /opt/tmp/screensaver/gluqlo-master
make && sudo make install
for usuarios in /home/*/.xscreensaver; do sudo yes | sudo rm $usuarios; done
for usuarios in /home/*; do sudo yes | sudo cp /opt/tmp/screensaver/gluqlo-master/.xscreensaver $usuarios; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _fuentes()
{

# Descargando y copiando fuentes de Quirinux

sudo mkdir -p /opt/tmp
sudo mkdir -p /opt/tmp/fuentes
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/oS7PZ4HqWTkNff7/download' -O /opt/tmp/fuentes/quirinux-fuentes.tar
sudo chmod 777 -R /opt/tmp/fuentes/
sudo chown $USER -R /opt/tmp/fuentes/
sudo tar -xvf /opt/tmp/fuentes/quirinux-fuentes.tar -C /opt/tmp/fuentes
sudo cp -r -a /opt/tmp/fuentes/quirinux-fuentes/* /

# Descargando y copiando fuentes de Quirinux

sudo mkdir -p /opt/tmp
sudo mkdir -p /opt/tmp/fuentes
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/oS7PZ4HqWTkNff7/download' -O /opt/tmp/fuentes/quirinux-fuentes.tar
sudo chmod 777 -R /opt/tmp/fuentes/
sudo chown $USER -R /opt/tmp/fuentes/
sudo tar -xvf /opt/tmp/fuentes/quirinux-fuentes.tar -C /opt/tmp/fuentes
sudo cp -r -a /opt/tmp/fuentes/quirinux-fuentes/* /

}

function _temas()
{


# OTORGANDO PERMISOS PARA MODIFICAR TEMAS

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# Descomentar para borrar los temas actuales:

# sudo rm -rf /usr/share/themes/*
# sudo rm -rf /usr/share/backgrounds/*
# sudo rm -rf /usr/share/desktop-base/*
# sudo rm -rf /usr/share/images/*

# INSTALAR TEMAS DE QUIRINUX

sudo mkdir -p /opt/tmp/temas
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/o7rg7CpARw5CPLA/download' -O /opt/tmp/temas/quirinux-temas.tar
sudo tar -xvf /opt/tmp/temas/quirinux-temas.tar -C /

# INSTALAR ÍCONOS DE QUIRINUX

sudo mkdir -p /opt/tmp/winbugs
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/NAwrJXnZYow9PHS/download' -O /opt/tmp/winbugs/winbugs-icons.deb
sudo apt install /opt/tmp/winbugs/./winbugs-icons.deb -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX')
# También instala menú principal de Quirinux y modifica algunos archivos más.

sudo mkdir -p /opt/tmp/config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/7WPCQjRSCjSMjSz/download' -O /opt/tmp/config/quirinux-config.tar
sudo tar -xvf /opt/tmp/config/quirinux-config.tar -C /opt/tmp/config/
sudo cp -r /opt/tmp/config/quirinux-config/* /
sudo update-grub
sudo update-grub2

# PERSONALIZANDO PANELES DE USUARIO DE QUIRINUX

for usuarios1 in /home/*; do sudo chmod 777 -R $usuarios1; done
for usuarios2 in /home/*; do sudo yes | sudo cp -r -f -a /etc/skel/* $usuarios2; done

# OTORGANDO PERMISOS PARA MODIFICAR CONFIGURACIÓN DE CARPETAS DE USUARIO

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod u+s /usr/sbin/hddtemp

}

function _red()
{

# ELIMINANDO ERRORES DE INICIO (RED

sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >> /etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

}

function _pulseaudio()
{

# REINSTALAR PULSEAUDIO

sudo apt-get remove --purge pulseuadio pavucontrol -y
sudo apt-get clean
sudo apt-get autoremove --purge -y
sudo rm -r ~/.pulse ~/.asound* ~/.pulse-cookie ~/.config/pulse
sudo apt-get install pulseaudio rtkit pavucontrol -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _remover()
{

# REMOVER TRADUCCIONES DE FIREFOX DE IDIOMAS QUE QUIRINUX NO INCLUYE

for paquetes_remover_idiomas_firefox in keditbookmarks firefox-esr-l10n-bn-bd firefox-esr-l10n-bn-in refox-esr-l10n-kn firefox-esr-l10n-kn firefox-esr-l10n-lt firefox-esr-l10n-ml firefox-esr-l10n-ml firefox-esr-l10n-ar firefox-esr-l10n-ast firefox-esr-l10n-be firefox-esr-l10n-bg firefox-esr-l10n-bn firefox-esr-l10n-bs firefox-esr-l10n-ca firefox-esr-l10n-cs firefox-esr-l10n-cy firefox-esr-l10n-da firefox-esr-l10n-el firefox-esr-l10n-eo firefox-esr-l10n-es-cl firefox-esr-l10n-es-mx firefox-esr-l10n-et firefox-esr-l10n-eu firefox-esr-l10n-fa firefox-esr-l10n-fi firefox-esr-l10n-ga-ie firefox-esr-l10n-gu-in firefox-esr-l10n-he firefox-esr-l10n-hi-in firefox-esr-l10n-hr firefox-esr-l10n-hu firefox-esr-l10n-id firefox-esr-l10n-is firefox-esr-l10n-ja firefox-esr-l10n-kk firefox-esr-l10n-km firefox-esr-l10n-ko firefox-esr-l10n-lv firefox-esr-l10n-mk firefox-esr-l10n-mr firefox-esr-l10n-nb-no firefox-esr-l10n-ne-np firefox-esr-l10n-nl firefox-esr-l10n-nn-no firefox-esr-l10n-pa-in firefox-esr-l10n-pl firefox-esr-l10n-ro firefox-esr-l10n-si firefox-esr-l10n-sk firefox-esr-l10n-sl firefox-esr-l10n-sq firefox-esr-l10n-sr firefox-esr-l10n-sv-se firefox-esr-l10n-ta firefox-esr-l10n-te firefox-esr-l10n-th firefox-esr-l10n-tr firefox-esr-l10n-uk firefox-esr-l10n-vi firefox-esr-l10n-zh-cn firefox-esr-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_firefox; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER TRADUCCIONES DE ESCRITORIO DE IDIOMAS QUE QUIRINUX NO INCLUYE

for paquetes_remover_idiomas_task in task-albanian-desktop task-amharic-desktop task-arabic-desktop task-asturian-desktop task-basque-desktop task-belarusian-desktop task-bengali-desktop task-bosnian-desktop task-bulgarian-desktop task-catalan-desktop task-croatian-desktop task-czech-desktop task-danish-desktop task-dutch-desktop task-dzongkha-desktop task-esperanto-desktop task-estonian-desktop task-finnish-desktop task-georgian-desktop task-greek-desktop task-gujarati-desktop task-hindi-desktop task-hungarian-desktop task-icelandic-desktop task-indonesian-desktop task-irish-desktop task-kannada-desktop task-kazakh-desktop task-khmer-desktop task-kurdish-desktop task-latvian-desktop task-lithuanian-desktop task-macedonian-desktop task-malayalam-desktop task-marathi-desktop task-nepali-desktop task-northern-sami-desktop task-norwegian-desktop task-persian-desktop task-polish-desktop task-punjabi-desktop task-romanian-desktop task-serbian-desktop task-sinhala-desktop task-slovak-desktop task-slovenian-desktop task-south-african-english-desktop task-tamil-desktop task-telugu-desktop task-thai-desktop task-turkish-desktop task-ukrainian-desktop task-uyghur-desktop task-vietnamese-desktop task-welsh-desktop task-xhosa-desktop task-chinese-s-desktop; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_task; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER CONJUNTOS DE CARACTERES DE IDIOMAS QUE QUIRINUX NO INCLUYE

for paquetes_remover_idiomas_ibus in inicatalan ipolish idanish idutch ibulgarian icatalan ihungarian ilithuanian inorwegian iswiss iukrainian  ihungarian ilithuanian inorwegian ipolish iukrainian iswiss; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_ibus; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DICCIONARIOS QUE QUIRINUX NO INCLUYE

for paquetes_remover_idiomas_mythes in  myspell-et; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_mythes; done
for paquetes_remover_idiomas_aspell in aspell-hi aspell-ml aspell-mr aspell-pa aspell-ta aspell-te aspell-gu aspell-bn  aspell-no aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-da aspell-el aspell-eo aspell-et aspell-eu aspell-he aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lt aspell-lv aspell-nl aspell-no aspell-pl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-pl aspell-eo aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-cy aspell-el aspell-et aspell-eu aspell-fa aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lv aspell-nl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-uk; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_aspell; done
for paquetes_remover_idiomas_hunspell in hunspell-ar hunspell-ml hunspell-be hunspell-bg hunspell-bs hunspell-ca hunspell-cs hunspell-da hunspell-eu hunspell-gu hunspell-hi hunspell-hr hunspell-hu hunspell-id hunspell-is hunspell-kk hunspell-kmr hunspell-ko hunspell-lt hunspell-lv hunspell-ne hunspell-nl hunspell-ro hunspell-se hunspell-si hunspell-sl hunspell-sr hunspell-sv hunspell-sv-se hunspell-te hunspell-th hunspell-de-at hunspell-de-ch hunspell-de-de hunspell-vi; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_hunspell; done  
for paquetes_remover_idiomas_myspell in myspell-eo myspell-fa myspell-ga myspell-he myspell-nb myspell-nn myspell-sk myspell-sq mythes-cs mythes-de-ch mythes-ne mythes-pl mythes-sk; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_myspell; done
for paquetes_remover_idiomas_hyphen in hyphen-hr hyphen-hu hyphen-lt; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_hyphen; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER FUENTES QUE QUIRINUX NO INCLUYE

for paquetes_remover_idiomas_fonts in fonts-arabeyes fonts-nanum fonts-crosextra-carlito fonts-nanum-coding fonts-tlwg-kinnari-ttf fonts-tlwg-kinnari fonts-thai-tlwg fonts-tlwg* fonts-vlgothic fonts-arphic-ukai fonts-arphic-uming fonts-lohit-knda fonts-lohit-telu fonts-ukij-uyghur; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_fonts; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER IDIOMAS DE LIBRE OFFICE QUE QUIRINUX NO INCLUYE

for paquetes_remover_idiomas_libreoffice in libreoffice-help-ca libreoffice-help-cs libreoffice-help-da libreoffice-help-dz libreoffice-help-el  libreoffice-help-et libreoffice-help-eu libreoffice-help-fi libreoffice-help-gl libreoffice-help-hi libreoffice-help-hu libreoffice-help-ja libreoffice-help-km libreoffice-help-ko libreoffice-help-nl libreoffice-help-pl libreoffice-help-sk libreoffice-help-sl libreoffice-help-sv libreoffice-help-zh-cn libreoffice-help-zh-tw fonts-linuxlibertine fonts-droid-fallback fonts-noto-mono libreoffice-l10n-ar libreoffice-l10n-ast libreoffice-l10n-be libreoffice-l10n-bg libreoffice-l10n-bn libreoffice-l10n-bs libreoffice-l10n-ca libreoffice-l10n-cs libreoffice-l10n-da libreoffice-l10n-dz libreoffice-l10n-el libreoffice-l10n-en-za libreoffice-l10n-eo libreoffice-l10n-et libreoffice-l10n-eu libreoffice-l10n-fa libreoffice-l10n-fi libreoffice-l10n-ga libreoffice-l10n-gu libreoffice-l10n-he libreoffice-l10n-hi libreoffice-l10n-hr libreoffice-l10n-hu libreoffice-l10n-id libreoffice-l10n-islibreoffice-l10n-ja libreoffice-l10n-kalibreoffice-l10n-km libreoffice-l10n-ko libreoffice-l10n-lt libreoffice-l10n-lv libreoffice-l10n-mk libreoffice-l10n-ml libreoffice-l10n-mr libreoffice-l10n-nb libreoffice-l10n-ne libreoffice-l10n-nl libreoffice-l10n-nnlibreoffice-l10n-pa-in libreoffice-l10n-pl libreoffice-l10n-ro libreoffice-l10n-si libreoffice-l10n-sk libreoffice-l10n-sl libreoffice-l10n-srlibreoffice-l10n-sv libreoffice-l10n-ta libreoffice-l10n-te libreoffice-l10n-th libreoffice-l10n-tr libreoffice-l10n-ug libreoffice-l10n-uk libreoffice-l10n-vi libreoffice-l10n-xh libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_libreoffice; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER PROGRAMAS QUE QUIRINUX NO INCLUYE

for paquetes_remover_programas in xsane xarchiver grsync jami blender dia gsmartcontrol ophcrack ophcrack-cli whowatch htop zulucrypt-cli zulucrypt-cli balena-etcher-electron keepassxc stacer dino-im dino-im-common etherape eterape-data hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux qassel qassel-data jami jami-daemon liferea liferea-data mumble wahay onionshare qtox signal hydra hydra-gtk bmon grub-customizer spek osmo eom eom-common compton mc mc-data pidgin pidgin-data bluetooth khmerconverter thunderbird fcitx* mozc* webcamoid modem-manager-gui fcitx mlterm-common bluez bluez-firmware culmus synapse apparmor pidgin-otr pidgin-encryption pidgin pidgin-data pidgin-themes pidgin-openpgp libpurple0 dino-im dino-im-common gajim gajim-omemo hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux quassel quassel-data mumble qtox keepassxc mc mc-data osmo exfalso kasumi mlterm parole modem-manager-gui modem-manager-gui-help; do sudo apt-get remove --purge -y $paquetes_remover_programas; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DOCUMENTACIÓN

sudo rm -rf /usr/share/doc/*

}

function _limpiar()
{

# CONFIGURANDO PAQUETES

sudo dpkg --configure -a

# LIMPIANDO CACHE

sudo apt-get clean && sudo apt-get autoclean

# REGENERANDO CACHE

sudo apt-get update --fix-missing

# CONFIGURANDO DEPENDENCIAS

sudo apt-get install -f

sudo apt-get autoremove --purge -y

# LIMPIEZA FINAL (descomentar para crear la iso live)

# sudo rm -rf /var/lib/apt/lists/lock/* 
# sudo rm -rf /var/cache/apt/archives/lock/* 
# sudo rm -rf /var/lib/dpkg/lock/*
# sudo rm -rf /lib/live/mount/rootfs/*
# sudo rm -rf /lib/live/mount/*
# sudo rm -rf /var/cache/apt/archives/*.deb
# sudo rm -rf /var/cache/apt/archives/partial/*.deb
# sudo rm -rf /var/cache/apt/partial/*.deb
# sudo rm -rf /opt/tmp/*
# sudo rm -rf /.git
}

function _baseBusterPro()
{

# INSTALAR PAQUETES ESPECIALIZADOS DESDE BUSTER (KRITA, OBS, SYNFIG, XSANE, ETC)

for paquetes_estandar in manuskript sweethome3d kdenlive guvcview xsane digikam k3d gnome-color-manager aegisub dispcalgui birdfont skanlite pencil2d devede vokoscreen-ng soundconverter hugin calf-plugins invada-studio-plugins-ladspa vlc-plugin-fluidsynth fluidsynth synfig synfigstudio synfig-examples pikopixel.app entangle darktable rawtherapee krita krita-data krita-gmic krita-l10n dvd-styler obs-studio obs-plugins gir1.2-entangle-0.1; do sudo apt-get install -y $paquetes_estandar; done
sudo apt-get install -f -y

}

function _tipografiasPro()
{

# INSTALAR TIPOGRAFÍAS PARA DIBUJANTES

sudo mkdir -p /opt/tmp/komika
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/eQrxHfx5QeeQtAL/download' -O /opt/tmp/komika/quirinu-komika.deb
sudo apt install /opt/tmp/godot/./godot-2.3.3-q2_amd64.deb -y
sudo apt-get autoremove --purge -y

}

function _especializadosPro()
{

# INSTALANDO INKSCAPE

for paquetes_remover_inkscape in inkscape; do sudo apt-get remove --purge -y $paquetes_remover_inkscape; done
sudo mkdir -p /opt/tmp/inkscape
sudo wget --no-check-certificate 'http://my.opendesktop.org/s/7BWLio7HC4Rga3J/download' -O /opt/tmp/inkscape/inkscape-1.0-q2_amd64.deb
sudo apt install /opt/tmp/inkscape/./inkscape-1.0-q2_amd64.deb -y

# INSTALAR TUPITUBE

sudo mkdir -p /opt/tmp/tupitube
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Zrce88JXLRjiqXF/download' -O /opt/tmp/tupitube/tupitube-desk-0.2.17-q2_amd64.deb
sudo apt install /opt/tmp/tupitube/./tupitube-desk-0.2.17-q2_amd64.deb -y

# INSTALAR GODOT

sudo mkdir -p /opt/tmp/godot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/w3R2NzrwwSMxPXC/download' -O /opt/tmp/godot/godot-2.3.3-q2_amd64.deb
sudo apt install /opt/tmp/godot/./godot-2.3.3-q2_amd64.deb -y

# INSTALAR STORYBOARDER

sudo mkdir -p /opt/tmp/storyboarder
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GePzTyxoYpM622t/download' -O /opt/tmp/storyboarder/storyboarder-2.0.0-q2_amd64.deb
sudo apt install /opt/tmp/storyboarder/./storyboarder-2.0.0-q2_amd64.deb -y

# INSTALAR KITSCENARIST
sudo mkdir -p /opt/tmp/kitscenarist
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/26WpWbDH5g5nC6k/download' -O /opt/tmp/kitscenarist/kitscenarist64.deb
sudo apt install /opt/tmp/kitscenarist/./kitscenarist64.deb -y

# INSTALAR NATRON

sudo mkdir -p /opt/tmp/natron
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/zBY3tinXbQpqDbB/download' -O /opt/tmp/natron/natron-2.3.15-q2_amd64.deb
sudo apt install /opt/tmp/natron/./natron-2.3.15-q2_amd64.deb -y

# INSTALAR AZPAINTER

sudo mkdir -p /opt/tmp/azpainter
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/AojjBiP7NmoSBsA/download' -O /opt/tmp/azpainter/azpainter-2.1.4-q2_amd64.deb
sudo apt install /opt/tmp/azpainter/./azpainter-2.1.4-q2_amd64.deb -y

# INSTALAR ENVE

sudo mkdir -p /opt/tmp/enve
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GAyMB7pt5K9MXnx/download' -O /opt/tmp/enve/enve-0.0.0-q2_amd64.deb
sudo apt install /opt/tmp/enve/./enve-0.0.0-q2_amd64.deb -y

# INSTALAR QUINEMA

sudo mkdir -p /opt/tmp/quinema
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/zREfipBzSxYXFTK/download' -O /opt/tmp/quinema/quinema_1.0-q2_amd64.deb
sudo apt install /opt/tmp/quinema/./quinema_1.0-q2_amd64.deb -y

# INSTALAR QSTOPMOTION

sudo mkdir -p /opt/tmp/qstopmotion
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/MznJgLCFeWeQMGd/download' -O /opt/tmp/qstopmotion/qstopmotion-2.5.0-q2_amd64.deb
sudo apt install /opt/tmp/qstopmotion/./qstopmotion-2.5.0-q2_amd64.deb -y

# INSTALAR CONTROLADORES PARA CÁMARAS VIRTUALES
# Complemento útil para qStopMotion

sudo mkdir -p /opt/tmp/akvcam
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/2BL5CgEa3YgMx2g/download' -O /opt/tmp/akvcam/akvcam-1.0-q2_amd64.deb
sudo chmod 777 -R /opt/tmp/akvcam/
sudo apt install /opt/tmp/akvcam/./akvcam-1.0-q2_amd64.deb -y

# INSTALAR BELLE

sudo mkdir -p /opt/tmp/belle
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/pQw6Yyytaz8TQ46/download' -O /opt/tmp/belle/belle-0.7-q2_amd64.deb
sudo apt install /opt/tmp/belle/./belle-0.7-q2_amd64.deb -y

# INSTALAR MYPAINT

sudo mkdir -p /opt/tmp/mypaint
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/TZL8554kj8HLjsK/download' -O /opt/tmp/mypaint/mypaint-2-q2_amd64.deb
sudo apt install /opt/tmp/mypaint/./mypaint-2-q2_amd64.deb -y

# INSTALAR EDITOR DE VIDEO PROFESIONAL CINELERRA

mkdir -p /opt/tmp/cinelerra
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/FK6xp4k38b9H3BT/download' -O /opt/tmp/cinelerra/cinelerra.deb
sudo apt install /opt/tmp/cinelerra/./cinelerra.deb -y
sudo rm -rf /opt/tmp/*

# DESCARGAR Y COMPILAR OPENTOONZ

# Instala dependencias del instalador de OpenToonz

sudo apt-get update -y
for paquetes_wget in wget git software-properties-common; do sudo apt-get install -y $paquetes_wget; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Instala dependencias de OpenToonz

sudo apt-get update -y
for paquetes_opentoonz in build-essential git cmake pkg-config libboost-all-dev qt5-default qtbase5-dev libqt5svg5-dev qtscript5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev qtmultimedia5-dev libsuperlu-dev liblz4-dev libusb-1.0-0-dev liblzo2-dev libpng-dev libjpeg-dev libglew-dev freeglut3-dev libfreetype6-dev libjson-c-dev qtwayland5 libqt5multimedia5-plugins; do sudo apt-get install -y $paquetes_opentoonz; done
for paquetes_opentoonz2 in libmypaint-dev; do sudo apt-get install -y $paquetes_opentoonz2; done

# Descarga y compila el código fuente de OpenToonz

mkdir -p /opt/tmp/opentoonz
sudo wget  --no-check-certificate 'https://github.com/opentoonz/opentoonz/archive/v1.4.0.tar.gz' -O /opt/tmp/opentoonz/opentoonz-1.4.0.tar.gz
tar -xzvf /opt/tmp/opentoonz/opentoonz-1.4.0.tar.gz -C /opt/tmp/
cd /opt/tmp/opentoonz-1.4.0
mkdir -p $HOME/.config/OpenToonz
cp -r /opt/tmp/opentoonz-1.4.0/stuff $HOME/.config/OpenToonz/
cat << EOF > $HOME/.config/OpenToonz/SystemVar.ini
[General]
OPENTOONZROOT="$HOME/.config/OpenToonz/stuff"
OpenToonzPROFILES="$HOME/.config/OpenToonz/stuff/profiles"
TOONZCACHEROOT="$HOME/.config/OpenToonz/stuff/cache"
TOONZCONFIG="$HOME/.config/OpenToonz/stuff/config"
TOONZFXPRESETS="$HOME/.config/OpenToonz/stuff/projects/fxs"
TOONZLIBRARY="$HOME/.config/OpenToonz/stuff/projects/library"
TOONZPROFILES="$HOME/.config/OpenToonz/stuff/profiles"
TOONZPROJECTS="$HOME/.config/OpenToonz/stuff/projects"
TOONZROOT="$HOME/.config/OpenToonz/stuff"
TOONZSTUDIOPALETTE="$HOME/.config/OpenToonz/stuff/studiopalette"
EOF
cd /opt/tmp/opentoonz-1.4.0/thirdparty/tiff-4.0.3 
./configure --with-pic --disable-jbig
make -j$(nproc)
cd ../../
cd toonz
mkdir build
cd build
cmake ../sources
make -j$(nproc)
sudo make install 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Descarga y copia el ícono del menú de inicio de OpenToonz

sudo mv /opt/opentoonz/bin/opentoonz /opt/opentoonz/bin/opentoonz2
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/FZz85jagrQLCjjB/download' -O /opt/tmp/opentoonz/opentoonz-icon.tar
sudo mv /opt/tmp/opentoonz /opt/tmp/opentoonz-tmp
sudo tar -xvf /opt/tmp/opentoonz-tmp/opentoonz-icon.tar -C /
mv /opt/tmp/opentoonz /opt/opentoonz/opentoonz
cp -r /opentoonz-icon/* /
rm -r /opentoonz-icon/

# Creando comando de inicio de OpenToonz

sudo chmod -R 775 /opt/opentoonz
sudo chown -R $USER /opt/opentoonz

FILE="/usr/local/bin/opentoonz"

FILE="/usr/local/bin/opentoonz"

if [ -f "$FILE" ]; then

sudo rm /usr/local/bin/opentoonz
mv /opt/tmp/opentoonz-tmp/* /opt/opentoonz/bin/
touch /opt/opentoonz/opentoonz
echo "/opt/opentoonz/bin/./opentoonz2" > /opt/opentoonz/opentoonz
cd /usr/local/bin
sudo ln -s /opt/opentoonz/opentoonz
sudo chmod 777 /usr/local/bin/opentoonz

else

mv /opt/tmp/opentoonz-tmp/* /opt/opentoonz/bin/
touch /opt/opentoonz/opentoonz
echo "/opt/opentoonz/bin/./opentoonz2" > /opt/opentoonz/opentoonz
cd /usr/local/bin
sudo ln -s /opt/opentoonz/opentoonz
sudo chmod 777 /usr/local/bin/opentoonz

fi

# Borrar archivos temporales

sudo rm -rf /opt/tmp/*
sudo rm /opt/opentoonz/opentoonz-icon.tar
sudo rm /opt/opentoonz/bin/opentoonz-1.4.0.tar.gz

clear

# INSTALAR TAHOMA 2D

mkdir -p /opt/tmp/tahoma2d
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/MWt7cqqGgQCdYby/download' -O /opt/tmp/tahoma2d/tahoma-1.1-q2_amd64.deb
sudo apt install /opt/tmp/tahoma2d/./*.deb -y

# ACTUALIZANDO BLENDER

for paquetes_remover_blender in remove --purge blender-data; do sudo apt-get remove --purge -y $paquetes_remover_blender; done
sudo mkdir -p /opt/tmp/blender283
sudo apt-get install -f -y
sudo apt-get autoremove --purge -
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/PfagSW43yP9yGiX/download' -O /opt/tmp/blender283/blender-2.83-q2_amd64.deb
sudo apt install /opt/tmp/blender283/./blender-2.83-q2_amd64.deb -y

# INSTALAR ARDOUR 6

sudo mkdir -p /opt/tmp/ardour6
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/YBKRojEoNbM8Nq5/download' -O /opt/tmp/ardour6/ardour6-6.3-q2_amd64.deb
sudo apt install /opt/tmp/ardour6/./ardour6-6.3-q2_amd64.deb -y

# INSTALAR PLUGINS PARA ARDOUR

for paquetes_calf in calf-plugins; do sudo apt-get install -y $paquetes_calf; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# DESCARGAR PLUGIN STOPMO-PREVIEW PARA ENTANGLE
# Luego será necesario ejecutar el comando instalar-plugin-entangle sin permisos de root.

sudo mkdir -p /opt/tmp/
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/kRmqM6HAit8Px2F/download' -O /opt/tmp/entangle-plugin-stopmotion.deb
for paquetes_python in python-gobject; do sudo apt-get install -y $paquetes_python; done
sudo apt-get install python3-gi 
sudo apt install /opt/tmp/./entangle-plugin-stopmotion.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _avisoInicio()
{

echo " -----------------------------------------------------------------------------
 INSTALAR QUIRINUX 2.0 SOBRE DEBIAN 10 (Buster)
 -----------------------------------------------------------------------------
${bold}   ___        _      _                  
  / _ \ _   _ _ _ __ _ _ __  _   _ _  __
 | | | | | | | | '__| | '_ \| | | \ \/ /
 | |_| | |_| | | |  | | | | | |_| |>  < 
  \__\__\__,_|_|_|  |_|_| |_|\__,_/_/\_\ ${normal}
                                       
 
 (p) 2019-2021 Licencia GPLv3, Autor: Charlie Martínez® 
 Página web: https://www.quirinux.org - E-Mail: cmartinez@quirinux.org   "

sleep 1

echo "
 --------------------------------------------------------------------
 | A continuación se instalarán algunos programas que el instalador | 
 | de Quirinux necesita para funcionar y se agregarán, además, algu-|
 | nos repositorios adicionales. Este procedimiento es 100% seguro. |
 --------------------------------------------------------------------"                                               
sleep 0.1

echo "
 1 Continuar
 0 Salir.
"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

_preRequisitos
_instalarDialog
_config
_menuPrincipal

;;

"0")

clear

exit 0

;; 

esac 

}

_inicio
