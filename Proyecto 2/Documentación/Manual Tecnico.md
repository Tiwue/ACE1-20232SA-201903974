# Manual Técnico

Se desarrolló un juego similar a crossy road, que consiste en atravesar una calle de 21 carriles esquivando vehíulos de diferentes tamaños, para esto se utilizó el modo video 13h del lenguaje ensamblador.

# Proyecto 2

## Requisitos

Para poder desarrollar esta proyecto y para realizar modificaciones futuras es necesaria la instalación de los siguientes recursos:

1. DosBox 
    - Para emular el sistema operativo DOS o MS-DOS

2. MASM 611
    - Para compilar el código

3. IDE/Editor de Código
    - Para realizar las modificaciones al código

## Código

Todo el código se encuentra dentro de un unico archivo: P2.asm

### Variables Globales
Estas variables son necesarias para mostrar mensajes en pantalla, recibir datos del usuario.

```asm
JUGADOR_CARRIL equ 01
JUGADOR_ACERA  equ 02
ACERA          equ 03
CARRIL         equ 04
CARRO_DERECHA  equ 05
CARRO_IZQUIERDA equ 06
BUS1_DERECHA	equ 07
BUS2_DERECHA	equ 08
BUS1_IZQUIERDA	equ 09
BUS2_IZQUIERDA	equ 0ah
CAMION1_DERECHA	equ 0bh
CAMION2_DERECHA	equ 0ch
CAMION3_DERECHA	equ 0eh
CAMION1_IZQUIERDA	equ 0fh
CAMION2_IZQUIERDA	equ 10h
CAMION3_IZQUIERDA	equ 11h

USUARIO_NORMAL         equ 01
USUARIO_ADMIN          equ 02
USUARIO_ADMIN_ORIGINAL equ 03

TAM_NOMBRE equ 14
TAM_CONTRA equ 19

NO_BLOQUEADO equ 00
BLOQUEADO    equ 01
.MODEL small
.RADIX 16
.STACK
.DATA
vidas    db "O  O  O$"
izq db "izquieda$"
der	db "derecha$"
arr db "arriba$"
abj db "abajo$"
x_elemento dw 0000
y_elemento dw 0000

coordenadas_jugador dw 1714h
coordenada_actual   dw 0000

sprite_jugador 	db 00, 00, 0a, 0a, 0E, 0E, 2B, 00 
               	db 00, 1d, 0a, 0E, 58, 0E, 0E, 2B 
               	db 02, 1d, 58, 0E, 00, 58, 00, 00 
               	db 00, 1d, 00, 58, 58, 58, 58, 00 
               	db 00, 1d, 0a, 0a, 58, 02, 00, 1d 
               	db 36, 36, 36, 06, 2a, 06, 02, 1d 
               	db 00, 58, 02, 0a, 0a, 02, 00, 1d 
               	db 1f, 1f, 06, 00, 1f, 06, 00, 00 

sprite_jugador_carril 	db 13, 13, 0a, 0a, 0E, 0E, 2B, 13 
               		  	db 13, 1d, 0a, 0E, 58, 0E, 0E, 2B 
               			db 02, 1d, 58, 0E, 00, 58, 00, 13 
               			db 13, 1d, 13, 58, 58, 58, 58, 13 
               			db 13, 1d, 0a, 0a, 58, 02, 13, 1d 
               			db 36, 36, 36, 06, 2a, 06, 02, 1d 
               			db 13, 58, 02, 0a, 0a, 02, 13, 1d 
               			db 1f, 1f, 06, 13, 1f, 06, 13, 13 

sprite_jugador_acera	db 17, 17, 0a, 0a, 0E, 0E, 2B, 17 
               		  	db 17, 1d, 0a, 0E, 58, 0E, 0E, 2B 
               			db 02, 1d, 58, 0E, 00, 58, 00, 17 
               			db 17, 1d, 17, 58, 58, 58, 58, 17 
               			db 17, 1d, 0a, 0a, 58, 02, 17, 1d 
               			db 36, 36, 36, 06, 2a, 06, 02, 1d 
               			db 17, 58, 02, 0a, 0a, 02, 17, 1d 
               			db 1f, 1f, 06, 17, 1f, 06, 17, 17

sprite_carril  db 13, 13, 13, 13, 13, 13, 13, 13 
               db 13, 13, 13, 13, 13, 13, 13, 13 
               db 13, 13, 13, 13, 13, 13, 13, 13 
               db 13, 13, 13, 13, 13, 13, 13, 13 
               db 13, 13, 13, 13, 13, 13, 13, 13 
               db 13, 13, 13, 13, 13, 13, 13, 13 
               db 13, 13, 13, 13, 13, 13, 13, 13 
               db 1f, 1f, 13, 13, 1f, 1f, 13, 13 

sprite_banqueta db 17, 17, 17, 17, 17, 17, 17, 17 
                db 17, 17, 17, 1a, 17, 17, 17, 17 
                db 17, 17, 17, 1a, 17, 17, 17, 17 
                db 17, 17, 17, 1a, 17, 17, 17, 17 
                db 17, 17, 17, 1a, 17, 17, 17, 17 
                db 17, 17, 17, 1a, 17, 17, 17, 17 
                db 17, 17, 17, 1a, 17, 17, 17, 17 
                db 17, 17, 17, 17, 17, 17, 17, 17

sprite_carro	db 13, 00, 00, 13, 13, 00, 00, 13
				db 36, 36, 36, 36, 36, 36, 36, 36
				db 0e, 36, 4Bh, 36, 36, 4Bh, 36, 0e
				db 36, 36, 4Bh, 36, 36, 4Bh, 36, 36
				db 36, 36, 4Bh, 36, 36, 4Bh, 36, 36
				db 0e, 36, 4Bh, 36, 36, 4Bh, 36, 0e
				db 36, 36, 36, 36, 36, 36, 36, 36
				db 0f, 00, 00, 13, 0f, 00, 00, 13

sprite_bus_1	db 13, 13, 13, 00, 00, 00, 13, 13
				db 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 0e, 2eh, 4Bh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 2eh, 2eh, 4Bh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 2eh, 2eh, 4Bh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 0e, 2eh, 4Bh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 0f, 0f, 13, 00, 00, 00, 13, 13

sprite_bus_2	db 13, 13, 13, 00, 00, 00, 13, 13
				db 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 2eh, 2eh, 2eh, 2eh, 2eh, 4Bh, 2eh, 0e
				db 2eh, 2eh, 2eh, 2eh, 2eh, 4Bh, 2eh, 2eh
				db 2eh, 2eh, 2eh, 2eh, 2eh, 4Bh, 2eh, 2eh
				db 2eh, 2eh, 2eh, 2eh, 2eh, 4Bh, 2eh, 0e
				db 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh, 2eh
				db 0f, 0f, 13, 00, 00, 00, 13, 13

sprite_camion_1	db 13, 13, 13, 13, 00, 00, 00, 13
				db 13, 04, 04, 04, 04, 04, 04, 04
				db 04, 04, 04, 04, 4Bh, 4Bh, 04, 0e
				db 04, 04, 04, 04, 4Bh, 4Bh, 04, 04
				db 04, 04, 04, 04, 4Bh, 4Bh, 04, 04
				db 04, 04, 04, 04, 4Bh, 4Bh, 04, 0e
				db 13, 04, 04, 04, 04, 04, 04, 04
				db 0f, 0f, 13, 13, 00, 00, 00, 13

sprite_camion_2	db 13, 00, 00, 00, 13, 13, 13, 13
				db 04, 04, 04, 04, 04, 04, 04, 13
				db 0e, 04, 4Bh, 4Bh, 04, 04, 04, 04
				db 04, 04, 4Bh, 4Bh, 04, 04, 04, 04
				db 04, 04, 4Bh, 4Bh, 04, 04, 04, 04
				db 0e, 04, 4Bh, 4Bh, 04, 04, 04, 04
				db 04, 04, 04, 04, 04, 04, 04, 13
				db 0f, 00, 00, 00, 0f, 0f, 13, 13

sprite_camion_3 db 13, 13, 13, 00, 00, 00, 13, 13
				db 07, 07, 07, 07, 07, 07, 07, 07
				db 07, 07, 07, 07, 07, 07, 07, 07
				db 07, 07, 07, 07, 07, 07, 07, 07
				db 07, 07, 07, 07, 07, 07, 07, 07
				db 07, 07, 07, 07, 07, 07, 07, 07
				db 07, 07, 07, 07, 07, 07, 07, 07
				db 0f, 0f, 13, 00, 00, 00, 13, 13

mapa_objetos db 3e8 dup (00)

opcion_principal_1  db "F1  Iniciar sesion$"
opcion_principal_2  db "F2  Registro$"
opcion_principal_3  db "F3  Salir$"

opcion1  db "F1  Nueva partida$"
opcion2  db "F2  Salir$"

cadena_pedir_nombre db "Escriba su nombre: $"
cadena_pedir_contra db "Escriba su clave: $"

semilla dw 0001
tipo_vehiculo db 00h
direccion_vehiculo db 00h
posicion_vehiculo db 00h
t_ultimo db 00h   ;ultimo segundo en el que se movieron los vehiculos
tiempo_partida dw 0000
horas_partida dw 0000
minutos_partida dw 0000
segundos_partida dw 0000
cadena_tiempo_partida db "00:00:00$"
debug db "sale del loop$"
colision_mensaje db "Colision!$"

;; ESTRUCTURA USUARIO -> 2f bytes
usuario_nombre    db 14 dup (00)
usuario_contra    db 19 dup (00)
usuario_tipo      db         00
usuario_bloqueado db         00

;; ESTRUCTURA JUEGO   -> 06 bytes
juego_cod_usuario dw 0000
juego_tiempo      dw 0000
juego_puntos      dw 0000

buffer_entrada db 0ff,00
               db 0ff dup (00)

usuarios_archivo db "USRS.ACE",00

cadena_limpiar db "                                       $" 
```

### Inicio

Con estas secciones podemos limpiar la pantalla, mostrar el menú principal y reconocer la elección del usuario

```assembly
.STARTUP
		;; ingreso al modo de video 13h
		mov AL, 13
		mov AH, 00
		int 10
		;; ...
menu_principal:
		mov DH, 08
		mov DL, 08
		mov BH, 00
		mov AH, 02
		int 10
		mov DX, offset opcion_principal_1
		mov AH, 09
		int 21
		mov DH, 0a
		mov DL, 08
		mov BH, 00
		mov AH, 02
		int 10
		mov DX, offset opcion_principal_2
		mov AH, 09
		int 21
		mov DH, 0c
		mov DL, 08
		mov BH, 00
		mov AH, 02
		int 10
		mov DX, offset opcion_principal_3
		mov AH, 09
		int 21
esperar_opcion_menu_principal:
		mov AH, 00
		int 16
		cmp AH, 3b
		je menu_usuario
		cmp AH, 3c
		je registro
		cmp AH, 3d
		je fin
		jmp esperar_opcion_menu_principal
```

### Menu Partida

Estas seccion nos permite limpiar pantalla y mostrar el menú para nuevas partidas

```asm
menu_usuario:
		call limpiar_pantalla
		mov DH, 08
		mov DL, 08
		mov BH, 00
		mov AH, 02
		int 10
		mov DX, offset opcion1
		mov AH, 09
		int 21
		mov DH, 0a
		mov DL, 08
		mov BH, 00
		mov AH, 02
		int 10
		mov DX, offset opcion2
		mov AH, 09
		int 21
		;;
esperar_opcion_menu:
		mov AH, 00
		int 16
		cmp AH, 3b
		je jugar
		cmp AH, 3c
		je menu_principal
		jmp esperar_opcion_menu
```


### Inicialización juego
Estas secciones de codigo se encargan de inicializar los datos para la partida y mostrar los elementos en pantalla
```asm
jugar:
		call limpiar_pantalla

		mov AH, 2Ch
		int 21 				;obtener tiempo, en cl se guarda el segundo
		mov [t_ultimo], Dh
		mov DL, Dh
		mov DH, 00
		mov [semilla], dx	;guardar la semilla para generar numeros aleatorios
		mov DH, 00		;fila
		mov DL, 10		;columna
		mov BH, 00		;pagina
		mov AH, 02		;posicionarse en la pantalla
		int 10
		;;
		mov DX, offset vidas
		mov AH, 09
		int 21
		mov CX, 0000
		mov cl, 28h
		mov DL, 00

colocar_aceras1:
		mov AL, DL
		mov AH, 01
		mov BL, ACERA
		call colocar_en_mapa
		inc DL
		loop colocar_aceras1
		mov CX, 0000
		mov cl, 28h
		mov DL, 00
colocar_aceras2:
		mov AL, DL
		mov AH, 17h
		mov BL, ACERA
		call colocar_en_mapa
		inc DL
		loop colocar_aceras2
		mov CX, 0000
		mov cl, 15h			;cantidad de carriles
		mov DH, 02h			;indice de la fila
colocar_todos_carriles:
		push CX				;guardar el valor de CX

		mov CX, 0000		
		mov cl, 28h
		mov DL, 00

colocar_carriles:
		mov AL, DL
		mov AH, DH		
		mov BL, CARRIL
		call colocar_en_mapa
		inc DL
		loop colocar_carriles
		inc DH
		pop CX
		loop colocar_todos_carriles
		mov AX, [coordenadas_jugador]
		mov BL, JUGADOR_ACERA
		call colocar_en_mapa

colocar_vehiculos:
		xor AX, AX
		xor DX, DX
		mov CX, 0000
		mov cl, 15h
		mov bh, 02h 		;indice de la fila

colocar_vehiculos_loop:
		call generar_vehiculo_aleatorio
		mov al, [tipo_vehiculo]
		cmp al, 02h
		jg colocar_vehiculos_loop
regenerar_direccion:
		call generar_direccion_vehiculo
		mov al, [direccion_vehiculo]
		cmp al, 01h
		jg regenerar_direccion
regenerar_posicion:
		call generar_posicion_vehiculo
		mov al, [posicion_vehiculo]
		cmp al, 27h
		jg regenerar_posicion
		mov al, [tipo_vehiculo]
		cmp al, 00h
		je colocar_carro
		cmp al, 01h
		je colocar_bus
		cmp al, 02h
		je colocar_camion

continuar_colocar_vehiculos:
		inc bh
		loop colocar_vehiculos_loop
		;;
		call pintar_mapa
		jmp validaciones

colocar_carro:
		mov al, [direccion_vehiculo]
		cmp al, 00h
		je colocar_carro_derecha
		jmp colocar_carro_izquierda
colocar_carro_derecha:
		mov al, [posicion_vehiculo]
		mov ah, bh
		mov bl, CARRO_DERECHA
		call colocar_en_mapa
		jmp continuar_colocar_vehiculos
colocar_carro_izquierda:
		mov al, [posicion_vehiculo]
		mov ah, bh
		mov bl, CARRO_IZQUIERDA
		call colocar_en_mapa
		jmp continuar_colocar_vehiculos
colocar_bus:
		mov al, [direccion_vehiculo]
		cmp al, 00h
		je colocar_bus_derecha
		jmp colocar_bus_izquierda
colocar_bus_derecha:
		mov al, [posicion_vehiculo]
		cmp al, 27h
		je correr_posicion_bus_der
continuar_colocar_bus_derecha:
		mov ah, bh
		mov bl, BUS1_DERECHA
		call colocar_en_mapa
		mov al, [posicion_vehiculo]
		inc al
		mov ah, bh
		mov bl, BUS2_DERECHA
		call colocar_en_mapa
		jmp continuar_colocar_vehiculos

correr_posicion_bus_der:
		dec al
		jmp continuar_colocar_bus_derecha

colocar_bus_izquierda:
		mov al, [posicion_vehiculo]
		cmp al, 27h
		je correr_posicion_bus_izq
continuar_colocar_bus_izquierda:
		mov ah, bh
		mov bl, BUS1_IZQUIERDA
		call colocar_en_mapa
		mov al, [posicion_vehiculo]
		inc al
		mov ah, bh
		mov bl, BUS2_IZQUIERDA
		call colocar_en_mapa
		jmp continuar_colocar_vehiculos
correr_posicion_bus_izq:
		dec al
		jmp continuar_colocar_bus_izquierda

colocar_camion:
		mov al, [direccion_vehiculo]
		cmp al, 00h
		je colocar_camion_derecha
		jmp colocar_camion_izquierda

colocar_camion_derecha:
		mov al, [posicion_vehiculo]
		cmp al, 27h
		je correr_posicion_camion_der
		cmp al, 26h
		je correr_posicion_camion_der
continuar_colocar_camion_derecha:
		mov ah, bh
		mov bl, CAMION3_DERECHA
		call colocar_en_mapa
		mov al, [posicion_vehiculo]
		inc al
		mov ah, bh
		mov bl, CAMION2_DERECHA
		call colocar_en_mapa
		mov al, [posicion_vehiculo]
		add al, 02h
		mov ah, bh
		mov bl, CAMION1_DERECHA
		call colocar_en_mapa
		jmp continuar_colocar_vehiculos
correr_posicion_camion_der:
		dec al
		dec al
		jmp continuar_colocar_camion_derecha

colocar_camion_izquierda:
		mov al, [posicion_vehiculo]
		cmp al, 27h
		je correr_posicion_camion_izq
		cmp al, 26h
		je correr_posicion_camion_izq
continuar_colocar_camion_izquierda:
		mov ah, bh
		mov bl, CAMION1_IZQUIERDA
		call colocar_en_mapa
		mov al, [posicion_vehiculo]
		inc al
		mov ah, bh
		mov bl, CAMION2_IZQUIERDA
		call colocar_en_mapa
		mov al, [posicion_vehiculo]
		add al, 02h
		mov ah, bh
		mov bl, CAMION3_IZQUIERDA
		call colocar_en_mapa
		jmp continuar_colocar_vehiculos
correr_posicion_camion_izq:
		dec al
		dec al
		jmp continuar_colocar_camion_izquierda
```


### Movimiento del jugador
Estas secciones se encargan de verificar si el jugador presionó una tecla y moverá el personaje en el mapa, tambien ferifican si existe una colisión con los vehiculos
```ASM
validaciones:
		mov AH, 01		;obtener tecla presionada
		int 16
		jz verificar_tiempo	;si no se presiono una tecla
		mov ah, 00
		int 16
		cmp AH, 53
		je mover_izquierda
		cmp AH, 51
		je mover_derecha
		cmp AH, 4Fh
		je mover_abajo
		cmp AH, 47
		je mover_arriba
		jmp verificar_tiempo

verificar_tiempo:
		mov AH, 2Ch
		int 21 				;obtener tiempo, en dh se guarda el segundo

		mov AL, [t_ultimo]
		cmp AL, DH
		jne aumentar_tiempo	;si el segundo es diferente al ultimo segundo en el que se movieron los vehiculos
		jmp validaciones	;si no se movieron los vehiculos volver a verificar si se presiono una tecla

aumentar_tiempo:
		mov [t_ultimo], DH	;guardar el nuevo segundo
		mov AX, [tiempo_partida]		
		inc AX
		mov [tiempo_partida], AX
		call pintar_tiempo
		jmp validaciones

pintar_tiempo:
		mov AX, [tiempo_partida]
		mov bx, 0E10h		;dividimos el tiempo en 3600 para obtener las horas
		xor DX, DX
		div BX
		mov [horas_partida], AX
		mov [minutos_partida], DX

		mov bh, 00
		mov bl, 0ah	;sacar las decenas de las horas
		xor DX, DX
		div BX
		add AL, 30h
		mov [cadena_tiempo_partida+00h], AL
		add DL, 30h
		mov [cadena_tiempo_partida+01h], DL

		mov AX, [minutos_partida]
		mov bh, 00  
		mov bl, 3Ch 	;dividimos el tiempo en 60 para obtener los minutos
		xor DX, DX
		div BX
		mov [minutos_partida], AX
		mov [segundos_partida], DX

		mov bh, 00
		mov bl, 0ah	;sacar las decenas de los minutos
		xor DX, DX
		div BX
		add AL, 30h
		mov [cadena_tiempo_partida+03h], AL
		add DL, 30h
		mov [cadena_tiempo_partida+04h], DL

		mov AX, [segundos_partida]
		mov bh, 00
		mov bl, 0ah	;sacar las decenas de los segundos
		xor DX, DX
		div BX
		add AL, 30h
		mov [cadena_tiempo_partida+06h], AL
		add DL, 30h
		mov [cadena_tiempo_partida+07h], DL
		
		;;posicionar el cursor en la posicion superior derecha
		mov DH, 00
		mov DL, 20h
		mov BH, 00
		mov AH, 02
		int 10

		mov DX, offset cadena_tiempo_partida
		mov AH, 09
		int 21

		jmp validaciones

		
mover_izquierda:
		mov AX, [coordenadas_jugador]
		cmp AL, 00h 	;si esta en el limite izquierdo
		je validaciones
		cmp AH, 17h 	;si esta en la acera
		je mover_izquierda_acera
		sub AL, 01
		call obtener_de_mapa
		cmp BL, CARRIL
		jne colision	;si hay un vehiculo en la izquierda
		jmp mover_izquierda_carril
mover_izquierda_acera:
		mov BL, ACERA
		call colocar_en_mapa
		mov AX, [coordenadas_jugador]
		sub AL, 01
		mov [coordenadas_jugador], AX
		mov BL, JUGADOR_ACERA
		call colocar_en_mapa
		call pintar_mapa
		jmp validaciones
mover_izquierda_carril:
		inc AL
		mov BL, CARRIL
		call colocar_en_mapa
		mov AX, [coordenadas_jugador]
		sub AL, 01
		mov [coordenadas_jugador], AX
		mov BL, JUGADOR_CARRIL
		call colocar_en_mapa
		call pintar_mapa
		jmp validaciones
mover_abajo:
		mov AX, [coordenadas_jugador]
		cmp Ah, 17h 	;si esta en la acera
		je validaciones
		cmp ah, 16h 	;si esta en el ultimo carril
		je mover_abajo_carril
		add AH, 01
		call obtener_de_mapa
		cmp BL, CARRIL
		jne colision	;si hay un vehiculo abajo
		sub AH, 01
		jmp mover_abajo_carril
mover_abajo_carril:
		mov BL, CARRIL
		call colocar_en_mapa
		mov AX, [coordenadas_jugador]
		add AH, 01
		mov [coordenadas_jugador], AX
		mov BL, JUGADOR_CARRIL
		call colocar_en_mapa
		call pintar_mapa
		jmp validaciones

mover_arriba:
		mov AX, [coordenadas_jugador]
		cmp Ah, 01h 	;si esta en la acera superior , no se puede mover mas arriba
		je validaciones
		sub ah, 01
		call obtener_de_mapa
		cmp BL, CARRIL
		jne colision	;si hay un vehiculo arriba
		add ah, 01
		cmp ah, 17h 	;si esta en la acera inferior
		je mover_arriba_acera
		jmp mover_arriba_carril
mover_arriba_carril:
		mov BL, CARRIL
		call colocar_en_mapa
		jmp mover_arriba_jugador
mover_arriba_acera:
		mov BL, ACERA
		call colocar_en_mapa
mover_arriba_jugador:
		mov AX, [coordenadas_jugador]
		sub AH, 01
		mov [coordenadas_jugador], AX
		mov BL, JUGADOR_CARRIL
		call colocar_en_mapa
		call pintar_mapa
		jmp validaciones
mover_derecha:
		mov AX, [coordenadas_jugador]
		cmp AL, 27h 	;si esta en el limite izquierdo
		je validaciones
		cmp AH, 17h 	;si esta en la acera
		je mover_derecha_acera
		add AL, 01
		call obtener_de_mapa
		cmp BL, CARRIL
		jne colision	;si hay un vehiculo en la izquierda
		sub AL, 01
		jmp mover_derecha_carril
mover_derecha_acera:
		mov BL, ACERA
		call colocar_en_mapa
		mov AX, [coordenadas_jugador]
		add AL, 01
		mov [coordenadas_jugador], AX
		mov BL, JUGADOR_ACERA
		call colocar_en_mapa
		call pintar_mapa
		jmp validaciones
mover_derecha_carril:
		mov BL, CARRIL
		call colocar_en_mapa
		mov AX, [coordenadas_jugador]
		add AL, 01
		mov [coordenadas_jugador], AX
		mov BL, JUGADOR_CARRIL
		call colocar_en_mapa
		call pintar_mapa
		jmp validaciones

colision:
		;;posicionar el cursor en la posicion superior derecha
		mov DH, 18h
		mov DL, 0fh
		mov BH, 00
		mov AH, 02
		int 10

		mov DX, offset colision_mensaje
		mov AH, 09
		int 21

		jmp validaciones
```
### pintado de elementos

Estas secciones convierten los sprites almacenados en variables a pixeles en pantalla

```asm
;; pintar_pixel - pinta un pixel en una posición x, y
;; ENTRADAS:
;;  - SI - x
;;  - DI - y
;;  - CL - color 
;; SALIDA:
pintar_pixel:
		;; DS tiene cierto valor
		;; se preservó DS
		push DS
		;; se coloca la dirección del scanner del modo de video
		mov DX, 0a000
		mov DS, DX
		;;
		mov AX, 140 ;; tamaño máximo de x ;; tamaño máximo de x
		mul DI
		;; DX-AX resultado de la multiplicación
		add AX, SI
		;; índice hacia la memoria del pixel
		mov BX, AX
		mov [BX], CL
		pop DS
		ret

;; pintar_sprite - pinta el sprite en la posición especificada en memoria
;; ENTRADA:
;;   BX -> datos del sprite a pintar
pintar_sprite:
		mov SI, [x_elemento]
		mov DI, [y_elemento]
		xchg BP, CX
		mov CX, 0000
		mov CL, 08    ;; altura del jugador, 8 en este caso
ciclo_filas:
		xchg BP, CX
		mov CX, 0000
		mov CL, 08    ;; anchura del jugador, 8 en este caso
ciclo_columnas:
		push BX
		push CX
		mov CL, [BX]
		call pintar_pixel
		pop CX
		pop BX
		inc SI
		inc BX
		loop ciclo_columnas
		;; terminó una fila
		;;; incremento y
		inc DI
		;;; reinicio x
		mov SI, [x_elemento]
		xchg BP, CX
		loop ciclo_filas
		ret

;; colocar_en_mapa -
;; ENTRADA:
;;  AL -> x del elemento
;;  AH -> y del elemento
;;  BL -> código del elemento
colocar_en_mapa:
		push DX  ;; guardar el contador de carriles en la pila
		push AX    ;; guardar las posiciones en la pila
		mov AL, AH
		mov AH, 00
		mov DI, AX
		mov AX, 28 ;; tamaño máximo de x
		mul DI
		;; DX-AX resultado de la multiplicación
		pop DX
		mov DH, 00
		add AX, DX  ;; AX = 28*y + x
		;; índice hacia la memoria del pixel
		mov SI, offset mapa_objetos
		add SI, AX
		mov [SI], BL
		pop DX 		;; recuperar el contador de carriles
		ret

;; obtener_de_mapa -
;; ENTRADA:
;;  AL -> x del elemento
;;  AH -> y del elemento
;; SALIDA:
;;  BL -> código del elemento
obtener_de_mapa:
		push AX    ;; guardar las posiciones en la pila
		push AX	 
		mov AL, AH
		mov AH, 00
		mov DI, AX
		mov AX, 28 ;; tamaño máximo de x
		mul DI
		;; DX-AX resultado de la multiplicación
		pop DX
		mov DH, 00
		add AX, DX  ;; AX = 28*y + x
		;; índice hacia la memoria del pixel
		mov SI, offset mapa_objetos
		add SI, AX
		mov BL, [SI]
		pop AX
		ret

;; pintar_mapa - 
pintar_mapa:
		mov AX, 0000
		mov [coordenada_actual], AX
		mov CX, 19
ciclo_filas_mapa:
		xchg BP, CX
		mov CX, 28
ciclo_columnas_mapa:
		mov AX, [coordenada_actual]
		call obtener_de_mapa
		jmp identificar_celda

ciclo_columnas_mapa_loop:
		mov AX, [coordenada_actual]
		inc AL
		mov [coordenada_actual], AX
		loop ciclo_columnas_mapa
		mov AX, [coordenada_actual]
		mov AL, 00
		inc AH
		mov [coordenada_actual], AX
		xchg BP, CX
		loop ciclo_filas_mapa
		ret

identificar_celda:
		cmp BL, ACERA
		je pintar_acera
		cmp BL, CARRIL
		je pintar_carril
		cmp BL, JUGADOR_CARRIL
		je pintar_jugador_carril
		cmp BL, JUGADOR_ACERA
		je pintar_jugador_acera
		cmp BL, CARRO_DERECHA
		je pintar_carro
		cmp BL, CARRO_IZQUIERDA
		je pintar_carro
		cmp BL, BUS1_DERECHA
		je pintar_bus_1
		cmp BL, BUS2_DERECHA
		je pintar_bus_2
		cmp BL, BUS1_IZQUIERDA
		je pintar_bus_1
		cmp BL, BUS2_IZQUIERDA
		je pintar_bus_2
		cmp BL, CAMION1_DERECHA
		je pintar_camion_1
		cmp BL, CAMION1_IZQUIERDA
		je pintar_camion_2
		cmp BL, CAMION2_DERECHA
		je pintar_camion_3
		cmp BL, CAMION3_DERECHA
		je pintar_camion_3
		cmp BL, CAMION2_IZQUIERDA
		je pintar_camion_3
		cmp BL, CAMION3_IZQUIERDA
		je pintar_camion_3
		jmp ciclo_columnas_mapa_loop

pintar_sprite_en_posicion:
		mov AX, [coordenada_actual]
		mov AH, 08
		mul AH
		mov [x_elemento], AX
		mov AX, [coordenada_actual]
		mov AL, AH
		mov AH, 08
		mul AH
		mov [y_elemento], AX
		push CX
		push BP
		call pintar_sprite
		pop BP
		pop CX
		jmp ciclo_columnas_mapa_loop

pintar_acera:
		mov BX, offset sprite_banqueta
		jmp pintar_sprite_en_posicion
pintar_carril:
		mov BX, offset sprite_carril
		jmp pintar_sprite_en_posicion
pintar_jugador_carril:
		mov BX, offset sprite_jugador_carril
		jmp pintar_sprite_en_posicion
pintar_jugador_acera:
		mov BX, offset sprite_jugador_acera
		jmp pintar_sprite_en_posicion
pintar_carro:
		mov BX, offset sprite_carro
		jmp pintar_sprite_en_posicion
pintar_bus_1:
		mov BX, offset sprite_bus_1
		jmp pintar_sprite_en_posicion
pintar_bus_2:
		mov BX, offset sprite_bus_2
		jmp pintar_sprite_en_posicion
pintar_camion_1:
		mov BX, offset sprite_camion_1
		jmp pintar_sprite_en_posicion
pintar_camion_2:
		mov BX, offset sprite_camion_2
		jmp pintar_sprite_en_posicion
pintar_camion_3:
		mov BX, offset sprite_camion_3
		jmp pintar_sprite_en_posicion
```

### Subrutina limpiar pantalla

Subrutina utilizada para limpiar pantalla

```asm
limpiar_pantalla:
		push CX
		mov CX, 1a
ciclo_limpiar_pantalla:
		mov DX, offset cadena_limpiar
		mov AH, 09
		int 21
		loop ciclo_limpiar_pantalla
		pop CX
		ret
```

### Generaciones aleatorias

Las siguientes subrutinas se encargan de generar  posiciones, direcciones y tipos de vehiculos a lo largo de la pantalla.
```asm
generar_posicion_vehiculo:
	push BX
	push CX

	mov ax, [semilla]
	mov bx, 0003
	mul bx
	add ax, 0001
	mov [semilla], ax
	xor dx, dx
	mov bh, 00
	mov bl, 27
	div bx
	mov [posicion_vehiculo], dl
	pop CX
	pop BX
	ret

generar_direccion_vehiculo:
	push BX
	push CX
	
	mov ax, [semilla]
	mov bx, 0003
	mul bx
	add ax, 0001
	mov [semilla], ax
	xor dx, dx
	mov bh, 00
	mov bl, 02
	div bx
	mov [direccion_vehiculo], dl
	pop CX
	pop BX
	ret

generar_vehiculo_aleatorio:
	push BX
	push CX

	mov ax, [semilla]
	mov bx, 0003
	mul bx
	add ax, 0001
	mov [semilla], ax
	xor dx, dx
	mov bh, 00
	mov bl, 03
	div bx

	mov [tipo_vehiculo], DL
	pop CX
	pop BX
	ret
```


