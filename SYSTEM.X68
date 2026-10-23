*-----------------------------------------------------------
*SYSTEM

*Este módulo contiene todas las subrutinas de servicio de 
*interrupción para tratar el acceso a periféricos del
*programa

*Lista de subrutinas:

*INIT_SYSTEM
*ISR_TIMER
*LEER_TECLADO_JUEGO
*LEER_TECLADO_MENU
*LEER_RATON
*DIBUJAR_TEXTO_GFX                      POR HACER
*DIBUJAR_RECTANGULO_RELLENO
*DIBUJAR_ELIPSE 
*DIBUJAR_SPRITE                         POR HACER
*CARGAR SONIDO                          
*REPRODUCIR_SONIDO                      
*DETENER_SONIDO                               (*)
*ABRIR_ARCHIVO                          
*LEER_ARCHIVO                           
*ESCRIBIR_ARCHIVO                       
*CERRAR_ARCHIVO                         
*GENERAR_ALEATORIO                            (*)
*-----------------------------------------------------------

*-----------------------------------------------------------
INIT_SYSTEM:
*Descripción: Inicializa la parte gráfica, interrupción del
*timer y las variables

*ENTRADA: Nada
*SALIDA: nada
*REGISTROS MODIFICADOS: Nada
*----------------------------------------------------------- 

    MOVEM.L D0-D2, -(A7)        ;Guardamos los reg en la pila
    ORI.W #$0700, SR        ;Desactivamos todas las interrupciones
     
*Tratar FPS
*Utilizar una interrupción que active un registro de forma 
* periódica que usaremos como flag 
*los programas para sincronizarse en el tiempo solo se
*ejecutarán cuando se active este flag y si no lo está
*esperarán a que se active para ejecutarse

    ;configurar el timer
    MOVE.L  #ISR_TIMER, $78 ;Metemos el vector de interrupción
    CLR.B   FLAG_FRAMES ;limpiamos el flag de sincronizar
    
    ;Inicializar ventana gráfica
    MOVE.L  #PANTALLA_ANCHO<<16|PANTALLA_ALTO,D1
    MOVE.B  #T_GRAF_INIT, D0
    TRAP    #15
    
    ;limpiamos la pantalla
    MOVE.B #T_GRAF_LIMPIAR, D0
    MOVE.W #$FF00, D1
    TRAP #15
    ;reiniciamos variables
    CLR.B   TECLA_ASCII
    CLR.B   ESTADO_WASD ;estado es pulsado/no pulsado
    CLR.B   EDGE_WASD ;edge es si lo pulsas se vuelve 1 por un fotograma
    CLR.W   MOUSE_X
    CLR.W   MOUSE_Y
    CLR.B   MOUSE_CLICK
    
    ANDI.W #$F8FF, SR
    MOVEM.L (A7)+, D0-D2
    RTS
    
    
*-----------------------------------------------------------  
ISR_TIMER:
*Mete en el flag que creamos un 1 si se activa
*interrupción periodica de FPS
*ENTRADA: Nada
*SALIDA: nada
*REGISTROS MODIFICADOS:
*-----------------------------------------------------------  
    MOVE.B #1, FLAG_FRAMES
    RTE
* LIMPIA LA PANTALLA
* DIBUJA EL FONDO

* LEER EL TECLADO (PARA EL JUEGO WASD)

*-----------------------------------------------------------
LEER_TECLADO_JUEGO:
*Descripción: Actualiza las variables ESTADO_WASD segun 
*si se pulsaron (para el movimiento de PETE)

*ENTRADA: Nada
*SALIDA: (ESTADO_WASD) y (EDGE_WASD)
*REGISTROS MODIFICADOS: Nada
*-----------------------------------------------------------  
        MOVEM.L D0-D3, -(A7) ;Guardamos los registros
        MOVE.B #T_LEER4_TECLADO, D0
        MOVE.L #'W'<<24+'S'<<16+'A'<<8+'D', D1 ; W A S D
        TRAP #15
        
        CLR.B D2
        BSR .PACK_BITS ;Va a meter los 4 bits en d2
        
        MOVE.B (ESTADO_WASD), D0
        NOT.B D0
        AND.B D2, D0
        
        MOVE.B D2,(ESTADO_WASD)
        MOVE.B D0,(EDGE_WASD)
        
        MOVEM.L (A7)+, D0-D3 ;restauramos los registros
        RTS
        
.PACK_BITS  MOVE.W #3, D3
.LOOP       LSL.L #8, D1
            ROXL.B #1, D2 ;Mete el bit de estado en D2
            DBRA.W D3, .LOOP
            RTS
        


*-----------------------------------------------------------
LEER_TECLADO_MENU:
*Descripción: Lee las teclas del teclado que se usan para
*introducir tu nombre

*ENTRADA: Nada
*SALIDA: (TECLA_ASCII)
*REGISTROS MODIFICADOS: Nada
*----------------------------------------------------------- 


    MOVEM.L D0-D1, -(A7)    ;guardamos los registros   
    MOVE.B #T_LEER_TECLADO, D0 ; Leemos tecla
    TRAP #15
    TST.B D1 ;si no hay nada va a limpiar la variable
    BEQ .NO_ASCII
    
    MOVE.B #T_LEER_CARACTER, D0 ;leemos el caracter
    TRAP #15
    MOVE.B D1, TECLA_ASCII ;lo guardamos en D1
    BRA .NOM_PUESTO
    
.NO_ASCII:
    CLR.B   TECLA_ASCII ;la limpia
    
.NOM_PUESTO:
    MOVEM.L (A7)+, D0-D1
    RTS
    
    
    
*-----------------------------------------------------------
LEER_RATON:
*Descripción: Actualiza las coordenadas y el estado de botones
*del ratón

*ENTRADA: Nada
*SALIDA: (MOUSE_X)(MOUSE_Y), (MOUSE_CLICK)
*REGISTROS MODIFICADOS: Nada
*-----------------------------------------------------------

    MOVEM.L D0-D1, -(A7) ;Guardamos los registros en la pila 
    MOVE.B #T_LEER_RATON, D0
    TRAP #15
    ;esta tarea del trp15 devuelve en d0 el estado de los 
    ;botones y en D1 las coordenadas, marcando
    ;en la parte alta Y y en la baja X, por lo que:
    MOVE.W D1, MOUSE_X
    SWAP    D1  ;Intercambiamos partea lta y baja
    MOVE.W D1, MOUSE_Y
    MOVE.B D0, MOUSE_CLICK
    
    MOVEM.L (A7)+, D0-D1 ;Restauramos los registros
    RTS
    
    
*-----------------------------------------------------------
DIBUJAR_TEXTO_GFX:
*Descripción: 

*ENTRADA: 
*SALIDA: 
*REGISTROS MODIFICADOS: 
*-----------------------------------------------------------
    RTS
*-----------------------------------------------------------
DIBUJAR_RECTANGULO_RELLENO:
*Descripción: Dibuja un rectángulo relleno

*ENTRADA: D1.W X1 D2.W Y2 D3.W X2 D4.W Y2 D5. COLOR
*Recordatorio formato color = $00BBGGRR
*a destacar que por como está hecho el color del pen y del 
*relleno será siempre el mismo, si queremos hacer uno que
*no sea así hay que implementar otro
*SALIDA: Nada
*REGISTROS MODIFICADOS: Nada
*-----------------------------------------------------------
    MOVEM.L D0-D5, -(A7) ;Guardamos los registros
    MOVE.L D1, -(A7) ;Metemos en la pila D1 ya que primero hay
                     ;que definir el color del relleno
    MOVE.L D5, D1 ;Color del pen D5, que pasamos a D1 para el trap
    MOVE.B #T_PEN_COLOR, D0
    TRAP #15
    
    MOVE.L D5, D1 ;Lo mismo pero con color de relleno
    MOVE.B #T_FILL_COLOR, D0
    TRAP #15
    
    MOVE.L (A7)+, D1
    MOVE.B #T_GRAF_RECT, D0 ;Lo dibujamos con esos colores
    TRAP #15
    
    ;Por si acaso, ponemos que los colores se reestablezcan
    ;a negro para el futuro

            MOVE.L  #$00000000,D1
            MOVE.B  #T_PEN_COLOR,D0
            TRAP    #15

            MOVE.L  #$00FFFFFF,D1 
            MOVE.B  #T_FILL_COLOR,D0
            TRAP    #15
    
    MOVEM.L (A7)+, D0-D5 ;Los restauramos
    RTS
*-----------------------------------------------------------
DIBUJAR_ELIPSE:
*Descripción: Dibuja una elipse

*ENTRADA: D1.W X1 D2.W Y2 D3.W X2 D4.W Y2 D5. COLOR
*Recordatorio formato color = $00BBGGRR
*a destacar que por como está hecho el color del pen y del 
*relleno será siempre el mismo, si queremos hacer uno que
*no sea así hay que implementar otro
*SALIDA: Nada
*REGISTROS MODIFICADOS: Nada 
*-----------------------------------------------------------

    MOVEM.L D0-D5, -(A7) ;Guardamos los registros
    MOVE.L D1, -(A7) ;Metemos en la pila D1 ya que primero hay
                     ;que definir el color del relleno
    MOVE.L D5, D1 ;Color del pen D5, que pasamos a D1 para el trap
    MOVE.B #T_PEN_COLOR, D0
    TRAP #15
    
    MOVE.L D5, D1 ;Lo mismo pero con color de relleno
    MOVE.B #T_FILL_COLOR, D0
    TRAP #15
    
    MOVE.L (A7)+, D1
    MOVE.B #T_GRAF_ELIPSE, D0 ;Lo dibujamos con esos colores
    TRAP #15
    
    ;Por si acaso, ponemos que los colores se reestablezcan
    ;a negro para el futuro

            MOVE.L  #$00000000,D1
            MOVE.B  #T_PEN_COLOR,D0
            TRAP    #15

            MOVE.L  #$00FFFFFF,D1 
            MOVE.B  #T_FILL_COLOR,D0
            TRAP    #15
    
    MOVEM.L (A7)+, D0-D5 ;Los restauramos
    RTS

*-----------------------------------------------------------
DIBUJAR_SPRITE
*Descripción: Dibuja un SPRITE desde memoria recorriendo
*una matriz de colores píxel a píxel

*ENTRADA: A0.L Apunta al array de datos del sprite
*          D1.W = Coordenada x de la pantalla
*          D2.W = coordenada y de la pantalla
*          D3.W = Ancho del sprite en píxeles
*          D4.W = Alto del sprite en píxeles
*SALIDA: Nada
*REGISTROS MODIFICADOS: Nada
*-----------------------------------------------------------

        MOVEM.L D0-D2/A0, -(A7) ;Guardamos reg en la pila
        
        MOVE.W D2, D6
        

        MOVEM.L (A7)+, D0-D2/A0
        RTS
        
        
*-----------------------------------------------------------
CARGAR_SONIDO:
*Descripción: Carga archivo .wav en la memoria de sonido del
*simulador y le pone un ID

*ENTRADA: A1.L = Puntero a la ruta del archivo
*         D1.B = ID asignado al sonido
*SALIDA: nada
*REGISTROS MODIFICADOS: nada
*-----------------------------------------------------------

        MOVEM.L D0-D1/A1,-(A7)  ;Guaramos en la pila
        MOVE.B #T_CARGAR_SO, D0
        TRAP #15
        
        MOVEM.L (A7)+, D0-D1/A1 ;Restauramos los registros
        RTS
*-----------------------------------------------------------
REPRODUCIR_SONIDO:
*Descripción: Reproduce un sonido cargado anteriormente
*en memoria con su identificador

*ENTRADA: D1.B (ID del sonido a reproducir (Es .B, max 255 
*sonidos distintos)
*SALIDA: none
*REGISTROS MODIFICADOS: nada 
*-----------------------------------------------------------
        MOVEM.L D0-D1, -(A7)
        
        MOVE.B #T_REP_SO, D0
        TRAP #15
        
        MOVEM.L (A7)+, D0-D1
        RTS
*-----------------------------------------------------------
DETENER_SONIDO:
*Descripción: Para cualquier sonido activo

    *DUDA: Por como está hecho si ponemos música de fondo
*        la pararía, tendríamos que cambiarlo?

*ENTRADA: nada
*SALIDA: nada
*REGISTROS MODIFICADOS: nada
*-----------------------------------------------------------
        MOVEM.L D0-D2, -(A7)
        
        MOVE.L #3, D2
        MOVE.B #T_CTRL_SO, D0
        TRAP #15
        
        MOVEM.L (A7)+, D0-D2
        RTS
*-----------------------------------------------------------
ABRIR_ARCHIVO:
*Descripción: abre un archivo del disco o crea uno

*ENTRADA: A0.L = Puntero del nombre del archivo
*         D1.B = Como se abre, 0 si existe 1 si lo ha de
*         crear o sobrescribir 
*SALIDA:  D1.L = ID archivo
*         D0.W = Estado de lo que se hizo (BIEN = 0, MAL OTRA COSA)
*REGISTROS MODIFICADOS: D0 y D1
*-----------------------------------------------------------
        MOVEM.L A1, -(A7) ;GUARDAMOS EL REGISTRO
        MOVEA.L A0, A1 ;Lo copiamos en a1
        
        TST.B D1 ;Miramos el modo
        BNE .MODO_CREAR 
        
        MOVE.B #T_ABRIR_ARCHIVO, D0
        BRA .EJECUTAR_TRAP
        
.MODO_CREAR:
        MOVE.B #T_CREAR_ARCHIVO, D0
    
.EJECUTAR_TRAP:
        TRAP #15
        MOVEM.L (A7)+, A1 ;Restauramos el registro A1
        RTS
        
        
*-----------------------------------------------------------
LEER_ARCHIVO:
*Descripción: lee un bloque d bytes desde un archivo abierto
*y lo mete en un buffer

*ENTRADA: D1.L = ID archivo A0.L = Puntero al buffer al que va
*         D2.L = número de bytes a leer
*SALIDA: D2.L = número de bytes leídos D0.W = Estado
* Estados: 0 = bien, 1 = todo el archivo leido 2 = error
*REGISTROS MODIFICADOS: D0 y D2
*-----------------------------------------------------------
        MOVEM.L A1, -(A7) 
        MOVEA.L A0, A1
        MOVE.B #T_LEER_ARCHIVO, D0
        TRAP #15
        MOVEM.L (A7)+, A1
        RTS    
        
        
*-----------------------------------------------------------
ESCRIBIR_ARCHIVO:
*Descripción: Escribe un bloque de bytes desde un archivo
*abierto

*ENTRADA: D1.L = ID
*         A0.L = Puntero al buffer
*SALIDA: D0.W = Código de estado, éxito si es un 0
*REGISTROS MODIFICADOS: D0
*-----------------------------------------------------------
        MOVEM.L D1-D2/A1, -(A7) 
        MOVEA.L A0, A1
        MOVE.B #T_ESCRIBIR_ARCHIVO, D0
        TRAP #15
        MOVEM.L (A7)+, D1-D2/A1
        RTS    
         
         
*-----------------------------------------------------------
CERRAR_ARCHIVO:
*Descripción: Cierra un archivo abiert

*ENTRADA: D1.L = ID 
*SALIDA: D0.W = Código de estado (0 = exito)
*REGISTROS MODIFICADOS: D0
*-----------------------------------------------------------
        MOVEM.L D1, -(A7) 
        
        MOVE.B #T_CERRAR_ARCHIVO, D0
        TRAP #15
        
        MOVEM.L (A7)+, D1
        RTS


*-----------------------------------------------------------
GENERAR_ALEATORIO:
*Descripción: Genera un numero "aleatorio" (no es aleatorio)
* entre 0 y D1
*Esta subrutina utilizará la tarea 8 que devuelve en D1
* la hora del dia en centesimas de segundo

*aprovechamos esto y le hacemos algunos cambios para que sea
*un numero impredecible que simula uno aleatorio
*ENTRADA: D1.W el limite superior
*SALIDA: D1.W el numero generado
*REGISTROS MODIFICADOS:  D1, devuelve el numero aleatorio
*-----------------------------------------------------------
        MOVEM.L D0/D2-D3, -(A7)
        MOVE.W D1, D3 ; En D3 tenemos el limite superior
        BEQ .FIN ; Si es 0 acaba para evitar problemas de dividir
        
        MOVE.B #T_TIEMPO_SISTEMA, D0
        TRAP #15 ;Con esto tenemos en D1.L las centesimas de segundo
                 ;del instante
        
        
        ;Coger el tiempo y usarlo ya de por si puede dar siempre
        ;los mismos numeros, por eso uso ese numero como seed y le
        ;hago algunos cambios para que sea mas aleatorio aun
        
        ;Esta manera funciona pero no se si podríamos crear otra si
        ;se nos ocurre alguna mejor
        ADD.W (SEED_ALEATORIA), D1
        ROL.W #3, D1 ;Rotas bit
        ADD.W #13849, D1 ;Le sumamos cosas
        MOVE.W D1, (SEED_ALEATORIA)
        
        ANDI.L #$0000FFFF, D1 ;Lo limpiamos para quedarnos solo con 
                              ;las centesimas
        DIVU D3, D1 
        SWAP D1

.FIN
        MOVEM.L (A7)+, D0/D2-D3
        RTS
        
*-----------------------------------------------------------
*-----------------------------------------------------------
*VARIABLES
FLAG_FRAMES: DS.B    1
TECLA_ASCII: DS.B    1
ESTADO_WASD: DS.B    1
EDGE_WASD:   DS.B    1
MOUSE_X:     DS.W    1
MOUSE_Y:     DS.W    1
SEED_ALEATORIA: DS.W 1
MOUSE_CLICK: DS.B    1
             DS.W    0








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
