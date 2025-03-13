;*************************
; DEFINICION DE VARIABLES
;*************************

x_mapa:				db 0		;coordenada x
y_mapa:				db 0		;coordenada y
waitCounter:        db 0        ;contador de espera
tickInProgress:     db 0        ;indica si estamos corriendo la ISR
timer:              db 0        ;contador global del programa
enCortinilla:       db 0        ;indica si estamos en medio de una cortinilla
