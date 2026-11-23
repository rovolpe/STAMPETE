*-----------------------------------------------------------
*LEADERBOARD

*Este es el módulo en el que implementaremos la gestión de 
*Ficheros de nuestro programa

*Hará dos cosas al acabar una partida:

*+-Escribe en un archivo los datos de un usuario, guardando su nombre y
*su total de tiempo.
*-Reordena el archivo de leaderboard para que estén ordenados en top

*Cuando entra en el inicio al apartado de leaderboard:
*-Lee el archivo y lo muestra en pantalla indicando el nombre y el
*total del tiempo

*-----------------------------------------------------------

*VARIABLES

LB_MAX_ENTRADAS EQU 9  ;9 máximo
LB_TAM_ENTRADA  EQU 8   ;8 bytes por entrada, 4 de letra, 2 de min y 2 de seg
LB_TAM_BUFFER   EQU LB_MAX_ENTRADAS*LB_TAM_ENTRADA

LB_POS_X    EQU 120
LB_POS_Y    EQU 80
LB_FIL_ALTO EQU 36

;Coords boton salir menu
BTN_LB_SALIR_X1     EQU     620
BTN_LB_SALIR_Y1     EQU     540
BTN_LB_SALIR_X2     EQU     780
BTN_LB_SALIR_Y2     EQU     575
*-----------------------------------------------------------

*-----------------------------------------------------------
INIT_LEADERBOARD:
* Descripción: Carga el archivo del leaderboard si ya existe y
* si no existe inicaliza los valores y crea el archivo

*-----------------------------------------------------------
    MOVEM.L D0-D2/A0, -(A7)


    BSR     LB_CARGAR_DEFECTO

    LEA     LB_ARCHIVO_NOMBRE, A0   ;Ponemos en A0 el nombre del archivo

    MOVE.L  #0, D1                     ; 0 = ABrir archivo que ya existe
    BSR     ABRIR_ARCHIVO
    TST.W   D0                          ; D0.W = 0 si funcionó
    BNE     .CREAR_INICIAL

    ; Lee el contenido del archivo en el buffer
    MOVE.L  D1, -(A7)                   ; D1 en la pila, tiene el FID
    LEA     LB_BUFFER, A0 
    MOVE.L  #LB_TAM_BUFFER, D2
    BSR     LEER_ARCHIVO
    MOVE.L  (A7)+, D1                   ; Recuperamos lo de la pila
    BSR     CERRAR_ARCHIVO
    BRA     .FIN

.CREAR_INICIAL:
    BSR     GUARDAR_LEADERBOARD

.FIN:
    MOVEM.L (A7)+, D0-D2/A0
    RTS
*-----------------------------------------------------------
LB_CARGAR_DEFECTO:
* Descripción: Mete en el buffer las entradas iniciales
*-----------------------------------------------------------

    MOVEM.L D0/A0-A1, -(A7)
    LEA LB_BUFFER, A0 ;Cargamos en A0 LB_BUFFER
    LEA LB_PLANTILLA_DEFECTO, A1 ;Cargamos la plantilla en A1
    MOVE.W #LB_TAM_BUFFER-1, D0 ;D0 = Tamaño del buffer -1
    
    ;Bucle que mientras D0 no sea 0 va a copiar toda la plantilla
    ;En el buffer
.COPIAR:
    MOVE.B (A1)+, (A0)+
    DBRA.W D0, .COPIAR
    MOVEM.L (A7)+, D0/A0-A1
    RTS
    
*-----------------------------------------------------------
GUARDAR_LEADERBOARD:
* Descripción: Guarda todo lo que hay en el buffer en el disco
*-----------------------------------------------------------
    MOVEM.L D0-D2/A0, -(A7)

    LEA     LB_ARCHIVO_NOMBRE, A0 ;Cargamos el nombre del fichero en A0
    MOVE.L  #1, D1                      ; 1 = crear 
    BSR     ABRIR_ARCHIVO 
    TST.W   D0
    BNE     .FIN

    MOVE.L  D1, -(A7)                   ; Guardamos FID
    LEA     LB_BUFFER, A0 ;Cargamos en A0 el buffer
    MOVE.L  #LB_TAM_BUFFER, D2 ;Decimos que queremos guardar el número del tamaño
                               ;del buffer de bytes (8) 
    BSR     ESCRIBIR_ARCHIVO ;Escribimos
    MOVE.L  (A7)+, D1                   ;Recuperamos FID
    BSR     CERRAR_ARCHIVO

.FIN:
    MOVEM.L (A7)+, D0-D2/A0
    RTS
    
*-----------------------------------------------------------
REGISTRAR_PUNTUACION:
* Descripción: Inserta una nueva marca en orden si entra en el top
* Entrada: D1.W = Minutos, D2.W = Segundos, A0.L = Puntero a 4B nombre

*Funcionamiento:
* Pasa todo el tiempo a segundos para compararse.
*Mira todos en orden y si su tiempo es mayor que el que lee se coloca en
*Su posición y desplaza las otras. Si no está en el top 10 no entra.
*-----------------------------------------------------------

    MOVEM.L D0-D7/A0-A3, -(A7)

    ;Pasamos todo el tiempo a segundos
    CLR.L   D3
    MOVE.W  D1, D3 ;D1 son los minutos, para el calculo lo pasamos a D3
    MULU.W  #60, D3
    CLR.L   D4
    MOVE.W  D2, D4 ;D4 = Segundos
    ADD.L   D4, D3                      ; D3.L = segundos + minutos en segundos

    LEA     LB_BUFFER, A1
    CLR.W   D5                          ; D5 = índice actual
    

.BUSCAR_POS:

    CMP.W   #LB_MAX_ENTRADAS, D5 ;Si el índice es el máximo salta, ya que
    BGE     .FIN                          ; No supera a ninguna marca

    ; Calculamos segundos de la fila en la que estamos
    CLR.L   D6
    MOVE.W  4(A1), D6                   ; Los minutos de la entrada
    MULU.W  #60, D6                     ; los pasamos a segundos
    CLR.L   D7
    MOVE.W  6(A1), D7                   ; los segundos de la entrada
    ADD.L   D7, D6                      ; tenemos en D6 el total de segundos

    CMP.L   D6, D3                      ;Comparamos los segundos del que estamos mirando
                                        ;Con los segundos nuestros

    BGT     .INSERTAR                   ; Significa que tiene mejor marca, saltamos a insertarlo

    ADD.W   #1, D5                      ; D5++
    ADD.L   #LB_TAM_ENTRADA, A1         ;Le suma 8 a A1, esto hace que apunte a los siguientes 8B,
                                        ; la nueva marca

    BRA     .BUSCAR_POS                 ;repite el bucle

.INSERTAR:
    ; Desplazar las otras entradas hacia abajo
    MOVE.W  #LB_MAX_ENTRADAS-1, D6
.DESPLAZAR:
    CMP.W   D5, D6 ;Siempre que D6 sea mayor que D5 desplaza
    BLE     .ESC_NEW

    ; Origen = LB_BUFFER + (D6-1)*8 (APUNTA A LA ENTRADA ANTERIOR)
    ; Destino = LB_BUFFER + D6*8 (APUNTA A LA ACTUAL)

    MOVE.W  D6, D7
    SUB.W   #1, D7
    MULU.W  #LB_TAM_ENTRADA, D7
    LEA     LB_BUFFER, A2
    ADDA.L  D7, A2                      ; A2 = origen

    MOVE.W  D6, D7
    MULU.W  #LB_TAM_ENTRADA, D7
    LEA     LB_BUFFER, A3
    ADDA.L  D7, A3                      ; A3 = destino

    MOVE.L  (A2)+, (A3)+                ; Copia 4 primeros bytes
    MOVE.L  (A2)+, (A3)+                ; Copia 2B min + 2B seg

    SUB.W   #1, D6 ;D6--
    BRA     .DESPLAZAR

.ESC_NEW:
    ; A1 apunta a D5 en LB_BUFFER
    MOVE.L  (A0), (A1)                  ; Nombre
    MOVE.W  D1, 4(A1)                   ; Minutos
    MOVE.W  D2, 6(A1)                   ; Segundos

    BSR     GUARDAR_LEADERBOARD

.FIN:
    MOVEM.L (A7)+, D0-D7/A0-A3
    RTS
    
    
*-----------------------------------------------------------
LB_DIBUJAR_CADENA:
* Descripción: Usa DIBUJAR_LETRA  de leaderboard para dibujar una cadena
* Entrada: A0.L = Puntero al string (terminado en 0)
*          D1.W = X inicial
*          D2.W = Y inicial
* Salida:  Nada
*-----------------------------------------------------------

    MOVEM.L D0/A0, -(A7)


    MOVE.W  D1, TEXTO_CURSOR_X
    MOVE.W  D2, TEXTO_CURSOR_Y

.SIG_CHAR:
    CLR.W   D0
    MOVE.B  (A0)+, D0
    BEQ     .FIN                ; Si es 0, fin de cadena
    BSR     DIBUJAR_LETRA
    BRA     .SIG_CHAR

.FIN:
    MOVEM.L (A7)+, D0/A0
    RTS
    
    
    
*-----------------------------------------------------------
DIBUJAR_LEADERBOARD:
* Descripción: Dibuja la tabla del leaderboard usando las subrutinas
* Que creamos en FUENTES

*!!!!!!!!! por ahora es solo un rectángulo ya cargaremos en un futuro un sprite
*-----------------------------------------------------------

    ;SI ESTA DIBUJADO NO LO HACEMOS!
    TST.B LB_DIBUJADO
    BNE .YA_DIBUJADO
    MOVEM.L D0-D6/A0-A2, -(A7)

    ;FONDO
    MOVE.W  #80, D1
    MOVE.W  #50, D2
    MOVE.W  #640, D3
    MOVE.W  #460, D4
    MOVE.L  #$00000000, D5      ; Negro
    BSR     DIBUJAR_RECTANGULO_RELLENO

    ; Usamos lo mismo que para pedir el nombre para mostrar un texto centrado
    LEA     LB_TXT_TITULO, A0
    MOVE.W  #80, D0             ; D0.W = coordenada Y
    BSR     MOSTRAR_TEXTO_CENTRADO

    ; dibujar las 5 filas en este formato: (Puesto | Nombre | Min:Seg)
    LEA     LB_BUFFER, A2       ; A2 recorre cada entrada de 8 bytes
    CLR.W   D6                  ; D6 = índice de fila (Pusimos que hasta el 9)
    MOVE.W  #120, D4            ; Y inicial de la primera fila

.LOOP_FILAS:
    CMP.W   #LB_MAX_ENTRADAS, D6
    BGE     .DIB_BOTON
    BGE     .FIN

    ; Dibujamos que puesto es
    MOVE.W  #144, D3            ; coord X del número de puesto
    ; Ya tenemos la coord Y en D4 asi que no hace falta inicializarla
    MOVE.L  #COLOR_BLANCO, D5
    CLR.L   D0
    MOVE.W  D6, D0
    ADDQ.W  #1, D0              ; Mostrar al 0 un 1 y asi para que no salga un 0
    BSR     DIBUJAR_DIGITO_PIXEL

    ; El nombre, que son 4 bytes
    MOVE.L  (A2), LB_NOMBRE_TMP
    CLR.B   LB_NOMBRE_TMP+4  
    LEA     LB_NOMBRE_TMP, A0
    MOVE.W  #190, D1            ; X inicial del nombre
    MOVE.W  D4, D2              ; Y de la fila
    BSR     LB_DIBUJAR_CADENA

    ; Dibujamos el tiempo
    MOVE.W  #525, D3            ; X inicial del tiempo
    MOVE.L  #COLOR_BLANCO, D5

    ; Minutos
    CLR.L   D0
    MOVE.W  4(A2), D0
    DIVU.W  #10, D0
    MOVE.W  D0, -(A7)
    BSR     DIBUJAR_DIGITO_PIXEL
    ADD.W   #DIGITO_ESPACIO, D3
    MOVE.W  (A7)+, D0
    SWAP    D0
    BSR     DIBUJAR_DIGITO_PIXEL
    ADD.W   #DIGITO_ESPACIO, D3

    ; Los dos puntos, que llamamos 10 en FONTS
    MOVE.W  #10, D0
    BSR     DIBUJAR_DIGITO_PIXEL
    ADD.W   #DIGITO_ESPACIO, D3

    ; Segundos
    CLR.L   D0
    MOVE.W  6(A2), D0
    DIVU.W  #10, D0
    MOVE.W  D0, -(A7)
    BSR     DIBUJAR_DIGITO_PIXEL
    ADD.W   #DIGITO_ESPACIO, D3
    MOVE.W  (A7)+, D0
    SWAP    D0
    BSR     DIBUJAR_DIGITO_PIXEL

    ; Siguiente fila
    ADD.W   #32, D4             ; Separación vertical entre filas
    ADD.L   #LB_TAM_ENTRADA, A2
    ADDQ.W  #1, D6
    BRA     .LOOP_FILAS
.DIB_BOTON:
    ;dibujar el boton de salir
    MOVE.W  #BTN_LB_SALIR_X1, D1
    MOVE.W  #BTN_LB_SALIR_Y1, D2
    MOVE.W  #BTN_LB_SALIR_X2, D3
    MOVE.W  #BTN_LB_SALIR_Y2, D4
    MOVE.L  #$000000FF, D5          ; Rojo
    BSR     DIBUJAR_RECTANGULO_RELLENO
.FIN:
    MOVE.B #1, LB_DIBUJADO
    MOVEM.L (A7)+, D0-D6/A0-A2
.YA_DIBUJADO:
    RTS
    
    
*-----------------------------------------------------------
TST_CLICK_SALIR:
*Analiza si el ratón está dentro del rectangulo de salir del leaderboard

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
    SUB.W #BTN_LB_SALIR_X1, D1     *MOUSE_X - BTN_JUGAR_X1
    BMI     .NO_PULSADO        *Si es negativo salta
    
        
    MOVE.W #BTN_LB_SALIR_X2, D1
    SUB.W MOUSE_X, D1  *MOUSE_X - BTN_JUGAR_X2
    BMI     .NO_PULSADO
    
    
    MOVE.W MOUSE_Y, D2
    SUB.W #BTN_LB_SALIR_Y1, D2     *MOUSE_Y - BTN_JUGAR_Y1
    BMI .NO_PULSADO
        
        
    MOVE.W #BTN_LB_SALIR_Y2, D2
    SUB.W MOUSE_Y, D2     *MOUSE_Y - BTN_JUGARY2
    BMI .NO_PULSADO
    
    CLR.B   LB_DIBUJADO
    CLR.B   MOUSE_CLICK
    BSR     BORRAR_PANTALLA
    MOVE.B  #0, ESTADO_JUEGO
    
.ESP_SOLTAR_CLICK:
    BSR     LEER_RATON
    MOVE.B  MOUSE_CLICK, D0
    BTST    #0, D0
    BNE     .ESP_SOLTAR_CLICK

    MOVE.B  #1, D0
    BRA     .FIN
    
.NO_PULSADO:
    CLR.B D0

.FIN:
    MOVEM.L (A7)+, D1-D2
    RTS
    


*------------------------------------------------------
*CONSTANTES Y VARIABLES
*------------------------------------------------------
LB_ARCHIVO_NOMBRE:  DC.B    'LEADER.BIN',0
                    DS.W    0
LB_TXT_TITULO:      DC.B    'LEADERBOARD MIN SEG',0
                    DS.W    0
;Plantilla por defecto
LB_PLANTILLA_DEFECTO:
                    DC.B    'AAAA'
                    DC.W    0,50
                    DC.B    'BBBB'
                    DC.W    0,45
                    DC.B    'CCCC'
                    DC.W    0,40
                    DC.B    'DDDD'
                    DC.W    0,35
                    DC.B    'EEEE'
                    DC.W    0,30
                    DC.B    'AAAA'
                    DC.W    0,25
                    DC.B    'BBBB'
                    DC.W    0,20
                    DC.B    'CCCC'
                    DC.W    0,15
                    DC.B    'DDDD'
                    DC.W    0,10
                    DS.W 0

LB_DIBUJADO: DS.B 1 ;BOOLEAN DE SI ESTÁ DIBUJADO O NO
                DS.W 0

LB_BUFFER:          DS.B    LB_TAM_BUFFER
LB_NOMBRE_TMP:      DS.B    5
                    DS.W    0














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
