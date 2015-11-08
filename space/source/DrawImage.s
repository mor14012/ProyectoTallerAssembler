.globl DrawImage
@------DrawImage-----
@---Parametros de Entrada---
@ R0: Matriz de la imagen
@ R1: Ancho de la imagen
@ R2: Alto de la imagen
@ R3: Posicion en X del alien
@ Stack: Posicion en Y del alien
@--- Salidas ---
DrawImage:
	pop {r4} 					/*Se obtiene del stack la posicion en Y del alien a dibujar*/
	push {r10-r12, lr}
	xPosition .req r8
	YPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0
	mov width, r1
	mov height, r2

	x .req r3
	y .req r4
	position .req r5
	mov position, #0

	mov y, height

	DIRow:
		mov x, width
		DIPixel:
		ldr r0, [matrix, position]
		bl SetForeColour 		/*Se carga el color respectivo del pixel de la imagen del alien*/
		@etc

		bl DrawPixel



	ldr r2, =alien1_a
	ldr r2, [r2]
	mov r0, r2
	push {lr}
	bl SetForeColour
	pop {lr}
	mov r0, posx
	ldr r0, =xPosition
	ldr r0, =[xPosition, counterOtro]
	mov r1, poxy
	push {lr}
	bl drawPixel

	pop {r10-r12, pc}





/*
	ldr r2, =alien1_a
	ldr r2, [r2]
	mov r0, r2
	push {lr}
	bl SetForeColour
	pop {lr}
	mov r0, posx
	ldr r0, =xPosition
	ldr r0, =[xPosition, counter]
	mov r1, poxy
	push {lr}
	bl drawPixel
	*/