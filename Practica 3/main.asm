.RADIX 16
.MODEL small
.STACK
.DATA
encabezado  db "	Universidad de San Carlos de Guatemala",0a,"	Facultad de Ingenieria",0a,"	Arquitectura de Computadora y Ensambladores 1",0a,"	Seccion ""A""",0a,"	Segundo Semestre 2023",0a,0a,"	Nombre: Steven Josue Gonzalez Monroy",0a,"	Carnet: 201903974",0a,0a,"	Presione 'Enter' para continuar...",0a,"$"
mensaje_reintente db "	Intente nuevamente...",0a,0a,"$"
mensaje_menu db "	Menu de opciones:", 0Dh, 0Ah
             db "		1. Nueva Partida", 0Dh, 0Ah
             db "		2. Cargar Partida", 0Dh, 0Ah
             db "		3. Ayuda", 0Dh, 0Ah
             db "		4. Salir", 0Dh, 0Ah
             db "		Elija una opcion (1-4):",0a,"$"

;;variables para apartado de ayuda
mensaje_db db "Presione 'n' para mostrar las siguientes 20 líneas o 'q' para salir.", 0Dh, "$"
mensaje_error db "No fue posible leer la linea", 0Dh, "$"
mensaje_lectura db "No fue posible leer el archivo", 0Dh, "$"
archivo_db db "CV.TXT", 0
buffer db 255 dup(0)   ; Buffer para almacenar una línea del archivo
buffer_size equ 255
lineas_por_iteracion equ 20

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
		mov AH, 01h
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

        ;;
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

		;;
		mov AH, 01h
		int 21
		;;verifica si la tecla presionada es 1
		cmp AL, 31h
		je menu
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
		mov AH, 3Dh         		; Función 3Dh: Abrir archivo.
		mov AL, 0           		; Modo de apertura (0 = lectura).
		lea DX, archivo_db  		; Nombre del archivo a abrir.
		int 21h             		; Llamar a la interrupción 21h.

		jc error            ; Verificar si hubo un error al abrir el archivo.

		mov bx, ax          ; Guardar el descriptor de archivo en BX.

		; Leer y mostrar líneas del archivo.
		mov cx, lineas_por_iteracion ; Contador para líneas por iteración.
		mov si, 0           ; Inicializar el índice de línea.

leer_linea:
    mov ah, 3Fh         ; Función 3Fh: Leer desde el archivo.
    lea dx, buffer      ; Dirección del buffer.
    mov cx, buffer_size ; Tamaño del buffer.
    mov bx, ax          ; Descriptor de archivo.
    int 21h             ; Llamar a la interrupción 21h para leer desde el archivo.

    jc error_lectura    ; Verificar si hubo un error al leer el archivo.

    ; Mostrar la línea leída.
    mov ah, 09h         ; Función 09h: Mostrar una cadena.
    lea dx, buffer      ; Dirección del buffer.
    int 21h             ; Llamar a la interrupción 21h para mostrar la línea.

    ; Aumentar el índice de línea y verificar si llegamos a 20.
    inc si
    cmp si, 14h
    je esperar_input    ; Si llegamos a 20 líneas, esperar la entrada del usuario.

    jmp leer_linea      ; Continuar leyendo más líneas del archivo.

esperar_input:
    ; Esperar la entrada del usuario ('n' para siguiente, 'q' para salir).
    mov ah, 01h         ; Función 01h: Leer un carácter desde la entrada estándar.
    int 21h             ; Llamar a la interrupción 21h para leer la tecla presionada.

    cmp al, 'n'         ; Comprobar si se presionó 'n' (siguiente).
    jne no_siguiente

    ; Reiniciar el índice de línea y volver a leer líneas.
    mov si, 0
    jmp leer_linea

no_siguiente:
    cmp al, 'q'         ; Comprobar si se presionó 'q' (salir).
    jne esperar_input   ; Si no se presionó 'q', volver a esperar la entrada.

cerrar_archivo:
    ; Cerrar el archivo y salir del programa.
    mov ah, 3Eh         ; Función 3Eh: Cerrar archivo.
    mov bx, bx          ; Descriptor de archivo.
    int 21h             ; Llamar a la interrupción 21h para cerrar el archivo.

error:
    ; Mostrar un mensaje de error si no se pudo abrir el archivo.
    mov ah, 09h         ; Función 09h: Mostrar un mensaje.
    lea dx, mensaje_error  ; Dirección del mensaje de error.
    int 21h             ; Llamar a la interrupción 21h para mostrar el mensaje.
	jmp fin
error_lectura:
    ; Mostrar un mensaje de error si no se pudo leer el archivo.
    mov ah, 09h         ; Función 09h: Mostrar un mensaje.
    lea dx, mensaje_lectura  ; Dirección del mensaje de error.
    int 21h             ; Llamar a la interrupción 21h para mostrar el mensaje.
fin:
.EXIT
END