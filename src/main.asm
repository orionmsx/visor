;*********************************************************************
;*
;* Visor de pantallas 1.1
;*
;* Fecha: 16/03/2025
;* Autor: Rafael López "Orion"
;* Email: orion@orionmsx.com
;*
;*********************************************************************

	output "out/main.bin"

    include "constantes.asm"

;**************
; CABECERA BIN
;**************

	db #fe
	dw BEGIN
	dw END
	dw BEGIN

	org #8200

;*********************
; INICIO DEL PROGRAMA
;*********************

BEGIN:

    di

    ;Engancha nuestra custom ISR
    im 1
    ld a,0C3h                               ;código de la instrucción JP
    ld (HTIMI),a
    ld hl,tickMain
    ld (HTIMI+1),hl
    
    ;bloquea la lógica del programa para inicializar hardware
    ld a,1
    ld (tickInProgress),a

    call SetVideoMode

    ld hl,tabla_colores
    ld de,#0000 
    call depack_VRAM
    ld hl,tabla_colores
    ld de,#0800 
    call depack_VRAM
    ld hl,tabla_colores
    ld de,#1000 
    call depack_VRAM

    ld hl,tabla_tiles
    ld de,#2000 
    call depack_VRAM
    ld hl,tabla_tiles
    ld de,#2800 
    call depack_VRAM
    ld hl,tabla_tiles
    ld de,#3000 
    call depack_VRAM

    call loadFont	            ;carga la fuente

    xor a
    ld hl,x_mapa
    ld (hl),a
    inc hl                      ;y_mapa está a continuación de x_mapa en la RAM
    ld (hl),a

    call pinta_pantalla

    ;desbloquea la lógica del programa tras inicializar hardware
    xor a
    ld (tickInProgress),a
    call RDVDP

    ei

bucle_infinito:
    jr $

    include "isr.asm"
    include "rutinas.asm"
    include "pantallas.asm"

depack_VRAM:	
    include "lib/PL_VRAM_Depack_SJASM.asm"

    include "variables.asm"

;******************
; FIN DEL PROGRAMA
;******************

END:
