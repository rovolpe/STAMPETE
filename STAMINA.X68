*-----------------------------------------------------------
*STAMINA
*Barra de stamina que funciona como barra de vida.
*Mostrará en pantalla en el juego la barra que irá bajando
*por el tiempo

*Tiene que tener subrutinas que hacen que baje mas rapido o que
*sumen cierta cantidad para cuando se come una flor de cactus
*o cuando se choca contra uno.
*------------------------------------------------------------

*------------------------------------------------------------
INIT_STAMINA:
*Descripción: Inicializa el valor de la stamina al maximo
*Entrada: Nada
*Salida: (STAMINA_ACTUAL) = maximo
*Registros modificados: nada
*------------------------------------------------------------

    MOVEM.L D0, -(A7)
    MOVE.W #STAMINA_MAX, STAMINA_ACTUAL
    MOVEM.L (A7)+, D0
    
    RTS
*------------------------------------------------------------
DIBUJAR_STAMINA:
*Descripción: Dibuja la barra de stamina con un marco
*Entrada: (STAMINA_ACTUAL)
*Salida:  nada
*Registros modificados: nada
*------------------------------------------------------------

    MOVEM.L D0-D6, -(A7)
        *Dibujamos la altura del relleno
    MOVE.W STAMINA_ACTUAL, D0
    MULU.W #STAMINA_ALTO_MAX, D0
    DIVU.W #STAMINA_MAX, D0 *altura del verde en d0
    
    
    *Punto de corte entre las dos partes
    MOVE.W #STAMINA_Y2, D6
    SUB.W D0, D6
    
        *Calculamos y1 (Y2-Altura)
    MOVE.W #STAMINA_Y2, D2
    SUB.W D0, D2
    
        *dibujamos la parte gris
    CMP.W #STAMINA_Y1, D6
    BLE .DIBUJAR_VERDE
    
    MOVE.W #STAMINA_X1, D1
    MOVE.W #STAMINA_Y1, D2
    MOVE.W #STAMINA_X2, D3
    MOVE.W D6, D4
    MOVE.L #COLOR_GRIS_MARCO, D5
    BSR DIBUJAR_RECTANGULO_RELLENO
    
.DIBUJAR_VERDE:


    CMP.W #STAMINA_Y2, D6
    BGE .FIN
    
    MOVE.W #STAMINA_X1, D1
    MOVE.W D6, D2
    MOVE.W #STAMINA_X2, D3
    MOVE.W #STAMINA_Y2, D4
    MOVE.L #COLOR_VERDE, D5
    BSR DIBUJAR_RECTANGULO_RELLENO
.FIN:
    MOVEM.L (A7)+, D0-D6
    RTS
*CONSUMIR_STAMINA:

*DAR_STAMINA:


*--------------------------------------------------------
*Variables
STAMINA_ACTUAL: DS.W 1
                DS.W 0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
