;*********************************************************************
;*
;* Visor de pantallas
;*
;* Fecha: 09/03/2025
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

    xor a
    ld hl,x_mapa
    ld (hl),a
    inc hl
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

pantallas:
    dw p1
    dw p2
    dw p3
    dw p4
    dw p5
    dw p6
    dw p7
    dw p8
    dw p9
    dw p10

p1:
    incbin "gfx/prueba.bin.asm_0_0.plet5"
p2:
    incbin "gfx/prueba.bin.asm_1_0.plet5"
p3:
    incbin "gfx/prueba.bin.asm_2_0.plet5"
p4:
    incbin "gfx/prueba.bin.asm_3_0.plet5"
p5:
    incbin "gfx/prueba.bin.asm_4_0.plet5"
p6:
    incbin "gfx/prueba.bin.asm_0_1.plet5"
p7:
    incbin "gfx/prueba.bin.asm_1_1.plet5"
p8:
    incbin "gfx/prueba.bin.asm_2_1.plet5"
p9:
    incbin "gfx/prueba.bin.asm_3_1.plet5"
p10:
    incbin "gfx/prueba.bin.asm_4_1.plet5"

depack_VRAM:	
    include "lib/PL_VRAM_Depack_SJASM.asm"

tabla_colores:
	incbin	"gfx/prueba.bin.clr.plet5"
tabla_tiles:
	incbin	"gfx/prueba.bin.chr.plet5"

    include "variables.asm"

;******************
; FIN DEL PROGRAMA
;******************

END:
