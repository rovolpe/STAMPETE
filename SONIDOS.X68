*-----------------------------------------------------------
;SONIDOS
*-----------------------------------------------------------
*REPRODUCE EL SONIDO DEL DISPARO
*DE RECIBIR DAÑO
*DE COMER UNA FLOR
*DE PERDER

*MUSICA DE FONDO

*CARGAR SONIDO DE PRUEBA

INIT_SONIDOS:
    MOVEM.L D1/A1, -(A7)
    LEA     SND_PRUEBA_RUTA, A1     ;pONEMOS LA RUTA EN A1
    MOVE.B  #SND_PRUEBA, D1         ;ID de como lo vamos a llamar
    BSR     CARGAR_SONIDO
    MOVEM.L (A7)+, D1/A1
    RTS

SND_PRUEBA_RUTA:    DC.B    'SND\PRUEBA.wav',0
                    DS.W    0
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
