*-----------------------------------------------------------
*CONTADOR
*Contador del tiempo que saldrá a la izquierda arriba y se usará
*para poder ordenar el leaderboard y se escribirá ahi.
*-----------------------------------------------------------

PIXEL_TAM              EQU 3     
DIGITO_ESPACIO         EQU 20

*-----------------------------------------------------------
INIT_CONTADOR:
*Descripción: Reinicia el contador

*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------

    MOVEM.L D0-D1, -(A7)    
    CLR.W CONTADOR_SEGUNDOS
    CLR.W CONTADOR_MINUTOS
    
    BSR GUARDAR_TIEMPO_SISTEMA
    MOVE.L D1, ULTIMO_TIEMPO
    
    BSR DIBUJAR_CONTADOR
    MOVEM.L (A7)+, D0-D1
    
    RTS
    
*-----------------------------------------------------------
INCREMENTAR_SEGUNDO:
*Descripción: Aumenta un srgundo y cuando llega a 60 aumenta
*un minuto

*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------    

    MOVE.L D0, -(A7)
    ADD.W #1, CONTADOR_SEGUNDOS ;+1S
    CMP.W #60, CONTADOR_SEGUNDOS ; Son 60?
    BLT .FIN ;no, saltamos lo siguiente
    
    ;sí?
    CLR.W CONTADOR_SEGUNDOS ;segundos = 0
    ADD.W #1, CONTADOR_MINUTOS  ;minutos +1
    
.FIN
    MOVE.L (A7)+, D0
    RTS



*-----------------------------------------------------------
DIBUJAR_CONTADOR:
*Descripción:Dibuja el contador mostrando los mins, luego : y luego
* los segundos

*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D0-D5, -(A7)
    
    
    
    ;dibujamos rectangulo negro para el fondo para que no
    ;se superpongan al redibujar
    
    MOVE.W #CONTADOR_POS_X, D1
    MOVE.W #CONTADOR_POS_Y, D2
    
    MOVE.W #CONTADOR_POS_X, D3
    ADD.W #100, D3
    
    MOVE.W #CONTADOR_POS_Y, D4
    ADD.W #25, D4
    
    MOVE.L #$00000000, D5
    BSR DIBUJAR_RECTANGULO_RELLENO
    
    MOVE.W #CONTADOR_POS_X, D3 ; X = D3
    MOVE.W #CONTADOR_POS_Y, D4 ; Y = D4 
    MOVE.L #COLOR_BLANCO, D5 ;Elegimos color blancoç
    
    

    
    ;MINUTOS
    
    CLR.L D0
    MOVE.W CONTADOR_MINUTOS, D0            ;DECENAS
    DIVU.W #10, D0
    
    ;AL HACER DIVU
    ;Tenemos en la parte baja de d0 el cociente, es decir las decenas
    ;y en la alta el resto, las unidades
    
    MOVE.W D0, -(A7)
    BSR DIBUJAR_DIGITO_PIXEL
    ADD.W #DIGITO_ESPACIO, D3
    MOVE.W (A7)+, D0
    ;Miramos la otra parte, las unidades
    SWAP D0 
    BSR DIBUJAR_DIGITO_PIXEL            ;UNIDADES
    ADD.W #DIGITO_ESPACIO, D3
    
    ; (:)
    MOVE.W #10, D0          ;(10 = :)
    BSR DIBUJAR_DIGITO_PIXEL
    ADD.W #DIGITO_ESPACIO, D3
    
    ;SEGUNDOS
    
    CLR.L D0
    MOVE.W CONTADOR_SEGUNDOS, D0
    DIVU.W #10, D0
    
    MOVE.W D0, -(A7)
    BSR DIBUJAR_DIGITO_PIXEL
    ADD.W #DIGITO_ESPACIO, D3
    
    MOVE.W (A7)+, D0
    SWAP D0
    BSR DIBUJAR_DIGITO_PIXEL
    
    MOVEM.L (A7)+, D0-D5
    RTS
    
*-----------------------------------------------------------
ACTUALIAR_CONTADOR:
* Descripción: Mira el tiempo del sistema y si han pasado 100
* centésimas avanza 1 segundo el reloj
* Entrada: Nada
* Salida: Nada
* Registros modificados: nada
*-----------------------------------------------------------

    MOVEM.L D0-D2, -(A7)
    
    BSR GUARDAR_TIEMPO_SISTEMA
    MOVE.L D1, D2
    SUB.L ULTIMO_TIEMPO, D2
    CMP.L #100, D2 ;si es 100 pasó un segundo
    BLT .FIN
    
    ADD.W #1, CONTADOR_SEGUNDOS
    ADD.L #100, ULTIMO_TIEMPO
    
    CMP.W #60, CONTADOR_SEGUNDOS ;pasaron 60s?
    BLT .DIBUJAR ; si no va a dibujar
    CLR.W CONTADOR_SEGUNDOS ; si si sec = 0
    ADD.W  #1, CONTADOR_MINUTOS ; min++


.DIBUJAR:
    BSR DIBUJAR_CONTADOR    
.FIN:
    MOVEM.L (A7)+, D0-D2
    RTS
*-----------------------------------------------------------
DIBUJAR_DIGITO_PIXEL:
*Lee las matrices de los numeros mapeados de abajo y los dibuja
*Son 5x7 y hay una por cada digito y una para el ":".

*Entrada: D0.W = Digito a dibujar (Si es 10 es :)
*        D3.W = Coordenada x inicial
*        D4.W = Coord y inicial
*        D5.L = Color
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------


*LÓGICA DEL DIBUJO DE LOS NÚMEROS
*Buscará con a0 el número en memoria
*En FONT_DIGITOS hay 7 bytes por número, por lo que el
*numero a escribir se calculará como FONT_DIGITOS + (D0 * 7)
*teniendo en d0 el numero a escribir.

*Miraremos un bucle fila por fila y para las columnas miraremos
*en bucle el bit 4, si es 0 va a la siguiente columna, los mueve todos
* a la izquierda

* así irá mirando bit a  bit todos los píxeles, si es un 1, ha de mirar
* dónde pintarlo, y tenemos las coords X en D1 y D3, y las Y en D2 y D4.

*que serán multiplicadas por el tamaño del pixel y se le sumará su coordenada
*x o y inicial.
* Luego usamos la subrutina que dibuja el rectángulo en un bloque 3x3 o del tamaño
*del pixel que establezcamos en la pantalla
    MOVEM.L D0-D7/A0, -(A7)



    LEA FONT_DIGITOS, A0
    MULU.W #7, D0
    ADDA.L D0, A0

    CLR.W D6    ;D6 es el contador de filas (de 0 a 6)

.LOOP_FILAS:
    MOVE.B (A0)+, D1
    CLR.W D7 ;D7 es el de columnas
    
.LOOP_COL:
    BTST    #4, D1 ;Miramos si es 1
    BEQ     .SIG_COL
    
    MOVEM.L D1-D4, -(A7)
    
    ;X1 = Base X + (Columna * pixel_tam)
    
    MOVE.W D7, D1
    MULU.W #PIXEL_TAM, D1
    ADD.W D3, D1
    
    ;lo mismo con y
    
    MOVE.W D6, D2
    MULU.W #PIXEL_TAM, D2
    ADD.W D4, D2
    
    ;X2 = x1 + pixel_tam
    MOVE.W D1, D3
    ADD.W #PIXEL_TAM, D3
    
    ;Y2 = y1 + pixel:tam
    
    MOVE.W D2, D4
    ADD.W #PIXEL_TAM, D4
    
    BSR DIBUJAR_RECTANGULO_RELLENO
    MOVEM.L (A7)+, D1-D4
    
.SIG_COL:
    LSL.B #1, D1
    ADD.W #1, D7
    CMP.W #5, D7
    BLT .LOOP_COL
    
    ADD.W #1, D6
    CMP.W #7, D6
    BLT .LOOP_FILAS
    
    MOVEM.L (A7)+, D0-D7/A0
    RTS



*-----------------------------------------------------------    
*VARIABLES
*-----------------------------------------------------------    

CONTADOR_SEGUNDOS: DS.W 1
CONTADOR_MINUTOS:  DS.W 1
ULTIMO_TIEMPO: DS.L 1











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
