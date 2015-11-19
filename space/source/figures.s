@Universidad del Valle de Guatemala
@Taller de Assembler
@Sección: 11
@Martha Ligia Naranjo Franky
@Proyecto 2
@20/11/2015
@Juan Diego Benitez Caceres.	Carne: 14124
@Diego Alberto Morales Ibanez. 	Carne: 14012

.globl DrawRectangle
@ --------DrawRectangle---------
@ Dibuja una Rectangulo con relleno
@-----Parametros de Entrada--
@ 	R0: Posicion inicial en X
@	R1: Posicion inicial en Y
@	R2: Ancho del rectangulo
@	R3: Alto del rectangulo
@-----Parametros de Salida---
@ Muestra en pantalla el rectangulo
@ con los parametros ingresados
@----------------------------

DrawRectangle:
	push {r4-r12,lr}					@Se almacenan los registros en el stack
	X		.req r12					@Asignacion de alias a registros
	Y		.req r11
	Width 	.req r10
	Height	.req r9
	Counter .req r8

	mov X, r0							@Movimiento de r0 a X con posicion inicial 
	mov Y, r1							@Movimiento de r1 a Y con posicion inicial
	mov Width, r2						@Movimiento de r2 del ancho del rectangulo
	mov Height, r3						@Movimiento de r3 de la altura del rectangulo
	add Counter, Y, Height				@Se le suma la altura y posicion incial en Y al contador

	DRDraw:
		DRFill:
			mov r0, X					@Movimiento a r0 posicion inicial en X
			mov r1, Y					@Movimiento a r1 posicion inicial en y
			add r2, X, Width			@En r2 la suma del ancho y la posicion inicial 
			mov r3, Y					@Movimiento de Y a r3
			bl DrawLine					@Se llama a la subrutina DrawLine

			add Y, #1					@Se le suma uno a Y

			cmp Y, Counter				@Comparacion entre y y el contador
			bne DRDraw					@Si no es igual se repite hasta que termine

	.unreq X							@Se retira asignacion de alias
	.unreq Y							@Se retira asignacion de alias
	.unreq Width						@Se retira asignacion de alias
	.unreq Height						@Se retira asignacion de alias
	.unreq Counter						@Se retira asignacion de alias

	pop {r4-r12, pc}					@Se retornan los valores originales almacenados en el stack
