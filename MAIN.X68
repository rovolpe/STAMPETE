w    *-----------------------------------------------------------
*MAIN
*Aquí se verificarán os estados de todo el juego y decidirá
*a que subrutinas llamar.

*CONTROL DE FPS SE APLICA AQUÍ;
*Esto lo mide en centesimas de segundo, por lo que para pasarlos 
*a FPS con la relación de que 100 / FPS = Centésimas de pausa

*El enunciado pide que sea cómodo de cambiar en formato de FPS, por
*lo que yo crearía una variable de FPS y luego una subrutina que calcule
*las centesimas de segundo que meter en D1 para el trap #15 tarea 33 para
*que equivalga a estos FPS.
*-----------------------------------------------------------
    ORG    $1000

*-----------------------------------------------------------
* 1. INCLUIR LOS MÓDULOS DE CONSTANTES
*-----------------------------------------------------------

    INCLUDE "CONST.X68"
    INCLUDE "SYSCONST.X68"

*-----------------------------------------------------------
* 2. INICIALIZAR
*Inicializamos todo, y una vez inicializado ponemos el estado
*Del juego como el estado del menú, ya que empieza en el menú
*-----------------------------------------------------------
START: 
        BSR INIT_SYSTEM 
        BSR INIT_SONIDOS
        BSR INIT_LEADERBOARD
        BSR CACTUS_CARGAR_PATRONES
        BSR CACTUS_INIT
        BSR COWBOY_INIT
        BSR INIT_CONTADOR
        BSR INIT_STAMINA
        MOVE.B #ESTADO_VAL_MENU, ESTADO_JUEGO
*-----------------------------------------------------------
*Bucle principal que según el estado ejecuta cada parte del
*juego

MAIN_LOOP:
* Lee el teclado  el ratón

    BSR     LEER_RATON
    BSR     LEER_TECLADO_JUEGO
    
    
* ACTUALIZAR LA LÓGICA

    MOVE.B ESTADO_JUEGO, D0 ;Metemos el estado en D0 para
                            ;comparar
    CMP.B #ESTADO_VAL_MENU, D0 ;Si es el del menu lo ejecuta
    BEQ LOGICA_MENU 
    
    CMP.B #ESTADO_VAL_JUEGO, D0 ;Si es el juego lo ejecuta
    BEQ LOGICA_JUEGO 
    
    CMP.B #ESTADO_VAL_LEADERBOARD, D0 ;Si es leaderboard lo mismo
    BEQ LOGICA_LEADERBOARD ; 
    
    ;Que vaya a la fase de dibujo sí o sçi
    BRA     FASE_DIBUJO
        


    ;Lógica del menú
LOGICA_MENU:
    ;PROCESAR_MENU hace toda la lógica de este
    BSR PROCESAR_MENU
    ;Va a la fase de dibujo
    BRA FASE_DIBUJO




    ;Lógica del juego
LOGICA_JUEGO:
    ;Reproducimos el sonido
    MOVE.B  #SND_PRUEBA, D1
    BSR REPRODUCIR_SONIDO
    
    ;Actualizamos el contador
    BSR ACTUALIAR_CONTADOR
    
    ;Consumimos y redibujamos la stamina
    BSR CONSUMIR_STAMINA
    BSR DIBUJAR_STAMINA
    
    ;Actualizamos las coordenadas del jugador y los cactus
    BSR COWBOY_UPDATE
    BSR CACTUS_UPDATE
    
    ;Vamos a la fase de dibujo
    BRA FASE_DIBUJO
    
    
    ;Lógica del laderboard
LOGICA_LEADERBOARD:
    BSR     TST_CLICK_SALIR
    BRA FASE_DIBUJO
    
    
;DIBUJAR EL JUEGO
FASE_DIBUJO:
    ;MIRAS QEUE DIBUJAR
    MOVE.B  ESTADO_JUEGO, D0
    CMP.B   #ESTADO_VAL_MENU, D0
    BEQ     DIBUJAR_MENU
    CMP.B   #ESTADO_VAL_JUEGO, D0
    BEQ     DIBUJAR_JUEGO
    CMP.B   #ESTADO_VAL_LEADERBOARD, D0
    BEQ     DIBUJAR_LB
    BRA     FASE_SYNC

DIBUJAR_MENU:
    BSR     MOSTRAR_MENU        
    BRA     FASE_SYNC

DIBUJAR_JUEGO:

    BSR     DIBUJAR_STAMINA
    BSR     DIBUJAR_CONTADOR
    BSR     DIBUJAR_MARCO
    BSR     DIBUJAR_CACTUS
    
    ;Dibuja el cowboy solo si se ha movido
    MOVE.W  COWBOY_POS_X, D0
    CMP.W   COWBOY_PREV_X, D0
    BNE     .HACER_CAMBIO
    
    MOVE.W  COWBOY_POS_Y, D0
    CMP.W   COWBOY_PREV_Y, D0
    
    BEQ     .FIN_DIBUJO_CWB ;NO LO DIBUJA SY X e Y son iguales
    
.HACER_CAMBIO:
    BSR COWBOY_ERASE
    BSR COWBOY_DRAW
    
    MOVE.W  COWBOY_POS_X, COWBOY_PREV_X
    MOVE.W  COWBOY_POS_Y, COWBOY_PREV_Y
    
.FIN_DIBUJO_CWB

    BRA     FASE_SYNC

DIBUJAR_LB:
    BSR     DIBUJAR_LEADERBOARD
    BRA     FASE_SYNC
*-----------------------------------------------------------
* 5. ESPERAR A SINCRONIZACIÓN
*-----------------------------------------------------------
FASE_SYNC:
        BSR     ESPERAR_FPS   
        BRA     MAIN_LOOP 
*-----------------------------------------------------------    
* 6. VARIABLES DE ESTADO
*-----------------------------------------------------------
                 DS.W    0
ESTADO_JUEGO:    DS.B    1
                 DS.W    0


*-----------------------------------------------------------
* 7. INCLUIR MÓDULOS CODIGO
*-----------------------------------------------------------

    INCLUDE "SYSTEM.X68"
    
    INCLUDE "MENU.X68"

    INCLUDE "CACTUS.X68"
    
    INCLUDE "MARCO.X68"

    INCLUDE "LEADERBOARD.X68"

    INCLUDE "STAMINA.X68"

    INCLUDE "CONTADOR.X68"

    INCLUDE "SONIDOS.X68"
    
    INCLUDE "COWBOY.X68"
    
    INCLUDE "FUENTES.X68"
    
    SIMHALT             ; halt simulator



    END    START        ; last line of source































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
