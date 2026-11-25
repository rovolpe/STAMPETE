*-----------------------------------------------------------
*DIBUJADO DEL MARCO
*Por ahora es muy simple
*-----------------------------------------------------------

MARCO_GROSOR    EQU 4
;El -1 y +1 para que esté fuera del area en el que puede ir el cowboy
MARCO_X1            EQU COWBOY_X_MIN-COWBOY_RADIO-1     ;izquierda
MARCO_X2            EQU COWBOY_X_MAX+COWBOY_RADIO+1     ;derecha
MARCO_Y1            EQU COWBOY_Y_MIN-COWBOY_RADIO-1     ;arriba
MARCO_Y2            EQU COWBOY_Y_MAX+COWBOY_RADIO+1     ;abajo


*-----------------------------------------------------------
DIBUJAR_MARCO:
*Descripcion: Dibuja las 4 barras blancas del marco
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D1-D5, -(A7)

    MOVE.L  #COLOR_BLANCO, D5

    ;Barra superior
    MOVE.W  #MARCO_X1-MARCO_GROSOR+1, D1
    MOVE.W  #MARCO_Y1-MARCO_GROSOR+1, D2
    MOVE.W  #MARCO_X2+MARCO_GROSOR-1, D3
    MOVE.W  #MARCO_Y1, D4
    BSR     DIBUJAR_RECTANGULO_RELLENO

    ;Barra inferior
    MOVE.W  #MARCO_X1-MARCO_GROSOR+1, D1
    MOVE.W  #MARCO_Y2, D2
    MOVE.W  #MARCO_X2+MARCO_GROSOR-1, D3
    MOVE.W  #MARCO_Y2+MARCO_GROSOR-1, D4
    BSR     DIBUJAR_RECTANGULO_RELLENO

    ;Barra izquierda
    MOVE.W  #MARCO_X1-MARCO_GROSOR+1, D1
    MOVE.W  #MARCO_Y1, D2
    MOVE.W  #MARCO_X1, D3
    MOVE.W  #MARCO_Y2, D4
    BSR     DIBUJAR_RECTANGULO_RELLENO

    ;Barra derecha
    MOVE.W  #MARCO_X2, D1
    MOVE.W  #MARCO_Y1, D2
    MOVE.W  #MARCO_X2+MARCO_GROSOR-1, D3
    MOVE.W  #MARCO_Y2, D4
    BSR     DIBUJAR_RECTANGULO_RELLENO

    MOVEM.L (A7)+, D1-D5
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
