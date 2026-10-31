*-----------------------------------------------------------
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

T_LEER_CARACTER     EQU 5
T_LEER_TECLADO      EQU 7
T_LEER4_TECLADO     EQU 19
T_TIEMPO_SISTEMA    EQU 8
T_LEER_RATON        EQU 61

T_GRAF_INIT         EQU 33
T_GRAF_LIMPIAR      EQU 11
T_GRAF_PIXEL        EQU 82
T_GRAF_LINEA        EQU 83
T_GRAF_TEXTO        EQU 95
T_GRAF_ELIPSE       EQU 88
T_GRAF_RECT         EQU 87
T_PEN_COLOR         EQU 80
T_FILL_COLOR        EQU 81

T_CREAR_ARCHIVO     EQU 52
T_ABRIR_ARCHIVO     EQU 51
T_CERRAR_ARCHIVO    EQU 56
T_LEER_ARCHIVO      EQU 53
T_ESCRIBIR_ARCHIVO  EQU 54

T_PLAY_WAB_DIREC    EQU 70
T_CARGAR_SO         EQU 71
T_REPRO_SO          EQU 72
T_CTRL_SO           EQU 76

T_ESPERAR           EQU 32


T_POSICION_RATON    EQU 86
;FPS TOTALES
;por definir















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
