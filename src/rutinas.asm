do_arriba:
    push af
    ld a,(y_mapa)
    or a
    jr z,.end
    dec a
    ld (y_mapa),a
    call doCortinilla
.end:
    pop af
    ret

do_abajo:
    push af
    ld a,(y_mapa)
    cp (ALTO_MAPA-1)
    jr z,.end
    inc a
    ld (y_mapa),a
    call doCortinilla
.end:
    pop af
    ret


do_derecha:
    push af
    ld a,(x_mapa)
    cp (ANCHO_MAPA-1)
    jr z,.end
    inc a
    ld (x_mapa),a
    call doCortinilla
.end:
    pop af
    ret


do_izquierda:
    push af
    ld a,(x_mapa)
    or a
    jr z,.end
    dec a
    ld (x_mapa),a
    call doCortinilla
.end:
    pop af
    ret


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


apaga_pantalla:
    ld b,022h
    ld c,1
    call WRTVDP
    ret


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


doCortinilla:
	ld a,32
    ld (waitCounter),a
    ld a,1
    ld (enCortinilla),a
    ;sigue abajo en drawCortinilla
    ;call drawCortinilla
    ;ret


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
;* Carga la fuente a partir del tile 16 y rellena la tabla de color
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
    ld hl,2080h	            ;pattern generator table addres (pattern 16)
    call UnpackPatterns
    ld a,0F0h               ;color blanco sobre transparente
    ld hl,80h               ;color table address (tile 16)
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
;* Devuelve: 
;*
;* Modifica: 
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
;* Devuelve: 
;*
;* Modifica: 
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
;* Parámetros: 
;*
;* Devuelve: 
;*
;* Modifica: 
;*
;*********************************************************************************************************
fillVRAM_DE:
    ld	a,(de)
    inc	de
    jp	fillVRAM


printHUD:
    ld hl,0x380C
    ld a,(x_mapa)
    call bin2bcd
    call AL_C__AH_B
    ld a,16
    add a,b
    call WRTVRM
    ld a,16
    add a,c
    inc hl
    call WRTVRM

    ld a,32
    inc hl
    inc hl
    call WRTVRM
    inc hl
    inc hl

    ld a,(y_mapa)
    call bin2bcd
    call AL_C__AH_B
    ld a,16
    add a,b
    call WRTVRM
    ld a,16
    add a,c
    inc hl
    call WRTVRM
    
    ret


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


AL_C__AH_B:
    push af		; Copia	el nibble alto de A en B y el bajo en C
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