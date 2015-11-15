.globl DrawImage
@------DrawImage-----
@---Parametros de Entrada---
@ R0: Matriz de la imagen
@ R1: Posicion en X 
@ R2: Posicion en Y
@--- Salidas ---

DrawImage:				
	push {r4-r12, lr} 				

	xCounter .req r5
	yCounter .req r6
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0
	ldrh width, [r0, #-2]
	ldrh height, [r0, #-4]
	mov xPosition, r1
	mov yPosition, r2

	position .req r7 								/*Contador para la matriz*/
	mov position, #0

	add xCounter, xPosition, width
	add yCounter, yPosition, height

	DIRow:	
		DIPixel:
			ldrh r0, [matrix, position]
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

	.unreq matrix
	.unreq height
	.unreq width
	.unreq xPosition
	.unreq yPosition
	.unreq position
	.unreq xCounter
	.unreq yCounter
	pop {r4-r12, pc}


.globl DrawImageTransparency
@------DrawImageTransparency-----
@---Parametros de Entrada---
@ R0: Matriz de la imagen
@ R1: Posicion en X 
@ R2: Posicion en Y
@ R3: Color del fondo de la imagen a ignorar
@--- Salidas ---

DrawImageTransparency:				
	push {r4-r12, lr} 				

	transparency .req r4
	xCounter .req r5
	yCounter .req r6
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0
	ldrh width, [r0, #-2]
	ldrh height, [r0, #-4]
	mov xPosition, r1
	mov yPosition, r2
	mov transparency, r3

	position .req r7 								/*Contador para la matriz*/
	mov position, #0

	add xCounter, xPosition, width
	add yCounter, yPosition, height

	DITRow:	
		DITPixel:
			ldrh r0, [matrix, position]
			cmp r0, transparency
			beq DITEnd
			bl SetForeColour 							/*Se carga el color respectivo del pixel de la imagen del alien*/
			mov r0, xPosition
			mov r1, yPosition
			bl DrawPixel

		DITEnd:
			add position, #2
			add xPosition, #1
			cmp xPosition, xCounter
			bne DITPixel
	sub xPosition, width
	add yPosition, #1
	cmp yPosition, yCounter
	bne DITRow

	.unreq matrix
	.unreq height
	.unreq width
	.unreq xPosition
	.unreq yPosition
	.unreq transparency
	.unreq position
	.unreq xCounter
	.unreq yCounter
	pop {r4-r12, pc}

.globl DrawBackground
@------DrawBackground-----
@---Parametros de Entrada---
@ R0: Matriz de la imagen de fondo
@ R1: Matriz de la imagen del personaje 
@ R2: Posicion en X 
@ R3: Posicion en Y
@--- Salidas ---

DrawBackground:				
	push {r4-r12, lr} 				

	Next	.req r4
	xCounter .req r5
	yCounter .req r6
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0
	ldrh width, [r1, #-2]
	ldrh height, [r1, #-4]
	mov xPosition, r2
	mov yPosition, r3

	position .req r7 								/*Contador para la matriz*/
	mov position, #0

	mov position, #1024
	mul position,yPosition
	add position, xPosition
	lsl position, #1

	mov Next, #1024
	sub Next, width
	lsl Next, #1

	add xCounter, xPosition, width
	add yCounter, yPosition, height

	DBRow:	
		DBPixel:
			ldrh r0, [matrix, position]
			bl SetForeColour 							/*Se carga el color respectivo del pixel de la imagen del alien*/
			mov r0, xPosition
			mov r1, yPosition
			bl DrawPixel
			add position, #2
			add xPosition, #1
			cmp xPosition, xCounter
			bne DBPixel
		@Salto de linea
	add position, Next
	sub xPosition, width
	add yPosition, #1
	cmp yPosition, yCounter
	bne DBRow

	.unreq matrix
	.unreq height
	.unreq width
	.unreq xPosition
	.unreq yPosition
	.unreq position
	.unreq xCounter
	.unreq yCounter
	pop {r4-r12, pc}
