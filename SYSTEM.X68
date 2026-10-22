*-----------------------------------------------------------
*SYSTEM

*Inicializa la pantalla, accede a periféricos...
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* INICIALIZA LA PANTALLA
INIT_SYSTEM:
    MOVE.B  #T_GRAF_INIT, D0
    MOVE.W  #PANTALLA_ANCHO, D1
    MOVE.W  #PANTALLA_ALTO, D2
    TRAP    #15
    
    CLR.B   TECLA_PULSADA
    CLR.W   MOUSE_X
    CLR.W   MOUSE_Y
    CLR.B   MOUSE_CLIC
    RTS
    
    
* REGULA LOS FPS
* LIMPIA LA PANTALLA
* DIBUJA EL FONDO

* LEER EL TECLADO (PARA EL JUEGO WASD)
* LEER EL TECLADO (PARA INTRODUCIR NOMBRE)
* LEER EL RATON 


*LEER Y ESCRIBIR EN EL DISCO DURO (PARA LEADERBOARD)
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
