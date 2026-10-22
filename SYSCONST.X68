T*-----------------------------------------------------------
*SYSCONST
*onstantes del sistema (Resolución...)
*-----------------------------------------------------------
;DIMENSIONES DE LA PANTALLA
PANTALLA_ANCHO      EQU 800
PANTALLA_ALTO       EQU 600
FPS_OBJETIVO        EQU 60


;ESTADOS DEL JUEGO

ESTADO_VAL_MENU     EQU 0
ESTADO_VAL_JUEGO            EQU 1
ESTADO_VAL_LEADERBOARD    EQU 2


;TAREAS DEL TRAP #15 Para acordarse

T_LEER_CARACTER     EQU 4
T_LEER_TECLADO      EQU 5

T_GRAF_INIT         EQU 80
T_GRAF_LIMPIAR      EQU 81
T_GRAF_PIXEL        EQU 82
T_GRAF_LINEA        EQU 83
T_GRAF_TEXTO        EQU 84

T_ABRIR_ARCHIVO     EQU 51
T_CERRAR_ARCHIVO    EQU 52
T_LEER_ARCHIVO      EQU 53
T_ESCRIBIR_ARCHIVO  EQU 54

T_SONIDO            EQU 72


T_POSICION_RATON    EQU 86
;FPS TOTALES
;por definir







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
