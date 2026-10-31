    *-----------------------------------------------------------
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

*Esto se guardaría en SYSCONST ya que es uan constante del sistema entero.
*-----------------------------------------------------------
    ORG    $1000

*-----------------------------------------------------------
* 1. INCLUIR LAOS OTROS MÓDULOS DE CONSTANTES
*-----------------------------------------------------------

    INCLUDE "CONST.X68"
    INCLUDE "SYSCONST.X68"
    INCLUDE "MENU.X68"
    
*-----------------------------------------------------------
* 2. INCLUIR LOS MÓDULOS DE DATOS
*-----------------------------------------------------------
* Si metemos alguno más en el futuro

*-----------------------------------------------------------
* 1. INICIALIZAR
*-----------------------------------------------------------
START: 
        BSR INIT_SYSTEM ;Vamos a la subrutina de inicializar
                        ;el sistema SIN HACER
        MOVE.B #ESTADO_VAL_MENU, ESTADO_JUEGO
        BSR     MOSTRAR_MENU
*-----------------------------------------------------------
* 4. ACTUALIZAR
*-----------------------------------------------------------
*Bucle principal que según el estado ejecuta cada parte del
*juego

MAIN_LOOP:
    MOVE.B ESTADO_JUEGO, D0 ;Metemos el estado en D0 para
                            ;comparar
    CMP.B #ESTADO_VAL_MENU, D0 ;Si es el del menu lo ejecuta
    BEQ EJECUTAR_MENU ; POR HACER
    
    CMP.B #ESTADO_VAL_JUEGO, D0 ;Si es el juego lo ejecuta
    BEQ EJECUTAR_JUEGO ;POR HACER
    
    CMP.B #ESTADO_VAL_LEADERBOARD, D0 ;Si es leaderboard lo mismo
    BEQ EJECUTAR_LEADERBOARD ; POR HACER
    
    BRA APLICAR_FPS ;APLICAMOS LOS FPS QUE TOCAN POR HACER
    
                ;MENU

EJECUTAR_MENU:
    BSR PROCESAR_MENU
    BRA APLICAR_FPS

            ;JUEGO
EJECUTAR_JUEGO:
    BRA APLICAR_FPS
EJECUTAR_LEADERBOARD:
*-----------------------------------------------------------
* 5. ESPERAR A SINCRONIZACIÓN
*-----------------------------------------------------------
APLICAR_FPS:
        BSR     ESPERAR_FPS   
        BRA     MAIN_LOOP 
*-----------------------------------------------------------    
* 6. VARIABLES DE ESTADO
*-----------------------------------------------------------
ESTADO_JUEGO:    DS.B    1
                 DS.W    0


*-----------------------------------------------------------
* 7. INCLUIR MÓDULOS CODIGO
*-----------------------------------------------------------

    INCLUDE "SYSTEM.X68"

    INCLUDE "COWBOY.X68"

    INCLUDE "CACTUS.X68"

    INCLUDE "LEADERBOARD.X68"

    INCLUDE "STAMINA.X68"

    INCLUDE "CONTADOR.X68"

    INCLUDE "SONIDOS.X68"
    
    SIMHALT             ; halt simulator



    END    START        ; last line of source














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
