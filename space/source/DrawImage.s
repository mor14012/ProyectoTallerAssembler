@Universidad del Valle de Guatemala
@Taller de Assembler
@Sección: 11
@Martha Ligia Naranjo Franky
@Proyecto 2
@20/11/2015
@Juan Diego Benitez Caceres.	Carne: 14124
@Diego Alberto Morales Ibanez. 	Carne: 14012

.globl DrawImage
@-------------DrawImage------------
@------Parametros de Entrada-------
@ R0: Matriz de la imagen
@ R1: Posicion en X 
@ R2: Posicion en Y
@-----------Salidas --------------
@ Dibuja en pantalla la imagen 
@ seleccionada en la posicion especificada

DrawImage:				
	push {r4-r12, lr} 								@Se almacenan los registros en el SP				

	xCounter .req r5 								@Asignacion de alias a registros
	yCounter .req r6
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12
	position .req r7 								

	mov matrix, r0 											@Movimiento de la matriz del personaje													
	ldrh width, [r0, #-2] 									@Se carga el ancho del personaje
	ldrh height, [r0, #-4] 									@Se carga el alto del personaje							
	mov xPosition, r1 										@Movimiento de posicion en X del personaje
	mov yPosition, r2 										@Movimiento de posicion en Y del personaje
	
	mov position, #0 										@Asignacion de 0 a contador position
	add xCounter, xPosition, width  						@Inicializacion de contador en X
	add yCounter, yPosition, height 						@Inicializacion de contador en Y

	DIRow:	
		DIPixel:
			ldrh r0, [matrix, position] 					@Carga el color del personaje correspondiente
			bl SetForeColour 								@Llamada a subrutina SetForeColour
			mov r0, xPosition 								@Movimiento de xPosition a R0
			mov r1, yPosition								@Movimiento de yPosition a R1
			bl DrawPixel 									@Llamada a subrutina DrawPixel
			add position, #2 	 							@Se suma 2 al contador de position
			add xPosition, #1 								@Se suma 2 al contador de xPosition
			cmp xPosition, xCounter 						@Comparacion de xPosition con xCounter
			bne DIPixel 									@Si no son iguales entonces se repite el ciclo
	sub xPosition, width 									@Se resta el ancho de la imagen al xPosition							
	add yPosition, #1 										@Se suma 1 al yPosition
	cmp yPosition, yCounter 								@Comparacion de xPosition con xCounter
	bne DIRow 												@Si no son iguales entonces se repite el ciclo

	.unreq matrix 											@Se retiran asignaciones de alias
	.unreq height
	.unreq width
	.unreq xPosition
	.unreq yPosition
	.unreq position
	.unreq xCounter
	.unreq yCounter	
	pop {r4-r12, pc} 										@Se retiran los registros almacenados en el SP


.globl DrawImageTransparency
@------DrawImageTransparency-----
@------Parametros de Entrada-------
@ R0: Matriz de la imagen
@ R1: Posicion en X 
@ R2: Posicion en Y
@ R3: Color del fondo de la imagen a ignorar
@-----------Salidas --------------
@ Dibuja en pantalla la imagen 
@ seleccionada en la posicion especificada
@ ignorando el color de fondo

DrawImageTransparency:				
	push {r4-r12, lr} 	 									@Se almacenan los registros en el SP			

	transparency .req r4 									@Asignacion de alias a registros
	xCounter .req r5		
	yCounter .req r6
	position .req r7 										
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0 					 						@Movimiento de la matriz del personaje													
	ldrh width, [r0, #-2] 									@Se carga el ancho del personaje
	ldrh height, [r0, #-4]		 							@Se carga el alto del personaje							
	mov xPosition, r1										@Movimiento de posicion en X del personaje
	mov yPosition, r2 										@Movimiento de posicion en Y del personaje
	mov transparency, r3									@Movimiento de color de transparencia
	
	mov position, #0										@Asignacion de 0 a contador position
	add xCounter, xPosition, width 							@Inicializacion de contador en X
	add yCounter, yPosition, height 						@Inicializacion de contador en Y

	DITRow:	
		DITPixel:
			ldrh r0, [matrix, position] 					@Carga el color del personaje correspondiente
			cmp r0, transparency 							@Comparacion del color de transparencia con el color del personaje
			beq DITEnd 										@Si son iguales entonces no pinta nada
			bl SetForeColour 								@Llamada a subrutina SetForeColour
			mov r0, xPosition 								@Movimiento de xPosition a R0
			mov r1, yPosition 								@Movimiento de yPosition a R1
			bl DrawPixel 									@Llamada a subrutina DrawPixel
		DITEnd:
			add position, #2 								@Se suma 2 al contador de position
			add xPosition, #1 								@Se suma 2 al contador de xPosition
			cmp xPosition, xCounter 						@Comparacion de xPosition con xCounter
			bne DITPixel									@Si no son iguales entonces se repite el ciclo
	sub xPosition, width		 							@Se resta el ancho de la imagen al xPosition							
	add yPosition, #1 										@Se suma 1 al yPosition
	cmp yPosition, yCounter									@Comparacion de xPosition con xCounter
	bne DITRow 												@Si no son iguales entonces se repite el ciclo

	.unreq matrix 											@Se retiran asignaciones de alias
	.unreq height
	.unreq width
	.unreq xPosition
	.unreq yPosition
	.unreq transparency
	.unreq position
	.unreq xCounter
	.unreq yCounter
	pop {r4-r12, pc} 										@Se retiran los registros almacenados en el SP

.globl DrawBackground
@----------DrawBackground----------
@------Parametros de Entrada-------
@ R0: Matriz de la imagen de fondo
@ R1: Matriz de la imagen del personaje 
@ R2: Posicion en X 
@ R3: Posicion en Y
@-----------Salidas --------------
@ Dibuja en pantalla el fondo seleccionado
@ en la posicion especificada con el ancho
@ y alto de la imagen seleccionada

DrawBackground:				
	push {r4-r12, lr} 		 						@Se almacenan los registros en el SP			

	Next	.req r4 								@Asignacion de alias a registros
	xCounter .req r5 
	yCounter .req r6
	position .req r7 								
	xPosition .req r8
	yPosition .req r9
	matrix .req r10
	width .req r11
	height .req r12

	mov matrix, r0 									@Movimiento de la matriz del fondo 
	ldrh width, [r1, #-2] 							@Se carga el ancho del personaje
	ldrh height, [r1, #-4] 							@Se carga el alto del personaje
	mov xPosition, r2 								@Movimiento de posicion en X del personaje
	mov yPosition, r3 								@Movimiento de posicion en Y del personaje

	mov position, #1024 							@Asignacion de 1024 a position
	mul position,yPosition 							@Multiplicacion de Y*1024
	add position, xPosition 						@Se suma la posicion en X 	
	lsl position, #1 								@Multiplicacion por 2 (2 bytes por pixel)

	mov Next, #1024 								@Asignacion de 1024 a next (salto de linea)
	sub Next, width 								@Se resta el ancho de la imagen a 1024
	lsl Next, #1 									@Multiplicacion por 2 (2 bytes por pixel)

	add xCounter, xPosition, width 					@Inicializacion de contador en X
	add yCounter, yPosition, height					@Inicializacion de contador en Y

	DBRow:	
		DBPixel:
			ldrh r0, [matrix, position] 			@Carga el color del fondo correspondiente
			bl SetForeColour 						@Asigna el color 
			mov r0, xPosition 						@Movimiento de xPosition a R0
			mov r1, yPosition 						@Movimiento de yPosition a R1
			bl DrawPixel 							@Llamada a subrutina DrawPixel
			add position, #2 						@Se suma 2 al contador de position
 			add xPosition, #1 						@Se suma 2 al contador de xPosition
			cmp xPosition, xCounter 				@Comparacion de xPosition con xCounter
			bne DBPixel 							@Si no son iguales entonces se repite el ciclo
	add position, Next 								@Se suma el salto de linea al contador position
	sub xPosition, width 							@Se resta el ancho de la imagen al xPosition
	add yPosition, #1 								@Se suma 1 al yPosition
	cmp yPosition, yCounter 						@Comparacion de xPosition con xCounter
	bne DBRow 										@Si no son iguales entonces se repite el ciclo

	.unreq matrix 									@Se retiran asignaciones de alias
	.unreq height 
	.unreq width
	.unreq xPosition
	.unreq yPosition
	.unreq position
	.unreq xCounter
	.unreq yCounter
	pop {r4-r12, pc} 								@Se retiran los registros almacenados en el SP
