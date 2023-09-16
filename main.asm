.RADIX 16
.MODEL small
.STACK
.DATA
encabezado  db "Universidad de San Carlos de Guatemala",0a,"Facultad de Ingenieria",0a,"Arquitectura de Computadora y Ensambladores 1",0a,"Seccion ""A""",0a,"Segundo Semestre 2023",0a,0a,"Nombre: Steven Josue Gonzalez Monroy",0a,"Carnet: 201903974",0a,0a,"Presione 'Enter' para continuar...",0a,"$"
mensaje_1 db "SI PRESIONASTE ENTER",0a,"$"
mensaje_2 db "NO PRESIONASTE ENTER",0a,"$"
aaaaa db 20
adios db 11 
arreglo db 1,2,3,4,5
.CODE
.STARTUP
;; LÓGICA DEL PROGRAMA
main:
    mov ah, 06    ; Función 06h: Scroll up (borrar pantalla)
    mov al, 0       ; Valor de caracteres para rellenar la pantalla (0 en blanco)
    mov bh, 07h     ; Página de códigos (color de fondo y texto)
    mov ch, 0       ; Fila superior
    mov cl, 0       ; Columna superior
    mov dh, 24      ; Fila inferior (25 líneas en modo texto)
    mov dl, 79      ; Columna inferior (80 columnas en modo texto)
    int 10h         ; Llamar a la interrupción 10h para realizar el desplazamiento de pantalla

principio:
		mov DX, offset encabezado
		mov AH, 09h
		int 21
		;;
		mov AH, 01h
		int 21
		;;verifica si la tecla presionada es enter
		cmp AL, 0Dh
		;; se modificó el registro de banderas
		je si_se_presiono
		jmp no_se_presiono
no_se_presiono:
		mov DX, offset mensaje_2
		mov AH, 09h
		int 21

        jmp fin
si_se_presiono:
        mov DX, offset mensaje_1
		mov AH, 09h
		int 21
		jmp principio
fin:
.EXIT
END