#!/bin/bash

# Nombre:	instalar-quirinux.sh
# Autor:	Charlie Martínez® <cmartinez@quirinux.org>
# Licencia:	https://www.gnu.org/licenses/gpl-3.0.txt
# Descripción:	Convierte una instalación limpia de Debian Buster XFCE 64 Bits en Quirinux 2.0
# Versión:	2.0 RC_5

# ===========================================================================================
# ¿ESTE CÓDIGO TE RESULTA INMANEJABLE?
# ===========================================================================================

# ¡Te sugiero utilizar el IDE Geany! A la izquierda del mismo tendrás un menú con todas las
# funciones de este script y podrás ir al lugar que necesites con mucha facilidad.
# Otra opción cómoda es VSCodium (Panel "Outline", a la izquierda).

# ===========================================================================================
# FUNCIONES PARA GENERACION DE ISO (DESCOMENTAR REFERENCIAS)
# ===========================================================================================

function _limpiezaAgresiva() {

clear
_remover
sudo rm -rf /var/lib/apt/lists/lock/*
sudo rm -rf /var/cache/apt/archives/lock/*
sudo rm -rf /var/lib/dpkg/lock/*
sudo rm -rf /lib/live/mount/rootfs/*
sudo rm -rf /lib/live/mount/*
sudo rm -rf /var/cache/apt/archives/*.deb
sudo rm -rf /var/cache/apt/archives/partial/*.deb
sudo rm -rf /var/cache/apt/partial/*.deb
sudo rm -rf /.git

}

# ===========================================================================================
# VERIFICAR REQUISITOS [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _inicioCheck() {

FILE="/opt/requisitos/ok"

if [ ! -e ${FILE} ]; then

clear
_menuCondicional
_menuRepositorios

else

clear

FILE2="/opt/requisitos/ok-repo"

if [ ! -e ${FILE2} ]; then

_menuRepositorios

else

_menuPrincipal

fi


fi

}

# ===========================================================================================
# INSTALAR REQUISITOS [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _requisitos() {

# INSTALAR WGET Y GIT

clear
sudo apt-get update -y
for paquetes_wget in wget git; do sudo apt-get install -y $paquetes_wget; done
mkdir -p /opt/requisitos/
touch /opt/requisitos/ok

}

# ===========================================================================================
# INSTALAR DIALOG [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _instalarDialog() {
sudo apt-get update -y
sudo apt-get install dialog -y
}

# ===========================================================================================
# FUNCION SALIR [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _salir() {

clear
exit 0

}

# ===========================================================================================
# FUNCION BORRAR TEMPORALES [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _borratemp() {
sudo rm -rf /opt/tmp/*
clear
}

# ===========================================================================================
# MENÚ CONDICIONAL [CASTELLANO]
# ===========================================================================================

function _menuCondicional() {

echo " -----------------------------------------------------------------------------
 INSTALAR COMPONENTES DE QUIRINUX 2.0
 -----------------------------------------------------------------------------
${bold}   ___        _      _                  
  / _ \ _   _ _ _ __ _ _ __  _   _ _  __
 | | | | | | | | '__| | '_ \| | | \ \/ /
 | |_| | |_| | | |  | | | | | |_| |>  < 
  \__\__\__,_|_|_|  |_|_| |_|\__,_/_/\_\ ${normal}
 
 (p) 2019-2021 Licencia GPLv3, Autor: Charlie Martínez® 
 Página web: https://www.quirinux.org - E-Mail: cmartinez@quirinux.org "

sleep 1

echo "
 --------------------------------------------------------------------
 | A continuación se instalarán algunos programas que el instalador | 
 | de Quirinux necesita para funcionar, procedimiento 100% seguro.  |
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

_requisitos
_instalarDialog
_config

;;

"0")

clear

exit 0

;;

esac

}

# ===========================================================================================
# MENU REPOSITORIOS [CASTELLANO]
# ===========================================================================================

function _menuRepositorios() {

opRepositorios=$(dialog --title "REPOSITORIOS ADICIONALES" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
--stdout \
--menu "NECESARIOS PARA EL RESTO DE LA INSTALACIÓN" 16 62 8 \
1 "Configurar repositorios extra para Debian Buster" \
2 "Configurar repositorios extra para Debian Bullseye" \
3 "Configurar repositorios extra para Debian Testing" \
4 "Configurar repositorios extra para Devuan Beowulf" \
5 "Configurar repositorios extra para Devuan Chimaera" \
6 "Configurar repositorios extra para Ubuntu 20.04 LTS" \
7 "No configurar repositorios adicionales" \
8 "Ayuda" \
9 "Salir")

echo $opRepositorios

if [[ $opRepositorios == 1 ]]; then # Instalar repositorios Quirinux - Debian Buster
clear
_sourcesDebian
_okrepo
_menuPrincipal
fi

if [[ $opRepositorios == 2 ]]; then # Instalar repositorios Quirinux - Debian Bullseye
clear
_bullseye
_okrepo
_menuPrincipal
fi

if [[ $opRepositorios == 3 ]]; then # Instalar repositorios Quirinux - Debian Testing
clear
_bullseye
_okrepo
_testing
_menuPrincipal
fi

if [[ $opRepositorios == 4 ]]; then # Instalar repositorios Quirinux - Devuan Beowulf
clear
_sourcesDevuan
_okrepo
_menuPrincipal

fi

if [[ $opRepositorios == 5 ]]; then # Instalar repositorios Quirinux - Devuan Chimaera
clear
_sourcesChim
_okrepo
_menuPrincipal

fi

if [[ $opRepositorios == 6 ]]; then # Instalar repositorios Quirinux - Ubuntu 20.04
clear
_sourcesUbuntu
_okrepo
_menuPrincipal

fi

if [[ $opRepositorios == 7 ]]; then # Salir
clear
_menuPrincipal
fi

if [[ $opRepositorios == 8 ]]; then # AyudaRepositorios
clear
_ayudaRepositorios
fi

if [[ $opRepositorios == 9 ]]; then # Salir
clear
_salir
fi
}

# ===========================================================================================
# AYUDA DEL MENÚ REPOSITORIOS [CASTELLANO]
# ===========================================================================================

function _ayudaRepositorios() {

dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
--title "AYUDA" \
--msgbox "\nQuirinux se crea sobre una instalación fresca de Debian Bullseye XFCE e incluye programas instalados desde repositorios específicos (Linux Mint, Cinelerra y otros). Si utilizas Debian Bullseye XFCE o alguna derivada directa como Mint puedes instalar estos repositorios con tranquilidad sobre Debian Bullseye.\n\n Ofrecemos la opción para instalar también repositorios de Buster, Devuan y Ubuntu pero no podemos garantizar que vayan a funcionar al 100%.\n\n." 23 100
_menuRepositorios
}

# ===========================================================================================
# MENÚ PRINCIPAL [CASTELLANO]
# ===========================================================================================

function _menuPrincipal() {

opPrincipal=$(dialog --title "MENÚ PRINCIPAL" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
--stdout \
--menu "Elije una opción" 16 50 8 \
1 "Instalar Quirinux Edición General" \
2 "Instalar Quirinux Edición Pro" \
3 "Instalar componentes sueltos" \
4 "Instalar programas sueltos" \
5 "Ayuda" \
6 "Salir")

echo $opPrincipal
_checkrepo
if [[ $opPrincipal == 1 ]]; then # Instalar Quirinux Edición General
clear
_instalarGeneral
_menuPrincipal
fi

if [[ $opPrincipal == 2 ]]; then # Instalar Quirinux Edición Pro
clear
_instalarPro
_menuPrincipal
fi

if [[ $opPrincipal == 3 ]]; then # Instalar componentes sueltos
clear
_instalarSueltos
fi

if [[ $opPrincipal == 4 ]]; then # Instalar programas sueltos
clear
_instalarProgramasSueltos
fi

if [[ $opPrincipal == 5 ]]; then # Ayuda
clear
_ayudaPrincipal
fi

if [[ $opPrincipal == 6 ]]; then # Salir
clear
_salir
fi
}

function _instalarDialog() {
sudo apt-get install dialog -y
}

function _checkrepo() {
FILE="/opt/requisitos/ok-repo"

if [ ! -e ${FILE} ]; then

_warningRepo

fi
}

# ===========================================================================================
# AYUDA DEL MENÚ PRINCIPAL [CASTELLANO]
# ===========================================================================================

function _ayudaPrincipal() {

dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
--title "AYUDA" \
--msgbox "*Programa para crear Quirinux sobre Debian Buster XFCE*\n\nINSTALAR QUIRINUX EDICIÓN GENERAL:\nOficina, internet, compresión de archivos, pdf y editores básicos de gráficos, redes, virtualización, audio y video.\n\nINSTALAR QUIRINUX EDICIÓN PRO:\nHerramientas de la edición General + Software profesional para la edición de gráficos, animación 2D, 3D y Stop-Motion, audio y video.\n\nINSTALAR COMPONENTES / PROGRAMAS SUELTOS:\nPermite instalar las cosas por separado y de manera optativa (controladores, programas, codecs, etc).\n\n" 23 90
_menuPrincipal
}

function _instalarDialog() {
sudo apt-get install dialog -y
}

# ===========================================================================================
# MENU INSTALAR COMPONENTES SUELTOS [CASTELLANO]
# ===========================================================================================

function _instalarSueltos() {
cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 23 76 16)
options=(1 "Software de hogar y oficina" off
2 "Software gráfico y de edición multimedia" off
3 "Tipografías adicionales (incluye las de Windows)" off
4 "Temas y salvapantallas de Quirinux" off
5 "Centro de software sencillo de usar" off
6 "Compatibilidad con carpetas compartidas" off
7 "Herramientas para virtualizar otros sistemas" off
8 "Herramientas para generar imágenes ISO de Quirinux" off
9 "Utilidad para usar digitalizadoras con 2 monitores" off
10 "Firmware para placas de red Wifi" off
11 "Controladores libres para hardware de red - excepto wifi" off
12 "Controladores libres para escáneres e impresoras" off
13 "Codecs privativos multimedia y RAR" off
14 "Controladores libres para aceleradoras NVIDEA" off
15 "Controladores libres para aceleradoras AMD" off
16 "Controladores libres para WACOM" off
17 "Controladores libres para tabletas GENIUS" off
18 "Controladores para cámaras virtuales" off
19 "Utilidades de backup y puntos de restauración" off
20 "Asistente Quirinux (incluye update y estilos)" off
21 "Corrección de bugs (recomendado)" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
case $choice in

1) # "Programas para usuarios en general"
clear
_baseBusterGeneral
_utiles
_olive
_wicd
;;

2) # "Programas para realizadores audiovisuales"
clear
_baseBusterPro
;;

3) # "Tipografías adicionales (incluye las de Windows)"
clear
_fuentes
_tipografiasPro
;;

4) # "Temas y salvapantallas de Quirinux"
clear
_temas
_salvapantallas
;;

5) # "Centro de software sencillo de usar (estilo Android)"
clear
_centroDeSoftware
;;

6) # "Compatibilidad con carpetas compartidas y redes de Microsoft"
clear
_samba
;;

7) # "Herramientas para virtualizar otros sistemas operativos (AQEMU)"
clear
_aqemu
;;

8) # "Herramientas para generar imagenes ISO de Quirinux"
clear
_eggs
;;

9) # "Utilidad para usar digitalizadoras con 2 monitores (para XFCE)"
clear
_ptxconf
;;

10) # "Firmware para placas de red Wifi"
clear
_firmwareWifi
;;

11) # "Controladores libres para hardware de red - excepto wifi"
clear
_libresRed
;;

12) # "Controladores libres para escáneres e impresoras"
clear
_libresImpresoras
;;

13) # "Codecs privativos multimedia y RAR"
clear
_codecs
;;

14) # "Controladores libres para aceleradoras gráficas nVidia"
clear
_libresNvidia
;;

15) # "Controladores libres para aceleradoras gráficas AMD"
clear
_libresAMD
;;

16) # "Controladores libres para digitalizadoras Wacom"
clear
_libresWacom
;;

17) # "Controladores libres para tabletas digitalizadoras Genius"
clear
_libresGenius
;;

18) # "Controladores para cámaras virtuales"
clear
_camarasVirtuales
;;

19) # "Utilidades de backup y puntos de restauración"
clear
_mint
;;

20) # "Asistente Quirinux"
clear
_asistente
;;

21) # "Corrección de bugs (recomendado)"
clear
_pulseaudio
;;

esac
done

_menuPrincipal

}

# ===========================================================================================
# INSTALAR PROGRAMAS SUELTOS [CASTELLANO]
# ===========================================================================================

_instalarProgramasSueltos() {
cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 28 76 16)
options=(
\
1 "Ardour (editor de audio multipista)" off
2 "Azpainter (similar a Paint tool SAI)" off
3 "Base general (firefox, bleachbit, PDFArranger etc)" off
4 "Base Pro (krita, obs, synfig, xsane, etc)" off
5 "Belle (editor de aventuras gráficas)" off
6 "Blender (animación 2D, 2.5D y 3D)" off
7 "Cinelerra (editor de video profesional)" off
8 "CPU Core Utils (gestionar procesador)" off
9 "Densify (reducir peso de PDF)" off
10 "Enve (editor para motion graphics)" off
11 "GIMP Edición Quirinux (similar a Photoshop)" off
12 "Godot (desarrollo de videojuegos)" off
13 "Huayra-stopmotion (stop-motion sencillo)" off
14 "Imagine (reducir peso de fotografías)" off
15 "Inkscape (editor de gráficos vectoriales)" off
16 "Kitchscenarist (editor para guionistas)" off
17 "Usuarios (gestionar usuarios)" off
18 "Mystiq (conversor de formatos)" off
19 "Natron (composición y FX)" off
20 "Olive (editor de video sencillo)" off
21 "Openboard (convertir pantalla en pizarra)" off
22 "Opentoonz (animación 2D industrial)" off
23 "qStopMotion (animación stop-motion)" off
24 "Quinema (herramientas para animación)" off
25 "Storyboarder (editor de storyboards)" off
26 "Tahoma (animación 2D y Stop-Motion)" off
27 "Tupitube (animación 2D y stop-motion)" off
28 "W-Convert(convertir mp4 para Windows / Whatsapp)" off
)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices; do
case $choice in

1) # "Ardour (editor de audio multipista)"
clear
_ardour
;;

2) # "Azpainter (similar a Paint tool SAI)"
clear
_azpainter
;;

3) # "Base general (firefox, bleachbit, PDFArranger etc)"
clear
_baseBusterGeneral
;;

4) # "Base Pro (krita, obs, synfig, xsane, etc)"
clear
_baseBusterPro
;;

5) # "Belle (editor de aventuras gráficas)"
clear
_belle
;;

6) # "Blender (animación 2D, 2.5D y 3D)"
clear
_blender
;;

7) # "Cinelerra (editor de video profesional)"
clear
_cinelerra
;;

8) # "CPU Core Utils (gestionar procesador)"
clear
_cpuCoreUtils
;;

9) # "Densify (reducir peso de PDF)"
clear
_densify
;;

10) # "Enve (editor para motion graphics)"
clear
_enve
;;

11) # "GIMP Edición Quirinux (similar a Photoshop)"
clear
_GIMP
;;

12) # "Godot (desarrollo de videojuegos)"
clear
_godot
;;

13) # "Huayra-stopmotion (stop-motion sencillo)"
clear
_huayra
;;

14) # "Imagine (reducir peso de fotografías)"
clear
_imagine
;;

15) # "Inkscape (editor de gráficos vectoriales)"
clear
_inkscape
;;

16) # "Kitchscenarist (editor para guionistas)"
clear
_kitscenarist
;;

17) # "Mugshot (gestionar usuarios)"
clear
_mugshot
;;

18) # "Mystiq (conversor de formatos)"
clear
_mystiq
;;

19) # "Natron (composición y FX)"
clear
_natron
;;

20) # "Olive (editor de video sencillo)"
clear
_olive
;;

21) # "Openboard (convertir pantalla en pizarra)"
clear
_openboard
;;

22) # "Opentoonz (animación 2D industrial)"
clear
_opentoonz
;;

23) # "qStopMotion (animación stop-motion)"
clear
_qstopmotion
;;

24) # "Quinema (herramientas para animación)"
clear
_quinema
;;

25) # "Storyboarder (editor de storyboards)"
_storyboarder
;;

26) # "Tahoma (animación 2D y Stop-Motion)"
clear
_tahoma2D
;;

27) # "Tupitube (animación 2D y stop-motion)"
clear
_tupitube
;;

28) # "w-convert (conversor)"
clear
_w-convert
;;

esac
done

_menuPrincipal

}

# ===========================================================================================
# REPOSITORIOS BULLSEYE
# ===========================================================================================

function _bullseye() {

# AGREGA REPOSITORIOS ADICIONALES PARA DEBIAN BULLSEYE Y EL COMANDO "QUIRINUX-LIBRE"

clear
apt-get autoremove --purge repoconfigdeb -y
sudo mkdir -p /opt/tmp/apt
sudo wget --no-check-certificate 'https://quirinux.ga/extras/repoconfigbull_1.1.1_all.deb' -O /opt/tmp/apt/repoconfigbull_1.1.1_all.deb
sudo apt install /opt/tmp/apt/./repoconfigbull_1.1.1_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEBIAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
apt-get update

touch /opt/requisitos/ok-bullseye

}

function _testing() {

apt-get autoremove --purge repoconfigbull -y

# AGREGA REPOSITORIOS ADICIONALES PARA DEBIAN TESTING Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget --no-check-certificate 'https://quirinux.ga/extras/repoconfigtesting_1.1.1_all.deb' -O /opt/tmp/apt/repoconfigtesting_1.1.1_all.deb
sudo apt install /opt/tmp/apt/./repoconfigtesting_1.1.1_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEBIAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
apt-get update

}

function _warningPrevia() {

dialog --backtitle "REQUISITO INCUMPLIDO" \
--title "NO SE ENCONTRÓ QUIRINUX S/BUSTER" \
--msgbox "\nNo se puede actualizar a Bullseye si antes no se ha instalado Quirinux 2.0 sobre Buster" 23 100
_menuPrincipal
}

function _warningRepo() {

dialog --backtitle "REQUISITO INCUMPLIDO" \
--title "SE NECESITAN REPOSITORIOS" \
--msgbox "\nSe requiere instalar repositorios adicionales de Quirinux. Por favor, elije el que sea compatible con tu distribución." 23 100
_menuRepositorios
}


# ===========================================================================================
# FUNCIONES SIN SALIDA EN PANTALLA [NO NECESITAN TRADUCCIÓN]
# ===========================================================================================

function _instalarGeneral() {
clear
_centroDeSoftware
#_firmwareWifi
_codecs
#_controladoresLibres
_programasGeneral
_pulseaudio
_previaVerif
_limpiar
}

function _controladoresLibres() {
clear
#_libresNvidia
#_libresAMD
_libresWacom
_libresGenius
_libresImpresoras
#_libresRed
}

function _programasGeneral() {
clear
_splash
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
_asistente
_pulseaudio
_eggs
_w-convert
_applications-general

}

function _instalarPro() {
clear
_instalarGeneral
_baseBusterPro
_tipografiasPro
_especializadosPro
_limpiar
}

function _especializadosPro() {
clear
_inkscape
_tupitube
_godot
_storyboarder
_opentoonz
_kitscenarist
_natron
_azpainter
_enve
_quinema
_qstopmotion
_camarasVirtuales
_belle
_mypaint
_cinelerra
_tahoma2D
_blender
_ardour
_pluginEntangle
_huayra
_borratemp

}

function _utiles() {
clear
_mugshot
_mystiq
_densify
_imagine
_openboard
_cpuCoreUtils
_borratemp
}

function _applications-general()
{

clear
apt-get install applications-general -y

}

function _previaVerif()
{
	
FILE="/opt/requisitos/ok-buster"

if [ -e ${FILE} ]; then

touch /opt/requisitos/ok-bullseye

fi
	
}

function _okrepo()
{
	
FILE="/opt/requisitos/ok-repo"

if [ ! -e ${FILE} ]; then

touch /opt/requisitos/ok-repo

fi
	
}

function _config() {

# CONFIGURACIÓN PREDETERMINADA DE SUDOERS DE QUIRINUX

clear
apt-get install sudoersquirinux -y

# ESTABLECE SOPORTE MULTIARQUITECTURA PARA 32 BITS

clear
sudo dpkg --add-architecture i386

}

function _sourcesDebian() {

# AGREGA REPOSITORIOS ADICIONALES PARA DEBIAN BUSTER Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget --no-check-certificate 'https://quirinux.ga/extras/repoconfigdeb_1.1.1_all.deb' -O /opt/tmp/apt/repoconfigdeb_1.1.1_all.deb
sudo apt install /opt/tmp/apt/./repoconfigdeb_1.1.1_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt
touch /opt/requisitos/ok-buster

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEBIAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/
apt-get update

}

function _sourcesDevuan() {

# AGREGA REPOSITORIOS ADICIONALES PARA DEVUAN Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget --no-check-certificate 'https://quirinux.ga/extras/repoconfigdev_1.1.1_all.deb' -O /opt/tmp/apt/repoconfigdev_1.1.1_all.deb
sudo apt install /opt/tmp/apt/./repoconfigdev_1.1.1_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEVUAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/

}

function _sourcesChim() {

# AGREGA REPOSITORIOS ADICIONALES PARA DEVUAN Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget --no-check-certificate 'https://quirinux.ga/extras/repoconfigchim_1.1.1_all.deb' -O /opt/tmp/apt/repoconfigchim_1.1.1_all.deb
sudo apt install /opt/tmp/apt/./repoconfigchim_1.1.1_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEVUAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/

}

function _asistente() {

clear
sudo apt-get install quirinuxasistente, quirinuxupdate, quirinuxestilos -y
}

function _sourcesUbuntu() {

# AGREGA REPOSITORIOS ADICIONALES PARA UBUNTU

clear
sudo mkdir -p /opt/tmp/apt
sudo wget --no-check-certificate "https://quirinux.ga/extras/repoconfigubu_1.1.1_all.deb" -O /opt/tmp/apt/repoconfigubu_1.1.1_all.deb
sudo apt install /opt/tmp/apt/./repoconfigubu_1.1.1_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt
}

function _eggs() {
clear
apt-get install eggs -y

}

function _wicd() {
clear
apt-get install network-manager -y

}

function _firmwareWifi() {

# INSTALAR FIRMWARE (CONTROLADORES PRIVATIVOS)

clear
for paquetes_firmware_q in firmware-intel-sound firmware-ath9k-htc grub-firmware-qemu firmware-misc-nonfree firmware-linux firmware-netronome firmware-samsung firmware-netxen firmware-bnx2 firmware-ipw2x00 firmware-bnx2x ubertooth-firmware-source firmware-linux-free firmware-ti-connectivity firmware-ath9k-htc-dbgsym firmware-linux-nonfree firmware-zd1211 firmware-brcm80211 firmware-siano firmware-microbit-micropython firmware-realtek firmware-libertas firmware-iwlwifi dahdi-firmware-nonfree firmware-cavium firmware-adi firmware-qcom-media firmware-qlogic firmware-ivtv sigrok-firmware-fx2lafw dns323-firmware-tools firmware-amd-graphics firmware-atheros firmware-microbit-micropython-doc firmware-myricom firmware-intelwimax firmware-ralink expeyes-firmware-dev; do sudo apt-get install -y $paquetes_firmware_q; done
for paquetes_firmware in firmware-linux firmware-linux-nonfree hdmi2usb-fx2-firmware firmware-ralink firmware-realtek firmware-intelwimax firmware-iwlwifi firmware-b43-installer firmware-b43legacy-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-atheros dahdi-firmware-nonfree dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 hdmi2usb-fx2-firmware nxt-firmware sigrok-firmware-fx2lafw dns323-firmware-tools firmware-adi firmware-amd-graphics firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound firmware-intelwimax firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netronome firmware-netxen firmware-qcom-media firmware-qlogic firmware-ralink firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 dahdi-firmware-nonfree nxt-firmware sigrok-firmware-fx2lafw; do sudo apt-get install -y $paquetes_firmware; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _codecs() {

# INSTALAR CODECS Y FORMATOS PRIVATIVOS

clear
for paquetes_codecs in mint-meta-codecs unace-nonfree rar unrar; do sudo apt-get install -y $paquetes_codecs; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresNvidia() {

# INSTALAR CONTROLADORES LIBRES DE NVIDIA

clear
for paquetes_nvidia in bumblebee; do sudo apt-get install -y $paquetes_nvidia; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _libresWacom() {

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS WACOM

clear
sudo apt-get install build-essential autoconf linux-headers-$uname -u -y
sudo wget --no-check-certificate 'https://quirinux.ga/extras/input-wacom-0.46.0.tar.bz2' -O /opt/tmp/input-wacom-0.46.0.tar.bz2
cd /opt/tmp
tar -xjvf /opt/tmp/input-wacom-0.46.0.tar.bz2
cd input-wacom-0.46.0
if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresGenius() {

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS GENIUS

clear
apt-get install geniusconfig -y
apt-get install wizardpen -y

}

function _libresImpresoras() {

# INSTALAR PAQUETES DE IMPRESIÓN Y ESCANEO LIBRES

clear
for paquetes_scaner_impresion in build-essential tix foomatic-filters groff dc cups cups-pdf ink autoconf git wget avahi-utils system-config-printer-udev colord flex g++ libtool python-dev sane sane-utils system-config-printer system-config-printer-udev unpaper xsltproc zlibc foomatic-db-compressed-ppds ghostscript-x ghostscript-cups gocr-tk gutenprint-locales openprinting-ppds printer-driver-brlaser printer-driver-all printer-driver-cups-pdf cups-client cups-bsd cups-filters cups-pdf cups-ppdc printer-driver-c2050 printer-driver-c2esp printer-driver-cjet printer-driver-dymo printer-driver-escpr printer-driver-fujixerox printer-driver-gutenprint printer-driver-m2300w printer-driver-min12xxw printer-driver-pnm2ppa printer-driver-ptouch printer-driver-pxljr printer-driver-sag-gdi printer-driver-splix; do sudo apt-get install -y $paquetes_scaner_impresion; done
sudo apt-get install cups
sudo apt-get install -f -y
sudo apt-get remove --purge hplip cups-filters cups hplip-data system-config-printer-udev -y
sudo apt-get remove --purge hplip -y
sudo rm -rf /usr/share/hplip
sudo rm -rf /var/lib/hp
apt-get install simple-scan -y
apt-get install impresoras -y
apt-get install epsonscan -y
epson-install

}

function _libresRed() {

# INSTALAR PAQUETES DE RED LIBRES

clear
for paquetes_red in mobile-broadband-provider-info pppconfig hardinfo modemmanager modem-manager-gui modem-manager-gui-help usb-modeswitch usb-modeswitch-data wvdial; do sudo apt-get install -y $paquetes_red; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresAMD() {

# INSTALAR CONTROLADORES DE VIDEO AMD LIBRES

clear
for paquetes_amd in mesa-opencl-icd mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers libdrm-amdgpu1 xserver-xorg-video-amdgpu; do sudo apt-get install -y $paquetes_amd; done
sudo apt-get install -f
sudo apt-get autoremove --purge -y

}

function _baseBusterGeneral() {

# INSTALAR PAQUETES BASE DE BUSTER

FILE="/opt/requisitos/ok-bullseye"

if [ ! -e ${FILE} ]; then

clear
for paquetes_buster in mediainfo xfce4-screensaver graphicsmagick mediainfo-gui firefox-esr firefox-l10n-de firefox-esr-l10n-es firefox-l10n-fr firefox-esr-l10n-gl firefox-esr-l10n-ru firefox-esr-l10n-it firefox-esr-l10n-pt converseen bluetooth h264enc bluez gvfs-backends bluez-cups bluez-obexd libbluetooth-dev libbluetooth3 blueman connman bluez-firmware conky conky-all libimobiledevice-utils kcharselect kpat thunderbird thunderbird-l10n-de thunderbird-l10n-es-es thunderbird-l10n-fr thunderbird-l10n-gl thunderbird-l10n-it thunderbird-l10n-pt-br thunderbird-l10n-pt-pt thunderbird-l10n-ru thunderbird-l10n-es-ar xdemineur default-jre cairo-dock cairo-dock-plug-ins chromium dia tumbler tumbler-plugins-extra ffmpegthumbnailer kpat ktorrent photopc usermode go-mtpfs pdfarranger build-essential gtk3-engines-xfce make automake cmake engrampa python-glade2 shotwell xinput-calibrator libsox-fmt-mp3 gvfs-fuse breeze-icon-theme-rcc libsmbclient python-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs smbclient python-smbc breeze lightdm liblensfun-bin galculator gufw pacpl kde-config-tablet imagemagick x264 vlc-plugin-vlsub gnome-system-tools ffmpeg audacity kolourpaint mtp-tools xinput gparted font-manager hdparm prelink unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full p7zip-rar gzip lzip screenkey kazam gdebi brasero breeze-icon-theme zip abr2gbr gtkam-gimp gphoto2 gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings vlc gdebi ifuse kdeconnect menulibre catfish bleachbit prelink packagekit packagekit-tools; do sudo apt-get install -y $paquetes_buster; done
apt-get install onboard -t bullseye -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
else
for paquetes_buster in onboard mediainfo graphicsmagick mediainfo-gui firefox-esr firefox-l10n-de firefox-esr-l10n-es firefox-l10n-fr firefox-esr-l10n-gl firefox-esr-l10n-ru firefox-esr-l10n-it firefox-esr-l10n-pt converseen bluetooth h264enc bluez gvfs-backends bluez-cups bluez-obexd libbluetooth-dev libbluetooth3 blueman connman bluez-firmware conky conky-all libimobiledevice-utils kcharselect kpat thunderbird thunderbird-l10n-de thunderbird-l10n-es-es thunderbird-l10n-fr thunderbird-l10n-gl thunderbird-l10n-it thunderbird-l10n-pt-br thunderbird-l10n-pt-pt thunderbird-l10n-ru thunderbird-l10n-es-ar xdemineur default-jre cairo-dock cairo-dock-plug-ins chromium dia tumbler tumbler-plugins-extra ffmpegthumbnailer kpat ktorrent photopc usermode go-mtpfs pdfarranger build-essential gtk3-engines-xfce make automake cmake engrampa python-glade2 shotwell xinput-calibrator libsox-fmt-mp3 gvfs-fuse breeze-icon-theme-rcc libsmbclient python-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs smbclient python-smbc breeze lightdm liblensfun-bin galculator gufw pacpl kde-config-tablet imagemagick x264 vlc-plugin-vlsub gnome-system-tools ffmpeg audacity kolourpaint mtp-tools xinput gparted font-manager hdparm prelink unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full p7zip-rar gzip lzip screenkey kazam gdebi brasero breeze-icon-theme zip abr2gbr gtkam-gimp gphoto2 gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings vlc gdebi ifuse kdeconnect menulibre catfish bleachbit prelink packagekit packagekit-tools; do sudo apt-get install -y $paquetes_buster; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
fi

}

function _ptxconf() {

# INSTALAR UTILIDAD PTXCONF (MAPPING)

clear
sudo mkdir -p /opt/tmp/ptxtemp
sudo wget --no-check-certificate 'https://quirinux.ga/extras/ptxconf.tar' -O /opt/tmp/ptxtemp/ptxconf.tar
sudo tar -xvf /opt/tmp/ptxtemp/ptxconf.tar -C /opt/
cd /opt/ptxconf
sudo python setup.py install
sudo apt-get install -f -y
sudo apt-get install libappindicator1 -y
sudo mkdir -p /opt/tmp/python-appindicator
sudo wget --no-check-certificate 'https://quirinux.ga/extras/python-appindicator_0.4.92-4_amd64.deb' -O /opt/tmp/python-appindicator/python-appindicator_0.4.92-4_amd64.deb
sudo apt install /opt/tmp/python-appindicator/./python-appindicator_0.4.92-4_amd64.deb -y
sudo apt-get install python-gtk2 -y

# Agrega entrada al inicio para PTXCONFIG

for usuarios_ptx in /home/*; do sudo yes | sudo cp -r -a -f /opt/ptxconf/.config $usuarios_ptx; done

}

function _chimiboga() {

# INSTALAR CHIMIBOGA - CHIMI VIDEOJUEGO

clear
apt-get install chimiboga -y

}

function _splash() {

# INSTALAR SPLASH DE QUIRINUX

clear
apt-get install quirinuxsplash -y

}

function _samba() {

# INSTALAR SAMBA Y CONFIGURADOR PARA SAMBA DE UBUNTU

clear
apt-get install system-config-samba -y

}

function _mugshot() {

# INSTALAR MUGSHOT

clear
apt-get install usuarios -y

}

function _mystiq() {

# INSTALAR CONVERSOR MYSTIQ DESDE OPENSUSE

clear
for paquetes_mystiq in mystiq; do sudo apt-get install -y $paquetes_mystiq; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _densify() {

# INSTALAR DENSIFY (para reducir archivos PDF)

clear
apt-get install densify -y

}

function _imagine() {

# INSTALAR IMAGINE (para reducir imágenes)

clear
apt-get install imagine -y

}

function _openboard() {

# INSTALAR OPENBOARD (Convierte la pantalla en una pizarra)

clear
apt-get install openboard -y

}

function _cpuCoreUtils() {

# INSTALAR PROGRAMA PARA CONFIGURAR EL RENDIMIENTO DEL PROCESADOR

clear
apt-get install cpufreq cpufrequtils -y

}

function _olive() {

# INSTALAR EDITOR DE VIDEO OLIVE - Version elegida por Quirinux

clear
apt-get install oliveq -y

}

function _GIMP() {

# INSTALAR GIMP EDICION QUIRINUX

clear
apt-get install gimp-quirinux gimp-paint-studio -y

}

function _aqemu() {

# INSTALAR PAQUETES DE VIRTUALIZACIÓN

clear
for paquetes_virtualizacion in aqemu qemu-kvm qemu-system-data qemu-block-extra intel-microcode amd-microcode qemu-system libvirt; do sudo apt-get install -y $paquetes_virtualizacion; done
sudo apt-get install -f -y

}

function _w-convert() {

# INSTALAR W-CONVERT

clear
apt-get install w-convert -y

}

function _mint() {

# INSTALAR MINTBACKUP, MINTUPDATE y TIMESHIFT

clear
for paquetes_extra in mintbackup mintupdate timeshift; do sudo apt-get install -y $paquetes_extra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _centroDeSoftware() {

# INSTALAR GESTOR DE PAQUETES DE MINT SIN FLATPAK

clear
sudo apt-get upgrade -y
sudo apt-get dist-ugprade -y
sudo apt-get install mintinstall -y
sudo apt-get autoremove --purge flatpak -y

# apt-get install gnome-software -y

# INSTALAR FLATPAK-CONFIG

clear
apt-get install flatpakconfig -y

}

function _salvapantallas() {

# INSTALAR SCREENSAVER GLUCLO

clear

apt-get install gluqlo -y

}

function _fuentes() {

# Descargando y copiando fuentes de Quirinux
clear
apt-get install quirinux-fuentes -y

}

function _temas() {

# OTORGANDO PERMISOS PARA MODIFICAR TEMAS

clear
sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# INSTALAR TEMAS DE QUIRINUX
clear
apt-get install quirinuxtemas -y

# INSTALAR ÍCONOS DE QUIRINUX
clear
apt-get install icons-winbugs -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX')
# También instala menú principal de Quirinux y modifica algunos archivos más.
clear
apt-get install quirinuxconfig -y
update-grub
update-grub2

# PERSONALIZANDO PANELES DE USUARIO DE QUIRINUX
clear
for usuarios1 in /home/*; do sudo chmod 777 -R $usuarios1; done
for usuarios2 in /home/*; do sudo yes | sudo cp -r -f -a /etc/skel/* $usuarios2; done

# OTORGANDO PERMISOS PARA MODIFICAR CONFIGURACIÓN DE CARPETAS DE USUARIO
clear
sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod u+s /usr/sbin/hddtemp

}

function _red() {

# ELIMINANDO ERRORES DE INICIO (RED
clear
sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >>/etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

}

function _pulseaudio() {

# REINSTALAR PULSEAUDIO
clear
sudo apt-get remove --purge pulseuadio pavucontrol -y
sudo apt-get clean
sudo apt-get autoremove --purge -y
sudo rm -r ~/.pulse ~/.asound* ~/.pulse-cookie ~/.config/pulse
sudo apt-get install pulseaudio rtkit pavucontrol -y
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _remover() {

# REMOVER IRQBALANCE
for paquetes_irq in irqbalance; do sudo apt-get remove --purge -y $paquetes_irq; done

# REMOVER TRADUCCIONES DE FIREFOX DE IDIOMAS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_firefox in keditbookmarks firefox-esr-l10n-bn-bd firefox-esr-l10n-bn-in refox-esr-l10n-kn firefox-esr-l10n-kn firefox-esr-l10n-lt firefox-esr-l10n-ml firefox-esr-l10n-ml firefox-esr-l10n-ar firefox-esr-l10n-ast firefox-esr-l10n-be firefox-esr-l10n-bg firefox-esr-l10n-bn firefox-esr-l10n-bs firefox-esr-l10n-ca firefox-esr-l10n-cs firefox-esr-l10n-cy firefox-esr-l10n-da firefox-esr-l10n-el firefox-esr-l10n-eo firefox-esr-l10n-es-cl firefox-esr-l10n-es-mx firefox-esr-l10n-et firefox-esr-l10n-eu firefox-esr-l10n-fa firefox-esr-l10n-fi firefox-esr-l10n-ga-ie firefox-esr-l10n-gu-in firefox-esr-l10n-he firefox-esr-l10n-hi-in firefox-esr-l10n-hr firefox-esr-l10n-hu firefox-esr-l10n-id firefox-esr-l10n-is firefox-esr-l10n-ja firefox-esr-l10n-kk firefox-esr-l10n-km firefox-esr-l10n-ko firefox-esr-l10n-lv firefox-esr-l10n-mk firefox-esr-l10n-mr firefox-esr-l10n-nb-no firefox-esr-l10n-ne-np firefox-esr-l10n-nl firefox-esr-l10n-nn-no firefox-esr-l10n-pa-in firefox-esr-l10n-pl firefox-esr-l10n-ro firefox-esr-l10n-si firefox-esr-l10n-sk firefox-esr-l10n-sl firefox-esr-l10n-sq firefox-esr-l10n-sr firefox-esr-l10n-sv-se firefox-esr-l10n-ta firefox-esr-l10n-te firefox-esr-l10n-th firefox-esr-l10n-tr firefox-esr-l10n-uk firefox-esr-l10n-vi firefox-esr-l10n-zh-cn firefox-esr-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_firefox; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER TRADUCCIONES DE ESCRITORIO DE IDIOMAS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_task in task-albanian-desktop task-amharic-desktop task-arabic-desktop task-asturian-desktop task-basque-desktop task-belarusian-desktop task-bengali-desktop task-bosnian-desktop task-bulgarian-desktop task-catalan-desktop task-croatian-desktop task-czech-desktop task-danish-desktop task-dutch-desktop task-dzongkha-desktop task-esperanto-desktop task-estonian-desktop task-finnish-desktop task-georgian-desktop task-greek-desktop task-gujarati-desktop task-hindi-desktop task-hungarian-desktop task-icelandic-desktop task-indonesian-desktop task-irish-desktop task-kannada-desktop task-kazakh-desktop task-khmer-desktop task-kurdish-desktop task-latvian-desktop task-lithuanian-desktop task-macedonian-desktop task-malayalam-desktop task-marathi-desktop task-nepali-desktop task-northern-sami-desktop task-norwegian-desktop task-persian-desktop task-polish-desktop task-punjabi-desktop task-romanian-desktop task-serbian-desktop task-sinhala-desktop task-slovak-desktop task-slovenian-desktop task-south-african-english-desktop task-tamil-desktop task-telugu-desktop task-thai-desktop task-turkish-desktop task-ukrainian-desktop task-uyghur-desktop task-vietnamese-desktop task-welsh-desktop task-xhosa-desktop task-chinese-s-desktop; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_task; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER CONJUNTOS DE CARACTERES DE IDIOMAS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_ibus in inicatalan ipolish idanish idutch ibulgarian icatalan ihungarian ilithuanian inorwegian iswiss iukrainian ihungarian ilithuanian inorwegian ipolish iukrainian iswiss; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_ibus; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DICCIONARIOS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_mythes in myspell-et; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_mythes; done
for paquetes_remover_idiomas_aspell in aspell-hi aspell-ml aspell-mr aspell-pa aspell-ta aspell-te aspell-gu aspell-bn aspell-no aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-da aspell-el aspell-eo aspell-et aspell-eu aspell-he aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lt aspell-lv aspell-nl aspell-no aspell-pl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-pl aspell-eo aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-cy aspell-el aspell-et aspell-eu aspell-fa aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lv aspell-nl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-uk; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_aspell; done
for paquetes_remover_idiomas_hunspell in hunspell-ar hunspell-ml hunspell-be hunspell-bg hunspell-bs hunspell-ca hunspell-cs hunspell-da hunspell-eu hunspell-gu hunspell-hi hunspell-hr hunspell-hu hunspell-id hunspell-is hunspell-kk hunspell-kmr hunspell-ko hunspell-lt hunspell-lv hunspell-ne hunspell-nl hunspell-ro hunspell-se hunspell-si hunspell-sl hunspell-sr hunspell-sv hunspell-sv-se hunspell-te hunspell-th hunspell-de-at hunspell-de-ch hunspell-de-de hunspell-vi; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_hunspell; done
for paquetes_remover_idiomas_myspell in myspell-eo myspell-fa myspell-ga myspell-he myspell-nb myspell-nn myspell-sk myspell-sq mythes-cs mythes-de-ch mythes-ne mythes-pl mythes-sk; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_myspell; done
for paquetes_remover_idiomas_hyphen in hyphen-hr hyphen-hu hyphen-lt; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_hyphen; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER FUENTES QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_fonts in fonts-arabeyes fonts-nanum fonts-crosextra-carlito fonts-nanum-coding fonts-tlwg-kinnari-ttf fonts-tlwg-kinnari fonts-thai-tlwg fonts-tlwg* fonts-vlgothic fonts-arphic-ukai fonts-arphic-uming fonts-lohit-knda fonts-lohit-telu fonts-ukij-uyghur; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_fonts; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER IDIOMAS DE LIBRE OFFICE QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_libreoffice in libreoffice-help-ca libreoffice-help-cs libreoffice-help-da libreoffice-help-dz libreoffice-help-el libreoffice-help-et libreoffice-help-eu libreoffice-help-fi libreoffice-help-gl libreoffice-help-hi libreoffice-help-hu libreoffice-help-ja libreoffice-help-km libreoffice-help-ko libreoffice-help-nl libreoffice-help-pl libreoffice-help-sk libreoffice-help-sl libreoffice-help-sv libreoffice-help-zh-cn libreoffice-help-zh-tw fonts-linuxlibertine fonts-droid-fallback fonts-noto-mono libreoffice-l10n-ar libreoffice-l10n-ast libreoffice-l10n-be libreoffice-l10n-bg libreoffice-l10n-bn libreoffice-l10n-bs libreoffice-l10n-ca libreoffice-l10n-cs libreoffice-l10n-da libreoffice-l10n-dz libreoffice-l10n-el libreoffice-l10n-en-za libreoffice-l10n-eo libreoffice-l10n-et libreoffice-l10n-eu libreoffice-l10n-fa libreoffice-l10n-fi libreoffice-l10n-ga libreoffice-l10n-gu libreoffice-l10n-he libreoffice-l10n-hi libreoffice-l10n-hr libreoffice-l10n-hu libreoffice-l10n-id libreoffice-l10n-islibreoffice-l10n-ja libreoffice-l10n-kalibreoffice-l10n-km libreoffice-l10n-ko libreoffice-l10n-lt libreoffice-l10n-lv libreoffice-l10n-mk libreoffice-l10n-ml libreoffice-l10n-mr libreoffice-l10n-nb libreoffice-l10n-ne libreoffice-l10n-nl libreoffice-l10n-nnlibreoffice-l10n-pa-in libreoffice-l10n-pl libreoffice-l10n-ro libreoffice-l10n-si libreoffice-l10n-sk libreoffice-l10n-sl libreoffice-l10n-srlibreoffice-l10n-sv libreoffice-l10n-ta libreoffice-l10n-te libreoffice-l10n-th libreoffice-l10n-tr libreoffice-l10n-ug libreoffice-l10n-uk libreoffice-l10n-vi libreoffice-l10n-xh libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_libreoffice; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER PROGRAMAS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_programas in xsane xarchiver grsync jami dia gsmartcontrol ophcrack ophcrack-cli whowatch htop zulucrypt-cli zulucrypt-cli balena-etcher-electron keepassxc stacer dino-im dino-im-common etherape eterape-data hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux qassel qassel-data jami jami-daemon liferea liferea-data mumble wahay onionshare qtox signal hydra hydra-gtk bmon grub-customizer spek osmo eom eom-common compton mc mc-data pidgin pidgin-data bluetooth khmerconverter thunderbird fcitx* mozc* webcamoid modem-manager-gui fcitx mlterm-common bluez bluez-firmware culmus synapse apparmor pidgin-otr pidgin-encryption pidgin pidgin-data pidgin-themes pidgin-openpgp libpurple0 dino-im dino-im-common gajim gajim-omemo hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux quassel quassel-data mumble qtox keepassxc mc mc-data osmo exfalso kasumi mlterm parole modem-manager-gui modem-manager-gui-help; do sudo apt-get remove --purge -y $paquetes_remover_programas; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DOCUMENTACIÓN
clear
sudo rm -rf /usr/share/doc/*

}

function _limpiar() {

_borratemp

# LIMPIAR TEMPORALES
clear
sudo rm -rf /opt/tmp/*

# CONFIGURANDO PAQUETES
clear
sudo dpkg --configure -a

# LIMPIANDO CACHE
clear
sudo apt-get clean && sudo apt-get autoclean

# REGENERANDO CACHE
clear
sudo apt-get update --fix-missing

# CONFIGURANDO DEPENDENCIAS
clear
sudo apt-get install -f
sudo apt-get autoremove --purge -y

# _limpiezaAgresiva

}

function _baseBusterPro() {

# INSTALAR PAQUETES ESPECIALIZADOS DESDE BUSTER (KRITA, OBS, SYNFIG, XSANE, ETC)
clear
for paquetes_estandar in manuskript sweethome3d kdenlive guvcview xsane digikam k3d gnome-color-manager aegisub dispcalgui birdfont skanlite pencil2d devede vokoscreen-ng soundconverter hugin calf-plugins invada-studio-plugins-ladspa vlc-plugin-fluidsynth fluidsynth synfig synfigstudio synfig-examples pikopixel.app entangle darktable rawtherapee krita krita-data krita-gmic krita-l10n dvd-styler obs-studio obs-plugins gir1.2-entangle-0.1; do sudo apt-get install -y $paquetes_estandar; done
sudo apt-get install -f -y
clear
_pluginEntangle

}

function _tipografiasPro() {

# INSTALAR TIPOGRAFÍAS PARA DIBUJANTES
clear
apt-get install komikafont -y

}

function _opentoonz() {

clear
apt-get install opentoonz -y

}

function _huayra() {

# INSTALAR HUAYRA-STOPMOTION

clear
apt-get install huayra-stopmotion -y

}

function _tahoma2D() {

# INSTALAR TAHOMA 2D

clear
apt-get install tahoma2d -y

}

function _inkscape() {

# INSTALANDO INKSCAPE

clear
apt-get install inkscape -y

}

function _tupitube() {

# INSTALAR TUPITUBE

clear
apt-get install tupitubedesk -y

}

function _godot() {

# INSTALAR GODOT

clear
apt-get install godot -y

}

function _storyboarder() {

# INSTALAR STORYBOARDER

clear
apt-get install storyboarder -y

}

function _kitscenarist() {

# INSTALAR KITSCENARIST

clear
apt-get install kitscenarist -y

}

function _natron() {

# INSTALAR NATRON

clear
apt-get install natron -y

}

function _azpainter() {

# INSTALAR AZPAINTER

clear
apt-get install azpainter -y

}

function _enve() {

# INSTALAR ENVE

clear
apt-get install enve -y

}

function _quinema() {

# INSTALAR QUINEMA

clear
apt-get install quinema -y

}

function _qstopmotion() {

clear
apt-get install qstopmotion -y

}

function _camarasVirtuales() {

# INSTALAR CONTROLADORES PARA CÁMARAS VIRTUALES
# Complemento útil para qStopMotion y OBS

clear
apt-get install akvcam -y
apt-get install obs-v4l2sink -y


}

function _belle() {

# INSTALAR BELLE

clear
apt-get install belle -y

}

function _mypaint() {

FILE="/opt/requisitos/ok-bullseye"

if [ ! -e ${FILE} ]; then

clear
apt-get install mypaintq -y

else
apt-get install mypaint -y

fi

}

function _cinelerra() {

# INSTALAR EDITOR DE VIDEO PROFESIONAL CINELERRA

clear
apt-get install cinelerragg -y

}

function _blender() {

FILE="/opt/requisitos/ok-bullseye"

if [ ! -e ${FILE} ]; then

clear
apt-get install blenderq -y

else

apt-get install blender -y

fi

}

function _ardour() {

# INSTALAR ARDOUR

clear
apt-get install ardour -y

# INSTALAR PLUGINS PARA ARDOUR

clear
for paquetes_calf in calf-plugins; do sudo apt-get install -y $paquetes_calf; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _pluginEntangle() {

# DESCARGAR PLUGIN STOPMO-PREVIEW PARA ENTANGLE
# Luego será necesario ejecutar el comando instalar-plugin-entangle sin permisos de root.

clear
apt-get install entangleinstallplugin -y

}

_inicioCheck
_menuPrincipal



