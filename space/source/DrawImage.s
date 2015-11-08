@Universidad del Valle de Guatemala
@Taller de Assembler
@Sección: 11
@Martha Ligia Naranjo Franky
@Laboratorio 6
@05/10/2015
@Diego Alberto Morales Ibanez. Carne: 14012
@Christopher Antonio Chiroy Miranda. Carne: 14411 

.globl DrawImage
@ --------DrawImage---------
@ Dibuja una imagen seleccionada
@ en una posicion especifica
@ de la pantalla utilizando 
@ los parametros de entrada
@-----Parametros de Entrada--
@ 	R0: FrameBuffer Info Address
@	R1: Matriz de datos de imagen
@	R2: Valor de altura de imagen
@	R3: Valor de ancho de imagen
@	*Pila
@	P1: Posicion en y
@	P2: Posicion en x
@-----Parametros de Salida---
@ 	Muestra en pantalla la imagen
@ 	con los parametros especificados
@----------------------------
DrawImage:
	pop {r4, r5} 							@Se recuperan los registros de posicion en X y Y
	push {r4-r12}							@Se almacenan los registros R4-R12 en el Stack

	Fb .req r12 							@Asignacion de nombres a registros
	Image 	.req r11
	Height 	.req r10
	Width	.req r9
	vHeight	.req r8
	vWidth 	.req r7
	YPosition .req r6
	XPosition .req r5

	mov Fb, r0 								@Se asignan los parametros ingresados a registros locales
	mov Image, r1
	ldrh Height, [r2]
	ldrh Width, [r3]
	mov YPosition, r4
	
	DIVerification: 						@Revisa que la posicion y tamano de la imagen no salga de la pantalla
		ImageWidth 	.req r0 				@Asignacion de nombres a registros
		ImageHeight .req r1
		ldr vWidth, [Fb] 					@Se carga el Virtual Width  del FrameBuffer
		ldr vHeight, [Fb, #4]				@Se carga el Virtual Height  del FrameBuffer
		add ImageWidth, Width, XPosition 	@Se suma el ancho de la imagen y su posicion en X
		add ImageHeight, Height, YPosition  @Se suma el alto de la imagen y su posicion en Y
		cmp ImageWidth, vWidth 				@Si el ancho+posicionX de la imagen son mayores a el ancho de pantalla
		bgt DIError							@Salta a la subrutina que indica que hubo un error
		cmp ImageHeight, vHeight			@Si el alto+posicionY de la imagen son mayores a el alto de pantalla
		bgt DIError							@Salta a la subrutina que indica que hubo un error	

	.unreq vHeight	 						@Se retira la asignacion de nombres a registros
	.unreq vWidth
	.unreq ImageHeight
	.unreq ImageWidth
		 		
	Position 	.req r8						@Asignacion de nombre a registro

	DIPosition:								@Calculo de la posicion inicial de la imagen en pantalla [2(1024*Y + X)]
		mov Position, #1024 				@Se asigna el ancho de la pantalla 
		mul Position, YPosition 			@Se multiplica el ancho por la posicion en Y
		add Position, XPosition				@Se suma la posicion en X
		lsl Position, #1 					@Se multiplica todo por 2 (2 bytes por pixel)

	.unreq YPosition 						@Se retira la asignacion de nombres a registros
	.unreq XPosition
	
	Counter .req r7 						@Asignacion de nombres a registros
	Colour 	.req r6

	ldr Fb, [Fb, #32]						@Se carga el puntero del FrameBuffer
	mov Counter, #0 						@Se asigna #0 al contador de bytes dibujados de la imagen

	Y 	.req r5 							@Asignacion de nombres a registros
	X 	.req r4
	Next	.req r3
	DINext: 								@Calculo del salto de linea de la imagen (1024-Ancho)*2
		ldr Next, =1024 					@Se asigna 1024
		sub Next, Width 					@Se resta el ancho de la imagen
		lsl Next, #1 						@Se multiplica todo por 2 (2 bytes por pixel)

	mov Y, Height     						@Asignacion del alto de la imagen al contador en Y
	DIRow:
		mov X, Width 						@Asignacion del ancho de la imagen al contador en X
		DIPixel:
			ldrh Colour, [Image, Counter] 	@Carga el valor especifico de la matriz de la imagen 
			ldr r0,=63519 					@Carga el valor 63519 (color rosado brillante)
			cmp Colour, r0 					@Compara el color de la imagen con el rosado brillante
			beq DINoDraw 					@Si son iguales entonces no pinta el pixel (para eliminar el fondo de la imagen)
			strh Colour, [Fb, Position]		@Se almacena el color de la imagen en la direccion del FrameBuffer especificada por la posicion en X y Y
			DINoDraw:
				add Fb, #2 					@Se suma 2 al puntero del FrameBuffer
				add Counter, #2 			@Se suma 2 al contador de la matriz de la imagen
				sub X, #1 					@Se resta 1 al contador en X
				teq X, #0 					@Se compara el contador en X con 0
				bne DIPixel 				@Si no es igual se repite la etiqueta DIPixel
		add Fb, Next 						@Se suma el salto de linea de la imagen al puntero del FrameBuffer	
		sub Y, #1 							@Se resta 1 al contador en Y
		teq Y, #0 							@Se compara el contador en Y con 0
		bne DIRow 							@Si no es igual se repite la etiqueta DIRow

	.unreq Fb 								@Se retira la asignacion de nombres a registros
	.unreq Image
	.unreq Height
	.unreq Width
	.unreq Position
	.unreq X
	.unreq Y
	.unreq Counter
	.unreq Colour
	.unreq Next
	
	pop {r4-r12} 							@Se retornan los valores originales de los registros R4-R12
	mov pc, lr 								@Se retorna el Progrma Counter al valor almacenado en el Link Register

DIError: 									@Etiqueta que indica que ha sucedido un error encendiendo el led del pin 16
	mov r0, #16								@Configuracion del pin 16 como salida (write)
	mov r1, #0				
	bl SetGpio 								
	mov r0, #16 							@Se menciende el pin 16
	mov r1, #0
	bl SetGpio
	mov pc, lr


.globl ReDrawImage
@ --------ReDrawImage---------
@ Dibuja una imagen de fondo
@ en una posición específica 
@ de un tamaño predeterminado.
@ Utilizada para volver a pintar
@ los pixeles de un fondo que han
@ sido modificados por una imagen
@ colocada con la subrutina DrawImage
@-----Parametros de Entrada--
@ 	R0: FrameBuffer Info Address
@	R1: Matriz de datos del fondo
@	R2: Valor de altura de imagen
@	R3: Valor de ancho de imagen
@	*Pila
@	P1: Posicion en y
@	P2: Posicion en x
@-----Parametros de Salida---
@ 	Pinta los pixeles del fondo
@ en la posicion y tamaño especificados
@----------------------------
	ReDrawImage:
		pop {r4, r5}							@Se recuperan los registros de posicion en X y Y
		push {r4-r12}							@Se almacenan los registros R4-R12 en el Stack

		Fb .req r12 							@Asignacion de nombres a registros
		Image 	.req r11
		Height 	.req r10
		Width	.req r9
		YPosition .req r6
		XPosition .req r5

		mov Fb, r0 								@Se asignan los parametros ingresados a registros locales
		mov Image, r1
		ldrh Height, [r2]
		ldrh Width, [r3]
		mov YPosition, r4
			
		Position 	.req r8						@Asignacion de nombre a registro

		RDIPosition:							@Calculo de la posicion inicial del fondo en pantalla [2(1024*Y + X)]
			mov Position, #1024 				@Se asigna el ancho de la pantalla 
			mul Position, YPosition 			@Se multiplica el ancho por la posicion en Y
			add Position, XPosition 			@Se suma la posicion en X
			lsl Position, #1 					@Se multiplica todo por 2 (2 bytes por pixel)

		.unreq YPosition 						@Se retira la asignación de nombres a registros				
		.unreq XPosition 	
		
		Counter .req r7 						@Asignacion de nombres a registros
		Colour 	.req r6 	

		ldr Fb, [Fb, #32] 						@Se carga el puntero del FrameBuffer
		mov Counter, Position 					@Se asigna la posicion de la imagen al contador de bytes dibujados del fondo

		Y 	.req r5 							@Asignacion de nombres a registros
		X 	.req r4
		Next	.req r3
		RDINext: 								@Calculo del salto de linea del fondo (1024-Ancho)*2
			ldr Next, =1024 					@Se asigna 1024
			sub Next, Width 					@Se resta el ancho de la imagen
			lsl Next, #1 						@Se multiplica todo por 2 (2 bytes por pixel)

		mov Y, Height     						@Asignacion del alto de la imagen al contador en Y
		RDIRow:
			mov X, Width 						@Asignacion del ancho de la imagen al contador en X
			RDIPixel:
				ldrh Colour, [Image, Counter]   @Carga el valor especifico de la matriz del fondo
				ldrh r0, [Fb, Position] 		@Carga el valor del pixel del FrameBuffer
				cmp Colour, r0 					@Compara si son iguales
				beq RDINoDraw 					@Si son iguales entonces no pinta de nuevo el mismo color de pixer
				strh Colour, [Fb, Position] 	@Se almacena el color de la imagen en la direcccion del FrameBuffer especificada por la posicion en X y Y
				RDINoDraw:
					add Fb, #2 					@Se suma 2 al puntero del FrameBuffer
					add Counter, #2 			@Se suma 2 al contador de la matriz del fondo
					sub X, #1 					@Se resta 1 al contador en X
					teq X, #0 					@Se compara el contador en X con 0
					bne RDIPixel 				@Si no es igual se repite la etiqueta DIPixel
			add Counter, Next 					@Se suma el salto de linea de la imagen al contador de pixeles de la matriz del fondo
			add Fb, Next 						@Se suma el salto de linea de la imagen al puntero del FrameBuffer	
			sub Y, #1 							@Se resta 1 al contador en Y
			teq Y, #0 							@Se compara el contador en Y con 0
			bne RDIRow 							@Si no es igual se repite la etiqueta DIRow
 	
		.unreq Fb 								@Se retira la asignacion de nombres a registros
		.unreq Image
		.unreq Height
		.unreq Width
		.unreq Position
		.unreq X
		.unreq Y
		.unreq Counter
		.unreq Colour
		.unreq Next
		
		pop {r4-r12} 							@Se retornan los valores originales de los registros R4-R12
		mov pc, lr	 							@Se retorna el Progrma Counter al valor almacenado en el Link Register
