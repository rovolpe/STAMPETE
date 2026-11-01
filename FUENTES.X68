*-----------------------------------------------------------
* FUENTES
*-----------------------------------------------------------


*LÓGICA DE FONT_DIGITOS
*1 = color 0 = transparente
*Usamos de ancho 5 pixeles y los 3 mas altos siempre son 0
          
FONT_DIGITOS:
    ; 0 
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110
   
    ; 1 
    DC.B %00000100
    DC.B %00001100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00001110
    ; 2 
    DC.B %00001110
    DC.B %00010001
    DC.B %00000001
    DC.B %00000110
    DC.B %00001000
    DC.B %00010000
    DC.B %00011111
    ; 3 
    DC.B %00001110
    DC.B %00010001
    DC.B %00000001
    DC.B %00000110
    DC.B %00000001
    DC.B %00010001
    DC.B %00001110
    ; 4 
    DC.B %00000010
    DC.B %00000110
    DC.B %00001010
    DC.B %00010010
    DC.B %00011111
    DC.B %00000010
    DC.B %00000010
    ; 5 
    DC.B %00011111
    DC.B %00010000
    DC.B %00011110
    DC.B %00000001
    DC.B %00000001
    DC.B %00010001
    DC.B %00001110
    ; 6 
    DC.B %00001110
    DC.B %00010000
    DC.B %00011110
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110
    ; 7 
    DC.B %00011111
    DC.B %00000001
    DC.B %00000010
    DC.B %00000100
    DC.B %00001000
    DC.B %00001000
    DC.B %00001000
    ; 8 
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110
    ; 9 
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00001111
    DC.B %00000001
    DC.B %00000001
    DC.B %00001110
    ; : 
    DC.B %00000000
    DC.B %00000100
    DC.B %00000100
    DC.B %00000000
    DC.B %00000100
    DC.B %00000100
    DC.B %00000000
    DS.W 0
    
    
FONT_LETRAS:
    ; A
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00011111
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001

    ; B
    DC.B %00011110
    DC.B %00010001
    DC.B %00010001
    DC.B %00011110
    DC.B %00010001
    DC.B %00010001
    DC.B %00011110

    ; C
    DC.B %00001110
    DC.B %00010001
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000
    DC.B %00010001
    DC.B %00001110

    ; D
    DC.B %00011110
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00011110

    ; E
    DC.B %00011111
    DC.B %00010000
    DC.B %00010000
    DC.B %00011110
    DC.B %00010000
    DC.B %00010000
    DC.B %00011111

    ; F
    DC.B %00011111
    DC.B %00010000
    DC.B %00010000
    DC.B %00011110
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000

    ; G
    DC.B %00001110
    DC.B %00010000
    DC.B %00010000
    DC.B %00010111
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110

    ; H
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00011111
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001

    ; I
    DC.B %00001110
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00001110

    ; J
    DC.B %00001110
    DC.B %00000010
    DC.B %00000010
    DC.B %00000010
    DC.B %00000010
    DC.B %00010010
    DC.B %00001100

    ; K
    DC.B %00010010
    DC.B %00010100
    DC.B %00011000
    DC.B %00011100
    DC.B %00011000
    DC.B %00010100
    DC.B %00010010

    ; L
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000
    DC.B %00011111

    ; M
    DC.B %00010001
    DC.B %00011011
    DC.B %00010101
    DC.B %00010101
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001

    ; N
    DC.B %00010001
    DC.B %00011001
    DC.B %00010101
    DC.B %00010011
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001

    ; O
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110

    ; P
    DC.B %00011110
    DC.B %00010001
    DC.B %00010001
    DC.B %00011110
    DC.B %00010000
    DC.B %00010000
    DC.B %00010000

    ; Q
    DC.B %00001110
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010101
    DC.B %00010010
    DC.B %00001101

    ; R
    DC.B %00011110
    DC.B %00010001
    DC.B %00010001
    DC.B %00011110
    DC.B %00010100
    DC.B %00010010
    DC.B %00010001

    ; S
    DC.B %00001111
    DC.B %00010000
    DC.B %00001110
    DC.B %00000001
    DC.B %00000001
    DC.B %00010001
    DC.B %00001110

    ; T
    DC.B %00011111
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100

    ; U
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00001110

    ; V
    DC.B %00010001
    DC.B %00010001
    DC.B %00010001
    DC.B %00001010
    DC.B %00001010
    DC.B %00000100
    DC.B %00000100

    ; W
    DC.B %00010001
    DC.B %00010001
    DC.B %00010101
    DC.B %00010101
    DC.B %00010101
    DC.B %00011011
    DC.B %00010001

    ; X
    DC.B %00010001
    DC.B %00010001
    DC.B %00001010
    DC.B %00000100
    DC.B %00001010
    DC.B %00010001
    DC.B %00010001

    ; Y
    DC.B %00010001
    DC.B %00010001
    DC.B %00001010
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100
    DC.B %00000100

    ; Z
    DC.B %00011111
    DC.B %00000001
    DC.B %00000010
    DC.B %00000100
    DC.B %00001000
    DC.B %00010000
    DC.B %00011111

    DS.W 0
    
    
DIBUJAR_LETRA:
*Funciona igual que con los numeros, que, de hecho, podriamos
*ponerlo aqui para mas modularidad

    MOVEM.L D0-D7/A0, -(A7)
    ;La unica diferencia es que aqui va a leer un valor ascii
    ;por ello, si es 65 es la A, y va sumando 1 en cada caso
    ;Para calcularlo le restaremos 65 a cada uno. Es decir
    ;Que nos quedarán las letras enumeradas siendo la A la 0
    ;En la parte baja de D0
    AND.W #$00FF, D0

    CMP.W   #32, D0
    BEQ     .ES_ESPACIO
    
    
    CMP.W   #65, D0          
    BLT     .SALIDA_NADA   
    CMP.W   #90, D0         
    BGT     .SALIDA_NADA
        
    

    SUB.W #65, D0
    BMI .FIN_LETRA ;Si es menos de un 0 salimos
    
    MOVE.W D0, D1
    MULU.W #7, D1 ;Por como lo organizamos cada letra son 7 bytes
    
    LEA FONT_LETRAS, A0
    ADDA.L D1, A0 ;Apuntamos con A0 al primer byte de la letra
    
    ;Bucle que dibuja las 7 filas
    
    MOVE.W #0, D2 ;Es el contador de la fila en la que estamos
    
.BUCLE_FILA:
    CMP.W #7, D2 ;Si es la septima ya ha hecho todas (va de 0 a 6)
    BGE .FIN_LETRA
    
    MOVE.B (A0)+, D3 ;d3 son los bits de esta fila
    MOVE.W #0, D6 ;D6 es el contador de la columna por la que va
    
.BUCLE_COL:
    CMP.W #8, D6
    BGE .SIGUIENTE_FILA
    
    ;MIRAMOS SI EL BIT ES UN 1, SI ES UN 1 DIBUJA
    LSL.B #1, D3 ;Desplazar bit izquierda
    BCC .SALTAR_PIXEL ;Se lo salta si es un 0
    
    ;Caso que es un 1: Lo tiene que pintar
    MOVEM.L D2/D3/D6/A0, -(A7)
    
    MOVE.W TEXTO_CURSOR_X, D1
    
    MOVE.W D6, D5               ; D4 es la columna actual

    MULU.W #3, D5               ; tam pixel x3
    ADD.W  D5, D1               ; X1
    MOVE.W D1, D3
    ADD.W  #3, D3               ; X2 =X1+3
    
    MOVE.W TEXTO_CURSOR_Y, D7
    MOVE.W D2, D5             
    MULU.W #3, D5
    ADD.W  D5, D7               ; Y1
    
    MOVE.W D7, D5
    ADD.W #3, D5
    
    MOVE.W D7, D2
    MOVE.W D5, D4
    MOVE.L #$00FFFFFF, D5
    BSR DIBUJAR_RECTANGULO_RELLENO
    
    MOVEM.L (A7)+, D2/D3/D6/A0
.SALTAR_PIXEL:
    ADDQ.W #1, D6
    BRA .BUCLE_COL
    
.SIGUIENTE_FILA:
    ADDQ.W #1, D2
    BRA .BUCLE_FILA
.FIN_LETRA:
.ES_ESPACIO:
    ADD.W #27, TEXTO_CURSOR_X ;Le sumamos 27 para ir a escribir la sig letra

.SALIDA_NADA
    MOVEM.L (A7)+, D0-D7/A0
    RTS

MOSTRAR_TEXTO_CENTRADO:
*Descripción: Te dibuja una cadena de texto centrada en la pantalla

    MOVEM.L D0-D2/A0/A1, -(A7)
    
    *Primero de todo calculamos como estaría centrado
    *Sería el ancho de la pantalla menos el del texto entre 2
    *INTRODUCE TU NOMBRE serian 19 caracteres 
    *La escala es 3x
    *La pantalla es de 800 de ancho 
    *Serian mas o menos 150
    
    MOVE.W #144, TEXTO_CURSOR_X
    MOVE.W D0, TEXTO_CURSOR_Y
    
.BUCLE_IMP
    MOVE.B (A0)+, D0 ;Leemos el siguiente caracter
    CMP.B #0, D0 ;Miramos si es el final de la cadena (0)
    BEQ .FIN_TEXTO
    
    BSR DIBUJAR_LETRA
    
    BRA     .BUCLE_IMP
.FIN_TEXTO
    MOVEM.L (A7)+, D0-D2/A0/A1
    RTS



    

*VARIABLES
TEXTO_CURSOR_X:     DS.W 1
TEXTO_CURSOR_Y:     DS.W 1
MENSAJE_INTRO:  DC.B 'INTRODUCE TU NOMBRE',0









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
