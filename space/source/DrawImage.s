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
	push {r4-r12, lr} 				

	xCounter .req r5
	yCounter .req r6
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0
	ldrh width, [r1]
	ldrh height, [r2]
	mov xPosition, r3
	mov yPosition, r4

	position .req r7 								/*Contador para la matriz*/
	mov position, #0

	add xCounter, xPosition, width
	add yCounter, yPosition, height

	DIRow:	
		DIPixel:
			ldr r0, [matrix, position]
			bl SetForeColour 							/*Se carga el color respectivo del pixel de la imagen del alien*/
			mov r0, xPosition
			mov r1, yPosition
			bl DrawPixel
			add position, #2
			add xPosition, #1
			cmp xPosition, xCounter
			bne DIPixel
	sub xPosition, width
	add yPosition, #1
	cmp yPosition, yCounter
	bne DIRow

	pop {r4-r12, pc}
