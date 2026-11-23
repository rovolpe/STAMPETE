*-----------------------------------------------------------
*LEADERBOARD

*Hará dos cosas al acabar una partida:

*+-Escribe en un archivo los datos de un usuario, guardando su nombre y
*su total de tiempo.
*-Reordena el archivo de leaderboard para que estén ordenados en top

*Cuando entra en el inicio al apartado de leaderboard:
*-Lee el archivo y lo muestra en pantalla indicando el nombre y el
*total del tiempo

*-----------------------------------------------------------


* 1. Abrir fichero en el que escribir


 *Descripción: abre un archivo del disco o crea uno

*ENTRADA: A0.L = Puntero del nombre del archivo
*         D1.B = Como se abre, 0 si existe 1 si lo ha de
*         crear o sobrescribir 
*SALIDA:  D1.L = ID archivo
*         D0.W = Estado de lo que se hizo (BIEN = 0, MAL OTRA COSA)
*REGISTROS MODIFICADOS: D0 y D1
*

*ABRIR_LEADERBOARD:

 *  MOVEM.L D0-D1/A0 , -(A7)
    
  * MOVE.B #0, D1
   *LEA NOMBRE_FICHERO, A0
  * BSR ABRIR_ARCHIVO
   
   *MOVE.L D1, ID_FICHEROS
   *MOVEM (A7)+, D0-D1/A0
   
   *RTS
   
   
* ESCRIBIR EL LEADERBOARD
*Descripción: Escribe un bloque de bytes desde un archivo
*abierto

*ENTRADA: D1.L = ID
*         A0.L = Puntero al buffer
*SALIDA: D0.W = Código de estado, éxito si es un 0
*REGISTROS MODIFICADOS: D0


ESCRIBIR_LEADERBOARD:


* ORDENAR LA LISTA
* LEER LA LISTA
* DIBUJAR LA LISTA
* SALIR DEL LEADERBOARD



*NOMBRE_FICHERO:  DC.B 'leaderboard.txt',0
  * DS.W 0 
 *  DC.L ID_FICHEROS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
