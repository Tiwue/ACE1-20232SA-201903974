# Manual Técnico

Se desarrolló una calculadora sencilla en forma de aplicacion en consola utilizando programacion a bajo nivel, esta calculadora tiene en cuenta el signo de las operaciones aritméticas, suma, resta, multiplicación y división. Tambien puede realizar el calculo de numeros factoriales y gaurdar operaciones para luego mostrarlas en un reporte en formato HTM

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
Estas variables son necesarias para mostrar mensajes en pantalla, recibir datos del usuario, almacenar resultados de operaciones y almacenar secciones del reporte en html.

```asm
.RADIX 16
.MODEL small
.STACK
.DATA
var_encabezado db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0a, "FACULTAD DE INGENIERIA", 0a, "ESCUELA DE CIENCIAS Y SISTEMAS", 0a, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", 0a, "SECCION B", 0a,0a, "SEGUNDO SEMESTRE 2023", 0a, "Steven Josue Gonzalez Monroy",0a,"201903974",0a,"Practica 4",0a,"$"
var_menu db 0a,0a,"       MENU PRICIPAL",0a,0a,"1. Cargar Archivo",0a,"2. Modo Calculadora",0a,"3. Factorial",0a,"4. Crear Reporte",0a,"5. Salir",0a,"$"

bufferFactorial db 20,00        ;;hay que colocarle el 20h para que reconozca con la funcion 0Ah
                db 20 dup (00)
inputFactorial db 03h DUP(0) ; Almacenar la cadena de entrada
valorHexFactorial db 00        ; Almacenar el valor hexadecimal convertido
errorMessageFactorial db "Entrada no valida, Ingrese un numero hexadecimal de 2 digitos que sea menor a 05", '$'
errorMessageFactorial2 db "Entrada no valida", '$'
tituloFactorial db "		Factorial", 0Ah, 0Dh, '$'
mensajeFactorial db 0ah,"Ingrese un numero: ", '$'
mensaje_operaciones db 0ah, "Operaciones: 0!=1; ", '$'
mensaje_fact1 db "1!=", '$'
mensaje_fact2 db " ; 2!=1*2=", '$'
mensaje_fact3 db " ; 3!=2*3=", '$'
mensaje_fact4 db " ; 4!=6*4=", '$'
str_pytcoma db ";", '$'
str_resultado db 0ah,"Resultado: ", '$'
resultado_factorial1 db 00h
resultado_factorial2 db 00h
resultado_factorial3 db 00h
resultado_factorial4 db 00h
cociente db 00h
residuo db 00h
iterador db 0000h
str_ingrese_numero db 0ah,"Ingrese un numero: ", '$'
str_ingrese_operador db 0ah,"Ingrese un operador: ", '$'
str_ingrese_igual_operador db 0ah,"Ingrese un operador o '=' para finalizar: ", '$'
tituloCalculadora db "		Modo Calculadora", 0Ah, 0Dh, '$'
bufferCalculadora db 20,00        ;;hay que colocarle el 20h para que reconozca con la funcion 0Ah
                db 20 dup (00)
inputCalculadora db 04h DUP(00) ; Almacenar la cadena de entrada
valor1HexCalculadora dw 0000h        ; Almacenar el valor hexadecimal convertido
valor2HexCalculadora dw 0000h       ; Almacenar el valor hexadecimal convertido
operacion_calculadora db 00h       ; Almacenar el valor para saber que operacion hacer en calculadora
resultado dw 0000h    ;Almacenar el resultado acumilado de las operaciones
millares_resultado    db 00h
centenas_resultado    db 00h
decenas_resultado     db 00h
unidades_resultado    db 00h
residuo_resultado     dw 0000h
errorMessageCalculadora db "Entrada no valida.",0a, '$'
contadorOperadores db 00h
bufferOperacionTexto db 3Ch DUP(00)    ;variable para formar la operacion en texto
operacion1 db 3Ch DUP(00)      ;variables para guardar las 10 operaciones
operacion2 db 3Ch DUP(00)
operacion3 db 3Ch DUP(00)
operacion4 db 3Ch DUP(00)
operacion5 db 3Ch DUP(00)
operacion6 db 3Ch DUP(00)
operacion7 db 3Ch DUP(00)
operacion8 db 3Ch DUP(00)
operacion9 db 3Ch DUP(00)
operacion10 db 3Ch DUP(00)
numeroOpGuardadas db 00h
nl       db 0a,"$"
str_Guardar_Op db 0ah, "Desea guardar (S/N): ", '$'
str_max_operaciones db "Se ha alcanzado el maximo de operaciones", '$'
nombre_reporte db "REPORTE.HTM", 0
reporteParte1 db "<style type=""text/css"">table { border-spacing: 0; border-style: solid; border-top-width: 2px; border-right-width: 2px; border-bottom-width: 2px; border-left-width: 2px}"
reporteParte2 db "td {border-style: solid; border-top-width: 1px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 1px}"
reporteParte3 db "th {border-style: solid; border-top-width: 1px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 1px}"
reporteParte4 db "</style><body><h1>Practica 4 Arqui 1 Seccion B</h1><h3>Estudiante: Steven Josue Gonzalez Monroy</h3> <h3>Carnet: 201903974</h3><h3>Fecha: "
reporteParte5 db "</h3><h3>Hora: "
reporteParte6 db "</h3><table><tr><th>Id Operacion</th><th>Operacion</th></tr>"
reporteParte7 db "<tr>"
reporteParte8 db "<td>"
reporteParte9 db "</td>"
reporteParte10 db "</tr>"
handle_reporte dw 0000
msj_reporte_exitoso db 0ah, "Reporte creado exitosamente", '$'
mensaje_error_reporte db "No fue posible generar el reporte", 0a, "$"
iterador_reporte dw 0000h
contador_id_operaciones db 30h
fecha db 10 dup (00) ; dd/mm/aaaa
dia db 00h
dia1 db 00h
dia2 db 00h
mes db 00h
mes1 db 00h
mes2 db 00h
anio dw 0000h
anio1 db 00h
anio2 db 00h
anio3 db 00h
anio4 dw 0000h
slash db '/'
hora db 00h
hora1 db 00h
hora2 db 00h
minuto db 00h
minuto1 db 00h
minuto2 db 00h
dospts db ':'
op db "Op"
```

### Inicio

Con estas secciones podemos limpiar la pantalla, mostrar el encabezado inicial, mostrar el menú principal y reconocer la elección del usuario.

```assembly
.STARTUP
;; LÓGICA DEL PROGRAMA
call limpiar_pantalla
encabezado:
    mov DX, offset var_encabezado
    mov AH, 09h
    int 21
menu:
    mov DX, offset var_menu
	mov AH, 09h
	int 21

	mov AH, 08h
	int 21
	;;verifica si la tecla presionada es 1
	cmp AL, 31h
	je fin
	;;verifica si la tecla presionada es 2
	cmp AL, 32h
	je titulo_calculadora
	;;verifica si la tecla presionada es 3
	cmp AL, 33h
	je titulo_factorial
	;;verifica si la tecla presionada es 4
	cmp AL, 34h
	je generar_reporte
    ;;verifica si la tecla presionada es 4
	cmp AL, 35h
	je fin
    call limpiar_pantalla
	jmp menu
limpiar_pantalla:
    mov ah, 06h    ; Función 06h: Scroll up (borrar pantalla)
    mov al, 0       ; Valor de caracteres para rellenar la pantalla (0 en blanco)
    mov bh, 07h     ; Página de códigos (color de fondo y texto)
    mov ch, 0       ; Fila superior
    mov cl, 0       ; Columna superior
    mov dh, 24      ; Fila inferior (25 líneas en modo texto)
    mov dl, 79      ; Columna inferior (80 columnas en modo texto)
    int 10h         ; Llamar a la interrupción 10h para realizar el desplazamiento de pantalla
    ret
```

### Factorial

Estas etiquetas realizan la solicitud de valores para realizar el calculo de factorial, almacena el valor en variables, realiza el calculo y posteriormente muestra el resultado junto con el procedimiento en pantalla.

```asm
titulo_factorial:

    mov ah, 09h
    lea dx, tituloFactorial
    int 21h

mensaje_factorial:
    ; Imprimir un mensaje de entrada
    mov ah, 09h
    lea dx, mensajeFactorial
    int 21h

    ; Leer la entrada del usuario
    
    mov DX, offset bufferFactorial
    mov AH, 0Ah
    int 21h

; Copiar la entrada del usuario a una variable
    mov DI, offset inputFactorial
    call copiar_cadena_factorial

    mov al, [inputFactorial] ; Obtener el primer dígito que es el tamaño
    cmp al, 02h                   ; Verificar que la entrada sea de 2 dígitos
    jne invalidInput

    ; Convertir la entrada a hexadecimal
    mov si, offset inputFactorial + 1 ; Obtener el primer dígito
    mov ax, 0000h ; Limpiar AX

convert_decenas:
    ; Cargamos el byte actual de la cadena en AL
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL
    inc si 

    cmp al, '0'
    jl invalidInput2 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jle is_digit_decenas ; Si es un dígito entre '0' y '9', procedemos a convertirlo
    cmp al, 'A'
    jl invalidInput2 ; Si es menor que 'A', es un dígito no válido
    cmp al, 'F'
    jg invalidInput2 ; Si es mayor que 'F', es un dígito no válido
    sub al, '1' ; Si es una letra A-F, ajustamos el valor numérico
is_digit_decenas:
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico

    ; Multiplicamos el valor actual en DX por 16 y sumamos el nuevo dígito
    mov bx, 10h ; Cargamos 16 en BX
    mul bx      ; Multiplicamos el valor actual en DX por 16 y guardamos el resultado en AX
    add dx, ax
 
convert_unidades:
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL
    inc si 
    cmp al, '0' ; Convertimos el dígito hexadecimal en AL a su valor numérico
    jl invalidInput2 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jle is_digit_unidades ; Si es un dígito entre '0' y '9', procedemos a convertirlo
    cmp al, 'A'
    jl invalidInput2 ; Si es menor que 'A', es un dígito no válido
    cmp al, 'F'
    jg invalidInput2 ; Si es mayor que 'F', es un dígito no válido
    sub al, '1' ; Si es una letra A-F, ajustamos el valor numérico
is_digit_unidades:
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico

    add dx, ax
    mov [valorHexFactorial], dl ; Guardamos el valor hexadecimal convertido en la variable
    cmp [valorHexFactorial], 00h
    jb invalidInput
    cmp [valorHexFactorial], 04h
    jg invalidInput
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov ch, [valorHexFactorial]
    mov [iterador], ch
    mov di, 0000h
ciclo_factorial:
    inc di 
    call calcular_factorial
    mov ch, [iterador]
    dec ch
    mov [iterador], ch
    cmp ch, 00h
    jg ciclo_factorial

    xor ax, ax  
    xor bx, bx
    xor cx, cx
    xor dx, dx
    
    cmp [valorHexFactorial], 00h
    je mostrar_resultado_factorial0
    cmp [valorHexFactorial], 01h
    je mostrar_resultado_factorial1
    cmp [valorHexFactorial], 02h
    je mostrar_resultado_factorial2
    cmp [valorHexFactorial], 03h
    je mostrar_resultado_factorial3
    jmp mostrar_resultado_factorial4

mostrar_resultado_factorial0:
    mov ah, 09h
    lea dx, mensaje_operaciones
    int 21h
    mov ah, 09h
    lea dx, str_resultado
    int 21h
    mov ah, 02h
    mov dl, '1'
    int 21h
    jmp menu
mostrar_resultado_factorial1:
    mov ah, 09h
    lea dx, mensaje_operaciones
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact1
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial1]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, str_pytcoma
    int 21h
    mov ah, 09h
    lea dx, str_resultado
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial1]
    add dl, 30h
    int 21h
    jmp menu

mostrar_resultado_factorial2:
    mov ah, 09h
    lea dx, mensaje_operaciones
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact1
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial1]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact2
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial2]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, str_pytcoma
    int 21h
    mov ah, 09h
    lea dx, str_resultado
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial2]
    add dl, 30h
    int 21h
    jmp menu

mostrar_resultado_factorial3:
    mov ah, 09h
    lea dx, mensaje_operaciones
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact1
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial1]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact2
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial2]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact3
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial3]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, str_pytcoma
    int 21h
    mov ah, 09h
    lea dx, str_resultado
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial3]
    add dl, 30h
    int 21h
    jmp menu

mostrar_resultado_factorial4:
    mov ah, 09h
    lea dx, mensaje_operaciones
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact1
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial1]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact2
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial2]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact3
    int 21h
    mov ah, 02h
    mov dl, [resultado_factorial3]
    add dl, 30h
    int 21h
    mov ah, 09h
    lea dx, mensaje_fact4
    int 21h
    xor dx, dx    ;limpiamos dx
    xor ax, ax  ;limpiamos ax
    xor bx, bx  ;limpiamos bx
    mov al, [resultado_factorial4]
    mov bx, 0ah     ;divisor 10
    div bx          ;cociente en ax, residuo en dx
    mov [cociente], al
    mov [residuo], dl
    mov ah, 02h
    mov dl, [cociente]
    add dl, 30h
    int 21h
    mov ah, 02h
    mov dl, [residuo]
    add dl, 30h
    int 21h

    mov ah, 09h
    lea dx, str_resultado
    int 21h

    mov ah, 02h
    mov dl, [cociente]
    add dl, 30h
    int 21h
    mov ah, 02h
    mov dl, [residuo]
    add dl, 30h
    int 21h

    jmp menu
 
calcular_factorial:
    mov si, 01h
    mov ax, 01h
factorial_loop:
    mov bx, si
    mul bx      ; multiplicar el resultado parcial por el contador (bx)
    inc si      ; incrementar el contador (si)
    cmp si, di  ; comparar el contador (si) con el número ingresado (di)
    jle factorial_loop ; si el contador es menor o igual al número ingresado, repetir el ciclo
    mov [resultado_factorial1 + di - 1], al  ; guardar el resultado en la posición de memoria correspondiente
    ret

invalidInput:

    mov ah, 09h
    lea dx, nl
    int 21h
    ; Manejar entrada inválida
    mov ah, 09h
    lea dx, errorMessageFactorial
    int 21h
    mov ah, 09h
    lea dx, nl
    int 21h
    jmp mensaje_factorial   ;regresarmos a pedir de nuevo el numero

invalidInput2:

    mov ah, 09h
    lea dx, nl
    int 21h
    ; Manejar entrada inválida
    mov ah, 09h
    lea dx, errorMessageFactorial2
    int 21h
    mov ah, 09h
    lea dx, nl
    int 21h
    ;regresarmos a pedir de nuevo el numero
    jmp mensaje_factorial

;; copiar_cadena - copia una cadena
;;    ENTRADAS: DI -> dirección hacia donde guardar
copiar_cadena_factorial:
		;; DI tengo ^
		mov SI, offset bufferFactorial 	;tomamos la direccion del primer byte del buffer
		inc SI							;pasamos a la segunda posicion del buffer
		mov AL, [SI]					;trasladamos el segundo byte del buffer a AL
		mov [DI], AL					;trasladamos el segundo byte del buffer a DI
		inc SI   ;; moverme a los bytes de la cadena
		inc DI   ;; para guardar esos bytes en el lugar correcto
		;;
		mov CX, 0000  ;; limpiando CX
		mov CL, AL		;;especificamos el tamaño de la cadena para el ciclo de copiado este valor es usado por la instruccion loop
ciclo_copiar_cadena_factorial:
		mov AL, [SI]
		mov [DI], AL
		inc SI
		inc DI
		loop ciclo_copiar_cadena_factorial
		ret
```


### Calculadore
Estas secciones de codigo se encargan de mostrar los mensajes de la calculadora para solicitar datos, almacenarlos e identificar errores.
```asm
;; copiar_cadena - copia una cadena
;;    ENTRADAS: DI -> dirección hacia donde guardar
copiar_cadena_calculadora:
		;; DI tengo ^
		mov SI, offset bufferCalculadora 	;tomamos la direccion del primer byte del buffer
		inc SI							;pasamos a la segunda posicion del buffer
		mov AL, [SI]					;trasladamos el segundo byte del buffer a AL
		mov [DI], AL					;trasladamos el segundo byte del buffer a DI
		inc SI   ;; moverme a los bytes de la cadena
		inc DI   ;; para guardar esos bytes en el lugar correcto
		;;
		mov CX, 0000  ;; limpiando CX
		mov CL, AL		;;especificamos el tamaño de la cadena para el ciclo de copiado este valor es usado por la instruccion loop
        jmp ciclo_copiar_cadena_factorial

titulo_calculadora:
    mov ah, 09h
    lea dx, tituloCalculadora
    int 21h

mensaje1_calculadora:
    mov ah, 09h     ; Imprimir un mensaje de entrada
    lea dx, str_ingrese_numero
    int 21h
    
    mov DX, offset bufferCalculadora
    mov AH, 0Ah
    int 21h

    mov DI, offset inputCalculadora     ; Copiar la entrada del usuario a una variable
    call copiar_cadena_calculadora
    xor dx, dx
    mov al, [inputCalculadora] ; Obtener el primer dígito que es el tamaño
    cmp al, 00h  ;si el tamano es 0 entonces es un error
    je invalidInput3
    cmp al, 03h                   ; Verificar que la entrada sea de maximo 3 dígitos
    jg invalidInput3    ;si el tamano es mayor a 3 entonces es un error

    mov al, [inputCalculadora + 1] ; Obtener el primer dígito que es el tamaño
    cmp al, 2Dh    ;validar si el primier digito es un simbolo negativo
    je convertir_valor1_calculadora_negativo

    mov al, [inputCalculadora]
    cmp al, 03h  ;si la entrada es de 3 digitos entonces es un error porque el numero positivo maximo es de 2 digitos
    je invalidInput3
    mov si, offset inputCalculadora + 1 ; Obtener el primer dígito
    cmp al, 01h    ;si el tamano es 1 entonces es un numero de 1 digito
    je convert_units_v1_calculadora
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL
    inc si 
    cmp al, '0'
    jl invalidInput3 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput3 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    ; Multiplicamos el valor actual en DX por 10 y sumamos el nuevo dígito
    mov bx, 0Ah ; Cargamos 10 en BX
    mul bx      ; Multiplicamos el valor actual en DX por 10 y guardamos el resultado en AX
    add dx, ax
 
convert_units_v1_calculadora:
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL 
    cmp al, '0' ; Convertimos el dígito hexadecimal en AL a su valor numérico
    jl invalidInput3 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput3 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    add dx, ax
    mov [valor1HexCalculadora], dx
    mov al, [contadorOperadores] ; Oobtenemos el contador de operadores
    add al, 01h                  ; le incrementamos 1
    mov [contadorOperadores], al    ; guardamos el contador de operadores
    mov DI, offset bufferOperacionTexto
    call copiar_cadena_Operacion
    jmp mensaje2_calculadora

convertir_valor1_calculadora_negativo:
    mov al, [inputCalculadora]
    mov si, offset inputCalculadora + 2 ; Obtener el primer dígito
    cmp al, 01h    ;si el tamano es 1 entonces es un error porque solo viene el simbolo menos
    je invalidInput3
    cmp al, 02h    ;si el tamano es 2 entonces es un numero negativo de 1 digito
    je convert_units_v1_negativo_calculadora
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL
    inc si 
    cmp al, '0'
    jl invalidInput3 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput3 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    ; Multiplicamos el valor actual en DX por 10 y sumamos el nuevo dígito
    mov bx, 0Ah ; Cargamos 10 en BX
    mul bx      ; Multiplicamos el valor actual en DX por 10 y guardamos el resultado en AX
    add dx, ax
 
convert_units_v1_negativo_calculadora:
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL 
    cmp al, '0' ; Convertimos el dígito hexadecimal en AL a su valor numérico
    jl invalidInput3 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput3 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    add dx, ax
    neg dx
    mov [valor1HexCalculadora], dx

    mov al, [contadorOperadores]    ; Oobtenemos el contador de operadores
    add al, 01h                     ; le incrementamos 1
    mov [contadorOperadores], al    ; guardamos el contador de operadores
    mov DI, offset bufferOperacionTexto
    call copiar_cadena_Operacion

mensaje2_calculadora:

    mov ah, 09h     ; Imprimir un mensaje de entrada
    lea dx, str_ingrese_operador
    int 21h

    mov DX, offset bufferCalculadora
    mov AH, 0Ah
    int 21h

    mov DI, offset inputCalculadora     ; Copiar la entrada del usuario a una variable
    call copiar_cadena_calculadora
    xor dx, dx
    mov al, [inputCalculadora] ; Obtener el primer dígito que es el tamaño
    cmp al, 00h  ;si el tamano es 0 entonces es un error
    je invalidInput4
    cmp al, 01h                   ; Verificar que la entrada sea de maximo 1 dígitos
    jg invalidInput4   ;si el tamano es mayor a 1 entonces es un error

    mov al, [inputCalculadora + 1] ; Obtener el primer dígito que es el tamaño
    cmp al, 2Dh    ;validar si el primier digito es un simbolo negativo
    je setResta 
    cmp al, 2Bh   ;validar si el primier digito es un simbolo positivo
    je setSuma
    cmp al, 2Ah   ;validar si el primier digito es un simbolo multiplicacion
    je setMultiplicacion
    cmp al, 2Fh   ;validar si el primier digito es un simbolo division
    je setDivision
    jmp invalidInput4

setSuma:
    mov [operacion_calculadora], 01h
    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], '+'
    jmp mensaje3_calculadora
setResta:
    mov [operacion_calculadora], 02h
    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], '-'
    jmp mensaje3_calculadora
setMultiplicacion:
    mov [operacion_calculadora], 03h
    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], '*'
    jmp mensaje3_calculadora
setDivision:
    mov [operacion_calculadora], 04h
    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], '/'
    jmp mensaje3_calculadora

mensaje3_calculadora:
    mov ah, 09h     ; Imprimir un mensaje de entrada
    lea dx, str_ingrese_numero
    int 21h
    
    mov DX, offset bufferCalculadora
    mov AH, 0Ah
    int 21h

    mov DI, offset inputCalculadora     ; Copiar la entrada del usuario a una variable
    call copiar_cadena_calculadora
    xor dx, dx
    mov al, [inputCalculadora] ; Obtener el primer dígito que es el tamaño
    cmp al, 00h  ;si el tamano es 0 entonces es un error
    je invalidInput5
    cmp al, 03h                   ; Verificar que la entrada sea de maximo 3 dígitos
    jg invalidInput5    ;si el tamano es mayor a 3 entonces es un error

    mov al, [inputCalculadora + 1] ; Obtener el primer dígito que es el tamaño
    cmp al, 2Dh    ;validar si el primier digito es un simbolo negativo
    je convertir_valor2_calculadora_negativo

    mov al, [inputCalculadora]
    cmp al, 03h  ;si la entrada es de 3 digitos entonces es un error porque el numero positivo maximo es de 2 digitos
    je invalidInput5
    mov si, offset inputCalculadora + 1 ; Obtener el primer dígito
    cmp al, 01h    ;si el tamano es 1 entonces es un numero de 1 digito
    je convert_units_v2_calculadora
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL
    inc si 
    cmp al, '0'
    jl invalidInput5 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput5 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    ; Multiplicamos el valor actual en DX por 10 y sumamos el nuevo dígito
    mov bx, 0Ah ; Cargamos 10 en BX
    mul bx      ; Multiplicamos el valor actual en DX por 10 y guardamos el resultado en AX
    add dx, ax
 
convert_units_v2_calculadora:
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL 
    cmp al, '0' ; Convertimos el dígito hexadecimal en AL a su valor numérico
    jl invalidInput5 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput5 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    add dx, ax
    mov [valor2HexCalculadora], dx
    mov al, [contadorOperadores]    ; Oobtenemos el contador de operadores
    add al, 01h                     ; le incrementamos 1
    mov [contadorOperadores], al    ; guardamos el contador de operadores
    mov DI, offset bufferOperacionTexto
    call copiar_cadena_Operacion
    jmp calcular

convertir_valor2_calculadora_negativo:
    mov al, [inputCalculadora]
    mov si, offset inputCalculadora + 2 ; Obtener el primer dígito
    cmp al, 01h    ;si el tamano es 1 entonces es un error porque solo viene el simbolo menos
    je invalidInput5
    cmp al, 02h    ;si el tamano es 2 entonces es un numero negativo de 1 digito
    je convert_units_v2_negativo_calculadora
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL
    inc si 
    cmp al, '0'
    jl invalidInput5 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput5 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    ; Multiplicamos el valor actual en DX por 10 y sumamos el nuevo dígito
    mov bx, 0Ah ; Cargamos 10 en BX
    mul bx      ; Multiplicamos el valor actual en DX por 10 y guardamos el resultado en AX
    add dx, ax
 
convert_units_v2_negativo_calculadora:
    mov ax, 0000h ; Limpiar AX
    mov al, [si]   ; Carga el byte de memoria en la dirección apuntada por SI en AL 
    cmp al, '0' ; Convertimos el dígito hexadecimal en AL a su valor numérico
    jl invalidInput5 ; Si es menor que '0', es un dígito no válido
    cmp al, '9'
    jg invalidInput5 ; Si es mayor que '9', es un dígito no válido
    sub al, '0' ; Convertimos el dígito ASCII en valor numérico
    add dx, ax
    neg dx
    mov [valor2HexCalculadora], dx
    mov al, [contadorOperadores]    ; Oobtenemos el contador de operadores
    add al, 01h                     ; le incrementamos 1
    mov [contadorOperadores], al    ; guardamos el contador de operadores
    mov DI, offset bufferOperacionTexto
    call copiar_cadena_Operacion
```


### Calculos
Estas secciones se encargan de realizar el calculo segun el valor de la operacion que se desea realizar y almacenan el resultado, luego saltan a la sección para recibir una siguiente operación, verifican si se debe mostrar el resultado o continuar con otra operación.
```ASM
calcular:
    mov al, [operacion_calculadora]
    cmp al, 01h     ;si es 1 entonces es suma
    je suma
    cmp al, 02h     ;si es 2 entonces es resta
    je resta
    cmp al, 03h     ;si es 3 entonces es multiplicacion
    je multiplicacion
    jmp division

suma:
    mov ax, [valor1HexCalculadora]
    mov bx, [valor2HexCalculadora]
    add ax, bx
    mov [resultado], ax
    mov [valor1HexCalculadora], ax
    mov ax, 0000h
    mov [valor2HexCalculadora], ax
    mov [operacion_calculadora], al
    jmp siguiente_operacion

resta:
    mov ax, [valor1HexCalculadora]
    mov bx, [valor2HexCalculadora]
    sub ax, bx
    mov [resultado], ax
    mov [valor1HexCalculadora], ax
    mov ax, 0000h
    mov [valor2HexCalculadora], ax
    mov [operacion_calculadora], al
    jmp siguiente_operacion

multiplicacion:
    mov ax, [valor1HexCalculadora]
    mov bx, [valor2HexCalculadora]
    imul bx
    mov [resultado], ax
    mov [valor1HexCalculadora], ax
    mov ax, 0000h
    mov [valor2HexCalculadora], ax
    mov [operacion_calculadora], al
    jmp siguiente_operacion

division:
    mov ax, [valor1HexCalculadora]
    mov bx, [valor2HexCalculadora]
    xor dx, dx
    cwd     ;extendemos el signo de ax a dx
    idiv bx
    mov [resultado], ax
    mov [valor1HexCalculadora], ax
    mov ax, 0000h
    mov [valor2HexCalculadora], ax
    mov [operacion_calculadora], al
    jmp siguiente_operacion

siguiente_operacion:

    mov al, [contadorOperadores]
    cmp al, 0Ah
    je mostrar_resultado_calculadora

    mov ah, 09h
    lea dx, str_ingrese_igual_operador
    int 21h

    mov DX, offset bufferCalculadora
    mov AH, 0Ah
    int 21h

    mov DI, offset inputCalculadora     ; Copiar la entrada del usuario a una variable
    call copiar_cadena_calculadora
    xor dx, dx
    mov al, [inputCalculadora] ; Obtener el primer dígito que es el tamaño
    cmp al, 00h  ;si el tamano es 0 entonces es un error
    je invalidInput6
    cmp al, 01h                   ; Verificar que la entrada sea de maximo 1 dígitos
    jg invalidInput6   ;si el tamano es mayor a 1 entonces es un error

    mov al, [inputCalculadora + 1] ; Obtener el primer dígito que es el tamaño
    cmp al, 2Dh    ;validar si el primier digito es un simbolo negativo
    je setResta 
    cmp al, 2Bh   ;validar si el primier digito es un simbolo positivo
    je setSuma
    cmp al, 2Ah   ;validar si el primier digito es un simbolo multiplicacion
    je setMultiplicacion
    cmp al, 2Fh   ;validar si el primier digito es un simbolo division
    je setDivision
    cmp al, 3Dh   ;validar si el primier digito es un simbolo igual
    je mostrar_resultado_calculadora
    jmp invalidInput6
```
### Resultado

Estas secciones convierten las variables con el resultado de las operaciones a sus equivalentes en decimal y muestran en pantalla los resultados asi como el procedimiento.

```asm
mostrar_resultado_calculadora:
    mov ah, 09h
    lea dx, str_resultado
    int 21h

    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], '='

    mov [contadorOperadores], 00h
    mov ax, [resultado]
    cmp ax, 0000h
    js mostrar_resultado_calculadora_negativo

    mov ax, [resultado]
    ;dividimos el resultado entre 1000
    xor dx, dx    ;limpiamos dx
    xor bx, bx  ;limpiamos bx
    xor cx, cx  ;limpiamos cx
    mov cx, 3E8h
    div cx          ;cociente en ax, residuo en dx
    mov [millares_resultado], al
    mov [residuo_resultado], dx
    ;dividimos el resultado entre 100
    xor dx, dx    ;limpiamos dx
    xor bx, bx  ;limpiamos bx
    xor cx, cx  ;limpiamos cx
    mov ax, [residuo_resultado]
    mov cx, 64h
    div cx          ;cociente en ax, residuo en dx
    mov [centenas_resultado], al
    mov [residuo_resultado], DX
    ;dividimos el resultado entre 10
    xor dx, dx    ;limpiamos dx
    xor bx, bx  ;limpiamos bx
    xor cx, cx  ;limpiamos cx
    mov ax, [residuo_resultado]
    mov cx, 0Ah
    div cx          ;cociente en ax, residuo en dx
    mov [decenas_resultado], al
    mov [residuo_resultado], DX

mostrar_millares:
    
    mov al, [millares_resultado]
    cmp al, 00h
    je mostrar_centenas
    mov ah, 02h
    mov dl, [millares_resultado]
    add dl, 30h
    int 21h

    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], dl

mostrar_centenas:
    mov al, [millares_resultado]
    cmp al, 00h
    jg continuarCentenas
    mov al, [centenas_resultado]
    cmp al, 00h
    je mostrar_decenas
continuarCentenas:
    mov ah, 02h
    mov dl, [centenas_resultado]
    add dl, 30h
    int 21h

    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], dl

mostrar_decenas:
    mov al, [millares_resultado]
    cmp al, 00h
    jg continuarDecenas
    mov al, [centenas_resultado]
    cmp al, 00h
    jg continuarDecenas
    mov al, [decenas_resultado]
    cmp al, 00h
    je mostrar_unidades
continuarDecenas:
    mov ah, 02h
    mov dl, [decenas_resultado]
    add dl, 30h
    int 21h

    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], dl

mostrar_unidades:
    mov ah, 02h
    mov dx, [residuo_resultado]
    add dl, 30h
    int 21h

    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], dl

    jmp mensaje_guardar_op
```

### Mensaje de Error

estas secciones se encargan de mostrar mensajes de error al momento de ingresar valores erroneos para la calculadora.

```asm
invalidInput3:
    mov ah, 09h
    lea dx, nl
    int 21h
    ; Manejar entrada inválida
    mov ah, 09h
    lea dx, errorMessageCalculadora
    int 21h
    mov ah, 09h
    lea dx, nl
    int 21h
    jmp mensaje1_calculadora   ;regresarmos a pedir de nuevo el numero

invalidInput4:
    mov ah, 09h
    lea dx, nl
    int 21h
    ; Manejar entrada inválida
    mov ah, 09h
    lea dx, errorMessageCalculadora
    int 21h
    mov ah, 09h
    lea dx, nl
    int 21h
    jmp mensaje2_calculadora   ;regresarmos a pedir de nuevo el numero

invalidInput5:
    mov ah, 09h
    lea dx, nl
    int 21h
    ; Manejar entrada inválida
    mov ah, 09h
    lea dx, errorMessageCalculadora
    int 21h
    mov ah, 09h
    lea dx, nl
    int 21h
    jmp mensaje3_calculadora   ;regresarmos a pedir de nuevo el numero

invalidInput6:
    mov ah, 09h
    lea dx, nl
    int 21h
    ; Manejar entrada inválida
    mov ah, 09h
    lea dx, errorMessageCalculadora
    int 21h
    mov ah, 09h
    lea dx, nl
    int 21h
    jmp siguiente_operacion   ;regresarmos a pedir de nuevo el numero
```

### Resultado negativo

Las siguientes secciones muestran el resultado en decimal negativo, mostrando el signo y convirtiendolo en positivo para posteriormente mostrarlo en pantalla.

```asm
mostrar_resultado_calculadora_negativo:

    mov ah, 02h
    mov dl, '-'
    int 21h

    mov al, [bufferOperacionTexto]
    inc al
    mov [bufferOperacionTexto], al
    mov bl, [bufferOperacionTexto]
    mov bh, 00h
    mov [bufferOperacionTexto + bx], '-'

    mov ax, [resultado]
    neg ax
    ;dividimos el resultado entre 1000
    xor dx, dx    ;limpiamos dx
    xor bx, bx  ;limpiamos bx
    xor cx, cx  ;limpiamos cx
    mov cx, 3E8h
    div cx          ;cociente en ax, residuo en dx
    mov [millares_resultado], al
    mov [residuo_resultado], dx
    ;dividimos el resultado entre 100
    xor dx, dx    ;limpiamos dx
    xor bx, bx  ;limpiamos bx
    xor cx, cx  ;limpiamos cx
    mov ax, [residuo_resultado]
    mov cx, 64h
    div cx          ;cociente en ax, residuo en dx
    mov [centenas_resultado], al
    mov [residuo_resultado], DX
    ;dividimos el resultado entre 10
    xor dx, dx    ;limpiamos dx
    xor bx, bx  ;limpiamos bx
    xor cx, cx  ;limpiamos cx
    mov ax, [residuo_resultado]
    mov cx, 0Ah
    div cx          ;cociente en ax, residuo en dx
    mov [decenas_resultado], al
    mov [residuo_resultado], DX
    jmp mostrar_millares
```


### Almacenar operaciónm

Secciones para almacenar la operación en texto en variables para mostrarlas en en reporte.

```asm
;; copiar_cadena - copia una cadena
;;    ENTRADAS: DI -> dirección hacia donde guardar
copiar_cadena_Operacion:
		;; DI tengo ^
        
		mov SI, offset bufferCalculadora 	;tomamos la direccion del primer byte del buffer
		inc SI							;pasamos a la segunda posicion del buffer
		mov AL, [SI]					;trasladamos el segundo byte del buffer a AL
		mov BL, [DI]                    ;obtenemos la cantidad de bytes en la variable
        add AL, BL                     ;sumamos la cantidad de bytes en el buffer a la variable
        mov [DI], AL					;trasladamos el segundo byte del buffer a DI
        mov AL, [SI]
		inc SI   ;; moverme a los bytes de la cadena
		inc DI   ;; para guardar esos bytes en el lugar correcto
        mov BH, 00h
        add DI, BX
		;;
		mov CX, 0000  ;; limpiando CX
		mov CL, AL		;;especificamos el tamaño de la cadena para el ciclo de copiado este valor es usado por la instruccion loop
ciclo_copiar_cadena_operacion:
		mov AL, [SI]
		mov [DI], AL
		inc SI
		inc DI
		loop ciclo_copiar_cadena_operacion
		ret
```
### Mensaje guardado

Estas secciones de codigo consultan al usuario si desea guardar la operación, verifica la alección del usuario y verifica el numero y la posición de la operación que se va a guardar.

```asm
mensaje_guardar_op:
    mov ah, 09h
    lea dx, str_guardar_op
    int 21h

    mov AH, 08h
	int 21h 

    cmp al, 's'
    je guardar_op
    cmp al, 'n'
    je noguardar_op
    cmp al, 'S'
    je guardar_op
    cmp al, 'N'
    je noguardar_op
    jmp mensaje_guardar_op
noguardar_op:
    mov [bufferOperacionTexto], 00h
    jmp menu

guardar_op:
        mov ah, [numeroOpGuardadas]
        cmp ah, 0Ah
        jge mensaje_max_op_guardadas
        mov ah, 00h
        mov al, [numeroOpGuardadas]
        mov bx, 003Ch
        mul bx
        xor bx, bx
        mov bx, offset operacion1
        add bx, ax 
        mov DI, bx   ; direccion de memoria donde se guardara la operacion
		;; DI tengo ^
		mov SI, offset bufferOperacionTexto 	;tomamos la direccion del primer byte del buffer
		mov AL, [SI]					;trasladamos el segundo byte del buffer a AL
		mov [DI], AL					;trasladamos el segundo byte del buffer a DI
        inc SI   ;; moverme a los bytes de la cadena
		inc DI   ;; para guardar esos bytes en el lugar correcto
		;;
		mov CX, 0000  ;; limpiando CX
		mov CL, AL		;;especificamos el tamaño de la cadena para el ciclo de copiado este valor es usado por la instruccion loop
ciclo_guardar_cadena_operacion:
		mov AL, [SI]
		mov [DI], AL
		inc SI
		inc DI
		loop ciclo_guardar_cadena_operacion
        mov al, [numeroOpGuardadas]
        inc al
        mov [numeroOpGuardadas], al
        mov [bufferOperacionTexto], 00h
		jmp menu
```

### Mensaje de error por maximo de operaciones almacenadas

Bloque para mostrar mensaje de error al intentar guardar mas de 10 operaciónes para el reporte

```asm
mensaje_max_op_guardadas:
    mov ah, 09h
    lea dx, str_max_operaciones
    int 21h
    jmp menu
```

### Generar reporte
Esta subrutina permite generar el reporte con las operaciones gaurdadas por el usuario, asi como mostrar la fecha y la hora en que se genera el reporte.

```asm
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
	mov cx, 00A8h     	; Número de bytes a escribir
	mov dx, offset reporteParte1 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 007Ah    	; Número de bytes a escribir
	mov dx, offset reporteParte2 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 007Ah      	; Número de bytes a escribir
	mov dx, offset reporteParte3 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
	mov bx, [handle_reporte] ; Descriptor de archivo
	mov cx, 008Ah     	; Número de bytes a escribir
	mov dx, offset reporteParte4 		; Dirección del buffer
	int 21h             ; Llamar a la interrupción 21h

    mov ah, 2Ah       ; Función 2Ah de la interrupción 21h (obtener la fecha)
    int 21h
    
    mov [dia], dl
    mov [mes], dh
    mov [anio], cx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov al, [dia]
    mov cx, 0ah
    div cx

    add al, '0'
    add dl, '0'
    mov [dia1], al
    mov [dia2], dl
    
    
    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset dia1 		; Dirección del buffer
    int 21h             ; Llamar a la interrupción 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset dia2 		; Dirección del buffer
    int 21h             ; Llamar a la interrupción 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset slash 		; Dirección del buffer
    int 21h             ; Llamar a la interrupción 21h

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov al, [mes]
    mov cx, 0ah
    div cx

    add al, '0'
    add dl, '0'
    mov [mes1], al
    mov [mes2], dl
    
    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset mes1 		; Dirección del buffer
    int 21h   

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset mes2 		; Dirección del buffer
    int 21h   

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset slash 		; Dirección del buffer
    int 21h             ; Llamar a la interrupción 21h

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov ax, [anio]
    mov cx, 03E8h
    div cx

    add al, '0'
    mov [anio1], al
    mov [anio4], dx

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov ax, [anio4]
    mov cx, 64h
    div cx

    add al, '0'
    mov [anio2], al
    mov [anio4], DX

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov ax, [anio4]
    mov cx, 0Ah
    div cx

    add al, '0'
    add dl, '0'
    mov [anio3], al
    mov [anio4], Dx

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset anio1 		; Dirección del buffer
    int 21h  

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset anio2		; Dirección del buffer
    int 21h  

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset anio3		; Dirección del buffer
    int 21h  

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 0002h     	; Número de bytes a escribir
    mov dx, offset anio4 		; Dirección del buffer
    int 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 000Fh     	; Número de bytes a escribir
    mov dx, offset reporteParte5 		; Dirección del buffer
    int 21h

    mov ah, 2Ch     ; Función 2Ch de la interrupción 21h (obtener la hora)
    int 21h

    mov [hora], ch
    mov [minuto], cl

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov al, [hora]
    mov cx, 0ah
    div cx

    add al, '0'
    add dl, '0'
    mov [hora1], al
    mov [hora2], dl

    xor ax, ax
    xor cx, cx
    xor dx, dx
    mov al, [minuto]
    mov cx, 0ah
    div cx

    add al, '0'
    add dl, '0'
    mov [minuto1], al
    mov [minuto2], dl

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte]    ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset hora1 		; Dirección del buffer
    int 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte]    ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset hora2 		; Dirección del buffer
    int 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte]    ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset dospts 		; Dirección del buffer
    int 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte]    ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset minuto1 		; Dirección del buffer
    int 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte]    ; Descriptor de archivo
    mov cx, 0001h     	; Número de bytes a escribir
    mov dx, offset minuto2 		; Dirección del buffer
    int 21h

    mov ah, 40h         ; Función 40h - Escribir en archivo
    mov bx, [handle_reporte] ; Descriptor de archivo
    mov cx, 3Ch     	; Número de bytes a escribir
    mov dx, offset reporteParte6 		; Dirección del buffer
    int 21h

ciclo_generar_reporte_operaciones:

    mov cx, [iterador_reporte] ;validamos que el iterador no sea mayor a 10 operaciones
    cmp cx, 021Ch
    jg cerrar_reporte ;si es mayor entonces terminamos de generar el reporte
    mov DI, offset operacion1
    add DI, cx
    mov al, [DI] ;obtenemos el primer byte de la operacion y validamos que la cantidad de bytes sea mayor a 0
    cmp al, 00h
    je cerrar_reporte

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0004h
    mov dx, offset reporteParte7
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0004h
    mov dx, offset reporteParte8
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0002h
    mov dx, offset op
    int 21h

    mov al, [contador_id_operaciones]
    add al, 01h
    mov [contador_id_operaciones], al
    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0001h
    mov dx, offset contador_id_operaciones
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0005h
    mov dx, offset reporteParte9
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0004h
    mov dx, offset reporteParte8
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 3Ah
    inc DI
    mov dx, DI
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0005h
    mov dx, offset reporteParte9
    int 21h

    mov ah, 40h
    mov bx, [handle_reporte]
    mov cx, 0005h
    mov dx, offset reporteParte10
    int 21h
    
    mov cx, [iterador_reporte]
    add cx, 3Ch
    mov [iterador_reporte], cx

    jmp ciclo_generar_reporte_operaciones


cerrar_reporte:

	; Cerrar el archivo
    mov ah, 3Eh         ; Función 3Eh - Cerrar archivo
    mov bx, [handle_reporte]    ; Manejador del archivo
    int 21h             ; Llamar a la interrupción 21h
    
    mov ah, 09h
    lea dx, msj_reporte_exitoso
    int 21h

    mov cx, 0000h
    mov [iterador_reporte], cx
    mov cl, 30h
    mov [contador_id_operaciones], cl

    jmp menu

error_reporte:
	mov ah, 09h
	lea dx, mensaje_error_reporte
	int 21h
	jmp menu
```

