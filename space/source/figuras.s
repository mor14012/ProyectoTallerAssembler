@Universidad del Valle de Guatemala
@Taller de Assembler
@Sección: 11
@Martha Ligia Naranjo Franky
@Diego Alberto Morales Ibanez. Carne: 14012


.globl DrawCircle
@ --------DrawCircle---------
@ Dibuja una circulo con relleno
@ o sin relleno.
@-----Parametros de Entrada--
@ 	R0: Posicion inicial en X
@	R1: Posicion inicial en Y
@	R2: Radio del circulo
@	R3: Relleno (1=Si)
@-----Parametros de Salida---
@ Muestra en pantalla el circulo
@ con los parametros ingresados
@----------------------------

DrawCircle:
	push {r7-r12, lr} 					@Se almacenan los registros en el stack
	Xo				.req r12 			@Asignacion de alias a registros
	Yo				.req r11
	X 				.req r10
	Y 				.req r9
	Fill 			.req r8
	radiusError 	.req r7	

	mov Xo, r0 							@Movimiento de la posicion inicial en X a Xo
	mov Yo, r1 							@Movimiento de la posicion inicial en Y a Yo
	mov X, r2 							@Movimiento del radio del circulo a X
	mov Y, #0 							@Asignacion de 0 a Y
	mov Fill, r3 						@Movimiento del relleno a Fill
	mov radiusError, #1 				@Asignacion de 1 a radiusError
	sub radiusError, X 					@Resta de x a radiusError

	DCDraw: 							@Subrutina que dibuja el circulo
		cmp Fill, #1 					@Comparacion de Fill con 1
		beq DCFill 						@Si Fill=1 entonces se salta a DCFill
		DCNoFill: 						@Subrutina para circulo sin relleno
			add r0, X, Xo 				@Asignacion de parametros para cada punto del circulo
			add r1, Y, Yo 				@Asignacion de parametros para cada puto que forma el circulo 	
			bl DrawPixel 				@Llamada a subrutina DrawPixel

			add r0, Y, Xo				@Asignacion coordenada X para circulo 
			add r1, X, Yo				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			sub r0, Xo, X				@Asignacion coordenada X para circulo 
			add r1, Y, Yo				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			sub r0, Xo, Y				@Asignacion coordenada X para circulo 
			add r1, Yo, X				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			sub r0, Xo, X				@Asignacion coordenada X para circulo 
			sub r1, Yo, Y				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			sub r0, Xo, Y				@Asignacion coordenada x para circulo
			sub r1, Yo, X				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			add r0, X, Xo				@Asignacion coordenada X para circulo 
			sub r1, Yo, Y				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			add r0, Xo, Y				@Asignacion coordenada X para circulo 
			sub r1, Yo, X				@Asignacion coordenada Y para circulo
			bl DrawPixel				@Llamada a subrutina DrawPixel

			b DCNext				@Se salta a la subrutina DCNext

		DCFill: 					@Subrutina para circulo con relleno
			mov r0, Xo 				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			add r1, Y, Yo
			add r2, X, Xo
			mov r3, r1
			bl DrawLine 			@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			add r1, X, Yo
			add r2, Y, Xo
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			add r1, Y, Yo
			sub r2, Xo, X
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			add r1, X, Yo
			sub r2, Xo, Y
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			sub r1, Yo, Y
			sub r2, Xo, X
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			sub r1, Yo, X
			sub r2, Xo, Y
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			sub r1, Yo, Y
			add r2, Xo, X
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

			mov r0, Xo				@Asignacion de parametros para cada linea del circulo con coordenada incial y final
			sub r1, Yo, X
			add r2, Y, Xo
			mov r3, r1
			bl DrawLine				@Llamada subrutina DrawLine

		DCNext: 						@Subrutina de continuacion de codigo
			add Y, #1 					@Suma 1 a Y
			cmp radiusError, #0 		@Comparacion de radiusError con 0

			lslle r0, Y, #1 			@Multiplicacion de Y por 2 y se almacena en R0
			addle r0, #1 				@Se suma 1 a R0
			addle radiusError, r0 		@Suma R0 a radiusError

			subgt X, #1 				@Resta de 1 a X
			subgt r0, Y, X 				@Resta de X a Y y se almacena en R0	
			lslgt r0, #1 				@Multiplicacion de R0 por 2
			addgt r0, #1 				@Suma 1 a R0
			addgt radiusError, r0 		@Suma R0 a radiusError

		cmp Y, X 						@Comparacion de X y Y
		ble DCDraw 						@Si Y es menor o igual a X entonces se salta a DCDraw

	.unreq Xo 							@Se retira asignacion de alias
	.unreq Yo							@Se retira asignacion de alias
	.unreq X							@Se retira asignacion de alias
	.unreq Y							@Se retira asignacion de alias
	.unreq Fill							@Se retira asignacion de alias
	.unreq radiusError					@Se retira asignacion de alias

	pop {r7-r12, pc} 					@Se retornan los valores originales almacenados en el stack


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

.globl DrawTriangle
@ --------DrawTriangle---------
@ Dibuja una triangulo con relleno
@-----Parametros de Entrada--
@ 	R0: Posicion inicial en X
@	R1: Posicion inicial en Y
@	R2: Factor de crecimiento
@	R3: Alto del triangulo
@-----Parametros de Salida---
@ Muestra en pantalla el triangulo
@ con los parametros ingresados
@----------------------------

DrawTriangle:	
	push {r4-r12, lr}						@Se almacenan los registros en el stack
	X		.req r12						@Asignacion de alias a registros
	Y		.req r11
	Width 	.req r10
	Height 	.req r9
	Counter	.req r8
	Xf		.req r7

	mov X, r0								@Movimiento de posicion inicial en X 
	mov Y, r1								@Movimiento de posicion inicial en Y
	mov Width, r2							@Movimiento del ancho 
	mov Height, r3							@Movimiento de la altura 

	add Counter, Y, Height					@Incrementa el contador la suma de Y y altura

	mov Xf, X								@Movimiento de X a XF

	DTDraw:
		DTFill:
			mov r0, X						@Movimiento de parametros para subrutina DrawLine
											@Posicion inicial en X
			mov r1, Y						@Posicion inicial en Y
			mov r2, Xf						@Factor que se reduce para formar triangulo
			mov r3, Y						@altura del triangulo
			bl DrawLine						@Se llama a la subrutina DrawLine

			add Y, #1						@Se le suma a 1 Y
			sub X, Width					@ Se le resta a X el ancho
			add Xf, Width					@ Se le suma el ancho al factor Xf

			cmp Y, Counter					@Se hace una comparacion entre Y y el contador
			bne DTDraw						@Si no es igual se repite el ciclo si no sale

	.unreq X								@Se retira asignacion de alias
	.unreq Y								@Se retira asignacion de alias
	.unreq Width							@Se retira asignacion de alias
	.unreq Height							@Se retira asignacion de alias
	.unreq Counter							@Se retira asignacion de alias
	.unreq Xf								@Se retira asignacion de alias

	pop {r4-r12, pc}						@Se retornan los valores originales almacenados en el stack

.globl DrawTriangleI
@ --------DrawTriangleI---------
@ Dibuja una triangulo invertido
@ con relleno
@-----Parametros de Entrada--
@ 	R0: Posicion inicial en X
@	R1: Posicion inicial en Y
@	R2: Factor de crecimiento
@	R3: Alto del triangulo
@-----Parametros de Salida---
@ Muestra en pantalla el triangulo
@ con los parametros ingresados
@----------------------------

DrawTriangleI:	
	push {r4-r12, lr}					@Se almacenan los registros en el stack
	X		.req r12					@Asignacion de alias a registros
	Y		.req r11
	Width 	.req r10
	Height 	.req r9
	Counter	.req r8
	Xf		.req r7

	mov X, r0							@Movimiento de parametros para subrutina DrawLine
										@Movimiento de posicion inicial en X
	mov Y, r1							@Movimiento de posicion inicial en Y
	mov Width, r2						@Movimiento del ancho  del triangulo
	mov Height, r3						@Movimiento de la altura del triangulo

	mov Counter, Y						@Movimiento de la posicion en Y al contador
	add Y, Y, Height					@Se le suma a Y la altura

	mov Xf, X						    @Movimiento de posicion inicial de X a Xf

	DTIDraw:
		DTIFill:
			mov r0, X					@Movimiento de parametros para subrutina DrawLine
										@Posicion inicial en X
			mov r1, Y					@Posicion final en Y
			mov r2, Xf					@Posicion final en X
			mov r3, Y					@Posicion final en Y
			bl DrawLine					@Se llama a la subrutina DrawLine

			sub Y, #1				 @Se resta 1 a Y
			sub X, Width			 @Se le resta a X el ancho
			add Xf, Width		     @Se suma a Xf el ancho

			cmp Y, Counter			@Comparacion de Y y contador
			bne DTIDraw				@Si no son iguales se repite el ciclo hasta que lo sean

	.unreq X								@Se retira asignacion de alias
	.unreq Y								@Se retira asignacion de alias
	.unreq Width							@Se retira asignacion de alias
	.unreq Height							@Se retira asignacion de alias
	.unreq Counter							@Se retira asignacion de alias
	.unreq Xf								@Se retira asignacion de alias

	pop {r4-r12, pc}						@Se retornan los valores originales almacenados en el stack

.globl DrawTriangleRectangle
@ -----DrawTriangleRectangle----
@ Dibuja una triangulo rectangulo
@ con relleno
@-----Parametros de Entrada--
@ 	R0: Posicion inicial en X
@	R1: Posicion inicial en Y
@	R2: Factor de crecimiento
@	R3: Alto del triangulo
@-----Parametros de Salida---
@ Muestra en pantalla el triangulo
@ con los parametros ingresados
@----------------------------

DrawTriangleRectangle:	
	push {r4-r12, lr}							@Se almacenan los registros en el stack
	X		.req r12							@Asignacion de alias a registros
	Y		.req r11
	Width 	.req r10
	Height 	.req r9
	Counter	.req r8
	Xf		.req r7

	mov X, r0								  @Movimiento de datos para la subrutina
	mov Y, r1								  @posicion inicial en X y Y
	mov Width, r2							  @Posicion final en X
	mov Height, r3							 @Posicion final en Y

	add Counter, Y, Height					@Se le suma uno al contador 
	sub Y, Height							@Se le resta uno a la altura

	mov Xf, X								@Movimiento de X a XF

	DTRDraw:
		DTRFill:
			mov r0, X   					@Movimiento de parametros para la subrutina DrawLine
			mov r1, Y
			mov r2, Xf
			mov r3, Y
			bl DrawLine						@Se llama a la subrutina DrawLine

			add Y, #1						@Se le suma uno a Y
			add Xf, Width					@Se le suma el ancho a XF

			cmp Y, Counter					@Comparacion entre Y y contador
			bne DTRDraw						@Si no es igual se repite hasta que lo sea

	.unreq X									@Se retira asignacion de alias
	.unreq Y									@Se retira asignacion de alias
	.unreq Width								@Se retira asignacion de alias
	.unreq Height								@Se retira asignacion de alias
	.unreq Counter								@Se retira asignacion de alias
	.unreq Xf									@Se retira asignacion de alias

	pop {r4-r12, pc}							@Se retornan los valores originales almacenados en el stack
