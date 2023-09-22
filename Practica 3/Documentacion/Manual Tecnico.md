# Manual Técnico

Se desarrolló una versión en consola del juego Connect4, permite partidas jugador vs jugador, jugador vs Computador, adicional incluye la funcionalidad de guardar, cargar partidas y generar un reporte con los datos al finalizar cada partida

# Práctica 4

## Requisitos

Para poder desarrollar esta práctica y para realizar modificaciones futuras es necesaria la instalación de los siguientes recursos:

1. DosBox 
    - Para emular el sistema operativo DOS o MS-DOS

2. MASM 611
    - Para compilar el código

3. IDE/Editor de Código
    - Para realizar las modificaciones al código

## Código

Todo el código se encuentra dentro de un unico archivo: main.asm

### Variables Globales
Estas variables son necesarias para mostrar mensajes en pantalla, guardar información al momento de leer archivos, manejar los cambios en el juego o para guardar la estructura basica que tendrán los reportes.

```asm
.RADIX 16
.MODEL small
ficha_a  equ 'O'
ficha_b  equ 'X'
.STACK
.DATA
encabezado  db "	Universidad de San Carlos de Guatemala",0a,"	Facultad de Ingenieria",0a,"	Arquitectura de Computadora y Ensambladores 1",0a,"	Seccion ""A""",0a,"	Segundo Semestre 2023",0a,0a,"	Nombre: Steven Josue Gonzalez Monroy",0a,"	Carnet: 201903974",0a,0a,"	Presione 'Enter' para continuar...",0a,"$"
mensaje_reintente db "	Intente nuevamente...",0a,0a,"$"
mensaje_menu db "	Menu de opciones:", 0Dh, 0Ah
             db "		1. Nueva Partida", 0Dh, 0Ah
             db "		2. Cargar Partida", 0Dh, 0Ah
             db "		3. Ayuda", 0Dh, 0Ah
             db "		4. Salir", 0Dh, 0Ah
             db "		Elija una opcion (1-4):",0a,0a,"$"

mensaje_input_ayuda_db db 0ah,"Presione 'n' para mostrar las siguientes 20 lineas o 'q' para salir.", 0a, "$"
mensaje_salir_ayuda_db db "Presione 'q' para salir.", 0a, "$"
mensaje_error_linea db "No fue posible leer la Linea", 0a, "$"
mensaje_lectura db "No fue posible leer el Archivo", 0a, "$"
mensaje_error_caracter db 0ah,"Se encontro un caracter no valido", 0a,0a,0a, "$"
archivo_db db "AYUDA.TXT", 0
ErrorCode dw ?                  ; Variable para almacenar el código de error
buffer db 255 dup(0)			 ; Buffer para almacenar los caracteres leídos
contadorLinea dw 0			   ; Contador de líneas
newline db 0Dh, 0Ah, "$"
char db ?

;variables para juego
mensaje_nombre_a db "Escriba el nombre del jugador 1: $"
mensaje_nombre_b db "Escriba el nombre del jugador 2: $"
nl       db 0a,"$"
mensaje_jugar    db 0ah,"Ingrese la columna:",0a, "$"
mensaje_fin_juego db 0ah,"No hay mas casillas disponibles, fin del juego",0a,0a,"$"
mensaje_victoria db 0ah,"Felicidades, ha ganado",0a,0a,"$"
mensaje_empate  db 0ah,"El juego ha terminado en Empate",0a,0a,"$"
buffer_nombre db 20,00
              db 20 dup (00)
nombre_c db "Computadora",0a,"$"
modo_juego db 01h
espacios_usados db 00h
ficha_actual  db ficha_a
nombre_a      db 00
              db 20 dup (00)
nombre_b      db 00
              db 20 dup (00)
tablero       db 2a dup (00)
encabezado_tablero db "  A   S   D   F   J   K   L  ",0a
                   db " ___ ___ ___ ___ ___ ___ ___ ",0a,"$"
antes_de_fila      db "| $"
entre_columnas     db " | $"
pie_de_tablero     db "'---'---'---'---'---'---'---'",0a,"$"

;;variables para apartado de juego
menu_juego db "Seleccione modo de juego: ", 0Dh, 0Ah
			db "		1. Jugador vs Jugador", 0Dh, 0Ah
			db "		2. Jugador vs Computadora", 0Dh, 0Ah,"$"
semilla dw 00h          ; Variable para almacenar la semilla inicial
numero_aleatorio db 00h ; Variable para almacenar el número aleatorio generado
mensaje_turno db 0ah,"Turno de: $" ; Mensaje para mostrar el turno del jugador
mensaje_ficha db 0ah,"Ficha: $" ; Mensaje para mostrar la ficha del jugador

;;variables para guardar partida
nombre_guardar  db 0c dup (00),00 
extension_guardar db ".SAV",00
buffer_entrada db 0ff,00
               db 0ff dup (00)
buffer_carga db 0ff,00
               db 0ff dup (00)
mensaje_guardar db "Escriba el nombre sin extension del archivo: $"
handle_guardar dw 0000
handle_cargar dw 0000
handle_reporte dw 0000
numero db 06 dup (30)
negativo db 00
mensaje_error_guardar db "No fue posible guardar el archivo", 0a, "$"

;;variables para reporte

nombre_reporte db "REP.HTM", 0
mensaje_error_reporte db "No fue posible generar el reporte", 0a, "$"
parte1 db "<body style=""text-align:center""><h1>Practica 3</h1><h2>Resultado: "
parte2 db "</h2><h3>Modo de juego: "
parte3 db "</h3><h3>Jugador O: "
parte4 db "</h3><h3>Jugador X: "
parte5 db "</h3>"
parte6 db "</body>"
fichas_x_1 db "<table style=""margin:auto""><tr><td>X</td><td>X</td><td>X</td><td>X</td></tr></table>"
fichas_x_2 db "<table style=""margin:auto""><tr><td>X</td></tr><tr><td>X</td></tr><tr><td>X</td></tr><tr><td>X</td></tr></table>"
fichas_x_3 db "<table style=""margin:auto""><tr><td>X</td><td></td><td></td><td></td></tr><tr><td></td><td>X</td><td></td><td></td></tr><tr><td></td><td></td><td>X</td><td></td></tr><tr><td></td><td></td><td></td><td>X</td></tr></table>"
fichas_x_4 db "<table style=""margin:auto""><tr><td></td><td></td><td></td><td>X</td></tr><tr><td></td><td></td><td>X</td><td></td></tr><tr><td></td><td>X</td><td></td><td></td></tr><tr><td>X</td><td></td><td></td><td></td></tr></table>"

fichas_o_1 db "<table style=""margin:auto""><tr><td>O</td><td>O</td><td>O</td><td>O</td></tr></table>"
fichas_o_2 db "<table style=""margin:auto""><tr><td>O</td></tr><tr><td>O</td></tr><tr><td>O</td></tr><tr><td>O</td></tr></table>"
fichas_o_3 db "<table style=""margin:auto""><tr><td>O</td><td></td><td></td><td></td></tr><tr><td></td><td>O</td><td></td><td></td></tr><tr><td></td><td></td><td>O</td><td></td></tr><tr><td></td><td></td><td></td><td>O</td></tr></table>"
fichas_o_4 db "<table style=""margin:auto""><tr><td></td><td></td><td></td><td>O</td></tr><tr><td></td><td></td><td>O</td><td></td></tr><tr><td></td><td>O</td><td></td><td></td></tr><tr><td>O</td><td></td><td></td><td></td></tr></table>"
str_victoria db "Victoria",0
str_empate db "Empate",0
str_pvp db "Jugador vs Jugador",0
str_pvc db "Jugador vs Computadora",0
resultado_juego db 00h
combinacion db 00h
```

### Inicio

Con estas secciones podemos limpiar la pantalla, mostrar el encabezado inicial y reconocer cuando el usuario presiona enter.

```assembly
inicio:
    mov ah, 06h    ; Función 06h: Scroll up (borrar pantalla)
    mov al, 0       ; Valor de caracteres para rellenar la pantalla (0 en blanco)
    mov bh, 07h     ; Página de códigos (color de fondo y texto)
    mov ch, 0       ; Fila superior
    mov cl, 0       ; Columna superior
    mov dh, 24      ; Fila inferior (25 líneas en modo texto)
    mov dl, 79      ; Columna inferior (80 columnas en modo texto)
    int 10h         ; Llamar a la interrupción 10h para realizar el desplazamiento de pantalla

	;;imprime el encabezado
	mov DX, offset encabezado
	mov AH, 09h
	int 21
	;;
	mov AH, 08h
	int 21
	;;verifica si la tecla presionada es enter
	cmp AL, 0Dh
	;; se modificó el registro de banderas
	je menu
	jmp no_se_presiono

no_se_presiono:
	mov DX, offset mensaje_reintente
	mov AH, 09h
	int 21

	mov AH, 01h
	int 21
	;;verifica si la tecla presionada es enter
	cmp AL, 0Dh
	;; se modificó el registro de banderas
	je menu
	jmp no_se_presiono

```


### Menu

Esta etiqueta se encarga de mostrar las opciones del menu principal y reconocer la tecla que el usuario presiona

```asm
menu:
    mov DX, offset mensaje_menu
	mov AH, 09h
	int 21

	mov AH, 08h
	int 21
	;;verifica si la tecla presionada es 1
	cmp AL, 31h
	je seleccion_modo_juego
	;;verifica si la tecla presionada es 2
	cmp AL, 32h
	je cargar_partida
	;;verifica si la tecla presionada es 3
	cmp AL, 33h
	je ayuda
	;;verifica si la tecla presionada es 4
	cmp AL, 34h
	je fin
	jmp menu

```

### Ayuda

Estas etiquetas realizan la lectura del archivo de ayuda el cual debe llamarse especificamente "AYUDA.TXT", lee caracter por caracter, verifica si es valido y los muestra hasta completar 20 lineas, tambien verifica que el usuario presione las teclas 'n' o 'q' para continuar o cerrar el apartado de ayuda.

```asm
ayuda:
	; Abrir el archivo para lectura.
	mov DX, offset archivo_db  		; Nombre del archivo a abrir.
	mov AL, 0h          		; Modo de apertura: lectura.
	mov AH, 3Dh         		; Función 3Dh: Abrir archivo.
	int 21h             		; Llamar a la interrupción 21h.

	jc error            ; Verificar si hubo un error al abrir el archivo.

	mov BX, AX          ; Guardar el descriptor de archivo en variable.

leer_caracter:
	;;guardamos todo el contenido del archivo en el buffer
    mov ah, 3Fh         ; Función 3Fh: Leer desde el archivo.
    mov dx, offset buffer      ; Dirección del buffer.
    mov cx, 1	   		; leer un solo caracter.
    int 21h             ; Llamar a la interrupción 21h para leer desde el archivo.
	jc error_lectura    ; Verificar si hubo un error al leer el archivo.
    
	mov al, buffer[0] 		; obtener caracter a mostrar.
	cmp ax, 0h         	    ; Comprobar si es el final del archivo.
	je cerrar_archivo		; Si es el final del archivo, cerrarlo.
	cmp al, 0Ah         	; Comprobar si es un salto de línea.
	
	je aumentar_contador   	; Si es un salto de línea, mostrarlo.
	cmp al, '$' 	  		; Comprobar si es el final del archivo.
	je cerrar_archivo		; Si es el final del archivo, cerrarlo.

	; verificar si el caracter es alfanumerico
	cmp al, 0Dh 			; Comprobar si es un salto de línea.
	je mostrar_caracter   	; Si es un salto de línea, mostrarlo.
	cmp al, 09h 			; Comprobar si es un tab.
	je mostrar_caracter   	; Si es un tab, mostrarlo.
	cmp al, 20h 			; Comprobar si es un espacio.
	jb error_char_ayuda  	; si es menor a espacio mostrar error
	cmp al, 7Eh			    ; Comprobar si es una virgulilla.
	ja error_char_ayuda  	; si es mayor a virgulilla mostrar error

mostrar_caracter:
	mov ah, 02h         	; Función 02h: Mostrar una caracter.
	mov dl, al          	; Caracter a mostrar.
    int 21h             	; Llamar a la interrupción 21h para mostrar el caracter.\

    jmp leer_caracter      ; Continuar leyendo caracteres.

aumentar_contador:
	inc SI ;incrementar el contador
	cmp SI, 14h ;comparar si el contador es igual a 20
	je esperar_input ;si es igual a 20 esperar la entrada del usuario
	jmp mostrar_caracter

esperar_input:

	; Mostrar un mensaje para esperar la entrada del usuario.
	mov DX, offset mensaje_input_ayuda_db ; Dirección del mensaje.
	mov AH, 09h							 ; Función 09h: Mostrar un mensaje.
	int 21								 ; Llamar a la interrupción 21h para mostrar el mensaje.
    ; Esperar la entrada del usuario ('n' para siguiente, 'q' para salir).
    mov ah, 08h         ; Función 01h: Leer un carácter desde la entrada estándar.
    int 21h             ; Llamar a la interrupción 21h para leer la tecla presionada.

    cmp al, 'n'         ; Comprobar si se presionó 'n' (siguiente).
    jne no_siguiente

    ; Reiniciar el índice de línea y volver a leer líneas.
    mov si, 0
    jmp leer_caracter

no_siguiente:
    cmp al, 'q'         ; Comprobar si se presionó 'q' (salir).
    jne esperar_input   ; Si no se presionó 'q', volver a esperar la entrada.
	
cerrar_archivo:
	mov si, 0
	; Mostrar un mensaje para esperar la entrada del usuario.
	mov DX, offset mensaje_salir_ayuda_db ; Dirección del mensaje.
	mov AH, 09h							 ; Función 09h: Mostrar un mensaje.
	int 21h								 ; Llamar a la interrupción 21h para mostrar el mensaje.

	; Esperar la entrada del usuario ('n' para siguiente, 'q' para salir).
    mov ah, 01h         ; Función 01h: Leer un carácter desde la entrada estándar.
    int 21h             ; Llamar a la interrupción 21h para leer la tecla presionada.

	cmp al, 'q'         ; Comprobar si se presionó 'q' (salir).
	jne cerrar_archivo  ; Si no se presionó 'q', volver a esperar la entrada.
    ; Cerrar el archivo y salir del programa.
    mov ah, 3Eh         ; Función 3Eh: Cerrar archivo.
    mov bx, bx          ; Descriptor de archivo.
    int 21h             ; Llamar a la interrupción 21h para cerrar el archivo.
	jmp menu
error:
	; Mover el código de error a ErrorCode
    mov ErrorCode, ax

    ; Convertir el código de error a cadena
    mov ah, 09h
    lea dx, ErrorCode
	int 21h

    ;Mostrar mensaje de error
    mov ah, 09h
    lea dx, mensaje_lectura
    int 21h

	jmp fin

error_char_ayuda:
	; Mostrar un mensaje de error si no se pudo leer el caracter.
	mov ah, 09h         ; Función 09h: Mostrar un mensaje.
	lea dx, mensaje_error_caracter ; Dirección del mensaje de error.
	int 21h             ; Llamar a la interrupción 21h para mostrar el mensaje.

	jmp cerrar_archivo   ; Continuar leyendo caracteres.

error_lectura:
    ; Mostrar un mensaje de error si no se pudo leer el archivo.
    mov ah, 09h         ; Función 09h: Mostrar un mensaje.
    lea dx, mensaje_error_linea ; Dirección del mensaje de error.
    int 21h             ; Llamar a la interrupción 21h para mostrar el mensaje.
```


### Modo de Juego
Estas secciones de codigo se encargan de mostrar el mensaje de seleccion de modos de juego y reconocer la elección del usuario
```asm
seleccion_modo_juego:
	mov DX, offset menu_juego
	mov AH, 09h
	int 21
esperar_tecla_menu_juego:	
	mov AH, 08h
	int 21
	;verifica si la tecla fue 1
	cmp AL, 31h     
	je jugar_pvp
	;verifica si la tecla fue 2
	cmp AL, 32h
	je jugar_pvc

	mov DX, offset mensaje_reintente
	mov AH, 09h
	int 21
	jmp esperar_tecla_menu_juego
```


### Juego Jugador vs PC
Estas secciones se encargan de solicitar el nombre del jugador, solicitar y verificar la columna seleccionada por el jugador y realizar el cambio entre turno de computadora y jugador.
```ASM
jugar_pvc:

	mov BL, 02h
	mov [modo_juego], BL

	mov BL, 00h
	;; pedimos la cadena de nombre del jugador 1
	mov DX, offset mensaje_nombre_a
	mov AH, 09
	int 21
	;;leemos la cadena
	mov DX, offset buffer_nombre
	mov AH, 0a
	int 21
	;;copiamos la cadena
	mov DI, offset nombre_a
	call copiar_cadena
	;;damos un salto de linea
	mov DX, offset nl
	mov AH, 09
	int 21
	
pedir_columna_pvc:

		mov BL, [espacios_usados]  ;tomamos el valor del contador de espacios usados
		cmp BL, 2Ah       ;comparamos si el contador llego a 42
		je empate
		mov BL, 0000 	;limpiamos BL

		mov DX, offset mensaje_turno
		mov AH, 09
		int 21

		call imprimir_cadena_player

		mov DX, offset mensaje_ficha
		mov AH, 09
		int 21

		mov ah, 02h     ; Cargar la función 02h para imprimir un carácter
		mov dl, ficha_actual ; Cargar el carácter que deseas imprimir en DL
		int 21h         ; Llamar a la interrupción 21h para imprimir el carácter

		mov DX, offset mensaje_jugar
		mov AH, 09
		int 21
		mov AH, 01
		int 21

		cmp AL, '0'
		je fin
		cmp AL, 'w'
		je guardar_partida
		;; AL -> columna
		call pasar_de_id_a_numero
		;; AL -> número de columna
		call buscar_vacio_en_columna
		;; DL -> 00 si se logró encontrar un espacio

		cmp DL, 0ffh	;si no hay espacio vacio en esta columna entonces volvemos a pedir la columna
		je pedir_columna
		;; DI -> dirección de la celda disponible
		;; Se coloca ficha
		mov BL, [espacios_usados]  ;aumentamos el contador de espacios usados
		add BL, 01
		mov [espacios_usados], BL

		mov BX, 0000	;;limpiamos BX

		mov AL, ficha_actual
		mov [DI], AL
		;;
		mov DX, offset nl
		mov AH, 09
		int 21
		;; - Imprimir tablero [OK]
		call imprimir_tablero

		;; - Verificar victoria
		call verificar_victoria

		; Obtiene la hora del sistema como semilla inicial
    	mov ah, 2Ch
    	int 21h
    	mov [semilla], dx

		;; - Cambiar turno a computadora
		jmp cambiar_player_por_computador
		;;
		mov AL, ficha_a
		mov [ficha_actual], AL

		jmp pedir_columna_pvc

cambiar_player_por_computador:

		mov BL, [espacios_usados]  ;tomamos el valor del contador de espacios usados
		cmp BL, 2Ah       ;comparamos si el contador llego a 42
		je empate
		mov BL, 0000 	;limpiamos BL

		mov AL, ficha_b
		mov [ficha_actual], AL
		
		mov DX, offset mensaje_turno
		mov AH, 09
		int 21

		mov DX, offset nombre_c
		mov AH, 09
		int 21

		mov DX, offset mensaje_ficha
		mov AH, 09
		int 21

		mov ah, 02h     ; Cargar la función 02h para imprimir un carácter
		mov dl, ficha_actual ; Cargar el carácter que deseas imprimir en DL
		int 21h         ; Llamar a la interrupción 21h para imprimir el carácter


		call generar_numero_aleatorio

		mov AL, [numero_aleatorio]		;obtenemos el numero aleatorio
		call buscar_vacio_en_columna	;buscamos un espacio vacio en la columna el resultado se almacena en D

		cmp DL, 0ffh	;si no hay espacio vacio en esta columna entonces volvemos a pedir la columna
		je cambiar_player_por_computador

		;; DI -> dirección de la celda disponible
		;; Se coloca ficha
		mov BL, [espacios_usados]  ;aumentamos el contador de espacios usados
		add BL, 01
		mov [espacios_usados], BL

		mov BX, 0000	;;limpiamos BX

		mov AL, ficha_actual
		mov [DI], AL
		;;
		mov DX, offset nl
		mov AH, 09
		int 21
		;; - Imprimir tablero [OK]
		call imprimir_tablero

		;; - Verificar victoria
		call verificar_victoria

		;;jmp pedir_columna
		;; - Guardar tablero
		;; - Cargar tablero

		mov AL, ficha_a
		mov [ficha_actual], AL
		jmp pedir_columna_pvc
```
### Juego Jugador vs Jugador

Estas secciones se encargan de solicitar los nombres de los jugadores, solicitar y verificar la columna seleccionada por el jugador actual y realizar el cambio entre turno de los jugadores.

```
jugar_pvp: 
	
	mov BL, 01h
	mov [modo_juego], BL

	;; pedimos la cadena de nombre del jugador 1
	mov DX, offset mensaje_nombre_a
	mov AH, 09
	int 21
	;;leemos la cadena
	mov DX, offset buffer_nombre
	mov AH, 0a
	int 21
	;;copiamos la cadena
	mov DI, offset nombre_a
	call copiar_cadena
	;;damos un salto de linea
	mov DX, offset nl
	mov AH, 09
	int 21
	;;
	mov DX, offset mensaje_nombre_b
	mov AH, 09
	int 21
	mov DX, offset buffer_nombre
	mov AH, 0a
	int 21
	;;
	mov DI, offset nombre_b
	call copiar_cadena
	;;
	mov DX, offset nl
	mov AH, 09
	int 21

pedir_columna:

		mov BL, [espacios_usados]  ;tomamos el valor del contador de espacios usados
		cmp BL, 2Ah       ;comparamos si el contador llego a 42
		je empate
		mov BL, 0000 	;limpiamos BL
		
		mov DX, offset mensaje_turno
		mov AH, 09
		int 21

		call imprimir_cadena_player

		mov DX, offset mensaje_ficha
		mov AH, 09
		int 21

		mov ah, 02h     ; Cargar la función 02h para imprimir un carácter
		mov dl, ficha_actual ; Cargar el carácter que deseas imprimir en DL
		int 21h         ; Llamar a la interrupción 21h para imprimir el carácter

		mov DX, offset mensaje_jugar
		mov AH, 09
		int 21
		mov AH, 01
		int 21

		cmp AL, '0'
		je fin
		cmp AL, 'w'
		je guardar_partida
		;; AL -> columna
		call pasar_de_id_a_numero
		;; AL -> número de columna
		call buscar_vacio_en_columna
		;; DL -> 00 si se logró encontrar un espacio

		cmp DL, 0ffh	;si no hay espacio vacio en esta columna entonces volvemos a pedir la columna
		je pedir_columna
		;; DI -> dirección de la celda disponible
		;; Se coloca ficha
		mov BL, [espacios_usados]  ;aumentamos el contador de espacios usados
		add BL, 01
		mov [espacios_usados], BL

		mov BX, 0000	;;limpiamos BX

		mov AL, ficha_actual
		mov [DI], AL
		;;
		mov DX, offset nl
		mov AH, 09
		int 21
		;; - Imprimir tablero [OK]
		call imprimir_tablero

		;; - Verificar victoria
		call verificar_victoria

		;; - Cambiar turno
		mov AL, [ficha_actual]
		cmp AL, ficha_a
		je cambiar_a_por_b
		;;
		mov AL, ficha_a
		mov [ficha_actual], AL

		jmp pedir_columna

cambiar_a_por_b:
		mov AL, ficha_b
		mov [ficha_actual], AL
		jmp pedir_columna
		;; - Guardar tablero
		;; - Cargar tablero
		jmp fin
```

### Guardado de Nombres

estas subrutinas nos permite guardar los nombres de los usuarios cada vez que se inicia una nueva partida

```asm
copiar_cadena:
		;; DI tengo ^
		mov SI, offset buffer_nombre 	;tomamos la direccion del primer byte del buffer
		inc SI							;pasamos a la segunda posicion del buffer
		mov AL, [SI]					;trasladamos el segundo byte del buffer a AL
		mov [DI], AL					;trasladamos el segundo byte del buffer a DI
		inc SI   ;; moverme a los bytes de la cadena
		inc DI   ;; para guardar esos bytes en el lugar correcto
		;;
		mov CX, 0000  ;; limpiando CX
		mov CL, AL		;;especificamos el tamaño de la cadena para el ciclo de copiado este valor es usado por la instruccion loop
ciclo_copiar_cadena:
		mov AL, [SI]
		mov [DI], AL
		inc SI
		inc DI
		loop ciclo_copiar_cadena
		ret
```

### Busqueda de espacio en columna

Las siguientes subrutinas permiten identificar la columna en la que el usuario desea colocar una ficha y verificar si existe estacio disponible en dicha columna.

```asm
;; pasar_de_id_a_numero - pasa de un id de columna a un número
;;
;; SALIDA:  AL -> número de columna o coordenada X
pasar_de_id_a_numero:
		cmp AL, 'a'
		je retornar_num0
		cmp AL, 's'
		je retornar_num1
		cmp AL, 'd'
		je retornar_num2
		cmp AL, 'f'
		je retornar_num3
		cmp AL, 'j'
		je retornar_num4
		cmp AL, 'k'
		je retornar_num5
		cmp AL, 'l'
		je retornar_num6
retornar_num0:
		mov AL, 00
		ret
retornar_num1:
		mov AL, 01
		ret
retornar_num2:
		mov AL, 02
		ret
retornar_num3:
		mov AL, 03
		ret
retornar_num4:
		mov AL, 04
		ret
retornar_num5:
		mov AL, 05
		ret
retornar_num6:
		mov AL, 06
		ret
;;
;; buscar_vacio_en_columna - busca un espacio vacío en la columna indicada
;;
;; ENTRADA: AL -> número de columna o X
;; SALIDA:  DI -> número de fila con espacio disponible
;;          DL -> 00 si se obtuvo un espacio disponible
;;               0ff si no se econtró espacio
buscar_vacio_en_columna:
		;; X en AL , Y en DL -> (AL, DL)
		mov DL, 05
ciclo_buscar_vacio:
		;; índice = 7*DL + AL
		mov DH, AL
		;; 7*DL = AX
		mov AL, 07
		mul DL
		;; 7*DL + DH
		;;  AL  + DH
		add AL, DH
		;; AX -> índice
		mov DI, offset tablero
		add DI, AX
		;; verifico el contenido
		mov AL, [DI]
		cmp AL, 00  		;; verificar si está vacío
		je retorno_buscar_vacio
		dec DL
		mov AL, DH  		;volvemos a colocar la columna deseada en al
		cmp DL, 00			;verificamos si ya se llego a la fila 0
		jge ciclo_buscar_vacio
retorno_fallido_buscar_vacio:
		mov DL, 0ffh
		ret
retorno_buscar_vacio:
		mov DL, 00
		ret
;;
;; obtener_valor_de_casilla - obtiene el valor de una casilla del tablero
;;
;; ENTRADA: BH -> X
;;          BL -> Y
;; SALIDA:  DL -> valor
obtener_valor_de_casilla:
		;; índice = 7*BL + BH
		;; 7*BL = AX
		mov AL, 07
		mul BL
		;; 7*BL + BH
		;;  AL  + BH
		add AL, BH
		;; AX -> índice
		mov DI, offset tablero
		add DI, AX
		;; obtengo el contenido
		mov DL, [DI]
		ret
```


### Mostrar Tablero

Las siguientes subrutinas permiten mostrar el tablero en pantalla con las fichas que han sido colocadas por los usuarios en la partida actual.

```asm
;;
;; imprimir_tablero - imprime el tablero del juego
;;
imprimir_tablero:
		mov DX, offset encabezado_tablero
		mov AH, 09
		int 21
		;;
		mov BX,0000
		;; inicialización de contadores
		mov SI, 0006
		xchg SI, CX
ciclo_columnas:
		xchg SI, CX
		mov CX, 0007
		;;
		mov DX, offset antes_de_fila
		mov AH, 09
		int 21
		;;
ciclo_fila:
		call obtener_valor_de_casilla
		cmp DL, 00
		je imprimir_vacia
		cmp DL, ficha_a
		je imprimir_ficha_a
		cmp DL, ficha_b
		je imprimir_ficha_b
imprimir_vacia:
		mov DL, ' '
		mov AH, 02
		int 21
		mov DX, offset entre_columnas
		mov AH, 09
		int 21
		jmp avanzar_en_fila
imprimir_ficha_a:
		mov DL, ficha_a
		mov AH, 02
		int 21
		mov DX, offset entre_columnas
		mov AH, 09
		int 21
		jmp avanzar_en_fila
imprimir_ficha_b:
		mov DL, ficha_b
		mov AH, 02
		int 21
		mov DX, offset entre_columnas
		mov AH, 09
		int 21
		jmp avanzar_en_fila
avanzar_en_fila:
		inc BH
		loop ciclo_fila
		mov DL, 0ah
		mov AH, 02h
		int 21
		;;
		mov BH, 00
		inc BL
		xchg SI, CX
		loop ciclo_columnas
		;;
		mov DX, offset pie_de_tablero
		mov AH, 09
		int 21
		ret
```
### Verificacion de Victoria

Estas subrutinas verifican si existe una combinacion de 4 fichas continuas para el turno actual y envia a la subrutina de victoria para posteriormente regresar al menú.

```asm
verificar_victoria:
    ; Verificar victoria en las filas
    mov cx, 06 ; Número de filas
    mov si, 00 ; Índice de inicio del tablero
    verificar_filas:
        mov di, si
        add di, 04 ; fila de 4 elementos hacia la derecha
        verificar_horizontal:
            mov al, [tablero+si]
            cmp al, ficha_a ; Comprobar si es una ficha del jugador 1
            je jugador1_encontrado
            cmp al, ficha_b ; Comprobar si es una ficha del jugador 2
            je jugador2_encontrado
            jmp siguiente_celda
        jugador1_encontrado:
            ; Comprobar si las siguientes tres celdas son del jugador 1
            mov al, [tablero+si+1]
            cmp al, ficha_a
            je siguiente_celda2
            jmp siguiente_celda
        siguiente_celda2:
            mov al, [tablero+si+2]
            cmp al, ficha_a
            je siguiente_celda3
            jmp siguiente_celda
        siguiente_celda3:
			mov [combinacion], 01h
            mov al, [tablero+si+3]
            cmp al, ficha_a
            je victoria
            jmp siguiente_celda
        jugador2_encontrado:
            ; Comprobar si las siguientes tres celdas son del jugador 2
            mov al, [tablero+si+1]
            cmp al, ficha_b
            je siguiente_celda12
            jmp siguiente_celda
        siguiente_celda12:
            mov al, [tablero+si+2]
            cmp al, ficha_b
            je siguiente_celda13
            jmp siguiente_celda
        siguiente_celda13:
			mov [combinacion], 05h
            mov al, [tablero+si+3]
            cmp al, ficha_b
            je victoria
        siguiente_celda:
            inc si
            cmp si, di
            jb verificar_horizontal

		sub si, 04h
        add si, 07h
        loop verificar_filas

	; Verificar victoria en las columnas
    mov si, 00 ; Índice de inicio del tablero
    verificar_columnas:
		mov di, 00h
        add di, 15h ; 3 filas hacia abajo, SI debe iniciar menor a la posicion 21 sino ya es la fila 4
        verificar_vertical:
            mov al, [tablero+si]
            cmp al, ficha_a
            je jugador1_encontrado_vertical
            cmp al, ficha_b
            je jugador2_encontrado_vertical
            jmp siguiente_celda_vertical
        jugador1_encontrado_vertical:
            mov al, [tablero+si+7]
            cmp al, ficha_a
            je jugador1_encontrado_vertical2
            jmp siguiente_celda_vertical
		jugador1_encontrado_vertical2:
			mov al, [tablero+si+0eh]
			cmp al, ficha_a
			je jugador1_encontrado_vertical3
			jmp siguiente_celda_vertical
		jugador1_encontrado_vertical3:
			mov [combinacion], 02h
			mov al, [tablero+si+15h]
			cmp al, ficha_a
			je victoria
			jmp siguiente_celda_vertical

        jugador2_encontrado_vertical:
            mov al, [tablero+si+7]
            cmp al, ficha_b
            je jugador2_encontrado_vertical2
			jmp siguiente_celda_vertical
		jugador2_encontrado_vertical2:
			mov al, [tablero+si+0eh]
			cmp al, ficha_b
			je jugador2_encontrado_vertical3
			jmp siguiente_celda_vertical
		jugador2_encontrado_vertical3:
			mov [combinacion], 06h
			mov al, [tablero+si+15h]
			cmp al, ficha_b
			je victoria
			jmp siguiente_celda_vertical
		
        siguiente_celda_vertical:
            inc si
            cmp si, di
            jb verificar_vertical
    
	; Verificar victoria en las diagonales
    mov si, 00 ; Índice de inicio del tablero
    verificar_diagonales:
		mov di, 00h
        add di, 12h ; posicion maxima en donde se puede encontrar una victoria en diagonal
        verificar_diagonal:
            mov al, [tablero+si]
            cmp al, ficha_a
            je jugador1_encontrado_diagonal
            cmp al, ficha_b
            je jugador2_encontrado_diagonal
            jmp siguiente_celda_diagonal
        jugador1_encontrado_diagonal:
            mov al, [tablero+si+8h]
            cmp al, ficha_a
            je jugador1_encontrado_diagonal2
            jmp siguiente_celda_diagonal
		jugador1_encontrado_diagonal2:
			mov al, [tablero+si+10h]
			cmp al, ficha_a
			je jugador1_encontrado_diagonal3
			jmp siguiente_celda_diagonal
		jugador1_encontrado_diagonal3:
			mov [combinacion], 03h
			mov al, [tablero+si+18h]
			cmp al, ficha_a
			je victoria
			jmp siguiente_celda_diagonal

        jugador2_encontrado_diagonal:
            mov al, [tablero+si+8h]
            cmp al, ficha_b
            je jugador2_encontrado_diagonal2
			jmp siguiente_celda_diagonal
		jugador2_encontrado_diagonal2:
			mov al, [tablero+si+10h]
			cmp al, ficha_b
			je jugador2_encontrado_diagonal3
			jmp siguiente_celda_diagonal
		jugador2_encontrado_diagonal3:
			mov [combinacion], 07h
			mov al, [tablero+si+18h]
			cmp al, ficha_b
			je victoria
			jmp siguiente_celda_diagonal
		
        siguiente_celda_diagonal:
            inc si
			cmp si, 04h
			je siguiente_celda_diagonal
			cmp si, 05h
			je siguiente_celda_diagonal
			cmp si, 06h
			je siguiente_celda_diagonal
			cmp si, 0Bh
			je siguiente_celda_diagonal
			cmp si, 0Ch
			je siguiente_celda_diagonal
			cmp si, 0Dh
			je siguiente_celda_diagonal
			cmp si, 14h
			je siguiente_celda_diagonal
            cmp si, di
            jb verificar_diagonal


	; Verificar victoria en las diagonales inversas
    mov si, 00 ; Índice de inicio del tablero
    verificar_contradiagonales:
		mov di, 00h
        add di, 15h ; posicion maxima en donde se puede encontrar una victoria en diagonal
        verificar_contradiagonal:
            mov al, [tablero+si]
            cmp al, ficha_a
            je jugador1_encontrado_contradiagonal
            cmp al, ficha_b
            je jugador2_encontrado_contradiagonal
            jmp siguiente_celda_contradiagonal
        jugador1_encontrado_contradiagonal:
            mov al, [tablero+si+6h]
            cmp al, ficha_a
            je jugador1_encontrado_contradiagonal2
            jmp siguiente_celda_contradiagonal
		jugador1_encontrado_contradiagonal2:
			mov al, [tablero+si+0Ch]
			cmp al, ficha_a
			je jugador1_encontrado_contradiagonal3
			jmp siguiente_celda_contradiagonal
		jugador1_encontrado_contradiagonal3:
			mov [combinacion], 04h
			mov al, [tablero+si+12h]
			cmp al, ficha_a
			je victoria
			jmp siguiente_celda_contradiagonal

        jugador2_encontrado_contradiagonal:
            mov al, [tablero+si+6h]
            cmp al, ficha_b
            je jugador2_encontrado_contradiagonal2
			jmp siguiente_celda_contradiagonal
		jugador2_encontrado_contradiagonal2:
			mov al, [tablero+si+0Ch]
			cmp al, ficha_b
			je jugador2_encontrado_contradiagonal3
			jmp siguiente_celda_contradiagonal
		jugador2_encontrado_contradiagonal3:
			mov [combinacion], 08h
			mov al, [tablero+si+12h]
			cmp al, ficha_b
			je victoria
			jmp siguiente_celda_contradiagonal
		
        siguiente_celda_contradiagonal:
            inc si
			cmp si, 00h
			je siguiente_celda_contradiagonal
			cmp si, 01h
			je siguiente_celda_contradiagonal
			cmp si, 02h
			je siguiente_celda_contradiagonal
			cmp si, 07h
			je siguiente_celda_contradiagonal
			cmp si, 08h
			je siguiente_celda_contradiagonal
			cmp si, 09h
			je siguiente_celda_contradiagonal
			cmp si, 0Eh
			je siguiente_celda_contradiagonal
			cmp si, 0Fh
			je siguiente_celda_contradiagonal
			cmp si, 10h
			je siguiente_celda_contradiagonal
            cmp si, di
            jb verificar_contradiagonal
    ; No se encontró ninguna victoria
    ret

victoria:
	mov al, 01h
	mov [resultado_juego], al
	call generar_reporte
	call limpiar_variables
    mov ah, 09h
    lea dx, mensaje_victoria
    int 21h

	jmp menu
```

### Generar numero aleatorio

Subrutina para obtener una columna aleatoria para el turno de la computadora en el modo PvC.

```asm
generar_numero_aleatorio:
    ; Genera un número aleatorio entre 0 y 7 basado en la hora del sistema

    ; Carga la semilla en DX para el generador de números pseudoaleatorios
    mov dx, [semilla]

    ; Multiplica DX por 0x5DEECE66D (una constante común en generadores)
    mov ax, dx
    mov cx, 5DEEh
    mov bx, 66Dh
    mul cx
    mov cx, dx
    mul bx
    add ax, cx

    ; Agrega la hora del sistema actual a DX
    mov ah, 2Ch
    int 21h
    add dx, ax

    ; Genera un número entre 0 y 7
    and dx, 07h

    ; Almacena el resultado en [numero_aleatorio]
    mov [numero_aleatorio], dl

    ; Actualiza la semilla
    mov [semilla], dx

    ret
```

### Imprimir nombres de jugadores
Esta subrutina permite imprimir en la consola el nombre del usuario con el turno actual.

```asm
imprimir_cadena_player:
    ; Imprime una cadena de caracteres sin el carácter nulo al final

    mov BX, 0001
	mov CX, 0000

	cmp [ficha_actual], ficha_a
	je imprimir_a

	mov CL, [nombre_b]
	mov DI, offset nombre_b
	inc DI
	mov DX, DI
	mov AH, 40
	int 21
	ret

imprimir_a:
	mov CL, [nombre_a]
	mov DI, offset nombre_a
	inc DI
	mov DX, DI
	mov AH, 40
	int 21

    ret
```

### Guardar partida

Subrutina para solicitar el nombre del archivo con extensión ".SAV" y escribir el contenido de la partida actual para recuperarlo posteriormente.

```

guardar_partida:
		mov DX, offset nl
		mov AH, 09
		int 21
		mov DX, offset mensaje_guardar
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;
		mov DX, offset nl
		mov AH, 09
		int 21
		;; DI <- primer byte del buffer
		mov DI, offset buffer_entrada
		inc DI
		;; DI <- segundo byte, tamaño de cadena leida
		mov AL, [DI]
		cmp AL, 08
		ja guardar_partida
		;;; cadena correcta
		call copiar_y_agregar_extension
		;;
		mov CX, 0000
		mov DX, offset nombre_guardar
		mov AH, 3c
		int 21
		;; AX -> handle
		mov [handle_guardar], AX
		;; Se guardará nombre_a, nombre_b, tablero y ficha actual
		mov BX, [handle_guardar]
		mov CX, 006Fh
		mov DX, offset modo_juego
		mov AH, 40
		int 21
		;;
		mov AH, 3e
		int 21
		;;
		mov AL, [modo_juego]
		cmp AL, 01h
		je pedir_columna
		cmp AL, 02h
		je pedir_columna_pvc
		;; - Cargar tablero
```

### Guardar nombre de archivo

Subrutina para guardar el nombre del archivo para guardar o cargar una partida.

```

copiar_y_agregar_extension:
		mov CX, 0000
		mov CL, 0c
		mov BX, offset nombre_guardar
limpiar_nombre_guardar:
		mov AL, 00
		mov [BX], AL
		inc BX
		loop limpiar_nombre_guardar
		;;
		mov SI, offset nombre_guardar
		mov CX, 0000
		mov CL, [DI]
		inc DI
ciclo_copiar_sin_extension:
		mov AL, [DI]
		mov [SI], AL
		inc DI
		inc SI
		loop ciclo_copiar_sin_extension
		;;;
		mov CX, 0000
		mov CL, 04  ;; ".SAV"
		mov DI, offset extension_guardar
ciclo_copiar_extension:
		mov AL, [DI]
		mov [SI], AL
		inc DI
		inc SI
		loop ciclo_copiar_extension
		ret
```


### Limpiar variables

Subrutina para limpiar las variables que se utilizan en cada partida.

```
limpiar_variables:
		mov [ficha_actual], ficha_a
		mov [espacios_usados], 00h
		mov [modo_juego], 01h
		mov [resultado_juego], 00h
		mov [combinacion], 00h
		mov AL, 21h
		mov DI, offset nombre_a
		mov AL, 6Ch 			;;cantidad de bytes a limpiar en este caso son 108 = 1+32 + 1+32 + 42 porque las variables son contiguas
		call limpiar_cadena
		ret

;; limpiar_cadena - limpia una cadena
;;    ENTRADAS: DI -> dirección hacia donde limpiar
;;	            AL -> tamano de bytes a limpiar
limpiar_cadena:
		mov CX, 0000  ;; limpiando CX
		mov CL, AL		;;especificamos el tamaño de la cadena para el ciclo de copiado este valor es usado por la instruccion loop
ciclo_limpiar_cadena:
		mov AL, 00h
		mov [DI], AL
		inc DI
		loop ciclo_limpiar_cadena
		ret
```

### Cargar Partida

Subrutina para cargar una partida por medio de un archivo ".SAV" previamente guardado. Se encarga de solicitar y leer el nombre del archivo especificado por el usuario y tomar la información del archivo y lo coloca en las variables de la partida.

```
cargar_partida:
	mov DX, offset nl
	mov AH, 09
	int 21
	mov DX, offset mensaje_guardar
	mov AH, 09
	int 21
	mov DX, offset buffer_carga
	mov AH, 0a
	int 21
	;;
	mov DX, offset nl
	mov AH, 09
	int 21
	;; DI <- primer byte del buffer
	mov DI, offset buffer_carga
	inc DI
	;; DI <- segundo byte, tamaño de cadena leida
	mov AL, [DI]
	cmp AL, 08
	ja cargar_partida
	;;; cadena correcta
	call copiar_y_agregar_extension
	;;
	; Abrir el archivo para lectura.
	mov DX, offset nombre_guardar  		; Nombre del archivo a abrir.
	mov AL, 0h          		; Modo de apertura: lectura.
	mov AH, 3Dh         		; Función 3Dh: Abrir archivo.
	int 21h             		; Llamar a la interrupción 21h.

	jc error            ; Verificar si hubo un error al abrir el archivo.

	mov BX, AX          ; Guardar el descriptor de archivo en variable.

leer_info_partida:
	;;guardamos todo el contenido del archivo en el buffer
    mov ah, 3Fh         ; Función 3Fh: Leer desde el archivo.
    mov dx, offset buffer      ; Dirección del buffer.
    mov cx, 006Fh	   		; leer 110 caracteres
    int 21h             ; Llamar a la interrupción 21h para leer desde el archivo.


	jc error_lectura    ; Verificar si hubo un error al leer el archivo.
	mov si, offset buffer
	mov DI, offset modo_juego
	mov CX, 006Fh
	;rep movsb
	
copyLoop:
    mov al, [si]        ; Lee un byte del búfer
    mov [di], al        ; Copia el byte a la variable
    inc si              ; Avanza al siguiente byte en el búfer
    inc di              ; Avanza al siguiente byte en la variable
    loop copyLoop       ; Repite hasta copiar todos los bytes

	mov AH, 3Eh		 ; Función 3Eh: Cerrar archivo.
	mov BX, BX          ; Descriptor de archivo.
	int 21h             ; Llamar a la interrupción 21h para cerrar el archivo.

	call imprimir_tablero

	MOV AL, [modo_juego]
	CMP AL, 01h
	je pedir_columna
	cmp AL, 02h
	je pedir_columna_pvc
```

### Generación de reportes

Subrutinas para generar los reportes al final de las partidas en formato ".HTM". Crea y escribe el archivo con formato HMTL para posteriormente abrirlo en un navegador.

```
generar_reporte:
	mov ah, 3Ch         ; Función 3Ch - Abrir archivo
    mov cx, 2           ; Modo de apertura (2 = crear o abrir para escritura)
    lea dx, nombre_reporte     ; Nombre del archivo
    int 21h             ; Llamar a la interrupción 21h

	jc error_reporte     ; Verificar si hubo un error al abrir el archivo.

	mov [handle_reporte], ax ; Guardar el descriptor de archivo en variable.

	;;escribir parte 1
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 42h      	; Número de bytes a escribir
	mov dx, offset parte1 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	mov al, [resultado_juego]
	cmp	al, 01h
	je add_str_victoria
	jmp add_str_empate

continuar_reporte1:
	;;escribir parte 2
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 18h      	; Número de bytes a escribir
	mov dx, offset parte2 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h
	
	mov al, [modo_juego]
	cmp al, 01h
	je add_str_pvp
	jmp add_str_pvc

continuar_reporte2:
	
	mov al, [resultado_juego]
	cmp	al, 01h
	je add_combinacion
	jmp cerrar_reporte

cerrar_reporte:

	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 07h      	; Número de bytes a escribir
	mov dx, offset parte6		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	; Cerrar el archivo
    mov ah, 3Eh         ; Función 3Eh - Cerrar archivo
    mov bx, [handle_reporte]    ; Manejador del archivo
    int 21h             ; Llamar a la interrupción 21h
	ret

add_str_victoria:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 08h      	; Número de bytes a escribir
	mov dx, offset str_victoria 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h
	jmp continuar_reporte1

add_str_empate:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 06h      	; Número de bytes a escribir
	mov dx, offset str_empate 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h
	jmp continuar_reporte1

add_str_pvp:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 12h      	; Número de bytes a escribir
	mov dx, offset str_pvp 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	;;escribir parte 3
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 14h      	; Número de bytes a escribir
	mov dx, offset parte3 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	mov cx, 0000
	mov di, offset nombre_a
	mov cl, [nombre_a]		; colocamos el tamaño de la cadena
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	inc di				; nos movemos a la direccion de la cadena
	mov dx, di			; colocamos la direccion de la cadena
	int 21h             ; Llamar a la interrupción 21h

	;;escribir parte 4
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 14h      	; Número de bytes a escribir
	mov dx, offset parte4 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	mov cx, 0000
	mov di, offset nombre_b
	mov cl, [nombre_b]		; colocamos el tamaño de la cadena
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	inc di				; nos movemos a la direccion de la cadena
	mov dx, di			; colocamos la direccion de la cadena
	int 21h             ; Llamar a la interrupción 21h

	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 05h      	; Número de bytes a escribir
	mov dx, offset parte5 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp continuar_reporte2

add_str_pvc:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 16h      	; Número de bytes a escribir
	mov dx, offset str_pvc 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	;;escribir parte 3
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 14h      	; Número de bytes a escribir
	mov dx, offset parte3 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	mov cx, 0000
	mov di, offset nombre_a
	mov cl, [nombre_a]		; colocamos el tamaño de la cadena
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	inc di				; nos movemos a la direccion de la cadena
	mov dx, di			; colocamos la direccion de la cadena
	int 21h             ; Llamar a la interrupción 21h

	;;escribir parte 4
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 14h      	; Número de bytes a escribir
	mov dx, offset parte4 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 0Bh      	; Número de bytes a escribir
	mov dx, offset nombre_c 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 05h      	; Número de bytes a escribir
	mov dx, offset parte5 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp continuar_reporte2

add_combinacion:
	mov al, [combinacion]
	cmp al, 01h
	je comb1
	cmp al, 02h
	je comb2
	cmp al, 03h
	je comb3
	cmp al, 04h
	je comb4
	cmp al, 05h
	je comb5
	cmp al, 06h
	je comb6
	cmp al, 07h
	je comb7
	jmp comb8

comb1:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 54h      	; Número de bytes a escribir
	mov dx, offset fichas_o_1 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb2:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 6Fh    	; Número de bytes a escribir
	mov dx, offset fichas_o_2 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb3:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 00DBh      	; Número de bytes a escribir
	mov dx, offset fichas_o_3 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb4:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 00DBh      	; Número de bytes a escribir
	mov dx, offset fichas_o_4 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb5:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 54h      	; Número de bytes a escribir
	mov dx, offset fichas_x_1		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb6:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 6Fh      	; Número de bytes a escribir
	mov dx, offset fichas_x_2		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb7:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 00DBh       	; Número de bytes a escribir
	mov dx, offset fichas_x_3		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

comb8:
	mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 00DBh      	; Número de bytes a escribir
	mov dx, offset fichas_x_4		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

	jmp cerrar_reporte

error_reporte:
	mov ah, 09h
	lea dx, mensaje_error_reporte
	int 21h
	jmp menu

```

