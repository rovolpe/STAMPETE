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
    BSR     BORRAR_PANTALLA
    BSR     PEDIR_NOMBRE
    BSR     INIT_STAMINA
    BSR     INIT_CONTADOR
    MOVE.B  #ESTADO_VAL_JUEGO, ESTADO_JUEGO
    BRA     .FIN
    
.ACCION_LEADERBOARD:
    MOVE.B  #ESTADO_VAL_LEADERBOARD , ESTADO_JUEGO
    BRA     .FIN
    
.FIN:
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
    
    BRA     .FIN        
    *COMPRUEBAS SI (MOUSE_CLICK) SE HA PRODUCIDO
    *SINO SALTAS
    
.NO_PULSADO:
    CLR.B D0

.FIN:
    MOVEM.L (A7)+, D1-D2
    RTS
    

PEDIR_NOMBRE:
    MOVEM.L D0-D2/A0, -(A7)
    
    LEA MENSAJE_INTRO, A0
    MOVE.W #180, D0 ;Ponemos la coord y como 180
    BSR MOSTRAR_TEXTO_CENTRADO
    
    MOVE.W #300, TEXTO_CURSOR_X
    MOVE.W #240, TEXTO_CURSOR_Y
    
    MOVE.W #0, LETRA_CONT
.ESPERAR_TECLA:
    ;Leemos la tecla
    BSR LEER_TECLADO_MENU
    ;Metemos el valor ascii en la memoria
    MOVE.B TECLA_ASCII, D0
    ;Si es 0 volvemos al bucle hasta que se introduzca
    CMP.B #0, D0
    BEQ .ESPERAR_TECLA
    
    AND.W #$00FF, D0
    
    ;Si es minusculas lo ponemos en mayusculas
    CMP.W   #97, D0             
    BLT     .FILTRO_MAYUSCULAS  
    CMP.W   #122, D0            
    BGT     .FILTRO_MAYUSCULAS
    SUB.W   #32, D0
    
.FILTRO_MAYUSCULAS:
    CMP.W   #65, D0             
    BLT     .ESPERAR_LIBERACION 
    CMP.W   #90, D0             
    BGT     .ESPERAR_LIBERACION
    
    ;La guardamos en la posición del array de 4 letras
    MOVE.W LETRA_CONT, D1
    LEA JUGADOR_NOMBRE, A0
    MOVE.B D0, 0(A0, D1.W) ;la posicion D1 de jugador_nombre será 
                           ;el varor D1 ascii.
                                 
    BSR DIBUJAR_LETRA
    
    ADDQ.W #1, LETRA_CONT ; LETRA_CONT++
    CMP.W #4, LETRA_CONT ;Si es el cuarto ya termina
    BGE .FIN_PEDIR_NOMBRE 
    
.ESPERAR_LIBERACION:
    ;Esperamos a que se suelte la tecla para que no ponga muchas veces
    ;la misma tecla por pulsarla
    BSR LEER_TECLADO_MENU
    TST.B TECLA_ASCII
    BNE .ESPERAR_LIBERACION
    
    BRA .ESPERAR_TECLA
    
.FIN_PEDIR_NOMBRE
.ESP_LIB_FIN:
    BSR     LEER_TECLADO_MENU
    TST.B   TECLA_ASCII
    BNE     .ESP_LIB_FIN
    BSR     ESPERAR_1S
    BSR BORRAR_PANTALLA
    MOVE.B #ESTADO_VAL_JUEGO, ESTADO_JUEGO
    
    MOVEM.L (A7)+, D0-D2/A0
    RTS
    

*Ha de cambiar el estado del juego al de leaderboard
    
*guarda la variable del nombre del jugador y su longitud

*VARIABLES
JUGADOR_NOMBRE: DS.B 4 ;4 LETRAS DE NOMBRE ASI RETRO
LETRA_CONT:     DS.W 1 ;CONTADOR DE LETRAS INTRODUCIDAS

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
