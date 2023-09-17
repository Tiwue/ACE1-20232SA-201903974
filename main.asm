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

;;variables para apartado de ayuda
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
mensaje_jugar    db "Ingrese la columna: $"
mensaje_fin_juego db 0ah,"No hay mas casillas disponibles, fin del juego",0a,0a,"$"
mensaje_victoria db 0ah,"Felicidades, ha ganado",0a,0a,"$"
buffer_nombre db 20,00
              db 20 dup (00)
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
ficha_actual  db ficha_a
espacios_usados db 00h
.CODE
.STARTUP
;; LÓGICA DEL PROGRAMA
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
menu:
    mov DX, offset mensaje_menu
	mov AH, 09h
	int 21

	mov AH, 08h
	int 21
	;;verifica si la tecla presionada es 1
	cmp AL, 31h
	je jugar
	;;verifica si la tecla presionada es 2
	cmp AL, 32h
	je menu
	;;verifica si la tecla presionada es 3
	cmp AL, 33h
	je ayuda
	;;verifica si la tecla presionada es 4
	cmp AL, 34h
	je fin
	jmp menu
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

jugar: 
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
		je fin_juego
		mov BL, 0000 	;limpiamos BL

		mov DX, offset mensaje_jugar
		mov AH, 09
		int 21
		mov AH, 01
		int 21
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


;; copiar_cadena - copia una cadena
;;    ENTRADAS: DI -> dirección hacia donde guardar
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

fin_juego:
		mov DX, offset mensaje_fin_juego
		mov AH, 09h ; Función 09h: Mostrar un mensaje.
		int 21h ; Llamar a la interrupción 21h para mostrar el mensaje.
		jmp menu 
;;
;; verificar_victoria
;;

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
			mov al, [tablero+si+15h]
			cmp al, ficha_b
			je victoria
			jmp siguiente_celda_vertical
		
        siguiente_celda_vertical:
            inc si
            cmp si, di
            jb verificar_vertical
    
    ; No se encontró ninguna victoria
    ret

victoria:
    mov ah, 09h
    lea dx, mensaje_victoria
    int 21h
    ret

fin:
.EXIT
END