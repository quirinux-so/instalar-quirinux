#!/bin/bash

# Nombre:	instalar-quirinux.sh
# Autor:	Charlie Martínez® <cmartinez@quirinux.org>
# Licencia:	https://www.gnu.org/licenses/gpl-3.0.txt
# Descripción:	Convierte una instalación limpia de Debian Buster en Quirinux 2.0
# Versión:	1.00-Beta

bold=$(tput bold)
normal=$(tput sgr0)
${bold}
${normal}

clear

echo " -----------------------------------------------------------------------------
 INSTALAR QUIRINUX 2.0 SOBRE DEBIAN 10 (Buster)
 -----------------------------------------------------------------------------
${bold}   ___        _      _                  
  / _ \ _   _ _ _ __ _ _ __  _   _ _  __
 | | | | | | | | '__| | '_ \| | | \ \/ /
 | |_| | |_| | | |  | | | | | |_| |>  < 
  \__\__\__,_|_|_|  |_|_| |_|\__,_/_/\_\ ${normal}
                                       
 
 (p) 2019-2020 Licencia GPLv3, Autor: Charlie Martínez® 
 Página web: https://www.quirinux.org - E-Mail: cmartinez@quirinux.org   "

sleep 1

echo "
 --------------------------------------------------------------------
 | Ejecutar como ROOT. Sólo valido para Debian Buster.              | 
 | El código requiere modificaciones si se pretende usar en Devuan. |
 | ó Ubuntu.                                                        |
 --------------------------------------------------------------------"                                               
sleep 0.1

echo "
 1 Comenzar la instalación (podrás confirmar cada paso).
 0 Salir.
"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR GIT, WGET Y SOFTWARE-PROPERTIES-COMMON
 -----------------------------------------------------------------------------
 Este programa necesitará las utilidades git, wget y 
 software-properties-common  para poder descargar los paquetes que instalará. 
 Si los tienes instalados, puedes saltar este paso. Si no estás seguro/a, 
 elije la opción 1. 








 1 Instalar programas necesarios para el resto de la instalación 
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR WGET, GIT Y SOFTWARE-PROPERTIES-COMMON

sudo apt-get update -y
for paquetes_wget in wget git software-properties-common; do sudo apt-get install -y $paquetes_wget; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: CONFIGURAR EXCEPCIONES NOPASSWD
 -----------------------------------------------------------------------------
 Se crearán los archivos 0pwfeedback, live, mintupdate y quirinux en la 
 carpeta /etc/sudoers.d/conforme vienen en Quirinux 2.0.
 
 Posibilitan que el sistema no requiera contraseñas para tareas cotidianas,
 sobretodo en modo live.


		




 1 Agregar archivos a /etc/sudoers.d/(recomendado).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# CONFIGURACIÓN PREDETERMINADA DE SUDOERS DE QUIRINUX

sudo mkdir -p /opt/tmp/sudoers
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/QiGdK8pC4SjKL8p/download' -O /opt/tmp/sudoers/quirinux-sudoers-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/sudoers/quirinux-sudoers-1.0-q2_amd64.deb
sudo chmod 755 -R /etc/sudoers.d/

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: DESINSTALAR KERNELS ANTERIORES 4.x
 -----------------------------------------------------------------------------
 Si ya instalaste el kernel AVL 5.4.28 de baja latencia que Quirinux trae  
 por defecto y estás ejecutándolo ahora, puedes desinstalar los kernels 
 anteriores.
  
 ${bold} ¡CUIDADO!${normal} Si no lo sabes con exactitud es preferible 
 que te saltes este paso, ya que un error podría dejar inutilizado 
 tu sistema.

 ${bold} TRUCO${normal} Puedes instalar el Kernel AVL 5.4.28 ahora 
 (opción 3). Luego tendrás que reiniciar y retomar la instalación saltando
 hasta este paso. 

 1 Eliminar kernels de Debian Buster ${bold}(¡CUIDADO!)${normal}.
 2 Saltar este paso (recomendado).
 3 Instalar ahora el kernel AVL 5.4.28 (requiere reiniciar).
 0 Salir.


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# SE ELIMINAN LOS KERNELS 4.X

for paquetes_kernels in linux-headers-4* linux-image-4* linux-image-amd64; do sudo apt-get remove --purge -y $paquetes_kernels; done
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"3")

sudo mkdir /opt/tmp

echo "# Download Kernel"; sleep 1s
wget --no-check-certificate 'http://my.opendesktop.org/s/tybe5FaBMjzts4R/download' -O /opt/tmp/linux-image-5.4.28avl2-lowlatency.deb

echo "# Dowload Headers"; sleep 1s
wget  --no-check-certificate 'http://my.opendesktop.org/s/Cx43SWj4w7LrTiY/download' -O /opt/tmp/linux-headers-5.4.28avl2-lowlatency.deb

sudo chmod 777 -R /opt/tmp/
sudo chown $USER /opt/tmp/*

echo "# Instalando el nuevo kernel"; sleep 1s
sudo dpkg -i /opt/tmp/linux-headers-5.4.28avl2-lowlatency.deb 
sudo dpkg -i /opt/tmp/linux-image-5.4.28avl2-lowlatency.deb
sudo apt-get remove --purge cryptsetup-initramfs -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

clear

echo " -----------------------------------------------------------------------------
 NUEVO KERNEL INSTALADO ¡ES NECESARIO REINICIAR!
 -----------------------------------------------------------------------------
 Felicidades, acabas de instalar el kernel de baja latencia AVL 5.4.28 
 compilado por Trulan Martin. El mismo que viene por defecto en la distro
 AV Linux y Quirinux 2.0. 

 Para que tu sistema inicie con este nuevo kernel, es necesario que reinicies
 el ordenador. Luego podrás volver a ejecutar este programa de instalación,
 saltar todos los pasos hasta llegar a ${bold}DESINSTALAR KERNELS ANTERIORES 4.x,${normal}
 elegir la opción 1 (Eliminar kernels de Debian Buster) y continuar con la
 instalación.		



 ¡Hasta luego!




"

exit 0

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: CONFIGURAR CPU PARA MAYOR PERFORMANCE
 -----------------------------------------------------------------------------
 Quirinux está pensado para trabajar en producción, por eso viene con la 
 configuración de CPU establecida para mayor performance.

 ${bold} TRUCO: ${normal}Aunque el modo de mayor performance puede reducir 
 la carga de las baterías en los equipos portátiles, en este paso también 
 se instalará el programa ${bold}CPUFreqManager${normal} con el que podrás 
 cambiar tu preferencia cuando quieras:
 ${bold}columna derecha del programa > Governor${normal}




 1 Configurar CPU para mayor performance (recomendado)
 2 Saltar este paso.
 0 Salir.



"


read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# CONFIGURACIÓN DE RENDIMIENTO PREDETERMINADA DE QUIRINUX

for paquetes_cpu in cpufrequtils; do sudo apt-get install -y $paquetes_cpu; done 
sudo apt-get install -f
sudo mkdir -p /opt/tmp/cpu
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/nkWBfXRo2Xs4kXE/download' -O /opt/tmp/cpu/quirinux-cpu.deb
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/KkH8atxtWTPLXdy/download' -O /opt/tmp/cpu/cpufreq_42-1_all.deb
sudo dpkg -i /opt/tmp/cpu/*.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: ACTIVAR SOPORTE PARA SOFTWARE DE 32 BITS
 -----------------------------------------------------------------------------
 Activar el soporte multiarquitectura (32 bits). Quizás lo necesites a la 
 hora de instalar algun controlador, por ejemplo algún tipo de impresora. 






		



 1 Activar soporte multiarquitectura (recomendado).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# ESTABLECE SOPORTE MULTIARQUITECTURA PARA 32 BITS

sudo dpkg --add-architecture i386

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: AGREGAR REPOSITORIOS ADICIONALES NECESARIOS
 -----------------------------------------------------------------------------
 Para instalar o actualizar el Kernel AVL, el conversor de video Mystiq
 el gestor de software, la utilidad de backup y el editor de video
 profesional de Cinelerra, Quirinux necesita agregar algunos repositorios 
 adicionales, que son 100% libres. 

 
 
 




 1 Agregar los repositorios adicionales necesarios (recomendado).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# AGREGA REPOSITORIOS LIBRES ADICIONALES

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
sudo tar -xf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac  

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: REPO-CONFIG Y REPOSITORIOS NON-FREE CONTRIB Y BACKPORTS
 -----------------------------------------------------------------------------
 Para instalar controladores privativos de hardware, por ejemplo para algunas
 placas WiFi que de otra forma no funcionan, es necesario activar los 
 repositorios non-free y contrib. También para formatos privativos como RAR.

 Los repositorios backports permiten descargar versiones algo más modernas
 del software estable de Debian. 
  
 ${bold} TRUCO: ${normal}En este paso también se instalará el programa  
 Repo-Config con el que siempre podrás modificar tu preferencia
 yendo a: ${bold}Aplicaciones > Sistema > Repo-Config${normal} 
 
  
 1 Instalar Repo-Config y activar non-ree contrib y backports (recomendado).
 2 Saltar este paso.
 3 Sólo instalar Repo-Config.
 0 Salir.


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR REPO-CONFIG

sudo mkdir -p /opt/tmp/repo-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/qoP844Zns8niQqK/download' -O /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo apt-get update -y

# ACTIVA REPOSITORIOS NON-FREE CONTRIB Y BACKPORTS DE DEBIAN 

sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
sudo apt-get update -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# INSTALAR REPO-CONFIG

sudo mkdir -p /opt/tmp/repo-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/qoP844Zns8niQqK/download' -O /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo apt-get update -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR CONTROLADORES LIBRES PARA ACELERADORAS NVIDIA
 -----------------------------------------------------------------------------
 Quirinux trae preinstalados los controladores libres para las tarjetas de  
 video NVidia. Si no los necesitas, puedes saltar este paso.
 









 1 Instalar controladores libres para Nvidia (sólo si los necesitas).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc
 
case $opc in

"1") 

clear

# INSTALAR CONTROLADORES LIBRES DE NVIDIA

sudo apt-get update -y
for paquetes_nvidia in bumblebee; do sudo apt-get install -y $paquetes_nvidia; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR CONTROLADORES PRIVATIVOS 
 -----------------------------------------------------------------------------
 Quirinux trae una gran cantidad de firmware preinstalado, porque fue pensado 
 para funcionar en modo live en la mayor variedad de hardware posible. Puedes 
 saltar este paso si tu hardware (incluyendo placa WiFi) está funcionando 
 bien o si necesitas algún driver específico pero prefieres buscarlo e 
 instalarlo por tu cuenta en lugar de instalar ahora todos los disponibles.

   ${bold}ADVERTENCIA:${normal} Requiere activar non-free y contrib.
 Si instalaste Repo-Config pero no activaste non-free y contrib, puedes 
 activarlos ahora: ${bold}Aplicaciones > Sistema > Repo-Config.${normal} 
 
 

 1 Instalar firmware (recomendado si no te funciona la placa WiFi).
 2 Saltar este paso.
 3 Instalar Repo-Config + activar non-free contrib backports + opción 1.
 0 Salir.


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR FIRMWARE (CONTROLADORES PRIVATIVOS)

sudo apt-get update -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/fMd6psxCXepG9fd/download' -O /opt/tmp/quirinux-firmware.tar
sudo tar -xf /opt/tmp/quirinux-firmware.tar -C /opt/tmp/
sudo dpkg -i /opt/tmp/quirinux-firmware/*
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Nsa3B5GkeDp3yRk/download' -O /opt/tmp/quirinux-i915-q2_amd64.deb
sudo dpkg -i /opt/tmp/quirinux-i915-q2_amd64.deb
for paquetes_firmware in hdmi2usb-fx2-firmware firmware-ralink firmware-realtek firmware-intelwimax firmware-iwlwifi firmware-b43-installer firmware-b43legacy-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-atheros dahdi-firmware-nonfree dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 hdmi2usb-fx2-firmware nxt-firmware sigrok-firmware-fx2lafw dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 dahdi-firmware-nonfree nxt-firmware sigrok-firmware-fx2lafw; do sudo apt-get install -y $paquetes_firmware; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# INSTALAR REPO-CONFIG

sudo mkdir -p /opt/tmp/repo-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/qoP844Zns8niQqK/download' -O /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo apt-get update -y

# ACTIVA REPOSITORIOS NON-FREE CONTRIB Y BACKPORTS DE DEBIAN 

sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
sudo apt-get update -y

# INSTALAR FIRMWARE (CONTROLADORES PRIVATIVOS)

sudo apt-get update -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/fMd6psxCXepG9fd/download' -O /opt/tmp/quirinux-firmware.tar
sudo tar -xf /opt/tmp/quirinux-firmware.tar -C /opt/tmp/
sudo dpkg -i /opt/tmp/quirinux-firmware/*
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Nsa3B5GkeDp3yRk/download' -O /opt/tmp/quirinux-i915-q2_amd64.deb
sudo dpkg -i /opt/tmp/quirinux-i915-q2_amd64.deb
for paquetes_firmware in hdmi2usb-fx2-firmware firmware-ralink firmware-realtek firmware-intelwimax firmware-iwlwifi firmware-b43-installer firmware-b43legacy-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-atheros dahdi-firmware-nonfree dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 hdmi2usb-fx2-firmware nxt-firmware sigrok-firmware-fx2lafw dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 dahdi-firmware-nonfree nxt-firmware sigrok-firmware-fx2lafw; do sudo apt-get install -y $paquetes_firmware; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR CODECS Y FORMATOS PRIVATIVOS 
 -----------------------------------------------------------------------------
 Ciertos codecs privativos son necesarios para reproducir algunos formatos 
 como Adobe Flash y trabajar con archivos comprimidos con extensión .rar.
 Si piensas que los necesitarás, puedes instalarlos ahora.

   ${bold}ADVERTENCIA:${normal} Requiere activar non-free y contrib.
 Si instalaste Rrepo-Config pero no activaste non-free y contrib, puedes 
 activarlos ahora: ${bold}Aplicaciones > Sistema > Repo-Config.${normal} 
 
 



 1 Instalar codecs y formatos privativos.
 2 Saltar este paso.
 3 Instalar Repo-Config + activar non-free contrib backports + opción 1.
 0 Salir.


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR CODECS Y FORMATOS PRIVATIVOS

sudo apt-get update -y
for paquetes_codecs in pepperflashplugin-nonfree browser-plugin-freshplayer-pepperflash mint-meta-codecs unace-nonfree rar unrar; do sudo apt-get install -y $paquetes_codecs; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"3")

clear

# INSTALAR REPO-CONFIG

sudo mkdir -p /opt/tmp/repo-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/qoP844Zns8niQqK/download' -O /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo apt-get update -y

# ACTIVA REPOSITORIOS NON-FREE CONTRIB Y BACKPORTS DE DEBIAN 

sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
sudo apt-get update -y

# INSTALAR CODECS Y FORMATOS PRIVATIVOS

sudo apt-get update -y
for paquetes_codecs in pepperflashplugin-nonfree browser-plugin-freshplayer-pepperflash mint-meta-codecs unace-nonfree rar unrar; do sudo apt-get install -y $paquetes_codecs; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR PROGRAMAS DE USO GENERAL
 -----------------------------------------------------------------------------
 Instalación de diversos programas de uso general. Esta base viene 
 preinstalada en todas las ediciones de Quirinux 2.0. y fusiona utilidades 
 de Mint y Opensuse con Debian y algunas extra como imagine, pdfarranger y 
 video-downloader, entre otras.

  ${bold}ADVERTENCIA:${normal} Requiere los repositorios adicionales. 
 Si no los agregaste al comienzo de instalación, puedes hacerlo ahora 
 (opción 3). 




 1 Instalar paquetes base (recomendado)
 2 Saltar este paso.
 3 Agregar los repositorios adicionales necesarios + opción 1.
 0 Salir.


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR PAQUETES BASE DE BUSTER

sudo apt-get update -y
for paquetes_buster in figlet photopc openshot usermode cheese cheese-common libcheese-gtk25 libcheese8 go-mtpfs pdfarranger plank build-essential gtk3-engines-xfce make automake cmake engrampa python-glade2 k3d thunderbird shotwell xinput-calibrator libsox-fmt-mp3 gvfs-fuse breeze-icon-theme-rcc libsmbclient python-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs smbclient python-smbc breeze aegisub lightdm samba gnome-color-manager liblensfun-bin galculator gufw pacpl kde-config-tablet imagemagick x264 vlc-plugin-vlsub gnome-system-tools ffmpeg audacity onboard kolourpaint mtp-tools dconf-editor xinput gparted font-manager hdparm prelink unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full p7zip-rar gzip lzip digikam screenkey kazam gdebi audacious bumblebee rapid-photo-downloader bumblebee brasero breeze-icon-theme zip abr2gbr gtkam-gimp gphoto2 gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings audacious vlc gdebi simple-scan gir1.2-entangle-0.1 ifuse kdeconnect menulibre dispcalgui catfish bleachbit prelink packagekit packagekit-tools; do sudo apt-get install -y $paquetes_buster; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR PAQUETES ACTUALIZABLES

for paquetes_actualizables in ardour inkscape; do sudo apt-get install -y $paquetes_actualizables; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR EXTRAS DE MINT Y OPENSUSE

for paquetes_extra in mintbackup mystiq; do sudo apt-get install -y $paquetes_extra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR CONFIGURADOR PARA SAMBA DE UBUNTU

sudo mkdir -p /opt/tmp/samba
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DH3fbW6oMXPQfqF/download' -O /opt/tmp/samba/system-config-samba_1.2.63-0ubuntu6_all.deb
sudo dpkg -i /opt/tmp/samba/system-config-samba_1.2.63-0ubuntu6_all.deb
sudo apt-get install -f -y
sudo touch /etc/libuser.conf

# INSTALAR MUGSHOT

sudo mkdir -p /opt/tmp/mugshot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/gQydJFz5qcYBXYf/download' -O /opt/tmp/mugshot/mugshot_0.4.2-1_all.deb
sudo dpkg -i /opt/tmp/mugshot/mugshot_0.4.2-1_all.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR PLUGIN PARA DESCARGAR VIDEOS EN FIREFOX

sudo mkdir -p /opt/tmp/video-downloader
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DHsA7oxmBQw8adb/download' -O /opt/tmp/video-downloader/net.downloadhelper.coapp-1.5.0-1_amd64.deb
sudo dpkg -i /opt/tmp/video-downloader/net.downloadhelper.coapp-1.5.0-1_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR DENSIFY (PARA REDUCIR ARCHIVOS PDF

sudo mkdir -p /opt/tmp/densify
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/bp8pYAKSXKQ7dFZ/download' -O /opt/tmp/densify/densify-0.3.1-q2_amd64.deb
sudo dpkg -i /opt/tmp/densify/densify-0.3.1-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR IMAGINE (PARA REDUCIR IMÁGENES

sudo mkdir -p /opt/tmp/imagine
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/xeTmnR4JGgzJnTE/download' -O /opt/tmp/imagine/imagine-0.5.1-q2_amd64.deb
sudo dpkg -i /opt/tmp/imagine/imagine-0.5.1-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# AGREGA REPOSITORIOS LIBRES ADICIONALES NECESARIOS

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
sudo tar -xf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

# INSTALAR PAQUETES BASE DE BUSTER

for paquetes_buster in figlet photopc openshot usermode cheese cheese-common libcheese-gtk25 libcheese8 go-mtpfs pdfarranger plank build-essential gtk3-engines-xfce make automake cmake engrampa python-glade2 k3d thunderbird shotwell xinput-calibrator libsox-fmt-mp3 gvfs-fuse breeze-icon-theme-rcc libsmbclient python-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs smbclient python-smbc breeze aegisub lightdm samba gnome-color-manager liblensfun-bin galculator gufw pacpl kde-config-tablet imagemagick x264 vlc-plugin-vlsub gnome-system-tools ffmpeg audacity onboard kolourpaint mtp-tools dconf-editor xinput gparted font-manager hdparm prelink unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full p7zip-rar gzip lzip digikam screenkey kazam gdebi audacious bumblebee rapid-photo-downloader bumblebee brasero breeze-icon-theme zip abr2gbr gtkam-gimp gphoto2 gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings audacious vlc gdebi simple-scan gir1.2-entangle-0.1 ifuse kdeconnect menulibre dispcalgui catfish bleachbit prelink packagekit packagekit-tools; do sudo apt-get install -y $paquetes_buster; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR PAQUETES ACTUALIZABLES

for paquetes_actualizables in ardour inkscape; do sudo apt-get install -y $paquetes_actualizables; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR EXTRAS DE MINT Y OPENSUSE

for paquetes_extra in mintbackup mystiq; do sudo apt-get install -y $paquetes_extra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR CONFIGURADOR PARA SAMBA DE UBUNTU

sudo mkdir -p /opt/tmp/samba
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DH3fbW6oMXPQfqF/download' -O /opt/tmp/samba/system-config-samba_1.2.63-0ubuntu6_all.deb
sudo dpkg -i /opt/tmp/samba/system-config-samba_1.2.63-0ubuntu6_all.deb
sudo apt-get install -f -y
sudo touch /etc/libuser.conf

# INSTALAR MUGSHOT

sudo mkdir -p /opt/tmp/mugshot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/gQydJFz5qcYBXYf/download' -O /opt/tmp/mugshot/mugshot_0.4.2-1_all.deb
sudo dpkg -i /opt/tmp/mugshot/mugshot_0.4.2-1_all.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR PLUGIN PARA DESCARGAR VIDEOS EN FIREFOX

sudo mkdir -p /opt/tmp/video-downloader
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DHsA7oxmBQw8adb/download' -O /opt/tmp/video-downloader/net.downloadhelper.coapp-1.5.0-1_amd64.deb
sudo dpkg -i /opt/tmp/video-downloader/net.downloadhelper.coapp-1.5.0-1_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR DENSIFY (PARA REDUCIR ARCHIVOS PDF

sudo mkdir -p /opt/tmp/densify
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/bp8pYAKSXKQ7dFZ/download' -O /opt/tmp/densify/densify-0.3.1-q2_amd64.deb
sudo dpkg -i /opt/tmp/densify/densify-0.3.1-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR IMAGINE (PARA REDUCIR IMÁGENES

sudo mkdir -p /opt/tmp/imagine
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/xeTmnR4JGgzJnTE/download' -O /opt/tmp/imagine/imagine-0.5.1-q2_amd64.deb
sudo dpkg -i /opt/tmp/imagine/imagine-0.5.1-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR GESTOR DE SOFTWARE DE MINT LMDE4
 -----------------------------------------------------------------------------
 Mint LMDE4 (basado en Debian Buster) incluye un cómodo gestor de software 
 gráfico mucho más ligero que otros como gnome-software. Se trata de 
 Mininstall, viene en Quirinux 2.0 y permite instalar paquetes tipo Flatpak. 
 
 Se instalará, además, la utilidad 'Flatpak-Config' (exclusiva de Quirinux)  
 con la que podrás activar o desactivar esta caracteristica, sin perjuicio 
 de que puedes elegir ahora tu preferencia.

  ${bold}ADVERTENCIA:${normal} Requiere repositorios libres adicionales. 
 Si no los agregaste antes, puedes hacerlo ahora (opciones 4 y 5).


 1 Instalar gestor de software de Mint con soporte Flatpak (recomendado).
 2 Saltar este paso.
 3 Instalar gestor de software de Mint sin soporte Flatpak.
 4 Agregar los repositorios adicionales necesarios + opción 1.
 5 Agregar los repositorios adicionales necesarios + opción 3.
 0 Salir.
"

read -p " Tu respuesta-> " opc
 
case $opc in

"1") 

clear

# INSTALAR GESTOR DE PAQUETES DE MINT CON FLATPAK

sudo apt-get update -y
sudo apt-get install mintinstall -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR FLATPAK-CONFIG

sudo mkdir -p /opt/tmp/flatpak-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/wwBY7B6rayeGQEw/download' -O /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# INSTALAR GESTOR DE PAQUETES DE MINT SIN FLATPAK

sudo apt-get update -y
sudo apt-get install mintinstall -y
sudo apt-get remove --purge flatpak
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR FLATPAK-CONFIG

sudo mkdir -p /opt/tmp/flatpak-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/wwBY7B6rayeGQEw/download' -O /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"4)"

# AGREGA REPOSITORIOS LIBRES ADICIONALES NECESARIOS

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
sudo tar -xf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

# INSTALAR GESTOR DE PAQUETES DE MINT CON FLATPAK

sudo apt-get update -y
sudo apt-get install mintinstall -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR FLATPAK-CONFIG

sudo mkdir -p /opt/tmp/flatpak-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/wwBY7B6rayeGQEw/download' -O /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"5")

# AGREGA REPOSITORIOS LIBRES ADICIONALES NECESARIOS

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
sudo tar -xf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

# INSTALAR GESTOR DE PAQUETES DE MINT SIN FLATPAK

sudo apt-get update -y
sudo apt-get install mintinstall -y
sudo apt-get remove --purge flatpak
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR FLATPAK-CONFIG

sudo mkdir -p /opt/tmp/flatpak-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/wwBY7B6rayeGQEw/download' -O /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR O ACTUALIZAR A LIBREOFFICE 6.4.6
 -----------------------------------------------------------------------------
 Se instalará LibreOffice versión 6.4.6. con los diccionarios y traducciones 
 incluidas en Quirinux 2.0  y se eliminarán las versiones anteriores 
 instaladas en el sistema (si las hay).

 Si ya tienes una versión de LibreOffice instalada y prefieres conservarla,
 puedes saltar este paso.






 1 Instalar LibreOffice 6.4.6 (recomendado)
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# REMOVER INSTALACIONES ANTERIORES DE LIBREOFFICE Y DICCIONARIOS

sudo apt-get update -y
sudo apt-get remove --purge libreoffice* hunspell* myspell* mythes* aspell* hypen* -y
sudo mkdir -p /opt/tmp/libreoffice
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR LIBREOFFICE

sudo apt-get update -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/kbkjPqrJSRmZmPk/download' -O /opt/tmp/libreoffice/libreoffice.tar
sudo tar -xf /opt/tmp/libreoffice/libreoffice.tar -C /
cd /opt/tmp/libreoffice
sudo dpkg -i *.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: IMPRESORAS Y ESCÁNERES
 -----------------------------------------------------------------------------

 Intalación de controladores de impresión y escaneo 100 % libres 
 (no incluye hplip ni controladores privativos de otros fabricantes)









 1 Instalar controladores libres para impresoras y escáneres (recomendado).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR PQUETES DE IMPRESIÓN Y ESCANEO LIBRES

sudo apt-get update -y
for paquetes_scaner_impresion in cups cups-pdf ink autoconf git wget avahi-utils system-config-printer-udev colord  flex g++ libtool python-dev sane sane-utils system-config-printer system-config-printer-udev unpaper xsane xsltproc zlibc foomatic-db-compressed-ppds ghostscript-x ghostscript-cups gocr-tk gutenprint-locales openprinting-ppds printer-driver-brlaser printer-driver-all printer-driver-cups-pdf cups-client cups-bsd cups-filters cups-pdf cups-ppdc printer-driver-c2050 printer-driver-c2esp printer-driver-cjet printer-driver-dymo printer-driver-escpr  printer-driver-fujixerox printer-driver-gutenprint printer-driver-m2300w printer-driver-min12xxw printer-driver-pnm2ppa printer-driver-ptouch printer-driver-pxljr printer-driver-sag-gdi printer-driver-splix; do sudo apt-get install -y $paquetes_scaner_impresion; done
sudo apt-get install -f -y
sudo apt-get update
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

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: PAQUETES DE RED
 -----------------------------------------------------------------------------
 Intalación de controladores de red 100 % libres.











 1 Instalar controladores libres para red.
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR PAQUETES DE RED LIBRES

sudo apt-get update -y
for paquetes_red in mobile-broadband-provider-info pppconfig hardinfo modemmanager modem-manager-gui modem-manager-gui-help usb-modeswitch usb-modeswitch-data wvdial; do sudo apt-get install -y $paquetes_red; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;


"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: CONTROLADORES AMD LIBRES Y/O PRIVATIVOS 
 -----------------------------------------------------------------------------
 Intalación de controladores de video AMD (si los necesitas)

   ${bold}ADVERTENCIA:${normal} Requiere activar non-free y contrib.
 Si instalaste Rrepo-Config pero no activaste non-free y contrib, puedes 
 activarlos ahora: ${bold}Aplicaciones > Sistema > Repo-Config.${normal} 

  





 1 Instalar controladores para AMD (libres y privativos).
 2 Saltar este paso.
 3 Instalar Repo-Config + activar non-free contrib backports + opción 1.
 4 Instalar controladores para AMD (sólo los libres).
 0 Salir.

"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR CONTROLADORES DE VIDEO AMD LIBRES Y PRIVATIVOS

sudo apt-get update -y
for paquetes_amd in mesa-opencl-icd mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers firmware-linux firmware-linux-nonfree libdrm-amdgpu1 xserver-xorg-video-amdgpu; do sudo apt-get install -y $paquetes_amd; done
sudo apt-get install -f
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"3")

clear

# INSTALAR REPO-CONFIG

sudo mkdir -p /opt/tmp/repo-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/qoP844Zns8niQqK/download' -O /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/repo-config/repo-config-1.0-q2_amd64.deb
sudo apt-get update -y

# ACTIVA REPOSITORIOS NON-FREE CONTRIB Y BACKPORTS DE DEBIAN 

sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
sudo apt-get update -y

# INSTALAR CONTROLADORES DE VIDEO AMD LIBRES Y PRIVATIVOS

sudo apt-get update -y
for paquetes_amd in mesa-opencl-icd mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers firmware-linux firmware-linux-nonfree libdrm-amdgpu1 xserver-xorg-video-amdgpu; do sudo apt-get install -y $paquetes_amd; done
sudo apt-get install -f
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"4")

clear

# INSTALAR SÓLO CONTROLADORES DE VIDEO AMD LIBRES

sudo apt-get update -y
for paquetes_amd in mesa-opencl-icd mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers libdrm-amdgpu1 xserver-xorg-video-amdgpu; do sudo apt-get install -y $paquetes_amd; done
sudo apt-get install -f
sudo apt-get autoremove --purge -y

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: SCREENSAVER
 -----------------------------------------------------------------------------
 Instalación del protector de pantalla screensaver gluclo, que es un relój de
 retro similar al de MacOS.










 1 Instalar screensaver gluclo (simil Relój de fichas de MacOs).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR SCREENSAVER GLUCLO

sudo apt-get update -y
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

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: AJUSTES DE SONIDO
 -----------------------------------------------------------------------------
 Reinstalar PulseAudio puede solucionar algunas incidencias que ocurren al ins-
 talar algunas aplicaciones de Quirinux.









 
 1 Reinstalar PulseAudio (recomendado).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# REINSTALAR PULSEAUDIO

sudo apt-get update -y
sudo apt-get remove --purge pulseuadio pavucontrol -y
sudo apt-get clean
sudo apt-get autoremove --purge -y
sudo rm -r ~/.pulse ~/.asound* ~/.pulse-cookie ~/.config/pulse
sudo apt-get update -y
sudo apt-get install pulseaudio rtkit pavucontrol -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: TRADUCCIONES DE FIREFOX
 -----------------------------------------------------------------------------
 Instalación de traducciones para Mozilla Firefox.
 
 Agrega los ficheros de lenguaje de los idiomas que vienen preinstalados en 
 Quirinux. 




 

 

 1 Instalar traducciones de Firefox.
 2 Saltar este paso. (recomendado)
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR TRADUCCIONES DE FIREFOX

sudo apt-get update -y
for paquetes_idiomas_firefox in firefox-l10n-es firefox-l10n-gl firefox-l10n-it firefox-l10n-pt firefox-l10n-pt-br firefox-l10n-de firefox-l10n-en-gb; do sudo apt-get install -y $paquetes_idiomas_firefox; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: INSTALAR TIPOGRAFÍAS
 -----------------------------------------------------------------------------
 Puedes instalar las fuentes que vienen preinstaladas en Quirinux, 
 incluyendo las de Microsoft. 

  ${bold} ADVERTENCIA: ${normal}Si eliges eliminar tus tipografías actuales, 
 puede que dejes de poder visualizar tu sistema  este programa. En ese caso
 necesitarás reiniciar tu ordenador -cuando veas que este programa se 
 en cuentre detenido- y volver a iniciar este programa saltando los pasos 
 anteriores y este mismo para continuar.




 1 Instalar fuentes (eliminando las actuales) (CUIDADO!)
 2 Saltar este paso
 3 Instalar fuentes (sin eliminar las actuales)
 0 Salir


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# Borrar fuentes anteriores !!! (CUIDADO!)

sudo rm -rf /usr/share/fonts/*

# Descargando y copiando fuentes de Quirinux

sudo mkdir -p /opt/tmp
sudo mkdir -p /opt/tmp/fuentes
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/oS7PZ4HqWTkNff7/download' -O /opt/tmp/fuentes/quirinux-fuentes.tar
sudo chmod 777 -R /opt/tmp/fuentes/
sudo chown $USER -R /opt/tmp/fuentes/
sudo tar -xvf /opt/tmp/fuentes/quirinux-fuentes.tar -C /opt/tmp/fuentes
sudo cp -r -a /opt/tmp/fuentes/quirinux-fuentes/* /

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# Descargando y copiando fuentes de Quirinux

sudo mkdir -p /opt/tmp
sudo mkdir -p /opt/tmp/fuentes
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/oS7PZ4HqWTkNff7/download' -O /opt/tmp/fuentes/quirinux-fuentes.tar
sudo chmod 777 -R /opt/tmp/fuentes/
sudo chown $USER -R /opt/tmp/fuentes/
sudo tar -xvf /opt/tmp/fuentes/quirinux-fuentes.tar -C /opt/tmp/fuentes
sudo cp -r -a /opt/tmp/fuentes/quirinux-fuentes/* /

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: ÍCONOS Y TEMAS DE ESCRITORIO
 -----------------------------------------------------------------------------
 Instalación de temas de escritorio, íconos y menú de Quirinux GENERAL.

 ${bold} ADVERTENCIA: ${normal}A continuación puedes elegir si prefieres
 borrar tus íconos y temas actuales o simplemente agregar los de Quirinux
 sin eliminar nada. 







 1 Instalar íconos y temas borrando los actuales. (CUIDADO!)
 2 Saltar este paso
 3 Instalar íconos y temas sin borrar los actuales (recomendado)
 0 Salir


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# OTORGANDO PERMISOS PARA MODIFICAR TEMAS

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# Borrando contenido original !!! (CUIDADO!)

sudo rm -rf /usr/share/themes/*
sudo rm -rf /usr/share/backgrounds/*
sudo rm -rf /usr/share/desktop-base/*
sudo rm -rf /usr/share/images/*

# INSTALAR TEMAS DE QUIRINUX

sudo mkdir -p /opt/tmp/temas
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/o7rg7CpARw5CPLA/download' -O /opt/tmp/temas/quirinux-temas.tar
sudo tar -xvf /opt/tmp/temas/quirinux-temas.tar -C /

# INSTALAR ÍCONOS DE QUIRINUX

sudo mkdir -p /opt/tmp/winbugs
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/NAwrJXnZYow9PHS/download' -O /opt/tmp/winbugs/winbugs-icons.deb
sudo dpkg -i /opt/tmp/winbugs/winbugs-icons.deb
sudo apt-get install -f -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX')
# También instala menú principal de Quirinux y modifica algunos archivos más.

sudo mkdir -p /opt/tmp/config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/7WPCQjRSCjSMjSz/download' -O /opt/tmp/config/quirinux-config.tar
sudo tar -xvf /opt/tmp/config/quirinux-config.tar -C /
sudo update-grub
sudo update-grub2

# PERSONALIZANDO PANELES DE USUARIO DE QUIRINUX

sudo chmod 777 -R /home/
for usuarios2 in /home/*; do sudo yes | sudo cp -r -a /etc/skel/* $usuarios2; done

# OTORGANDO PERMISOS PARA MODIFICAR CONFIGURACIÓN DE CARPETAS DE USUARIO

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod u+s /usr/sbin/hddtemp

# ELIMINANDO ERRORES DE INICIO (RED

sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >> /etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

# ELIMINANDO ACCIÓN DE THUNAR QUE NO FUNCIONA (SET AS WALLPAPER

sudo rm /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-wallpaper-plugin.so

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# OTORGANDO PERMISOS PARA MODIFICAR TEMAS

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# INSTALAR TEMAS DE QUIRINUX

sudo mkdir -p /opt/tmp/temas
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/o7rg7CpARw5CPLA/download' -O /opt/tmp/temas/quirinux-temas.tar
sudo tar -xvf /opt/tmp/temas/quirinux-temas.tar -C /

# INSTALAR ÍCONOS DE QUIRINUX

sudo mkdir -p /opt/tmp/winbugs
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/NAwrJXnZYow9PHS/download' -O /opt/tmp/winbugs/winbugs-icons.deb
sudo dpkg -i /opt/tmp/winbugs/winbugs-icons.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX'

sudo mkdir -p /opt/tmp/config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/7WPCQjRSCjSMjSz/download' -O /opt/tmp/config/quirinux-config.tar
sudo tar -xvf /opt/tmp/config/quirinux-config.tar -C /
sudo update-grub
sudo update-grub2

# PERSONALIZANDO PANELES DE USUARIO DE QUIRINUX

sudo chmod 777 -R /home/
for usuarios2 in /home/*; do sudo yes | sudo cp -r -a /etc/skel/* $usuarios2; done

# OTORGANDO PERMISOS PARA MODIFICAR CONFIGURACIÓN DE CARPETAS DE USUARIO

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod u+s /usr/sbin/hddtemp

# ELIMINANDO ERRORES DE INICIO (RED

sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >> /etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

# ELIMINANDO ACCIÓN DE THUNAR QUE NO FUNCIONA (SET AS WALLPAPER

sudo rm /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-wallpaper-plugin.so

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear 

echo " -----------------------------------------------------------------------------
 QUIRINUX GENERAL: BORRAR COMPONENTES QUE QUIRINUX NO INCLUYE
 -----------------------------------------------------------------------------
 Remover componentes que Quirinux GENERAL no incluye.

 ${bold} ADVERTENCIA:${normal} Quirinux procura ahorrar espacio para adelgazar las ISO de 
 instalación en modo live, por tal motivo se borraran conjuntos de caracteres 
 no occidentales, idiomas, diccionarios y toda la documentación (manuales, 
 archivos readme de Debian, etc de la carpeta /usr/share/doc/ 
 





 1 Remover componentes que no vienen en Quirinux (CUIDADO!).
 2 Saltar este paso (recomendado).
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# REMOVER TRADUCCIONES DE FIREFOX DE IDIOMAS QUE QUIRINUX NO INCLUYE

sudo apt-get update -y
for paquetes_remover_idiomas_firefox in firefox-esr-l10n-bn-bd firefox-esr-l10n-bn-in refox-esr-l10n-kn firefox-esr-l10n-kn firefox-esr-l10n-lt firefox-esr-l10n-ml firefox-esr-l10n-ml firefox-esr-l10n-ar firefox-esr-l10n-ast firefox-esr-l10n-be firefox-esr-l10n-bg firefox-esr-l10n-bn firefox-esr-l10n-bs firefox-esr-l10n-ca firefox-esr-l10n-cs firefox-esr-l10n-cy firefox-esr-l10n-da firefox-esr-l10n-el firefox-esr-l10n-eo firefox-esr-l10n-es-cl firefox-esr-l10n-es-mx firefox-esr-l10n-et firefox-esr-l10n-eu firefox-esr-l10n-fa firefox-esr-l10n-fi firefox-esr-l10n-ga-ie firefox-esr-l10n-gu-in firefox-esr-l10n-he firefox-esr-l10n-hi-in firefox-esr-l10n-hr firefox-esr-l10n-hu firefox-esr-l10n-id firefox-esr-l10n-is firefox-esr-l10n-ja firefox-esr-l10n-kk firefox-esr-l10n-km firefox-esr-l10n-ko firefox-esr-l10n-lv firefox-esr-l10n-mk firefox-esr-l10n-mr firefox-esr-l10n-nb-no firefox-esr-l10n-ne-np firefox-esr-l10n-nl firefox-esr-l10n-nn-no firefox-esr-l10n-pa-in firefox-esr-l10n-pl firefox-esr-l10n-ro firefox-esr-l10n-si firefox-esr-l10n-sk firefox-esr-l10n-sl firefox-esr-l10n-sq firefox-esr-l10n-sr firefox-esr-l10n-sv-se firefox-esr-l10n-ta firefox-esr-l10n-te firefox-esr-l10n-th firefox-esr-l10n-tr firefox-esr-l10n-uk firefox-esr-l10n-vi firefox-esr-l10n-zh-cn firefox-esr-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_firefox; done
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

for paquetes_remover_programas in grsync jami blender dia gsmartcontrol ophcrack ophcrack-cli whowatch htop aqemu virt-manager qemu zulucrypt-cli zulucrypt-cli synapse plank balena-etcher-electron keepassxc stacer dino-im dino-im-common etherape eterape-data hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux qassel qassel-data jami jami-daemon liferea liferea-data mumble wahay onionshare qtox signal hydra hydra-gtk bmon grub-customizer spek osmo eom eom-common compton mc mc-data pidgin pidgin-data bluetooth khmerconverter thunderbird fcitx* mozc* webcamoid modem-manager-gui fcitx mlterm-common bluez bluez-firmware culmus synapse apparmor pidgin-otr pidgin-encryption pidgin pidgin-data pidgin-themes pidgin-openpgp libpurple0 dino-im dino-im-common gajim gajim-omemo hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux quassel quassel-data mumble qtox python-wicd wicd wicd-daemon wicd-gtk keepassxc mc mc-data osmo exfalso kasumi mlterm parole modem-manager-gui modem-manager-gui-help; do sudo apt-get remove --purge -y $paquetes_remover_programas; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DOCUMENTACIÓN

sudo rm -rf /usr/share/doc/*

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

echo " -----------------------------------------------------------------------------
 ¡QUIRINUX GENERAL INSTALADO!
 -----------------------------------------------------------------------------
 Hasta ahora, instalamos paquetes disponibles en la edición GENERAL. Puedes 
 salir ahora o ingresar en el terreno de ${bold}Quirinux Edicion PRO${normal}.
 Todo lo que trae Quirinux GENERAL, también lo trae Quirinux PRO, sólo que
 que mientras GENERAL está pensada para uso general, PRO es un sistema hecho
 para la fotografía, la edición multimedia y el cine de animación.

 Si sales ahora, de todas formas siempre podrás reiniciar este programa y 
 saltar hasta este paso si luego decides retomar la instalación y ampliar
 las características hasta convertir a Quirinux General en Quirinux PRO. 



 1 Borrar temporales y salir
 2 Continuar con la instalación de Quirinux PRO (recomendado) 
 0 Salir sin borrar los temporales. 



"

read -p " Tu respuesta-> " opc
 
case $opc in

"2") 

clear

;;

"1")

clear

# CONFIGURANDO PAQUETES

sudo dpkg --configure -a

# LIMPIANDO CACHE

sudo apt-get clean && sudo apt-get autoclean

# REGENERANDO CACHE

sudo apt-get update --fix-missing

# CONFIGURANDO DEPENDENCIAS

sudo apt-get install -f
sudo apt-get update -y
sudo apt-get autoremove --purge -y

# LIMPIEZA FINAL 

sudo rm -rf /var/lib/apt/lists/lock/* 
sudo rm -rf /var/cache/apt/archives/lock/* 
sudo rm -rf /var/lib/dpkg/lock/*
sudo rm -rf /lib/live/mount/rootfs/*
sudo rm -rf /lib/live/mount/*
sudo rm -rf /var/cache/apt/archives/*.deb
sudo rm -rf /var/cache/apt/archives/partial/*.deb
sudo rm -rf /var/cache/apt/partial/*.deb
sudo rm -rf /opt/tmp/*
sudo rm -rf /.git

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: SELECCIÓN DE PROGRAMAS GRÁFICOS Y MULTIMEDIA
 -----------------------------------------------------------------------------
 Instalar programas gráficos y multimedia que se encuentran en los 
 repositorios oficiales de Debian Buster pero que no vienen instalados por
 defecto:

 manuskript birdfont skanlite pencil2d devede vokoscreen-ng soundconverter 
 hugin guvcview calf-plugins invada-studio-plugins-ladspa 
 vlc-plugin-fluidsynth fluidsynth synfig synfigstudio synfig-examples  
 pikopixel.app entangle darktable rawtherapee krita krita-data krita-gmic 
 krita-l10n dvd-styler obs-studio obs-plugins



 1 Instalar especializados estándar (recomendado).
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR PAQUETES ESPECIALIZADOS DESDE BUSTER (KRITA, OBS, SYNFIG, ETC

sudo apt-get update -y
for paquetes_estandar in manuskript birdfont skanlite pencil2d devede vokoscreen-ng soundconverter hugin guvcview calf-plugins invada-studio-plugins-ladspa vlc-plugin-fluidsynth fluidsynth synfig synfigstudio synfig-examples pikopixel.app entangle darktable rawtherapee krita krita-data krita-gmic krita-l10n dvd-styler obs-studio obs-plugins; do sudo apt-get install -y $paquetes_estandar; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: PROGRAMAS EXCLUSIVOS DE ANIMACIÓN
 -----------------------------------------------------------------------------
 Conjunto de programas empaquetados especialmente para Quirinux y que no  
 están presentes en la mayoría de los respositorios oficiales de otras 
 distribuciones:
 
 ${bold}Storyboarder:${normal} Alternativa a Toon Boom Storyboard Pro
 ${bold}Tupi, qStopMotion:${normal} Alternativas a Toon Boom Harmony y Dragonframe
 ${bold}Natron, Enve:${normal} Alternativas a Adobe After Effects
 ${bold}MyPaint, AzPAinter:${normal} Alternativas Corel Painter y SAI
 ${bold}Belle, Godot:${normal} Desarrollo de videojuegos 
 ${bold}Quinema:${normal} Scripts de animación de Ernesto Bazzano 


 1 Instalar Especializados Quirinux
 2 Saltar este paso
 0 Salir



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR TUPITUBE

sudo apt-get update -y
sudo mkdir -p /opt/tmp/tupitube
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Zrce88JXLRjiqXF/download' -O /opt/tmp/tupitube/tupitube-desk-0.2.15-q2_amd64.deb
sudo dpkg -i /opt/tmp/tupitube/tupitube-desk-0.2.15-q2_amd64.deb 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR GODOT

sudo mkdir -p /opt/tmp/godot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/w3R2NzrwwSMxPXC/download' -O /opt/tmp/godot/godot-2.3.3-q2_amd64.deb
sudo dpkg -i /opt/tmp/godot/godot-2.3.3-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR STORYBOARDER

sudo mkdir -p /opt/tmp/storyboarder
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GePzTyxoYpM622t/download' -O /opt/tmp/storyboarder/storyboarder-2.0.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/storyboarder/storyboarder-2.0.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR NATRON

sudo mkdir -p /opt/tmp/natron
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/zBY3tinXbQpqDbB/download' -O /opt/tmp/natron/natron-2.3.15-q2_amd64.deb
sudo dpkg -i /opt/tmp/natron/natron-2.3.15-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR AZPAINTER

sudo mkdir -p /opt/tmp/azpainter
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/AojjBiP7NmoSBsA/download' -O /opt/tmp/azpainter/azpainter-2.1.4-q2_amd64.deb
sudo dpkg -i /opt/tmp/azpainter/azpainter-2.1.4-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR ENVE

sudo mkdir -p /opt/tmp/enve
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GAyMB7pt5K9MXnx/download' -O /opt/tmp/enve/enve-0.0.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/enve/enve-0.0.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR QUINEMA

sudo mkdir -p /opt/tmp/quinema
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/zREfipBzSxYXFTK/download' -O /opt/tmp/quinema/quinema_1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/quinema/quinema_1.0-q2_amd64.deb
sudo apt-get install -f -y

# INSTALAR QSTOPMOTION

sudo mkdir -p /opt/tmp/qstopmotion
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/MznJgLCFeWeQMGd/download' -O /opt/tmp/qstopmotion/qstopmotion-2.5.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/qstopmotion/qstopmotion-2.5.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR CONTROLADORES PARA CÁMARAS VIRTUALES
# Complemento útil para qStopMotion

sudo mkdir -p /opt/tmp/akvcam
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/2BL5CgEa3YgMx2g/download' -O /opt/tmp/akvcam/akvcam-1.0-q2_amd64.deb
sudo chmod 777 -R /opt/tmp/akvcam/
sudo dpkg -i /opt/tmp/akvcam/akvcam-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR BELLE

sudo mkdir -p /opt/tmp/belle
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/pQw6Yyytaz8TQ46/download' -O /opt/tmp/belle/belle-0.7-q2_amd64.deb
sudo dpkg -i /opt/tmp/belle/belle-0.7-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR MYPAINT

sudo mkdir -p /opt/tmp/mypaint
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/TZL8554kj8HLjsK/download' -O /opt/tmp/mypaint/mypaint-2-q2_amd64.deb
sudo dpkg -i /opt/tmp/mypaint/mypaint-2-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: GIMP + PLUGINS
 -----------------------------------------------------------------------------
 Instalación completa del editor profesional de imágenes GIMP, como 
 alternativa  a Adobe Photoshop. Se instala desde los repositorios oficiales 
 de Debian Buster.

 ${bold} TRUCO:${normal} Si tienes instalado Gimp desde snap, flatpak
 o appimage, es necesario volver a instalarlo con esta opción si luego 
 quieres agregar el complemento para configurar atajos y/o íconos de 
 Photoshop. 




 1 Instalar GIMP + Plugins (recomendado)
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# Desinstalar GIMP desde snap y flatpak

sudo snap remove gimp
sudo flatpak uninstall org.gimp.GIMP && flatpak uninstall --unused

# INSTALAR GIMP 2.10 DESDE BUSTER

sudo apt-get update -y
for paquetes_gimp in gimp gimp-data gimp-gap gimp-gluas gimp-gmic gimp-gutenprint gimp-plugin-registry gimp-python gimp-texturize gimp-ufraw; do sudo apt-get install -y $paquetes_gimp; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: GIMP EDICIÓN QUIRINUX
 -----------------------------------------------------------------------------
 Se agrega un programa llamado ${bold}Configurar-Gimp${normal} que sirve para 
 convertir a Gimp  en ${bold}Gimp Edición Quirinux.${normal} Este programa 
 permite utilizar Gimp con los íconos  y/o atajos de Photoshop y revertir los 
 cambios en cualquier momento, a  diferencia de  otras utilidades similares
 que no posibilitan deshacer los cambios. 

 ${bold} ADVERTENCIA${normal} Requiere haber instalado GIMP en el paso 
 anterior. Si no lo hiciste, puedes hacerlo ahora (opción 3).




 1 Instalar Gimp Edición Quirinux (recomendado).
 2 Saltar este paso.
 3 Instalar GIMP + Plugins + opcion 1.
 0 Salir.


"

read -p " Tu respuesta-> " opc

case $opc in

"1") 

clear

# INSTALAR CONVERSOR PARA GIMP EDICIÓN QUIRINUX

sudo apt-get update -y
sudo mkdir -p /opt/tmp/gimp/
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GHyPZZz9MgX7sdJ/download' -O /opt/tmp/gimp/gimp-quirinux.deb
sudo dpkg -i /opt/tmp/gimp/gimp-quirinux.deb
sudo chmod 777 -R /home/
sudo rm -rf /home/*/.config/GIMP
sudo rm -rf /root/.config/GIMP 
sudo rm -rf /usr/share/gimp 
sudo rm -rf /etc/skel/.config/GIMP 
for usuarios in /home/*; do sudo yes | sudo cp -r -a /opt/gimp-quirinux/gimp-shop/.config $usuarios; done
sudo yes | sudo cp -rf -a /opt/gimp-quirinux/gimp-shop/.config /root/ 
sudo yes | sudo cp -rf -a /opt/gimp-quirinux/gimp-shop/.config /etc/skel/ 
sudo yes | sudo cp -rf -a /opt/gimp-quirinux/gimp-shop/usr/share /usr/
sudo chmod 777 -R /home/
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# INSTALAR GIMP 2.10 DESDE BUSTER

sudo apt-get update -y
for paquetes_gimp in gimp gimp-data gimp-gap gimp-gluas gimp-gmic gimp-gutenprint gimp-plugin-registry gimp-python gimp-texturize gimp-ufraw; do sudo apt-get install -y $paquetes_gimp; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR CONVERSOR PARA GIMP EDICIÓN QUIRINUX

sudo apt-get update -y
sudo mkdir -p /opt/tmp/gimp/
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GHyPZZz9MgX7sdJ/download' -O /opt/tmp/gimp/gimp-quirinux.deb
sudo dpkg -i /opt/tmp/gimp/gimp-quirinux.deb
sudo chmod 777 -R /home/
sudo rm -rf /home/*/.config/GIMP
sudo rm -rf /root/.config/GIMP 
sudo rm -rf /usr/share/gimp 
sudo rm -rf /etc/skel/.config/GIMP 
for usuarios in /home/*; do sudo yes | sudo cp -r -a /opt/gimp-quirinux/gimp-shop/.config $usuarios; done
sudo yes | sudo cp -rf -a /opt/gimp-quirinux/gimp-shop/.config /root/ 
sudo yes | sudo cp -rf -a /opt/gimp-quirinux/gimp-shop/.config /etc/skel/ 
sudo yes | sudo cp -rf -a /opt/gimp-quirinux/gimp-shop/usr/share /usr/
sudo chmod 777 -R /home/
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: INSTALAR CINELERRA
 -----------------------------------------------------------------------------
 Instalación del editor de video profesional Cinelerra, 
 alternativa que supera en prestaciones a Adobe Premiere. 

  ${bold}ADVERTENCIA:${normal} Requiere repositorios libres adicionales. 
 Si no los activaste al comienzo de la instalación, puedes hacerlo ahora 
 (opción 3).






 1 Instalar Cinelerra (recomendado)
 2 Saltar este paso
 3 Agregar respositorios libres adicionales necesarios + opción 1.
 0 Salir


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR EDITOR DE VIDEO PROFESIONAL CINELERRA

sudo apt-get update -y
for paquetes_cinelerra in cin; do sudo apt-get install -y $paquetes_cinelerra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"3")

clear

# AGREGA REPOSITORIOS LIBRES ADICIONALES NECESARIOS

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
sudo tar -xf /opt/tmp/apt/quirinux-apt.tar -C /
sudo apt-get update -y

# INSTALAR EDITOR DE VIDEO PROFESIONAL CINELERRA

sudo apt-get update -y
for paquetes_cinelerra in cin; do sudo apt-get install -y $paquetes_cinelerra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;;

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: COMPILAR E INSTALAR OPENTOONZ
 -----------------------------------------------------------------------------
 Descargar código fuente e instalar compilando desde el código la versión más
 nueva del programa de animación profesional OpenToonz, con el que puedes 
 reemplazar a Toon Boom Harmony.

  ${bold}ADVERTENCIA:${normal} El proceso de compilación de este programa
 es lento, pero vale la pena. 






 1 Descargar, compilar e instalar OpenToonz (recomendado)
 2 Saltar este paso
 0 Salir



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

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

mkdir /opt/tmp
cd /opt/tmp
git clone https://github.com/opentoonz/opentoonz
mkdir -p $HOME/.config/OpenToonz
cp -r opentoonz/stuff $HOME/.config/OpenToonz/
cat << EOF > $HOME/.config/OpenToonz/SystemVar.ini
[General]
OPENTOONZROOT="$HOME/.config/OpenToonz/stuff"
OpenToonzPROFILES="$HOME/.config/OpenToonz/stuff/profiles"
TOONZCACHEROOT="$HOME/.config/OpenToonz/stuff/cache"
TOONZCONFIG="$HOME/.config/OpenToonz/stuff/config"
TOONZFXPRESETS="$HOME/.config/OpenToonz/stuff/fxs"
TOONZLIBRARY="$HOME/.config/OpenToonz/stuff/library"
TOONZPROFILES="$HOME/.config/OpenToonz/stuff/profiles"
TOONZPROJECTS="$HOME/.config/OpenToonz/stuff/projects"
TOONZROOT="$HOME/.config/OpenToonz/stuff"
TOONZSTUDIOPALETTE="$HOME/.config/OpenToonz/stuff/studiopalette"
EOF
cd /opt/tmp/opentoonz/thirdparty/tiff-4.0.3
./configure --with-pic --disable-jbig
make -j$(nproc)
cd ../../
cd /opt/tmp/opentoonz/toonz
mkdir build
cd build
cmake ../sources
make -j$(nproc)
sudo make install 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Descarga y copia en ícono del menú de inicio de OpenToonz

sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/FZz85jagrQLCjjB/download' -O /opt/opentoonz/opentoonz-icon.tar
sudo rm /opt/opentoonz/bin/opentoonz
sudo tar -xf /opt/opentoonz/opentoonz-icon.tar -C /

# Creando comando de inicio de OpenToonz

sudo chmod -R 775 /opt/opentoonz
sudo chown -R $USER /opt/opentoonz

FILE="/usr/local/bin/imagine2"

if [ -f "$FILE" ]; then

sudo rm /usr/local/bin/opentoonz
sudo mv /opt/opentoonz/bin/opentoonz /opt/opentoonz/bin/run-opentoonz
cd /usr/local/bin
sudo ln -s /opt/opentoonz/bin/opentoonz
sudo chmod -R 4755 /usr/local/bin/opentoonz

else

sudo mv /opt/opentoonz/bin/opentoonz /opt/opentoonz/bin/run-opentoonz
cd /usr/local/bin
sudo ln -s /opt/opentoonz/bin/opentoonz
sudo chmod -R 4755 /usr/local/bin/opentoonz

fi

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: VERSION MÁS NUEVA DE BLENDER
 -----------------------------------------------------------------------------
 A diferencia de Quirinux GENERAL, Quirinux PRO incluye una versión más 
 reciente del programa Blender.

 Blender no sólo sirve para animación 3D: en sus últimas versiones incorpora
 herramientas muy atractivas para la animación 2D y 2.5D. 







 1 Instalar o actualizar a una versión reciente de Blender (recomendado)
 2 Saltar este paso
 0 Salir



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# ACTUALIZANDO BLENDER

sudo apt-get update -y
for paquetes_remover_blender in remove --purge blender-data; do sudo apt-get remove --purge -y $paquetes_remover_blender; done
sudo mkdir -p /opt/tmp/blender283
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/PfagSW43yP9yGiX/download' -O /opt/tmp/blender283/blender-2.83-q2_amd64.deb
sudo dpkg -i /opt/tmp/blender283/blender-2.83-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: VERSIÓN MÁS NUEVA DE INKSCAPE
 -----------------------------------------------------------------------------
 A diferencia de Quirinux GENERAL, Quirinux PRO incluye una versión más 
 reciente del programa Inkscape.

 Con Inkscape puedes hacer reemplazar a Adobe Illustrator, incluso puedes
 editar proyectos .ai







 1 Instalar o actualizar una versión más reciente de Inkscape (recomendado)
 2 Saltar este paso
 0 Salir



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# ACTUALIZANDO INKSCAPE

sudo apt-get update -y
for paquetes_remover_inkscape in inkscape; do sudo apt-get remove --purge -y $paquetes_remover_inkscape; done
sudo mkdir -p /opt/tmp/inkscape
sudo wget --no-check-certificate 'http://my.opendesktop.org/s/7BWLio7HC4Rga3J/download' -O /opt/tmp/inkscape/inkscape-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/inkscape/inkscape-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: VERSIÓN MÁS NUEVA DE ARDOUR
 -----------------------------------------------------------------------------
 El paquete Quirinux GENERAL trae${bold}Ardour5${normal}, y PRO actualiza a 
 ${bold}Ardour6${normal}. Entre otras mejoras, incorpora compesación de 
 latencia, importar mp3 sin necesidad de convertir a wav y grabación con 
 escucha sobre track en reproducción.

 Este paquete aún no se encuentra disponible de manera nativa para    
 Debian y requiere ser compilado (al igual que OpenToonz 1.4).
 Puedes compilar e instalar la actualización ahora

 ${bold} ADVERTENCIA:${normal} Este proceso es muy largo y tarda mucho.

 
 1 Actualizar a Ardour6 (recomendado para sonidistas profesionales)
 2 Saltar este paso
 0 Salir



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# DESCARGAR VERSIONES ANTERIORES DE ARDOUR

sudo apt-get update
for paquetes_ardour5 in ardour ardour-data; do sudo apt-get remove --purge -y $paquetes_ardour5; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# INSTALAR DEPENDENCIAS NECESARIAS PARA COMPILAR ARDOUR

sudo apt-get update
for paquetes_ardour in libboost-all-dev libasound2-dev libglib2.0-dev glibmm-2.4-dev libsndfile1-dev libcurl4-gnutls-dev liblo-dev libtag1-dev vamp-plugin-sdk librubberband-dev libfftw3-dev libaubio-dev libxml2-dev libcwiid-dev libjack-jackd2-dev jackd qjackctl liblrdf0-dev libsamplerate-dev lv2-dev libserd-dev libsord-dev libsratom-dev liblilv-dev libgtkmm-2.4-dev libarchive-dev git xjadeo; do sudo apt-get install -y $paquetes_ardour; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# DESCARGAR EL CÓDIGO FUENTE DE ARDOUR

cd /opt/tmp/
git clone git://git.ardour.org/ardour/ardour.git

# COMPILAR CÓDIGO FUENTE DE ARDOUR

cd /opt/tmp/ardour
./waf configure
sudo ./waf install
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# DESCARGÁNDO ÍCONO Y PERSONALIZACIONES DE ARDOUR

sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/YjPGEJcENG6qXDt/download' -O /opt/tmp/ardour6-postinstall.tar
sudo chmod 777 -R /opt/tmp/
sudo chown $USER /opt/tmp/*
sudo chmod 777 /opt/tmp/ardour6-postinstall.tar

# INSTALAR ACCESO DIRECTO DE ARDOUR

cd /opt/tmp/
sudo tar -xvf /opt/tmp/ardour6-postinstall.tar
sudo cp -rf -a /opt/tmp/ardour6-postinstall/usr/* /usr/

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: DESCARGAR PLUGIN STOPMO-PREVIEW PARA ENTANGLE
 -----------------------------------------------------------------------------
 Entangle es un programa similar a EOS que sirve para cámaras reflex de los  
 fabricantes más conocidos.

 El plugin 'stopmo-preview' añade utilidad de stopmotion (papel cebolla y 
 podemos descargarlo a continuación pero necesita ser instalado sin permiso 
 de root. 

 Puedes instalarlo ejecutando -SIN permisos de root- el script 
 ${bold}instalar-plugin-entangle-NOROOT.sh${normal} que encontrarás en la 
 carpeta ${bold}/opt/stopmo-preview-plugin${normal} luego de la descarga.


 1 Descargar Plugin stopmo-preview para Entangle
 2 Saltar este paso
 0 Salir



"
read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# DESCARGAR PLUGIN STOPMO-PREVIEW PARA ENTANGLE

sudo mkdir -p /opt/stopmo-preview-plugin
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Qd8CtZBN6a6STAY/download' -O /opt/stopmo-preview-plugin/stopmo-preview-plugin.tar
sudo tar -xf /opt/stopmo-preview-plugin/stopmo-preview-plugin.tar -C /opt/stopmo-preview-plugin/
for paquetes_python in python2-gobject; do sudo apt-get install -y $paquetes_python; done
sudo rm /opt/stopmo-preview-plugin/stopmo-preview-plugin.tar
sudo chmod 777 /opt/stopmo-preview-plugin/instalar-plugin-entangle-NOROOT.sh
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: INSTALAR CONTROLADORES PARA TABLETAS WACOM
 -----------------------------------------------------------------------------
 Instalar controladores libres para las tabletas gráficas de la marca Wacom.

 

 







 1 Instalar controladores de Wacom.
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc
 
case $opc in

"1") 

clear

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS WACOM

sudo apt-get update -y
sudo apt-get install build-essential autoconf linux-headers-$uname -r
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Cp4yR3tt9gHeFEH/download' -O /opt/tmp/input-wacom-0.46.0.tar.bz2
cd /opt/tmp
tar -xjvf /opt/tmp/input-wacom-0.46.0.tar.bz2 
cd input-wacom-0.46.0 
if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: INSTALAR CONTROLADORES PARA TABLETAS GENIUS
 -----------------------------------------------------------------------------
 Instalar controladores libres para tabletas gŕaficas Genius antiguas,
 incluidos en Quirinux Edición Pro.










 1 Instalar controladores de Genius.
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS GENIUS

sudo apt-get update -y
sudo mkdir -p /opt/tmp/quirinux-genius
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/LD8wnWefdNpDsSo/download' -O /opt/tmp/quirinux-genius/quirinux-genius-1.0-q2_amd64.deb
sudo dpkg -i /opt/tmp/quirinux-genius/quirinux-genius-1.0-q2_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: INSTALAR PTXCONF
 -----------------------------------------------------------------------------
 Ptxconf es una utilidad programada en Perl, que sirve para mapear una  
 tableta gráfica a un sólo monitor cuando se utiliza más de uno. Gestiona de 
 manera gráfica el comando xorg map-to-input y resulta muy útil bajo el  
 escritorio xfce, predeterminado en Quirinux. 

 Si no usas xfce, puedes saltar este paso.






 1 Instalar Ptxconf (recomendado si usas XFCE)
 2 Saltar este paso.
 0 Salir.



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# INSTALAR UTILIDAD PTXCONF (MAPPING)

sudo mkdir -p /opt/tmp/ptxtemp
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/ajaj7dRJFp8PJFK/download' -O /opt/tmp/ptxtemp/ptxconf.tar
sudo tar -xf /opt/tmp/ptxtemp/ptxconf.tar -C /opt/
cd /opt/ptxconf
sudo python setup.py install
sudo apt-get install -f -y
sudo apt-get install libappindicator1
sudo mkdir -p /opt/tmp/python-appindicator
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/gfCdMmfLaX627rj/download' -O /opt/tmp/python-appindicator/python-appindicator_0.4.92-4_amd64.deb
sudo dpkg -i /opt/tmp/python-appindicator/python-appindicator_0.4.92-4_amd64.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: ÍCONOS Y TEMAS DE ESCRITORIO
 -----------------------------------------------------------------------------
 Instalación de temas de escritorio e íconos de Quirinux PRO.

 ${bold} ADVERTENCIA: ${normal}A continuación puedes elegir si prefieres
 borrar tus íconos y temas actuales o simplemente agregar los de Quirinux
 sin eliminar nada. 







 1 Instalar íconos y temas borrando los actuales. (CUIDADO!)
 2 Saltar este paso
 3 Instalar íconos y temas sin borrar los actuales (recomendado)
 0 Salir


"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# OTORGANDO PERMISOS PARA MODIFICAR TEMAS

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# Borrando contenido original !!! (CUIDADO!)

sudo rm -rf /usr/share/themes/*
sudo rm -rf /usr/share/backgrounds/*
sudo rm -rf /usr/share/desktop-base/*
sudo rm -rf /usr/share/images/*

# INSTALAR TEMAS DE QUIRINUX

sudo mkdir -p /opt/tmp/temas
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/o7rg7CpARw5CPLA/download' -O /opt/tmp/temas/quirinux-temas.tar
sudo tar -xvf /opt/tmp/temas/quirinux-temas.tar -C /

# INSTALAR ÍCONOS DE QUIRINUX

sudo mkdir -p /opt/tmp/winbugs
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/NAwrJXnZYow9PHS/download' -O /opt/tmp/winbugs/winbugs-icons.deb
sudo dpkg -i /opt/tmp/winbugs/winbugs-icons.deb
sudo apt-get install -f -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX')
# También instala menú principal de Quirinux y modifica algunos archivos más.

sudo mkdir -p /opt/tmp/config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/7WPCQjRSCjSMjSz/download' -O /opt/tmp/config/quirinux-config.tar
sudo tar -xvf /opt/tmp/config/quirinux-config.tar -C /
sudo update-grub
sudo update-grub2

# PERSONALIZANDO PANELES DE USUARIO DE QUIRINUX

sudo chmod 777 -R /home/
for usuarios2 in /home/*; do sudo yes | sudo cp -r -a /etc/skel/* $usuarios2; done

# OTORGANDO PERMISOS PARA MODIFICAR CONFIGURACIÓN DE CARPETAS DE USUARIO

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod u+s /usr/sbin/hddtemp

# ELIMINANDO ERRORES DE INICIO (RED

sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >> /etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

# ELIMINANDO ACCIÓN DE THUNAR QUE NO FUNCIONA (SET AS WALLPAPER

sudo rm /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-wallpaper-plugin.so

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"3")

clear

# OTORGANDO PERMISOS PARA MODIFICAR TEMAS

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# INSTALAR TEMAS DE QUIRINUX

sudo mkdir -p /opt/tmp/temas
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/o7rg7CpARw5CPLA/download' -O /opt/tmp/temas/quirinux-temas.tar
sudo tar -xvf /opt/tmp/temas/quirinux-temas.tar -C /

# INSTALAR ÍCONOS DE QUIRINUX

sudo mkdir -p /opt/tmp/winbugs
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/NAwrJXnZYow9PHS/download' -O /opt/tmp/winbugs/winbugs-icons.deb
sudo dpkg -i /opt/tmp/winbugs/winbugs-icons.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX'

sudo mkdir -p /opt/tmp/config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/7WPCQjRSCjSMjSz/download' -O /opt/tmp/config/quirinux-config.tar
sudo tar -xvf /opt/tmp/config/quirinux-config.tar -C /
sudo update-grub
sudo update-grub2

# PERSONALIZANDO PANELES DE USUARIO DE QUIRINUX

sudo chmod 777 -R /home/
for usuarios2 in /home/*; do sudo yes | sudo cp -r -a /etc/skel/* $usuarios2; done

# OTORGANDO PERMISOS PARA MODIFICAR CONFIGURACIÓN DE CARPETAS DE USUARIO

sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod u+s /usr/sbin/hddtemp

# ELIMINANDO ERRORES DE INICIO (RED

sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >> /etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

# ELIMINANDO ACCIÓN DE THUNAR QUE NO FUNCIONA (SET AS WALLPAPER

sudo rm /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-wallpaper-plugin.so

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"0")

clear

exit 0

;; 

esac 

clear 

echo " -----------------------------------------------------------------------------
 QUIRINUX PRO: BORRAR COMPONENTES QUE QUIRINUX NO INCLUYE
 -----------------------------------------------------------------------------
 Remover componentes que Quirinux PRO no incluye. 

 ADVERTENCIA: Quirinux procura ahorrar espacio para adelgazar
 las ISO de instalación en modo live, por tal motivo se 
 borraran conjuntos de caracteres no occidentales, idiomas, 
 diccionarios y toda la documentación (manuales, archivos read-
 me de Debian, etc de la carpeta /usr/share/doc/ 




 
 1 Remover componentes que no vienen en Quirinux PRO (CUIDADO!)
 2 Saltar este paso
 0 Salir



"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# REMOVER TRADUCCIONES DE FIREFOX DE IDIOMAS QUE QUIRINUX NO INCLUYE

sudo apt-get update -y
for paquetes_remover_idiomas_firefox in firefox-esr-l10n-bn-bd firefox-esr-l10n-bn-in refox-esr-l10n-kn firefox-esr-l10n-kn firefox-esr-l10n-lt firefox-esr-l10n-ml firefox-esr-l10n-ml firefox-esr-l10n-ar firefox-esr-l10n-ast firefox-esr-l10n-be firefox-esr-l10n-bg firefox-esr-l10n-bn firefox-esr-l10n-bs firefox-esr-l10n-ca firefox-esr-l10n-cs firefox-esr-l10n-cy firefox-esr-l10n-da firefox-esr-l10n-el firefox-esr-l10n-eo firefox-esr-l10n-es-cl firefox-esr-l10n-es-mx firefox-esr-l10n-et firefox-esr-l10n-eu firefox-esr-l10n-fa firefox-esr-l10n-fi firefox-esr-l10n-ga-ie firefox-esr-l10n-gu-in firefox-esr-l10n-he firefox-esr-l10n-hi-in firefox-esr-l10n-hr firefox-esr-l10n-hu firefox-esr-l10n-id firefox-esr-l10n-is firefox-esr-l10n-ja firefox-esr-l10n-kk firefox-esr-l10n-km firefox-esr-l10n-ko firefox-esr-l10n-lv firefox-esr-l10n-mk firefox-esr-l10n-mr firefox-esr-l10n-nb-no firefox-esr-l10n-ne-np firefox-esr-l10n-nl firefox-esr-l10n-nn-no firefox-esr-l10n-pa-in firefox-esr-l10n-pl firefox-esr-l10n-ro firefox-esr-l10n-si firefox-esr-l10n-sk firefox-esr-l10n-sl firefox-esr-l10n-sq firefox-esr-l10n-sr firefox-esr-l10n-sv-se firefox-esr-l10n-ta firefox-esr-l10n-te firefox-esr-l10n-th firefox-esr-l10n-tr firefox-esr-l10n-uk firefox-esr-l10n-vi firefox-esr-l10n-zh-cn firefox-esr-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_firefox; done
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

for paquetes_remover_programas in grsync jami blender dia gsmartcontrol ophcrack ophcrack-cli whowatch htop aqemu virt-manager qemu zulucrypt-cli zulucrypt-cli synapse plank balena-etcher-electron keepassxc stacer dino-im dino-im-common etherape eterape-data hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux qassel qassel-data jami jami-daemon liferea liferea-data mumble wahay onionshare qtox signal hydra hydra-gtk bmon grub-customizer spek osmo eom eom-common compton mc mc-data pidgin pidgin-data bluetooth khmerconverter thunderbird fcitx* mozc* webcamoid modem-manager-gui fcitx mlterm-common bluez bluez-firmware culmus synapse apparmor pidgin-otr pidgin-encryption pidgin pidgin-data pidgin-themes pidgin-openpgp libpurple0 dino-im dino-im-common gajim gajim-omemo hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux quassel quassel-data mumble qtox python-wicd wicd wicd-daemon wicd-gtk keepassxc mc mc-data osmo exfalso kasumi mlterm parole modem-manager-gui modem-manager-gui-help; do sudo apt-get remove --purge -y $paquetes_remover_programas; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DOCUMENTACIÓN

sudo rm -rf /usr/share/doc/*

# Borrar archivos temporales 

sudo rm -rf /opt/tmp/*

;;

"2")

clear

;;

"0")

clear

exit 0

;; 

esac 

clear

echo " -----------------------------------------------------------------------------
 ¡FIN DE LA INSTALACIÓN!
 -----------------------------------------------------------------------------
 A continuación, se borrarán los archivos temporales.











 1 Borrar archivos temporales y salir
 0 Salir sin borrar los archivos temporales 




"

read -p " Tu respuesta-> " opc 

case $opc in

"1") 

clear

# CONFIGURANDO PAQUETES

sudo dpkg --configure -a

# LIMPIANDO CACHE

sudo apt-get clean && sudo apt-get autoclean

# REGENERANDO CACHE

sudo apt-get update --fix-missing

# CONFIGURANDO DEPENDENCIAS

sudo apt-get install -f
sudo apt-get update -y
sudo apt-get autoremove --purge -y

# LIMPIEZA FINAL 

sudo rm -rf /var/lib/apt/lists/lock/* 
sudo rm -rf /var/cache/apt/archives/lock/* 
sudo rm -rf /var/lib/dpkg/lock/*
sudo rm -rf /lib/live/mount/rootfs/*
sudo rm -rf /lib/live/mount/*
sudo rm -rf /var/cache/apt/archives/*.deb
sudo rm -rf /var/cache/apt/archives/partial/*.deb
sudo rm -rf /var/cache/apt/partial/*.deb
sudo rm -rf /opt/tmp/*
sudo rm -rf /.git

exit 0

;; 

"2")

clear

exit 0

;;

"0")

clear

exit 0

;; 

esac 
