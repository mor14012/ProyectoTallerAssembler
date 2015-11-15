@Pantalla de Inicio
.globl screen1
screen1:
	b screen2
	
	b screen1

@Pantalla de seleccion de personaje
.globl screen2
screen2:
	push {lr}
	ldr r0, =mann
	mov r1, #0
	mov r2, #1
	bl DrawImage 		/*Dibujo de fondo temporal*/

	bl tank 			/*Dibujo del tanque*/

	bl alien
	pop {lr}
	b screen2

@Pantalla de juego
.globl screen3
screen3:

	b screen3

@Pantalla de resultados
.globl screen4
screen4:
	
	b screen4

@Pantalla de instrucciones
.globl screen5
screen5:
	
	b screen5

.globl clear
clear:
	push {lr}
	mov r0, #0
	bl SetForeColour
	
	mov r0,#0
	mov r1,#0
	ldr r2,=1024
	ldr r3,=384
	bl DrawRectangle
	pop {pc}
