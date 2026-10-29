*-----------------------------------------------------------
*CACTUS
*Lógica de los cactus.
*Se moverán en la coordenada Y (simulando que se mueve el jugador)
*tendrán dos estados:

*el primero default en el que hay colisión con él
*y si lo tocas te baja la stamina y te ralentiza

*el segundo en el que es disparado en el que tiene una flor
*que desaparece si la tocan y aumenta la stamina del jugador.

*-----------------------------------------------------------



*-----------------------------------------------------------
CACTUS_INIT
*-----------------------------------------------------------

*INICIALIZAR CACTUS
*   Resetear el temporizador de generación
*   Desactivar todos los cactus de memoria

.CACTUS_GEN

*-----------------------------------------------------------
CACTUS_UPDATE
*-----------------------------------------------------------

*UNA SUBRUTINA PRINCIPAL QUE ACUALIZA EL CACTUS
*   Genera el cactus
*        Comprueba el temporizador, si es el momento genera uno

*   Mover el cactus
*       Al bucle de cactus activos le reduce a todos la coordenada Y
*       Si se va fuera de la pantalla por debajo libera el slot de ese 
*       cactus para que se puega generar otro

*   Detectar disparos
*       Si una bala lo toca cambia el estado a con flor y destruye la bala

*   Detectar colisión con el jugador
*       Si colisiona y el estado es normal resta stamina y ralentiza al cowboy 
*       Y si es una flor suma la stamina y libera el slot del cactus

.CACTUS_UPDT_NORMAL
    RTS
.CACTUS_UPDT_FLOR
    RTS

* CONSTANTES DE ESTADOS


* CONSTANTE DE NÚMERO MÁXIMO DE CACTUS AL MISMO TIEMPO^
* TEMPORIZADOR DE GENERACIÓN DE CACTUS

*COORDENADAS DEL CACTUS
*-----------------------------------------------------------
*4. VARIABLES DEL CACTUS
*-----------------------------------------------------------
*Temporizador
*Si está activo o no
*Coords X e Y
*Estado del cactus




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
