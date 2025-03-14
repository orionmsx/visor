;*************************
; DEFINICION DE VARIABLES
;*************************

x_mapa:				db 0		;coordenada x
y_mapa:				db 0		;coordenada y
waitCounter:        db 0        ;contador de espera
tickInProgress:     db 0        ;indica si estamos corriendo la ISR
timer:              db 0        ;contador global del programa
enCortinilla:       db 0        ;indica si estamos en medio de una cortinilla

;Fuente
GFX_Font:	
    db 8Bh,	0, 1Ch,	22h, 63h, 63h, 63h, 22h, 1Ch, 0, 18h, 38h, 4, 18h, 0CEh, 7Eh
    db 0, 3Eh, 63h,	3, 0Eh,	3Ch, 70h, 7Fh, 0, 3Eh, 63h, 3, 0Eh, 3, 63h, 3Eh
    db 0, 0Eh, 1Eh,	36h, 66h, 66h, 7Fh, 6, 0, 7Fh, 60h, 7Eh, 63h, 3, 63h, 3Eh
    db 0, 3Eh, 63h,	60h, 7Eh, 63h, 63h, 3Eh, 0, 7Fh, 63h, 6, 0Ch, 18h, 18h,	18h
    db 0, 3Eh, 63h,	63h, 3Eh, 63h, 63h, 3Eh, 0, 3Eh, 63h, 63h, 3Fh,	3, 63h,	3Eh
    db 3Ch,	42h, 99h, 0A1h,	0A1h, 99h, 42h,	3Ch, 18h, 3Ch, 18h, 8, 10h, 27h, 0, 1
    db 7Eh,	4, 0, 0C1h, 1Ch, 36h, 63h, 63h,	7Fh, 63h, 63h, 0, 7Eh, 63h, 63h, 7Eh
    db 63h,	63h, 7Eh, 0, 3Eh, 63h, 60h, 60h, 60h, 63h, 3Eh,	0, 7Ch,	66h, 63h, 63h
    db 63h,	66h, 7Ch, 0, 7Fh, 60h, 60h, 7Eh, 60h, 60h, 7Fh,	0, 7Fh,	60h, 60h, 7Eh
    db 60h,	60h, 60h, 0, 3Eh, 63h, 60h, 67h, 63h, 63h, 3Fh,	0, 63h,	63h, 63h, 7Fh
    db 63h,	63h, 63h, 0, 3Ch, 5, 18h, 83h, 3Ch, 0, 1Fh, 4, 6, 8Bh, 66h, 3Ch
    db 0, 63h, 66h,	6Ch, 78h, 7Ch, 6Eh, 67h, 0, 6, 60h, 93h, 7Fh, 0, 63h, 77h
    db 7Fh,	7Fh, 6Bh, 63h, 63h, 0, 63h, 73h, 7Bh, 7Fh, 6Fh,	67h, 63h, 0, 3Eh, 5
    db 63h,	0A3h, 3Eh, 0, 7Eh, 63h,	63h, 63h, 7Eh, 60h, 60h, 0, 3Eh, 63h, 63h, 63h
    db 6Fh,	66h, 3Dh, 0, 7Eh, 63h, 63h, 62h, 7Ch, 66h, 63h,	0, 3Eh,	63h, 60h, 3Eh
    db 3, 63h, 3Eh,	0, 7Eh,	6, 18h,	1, 0, 6, 63h, 82h, 3Eh,	0, 4, 63h
    db 0A4h, 36h, 1Ch, 8, 0, 63h, 63h, 6Bh,	6Bh, 7Fh, 77h, 22h, 0, 63h, 76h, 3Ch
    db 1Ch,	1Eh, 37h, 63h, 0, 66h, 66h, 7Eh, 3Ch, 18h, 18h,	18h, 0,	7Fh, 7,	0Eh
    db 1Ch,	38h, 70h, 7Fh, 0, 3, 24h, 4, 0,	0
