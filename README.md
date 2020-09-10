# instalar-quirinux.sh
Autor: Charlie Martínez ®
## Acerca de este repositorio
Quirinux es una imagen personalizada y compartida de Debian Buster que fue creada inicialmente con este script. Si ya cuentas con Debian Buster instalado, puedes utilizar este script para convertirlo en Quirinux. 

Lo que hará el script es modificar los archivos de configuración de Buster para convertirlo en Quirinux 2.0, agregando los repositorios de Mint LMDE4, OpenSuse y Cinelerra, además de programas especialmente empaquetados en .deb para Quirinux (ej. Tupi, Storyboarder) y otros que se descargan y compilan directamente desde la versión más nueva de su código fuente (ej. Ardour, Opentoonz)

## Detalles adicionales
Este instalador funciona por consola, en modo de texto y no es desatendido: cada paso requiere ser confirmado por el usuario. 
### Compatibilidad
Programado para Debian Buster y probado con éxito en AV Linux, Linux Mint LMDE4 y Q4OS, o sea, distribuciones basadas en Debian Buster.
NO COMPATIBLE CON: Devuan Beowult, derivadas como Etertics, GobMis. Tampoco es compatible con Ubuntu. Para utilizarlo con distros que no sean Debian Buster, es necesario modificar el código fuente en lo que concierne a paquetes de instalación / desinstalación de base y sources.list 
### Instrucciones
sudo chmod 755 instalar-quirinux.sh
sudo ./instalar-quirinux.sh
#### Autores
Charlie Martínez, haciendo uso de la libertad de distribución de la licencia GPL, ha programado este instalador pero no guarda relación con el desarrollo de gran parte del software que instala, el cual ha sido liberado casi en su totalidad bajo licencia GPLv3. Este script está liberado también bajo licencia GPLv3. Este script proporciona formas de instalar, de manera optativa, firmware privativo (publicado bajo licencias no libres que permiten su redistribución). 
#### Avisos legales
(p) y (c) 2020. Charlie Martínez y Quirinux son marcas registradas. Todo el software aquí publicado está protegido por Derechos de Autor y registrada en DNDA y se distribuye bajo licencia <a href="https://lslspanish.github.io/translation_GPLv3_to_spanish/">GPLv3</a>, mientras que todo el contenido artistico que acompaña al software (íconos, wallpapers, etc) y el literario (manuales y textos en general) es distribuido bajo licencia <a href="https://creativecommons.org/licenses/by/4.0/deed.es">Creative Commons Reconocimiento 4.0 Internacional</a>. Windows, Mac, GitHub, Debian, TupiTube, OpenToonz, Linux, GNU, Ardour y otras son marcas registradas por sus respectivo dueños.
## Licencia GPLv3
Puedes copiar y distribuir este material en cualquier medio y formato, remezclar, transformar y contruir nuevo material a partir del mismo para cualquier propósito, incluso comercialmente. Es necesario que indiques el nombre del autor original en los créditos, de manera adecuada y brindes un enlace a la licencia, indicando si se han realizado cambios. Puedes hacerlo en cualquier forma razonable, pero no de forma en que parezca que tu o que la implementación de este software cuenta con apoyo del licenciante. No puedes aplicar términos legales ni medidas tecnológicas que restrinjan legalmente a otras a hacer cualquier uso permitido por la licencia. 
#### Renuncias
Este repositorio de GitHub no es un respaldo a GitHub por parte de Charlie Martínez ni de Quirinux. Quirinux no mantiene ni distribuye el código base del motor de GitHub porque no está disponible bajo una licencia de código abierto y libre.
El autor de Quirinux no forma parte del equipo de desarrollo de Debian y Quirinux no es una distribución oficial de Debian, sino una derivada construida en base a ella, sin relación colaborativa alguna. 
El autor de Quirinux participa como usuario de pruebas y aporta sugerencias en proyectos como el fork de Systemback de Franco Conidi, OpenToonz y TupiTube, aplicaciones incluidas por defecto en Quirinux, sin embargo no forma parte del equipo de desarrollo de tales aplicaciones ni de ninguna otra salvo las que se indiquen específicamente en los repositorios.
