#!/bin/bash

# Nombre:	instalar-quirinux.sh
# Autor:	Charlie Martínez® <cmartinez@quirinux.org>
# Licencia:	https://www.gnu.org/licenses/gpl-3.0.txt
# Descripción:	Convierte una instalación limpia de Debian Buster XFCE 64 Bits en Quirinux 2.0
# Versión:	2.0 RC_4

# ===========================================================================================
# DOC EN CASTELLANO
# ===========================================================================================

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# *                                                                                         *
# * 1. ESTRUCTURA                                                                           *
# *	                                                                                        *
# * Emulando, salvando la distancia, a la programación orientada a objetos, este            *
# * programa se encuentra estructurado en funciones para facilitar su modificación.         *
# * Se sugiere utilizar un editor con navegación por símbolos como Geany para mayor         *
# * comodidad.                                                                              *
# * Los menúes de usuario acceden a combinaciones diversas de estas funciones, en su        *
# * mayoría reducidas a mínimas expresiones de procesos para mayor control de cada          *
# * componente individual.                                                                  *
# * Las funciones cuyas referencias vienen por defecto comentadas (por cuestiones de        *
# * seguridad) se encuentran al principio, para favorecer a una rápida auditoría.           *	
# *                                                                                         *	
# * 2. REFERENCIAS COMENTADAS                                                               *
# *                                                                                         *
# * Las referencias a las funciones _borrarTemasActuales() y _limpiezaAgresiva()            *
# * se encuentran comentadas para mayor seguridad de los usuarios finales. Se sugiere       *
# * descomentarlas al momento de generar una ISO, lo que contribuye a disminuir el peso     *
# * de la misma.                                                                            *
# *	                                                                                        *
# * 3. PENDIENTES                                                                           *
# *                                                                                         *
# * Se prevee traducir este programa a los idiomas en los que Quirinux se distribuye:       *
# * inglés, gallego, portugués, alemán, francés, ruso, italiano.                            *
# *                                                                                         *
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# ===========================================================================================
# FUNCIONES PARA GENERACION DE ISO (DESCOMENTAR REFERENCIAS)
# ===========================================================================================


function _borrarTemasActuales()
{
	
clear
sudo rm -rf /usr/share/themes/*
sudo rm -rf /usr/share/backgrounds/*
sudo rm -rf /usr/share/desktop-base/*
sudo rm -rf /usr/share/images/*

}

function _limpiezaAgresiva()
{

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

function _inicioCheck()
{
	
FILE="/usr/local/bin/quirinux-sudoers"

if [ ! -e ${FILE} ]; then

clear
_menuCondicional
_menuRepositorios

else

clear
_menuRepositorios

fi

}

# ===========================================================================================
# INSTALAR PREREQUISITOS [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _preRequisitos()
{

# INSTALAR WGET Y GIT

clear
sudo apt-get update -y
for paquetes_wget in wget git; do sudo apt-get install -y $paquetes_wget; done

}

# ===========================================================================================
# INSTALAR DIALOG [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _instalarDialog()
{
sudo apt-get install dialog -y
}

# ===========================================================================================
# FUNCION SALIR [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _salir()
{

clear
exit 0

}

# ===========================================================================================
# FUNCION BORRAR TEMPORALES [CÓDIGO REUTILIZABLE]
# ===========================================================================================

function _borratemp()
{
sudo rm -rf /opt/tmp/*
clear
}

function _menuCondicional()

{
	
# ===========================================================================================
# MENÚ CONDICIONAL [CASTELLANO]
# ===========================================================================================

echo " -----------------------------------------------------------------------------
 INSTALAR COMPONENTES DE QUIRINUX 2.0
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

_preRequisitos
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

function _menuRepositorios()

{

opRepositorios=$(dialog --title "REPOSITORIOS ADICIONALES" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
--stdout \
--menu "Elije una opción" 16 62 6 \
1 "Configurar repositorios extra para Debian Buster" \
2 "Configurar repositorios extra para Devuan Beowulf" \
3 "Configurar repositorios extra para Ubuntu 20.04 LTS" \
4 "No configurar repositorios adicionales" \
5 "Ayuda" \
6 "Salir" )

echo $opRepositorios

if [[ $opRepositorios == 1 ]]; then # Instalar Quirinux Edición General
clear 
_sourcesDebian
_menuPrincipal
fi

if [[ $opRepositorios == 2 ]]; then # Instalar Quirinux Edición Pro
clear 
_sourcesDevuan
_menuPrincipal
fi

if [[ $opRepositorios == 3 ]]; then # Instalar componentes sueltos
clear
_sourcesUbuntu
fi

if [[ $opRepositorios == 3 ]]; then # Instalar componentes sueltos
clear
_menuPrincipal
fi

if [[ $opRepositorios == 5 ]]; then # AyudaRepositorios
clear
_ayudaRepositorios
fi

if [[ $opRepositorios == 6 ]]; then # Salir
clear
_salir
fi
}

# ===========================================================================================
# AYUDA DEL MENÚ REPOSITORIOS [CASTELLANO]
# ===========================================================================================

function _ayudaRepositorios()
{

dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
--title "AYUDA" \
--msgbox "\nQuirinux se crea sobre una instalación fresca de Debian Buster XFCE e incluye programas instalados desde repositorios específicos (Linux Mint, Cinelerra y otros). Si utilizas Debian XFCE o alguna derivada directa como Mint puedes instalar estos repositorios con tranquilidad. Ofrecemos la opción para instalar también repositorios de Devuan y Ubuntu pero no podemos garantizar que vayan a funcionar al 100%. La opción más segura es la de no instalar repositorios, pero puede que algunas aplicaciones no se instalen (de todas formas, lo escencial funcionará)." 23 100
_menuRepositorios
}

# ===========================================================================================
# MENÚ PRINCIPAL [CASTELLANO]
# ===========================================================================================

function _menuPrincipal()

{

opPrincipal=$(dialog --title "MENÚ PRINCIPAL" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
--stdout \
--menu "Elije una opción" 16 50 7 \
1 "Instalar Quirinux Edición General" \
2 "Instalar Quirinux Edición Pro" \
3 "Instalar componentes sueltos" \
4 "Instalar programas sueltos" \
5 "Instalar núcleos" \
6 "Ayuda" \
7 "Salir" )

echo $opPrincipal

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

if [[ $opPrincipal == 5 ]]; then # Instalar núcleos
clear
_menuNucleos
_menuPrincipal
fi

if [[ $opPrincipal == 6 ]]; then # Ayuda
clear
_ayudaPrincipal
fi

if [[ $opPrincipal == 7 ]]; then # Salir
clear
_salir
fi
}

function _instalarDialog()
{
sudo apt-get install dialog -y
}

# ===========================================================================================
# AYUDA DEL MENÚ PRINCIPAL [CASTELLANO]
# ===========================================================================================

function _ayudaPrincipal()
{
	
dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
--title "AYUDA" \
--msgbox "*Programa para crear Quirinux sobre Debian Buster XFCE*\n\nINSTALAR QUIRINUX EDICIÓN GENERAL:\nOficina, internet, compresión de archivos, pdf y editores básicos de gráficos, redes, virtualización, audio y video.\n\nINSTALAR QUIRINUX EDICIÓN PRO:\nHerramientas de la edición General + Software profesional para la edición de gráficos, animación 2D, 3D y Stop-Motion, audio y video.\n\nINSTALAR COMPONENTES SUELTOS:\nPermite instalar las cosas por separado y de manera optativa (controladores, programas, codecs, etc).\n\nACERCA DEL KERNEL:\n Este programa no instalará los núcleos AVL de baja latencia y Linux-Libre con los que viene Quirinux, sólo instalará controladores sobre el kernel que estés utilizando en este momento." 23 100
_menuPrincipal
}

# ===========================================================================================
# MENÚ INSTALAR NUCLEOS [CASTELLANO]
# ===========================================================================================

function _menuNucleos()

{
	
cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 28 76 4)
options=(1 "Instalar kernel AVL de baja latencia" off
2 "Instalar kernel GNU Linux-Libre" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
case $choice in

1) # "Instalar kernel AVL de baja latencia"
clear
_instalarAVL
_menuPrincipal
;;

2) # "Instalar kernel GNU Linux-Libre"
clear 
_instalarGNULinuxLibre
_menuPrincipal
;;

esac
done
_clear
_menuPrincipal

}

function _instalarDialog()
{
sudo apt-get install dialog -y
}


# ===========================================================================================
# MENU INSTALAR COMPONENTES SUELTOS [CASTELLANO]
# ===========================================================================================

function _instalarSueltos()
{
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
20 "Corrección de bugs (recomendado)" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
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

12) # "Codecs privativos multimedia y RAR"
clear
_codecs
;;

13) # "Controladores libres para aceleradoras gráficas nVidia"
clear
_libresNvidia
;;

14) # "Controladores libres para aceleradoras gráficas AMD"
clear 
_libresAMD
;;

15) # "Controladores libres para digitalizadoras Wacom"
clear
_libresWacom
;;

16) # "Controladores libres para tabletas digitalizadoras Genius"
clear
_libresGenius
;;

17) # "Controladores para cámaras virtuales"
clear
_camarasVirtuales
;;

18) # "Utilidades de backup y puntos de restauración"
clear
_mint
;;

19) # "Corrección de bugs (recomendado)"
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

_instalarProgramasSueltos()
{
cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 28 76 16)
options=(

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
13 "Imagine (reducir peso de fotografías)" off
14 "Inkscape (editor de gráficos vectoriales)" off
15 "Kitchscenarist (editor para guionistas)" off
16 "Mugshot (gestionar usuarios)" off
17 "Mystiq (conversor de formatos)" off
18 "Natron (composición y FX)" off
19 "Olive (editor de video sencillo)" off
20 "Openboard (convertir pantalla en pizarra)" off
21 "Opentoonz (animación 2D industrial)" off
22 "qStopMotion (animación stop-motion)" off
23 "Quinema (herramientas para animación)" off
24 "Storyboarder (editor de storyboards)" off
25 "Tahoma (animación 2D y Stop-Motion)" off
26 "Tupitube (animación 2D y stop-motion)" off
27 "Wicd (gestión de red)" off) 

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
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

13) # "Imagine (reducir peso de fotografías)"
clear
_imagine
;;

14) # "Inkscape (editor de gráficos vectoriales)"
clear
_inkscape
;;

15) # "Kitchscenarist (editor para guionistas)"
clear
_kitscenarist
;;

16) # "Mugshot (gestionar usuarios)"
clear
_mugshot
;;

17) # "Mystiq (conversor de formatos)"
clear
_mystiq
;;

18) # "Natron (composición y FX)"
clear
_natron
;;

19) # "Olive (editor de video sencillo)"
clear
_olive
;;

20) # "Openboard (convertir pantalla en pizarra)"
clear
_openboard
;;

21) # "Opentoonz (animación 2D industrial)"
clear
_opentoonz
;;

22) # "qStopMotion (animación stop-motion)"
clear
_qstopmotion
;;

23) # "Quinema (herramientas para animación)"
clear
_quinema
;;

24) # "Storyboarder (editor de storyboards)" 
_storyboarder
;;

25) # "Tahoma (animación 2D y Stop-Motion)"
clear
_tahoma2D
;;

26) # "Tupitube (animación 2D y stop-motion)"
clear
_tupitube
;;

27) # "Wicd (gestión de red)"
clear
_wicd
;;

esac
done

_menuPrincipal

}

# ===========================================================================================
# FUNCIONES SIN SALIDA EN PANTALLA [NO NECESITAN TRADUCCIÓN]
# ===========================================================================================

function _instalarGeneral()
{
clear
_centroDeSoftware
_firmwareWifi
_codecs
_controladoresLibres
_programasGeneral
_pulseaudio
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

function _programasGeneral()
{
clear
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
_eggs

}

function _instalarPro()
{
clear
_instalarGeneral		
_baseBusterPro
_tipografiasPro
_especializadosPro
_limpiar
}

function _especializadosPro()
{
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
_borratemp

}

function _utiles()
{
clear
_mugshot
_mystiq
_densify
_imagine
_openboard
_cpuCoreUtils
_borratemp
}

function _instalarGNULinuxLibre()
{
mkdir -p /opt/tmp/libre
wget --no-check-certificate 'http://my.opendesktop.org/s/qnew98T6ZGyrgK4/download' -O /opt/tmp/libre/linuxlibre.tar
sudo tar -xvf /opt/tmp/libre/linuxlibre.tar -C /opt/tmp/libre/
sudo apt install /opt/tmp/libre/./*.deb -y
sudo rm -rf /opt/tmp/*
sudo apt-get remove --purge cryptsetup-initramfs -y
sudo apt-get autoremove --purge -y
sudo rm -rf /opt/tmp/*
sudo apt-get remove --purge cryptsetup-initramfs -y
sudo apt-get autoremove --purge -y
sudo rm -rf /opt/tmp/*

}

function _instalarAVL()
{

mkdir -p /opt/tmp/avl
wget --no-check-certificate 'http://my.opendesktop.org/s/tybe5FaBMjzts4R/download' -O /opt/tmp/avl/linux-image-5.4.28avl2-lowlatency.deb
# wget --no-check-certificate 'http://my.opendesktop.org/s/Mtty82em5dKM5na/download' -O /opt/tmp/avl/linux-image-5.9.1avl1-lowlatency_5.9.1avl1-lowlatency-1_amd64.deb

echo "# Dowload Headers"; sleep 1s
wget  --no-check-certificate 'http://my.opendesktop.org/s/Cx43SWj4w7LrTiY/download' -O /opt/tmp/avl/linux-headers-5.4.28avl2-lowlatency.deb
# wget  --no-check-certificate 'http://my.opendesktop.org/s/YZ7rnzLZDbTiTN9/download' -O /opt/tmp/avl/linux-headers-5.9.1avl1-lowlatency_5.9.1avl1-lowlatency-1_amd64.deb

sudo chmod 777 -R /opt/tmp/avl
sudo chown $USER /opt/tmp/*

sudo apt install /opt/tmp/avl/./linux-image-5.4.28avl2-lowlatency.deb -y
sudo apt install /opt/tmp/avl/./linux-headers-5.4.28avl2-lowlatency.deb -y
# sudo dpkg -i /opt/tmp/linux-headers-5.9.1avl1-lowlatency_5.9.1avl1-lowlatency-1_amd64.deb
# sudo dpkg -i /opt/tmp/linux-image-5.9.1avl1-lowlatency_5.9.1avl1-lowlatency-1_amd64.deb
sudo apt-get remove --purge cryptsetup-initramfs -y
sudo apt-get autoremove --purge -y
sudo rm -rf /opt/tmp/*

}

function _config()
{
	
# CONFIGURACIÓN PREDETERMINADA DE SUDOERS DE QUIRINUX

clear
sudo mkdir -p /opt/tmp/sudoers
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/QiGdK8pC4SjKL8p/download' -O /opt/tmp/sudoers/sudoersquirinux_1.0.0_all.deb
sudo apt install /opt/tmp/sudoers/./sudoersquirinux_1.0.0_all.deb -y
sudo chown root:root -R /etc/sudoers.d
sudo chmod 755 -R /etc/sudoers.d/

# ESTABLECE SOPORTE MULTIARQUITECTURA PARA 32 BITS

clear
sudo dpkg --add-architecture i386

}

function _sourcesDebian()
{

# AGREGA REPOSITORIOS ADICIONALES PARA DEBIAN Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/tyCN3iK2mAdJAEm/download' -O /opt/tmp/apt/sourcesquirinuxdebian_1.0.0_all.deb
sudo apt install /opt/tmp/apt/./sourcesquirinuxdebian_1.0.0_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEBIAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/

}

function _sourcesDevuan()
{

# AGREGA REPOSITORIOS ADICIONALES PARA DEVUAN Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/jSzsYgAkFa9eYPs/download' -O /opt/tmp/apt/sourcesquirinuxdevuan_1.0.0_all.deb
sudo apt install /opt/tmp/apt/./sourcesquirinuxdevuan_1.0.0_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt

# ACTIVA REPOSITORIOS NON-FREE CONTRIB, BACKPORTS DE DEVUAN

clear
sudo cp -r -a /opt/repo-config/non-free-back/* /etc/apt/sources.list.d/

}

function _eggs()
{
clear
sudo mkdir -p /opt/tmp/eggs
sudo wget --no-check-certificate "http://my.opendesktop.org/s/8JSsp6PNGpjtb6t/download" -O /opt/tmp/eggs/eggs_7.8.46-1_amd64.deb
sudo apt install /opt/tmp/eggs/./eggs_7.8.46-1_amd64.deb
	
}

function _sourcesUbuntu()
{

# AGREGA REPOSITORIOS ADICIONALES PARA UBUNTU Y EL COMANDO "QUIRINUX-LIBRE"

clear
sudo mkdir -p /opt/tmp/apt
sudo wget  --no-check-certificate "http://cloud.opendesktop.org/s/cyqxpCTJ6yoFiAJ/download" -O /opt/tmp/apt/sourcesquirinuxubuntu_1.0.0_all.deb
sudo apt install /opt/tmp/apt/./sourcesquirinuxubuntu_1.0.0_all.deb
sudo apt-get update -y
chown -R root:root /etc/apt
}

function _firmwareWifi()
{

# INSTALAR FIRMWARE (CONTROLADORES PRIVATIVOS)

clear
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

clear
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

clear
for paquetes_nvidia in bumblebee; do sudo apt-get install -y $paquetes_nvidia; done 
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _libresWacom()
{

# INSTALAR CONTROLADORES DE TABLETAS GRÁFICAS WACOM

clear
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

clear
sudo mkdir -p /opt/tmp/quirinux-genius
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/LD8wnWefdNpDsSo/download' -O /opt/tmp/quirinux-genius/quirinux-genius-1.0-q2_amd64.deb
sudo apt install /opt/tmp/./quirinux-genius/quirinux-genius-1.0-q2_amd64.deb -y
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/X6S6zKycQEy9ygd/download' -O /opt/tmp/quirinux-genius/wizardpen_0.7.0_i386.deb
sudo apt install /opt/tmp/./quirinux-genius/wizardpen_0.7.0_i386.deb -y

}

function _libresImpresoras()
{

# INSTALAR PAQUETES DE IMPRESIÓN Y ESCANEO LIBRES

clear
for paquetes_scaner_impresion in build-essential tix foomatic-filters groff dc cups cups-pdf ink autoconf git wget avahi-utils system-config-printer-udev colord  flex g++ libtool python-dev sane sane-utils system-config-printer system-config-printer-udev unpaper xsltproc zlibc foomatic-db-compressed-ppds ghostscript-x ghostscript-cups gocr-tk gutenprint-locales openprinting-ppds printer-driver-brlaser printer-driver-all printer-driver-cups-pdf cups-client cups-bsd cups-filters cups-pdf cups-ppdc printer-driver-c2050 printer-driver-c2esp printer-driver-cjet printer-driver-dymo printer-driver-escpr  printer-driver-fujixerox printer-driver-gutenprint printer-driver-m2300w printer-driver-min12xxw printer-driver-pnm2ppa printer-driver-ptouch printer-driver-pxljr printer-driver-sag-gdi printer-driver-splix; do sudo apt-get install -y $paquetes_scaner_impresion; done
sudo apt-get install cups
sudo apt-get install -f -y
sudo apt-get remove --purge hplip cups-filters cups hplip-data system-config-printer-udev -y
sudo apt-get remove --purge hplip -y
sudo rm -rf /usr/share/hplip
sudo rm -rf /var/lib/hp
sudo apt-get install printer-driver-foo2zjs printer-driver-foo2zjs-common -y
sudo apt-get install tix groff dc cups cups-filters -y
sudo wget --no-check-certificate 'https://www.quirinux.org/printers/getweb' -O /usr/sbin/getweb
sudo getweb 1018
sudo getweb 2430   
# sudo getweb 2300  
# sudo getweb 2200    
# sudo getweb cpwl    
# sudo getweb 1020  
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

clear
for paquetes_red in mobile-broadband-provider-info pppconfig hardinfo modemmanager modem-manager-gui modem-manager-gui-help usb-modeswitch usb-modeswitch-data wvdial; do sudo apt-get install -y $paquetes_red; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _libresAMD()
{

# INSTALAR CONTROLADORES DE VIDEO AMD LIBRES

clear
for paquetes_amd in mesa-opencl-icd mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers libdrm-amdgpu1 xserver-xorg-video-amdgpu; do sudo apt-get install -y $paquetes_amd; done
sudo apt-get install -f
sudo apt-get autoremove --purge -y

}

function _baseBusterGeneral()
{

# INSTALAR PAQUETES BASE DE BUSTER

clear
for paquetes_buster in firefox firefox-l10n-de firefox-l10n-es firefox-l10n-fr firefox-l10n-gl firefox-l10n-ru firefox-l10n-it firefox-l10n-pt converseen bluetooth h264enc bluez gvfs-backends bluez-cups bluez-obexd libbluetooth-dev libbluetooth3 blueman connman bluez-firmware conky conky-all libimobiledevice-utils kcharselect kpat thunderbird thunderbid-l10n-de thunderbid-l10n-es-es thunderbid-l10n-fr thunderbid-l10n-gl thunderbid-l10n-it thunderbid-l10n-pt-br thunderbid-l10n-pt-ptthunderbid-l10n-ru thunderbid-l10n-es-ar xdemineur default-jre cairo-dock cairo-dock-plug-ins chromium dia tumbler tumbler-plugins-extra ffmpegthumbnailer xpat ktorrent photopc usermode go-mtpfs pdfarranger build-essential gtk3-engines-xfce make automake cmake engrampa python-glade2 shotwell xinput-calibrator libsox-fmt-mp3 gvfs-fuse breeze-icon-theme-rcc libsmbclient python-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs smbclient python-smbc breeze lightdm liblensfun-bin galculator gufw pacpl kde-config-tablet imagemagick x264 vlc-plugin-vlsub gnome-system-tools ffmpeg audacity onboard kolourpaint mtp-tools   xinput gparted font-manager hdparm prelink unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full p7zip-rar gzip lzip screenkey kazam gdebi bumblebee brasero breeze-icon-theme zip abr2gbr gtkam-gimp gphoto2 gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings vlc gdebi simple-scan ifuse kdeconnect menulibre catfish bleachbit prelink packagekit packagekit-tools; do sudo apt-get install -y $paquetes_buster; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _ptxconf()
{

# INSTALAR UTILIDAD PTXCONF (MAPPING)

clear
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

clear
sudo mkdir -p /opt/tmp/chimiboga
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Hmy6qMkGcR8TZdE/download' -O /opt/tmp/chimiboga/chimiboga.deb
sudo apt install /opt/tmp/chimiboga/./chimiboga.deb -y

}

function _samba()
{

# INSTALAR SAMBA Y CONFIGURADOR PARA SAMBA DE UBUNTU

clear
sudo apt-get install samba -y
sudo mkdir -p /opt/tmp/samba
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/DH3fbW6oMXPQfqF/download' -O /opt/tmp/samba/system-config-samba_1.2.63-0ubuntu6_all.deb
sudo apt install /opt/tmp/samba/./system-config-samba_1.2.63-0ubuntu6_all.deb -y
sudo touch /etc/libuser.conf
sudo chown root /etc/sudoers.d/samba

}

function _mugshot()
{
	
# INSTALAR MUGSHOT

clear
sudo mkdir -p /opt/tmp/mugshot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/gQydJFz5qcYBXYf/download' -O /opt/tmp/mugshot/mugshot_0.4.2-1_all.deb
sudo apt install /opt/tmp/mugshot/./mugshot_0.4.2-1_all.deb -y
}

function _mystiq
{
	
# INSTALAR CONVERSOR MYSTIQ DESDE OPENSUSE

clear
for paquetes_mystiq in mystiq; do sudo apt-get install -y $paquetes_mystiq; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _densify()
{
	
# INSTALAR DENSIFY (para reducir archivos PDF)

clear
sudo mkdir -p /opt/tmp/densify
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/bp8pYAKSXKQ7dFZ/download' -O /opt/tmp/densify/densify-0.3.1-q2_amd64.deb
sudo apt install /opt/tmp/densify/./densify-0.3.1-q2_amd64.deb -y
}

function _imagine()
{
	
# INSTALAR IMAGINE (para reducir imágenes)

clear
sudo mkdir -p /opt/tmp/imagine
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/xeTmnR4JGgzJnTE/download' -O /opt/tmp/imagine/imagine-0.5.1-q2_amd64.deb
sudo apt install /opt/tmp/imagine/./imagine-0.5.1-q2_amd64.deb -y
}

function _openboard()
{
	
# INSTALAR OPENBOARD (Convierte la pantalla en una pizarra)

clear
sudo mkdir -p /opt/tmp/openboard
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/t7rC79ZSXwpipRW/download' -O /opt/tmp/openboard/openboard_1.0.3_amd64.deb
sudo apt install /opt/tmp/openboard/./openboard_1.0.3_amd64.deb -y
}

function _cpuCoreUtils()
{
	
# INSTALAR PROGRAMA PARA CONFIGURAR EL RENDIMIENTO DEL PROCESADOR

clear
for paquetes_cpu in cpufrequtils; do sudo apt-get install -y $paquetes_cpu; done 
sudo apt-get install -f
sudo mkdir -p /opt/tmp/cpu
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/KkH8atxtWTPLXdy/download' -O /opt/tmp/cpu/cpufreq_42-1_all.deb
sudo apt install /opt/tmp/cpu/./*.deb -y
}

function _olive()
{

# INSTALAR EDITOR DE VIDEO OLIVE

clear
sudo mkdir -p /opt/tmp/olive
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/Tg9AZJf6R8ffFqD/download' -O /opt/tmp/olive/olive-quirinux.deb
sudo apt install /opt/tmp/olive/./olive-quirinux.deb -y
}

function _GIMP()
{

# INSTALAR GIMP EDICION QUIRINUX

clear
sudo mkdir -p /opt/tmp/gimp/
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GHyPZZz9MgX7sdJ/download' -O /opt/tmp/gimp/gimpquirinux_2.1.0_all.deb
sudo apt install /opt/tmp/gimp/./gimpquirinux_2.1.0_all.deb -y

}

function _aqemu()
{

# INSTALAR PAQUETES DE VIRTUALIZACIÓN

clear
for paquetes_virtualizacion in aqemu qemu-kvm qemu-system-data qemu-block-extra intel-microcode amd-microcode qemu-system libvirt; do sudo apt-get install -y $paquetes_virtualizacion; done
sudo apt-get install -f -y

}

function _wicd()
{

# INSTALAR WICD

clear
for paquetes_wicd in wicd; do sudo apt-get install -y $paquetes_wicd; done
for paquetes_nm in network-manager; do sudo apt-get autoremove --purge -y $paquetes_nm; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _mint()
{

# INSTALAR MINTBACKUP, MINTUPDATE y TIMESHIFT

clear
for paquetes_extra in mintbackup mintupdate timeshift; do sudo apt-get install -y $paquetes_extra; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

}

function _centroDeSoftware()

{
	
# INSTALAR GESTOR DE PAQUETES DE MINT SIN FLATPAK

clear
sudo apt-get upgrade -y
sudo apt-get dist-ugprade -y
sudo apt-get install mintinstall -y
sudo apt-get autoremove --purge flatpak -y

# INSTALAR FLATPAK-CONFIG

clear
sudo mkdir -p /opt/tmp/flatpak-config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/wwBY7B6rayeGQEw/download' -O /opt/tmp/flatpak-config/quirinux-flatpak-1.0-q2_amd64.deb
sudo apt install /opt/tmp/flatpak-config/./quirinux-flatpak-1.0-q2_amd64.deb -y

}

function _salvapantallas()
{

# INSTALAR SCREENSAVER GLUCLO

clear
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
clear
sudo mkdir -p /opt/tmp
sudo mkdir -p /opt/tmp/fuentes
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/oS7PZ4HqWTkNff7/download' -O /opt/tmp/fuentes/quirinux-fuentes.tar
sudo chmod 777 -R /opt/tmp/fuentes/
sudo chown $USER -R /opt/tmp/fuentes/
sudo tar -xvf /opt/tmp/fuentes/quirinux-fuentes.tar -C /opt/tmp/fuentes
sudo cp -r -a /opt/tmp/fuentes/quirinux-fuentes/* /

# Descargando y copiando fuentes de Quirinux
clear
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

clear
sudo chmod 777 -R /home/
sudo chmod 777 -R /usr/share/backgrounds/
sudo chmod 777 -R /usr/share/desktop-base/
sudo chmod 777 -R /usr/share/images/
sudo chmod 777 -R /usr/share/fonts/
sudo chmod u+s /usr/sbin/hddtemp

# _borrarTemasActuales

# INSTALAR TEMAS DE QUIRINUX
clear
sudo mkdir -p /opt/tmp/temas
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/o7rg7CpARw5CPLA/download' -O /opt/tmp/temas/quirinux-temas.tar
sudo tar -xvf /opt/tmp/temas/quirinux-temas.tar -C /

# INSTALAR ÍCONOS DE QUIRINUX
clear
sudo mkdir -p /opt/tmp/winbugs
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/NAwrJXnZYow9PHS/download' -O /opt/tmp/winbugs/iconswinbugs_1.0.0_all.deb
sudo apt install /opt/tmp/winbugs/./iconswinbugs_1.0.0_all.deb -y

# MODIFICANDO DENOMINACIÓN DE DEBIAN EN EL GRUB (PARA QUE DIGA 'QUIRINUX')
# También instala menú principal de Quirinux y modifica algunos archivos más.
clear
sudo mkdir -p /opt/tmp/config
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/7WPCQjRSCjSMjSz/download' -O /opt/tmp/config/quirinux-config.tar
sudo tar -xvf /opt/tmp/config/quirinux-config.tar -C /opt/tmp/config/
sudo cp -r /opt/tmp/config/quirinux-config/* /
sudo update-grub
sudo update-grub2

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

function _red()
{

# ELIMINANDO ERRORES DE INICIO (RED
clear
sudo rm -rf /etc/network/interfaces.d/setup
sudo chmod 777 /etc/network/interfaces
sudo echo "auto lo" >> /etc/network/interfaces
sudo echo "iface lo inet loopback" /etc/network/interfaces
sudo chmod 644 /etc/network/interfaces

}

function _pulseaudio()
{

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

function _remover()
{

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
for paquetes_remover_idiomas_ibus in inicatalan ipolish idanish idutch ibulgarian icatalan ihungarian ilithuanian inorwegian iswiss iukrainian  ihungarian ilithuanian inorwegian ipolish iukrainian iswiss; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_ibus; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DICCIONARIOS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_idiomas_mythes in  myspell-et; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_mythes; done
for paquetes_remover_idiomas_aspell in aspell-hi aspell-ml aspell-mr aspell-pa aspell-ta aspell-te aspell-gu aspell-bn  aspell-no aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-da aspell-el aspell-eo aspell-et aspell-eu aspell-he aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lt aspell-lv aspell-nl aspell-no aspell-pl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-pl aspell-eo aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-cy aspell-el aspell-et aspell-eu aspell-fa aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lv aspell-nl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-uk; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_aspell; done
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
for paquetes_remover_idiomas_libreoffice in libreoffice-help-ca libreoffice-help-cs libreoffice-help-da libreoffice-help-dz libreoffice-help-el  libreoffice-help-et libreoffice-help-eu libreoffice-help-fi libreoffice-help-gl libreoffice-help-hi libreoffice-help-hu libreoffice-help-ja libreoffice-help-km libreoffice-help-ko libreoffice-help-nl libreoffice-help-pl libreoffice-help-sk libreoffice-help-sl libreoffice-help-sv libreoffice-help-zh-cn libreoffice-help-zh-tw fonts-linuxlibertine fonts-droid-fallback fonts-noto-mono libreoffice-l10n-ar libreoffice-l10n-ast libreoffice-l10n-be libreoffice-l10n-bg libreoffice-l10n-bn libreoffice-l10n-bs libreoffice-l10n-ca libreoffice-l10n-cs libreoffice-l10n-da libreoffice-l10n-dz libreoffice-l10n-el libreoffice-l10n-en-za libreoffice-l10n-eo libreoffice-l10n-et libreoffice-l10n-eu libreoffice-l10n-fa libreoffice-l10n-fi libreoffice-l10n-ga libreoffice-l10n-gu libreoffice-l10n-he libreoffice-l10n-hi libreoffice-l10n-hr libreoffice-l10n-hu libreoffice-l10n-id libreoffice-l10n-islibreoffice-l10n-ja libreoffice-l10n-kalibreoffice-l10n-km libreoffice-l10n-ko libreoffice-l10n-lt libreoffice-l10n-lv libreoffice-l10n-mk libreoffice-l10n-ml libreoffice-l10n-mr libreoffice-l10n-nb libreoffice-l10n-ne libreoffice-l10n-nl libreoffice-l10n-nnlibreoffice-l10n-pa-in libreoffice-l10n-pl libreoffice-l10n-ro libreoffice-l10n-si libreoffice-l10n-sk libreoffice-l10n-sl libreoffice-l10n-srlibreoffice-l10n-sv libreoffice-l10n-ta libreoffice-l10n-te libreoffice-l10n-th libreoffice-l10n-tr libreoffice-l10n-ug libreoffice-l10n-uk libreoffice-l10n-vi libreoffice-l10n-xh libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw; do sudo apt-get remove --purge -y $paquetes_remover_idiomas_libreoffice; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER PROGRAMAS QUE QUIRINUX NO INCLUYE
clear
for paquetes_remover_programas in xsane xarchiver grsync jami blender dia gsmartcontrol ophcrack ophcrack-cli whowatch htop zulucrypt-cli zulucrypt-cli balena-etcher-electron keepassxc stacer dino-im dino-im-common etherape eterape-data hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux qassel qassel-data jami jami-daemon liferea liferea-data mumble wahay onionshare qtox signal hydra hydra-gtk bmon grub-customizer spek osmo eom eom-common compton mc mc-data pidgin pidgin-data bluetooth khmerconverter thunderbird fcitx* mozc* webcamoid modem-manager-gui fcitx mlterm-common bluez bluez-firmware culmus synapse apparmor pidgin-otr pidgin-encryption pidgin pidgin-data pidgin-themes pidgin-openpgp libpurple0 dino-im dino-im-common gajim gajim-omemo hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux quassel quassel-data mumble qtox keepassxc mc mc-data osmo exfalso kasumi mlterm parole modem-manager-gui modem-manager-gui-help; do sudo apt-get remove --purge -y $paquetes_remover_programas; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y

# REMOVER DOCUMENTACIÓN
clear
sudo rm -rf /usr/share/doc/*

}

function _limpiar()
{
	
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

function _baseBusterPro()
{

# INSTALAR PAQUETES ESPECIALIZADOS DESDE BUSTER (KRITA, OBS, SYNFIG, XSANE, ETC)
clear
for paquetes_estandar in manuskript sweethome3d kdenlive guvcview xsane digikam k3d gnome-color-manager aegisub dispcalgui birdfont skanlite pencil2d devede vokoscreen-ng soundconverter hugin calf-plugins invada-studio-plugins-ladspa vlc-plugin-fluidsynth fluidsynth synfig synfigstudio synfig-examples pikopixel.app entangle darktable rawtherapee krita krita-data krita-gmic krita-l10n dvd-styler obs-studio obs-plugins gir1.2-entangle-0.1; do sudo apt-get install -y $paquetes_estandar; done
sudo apt-get install -f -y
clear
_pluginEntangle

}

function _tipografiasPro()
{

# INSTALAR TIPOGRAFÍAS PARA DIBUJANTES
clear
sudo mkdir -p /opt/tmp/komika
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/eQrxHfx5QeeQtAL/download' -O /opt/tmp/komika/quirinu-komika.deb
sudo apt install /opt/tmp/godot/./godot-2.3.3-q2_amd64.deb -y
sudo apt-get autoremove --purge -y

}

function _opentoonz()
{

clear

# Descarga y compila el código fuente de OpenToonz

sudo apt-get update -y
for paquetes_opentoonz in wget build-essential git cmake pkg-config libboost-all-dev qt5-default qtbase5-dev libqt5svg5-dev qtscript5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins libqt5serialport5-dev libsuperlu-dev liblz4-dev libusb-1.0-0-dev liblzo2-dev libpng-dev libjpeg-dev libglew-dev freeglut3-dev libfreetype6-dev libjson-c-dev qtwayland5 libmypaint-dev libopencv-dev libturbojpeg-dev; do sudo apt-get install -y $paquetes_opentoonz; done

mkdir -p /opt/tmp/opentoonz
sudo wget  --no-check-certificate 'https://github.com/opentoonz/opentoonz/archive/refs/tags/v1.5.0.tar.gz' -O /opt/tmp/opentoonz/opentoonz-1.5.0.tar.gz
tar -xzvf /opt/tmp/opentoonz/opentoonz-1.5.0.tar.gz -C /opt/tmp/
cd /opt/tmp/opentoonz-1.5.0

mkdir -p $HOME/.config/OpenToonz
cp -r /opt/tmp/opentoonz-1.5.0/stuff $HOME/.config/OpenToonz/

cd /opt/tmp/opentoonz-1.5.0/thirdparty/tiff-4.0.3
./configure --with-pic --disable-jbig
make -j$(nproc)
cd ../../

cd toonz
mkdir build
cd build
cmake ../sources
make -j$(nproc)
make install

# Descarga y copia el ícono del menú de inicio de OpenToonz

mkdir -p /opt/tmp/opentoonz
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/oTxLzXBFCZR8Abi/download' -O /opt/tmp/opentoonz/opentoonzicon_1.5.0_amd64.deb
apt install /opt/tmp/opentoonz/./opentoonzicon_1.5.0_amd64.deb

clear

}

function _tahoma2D()
{
	
# INSTALAR TAHOMA 2D

clear
mkdir -p /opt/tmp/tahoma2d
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/MWt7cqqGgQCdYby/download' -O /opt/tmp/tahoma2d/tahoma-1.1-q2_amd64.deb
sudo apt install /opt/tmp/tahoma2d/./*.deb -y
}

function _inkscape()
{
	
# INSTALANDO INKSCAPE

clear
for paquetes_remover_inkscape in inkscape; do sudo apt-get remove --purge -y $paquetes_remover_inkscape; done
sudo mkdir -p /opt/tmp/inkscape
sudo wget --no-check-certificate 'http://my.opendesktop.org/s/7BWLio7HC4Rga3J/download' -O /opt/tmp/inkscape/inkscape-1.0-q2_amd64.deb
sudo apt install /opt/tmp/inkscape/./inkscape-1.0-q2_amd64.deb -y
}

function _tupitube()
{
	
# INSTALAR TUPITUBE

clear
sudo mkdir -p /opt/tmp/tupitube
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/4C37F2wJ4ebAdLH/download' -O /opt/tmp/tupitube/tupitubedesk_0.2.17_amd64.deb
sudo apt install /opt/tmp/tupitube/./tupitubedesk_0.2.17_amd64.deb -y
}

function _godot()
{
	
# INSTALAR GODOT

clear
sudo mkdir -p /opt/tmp/godot
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/w3R2NzrwwSMxPXC/download' -O /opt/tmp/godot/godot-2.3.3-q2_amd64.deb
sudo apt install /opt/tmp/godot/./godot-2.3.3-q2_amd64.deb -y
}

function _storyboarder()
{
	
# INSTALAR STORYBOARDER

clear
sudo mkdir -p /opt/tmp/storyboarder
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GePzTyxoYpM622t/download' -O /opt/tmp/storyboarder/storyboarder-2.0.0-q2_amd64.deb
sudo apt install /opt/tmp/storyboarder/./storyboarder-2.0.0-q2_amd64.deb -y
}

function _kitscenarist()
{

# INSTALAR KITSCENARIST

clear
sudo mkdir -p /opt/tmp/kitscenarist
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/26WpWbDH5g5nC6k/download' -O /opt/tmp/kitscenarist/kitscenarist64.deb
sudo apt install /opt/tmp/kitscenarist/./kitscenarist64.deb -y
}

function _natron()
{
	
# INSTALAR NATRON

clear
sudo mkdir -p /opt/tmp/natron
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/zBY3tinXbQpqDbB/download' -O /opt/tmp/natron/natron-2.3.15-q2_amd64.deb
sudo apt install /opt/tmp/natron/./natron-2.3.15-q2_amd64.deb -y
}

function _azpainter()
{
	
# INSTALAR AZPAINTER

clear
sudo mkdir -p /opt/tmp/azpainter
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/AojjBiP7NmoSBsA/download' -O /opt/tmp/azpainter/azpainter-2.1.4-q2_amd64.deb
sudo apt install /opt/tmp/azpainter/./azpainter-2.1.4-q2_amd64.deb -y
}

function _enve()
{
	
# INSTALAR ENVE

clear
sudo mkdir -p /opt/tmp/enve
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/GAyMB7pt5K9MXnx/download' -O /opt/tmp/enve/enve-0.0.1_amd64.deb
sudo apt install /opt/tmp/enve/./enve-0.0.1_amd64.deb -y
}

function _quinema()
{
	
# INSTALAR QUINEMA

clear
sudo mkdir -p /opt/tmp/quinema
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/zREfipBzSxYXFTK/download' -O /opt/tmp/quinema/quinema_1.0-q2_amd64.deb
sudo apt install /opt/tmp/quinema/./quinema_1.0-q2_amd64.deb -y
}

function _qstopmotion()
{
	
# INSTALAR QSTOPMOTION

clear
sudo mkdir -p /opt/tmp/qstopmotion
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/MznJgLCFeWeQMGd/download' -O /opt/tmp/qstopmotion/qstopmotion-2.5.0-q2_amd64.deb
sudo apt install /opt/tmp/qstopmotion/./qstopmotion-2.5.0-q2_amd64.deb -y
}

function _camarasVirtuales()
{
	
# INSTALAR CONTROLADORES PARA CÁMARAS VIRTUALES
# Complemento útil para qStopMotion

clear
sudo mkdir -p /opt/tmp/akvcam
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/2BL5CgEa3YgMx2g/download' -O /opt/tmp/akvcam/akvcam-1.0-q2_amd64.deb
sudo chmod 777 -R /opt/tmp/akvcam/
sudo apt install /opt/tmp/akvcam/./akvcam-1.0-q2_amd64.deb -y
}

function _belle()
{
	
# INSTALAR BELLE

clear
sudo mkdir -p /opt/tmp/belle
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/pQw6Yyytaz8TQ46/download' -O /opt/tmp/belle/belle-0.7-q2_amd64.deb
sudo apt install /opt/tmp/belle/./belle-0.7-q2_amd64.deb -y
}

function _mypaint()
{
	
# INSTALAR MYPAINT

clear
sudo mkdir -p /opt/tmp/mypaint
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/TZL8554kj8HLjsK/download' -O /opt/tmp/mypaint/mypaint-2-q2_amd64.deb
sudo apt install /opt/tmp/mypaint/./mypaint-2-q2_amd64.deb -y
}

function _cinelerra()
{
	
# INSTALAR EDITOR DE VIDEO PROFESIONAL CINELERRA

clear
mkdir -p /opt/tmp/cinelerra
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/FK6xp4k38b9H3BT/download' -O /opt/tmp/cinelerra/cinelerra.deb
sudo apt install /opt/tmp/cinelerra/./cinelerra.deb -y
sudo rm -rf /opt/tmp/*
}

function _blender()
{
	
# ACTUALIZANDO BLENDER

clear
for paquetes_remover_blender in remove --purge blender-data; do sudo apt-get remove --purge -y $paquetes_remover_blender; done
sudo mkdir -p /opt/tmp/blender283
sudo apt-get install -f -y
sudo apt-get autoremove --purge -
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/PfagSW43yP9yGiX/download' -O /opt/tmp/blender283/blender-2.83-q2_amd64.deb
sudo apt install /opt/tmp/blender283/./blender-2.83-q2_amd64.deb -y
}

function _ardour()
{
	
# INSTALAR ARDOUR 6

clear
sudo mkdir -p /opt/tmp/ardour6
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/YBKRojEoNbM8Nq5/download' -O /opt/tmp/ardour6/ardour6-6.3-q2_amd64.deb
sudo apt install /opt/tmp/ardour6/./ardour6-6.3-q2_amd64.deb -y

# INSTALAR PLUGINS PARA ARDOUR

clear
for paquetes_calf in calf-plugins; do sudo apt-get install -y $paquetes_calf; done
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

function _pluginEntangle()
{
	
# DESCARGAR PLUGIN STOPMO-PREVIEW PARA ENTANGLE
# Luego será necesario ejecutar el comando instalar-plugin-entangle sin permisos de root.

clear
sudo mkdir -p /opt/tmp/
sudo wget  --no-check-certificate 'http://my.opendesktop.org/s/kRmqM6HAit8Px2F/download' -O /opt/tmp/entangle-plugin-stopmotion.deb
for paquetes_python in python-gobject; do sudo apt-get install -y $paquetes_python; done
sudo apt-get install python3-gi 
sudo apt install /opt/tmp/./entangle-plugin-stopmotion.deb
sudo apt-get install -f -y
sudo apt-get autoremove --purge -y
}

_inicioCheck
_menuPrincipal
