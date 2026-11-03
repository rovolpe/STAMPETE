*-----------------------------------------------------------
*COWBOY
*Es el jugador.
*Se puede mover hacia las cuatro direcciones utilizando WASD
*Puede disparar en la dirección de donde se hace click con el ratón
*?? Dirección o al punto exacto ?? Lo haria sobre el punto exacto 
*que creo que seria mas facil

*-----------------------------------------------------------
COWBOY_INIT:
*-----------------------------------------------------------
    MOVE.L D0, -(A7)
    ;Coordenadas pasan a ser las iniciales
    ;Las hacemos aleatorias? 
    MOVE.W   #COWBOY_INIT_X, COWBOY_POS_X
    MOVE.W   #COWBOY_INIT_Y, COWBOY_POS_Y
    
    
    MOVE.W  #COWBOY_INIT_X, COWBOY_PREV_X
    MOVE.W  #COWBOY_INIT_Y, COWBOY_PREV_Y

    MOVE.L (A7)+, D0
    RTS
*-----------------------------------------------------------
COWBOY_ERASE:

*Descripción: Borra el dibujo del cowboy
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D1-D5, -(A7)

    MOVE.W  COWBOY_PREV_X, D1
    SUB.W   #COWBOY_RADIO, D1
    MOVE.W  COWBOY_PREV_Y, D2
    SUB.W   #COWBOY_RADIO, D2
    MOVE.W  COWBOY_PREV_X, D3
    ADD.W   #COWBOY_RADIO, D3
    MOVE.W  COWBOY_PREV_Y, D4
    ADD.W   #COWBOY_RADIO, D4
    MOVE.L  #$00000000, D5  
    BSR     DIBUJAR_ELIPSE

    MOVEM.L (A7)+, D1-D5
    RTS    
*-----------------------------------------------------------
COWBOY_DRAW:
*Descripción: Dibuja el cowboy en las coordenadas que hay en memoria
*Y las calcula
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D1-D5, -(A7)
    
    ;Para hacer un circulo con lo de la elipse hay que hacer
    ;una elipse que esté contenida en las coordenads
    ;de un cuadrado. Por ello
    
    ;X1 = POS_X - RADIO
    ;Y1 = POS_Y - RADIO
    
    ;X2 = POS_Y + RADIO
    ;Y2 = POS_Y + RADIO
    MOVE.W COWBOY_POS_X, D1
    SUB.W #COWBOY_RADIO, D1
   
    MOVE.W COWBOY_POS_Y, D2
    SUB.W #COWBOY_RADIO, D2
    
    MOVE.W COWBOY_POS_X, D3
    ADD.W #COWBOY_RADIO, D3
    
    MOVE.W COWBOY_POS_Y, D4
    ADD.W #COWBOY_RADIO, D4
    
    MOVE.L #COLOR_ROJO, D5
    BSR DIBUJAR_ELIPSE
    
    MOVEM.L (A7)+, D1-D5
    RTS
*-----------------------------------------------------------
COWBOY_DET_MOV:

*Descripción: Detecta el movimiento del jugador segun WASD y devuelve
* en D0 y D1 las coords X e Y de la posicion nueva a la que tendria que moverse
*Entrada: nada
*Salida: D0 y D1 coords
*Registros modificados: D0 y D1
*-----------------------------------------------------------  

*Recordatorio de como funciona el lector de WASD:
* Tenemos 4 bits que detectan la WASD en ese orden.
  
        MOVE.L D2, -(A7)
        
        BSR LEER_TECLADO_JUEGO
        MOVE.B ESTADO_WASD, D2
        
        MOVE.W COWBOY_POS_X, D0
        MOVE.W COWBOY_POS_Y, D1
        ;VERTICAL
        BTST #3, D2 ;MIRAMOS LA W
        BEQ     .CHECK_S
        SUB.W   #COWBOY_VELOCIDAD, D1 
        BRA     .CHECK_HORIZONTAL
.CHECK_S:
        BTST    #1, D2
        BEQ     .CHECK_HORIZONTAL
        ADD.W   #COWBOY_VELOCIDAD, D1

.CHECK_HORIZONTAL:

        BTST    #2, D2  
        BEQ     .CHECK_D
        SUB.W   #COWBOY_VELOCIDAD, D0 
        BRA     .FIN

.CHECK_D:
        BTST    #0, D2  
        BEQ     .FIN

        ADD.W   #COWBOY_VELOCIDAD, D0  
.FIN:
        MOVE.L (A7)+, D2
        RTS
*-----------------------------------------------------------
COWBOY_UPDATE_COORDS:

*Descripción: Te actualiza las coordenadas del cowboy teniendo
*en cuenta las colisiones con los bordes de la pantalla
*Entrada: D0 = X D1 = Y ya calculadas (COORDS NUEVAS)
*Salida: NADA
*Registros modificados: nada (pero actualiza las posiciones de memoria)
*-----------------------------------------------------------
        
        
        ;Colisiones con los bordes de la pantalla
        
        ;DETECCIÓN CON LADOS DERECHO E IZQUIERDO

        CMP.W #COWBOY_X_MAX, D0
        BGT   .COL_X
        CMP.W #COWBOY_X_MIN, D0
        BLT .COL_X
        BRA .GUARDAR_X

        
        ;COLISIÓN X(En coord X no se moverá)
.COL_X:
        MOVE.W COWBOY_POS_X, D0
        
.GUARDAR_X:
        MOVE.W D0, COWBOY_POS_X
        
        ;MIRAMOS ARRIBA Y ABAJO
        CMP.W #COWBOY_Y_MAX, D1
        BGT .COL_Y
        CMP.W #COWBOY_Y_MIN, D1
        BLT   .COL_Y
        BRA   .GUARDAR_Y
        ;COLISIÓN Y
.COL_Y:
        MOVE.W COWBOY_POS_Y, D1
.GUARDAR_Y:
        MOVE.W D1, COWBOY_POS_Y
        
        RTS
        
*-----------------------------------------------------------
COWBOY_UPDATE:
*Descripción: Esto detectará si se han cambiado las coordenadas
* Y si se ha hecho lo moverá borrando y redibujando
* En las nuevas teniendo en cuenta las colisiones con los bordes
*-----------------------------------------------------------

    MOVEM.L D0-D3, -(A7)
    
    ;Guardamos la opsicion anterior para borrarla
    MOVE.W  COWBOY_POS_X, COWBOY_PREV_X
    MOVE.W  COWBOY_POS_Y, COWBOY_PREV_Y
    
    
    BSR COWBOY_DET_MOV
    BSR COWBOY_UPDATE_COORDS
    MOVEM.L (A7)+, D0-D3
    RTS
*-----------------------------------------------------------
BULLET_INIT
*-----------------------------------------------------------

*Gestiona un cooldown (supongo)
*Comprueba si hizo click y busca donde
*Crea la bala

*-----------------------------------------------------------
BULLET_UPDATE
*-----------------------------------------------------------
*Mover las balas a la coordenada clickada
*Bucle que comprueba cuando borrarla (si choca o se va fuera
* de la pantalla)
*borrar la bala




*-----------------------------------------------------------
*6. VARIABLES
*-----------------------------------------------------------
*COORDENADAS
COWBOY_POS_X: DS.W 1
COWBOY_POS_Y: DS.W 1

COWBOY_PREV_X: DS.W 1
COWBOY_PREV_Y: DS.W 1
*coord de las balas

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
