#!/bin/bash

# Nombre:	instalar-quirinux.sh
# Autor:	Charlie Martínez® <cmartinez@quirinux.org>
# Licencia:	https://www.gnu.org/licenses/gpl-2.0.txt
# Descripción:	Convierte una instalación limpia de Debian Bookworm XFCE 64 Bits en Quirinux.
# Versión:	2.0
# ===========================================================================================
# ¿ESTE CÓDIGO TE RESULTA INMANEJABLE?
# ===========================================================================================
# ¡Te sugiero utilizar el IDE Geany! A la izquierda del mismo tendrás un menú con todas las
# funciones de este script y podrás ir al lugar que necesites con mucha facilidad.
# Otra opción cómoda es VSCodium (Panel "Outline", a la izquierda).

function _inicioCheck() {
	
	
# Verifica si el usuario tiene permisos de administrador

if [ "$EUID" -ne 0 ]; then
    echo ''
    echo "Este script debe ejecutarse con permisos de root."
    echo 'Puedes intentarlo con "sudo" tuusuario, "sudo su" o "su root".'
    echo ''
    exit 1
fi

    # ===========================================================================================
    # VERIFICAR REQUISITOS [CÓDIGO REUTILIZABLE]
    # ===========================================================================================

    FILE="/opt/requisitos/ok"

    if [ ! -e ${FILE} ]; then
        clear
        _menuCondicional
        _menuRepositorios

    else
        clear
        FILE="/opt/requisitos/ok-repo"

        if [ ! -e ${FILE} ]; then
            _menuRepositorios

        else
            _menuPrincipal

        fi
    fi

}

function _requisitos() {

    # ===========================================================================================
    # INSTALAR REQUISITOS [CÓDIGO REUTILIZABLE]
    # ===========================================================================================

    # Instalar DIALOG, WGET y GIT
    clear
    apt update -y
    apt upgrade -y

    for paquetes in dialog wget git spice-vdagent; do sudo apt install -y $paquetes; done

    # Crear fichero de verificación
    sudo mkdir -p /opt/requisitos/
    sudo touch /opt/requisitos/ok

}

function _menuCondicional() {

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
 
 (p) 2019-2024 Licencia GPLv2, Autor: Charlie Martínez® 
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
    "1") # Continuar
        clear
        _requisitos
        ;;
    "0") #Salir
        clear
        exit 0
        ;;
    esac

}

function _menuRepositorios() {

    # ===========================================================================================
    # MENU REPOSITORIOS [CASTELLANO]
    # ===========================================================================================

    opRepositorios=$(dialog --title "REPOSITORIOS ADICIONALES" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
        --stdout \
        --menu "NECESARIOS PARA EL RESTO DE LA INSTALACIÓN" 16 62 8 \
        1 "Agregar repositorios de Quirinux" \
        2 "Ayuda" \
        3 "Salir")
    echo $opRepositorios

    if [[ $opRepositorios == 1 ]]; then # Instalar repositorios Quirinux
        clear
        _repoconfig
        _okrepo
        _menuPrincipal
    fi

    if [[ $opRepositorios == 2 ]]; then # AyudaRepositorios
        clear
        _ayudaRepositorios
    fi

    if [[ $opRepositorios == 3 ]]; then # Salir
        clear
        _salir
    fi

}

function _repoconfig() {

    # ===========================================================================================
    # REPOSITORIOS DE QUIRINUX
    # ===========================================================================================

    # AGREGA REPOSITORIOS ADICIONALES PARA DEBIAN
    clear
    mkdir -p /opt/tmp/apt
    wget --no-check-certificate 'https://repo.quirinux.org/pool/main/q/quirinux-repo/quirinux-repo_1.0.1_all.deb' -O /opt/tmp/apt/quirinux-repo_1.0.1_all.deb
    apt install /opt/tmp/apt/./quirinux-repo_1.0.1_all.deb -y
    apt update -y
    chown -R root:root /etc/apt
    apt install quirinux-sudoers -y
    rm /opt/tmp/apt/quirinux-repo_1.0.1_all.deb

}

function _okrepo() {

    FILE="/etc/apt/sources.list.d/quirinux.list"

    if [ -e ${FILE} ]; then
        touch /opt/requisitos/ok-repo
    fi

}

function _checkrepo() {

    FILE1="/opt/requisitos/ok-repo"

    if [ ! -e ${FILE1} ]; then
        _warningRepo
    fi

}

function _warningRepo() {

    # ===========================================================================================
    # VERIFICA REQUISITO REPOSITORIO
    # ===========================================================================================
    dialog --backtitle "REQUISITO INCUMPLIDO" \
        --title "SE NECESITAN REPOSITORIOS" \
        --msgbox "\nSe requiere instalar repositorios adicionales de Quirinux." 23 100
    _menuRepositorios

}

function _menuPrincipal() {

    # ===========================================================================================
    # MENÚ PRINCIPAL [CASTELLANO]
    # ===========================================================================================

    opPrincipal=$(dialog --title "MENÚ PRINCIPAL" --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" --nocancel \
        --stdout \
        --menu "Elije una opción" 16 50 8 \
        1 "Instalar Quirinux Base" \
        2 "Instalar Quirinux Animación" \
        3 "Instalar componentes base sueltos" \
        4 "Instalar programas de animación sueltos" \
        5 "Ayuda" \
        6 "Salir")
    echo $opPrincipal

    _checkrepo

    if [[ $opPrincipal == 1 ]]; then # Instalar programas base de todo Quirinux
        clear
        _instalarBase
        _menuPrincipal
    fi

    if [[ $opPrincipal == 2 ]]; then # Instalar Quirinux Animación
        clear
        _instalarAnimacion
        _menuPrincipal
    fi

    if [[ $opPrincipal == 3 ]]; then # Instalar componentes base sueltos
        clear
        _menuBase
    fi

    if [[ $opPrincipal == 4 ]]; then # Instalar programas de animación sueltos
        clear
        _menuAnimacion
    fi

    if [[ $opPrincipal == 5 ]]; then # Ayuda_sistema
        clear
        _ayudaPrincipal
    fi

    if [[ $opPrincipal == 6 ]]; then # Salir
        clear
        _salir
    fi

}

function _instalarBase() {

    FILE="/opt/requisitos/ok-base"
    if [ -e ${FILE} ]; then

        _finalBase
    else

        _paquetesBase
        _finalBase
    fi

}

function _finalBase() {

    dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
        --title "ATENCION!" \
        --msgbox "\n Todos los paquetes correspondientes de Debian Base para Quirinux han sido instalados." 23 100

}

function _instalarAnimacion() {

    # INSTALAR QUIRINUX ANIMACIÓN SOBRE QUIRINUX BASE

    FILE1="/opt/requisitos/ok-animacion"
    FILE2="/opt/requisitos/ok-base"

    if [ -e ${FILE1} ]; then
        clear
        _finalAnimacion

    elif [ -e ${FILE2} ]; then
        clear
        _paquetesAnimacion
        _finalAnimacion
    elif [ -e ${FILE1} && -e ${FILE2}]; then
        clear
        _finalBase
        _finalAnimacion
    else
        clear
        _instalarBase

    fi

}

function _paquetesBase() {
	
    clear
    
    _centroDeSoftware  
    _sistema  
    _devede  
    _torrent  
    _accesorios  
    _teclado  
	_audacity   
    _virtualbox  
    _peek  
    _vlc  
    _kdenlive  
    _juegos  
    _appsQuirinux  
    _telegram  
    _jitsi  
    _qrcreator  
    _openboard  
    _obs  
    _eggs  
    _pdf  
    _imagine  
    _gimp  
    _pipewire  
    _imagenes    
    _impresoras 
    _controladoresTabletas    
    _controladoresAMD    
    _controladoresIntel        
    _librerias    
    _screenkeys    
    _tipografias  
    _codecs  
    _warpinator  
    _isync   
    _owncloud
    
    _limpiar
    touch /opt/requisitos/ok-base

}

function _paquetesAnimacion() {
	
    clear
    
    _audio
    _perfiles
    _subtitulos
    _editorFuentes
    _escanerLinea
    _pencil
    _hugin
    _synfig
    _darktable
    _rawtherapee
    _krita
    _entangle
    _manuskript
    _sweethome3d
    _huayra
    _tahoma2D
    _inkscape
    _tupitube
    _godot
    _storyboarder
    _natron
    _azpainter
    _enve
    _quinema
    _qstopmotion
    _belle
    _mypaint
    _blender
    _boats
	_gb-studio
	_pikopixel
	_cura
	
    _limpiar
    touch /opt/requisitos/ok-animacion

}

function _finalAnimacion() {

    dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
        --title "ATENCIÓN!" \
        --msgbox "\n Todos los paquetes correspondientes a la edicion QUIRINUX 2.0 han sido instalados.\n\nPara activar el plugin entangle stop motion, ejecute el sigiente comando SIN PERMISOS DE ROOT:\n\ninstalar-plugin-entangle" 23 100

}

function _menuBase() {

    # ===========================================================================================
    # MENU INSTALAR COMPONENTES SUELTOS [CASTELLANO]
    # ===========================================================================================

    cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 23 76 16)
    options=(1 "Accesorios: Calculadora, Color Picker, KPaint y Otros" off
        2 "Aplicación de Mensajería: Telegram" off
        3 "Aplicación de Videoconferencia: Jitsi" off
        4 "Audacity: aplicación básica para edición de sonido" off
        5 "Asistente, Utilidades, Temas y Wallpapers de Quirinux" off
        6 "Centro de Software Estilo Android" off
        7 "Codecs para Comprimir y Descomprimir en RAR" off
        8 "Creador de Códigos QR" off
        9 "Creador de ISO Penguin's Eggs, de Piero Proietti" off
        10 "Controlador Privativo AMD" off
        11 "Controlador Privativo Intel" off
        12 "Controladores Impresoras y Escáneres" off
        13 "Controladores para Tabletas de Dibujo" off
        14 "Editor Profesional de Video: Kdenlive" off
        15 "Grabación CD, DVD y Conversión Multimedia" off
        16 "GIMP: Editor de Gráficos" off
        17 "Isync: sincronizar nubes" off
        18 "Owncloud: sincronizar nube Ownclod" off
        19 "Juegos: Chimiboga, Buscaminas, Knetwalk" off
        20 "Librerías Más Habituales" off
        21 "Openboard: Pizarra en Pantalla" off
        22 "Paquete de Librerías Más Habituales" off
        23 "Peek: grabar pequeños GIF animados de la pantalla" off
        24 "Reproductor Multimedia VLC + Complementos" off
        25 "Screenkey: Muestra en Pantalla lo que se Escribe" off
        26 "Servidor de Sonido Pipewire" off
        27 "Teclado en Pantalla para Dispositivos Táctiles" off
        28 "Tipografías Adicionales (Incluye las de Windows)" off
        29 "qbittorrent: Cliente para Torrent" off
        30 "Utilidades de Sistema (Limpieza, Seguridad y Backup)" off
        31 "Utilidades para Ficheros PDF" off
        32 "Virtualbox: Virtualizar otros Sistemas Operativos" off
        33 "Visualizadores y Organizadores de Imágenes" off
        34 "Warpinator: conectar dispositivos" off       
    )

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear

    for componente in $choices; do
        case $componente in
        1) _accesorios ;;
        2) _telegram ;;
        3) _jitsi ;;
        4) _audacity ;;
        5) _appsQuirinux ;;
        6) _centroDeSoftware ;;
        7) _codecs ;;
        8) _qrcreator ;;
        9) _eggs ;;
        10) _impresoras ;;
        11) _controladorIntel ;;
        12) _impresoras ;;
        13) _controladoresTabletas ;;
        14) _kdenlive ;;
        15) _devede ;;
        16) _gimp ;;
        17) _isync ;;
        18) _owncloud ;;
        19) _juegos ;;
        20) _librerias ;;
        21) _openboard ;;
        22) _librerias ;;
        23) _peek ;;
        24) _vlc ;;
        25) _screenkey ;;
        26) _pipewire ;;
        27) _teclado ;;
        28) _tipografias ;;
        29) _torrent ;;
        30) _sistema ;;
        31) _pdf ;;
        32) _virtualbox ;;
        33) _imagenes ;;
        34) _warpinator ;;
        esac
    done

    _menuPrincipal
}

function _menuAnimacion() {

    # ===========================================================================================
    # MENU INSTALAR PROGRAMAS DE ANIMACION SUELTOS [CASTELLANO]
    # ===========================================================================================

    cmd=(dialog --separate-output --checklist "Barra espaciadora = seleccionar" 23 76 16)
    options=(1 "Administrador de Perfiles de Color" off
        2 "Aegisub: Editor de Subtítulos" off
        3 "Apps para Edición de Audio (Ardour, Audacity y plugins)"
        4 "AZPainter: Dibujo y Entintado, Ideal Comics" off
        5 "Belle (Editor de Aventuras Gráficas Animadas)" off
        6 "Birdfont: Editor de Tipografías" off
        7 "Blender: Animación Profesional 3D, 2D y 2.5D" off
        8 "Boats: Stopmotion Simple para Webcam en 16:9" off
        9 "Ultimaker cura: impresión 3D" off 
        10 "Darktable: Revelado RAW Similar a Lightroom, Ideal para Paisajes" off
        11 "Enve: Motion Graphics Sencillo, Interfaz Similar a After Effects" off
        12 "Entangle: Control para Cámaras DSLR y Plugin Papel Cebolla" off
        13 "GB Studio: Editor visual de juegos retro" off
        14 "Godot: Animación Cut-out Ideal Videojuegos" off
        15 "Hugin: Unir Dibujos para Fondos Widescreen" off
        16 "Huayra Stopmotion: App Sencilla de Stop-motion Webcam en 4:3" off
        17 "Inkscape: Dibujo Vectorial" off
        18 "Krita: Dibujo, Pintura y Animación 2D, Modos RGB y CMYK" off
        19 "Manuskript: Software para Escritores y Guionistas" off
        20 "MyPaint: Pintura Digital Similar a ArtRage" off
        21 "Natron: Composición y Efectos por Nodos, Similar a Nuke" off
        22 "Pencil 2D: Animación 2D Estilo Flash 8" off
        23 "PikoPixel.app: editor de pixel art" off
        24 "Quinema: Scripts para Procesar Imágenes, de Ernesto Bazzano" off
        25 "QStopMotion: Animación Stopmotion con Webcam o DSLR" off
        26 "Rawtherapee: Revelado RAW, Ideal para Tonos de Piel" off
        27 "Skanlite: Software para Escanear en Modo Lineart" off
        28 "Storyboarder: Creación de Storyboard y Animatics" off
        29 "Sweethome3D: Diseño de Interiores" off
        30 "Synfig: Animación 2D Cut-out" off
        31 "Tahoma2D: Animación 2D y Stop-Motion Webcam/DSLR, Basado en Open Toonz" off
        32 "TupiTube: Animación 2D y Stopmotion Webcam Ideal para Edad Escolar" off
        
    )

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear

    for componente in $choices; do
        case $componente in
        1) _perfiles ;;
        2) _subtitulos ;;
        3) _audio ;;
        4) _azpainter ;;
        5) _belle ;;
        6) _editorFuentes ;;
        7) _blender ;;
        8) _boats ;;
        9) _cura ;;
        10) _darktable ;;
        11) _enve ;;
        12) _entangle ;;
        13) _gb-studio ;;
        14) _godot ;;
        15) _hugin ;;
        16) _huayra ;;
        17) _inkscape ;;
        18) _krita ;;
        19) _manuskript ;;
        20) _mypaint ;;
        21) _natron ;;
        22) _pencil ;;
        23) _pikopixel ;;
        24) _quinema ;;
        25) _qstopmotion ;;
        26) _rawtherapee ;;
        27) _escanerLinea ;;
        28) _storyboarder ;;
        29) _sweethome3d ;;
        30) _synfig ;;
        31) _tahoma2D ;;
        32) _tupitube ;;
        
        esac
    done

    _menuPrincipal
}

# ===========================================================================================
# PAQUETES DE QUIRINUX BASE
# ===========================================================================================

function _centroDeSoftware() {

    # Centro de Software
    for paquetes in mintinstall flatpak flatpakconfig; do sudo apt install -y $paquetes; done

}
function _sistema() {
    # Utilidades de sistema (limpieza, seguridad y backup)
    for paquetes in color-picker stacer bleachbit gparted flatpakconfig gufw baobab catfish quirinux-bluconfig timeshift; do sudo apt install -y $paquetes; done

}

function _devede() {

    # Grabación de CD, DVD, captura de pantalla y conversores de video
    for paquetes in devede xfburn converseen handbrake mediainfo kazam; do sudo apt install -y $paquetes; done

}

function _torrent() {

    # qbittorrent: cliente para Torrent
    for paquetes in qbittorrent; do sudo apt install -y $paquetes; done

}

function _accesorios() {

    # Accesorios: calculadora, color picker, kpaint y otros
    for paquetes in galculator color-picker kpaint dia kcharselect kruler; do sudo apt install -y $paquetes; done

}

function _teclado() {

    # Teclado en pantalla para dispositivos táctiles
    for paquetes in onboard; do sudo apt install -y $paquetes; done

}

function _audacity() {
	
	for paquetes in audacity; do sudo apt install $paquetes; done
	
}

function _virtualbox() {

    # Virtualbox + Paquete de extensiones
    for paquetes in virtualbox-7.0 linux-headers-$(uname -r); do sudo apt install -y $paquetes; done
    sudo mkdir -p /opt/tmp/virtualbox
    sudo wget --no-check-certificate 'https://download.virtualbox.org/virtualbox/7.0.10/Oracle_VM_VirtualBox_Extension_Pack-7.0.10.vbox-extpack' -O /opt/tmp/virtualbox/Oracle_VM_VirtualBox_Extension_Pack-7.0.10.vbox-extpack
    cd /opt/tmp/virtualbox/
    sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.10.vbox-extpack
    sudo rm /opt/tmp/virtualbox/Oracle_VM_VirtualBox_Extension_Pack-7.0.10.vbox-extpack
    for paquetes in quirinux-virtualbox; do sudo apt install -y $paquetes; done
    sudo rcvboxadd setup

}

function _peek() {

    # Peek: grabar GIF animados pequeños de la pantalla
    for paquetes in peek; do sudo apt install -y $paquetes; done

}

function _vlc() {

    # Reproductor multimedia VLC + Complementos
    for paquetes in vlc vlc-plugin-svg vlc-plugin-fluidsynth vlc-plugin-pipewire vlc-plugin-jack; do sudo apt install -y $paquetes; done

}

function _kdenlive() {

    # Editor profesional de video Kdenlive
    for paquetes in kdenlive breeze breeze-icon-theme-rcc; do sudo apt install -y $paquetes; done

}

function _juegos() {

    # Juegos: chimiboga, buscaminas solitario y knetwalk 
		# Marzo 2024 chimiboga se retiró porque hace días que esta offline.
    for paquetes in kpat xdemineur knetwalk; do sudo apt install -y $paquetes; done

}

function _appsQuirinux() {

    # Asistente, utilidades, temas y wallpapers de Quirinux
    for paquetes in quirinux-fuentes os-prober mugshot xscreensaver quirinux-actualizar quirinux-applications quirinux-asistente quirinux-autologin quirinux-bluconfig quirinux-config quirinux-estilos quirinux-firefox-base quirinux-notify quirinux-pipewire quirinux-splash quirinux-sudoers quirinux-temas quirinux-usuarios quirinux-wallpapers xqlogout crealib-libersys draw.io gluqlo icons-libreoffice icons-winbugs reiniciar-red webapp-manager xfce4-panel-profiles xfce4-theme-switcher grub2; do sudo apt install -y $paquetes; done
    sudo update-grub
    sudo update-grub2
    _idiomas

}

function _idiomas() {

    idiomas=("es_ES.UTF-8" "en_US.UTF-8" "fr_FR.UTF-8" "de_DE.UTF-8" "it_IT.UTF-8" "gl_ES.UTF-8" "pt_PT.UTF-8")

    # Configura cada idioma
    for idioma in "${idiomas[@]}"; do
        # Verifica si la configuración ya existe
        if ! locale -a | grep -q "$idioma"; then
            sudo locale-gen $idioma
            echo "Configuración de $idioma completa."
        fi
        if [ "$idioma" == "pt_PT.UTF-8" ]; then
            break # Sale del bucle cuando llega a pt_PT.UTF-8
        fi
    done

    # Establece el idioma predeterminado
    sudo update-locale LANG="es_ES.UTF-8"

}

function _telegram() {

    # Aplicación de mensajería Telegram
    for paquetes in telegram; do sudo apt install -y $paquetes; done

}

function _jitsi() {

    # Aplicación de videoconferencia Jitsi
    for paquetes in jitsi-meet-electron; do sudo apt install -y $paquetes; done

}

function _openboard() {

    # Openboard: pizarra en pantalla
    for paquetes in openboard; do sudo apt install -y $paquetes; done

}

function _qrcreator() {

    # Creador de códigos QR
    for paquetes in qrcreator; do sudo apt install -y $paquetes; done

}

function _obs() {

    # Applicación para streaming OBS Studio
    for paquetes in akvcam obs-studio obs-plugins obs-v4l2sink; do sudo apt install -y $paquetes; done

}

function _eggs() {

    # Creador de ISO Penguin's Eggs, de Piero Proietti
    for paquetes in eggs; do sudo apt install -y $paquetes; done

}

function _pdf() {

    # Utilidades para ficheros PDF
    for paquetes in atril autofirma compresorpdf pdfexport pdfarranger; do sudo apt install -y $paquetes; done

}

function _imagine() {

    # Optimizador de imagenes Imagine
    for paquetes in imagine; do sudo apt install -y $paquetes; done

}

function _gimp() {

    # GIMP Quirinux con selector para íconos y atajos de Photoshop
    for paquetes in gimp-quirinux gimp-paint-studio xcftools; do sudo apt install -y $paquetes; done

}

function _pipewire() {

    # Servidor de sonido Pipewire
    for paquetes in libwireplumber-0.4-0 wireplumber gstreamer1.0-pipewire libpipewire-0.3-0 libpipewire-0.3-modules pipewire pipewire-alsa pipewire-audio pipewire-bin pipewire-pulse; do sudo apt install -y $paquetes; done

}

function _imagenes() {

    # Visualizadores y organizadores de imágenes
    for paquetes in shotwell digikam; do sudo apt install -y $paquetes; done
    
}

function _impresoras() {

    # Controladores para impresoras y escáneres

    for paquetes in hplip cups-filters cups hplip-data system-config-printer-udev; do sudo apt remove --purge -y $paquetes; done

    FILE1="/usr/share/hplip"
	FILE2="/var/lib/hp"
	
    if [ -e ${FILE1} ]; then
    sudo rm -rf $FILE
    fi
    
    if [ -e ${FILE2} ]; then
    sudo rm -rf $FILE2
	fi
    
    for paquetes in impresoras epsonscan simple-scan xsane akvcam; do sudo apt install -y $paquetes; done
    sudo chmod 775 /usr/local/bin/epson-install
    sudo epson-install
    
}

function _controladoresTabletas() {

    # Controladores para tabletas de dibujo

    for paquetes in kde-config-tablet geniusconfig wizardpen huion-tablet xppen ptxconf; do sudo apt install -y $paquetes; done

}

function _controladorAMD() {

    # Controlador privativo para el procesador AMD
    for paquetes in amd64-microcode; do sudo apt install -y $paquetes; done

}

function _controladorIntel() {

    # Controlador privativo para el procesador Intel
    for paquetes in intel-microcode; do sudo apt install -y $paquetes; done

}

function _librerias() {

    # Paquete de librerías más habituales
    for paquetes in gnome-firmware mencoder mtp-tools font-manager breeze-icon-theme gambas3-gb-db gambas3-gb-db-form gambas3-gb-form gambas3-gb-form-stock gambas3-gb-gui-qt gambas3-gb-image gambas3-gb-qt5 gambas3-gb-settings packagekit; do sudo apt install -y $paquetes; done
    
    for paquetes in mmolch-thumbnailers xapp-appimage-thumbnailer xapp-epub-thumbnailer xapp-mp3-thumbnailer xapp-raw-thumbnailer xapp-thumbnailers-common xapp-vorbiscomment-thumbnailer; do sudo apt install -y $paquetes; done
    
    for paquetes in ntp hunspell-es hunspell-en-us hunspell-gl hunspell-it hunspell-pt-pt hunspell-pt-br hunspell-de-de-frami xserver-xorg-input-mutouch xserver-xorg-input-multitouch btrfs-progs dosfstools dmraid exfat-fuse f2fs-tools fatresize fatsort hfsutils hfsplus lvm2 nilfs-tools nfs-common ntfs-3g jfsutils reiserfsprogs reiser4progs dosfstools dmraid exfat-fuse f2fs-tools fatresize fatsort hfsutils hfsplus lvm2 nilfs-tools nfs-common ntfs-3g jfsutils reiserfsprogs reiser4progs sshfs xfsdump xfsprogs udfclient udftools package-update-indicator gnome-packagekit python3-distro-info python3-pycurl unattended-upgrades libreoffice-l10n-de libreoffice-l10n-es libreoffice-l10n-gl libreoffice-l10n-it libreoffice-l10n-pt libreoffice-l10n-fr firefox-esr-l10n-es-es firefox-esr-l10n-fr firefox-esr-l10n-pt-pt firefox-esr-l10n-it firefox-esr-l10n-de firefox-esr-l10n-fr frei0r-plugins graphicsmagick mediainfo-gui firefox-esr firefox-esr-l10n-de firefox-esr-l10n-es-es firefox-esr-l10n-fr firefox-esr-l10n-gl firefox-esr-l10n-ru firefox-esr-l10n-it gvfs-backends connman conky conky-all libimobiledevice-utils default-jre tumbler tumbler-plugins-extra ffmpegthumbnailer usermode build-essential make automake cmake xinput-calibrator libsox-fmt-mp3 gvfs-fuse libsmbclient python3-gphoto2cffi libgphoto2-dev dcraw python3-gphoto2cffi python3-gphoto2 gphotofs python3-smbc liblensfun-bin pacpl imagemagick x264 gnome-system-tools unrar-free zip unzip unace bzip2 lzop p7zip p7zip-full gzip lzip zip abr2gbr gtkam-gimp gphoto2 qapt-deb-installer ifuse; do sudo apt install -y $paquetes; done

}

function _screenkey() {

    # Screenkey: muestra en pantalla lo que se escribe
    for paquetes in screenkey; do sudo apt install -y $paquetes; done

}

function _tipografias() {
	
    # Tipografías adicionales (incluye las de Windows)
    for paquetes in quirinux-fuentes; do sudo apt install -y $paquetes; done
    
}

function _codecs() {

    # Codecs para comprimir y descomprimir en RAR
    for packages in engrampa rar unrar; do sudo apt install -y $packages; done

}

function _warpinator() {
	
	# Warpinator: conectar dispositivos
	for paquetes in warpinator; do sudo apt install -y $paquetes; done
	
}

function _isync() {
	
	# Sincronizar nubes
	
	for paquetes in isync; do sudo apt install -y $paquetes; done
	
}

function _owncloud() {
	
	# Owncloud: sincronizar nube Owncloud
	
	for paquetes in owncloud-client; do sudo apt install -y $paquetes; done
	
}

# ===========================================================================================
# PAQUETES DE QUIRINUX ANIMACIÓN
# ===========================================================================================

function _audio() {

    # Aplicaciones para edición de audio (Ardour, Audacity y plugins)
    for paquetes in quirinux-audio-config quirinux-audio-pack; do sudo apt install -y $paquetes; done

}

function _cura() {
	
	for paquetes in cura; do sudo apt install -y $paquetes; done
	
}

function _pikopixel() {
	
	for paquetes in pikopixel.app; do sudo apt install -y $paquetes; done
	
}

function _gb-studio() {
	
	for paquetes in gb-studio; do sudo apt install -y $paquetes; done
	
}

function _perfiles() {

    # Administrador de perfiles de color
    for paquetes in gnome-color-manager dispcalgui; do sudo apt install -y $paquetes; done

}

function _subtitulos() {

    # Aegisub: editor de subtítulos
    for paquetes in aegisub; do sudo apt install -y $paquetes; done

}

function _editorFuentes() {

    # Birdfont: editor de tipografías
    for paquetes in birdfont; do sudo apt install -y $paquetes; done

}

function _escanerLinea() {

    # Skanlite: software para escanear en modo lineart
    for paquetes in skanlite; do sudo apt install -y $paquetes; done

}

function _pencil() {

    # Pencil 2D: Animación 2D estilo Flash 8
    for paquetes in pencil2d; do sudo apt install -y $paquetes; done

}

function _hugin() {

    # Hugin: unir dibujos para fondos widescreen
    for paquetes in hugin; do sudo apt install -y $paquetes; done

}

function _synfig() {

    # Synfig: animación 2D cut-out
    for paquetes in synfig synfigstudio synfig-examples; do sudo apt install -y $paquetes; done
}

function _darktable() {

    # Darktable: revelado RAW similar a Lightroom, ideal para paisajes
    for paquetes in darktable; do sudo apt install -y $paquetes; done

}

function _rawtherapee() {

    # Rawtherapee: revelado RAW, ideal para tonos de piel
    for paquetes in rawtherapee; do sudo apt install -y $paquetes; done

}

function _krita() {

    # Krita: dibujo, pintura y animación 2D, modos RGB y CMYK
    for paquetes in krita krita-data krita-gmic krita-l10n; do sudo apt install -y $paquetes; done

}

function _manuskript() {

    # Manuskript: software para escritores y guionistas
    for paquetes in manuskript; do sudo apt install -y $paquetes; done

}

function _sweethome3d() {

    # Sweethome3D: Diseño de interiores
    for paquetes in sweethome3d; do sudo apt install -y $paquetes; done
    
}

function _huayra() {

    # Huayra Stopmotion: app sencilla de stop-motion webcam en 4:3
    for paquetes in huayra-stopmotion; do sudo apt install -y $paquetes; done

}

function _tahoma2D() {

    # Tahoma2D: Animación 2D y Stom-Motion webcam/DSLR, basado en Open Toonz
    for paquetes in tahoma2d; do sudo apt install -y $paquetes; done

}

function _inkscape() {

    # Inkscape: dibujo vectorial
    for paquetes in inkscape; do sudo apt install -y $paquetes; done

}

function _tupitube() {

    # TupiTube: animación 2D y stopmotion webcam ideal para edad escolar
    for paquetes in tupitubedesk; do sudo apt install -y $paquetes; done

}

function _godot() {

    # Godot: animación cut-out ideal videojuegos    
    for paquetes in godot; do sudo apt install -y $paquetes; done

}

function _storyboarder() {

    # Storyboarder: Creación de storyboard y animatics optimizado
    for paquetes in storyboarder; do sudo apt install -y $paquetes; done

}

function _natron() {

    # Natron: composición y efectos por nodos, similar a Nuke
    for paquetes in natron; do sudo apt install -y $paquetes; done

}

function _azpainter() {

    # AZPainter: Dibujo y entintado, ideal comics
    for paquetes in azpainter; do sudo apt install -y $paquetes; done

}

function _enve() {

    # Enve: motion graphics sencillo, interfaz similar a After Effects
    for paquetes in enve; do sudo apt install -y $paquetes; done

}

function _quinema() {

    # Quinema: Scripts para procesar imagenes, de Ernesto Bazzano
    for paquetes in quinema; do sudo apt install -y $paquetes; done

}

function _qstopmotion() {

    # QStopMotion: animación stopmotion con webcam o DSLR
    for paquetes in qstopmotion; do sudo apt install -y $paquetes; done

}

function _belle() {

    # Belle (editor de aventuras gráficas animadas)
    for paquetes in belle; do sudo apt install -y $paquetes; done

}

function _mypaint() {

    # MyPaint: pintura digital similar a ArtRage
    for paquetes in mypaint; do sudo apt install -y $paquetes; done

}

function _blender() {

    # Blender: animación profesional 3D, 2D Y 2.5D
    for paquetes in blender; do sudo apt install -y $paquetes; done

}

function _boats() {

    # Boats: stopmotion simple para webcam en 16:9
    for paquetes in boats-animator; do sudo apt install -y $paquetes; donde

}

function _entangle() {

    # Entangle: control para Cámaras DSLR y plugin para stop motion
    for paquetes in entangle gir1.2-entangle-0.1 entangleinstallplugin; do sudo apt install -y $paquetes; done
    _entanglePlugin

}

function _entanglePlugin() {

    dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
        --title "ATENCIÓN!" \
        --msgbox "\n Para activar el plugin entangle stop motion, ejecute el sigiente comando SIN PERMISOS DE ROOT:\n\ninstalar-plugin-entangle" 23 100

}

function _limpiar() {

    _remover
    _borratemp
    _ordenar

}

function _finalAnimacion() {

    touch /opt/requisitos/ok-animacion

    dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
        --title "ATENCIÓN!" \
        --msgbox "\n Todos los paquetes de ANIMACIÓN de Quirinux 2.0 han sido instalados." 23 100
    _entanglePlugin
}

function _ayudaPrincipal() {

    # ===========================================================================================
    # AYUDA DEL MENÚ PRINCIPAL [CASTELLANO]
    # ===========================================================================================

    dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
        --title "AYUDA" \
        --msgbox "*Programa para crear Quirinux sobre Debian Buster XFCE*\n\nINSTALAR QUIRINUX BASE:\nOficina, internet, compresión de archivos, pdf, GIMP Quirinux, redes, virtualización, audio y video.\n\nINSTALAR QUIRINUX ANIMACIÓN:\nHerramientas de la edición General + Software profesional para la edición de gráficos, animación 2D, 3D y Stop-Motion, audio y video.\n\nINSTALAR COMPONENTES SUELTOS:\nPermite seleccionar e instalar cosas por separado (controladores, programas, codecs, etc).\n\n" 23 90
    _menuPrincipal

}

function _ayudaRepositorios() {

    # ===========================================================================================
    # AYUDA DEL MENÚ REPOSITORIOS [CASTELLANO]
    # ===========================================================================================

    dialog --backtitle "INSTALACIÓN DE QUIRINUX GNU/LINUX V.2.0" \
        --title "AYUDA" \
        --msgbox "\nQuirinux puede crearse sobre una instalación fresca de DEBIAN XFCE e incluye programas instalados tanto desde el repositorio oficial de Debian como del propio repositorio de Quirinux. Además, agrega los respositorios de VirtualBox para quien quiera utilizarlos. Si utilizas DEBIAN / DEVUAN XFCE puedes instalar estos repositorios con tranquilidad. ADVERTENCIA: Este instalador modificará la configuración de sudoers." 23 100

    _menuRepositorios

}

function _salir() {

    # ===========================================================================================
    # FUNCION SALIR [CÓDIGO REUTILIZABLE]
    # ===========================================================================================
    clear
    exit 0

}

function _remover() {

    # ===========================================================================================
    # BORRAR COMPONENTES QUE QUIRINUX NO INCLUYE
    # ===========================================================================================

    # REMOVER TRADUCCIONES DE FIREFOX DE IDIOMAS QUE QUIRINUX NO INCLUYE

    clear
    for paquetes in keditbookmarks firefox-esr-l10n-ru firefox-esr-l10n-bn-bd firefox-esr-l10n-bn-in refox-esr-l10n-kn firefox-esr-l10n-kn firefox-esr-l10n-lt firefox-esr-l10n-ml firefox-esr-l10n-ml firefox-esr-l10n-ar firefox-esr-l10n-ast firefox-esr-l10n-be firefox-esr-l10n-bg firefox-esr-l10n-bn firefox-esr-l10n-bs firefox-esr-l10n-ca firefox-esr-l10n-cs firefox-esr-l10n-cy firefox-esr-l10n-da firefox-esr-l10n-el firefox-esr-l10n-eo firefox-esr-l10n-es-cl firefox-esr-l10n-es-mx firefox-esr-l10n-et firefox-esr-l10n-eu firefox-esr-l10n-fa firefox-esr-l10n-fi firefox-esr-l10n-ga-ie firefox-esr-l10n-gu-in firefox-esr-l10n-he firefox-esr-l10n-hi-in firefox-esr-l10n-hr firefox-esr-l10n-hu firefox-esr-l10n-id firefox-esr-l10n-is firefox-esr-l10n-ja firefox-esr-l10n-kk firefox-esr-l10n-km firefox-esr-l10n-ko firefox-esr-l10n-lv firefox-esr-l10n-mk firefox-esr-l10n-mr firefox-esr-l10n-nb-no firefox-esr-l10n-ne-np firefox-esr-l10n-nl firefox-esr-l10n-nn-no firefox-esr-l10n-pa-in firefox-esr-l10n-pl firefox-esr-l10n-ro firefox-esr-l10n-si firefox-esr-l10n-sk firefox-esr-l10n-sl firefox-esr-l10n-sq firefox-esr-l10n-sr firefox-esr-l10n-sv-se firefox-esr-l10n-ta firefox-esr-l10n-te firefox-esr-l10n-th firefox-esr-l10n-tr firefox-esr-l10n-uk firefox-esr-l10n-vi firefox-esr-l10n-zh-cn firefox-esr-l10n-zh-tw; do sudo apt remove --purge -y $paquetes; done

    # REMOVER TRADUCCIONES DE ESCRITORIO DE IDIOMAS QUE QUIRINUX NO INCLUYE

    for paquetes in task-albanian-desktop task-cyrillic-desktop task-russian-desktop task-amharic-desktop task-arabic-desktop task-asturian-desktop task-basque-desktop task-belarusian-desktop task-bengali-desktop task-bosnian-desktop task-bulgarian-desktop task-catalan-desktop task-croatian-desktop task-czech-desktop task-danish-desktop task-dutch-desktop task-dzongkha-desktop task-esperanto-desktop task-estonian-desktop task-finnish-desktop task-georgian-desktop task-greek-desktop task-gujarati-desktop task-hindi-desktop task-hungarian-desktop task-icelandic-desktop task-indonesian-desktop task-irish-desktop task-kannada-desktop task-kazakh-desktop task-khmer-desktop task-kurdish-desktop task-latvian-desktop task-lithuanian-desktop task-macedonian-desktop task-malayalam-desktop task-marathi-desktop task-nepali-desktop task-northern-sami-desktop task-norwegian-desktop task-persian-desktop task-polish-desktop task-punjabi-desktop task-romanian-desktop task-serbian-desktop task-sinhala-desktop task-slovak-desktop task-slovenian-desktop task-south-african-english-desktop task-tamil-desktop task-telugu-desktop task-thai-desktop task-turkish-desktop task-ukrainian-desktop task-uyghur-desktop task-vietnamese-desktop task-welsh-desktop task-xhosa-desktop task-chinese-s-desktop; do sudo apt remove --purge -y $paquetes; done
    
    # REMOVER CONJUNTOS DE CARACTERES DE IDIOMAS QUE QUIRINUX NO INCLUYE

    for paquetes in inicatalan ipolish irussian idanish idutch ibulgarian icatalan ihungarian ilithuanian inorwegian iswiss iukrainian ihungarian ilithuanian inorwegian ipolish iukrainian iswiss; do sudo apt remove --purge -y $paquetes; done

    for paquetes in myspell-ru mythes-ru myaspell-ru myspell-et; do sudo apt remove --purge -y $paquetes; done

    for paquetes in aspell-hi aspell-ml aspell-mr aspell-pa aspell-ta aspell-te aspell-gu aspell-bn aspell-no aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-da aspell-el aspell-eo aspell-et aspell-eu aspell-he aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lt aspell-lv aspell-nl aspell-no aspell-pl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-pl aspell-eo aspell-am aspell-ar aspell-ar-large aspell-bg aspell-ca aspell-cs aspell-cy aspell-el aspell-et aspell-eu aspell-fa aspell-ga aspell-he aspell-hr aspell-hu aspell-is aspell-kk aspell-ku aspell-lv aspell-nl aspell-ro aspell-sk aspell-sl aspell-sv aspell-tl aspell-uk aspell-uk; do sudo apt remove --purge -y $paquetes; done

    for paquetes in hunspell-ar hunspell-ml hunspell-be hunspell-bg hunspell-bs hunspell-ca hunspell-cs hunspell-da hunspell-eu hunspell-gu hunspell-hi hunspell-hr hunspell-hu hunspell-id hunspell-is hunspell-kk hunspell-kmr hunspell-ko hunspell-lt hunspell-lv hunspell-ne hunspell-nl hunspell-ro hunspell-se hunspell-si hunspell-sl hunspell-sr hunspell-sv hunspell-sv-se hunspell-te hunspell-th hunspell-de-at hunspell-de-ch hunspell-de-de hunspell-vi; do sudo apt remove --purge -y $paquetes; done
    
    for paquetes in myspell-eo myspell-fa myspell-ga myspell-he myspell-nb myspell-nn myspell-sk myspell-sq mythes-cs mythes-de-ch mythes-ne mythes-pl mythes-sk; do sudo apt remove --purge -y $paquetes; done

    for paquetes in hyphen-hr hypen-ru hyphen-hu hyphen-lt; do sudo apt remove --purge -y $paquetes; done

    # REMOVER FUENTES QUE QUIRINUX NO INCLUYE

    for paquetes in fonts-arabeyes fonts-nanum fonts-crosextra-carlito fonts-nanum-coding fonts-tlwg-kinnari-ttf fonts-tlwg-kinnari fonts-thai-tlwg fonts-tlwg* fonts-vlgothic fonts-arphic-ukai fonts-arphic-uming fonts-lohit-knda fonts-lohit-telu fonts-ukij-uyghur; do sudo apt remove --purge -y $paquetes; done
    
    # REMOVER IDIOMAS DE LIBRE OFFICE QUE QUIRINUX NO INCLUYE

    for paquetes in libreoffice-help-ru libreoffice-l10n-ru libreoffice-help-ca libreoffice-help-cs libreoffice-help-da libreoffice-help-dz libreoffice-help-el libreoffice-help-et libreoffice-help-eu libreoffice-help-fi libreoffice-help-gl libreoffice-help-hi libreoffice-help-hu libreoffice-help-ja libreoffice-help-km libreoffice-help-ko libreoffice-help-nl libreoffice-help-pl libreoffice-help-sk libreoffice-help-sl libreoffice-help-sv libreoffice-help-zh-cn libreoffice-help-zh-tw fonts-linuxlibertine fonts-droid-fallback fonts-noto-mono libreoffice-l10n-ar libreoffice-l10n-ast libreoffice-l10n-be libreoffice-l10n-bg libreoffice-l10n-bn libreoffice-l10n-bs libreoffice-l10n-ca libreoffice-l10n-cs libreoffice-l10n-da libreoffice-l10n-dz libreoffice-l10n-el libreoffice-l10n-en-za libreoffice-l10n-eo libreoffice-l10n-et libreoffice-l10n-eu libreoffice-l10n-fa libreoffice-l10n-fi libreoffice-l10n-ga libreoffice-l10n-gu libreoffice-l10n-he libreoffice-l10n-hi libreoffice-l10n-hr libreoffice-l10n-hu libreoffice-l10n-id libreoffice-l10n-islibreoffice-l10n-ja libreoffice-l10n-kalibreoffice-l10n-km libreoffice-l10n-ko libreoffice-l10n-lt libreoffice-l10n-lv libreoffice-l10n-mk libreoffice-l10n-ml libreoffice-l10n-mr libreoffice-l10n-nb libreoffice-l10n-ne libreoffice-l10n-nl libreoffice-l10n-nnlibreoffice-l10n-pa-in libreoffice-l10n-pl libreoffice-l10n-ro libreoffice-l10n-si libreoffice-l10n-sk libreoffice-l10n-sl libreoffice-l10n-srlibreoffice-l10n-sv libreoffice-l10n-ta libreoffice-l10n-te libreoffice-l10n-th libreoffice-l10n-tr libreoffice-l10n-ug libreoffice-l10n-uk libreoffice-l10n-vi libreoffice-l10n-xh libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw; do sudo apt remove --purge -y $paquetes; done
    
    # REMOVER PROGRAMAS QUE QUIRINUX NO INCLUYE

    for paquetes in grsync jami dia gsmartcontrol ophcrack ophcrack-cli whowatch htop zulucrypt-cli zulucrypt-cli balena-etcher-electron keepassxc dino-im dino-im-common etherape eterape-data hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux qassel qassel-data jami jami-daemon liferea liferea-data mumble wahay onionshare qtox signal hydra hydra-gtk bmon grub-customizer spek osmo eom eom-common compton mc mc-data pidgin pidgin-data bluetooth khmerconverter fcitx* mozc* webcamoid modem-manager-gui fcitx mlterm-common bluez bluez-firmware culmus synapse apparmor pidgin-otr pidgin-encryption pidgin pidgin-data pidgin-themes pidgin-openpgp libpurple0 dino-im dino-im-common gajim gajim-omemo hexchat hexchat-common hexchat-perl hexchat-plugins hexchat-python3 hexchat-otr iptux quassel quassel-data mumble qtox keepassxc mc mc-data osmo kasumi mlterm parole modem-manager-gui modem-manager-gui-help; do sudo apt remove --purge -y $paquetes; done

    # REMOVER DOCUMENTACIÓN
    clear
    sudo rm -rf /usr/share/doc/*

}

function _borratemp() {

    # ===========================================================================================
    # BORRAR TEMPORALES [CÓDIGO REUTILIZABLE]
    # ===========================================================================================
    sudo rm -rf /opt/tmp/*
    sudo apt-get clean
    
}

function _ordenar() {

    # ===========================================================================================
    # ORDENAR CACHE DE PAQUETES [CÓDIGO REUTILIZABLE]
    # ===========================================================================================

    # CONFIGURANDO PAQUETES
    sudo dpkg --configure -a

    # LIMPIANDO CACHE
    sudo apt clean && apt autoclean

    # REGENERANDO CACHE
    sudo apt update --fix-missing

    # CONFIGURANDO DEPENDENCIAS
    sudo apt install -f
    sudo apt autoremove --purge -y
    
}

_inicioCheck
