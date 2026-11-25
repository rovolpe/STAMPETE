*-----------------------------------------------------------
*CACTUS
*Lógica de los cactus.
*Se mueven en filas ocupando todo el ancho de la zona del jueg
*Y can cayendose actualizando la coord Y. Cada fila se selecciona
*De un patrón leido e un fichero PATRONES.TXT

*Cada celda puede ser: vacía/cactus/cactus diparable/flor

*FORMATO PATRONES.TXT
*  . = vacio   N = cactus normal  D = cactus disparable
*Cada fila mide 16 caracteres
*También hay patrones por defecto en este fichero
*-----------------------------------------------------------


*EL MÓDULO SE DIVIDE EN DOS BLOQUES DE SUBRUTINAS

*1. SUBRUTINAS DE LEER Y ANALIZAR LOS PATRONES DEL TXT

* El programa ha de leer el ficheroy convertir en el 
*formato que toca (parsear) el fichero, si no lo lee bien
*He añadido unos patrones default, borrar más adelante si eso

* Llama a la subrutina CACTUS_CARGAR_PATRONES, que es la principal,
*Esta llama a CAC_LEER_FICHERO y si los ha leído llama a CAC_PARSEAR

*CAC_LEER_FICHERO : Abre PATRONES.txt en modo lectura y usa 
*La subrutina de SYSTEM para abrir el archivo y para leerlo
*Lee hasta CAC_BUF_TAM bytes (16)

*CAC_PARSEAR Convierte lo que ha leido en los datos que tocan


*2. SUBRUTINAS DE LÓGICAS DEL CACTUS

*Contiene toda la lógica del cactus, su inicialización, redibujado, colisión...

*CACTUS_INIT: Pone todas las ranuras de CAC_FILASS en activo
*Pone 0 en CAC_FILAS_REST (Ningún patrón activo ahora mismo)
*carga SPAWN_TIEMPO en CAC_TEMP, esto para que pause antes de enviarlo

*CACTUS_UPDATE: Ejecuta la lógica del cactus, solo llama a suburtinas
*Llama a CAC_MOVER, CAC_GENERAR y CAC_COLISION_JUGADOR

*CAC_MOVER :Desplaza hacia abajo las filas enteras y si llegan al final las libera

*CAC_GENERAR: Baja el temporizador (CAC_TEMP) y cuando es 0 mira si CAC_FILAS_REST es 0
*si lo es, no quedan filas en este parón por lo que busca otro, y llama a CAC_ELEGIR_PATRON
*Llama luego a CAC_CREAR_FILA y crea la fila

;CAC_ELEGIR_PATRON: Elige el patrón al azar de CAC_PAT_TABLA, usando el número aleatorio de
;SYSTEM, también evita que se use el último, y carga CAC_PTR_FILA y CAC_FILAS_REST

*CAC_CREAR_FILA: Crea una fila, busca la primera ranura que tenga 0 en FILA_ACTIVA y si no 
;hay ninguna devuelve 0 en D0.B. Sino fija FILA_Y = CAC_Y_INICIO, pone FILA_ACTIVA en 1 y copia
* Las columnas, luego devuelve 1 en D0.B confirmando que se ha creado.

*CAC_COLISION_JUGADOR: Calcula las colisiones




*CONSTANTES
*tipos de celdas
CELDA_VACIA         EQU 0
CELDA_NORMAL        EQU 1
CELDA_DISP          EQU 2
CELDA_FLOR          EQU 3



;Movimiento y generacion
CAC_VEL             EQU 4           ;numero de pixeles que baja cada fila por fotograma

;Coordenadas de zonas
CAC_ZONA_X1         EQU 80
CAC_ZONA_X2         EQU 719
CAC_ZONA_Y1         EQU 105
CAC_ZONA_Y2         EQU 545

CAC_COLS            EQU 16
CAC_X0              EQU CAC_ZONA_X1+((CAC_ZONA_X2-CAC_ZONA_X1+1)-CAC_COLS*CACTUS_ANCHO)/2
CAC_ANCHO_TOTAL     EQU CAC_COLS*CACTUS_ANCHO
CAC_Y_INICIO        EQU CAC_ZONA_Y1-CACTUS_ALTO
CAC_Y_FIN           EQU CAC_ZONA_Y2+1
CAC_ESPACIO_FILAS   EQU 40          ;fotogramas entre filas de un patron
.TO
;Dibujo
CAC_MARGEN          EQU 2           ;margen entre cactus
CAC_FLOR_LADO       EQU 30
CAC_FLOR_DX         EQU (CACTUS_ANCHO-CAC_FLOR_LADO)/2
CAC_FLOR_DY         EQU (CACTUS_ALTO-CAC_FLOR_LADO)/2
CAC_COLOR_DISP      EQU $0060E060   ;verde claro ($00BBGGRR)

;Tamanos de tablas
MAX_FILAS           EQU 8           ;filas simultaneas en pantalla
CAC_MAX_PATRONES    EQU 8
CAC_PAT_TAM         EQU 6           ;4 bytes puntero y 2 bytes n filas
CAC_BUF_TAM         EQU 2048        ;bytes maximos que se leen del fichero

FILA_Y              EQU 0           ;.W  Y de la fila (con signo)
FILA_ACTIVA         EQU 4           ;.B  0 = ranura libre
FILA_CELDAS         EQU 6           ;CAC_COLS bytes, uno por celda
FILA_TAM            EQU FILA_CELDAS+CAC_COLS

*-----------------------------------------------------------
CACTUS_CARGAR_PATRONES
*Esta subrutina lee el fichero de patrones
*Pone a 0 el numero de patrones, llama a leer el fichero y 
*Si ha leido llama a la subrutina de parsear. Si no existe copia
*Los patrones por defecto y los parsea
*-----------------------------------------------------------
    MOVEM.L D0, -(A7)
    CLR.W   CAC_NUM_PATRONES

    BSR     CAC_LEER_FICHERO        ;bytes leidos en D0.L
    TST.L D0
    BEQ .FIN ;no se ha leido nada
    BSR     CAC_PARSEAR

.FIN:
    MOVEM.L (A7)+, D0
    RTS
 
*-----------------------------------------------------------
CAC_LEER_FICHERO:
*Descripcion: Lee el fichero de patrones al buffer de texto
*Abre PATRONES.TXT en modo lectura, lee hasta 16 bytes, cierra
*el archivo y devuelve el número de bytes leídos
*Entrada: nada
*Salida: D0.L = bytes leidos (0 si no existe o hay error)
*Registros modificados: D0
*-----------------------------------------------------------
    MOVEM.L D1-D2/D4/A0/A2, -(A7)


    LEA     CAC_ARCHIVO_NOMBRE, A0
    CLR.L   D1                      ;0 = abrir uno que ya existe
    BSR     ABRIR_ARCHIVO
    TST.W   D0
    BNE     .ERROR                  ;D1.L = ID del archivo

    LEA     CAC_BUFFER, A2          ;A2 = donde va el siguiente byte
    CLR.L   D4                      ;D4 = bytes leidos hasta ahora
.LEER_BYTE:
    CMP.L   #CAC_BUF_TAM, D4
    BGE     .CERRAR                 ;buffer lleno
    CLR.B   (A2)                    ;si no llega nada, el byte queda a 0
    MOVEA.L A2, A0
    MOVE.L  #1, D2                  ;un solo byte
    BSR     LEER_ARCHIVO            ;D0.W = estado, D2.L = bytes leidos
    CMP.W   #2, D0
    BGE     .CERRAR                 ;error: se deja de leer
    TST.L   D2
    BEQ     .CERRAR                 ;no ha llegado ningun byte: fin
    TST.B   (A2)
    BEQ     .CERRAR                 ;un 0 no es texto: fin
    ADDQ.L  #1, A2
    ADDQ.L  #1, D4
    BRA     .LEER_BYTE

.CERRAR:
    BSR     CERRAR_ARCHIVO
    MOVE.L  D4, D0                  ;D0 = bytes leidos (0 = nada)
    BRA     .FIN

.ERROR:
    CLR.L   D0

.FIN:
    MOVEM.L (A7)+, D1-D2/D4/A0/A2
    RTS



*-----------------------------------------------------------
CAC_PARSEAR:
*Descripcion: Analiza el texto y lo convierte en un tipo de celda
*(0 vacio, 1 normal, 2 disparable)
*Entrada: D0.L = bytes de texto en CAC_BUFFER
*Salida: (CAC_NUM_PATRONES), (CAC_PAT_TABLA)
*Registros modificados: nada
*
*-----------------------------------------------------------
    MOVEM.L D0-D5/A0-A4, -(A7)

    LEA     CAC_BUFFER, A1 ;Cargamos el buffer en A1
    MOVEA.L A1, A2 ;Lo pasamos a A2
    LEA     0(A1,D0.L), A3 ; cargamos en A3 la dirección de A1 +D0
    LEA     CAC_PAT_TABLA, A0
    CLR.L   D0  
    CLR.W   D2
    CLR.W   D3
    CLR.W   D4

.LEER:
    CMPA.L  A3, A1 
    BLT     .HAY_CHAR
    ;Fin del texto: simulamos dos saltos de linea. El primero cierra la
    ;ultima linea y el segundo cierra el ultimo patron.
    CMP.W   #2, D0
    BGE     .FIN_TEXTO
    ADDQ.W  #1, D0
    BRA     .FIN_LINEA
;Lee cada carácter y lo traduce al tipo de celda
.HAY_CHAR:
    MOVE.B  (A1)+, D1
    CMP.B   #10, D1                 ;Si es saltoo de linea va a fin linea
    BEQ     .FIN_LINEA
    CMP.B   #13, D1                 ;Ignora CR (no leia bien sino)
    BEQ     .LEER

    CLR.B   D5                      ;En D5 tenemos el valor de la celda
    ;Lo comparamos con los valores posibles y saltamos a cada caso
    CMP.B   #'N', D1
    BEQ     .ES_N
    CMP.B   #'n', D1
    BEQ     .ES_N
    CMP.B   #'D', D1
    BEQ     .ES_D
    CMP.B   #'d', D1
    BEQ     .ES_D
    BRA     .GUARDAR                ;cualquier otro caracter será vacío
    ;N es una celda normal
.ES_N:
    MOVE.B  #CELDA_NORMAL, D5
    BRA     .GUARDAR
    ;D es una celda con flor, disparable
.ES_D:
    MOVE.B  #CELDA_DISP, D5
    ;Guarda en al fila actual y cuenta columnas
.GUARDAR:
    CMP.W   #CAC_COLS, D2 ;Si D2 ya llegó a mirar 16 columnas
    BGE     .SIG_COL    ;Si no sigue mirando la siguiente
    MOVE.B  D5, 0(A2,D2.W) ;Escribe el valor de celda en la posición 0(A2,D2) A2+D2.
    ;Si ya son 16 esto no lo haría y iría directo a la siguiente columna
.SIG_COL:
    ADDQ.W  #1, D2
    BRA     .LEER
;Valida que tipo de linea terminó
.FIN_LINEA:
    CMP.W   #CAC_COLS, D2 ;Aquí la fila tendrúa el ancho exacto
    BEQ     .FILA_VALIDA
    TST.W   D2 ;Si es 0 está vacía
    BEQ     .LINEA_VACIA
    CLR.W   D2       ;Cualquier otra cosa la descartamos
    BRA     .LEER

.FILA_VALIDA:
    TST.W   D3 ;D3 = La cantidad de filas acumuladas en el patrón actual
    BNE     .NO_PRIMERA
    MOVEA.L A2, A4            ;Significa que es la primera fila de un patrón nuevo
.NO_PRIMERA:
    LEA     CAC_COLS(A2), A2         ;Mantiene A4(no es la primera fila)
    ADDQ.W  #1, D3
    CLR.W   D2
    BRA     .LEER

.LINEA_VACIA: ;Aquí la linea está vacía
    TST.W   D3 ;Si d3 está vacío no hay ningún patrón abierto
    BEQ     .LEER                   ;vuelve a leer
    CMP.W   #CAC_MAX_PATRONES, D4 ;Miras si D4 ha llegado a 8
    BGE     .PAT_LLENA              ;lo descartas
    MOVE.L  A4, (A0)+               
    MOVE.W  D3, (A0)+            
    ADDQ.W  #1, D4
.PAT_LLENA:
    CLR.W   D3
    BRA     .LEER
    ;Cierra el parseo
.FIN_TEXTO:
    MOVE.W  D4, CAC_NUM_PATRONES
    MOVEM.L (A7)+, D0-D5/A0-A4
    RTS

*-----------------------------------------------------------
CACTUS_INIT:
*Descripcion: Libera todas las filas y reinicia el generador.
*Llamar al empezar cada partida.
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D0/A0, -(A7)

    LEA     CAC_FILAS, A0 ;Cargamos en A0 las filas
    MOVE.W  #MAX_FILAS-1, D0 ;Servirá de contador para vaciar todo
.LIMPIAR:
    CLR.B   FILA_ACTIVA(A0) ;Vaciamos la fila activa de A0
    LEA     FILA_TAM(A0), A0
    DBRA    D0, .LIMPIAR

    CLR.W   CAC_FILAS_REST     ;Vacía las filsa  restantes
    MOVE.W  #SPAWN_TIEMPO, CAC_TEMP ;Carga el temporizador inicial
    MOVE.W  #-1, CAC_PAT_ULTIMO ;Reseteo CAC_PAT_ULTIMO

    MOVEM.L (A7)+, D0/A0
    RTS

*-----------------------------------------------------------
CACTUS_UPDATE:
*Descripcion: Llama a las subrutinas para actualizar
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    BSR     CAC_MOVER
    BSR     CAC_GENERAR
    BSR     CAC_COLISION_JUGADOR
    RTS

*-----------------------------------------------------------
CAC_MOVER:
*Descripcion: Baja un total de CAC_VEL pixeles 
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D0/D2/A0, -(A7)
    ;Esto para recorrer todas las filas
    LEA     CAC_FILAS, A0
    MOVE.W  #MAX_FILAS-1, D2
    ;Este bucle recorre todas las ranuras, si una fila está activa suma
    ;CAC_VEL a FILA_Y, si está al final (>= CAC_Y_FIN) la borra y marca su ranura
    ;Como activa
.BUCLE:
    TST.B   FILA_ACTIVA(A0)
    BEQ     .SIG
    MOVE.W  FILA_Y(A0), D0 ;Tenemos en D0 la coord Y de la fila
    ADD.W   #CAC_VEL, D0 ;Le sumamos la velocidad
    CMP.W   #CAC_Y_FIN, D0 ;Si es mayor a la final la borramos
    BLT     .GUARDAR
    BSR     CAC_BORRAR_FILA   ;se borra donde estaba dibujada
    CLR.B   FILA_ACTIVA(A0)
    BRA     .SIG
.GUARDAR:
    MOVE.W  D0, FILA_Y(A0) 
.SIG:
    LEA     FILA_TAM(A0), A0
    DBRA    D2, .BUCLE

    MOVEM.L (A7)+, D0/D2/A0
    RTS

*-----------------------------------------------------------
CAC_GENERAR:
*Gestiona el temporizador, cuando llega a 0 llama a elegir patrón
*y intenta crear una fila, si la crea, avanza CAC_PTR_FILA, le resta 
*1 a filas restanates
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D0, -(A7)
    ;Mira la cuenta atrás, si es 0, ya toca, sino, le resta 1
    TST.W   CAC_TEMP
    BEQ     .TOCA
    SUBQ.W  #1, CAC_TEMP
    BNE     .FIN                    ;todavia no toca

.TOCA:
    TST.W   CAC_FILAS_REST ;Mira cuantas filas restantes hay
    BNE     .CREAR              ; si no es 0 significa que seguimos con el patron actual
    BSR     CAC_ELEGIR_PATRON ;Selecciona un patrón nuevo 
    TST.W   CAC_FILAS_REST
    BNE     .CREAR
    MOVE.W  #SPAWN_TIEMPO, CAC_TEMP ;no hay patrones validos: reintentar luego
    BRA     .FIN

.CREAR:
    BSR     CAC_CREAR_FILA          ;D0 = 1 si habia ranura libre
    TST.B   D0
    BEQ     .FIN                    ;No se pudo crear la fila
    ADD.L   #CAC_COLS, CAC_PTR_FILA ;Le sumamos las columnas (16)
    SUBQ.W  #1, CAC_FILAS_REST ; Filas restantes--
    BNE     .ENTRE_FILAS ;Si aun quedan filas
    MOVE.W  #SPAWN_TIEMPO, CAC_TEMP ;fin del patron
    BRA     .FIN
.ENTRE_FILAS:
    MOVE.W  #CAC_ESPACIO_FILAS, CAC_TEMP ;cargamos CAC_ESPACIO_FILAS en CAC_TEMP

.FIN:
    MOVEM.L (A7)+, D0
    RTS

*-----------------------------------------------------------
CAC_ELEGIR_PATRON:
*Descripcion: Elige un patrón al azar, y elige el patrón, evitando 
*elegir el anterior y cargando los datos del patrón que ha elegido
*Entrada: nada
*Salida: (CAC_PTR_FILA), (CAC_FILAS_REST)
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D1-D2/A0, -(A7)

    MOVE.W  CAC_NUM_PATRONES, D2 ;Cargamos el número de patrones en D0
    BEQ     .FIN                    ;Si no hay, fin
    MOVE.W  D2, D1          ;Copiamos D2 en D1
    BSR     GENERAR_ALEATORIO       ;Generamos un numero aleatorio

    CMP.W   #1, D2 ;Si solo hay uno, lo usamos
    BLE     .USAR                 
    CMP.W   CAC_PAT_ULTIMO, D1 ;Comparamos con el indice
    BNE     .USAR ;Si es distinto al ultimo patron se queda con ese
    ADDQ.W  #1, D1  ; si es el mismo le suma 1        
    CMP.W   D2, D1 ; si al sumar se pasa del total que hay vuelve al principio con el clr d1
    BLT     .USAR
    CLR.W   D1

.USAR:
    MOVE.W  D1, CAC_PAT_ULTIMO ;Metemos D1 en el último patrón
    MULU.W  #CAC_PAT_TAM, D1 ;Lo multiplicamos por el tamaño
    LEA     CAC_PAT_TABLA, A0 ; A0 ahora apunta a la entrada de cac_pat_tabla
    ADDA.L  D1, A0
    ;Lee los 4 bytes del puntero y los 2 bytes del total de filas (.L Y .W)
    MOVE.L  (A0)+, CAC_PTR_FILA
    MOVE.W  (A0), CAC_FILAS_REST

.FIN:
    MOVEM.L (A7)+, D1-D2/A0
    RTS

*-----------------------------------------------------------
CAC_CREAR_FILA:
*Descripcion: Busca una ranura libre y copia en ella la fila
*apuntada por CAC_PTR_FILA, arriba de la pantalla.
*Entrada: (CAC_PTR_FILA)
*Salida: D0.B = 1 si se creo, 0 si no habia ranura libre
*Registros modificados: D0
*-----------------------------------------------------------
    MOVEM.L D1/A0-A1, -(A7)

    LEA     CAC_FILAS, A0
    MOVE.W  #MAX_FILAS-1, D1
.BUSCAR:
    TST.B   FILA_ACTIVA(A0)
    BEQ     .LIBRE
    LEA     FILA_TAM(A0), A0
    DBRA    D1, .BUSCAR
    CLR.B   D0
    BRA     .FIN

.LIBRE:
    MOVE.W  #CAC_Y_INICIO, FILA_Y(A0)
    MOVE.B  #1, FILA_ACTIVA(A0)
    MOVEA.L CAC_PTR_FILA, A1
    LEA     FILA_CELDAS(A0), A0
    MOVE.W  #CAC_COLS-1, D1
.COPIAR:
    MOVE.B  (A1)+, (A0)+
    DBRA    D1, .COPIAR
    MOVE.B  #1, D0

.FIN:
    MOVEM.L (A7)+, D1/A0-A1
    RTS

*-----------------------------------------------------------
CAC_COLISION_JUGADOR:
*Descripcion: Comprueba las celdas que toca el cowboy. Si toca cactus
*Le resta stamina, le suma si toca flor y el cactus desaparece al tocarse
*Entrada: (COWBOY_POS_X), (COWBOY_POS_Y)
*Salida: nada
*Registros modificados: nada
*
*-----------------------------------------------------------
    MOVEM.L D0-D7/A0-A1, -(A7)

    MOVE.W  COWBOY_POS_X, D1
    SUB.W   #COWBOY_RADIO, D1
    SUB.W   #CAC_X0, D1             ;D1 = borde izquierdo
    MOVE.W  COWBOY_POS_X, D2
    ADD.W   #COWBOY_RADIO-1, D2
    SUB.W   #CAC_X0, D2             ;D2 = borde derecho (inclusive)
    TST.W   D2
    BMI     .FIN                    ;totalmente a la izquierda de la rejilla
    CMP.W   #CAC_ANCHO_TOTAL, D1
    BGE     .FIN                    ;totalmente a la derecha
    TST.W   D1
    BPL     .IZQ_OK
    CLR.W   D1
.IZQ_OK:
    CMP.W   #CAC_ANCHO_TOTAL-1, D2
    BLE     .DER_OK
    MOVE.W  #CAC_ANCHO_TOTAL-1, D2
.DER_OK:
    ANDI.L  #$0000FFFF, D1
    ANDI.L  #$0000FFFF, D2
    DIVU.W  #CACTUS_ANCHO, D1       ;D1.W = columna izquierda
    DIVU.W  #CACTUS_ANCHO, D2       ;D2.W = columna derecha

    MOVE.W  COWBOY_POS_Y, D3
    SUB.W   #COWBOY_RADIO, D3
    MOVE.W  COWBOY_POS_Y, D4
    ADD.W   #COWBOY_RADIO, D4

    LEA     CAC_FILAS, A0
    MOVE.W  #MAX_FILAS-1, D5
.FILA:
    TST.B   FILA_ACTIVA(A0)
    BEQ     .SIG_FILA
    MOVE.W  FILA_Y(A0), D0
    CMP.W   D0, D4
    BLE     .SIG_FILA               ;el cowboy acaba por encima de la fila
    ADD.W   #CACTUS_ALTO, D0
    CMP.W   D0, D3
    BGE     .SIG_FILA               ;el cowboy empieza por debajo de la fila

    LEA     FILA_CELDAS(A0), A1
    MOVE.W  D1, D6
.COL:
    MOVE.B  0(A1,D6.W), D7
    BEQ     .SIG_COL                ;celda vacia
    CMP.B   #CELDA_FLOR, D7
    BEQ     .FLOR
    MOVE.W  #STAMINA_RESTA_CACTUS, D0
    BSR     RESTAR_STAMINA
    BRA     .CONSUMIR
.FLOR:
    MOVE.W  #STAMINA_SUMA_FLOR, D0
    BSR     SUMAR_STAMINA
.CONSUMIR:
    CLR.B   0(A1,D6.W)              ;la celda desaparece
    BSR     CAC_BORRAR_CELDA
    BSR     COWBOY_DRAW             ;por si se traga al cobwoy
.SIG_COL:
    ADDQ.W  #1, D6
    CMP.W   D2, D6
    BLE     .COL

.SIG_FILA:
    LEA     FILA_TAM(A0), A0
    DBRA    D5, .FILA

.FIN:
    MOVEM.L (A7)+, D0-D7/A0-A1
    RTS
*-----------------------------------------------------------
DIBUJAR_CACTUS:
*Descripcion: Dibuja todas las celdas no vacias de las filas
*activas.
*Entrada: nada
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D0-D7/A0-A1, -(A7)

    LEA     CAC_FILAS, A0
    MOVE.W  #MAX_FILAS-1, D7
.FILA:
    TST.B   FILA_ACTIVA(A0)
    BEQ     .SIG_FILA
    LEA     FILA_CELDAS(A0), A1
    CLR.W   D6
.COL:
    MOVE.B  0(A1,D6.W), D0
    BEQ     .SIG_COL
    BSR     CAC_DIBUJAR_CELDA       ;Entradas de la subrutina:
                               ;A0 = fila, D6.W = columna, D0.B = tipo
.SIG_COL:
    ADDQ.W  #1, D6
    CMP.W   #CAC_COLS, D6
    BLT     .COL
.SIG_FILA:
    LEA     FILA_TAM(A0), A0
    DBRA    D7, .FILA

    MOVEM.L (A7)+, D0-D7/A0-A1
    RTS

*-----------------------------------------------------------
CAC_DIBUJAR_CELDA:
*Descripcion: Dibuja una celda en su posicion actual.
*Entrada: A0 = fila, D6.W = columna, D0.B = tipo de celda
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D0-D7, -(A7)

    MULU.W  #CACTUS_ANCHO, D6
    ADD.W   #CAC_X0, D6             ;D6.W = X de la celda
    MOVE.W  FILA_Y(A0), D7          ;D7.W = Y de la celda

    CMP.B   #CELDA_FLOR, D0
    BEQ     .FLOR

    ;Dbuja una estela
    MOVE.W  D6, D1
    MOVE.W  D7, D2
    SUB.W   #CAC_VEL, D2
    MOVE.W  D6, D3
    ADD.W   #CACTUS_ANCHO-1, D3
    MOVE.W  D7, D4
    SUBQ.W  #1, D4
    MOVE.L  #COLOR_NEGRO, D5
    BSR     CAC_RECT
    ;Dibuja el catus (por ahora un rectangulo)
    MOVE.W  D6, D1
    ADD.W   #CAC_MARGEN, D1
    MOVE.W  D7, D2
    MOVE.W  D6, D3
    ADD.W   #CACTUS_ANCHO-1-CAC_MARGEN, D3
    MOVE.W  D7, D4
    ADD.W   #CACTUS_ALTO-1, D4
    MOVE.L  #COLOR_VERDE_CACTUS, D5
    CMP.B   #CELDA_DISP, D0
    BNE     .PINTAR
    MOVE.L  #CAC_COLOR_DISP, D5
.PINTAR:
    BSR     CAC_RECT
  BRA     .FIN

.FLOR:
    ;Borra la caja
    MOVE.W  D6, D1
    MOVE.W  D7, D2
    SUB.W   #CAC_VEL, D2
    MOVE.W  D6, D3
    ADD.W   #CACTUS_ANCHO-1, D3
    MOVE.W  D7, D4
    ADD.W   #CACTUS_ALTO-1, D4
    MOVE.L  #COLOR_NEGRO, D5
    BSR     DIBUJAR_RECTANGULO_RELLENO
    ;Dibuja una elipse
    MOVE.W  D6, D1
    ADD.W   #CAC_FLOR_DX, D1
    MOVE.W  D1, D3
    ADD.W   #CAC_FLOR_LADO-1, D3
    MOVE.W  D7, D2
    ADD.W   #CAC_FLOR_DY, D2
    CMP.W   #CAC_ZONA_Y1, D2
    BLT     .FIN                    ;asoma por arriba
    MOVE.W  D2, D4
    ADD.W   #CAC_FLOR_LADO-1, D4
    CMP.W   #CAC_ZONA_Y2, D4
    BGT     .FIN 
    ANDI.L  #$0000FFFF, D1          
    ANDI.L  #$0000FFFF, D2
    ANDI.L  #$0000FFFF, D3
    ANDI.L  #$0000FFFF, D4
    MOVE.L  #COLOR_AMARILLO_FLOR, D5
    BSR     DIBUJAR_ELIPSE

.FIN:
    MOVEM.L (A7)+, D0-D7
    RTS


*-----------------------------------------------------------
CAC_BORRAR_CELDA:
*Descripcion: Borra la caja de una celda
*La pinta de negro
*Entrada: A0 = fila, D6.W = columna
*Salida: nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D1-D5, -(A7)

    MOVE.W  D6, D1
    MULU.W  #CACTUS_ANCHO, D1
    ADD.W   #CAC_X0, D1             ;X1
    MOVE.W  D1, D3
    ADD.W   #CACTUS_ANCHO-1, D3     ;X2
    MOVE.W  FILA_Y(A0), D2
    SUB.W   #CAC_VEL, D2            ;Y1
    MOVE.W  FILA_Y(A0), D4
    ADD.W   #CACTUS_ALTO-1, D4      ;Y2
    MOVE.L  #COLOR_NEGRO, D5
    BSR     DIBUJAR_RECTANGULO_RELLENO

    MOVEM.L (A7)+, D1-D5
    RTS

*-----------------------------------------------------------
CAC_BORRAR_FILA:
*Descripcion: Borra todas las celdas no vacias de una fila
*Entrada: A0 = fila
*Salida: Nada
*Registros modificados: nada
*-----------------------------------------------------------
    MOVEM.L D6/A1, -(A7)
    ;Cargamos la fila en A1
    LEA     FILA_CELDAS(A0), A1
    CLR.W   D6
.COL:
    TST.B   0(A1,D6.W)
    ;Si está vacía vamos a la siguiente
    BEQ     .SIG
    ;Borramos la celda
    BSR     CAC_BORRAR_CELDA
.SIG:
    ADDQ.W  #1, D6
    CMP.W   #CAC_COLS, D6
    BLT     .COL

    MOVEM.L (A7)+, D6/A1
    RTS
    
*-----------------------------------------------------------
CAC_RECT:
*-----------------------------------------------------------
    CMP.W   #CAC_ZONA_Y1, D4
    BLT     .FIN              
    CMP.W   #CAC_ZONA_Y2, D2
    BGT     .FIN            
    CMP.W   #CAC_ZONA_X1, D3
    BLT     .FIN 
    CMP.W   #CAC_ZONA_X2, D1
    BGT     .FIN           
    MOVEM.L D1-D4, -(A7)
    CMP.W   #CAC_ZONA_X1, D1
    BGE     .X1_OK
    MOVE.W  #CAC_ZONA_X1, D1
.X1_OK:
    CMP.W   #CAC_ZONA_X2, D3
    BLE     .X2_OK
    MOVE.W  #CAC_ZONA_X2, D3
.X2_OK:
    CMP.W   #CAC_ZONA_Y1, D2
    BGE     .Y1_OK
    MOVE.W  #CAC_ZONA_Y1, D2
.Y1_OK:
    CMP.W   #CAC_ZONA_Y2, D4
    BLE     .Y2_OK
    MOVE.W  #CAC_ZONA_Y2, D4
.Y2_OK:
    BSR     DIBUJAR_RECTANGULO_RELLENO
    MOVEM.L (A7)+, D1-D4
.FIN:
    RTS    
*-----------------------------------------------------------
RESTAR_STAMINA:
*resta la stamina (SIN BAJAR DE 0)
*Entrada: D0.W = Cuanto resta
*Salida: (STAMINA_ACTUAL)
*-----------------------------------------------------------
    MOVE.L  D1, -(A7)
    MOVE.W  STAMINA_ACTUAL, D1
    SUB.W   D0, D1
    BGE     .GUARDAR
    CLR.W   D1
.GUARDAR:
    MOVE.W  D1, STAMINA_ACTUAL
    MOVE.L  (A7)+, D1
    RTS
*-----------------------------------------------------------
SUMAR_STAMINA:
*Suma la stamina (SIN PASAR DE LA  MÁXIMA)
*Entrada: D0.W = Cuanto suma
*Salida: (STAMINA_ACTUAL)
*-----------------------------------------------------------
   MOVE.L  D1, -(A7)
    MOVE.W  STAMINA_ACTUAL, D1
    ADD.W   D0, D1
    CMP.W   #STAMINA_MAX, D1
    BLE     .GUARDAR
    MOVE.W  #STAMINA_MAX, D1
.GUARDAR:
    MOVE.W  D1, STAMINA_ACTUAL
    MOVE.L  (A7)+, D1
    RTS

*-----------------------------------------------------------
*DATOS
*-----------------------------------------------------------
CAC_ARCHIVO_NOMBRE: DC.B    'PATRONES.TXT',0 ;Nombre del archivo con aptrones
                    DS.W    0
                    
CAC_FILAS:          DS.B    MAX_FILAS*FILA_TAM
CAC_BUFFER:         DS.B    CAC_BUF_TAM
CAC_PAT_TABLA:      DS.B    CAC_MAX_PATRONES*CAC_PAT_TAM
                    DS.W    0
CAC_PTR_FILA:       DS.L    1       ;siguiente fila a crear del patron actual
CAC_NUM_PATRONES:   DS.W    1
CAC_TEMP:           DS.W    1       ;cuenta atras hasta la siguiente fila
CAC_FILAS_REST:     DS.W    1       ;filas que le quedan al patron actual
CAC_PAT_ULTIMO:     DS.W    1       ;ultimo patron elegido
                    DS.W    0












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
