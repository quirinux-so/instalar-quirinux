# instalar-quirinux.sh
Autor: Charlie Martínez ®
## Acerca de este repositorio
Este programa sirve para instalar los controladores y aplicaciones de la distribución Quirinux GNU/Linux sobre una instalación fresca de Debian/Devuan GNU/Linux XFCE. Si ya cuentas con Debian XFCE o Devuan con escritorio XFCE instalado, puedes utilizar este script para convertirlo en Quirinux o bien agregar componentes aislados.<br>
### Detalles adicionales
Este instalador funciona por consola, con un menú en modo texto a color.
### Compatibilidad con distribuciones
Programado para Debian Buster, en las últimas revisiones incluye opción para seleccionar repositorios para Devuan Beowulf, Chimaera, Bullseye y Ubuntu 20.04. Probado en Beowulf y Chimaera. Este script descarga e instala repositorios personalizados, guardando carpetas de backup con todas las configuraciones de la carpeta /etc/apt, por lo que los cambios son revertibles.
### Instrucciones
sudo chmod 755 instalar-quirinux.sh <br>
su root<br>
./instalar-quirinux.sh<br>
Es preferible ejecutar este script iniciando sesión como root, en lugar utilizar de sudo ./instalar-quirinux.sh
#### Autores
Charlie Martínez, haciendo uso de la libertad de distribución de la licencia GPL, ha programado este instalador pero no guarda relación con el desarrollo de gran parte del software que instala, el cual ha sido liberado casi en su totalidad bajo licencia GPL. Este script está liberado también bajo licencia GPLv2. Este script proporciona formas de instalar, de manera optativa, firmware privativo (publicado bajo licencias no libres que permiten su redistribución). 
#### Avisos legales
(p) y (c) 2020. Charlie Martínez y Quirinux son marcas registradas. Todo el software aquí publicado está protegido por Derechos de Autor y registrada en DNDA y se distribuye bajo licencia GPLv2.0, mientras que todo el contenido artistico que acompaña al software (íconos, wallpapers, etc) y el literario (manuales y textos en general) es distribuido bajo licencia <a href="https://creativecommons.org/licenses/by/4.0/deed.es">Creative Commons Reconocimiento 4.0 Internacional</a>. Windows, Mac, GitHub, Debian, TupiTube, OpenToonz, Ardour, Linux, GNU  y otras son marcas registradas por sus respectivo dueños.
## Licencia GPLv2.0
Puedes copiar y distribuir este material en cualquier medio y formato, remezclar, transformar y contruir nuevo material a partir del mismo para cualquier propósito, incluso comercialmente. Es necesario que indiques el nombre del autor original en los créditos, de manera adecuada y brindes un enlace a la licencia, indicando si se han realizado cambios. Puedes hacerlo en cualquier forma razonable, pero no de forma en que parezca que tu o que la implementación de este software cuenta con apoyo del licenciante. No puedes aplicar términos legales ni medidas tecnológicas que restrinjan legalmente a otras a hacer cualquier uso permitido por la licencia. 
#### Renuncias
Este repositorio de GitHub no es un respaldo a GitHub por parte de Charlie Martínez ni de Quirinux. Quirinux no mantiene ni distribuye el código base del motor de GitHub porque no está disponible bajo una licencia de código abierto y libre.
El autor de Quirinux no forma parte del equipo de desarrollo de Debian y Quirinux no es una distribución oficial de Debian, sino una derivada construida en base a ella, sin relación colaborativa alguna. 
El autor de Quirinux participa como usuario de pruebas y aporta sugerencias en proyectos como el fork de Systemback de Franco Conidi, OpenToonz y TupiTube, aplicaciones incluidas por defecto en Quirinux, sin embargo no forma parte del equipo de desarrollo de tales aplicaciones ni de ninguna otra salvo las que se indiquen específicamente en los repositorios.
