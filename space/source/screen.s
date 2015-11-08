@Pantalla de Inicio
.globl screen1
screen1:

	b screen1

@Pantalla de seleccion de personaje
.globl screen2
screen2:

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
	mov r0,#0
	mov r1,#0
	ldr r2,=1024
	ldr r3,=768
	bl DrawRectangle
	pop {pc}
