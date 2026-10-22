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
* 1. INCLUIR LAOS OTROS MÓDULOS DE CÓDIGO
*-----------------------------------------------------------

    INCLUDE "CONST.X68"
    INCLUDE "SYSCONST.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "COWBOY.X68"
    INCLUDE "CACTUS.X68"
    INCLUDE "LEADERBOARD.X68"
    INCLUDE "STAMINA.X68"
    INCLUDE "CONTADOR.X68"
    INCLUDE "SONIDOS.X68"
    
*-----------------------------------------------------------
* 2. INCLUIR LOS MÓDULOS DE DATOS
*-----------------------------------------------------------
* Si metemos alguno más en el futuro

*-----------------------------------------------------------
* 3. INICIALIZAR
*-----------------------------------------------------------
START: 
        BSR INIT_SYSTEM ;Vamos a la subrutina de inicializar
                        ;el sistema SIN HACER
        BSR CARGAR_LEADERBOARD ; Cargamos los datos guardados
                               ; POR HACER
        BSR INICIALIZAR_MENU ; POR HACER
        MOVE.B #ESTADO_VAL_MENU, ESTADO_JUEGO ;CONSTANTES AUN
                                              ;SIN DEFINIR
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
    BEQ EJECUTAR_JUEGO ; POR HACER
    
    BRA APLICAR_FPS ;APLICAMOS LOS FPS QUE TOCAN POR HACER
    
                ;MENU

EJECUTAR_MENU:

    * ESTO IRA EN EL SYSTEM
    BSR LEER_TECLADO    ;POR HACER
    BSR LEER_RATON      ;POR HACER  
    BSR ACTUALIZAR_MENU ;POR HACER

    BSR LIMPIAR_PANTALLA ; POR HACER
    BSR DIBUJAR_MENU    ;POR HACER
    BRA APLICAR_FPS ;POR HACER

            ;JUEGO
EJECUTAR_JUEGO:

    * ESTO IRA EN EL SYSTEM
    BSR     LEER_TECLADO ;POR HACER
    BSR     LEER_RATON ;POR HACER

    BSR     ACTUALIZAR_COWBOY ;POR HACER
    BSR     ACTUALIZAR_CACTUS ;POR HACER
    BSR     ACTUALIZAR_STAMINA  ;POR HACER
    BSR     ACTUALIZAR_CONTADOR  ;POR HACER
    
    * PANTALLA
    BSR     LIMPIAR_PANTALLA ;POR HACER
    BSR     DIBUJAR_FONDO ;POR HACER
    BSR     DIBUJAR_CACTUS ;POR HACER
    BSR     DIBUJAR_COWBOY ; POR HACER
    BSR     DIBUJAR_STAMINA ;POR HACER
    BSR     DIBUJAR_CONTADOR ;POR HACER
    BRA     APLICAR_FPS ;POR HACER
    
EJECUTAR_LEADERBOARD:
    *ESTO EN EL SYSTEM
    BSR     LEER_RATON ;POR HACER 
    BSR     ACTUALIZAR_LEADERBOARD ;POR HACER


    BSR     LIMPIAR_PANTALLA ;POR HACER
    BSR     DIBUJAR_LEADERBOARD ;POR HACER
    BRA     APLICAR_FPS ;POR HACER
*-----------------------------------------------------------
* 5. ESPERAR A SINCRONIZACIÓN
*-----------------------------------------------------------
APLICAR_FPS:
    BSR     REGULAR_FPS ;POR HACER
    BRA     MAIN_LOOP   ;POR HACER
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
