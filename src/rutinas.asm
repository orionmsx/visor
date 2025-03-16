;*********************************************************************************************************
;*
;* Nos movemos a la pantalla de arriba
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
do_arriba:
    push af
    ld a,(y_mapa)
    or a
    jr z,.end
    dec a
    ld (y_mapa),a
    call doCortinilla               ;reemplaza por call pinta_pantalla para no usar la cortinilla
.end:
    pop af
    ret


;*********************************************************************************************************
;*
;* Nos movemos a la pantalla de abajo
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
do_abajo:
    push af
    ld a,(y_mapa)
    cp (ALTO_MAPA-1)
    jr z,.end
    inc a
    ld (y_mapa),a
    call doCortinilla               ;reemplaza por call pinta_pantalla para no usar la cortinilla
.end:
    pop af
    ret


;*********************************************************************************************************
;*
;* Nos movemos a la pantalla de la derecha
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
do_derecha:
    push af
    ld a,(x_mapa)
    cp (ANCHO_MAPA-1)
    jr z,.end
    inc a
    ld (x_mapa),a
    call doCortinilla               ;reemplaza por call pinta_pantalla para no usar la cortinilla
.end:
    pop af
    ret


;*********************************************************************************************************
;*
;* Nos movemos a la pantalla de la izquierda
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
do_izquierda:
    push af
    ld a,(x_mapa)
    or a
    jr z,.end
    dec a
    ld (x_mapa),a
    call doCortinilla               ;reemplaza por call pinta_pantalla para no usar la cortinilla
.end:
    pop af
    ret


;*********************************************************************************************************
;*
;* Dibuja la pantalla
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: A,DE
;*
;*********************************************************************************************************
pinta_pantalla:
    call apaga_pantalla
    call calcula_puntero
    add a,a
    ld hl,pantallas
    call getIndexHL_A
    ld de,#3800
    halt
    call depack_VRAM
    call printHUD
    call enciende_pantalla
    ret


;*********************************************************************************************************
;*
;* Devuelve en A la posición de la pantalla en la lista, tomando sus coordenadas x_mapa e y_mapa
;*
;* Parámetros: Ninguno
;*
;* Devuelve: A = posición de la pantalla en la lista
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
calcula_puntero:
    ld a,(y_mapa)
    ld b,a
    xor a
[ANCHO_MAPA]    add b
    ld b,a
    ld a,(x_mapa)
    add a,b
    ret


;*********************************************************************************************************
;*
;* Obtiene el valor de la posición de memoria apuntada por HL + A
;*
;* Parámetros: HL = index pointer, A = index
;*
;* Devuelve: HL = (HL + A)
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
getIndexHL_A:
    call ADD_A_HL
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ret


;*********************************************************************************************************
;*
;* Suma HL y A
;*
;* Parámetros: A, HL
;*
;* Devuelve: HL = A + HL
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
ADD_A_HL:
    add a,l
    ld l,a
    ret nc
    inc h
    ret


;*********************************************************************************************************
;*
;* Borra la pantalla
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: HL, BC, A
;*
;*********************************************************************************************************
clearScreen:
    ld hl,7800h	        ;tabla	de nombres (#3800) VRAM	= 16K #0000-#3FFF
    ld bc,300h	        ;name table size
    xor	a
    ;sigue abajo en setFillVRAM


;*********************************************************************************************************
;*
;* Escribe en una zona de la VRAM el valor de A
;*
;* Parámetros: HL = dirección VRAM, A = dato a escribir, BC = número de bytes
;*
;* Devuelve: Nada
;*
;* Modifica: A', C'
;*
;*********************************************************************************************************
setFillVRAM:
    call setVDPWrite
fillVRAM:
    ex af,af'
VRAM_write2:                        ;envío de las órdenes al VDP
    ex af,af'
    exx
    out (c),a
    exx
    ex af,af'
    dec bc
    ld a,b
    or c
    jr nz,VRAM_write2
    ex af,af'
    ret


;*********************************************************************************************************
;*
;* Prepara el VDP para escribir en VRAM
;*
;* Parámetros: HL = dirección VRAM en la que queremos escribir
;*
;* Devuelve: C' = Puerto de escritura del VDP
;*
;* Modifica: A'
;*
;*********************************************************************************************************
setVDPWrite:
    ex af,af'
    call SETWRT
    exx
    ld a,(byte_6)
    ld c,a
    exx
    ex af,af'
    ret


;*********************************************************************************************************
;*
;* Desactiva la pantalla en el VDP
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: BC,AF
;*
;*********************************************************************************************************
apaga_pantalla:
    ld b,022h
    ld c,1
    call WRTVDP
    ret


;*********************************************************************************************************
;*
;* Activa la pantalla en el VDP
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: BC,AF
;*
;*********************************************************************************************************
enciende_pantalla:
    ld b,0E2h
    ld c,1
    call WRTVDP
    ret


;*********************************************************************************************************
;*
;* Configura el VDP
;* - Screen 2
;* - Sprites 16x16 unzoomed
;* - Pattern name table = #3800-#3AFF
;* - Pattern color table = #0000-#17FF
;* - Pattern generator table = #2000-#37FF
;* - Sprite atribute table	= #3b00-#3B7F
;* - Sprite generator table = #1800-#1FFF
;* - Background color = #E0 (Gris/Transparente)
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: AF, HL, BC, D
;*
;*********************************************************************************************************
SetVideoMode:
    ld hl,VDP_InitData
    ld d,8
    ld c,0
setVideoMode2:
    ld b,(hl)
    call WRTVDP
    inc hl
    inc c
    dec d
    jr nz,setVideoMode2
    ret
VDP_InitData:	
    db 2
    db 0E2h
    db 0Eh
    db 7Fh
    db 7
    db 76h
    db 3
    db 0E0h


;*********************************************************************************************************
;*
;* Inicialización para la primera invocación de drawCortinilla
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: A
;*
;*********************************************************************************************************
doCortinilla:
	ld a,32
    ld (waitCounter),a
    ld a,1
    ld (enCortinilla),a
    ;sigue abajo en drawCortinilla


;*********************************************************************************************************
;*
;* Borra la pantalla haciendo una cortinilla de izquierda a derecha, cada invocación una columna
;*
;* Parámetros: waitCounter = 32 - columna a borrar
;*
;* Devuelve: Nada
;*
;* Modifica: DE, HL, AF, B
;*
;*********************************************************************************************************
drawCortinilla:
    ld hl,waitCounter
    dec (hl)
    ;estamos construyendo la serie #3800 hasta #381F
    ;que son las posiciones de la primera fila de pantalla
    ;en la tabla de nombres
    ld a,(hl)
    ld h,38h		                ;#3800 es la tabla de nombres
    xor	1Fh                         ;segundo nible de la tabla de nombres es 31-waitCounter
    ld l,a

    ld b,18h		                ;las 24 filas de la pantalla
    xor	a                           ;valor 0 a escribir en VRAM, borra la pantalla

drawCortinilla2:                    ;borra una columna
    call WRTVRM
    ld de,20h                       ;las 32 columnas de la pantalla
    add	hl,de		                ;siguiente fila
    djnz drawCortinilla2

    ld a,(waitCounter)
    or a
    jr z,.finCortinilla

.salimos
    ret
.finCortinilla
    xor a
    ld (enCortinilla),a
    call pinta_pantalla
    ret


;*********************************************************************************************************
;*
;* Carga la fuente a partir del tile INI_FONT y rellena su parte de la tabla de color
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: HL, BC, A
;*
;*********************************************************************************************************
loadFont:
    ld de,GFX_Font            
    ld hl,8192+(8*INI_FONT) ;pattern generator table addres (pattern INI_FONT)
    call UnpackPatterns
    ld a,0F0h               ;color blanco sobre transparente
    ld hl,8*INI_FONT        ;color table address (tile INI_FONT)
    ld bc,180h              ;número de bytes a rellenar
fillVRAM3Bank:
    ld d,3
fillVRAM3Bank2:
    push bc
    push de
    call setFillVRAM        ;rellena la tabla de color
    ld de,800h              ;siguiente banco
    add hl,de
    pop de
    pop bc
    dec d
    jr nz,fillVRAM3Bank2

    ret


;*********************************************************************************************************
;*
;* Descomprime los datos de la tabla de patrones o de colores en los tres bancos
;*
;* Parámetros: DE = datos, HL = dirección de la tabla
;*
;* Devuelve: Nada
;*
;* Modifica: HL, BC, A
;*
;*********************************************************************************************************
UnpackPatterns:
    ld b,3
setPatternDatax_:
    push bc
    push de
    call unpackGFX
    ld de,800h	            ;siguiente banco
    add	hl,de
    pop	de
    pop	bc
    djnz setPatternDatax_
    ret


;*********************************************************************************************************
;*
;* Paso previo a unpackGFX para indicar mediante DE la dirección de VRAM donde escribir
;*
;*********************************************************************************************************
unpackGFXset:
    ex de,hl
    ld e,(hl)
    inc	hl
    ld d,(hl)
    ex de,hl		        ;HL = Direccion de la VRAM
    inc	de
    ;sigue abajo en unpackGFX


;*********************************************************************************************************
;*
;* Interpreta los datos graficos
;*
;* Parámetros: DE = Datos a interpretar, HL = VRAM address
;*  +0: Numero de veces a repetir un dato
;*  +1: Dato a repetir
;*
;*  Si el bit7 del numero de veces a repetir esta activo:
;*  +0: Cantidad de bytes a transferir a VRAM
;*  +1: Datos a transferir
;*
;*  0 = Fin de datos
;*
;* Devuelve: Nada
;*
;* Modifica: A,BC,DE
;*
;*********************************************************************************************************
unpackGFX:
    call setVDPWrite
unpackGFX2:
    ld a,(de)
    and	7Fh
    ld c,a
    ld a,(de)
    inc	de
    jr nz,unpackGFX3
    cp c
    jr nz,unpackGFXset      ;cambia a una nueva posicion en la VRAM
    ret
unpackGFX3:
    ld b,0
    cp c
    push af
    call nz,DEtoVRAM	    ;transfiere desde DE a VRAM (BC bytes)
    pop	af
    call z,fillVRAM_DE
    jr unpackGFX2


;*********************************************************************************************************
;*
;* Transfiere datos desde la RAM a la VRAM
;*
;* Parámetros: DE = Origen, BC = Numero de datos
;*
;* Devuelve: Nada
;*
;* Modifica: A,BC,DE
;*
;*********************************************************************************************************
DEtoVRAM:
    ld a,(de)
    exx
    out	(c),a
    exx
    inc	de
    dec	bc
    ld a,b
    or c
    jr nz,DEtoVRAM
    ret


;*********************************************************************************************************
;*
;* Rellena BC bytes de VRAM con el dato (DE)
;*
;* Parámetros: BC = número de bytes a rellenar, DE = dirección del dato en RAM
;*
;* Devuelve: Nada
;*
;* Modifica: A,DE
;*
;*********************************************************************************************************
fillVRAM_DE:
    ld	a,(de)
    inc	de
    jp	fillVRAM


;*********************************************************************************************************
;*
;* Escribe las coordenadas de la pantalla actual en la primera fila
;*
;* Parámetros: Ninguno
;*
;* Devuelve: Nada
;*
;* Modifica: HL,A,BC
;*
;*********************************************************************************************************
printHUD:
    ld hl,0x380C
    ld a,(x_mapa)
    call bin2bcd
    call AL_C__AH_B
    ld a,INI_FONT
    add a,b
    call WRTVRM
    ld a,INI_FONT
    add a,c
    inc hl
    call WRTVRM

    ld a,INI_FONT+16                    ;caracter del guión
    inc hl
    inc hl
    call WRTVRM
    inc hl
    inc hl

    ld a,(y_mapa)
    call bin2bcd
    call AL_C__AH_B
    ld a,INI_FONT
    add a,b
    call WRTVRM
    ld a,INI_FONT
    add a,c
    inc hl
    call WRTVRM
    
    ret


;*********************************************************************************************************
;*
;* Convierte el número en A de binario a BCD
;*
;* Parámetros: A = número a convertir
;*
;* Devuelve: A = número en BCD
;*
;* Modifica: BC
;*
;*********************************************************************************************************
bin2bcd:
;https://www.msx.org/forum/development/msx-development/bcdhex-conversion-asm
    push bc
    ld c,a
    ld b,8
    xor a
.loop:
    sla c
    adc a,a
    daa
    djnz .loop
    pop bc
    ret


;*********************************************************************************************************
;*
;* Copia el nibble alto de A en B y el bajo en C
;*
;* Parámetros: A = numero a separar
;*
;* Devuelve: B = nibble alto, C = nibble bajo
;*
;* Modifica: Nada
;*
;*********************************************************************************************************
AL_C__AH_B:
    push af 
    rra
    rra
    rra
    rra
    and	0Fh
    ld b,a
    pop	af
    and	0Fh
    ld c,a
    ret