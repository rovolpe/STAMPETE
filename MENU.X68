*-----------------------------------------------------------
*MENU
*Menu que abrirá o el juego o el leaderboard.
*Pedirá al usuario introducir por teclado su nombre al inicio
*de cada juego para luego escribir en terminar la partida.


*SUBRUTINAS:

*MOSTRAR_MENU
*BORRAR_MENU
*PROCESAR_MENU
*-----------------------------------------------------------
    

    

*-----------------------------------------------------------
MOSTRAR_MENU:
*Muestra el menu

*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------

    MOVE.B #0, ESTADO_JUEGO
    MOVEM.L D0-D5, -(A7)
    MOVE.W #BTN_JUGAR_X1, D1
    MOVE.W #BTN_JUGAR_Y1, D2
    MOVE.W #BTN_JUGAR_X2, D3
    MOVE.W #BTN_JUGAR_Y2, D4
    MOVE.L #$00FF0000, D5
    
    BSR DIBUJAR_RECTANGULO_RELLENO
    
    
    MOVE.W #BTN_LEADERBOARD_X1, D1
    MOVE.W #BTN_LEADERBOARD_Y1, D2
    MOVE.W #BTN_LEADERBOARD_X2, D3
    MOVE.W #BTN_LEADERBOARD_Y2, D4
    MOVE.L #$000000FF, D5
    
    BSR DIBUJAR_RECTANGULO_RELLENO
    MOVEM.L (A7)+, D0-D5
    RTS

*-----------------------------------------------------------
BORRAR_MENU:
*Borra el menu

*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    
RTS

*-----------------------------------------------------------
PROCESAR_MENU:
*Analiza que se pulsa en el menu y va a realizar cada accion
*en cada caso

*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------

    MOVE.L D0, -(A7)
    
    BSR TST_CLICK_JUGAR
    TST.B D0
    BNE .ACCION_JUGAR
    
    BSR TST_CLICK_LEADERBOARD
    TST.B D0
    BNE .ACCION_LEADERBOARD
    
    BRA .FIN
    
.ACCION_JUGAR:
    BSR     BORRAR_MENU
    BSR     PEDIR_NOMBRE
    MOVE.B  #1, ESTADO_JUEGO
    BRA     .FIN
    
.ACCION_LEADERBOARD
    MOVE.B  #2 , ESTADO_JUEGO
    BRA     .FIN
    
.FIN
    MOVE.L (A7)+, D0
    RTS
*-----------------------------------------------------------
TST_CLICK_JUGAR:
*Analiza si el ratón está dentro del rectangulo de jugar

*Entrada: (MOUSE_X), (MOUSE_Y), (MOUSE_CLICK)
*Salida: D0.B = 1 si se ha pulsado dentro del boton, sino 0
*Registros modificados: D0
*-----------------------------------------------------------
    MOVEM.L D1-D2, -(A7) ;Guardamos los registros
    BSR LEER_RATON ;Actualiza (MOUSE_X)
    ;(MOUSE_Y) Y (MOUSE_CLICK)
    
    ;Primero miramos si se ha clickado
    MOVE.B MOUSE_CLICK, D0
    BTST #0, D0
    BEQ .NO_PULSADO

    MOVE.W MOUSE_X, D1
    SUB.W #BTN_JUGAR_X1, D1     *MOUSE_X - BTN_JUGAR_X1
    BMI     .NO_PULSADO        *Si es negativo salta
    
        
    MOVE.W #BTN_JUGAR_X2, D1
    SUB.W MOUSE_X, D1  *MOUSE_X - BTN_JUGAR_X2
    BMI     .NO_PULSADO
    
    
    MOVE.W MOUSE_Y, D2
    SUB.W #BTN_JUGAR_Y1, D2     *MOUSE_Y - BTN_JUGAR_Y1
    BMI .NO_PULSADO
        
        
    MOVE.W #BTN_JUGAR_Y2, D2
    SUB.W MOUSE_Y, D2     *MOUSE_Y - BTN_JUGARY2
    BMI .NO_PULSADO
    
    MOVE.B #1, D0
    BRA     .FIN        
    *COMPRUEBAS SI (MOUSE_CLICK) SE HA PRODUCIDO
    *SINO SALTAS
    
.NO_PULSADO:
    CLR.B D0

.FIN:
    MOVEM.L (A7)+, D1-D2
    RTS
    

*-----------------------------------------------------------
TST_CLICK_LEADERBOARD:
*Analiza si el ratón está dentro del rectangulo de jugar

*Entrada: (MOUSE_X), (MOUSE_Y), (MOUSE_CLICK)
*Salida: D0.B = 1 si se ha pulsado dentro del boton, sino 0
*Registros modificados: D0
*-----------------------------------------------------------
    MOVEM.L D1-D2, -(A7) ;Guardamos los registros
    BSR LEER_RATON ;Actualiza (MOUSE_X)
    ;(MOUSE_Y) Y (MOUSE_CLICK)
    
    ;Primero miramos si se ha clickado
    MOVE.B MOUSE_CLICK, D0
    BTST #0, D0
    BEQ .NO_PULSADO

    MOVE.W MOUSE_X, D1
    SUB.W #BTN_LEADERBOARD_X1, D1     *MOUSE_X - BTN_JUGAR_X1
    BMI     .NO_PULSADO        *Si es negativo salta
    
        
    MOVE.W #BTN_LEADERBOARD_X2, D1
    SUB.W MOUSE_X, D1  *MOUSE_X - BTN_JUGAR_X2
    BMI     .NO_PULSADO
    
    
    MOVE.W MOUSE_Y, D2
    SUB.W #BTN_LEADERBOARD_Y1, D2     *MOUSE_Y - BTN_JUGAR_Y1
    BMI .NO_PULSADO
        
        
    MOVE.W #BTN_LEADERBOARD_Y2, D2
    SUB.W MOUSE_Y, D2     *MOUSE_Y - BTN_JUGARY2
    BMI .NO_PULSADO
    
    MOVE.B #1, D0
    
    
    *Quitar luego, si se ha pulsado lo pinta de verde 
        *para testing
    MOVEM.L D0-D5, -(A7)
    MOVE.W #BTN_LEADERBOARD_X1, D1
    MOVE.W #BTN_LEADERBOARD_Y1, D2
    MOVE.W #BTN_LEADERBOARD_X2, D3
    MOVE.W #BTN_LEADERBOARD_Y2, D4
    MOVE.L #$0000FF00, D5
    
    BSR DIBUJAR_RECTANGULO_RELLENO
    MOVEM.L (A7)+, D0-D5
    BRA     .FIN        
    *COMPRUEBAS SI (MOUSE_CLICK) SE HA PRODUCIDO
    *SINO SALTAS
    
.NO_PULSADO:
    CLR.B D0

.FIN:
    MOVEM.L (A7)+, D1-D2
    RTS
    

PEDIR_NOMBRE:
*Ha de mostrar un menu en el que pide un nombre, se
*ha de introducir y luego ha de cambiar el estado
*del juego al de jugar
    MOVEM.L D0-D5, -(A7)
    MOVE.W #BTN_JUGAR_X1, D1
    MOVE.W #BTN_JUGAR_Y1, D2
    MOVE.W #BTN_JUGAR_X2, D3
    MOVE.W #BTN_JUGAR_Y2, D4
    MOVE.L #$0000FF00, D5
    
    BSR DIBUJAR_RECTANGULO_RELLENO
    MOVEM.L (A7)+, D0-D5
    RTS
    

*Ha de cambiar el estado del juego al de leaderboard
    
*guarda la variable del nombre del jugador y su longitud









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
