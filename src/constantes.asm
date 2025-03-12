;****************
; SERVICIOS BIOS
;****************

GTSTCK  equ	#00D5	;lee los cursores y joystick
RDVDP	equ	#013E	;lee registro del VDP
WRTVDP 	equ #0047	;escribe registro del VDP
SETWRT  equ #0053   ;habilita el VDP para escribir
WRTVRM	equ	#004D	;escribe en VRAM


;*************************
; DIRECCIONES IMPORTANTES
;*************************

HTIMI	equ #FD9F   ;dirección de la ISR original del sistema para el VDP


;*************
; ESPECIFICAS
;*************

ANCHO_MAPA  equ 5
ALTO_MAPA   equ 2
byte_6      equ 6
RETARDO_MAX equ	6