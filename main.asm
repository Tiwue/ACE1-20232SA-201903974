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
		mov AH, 08h
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

; Macros para verificar si un carácter es alfanumérico, un dígito o un símbolo de puntuación


fin:
.EXIT
END