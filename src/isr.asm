tickMain:
    di
    call RDVDP                      ;borra flag de interrupción
    ld hl,tickInProgress            ;si hay una ISR anterior sin terminar no ejecuta la lógica del juego
    bit 0,(hl)
    jr nz,tickMain2
    inc (hl)                        ;pone la marca de ISR trabajando
    ei

    ld hl,timer                     ;incrementa el contador global del programa
    inc (hl)

    ld a,(enCortinilla)
    or a
    jr z,.seguimos

    call drawCortinilla
    ld hl,waitCounter
    jp m,.seguimos
    jr .terminamos

.seguimos:

    xor a
	call GTSTCK

    cp 1
    call z,do_arriba
	cp 3
	call z,do_derecha
    cp 5
    call z,do_abajo
	cp 7
	call z,do_izquierda

.terminamos:
    xor a                           ;quita la marca de ISR trabajando
    ld (tickInProgress),a

tickMain2:
    call RDVDP                      ;lee y borra el flag de interrupción
    or a

    ret