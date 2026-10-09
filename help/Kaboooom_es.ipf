:userdoc.
:title.Ayuda de Kaboooom
:docprof toc=12.
:h1 res=1000.General
:p.Kaboooom! es un juego de ingenio&colon. camine desde la esquina superior izquierda de un campo hasta la casa de la esquina inferior derecha sin pisar una mina. Se basa en un juego publicado por Alex Lane en Dr. Dobb's Journal en 1990 y fue escrito para OS/2 por Michael G. Slack.
:p.:link reftype=hd res=1100.Como jugar:elink.
:p.:link reftype=hd res=1200.Teclas y raton:elink.
:p.:link reftype=hd res=1300.Ajustes:elink.
:p.:link reftype=hd res=1400.Ayuda del Ordenador:elink.
:p.:link reftype=hd res=1500.Acerca de Kaboooom:elink.
:h1 res=1100.Como jugar
:ul.
:li.Usted es el hombrecillo de la esquina superior izquierda. Avance una celda cada vez, en cualquiera de las ocho direcciones.
:li.Cada celda por la que ha pasado muestra cuantas minas hay en las celdas de alrededor (y en la propia celda). Use estos numeros para encontrar el camino seguro.
:li.Si cree que hay una mina en una celda junto a usted, marquela con el boton derecho del raton. Con Juego seguro activado no puede pisar una celda marcada. Las marcas son solo una ayuda; pueden ser erroneas.
:li.Gana al llegar a la casa. Pierde si pisa una mina. Al terminar se muestran todas las minas.
:eul.
:h1 res=1200.Teclas y raton
:p.Muevase con el raton, el panel de la derecha, las teclas de cursor o el teclado numerico&colon.
:table cols='18 34 36' rules=both frame=box.
:row.:c.:hp2.Accion:ehp2.:c.:hp2.Tecla:ehp2.:c.:hp2.Que hace:ehp2.
:row.:c.Mover:c.Clic izquierdo en una celda contigua:c.Ir a esa celda
:row.:c.Mover:c.Teclas de cursor, Inicio, Fin, Re Pag, Av Pag:c.Ocho direcciones
:row.:c.Mover:c.Teclado numerico 7 8 9 / 4 6 / 1 2 3:c.Ocho direcciones
:row.:c.Marcar:c.Clic derecho en una celda contigua:c.Marcar o desmarcar
:row.:c.Marcar:c.Ctrl y una tecla de cursor:c.Marcar o desmarcar esa celda
:row.:c.Ayuda del Ordenador:c.Ctrl+E o 5 o el boton ?:c.El ordenador deduce lo que puede
:row.:c.Nuevo Juego:c.Ctrl+N:c.Empezar un campo nuevo
:row.:c.Salir:c.Ctrl+X:c.Cerrar el programa
:row.:c.Controles de marco:c.Ctrl+F:c.Ocultar o mostrar la barra de titulo y el menu
:etable.
:h1 res=1300.Ajustes
:p.Opciones - Ajustes cambia el juego. Los ajustes se guardan al salir si Guardar ajustes al salir esta marcado.
:parml tsize=24 break=none.
:pt.Juego seguro
:pd.No se puede pisar una celda marcada.
:pt.Sonidos
:pd.Reproduce un sonido en los eventos del juego&colon. los archivos beep.wav, finish.wav, explode.wav y negative.wav de la carpeta sounds junto al programa. Puede sustituirlos por los suyos.
:pt.Mensajes detallados
:pd.El ordenador tambien pita al terminar.
:pt.Confirmaciones
:pd.Pregunta antes de un juego nuevo y antes de que ayude el ordenador.
:pt.Numero aleatorio de bombas
:pd.Cada juego nuevo tiene entre 10 y 40 minas. Sin esta opcion elige el numero de bombas (10-40).
:pt.Idioma
:pd.Idioma del programa y de la ayuda (Opciones - Idioma).
:eparml.
:h1 res=1400.Ayuda del Ordenador
:p.El ordenador mira los numeros que ha descubierto y deduce que celdas son seguras y cuales son minas. Abre las seguras (muestran su numero) y marca las minas. Luego vuelve a mirar, hasta que no encuentra nada mas.
:p.Si no puede deducir nada se lo dice. El ordenador no le mueve; usted camina. Si gana tras usar la ayuda, el mensaje lo indica.
:p.La ayuda solo usa los numeros del tablero, nunca las minas ocultas. Sus propias marcas se ignoran mientras piensa.
:h1 res=1500.Acerca de Kaboooom
:p.Kaboooom 1.07 para OS/2, ArcaOS y eComStation.
:p.Autor original&colon. Michael G. Slack (1997-1998).
:p.Basado en Kaboooom! de Alex Lane, Dr. Dobb's Journal #163, abril de 1990.
:p.Port a Open Watcom 2.0&colon. comunidad OS2World (2026).
:p.Licencia&colon. BSD de 3 clausulas.
:euserdoc.
