*-----------------------------------------------------------
*CONST
*Contiene las constantes (coordenadas, colores...)
*-----------------------------------------------------------
;CONSTANTES DEL COWBOY
COWBOY_INIT_X        EQU 384 ;Puse eso por poner
COWBOY_INIT_Y        EQU 436 ;lo mismo
COWBOY_VELOCIDAD     EQU 15
COWBOY_RADIO      EQU 15 ;Por ahora es un circulo

;CONSTANTES DEL CACTUS
MAX_CACTUS           EQU 4
CACTUS_ANCHO         EQU 40
CACTUS_ALTO          EQU 70
SPAWN_TIEMPO         EQU 120

ESTADO_CACTUS_NORMAL EQU 0
ESTADO_CACTUS_FLOR   EQU 1

;CONSTANTES DE LA BARRA DE STAMINA

STAMINA_MAX          EQU 5000
STAMINA_RITMO        EQU 3
STAMINA_RESTA_CACTUS EQU 20
STAMINA_SUMA_FLOR    EQU 25
STAMINA_X1           EQU 760
STAMINA_Y1           EQU 50
STAMINA_X2           EQU 780
STAMINA_Y2           EQU 550
STAMINA_ALTO_MAX     EQU (STAMINA_Y2-STAMINA_Y1)

;CRONOMETRO
CONTADOR_POS_X       EQU 20
CONTADOR_POS_Y       EQU 50

;MENU
BTN_JUGAR_X1         EQU 300
BTN_JUGAR_Y1         EQU 220
BTN_JUGAR_X2         EQU 500
BTN_JUGAR_Y2         EQU 280

BTN_LEADERBOARD_X1   EQU 300
BTN_LEADERBOARD_Y1   EQU 420
BTN_LEADERBOARD_X2   EQU 500
BTN_LEADERBOARD_Y2   EQU 480

;COLORES
COLOR_NEGRO             EQU $00000000
COLOR_BLANCO            EQU $00FFFFFF
COLOR_ROJO              EQU $000000FF
COLOR_VERDE             EQU $0000FF00
COLOR_AZUL              EQU $00FF0000
COLOR_VERDE_CACTUS      EQU $00108020
COLOR_AMARILLO_FLOR     EQU $0000D7FF
COLOR_FONDO             EQU $0080C0FF
COLOR_GRIS_MARCO        EQU $00808080


;Me he inventado algunos pero habría que poner  
;uno por audio
*EFECTOS DE SONIDO: IDS
ID_SND_DISPARO  EQU 0
ID_SND_FLOR     EQU 1
ID_SND_HERIDO   EQU 2
ID_SND_COMER    EQU 3
     
                         
COWBOY_X_MIN    EQU 40
COWBOY_X_MAX    EQU 700
COWBOY_Y_MIN    EQU 120
COWBOY_Y_MAX    EQU 530
                         
COWBOY_DELAY_MAX    EQU 1 ;El cooldown para que se mueva el cowboy, lo añadi porque se movia demasiado rapido
STAMINA_DELAY_MAX   EQU 33 ;LO MISMO PARA LA BARRA DE STAMINA

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
