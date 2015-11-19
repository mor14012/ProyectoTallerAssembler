@Universidad del Valle de Guatemala
@Taller de Assembler
@Sección: 11
@Martha Ligia Naranjo Franky
@Proyecto 2
@20/11/2015
@Juan Diego Benitez Caceres.	Carne: 14124
@Diego Alberto Morales Ibanez. 	Carne: 14012

.globl alien
alien:
	push {r11, r12, lr} 								@Almacenamiento de registros en SP
	 
	counter .req r12 									@Asignacion de alias a registros
	state .req r11

	mov counter, #56 									@Inicializacion de contador en 56 (ultimo alien)

	CheckAlien: 									
		ldr r0, =alienAlive 							@Se apunta al vector de alienAlive
		ldr r0, [r0, counter] 							@Carga el valor del alienAlive correspondiente
		cmp counter, #-4 								@Comparacion del valor del contador con -4
		beq UpdateAlienState 							@Si son iguales se salta a UpdateAlienState
		cmp r0, #0 										@Comparacion del valor de alienAlive con 0
		subeq counter, #4 								@Si es 0 (alien muerto) entonces se resta 4 al contador
		beq CheckAlien 									@Si es 0 (alien muerto) entonces se repite el ciclo 

	LoadAlien:
		ldr state, =State 								@Se apunta a la variable de estado
		ldr state, [r11] 								@Carga el valor de la variable de estado
		and state, #0b0000001 							@And logico para determinar si la cifra de la derecha es 1 o 0
		cmp state, #0 									@Comparacion de variable de estado con cero
		bne spriteB 	 								@Si no es igual a cero entonces salta a spriteB
		
		spriteA:
			cmp r0, #1 									@Comparacion del tipo de alien con #1
			ldreq r0,=alien1_a 							@Si son iguales entonces se apunta a la imagen respectiva
			cmp r0, #2 									@Comparacion del tipo de alien con #2
			ldreq r0,=alien2_a 							@Si son iguales entonces se apunta a la imagen respectiva	
			cmp r0, #3 									@Comparacion del tipo de alien con #3	
			ldreq r0,=alien3_a							@Si son iguales entonces se apunta a la imagen respectiva

			b DrawAlien

		spriteB:
			cmp r0, #1 									@Comparacion del tipo de alien con #1
			ldreq r0,=alien1_b 							@Si son iguales entonces se apunta a la imagen respectiva
			cmp r0, #2 									@Comparacion del tipo de alien con #2
			ldreq r0,=alien2_b 							@Si son iguales entonces se apunta a la imagen respectiva
			cmp r0, #3 									@Comparacion del tipo de alien con #3
			ldreq r0,=alien3_b 							@Si son iguales entonces se apunta a la imagen respectiva

	EraseOldAlien:
		push {r0} 										@Almacenamiento de registro 0 en el SP
		mov r1, r0 										@Movimiento del tipo de alien a r1
		ldr r0,=mann 		 							@Se apunta a la matriz del fondo
		ldr r2,=alienxPosition 							@Se apunta a la posicion en X del alien
		ldr r2, [r2, counter] 							@Carga el valor de la posicion en X del alien seleccionado
		ldr r3,=alienyPosition 							@Se apunta a la posicion en Y del alien
		ldr r3, [r3, counter] 							@Carga el valor de la posicion en Y del alien seleccionado
		bl DrawBackground 								@Llamada a subrutina DrawBackground 
		pop {r0} 										@Se retiran el registro almacenado en el SP

	UpdateAlienXPosition:
		ldr r1,=alienxPosition 							@Se apunta a la posicion en X del alien
		ldr r1, [r1, counter] 							@Carga el valor de la posicion en X del alien seleccionado
		ldr r2, =State 									@Se apunta a la variable de estado
		ldr r2, [r2] 									@Carga el valor de la variable de estado
		cmp r2, #32 									@Comparacion de variable de estado con 32
		subge r1, #25  									@Si es mayor o igual, entonces se resta 25
		addlt r1, #25 			 						@Si es menor, entonces se suma 25

		cmp r2, #31 									@Comparacion de la variable de estado con 31
		bleq UpdateAlienYPosition 						@Si son iguales se salta a UpdateAlienYPosition
		cmp r2, #63 									@Comparacion de la variable de estado con 31
		bleq UpdateAlienYPosition 						@Si son iguales se salta a UpdateAlienYPosition

		ldr r2, =alienxPosition 						@Se apunta a la posicion en X del alien
		str r1, [r2, counter] 							@Se almacena el valor de la posicion en X

	DrawAlien: 							
		ldr r1,=alienxPosition 							@Se apunta a la posicion en X del alien
		ldr r1, [r1, counter] 							@Carga el valor de la posicion en X del alien seleccionado
		ldr r2,=alienyPosition 							@Se apunta a la posicion en Y del alien
		ldr r2, [r2, counter] 							@Carga el valor de la posicion en Y del alien seleccionado
		ldr r3, =0 										@Carga el valor cero (fondo a ignorar de la imagen)
		bl DrawImageTransparency 						@Llamada a subrutina DrawImageTransparency
	
	sub counter, #4 									@Se resta 4 al contador para apuntar al siguiente alien
	cmp counter, #-4 									@Comparacion del contador con -4
	bne CheckAlien 										@Si no son iguales entonces salta a CheckAlien

	UpdateAlienState:
		ldr r0,=State 									@Se apunta a la variable de estado
		ldr r1, [r0] 									@Carga el valor de la variable de estado
		add r1, #1 										@Suma 1 a la variable de estado
		cmp r1, #64 									@Comparacion de variable de estado con 64
		moveq r1, #0 									@Si son iguales entonces asigna 0
		str r1, [r0] 									@Almacena el valor de la variable de estado

	CheckGameOver:
		mov r0, #0 										@Inicializacion de contador en 0
		ldr r1,=alienyPosition 							@Se apunta a la posicion en Y del alien
		ldr r2,=650 									@Se carga el valor 650 en r2 para comparacion
		CheckGameOverCicle:
			ldr r3, [r1, r0] 							@Carga la posicion en Y del alien seleccionado
			cmp r3, r2 									@Comparacion de posicion en Y con 650
			bge screenGameOver 							@Si es mayor o igual entonces el jugador perdio
			add r0, #4 									@Se suma 4 al contador
			cmp r0, #60 								@Comparacion del contador con 60
			bne CheckGameOverCicle 						@Si no es igual a 60 entonces se repite el ciclo

	CheckWin:
		mov r0, #0 										@Inicializacion de contador en 0
		ldr r1, =alienAlive 							@Se apunta a la variable alienAlive
		CheckWinCicle:
			ldr r2, [r1, r0] 							@Carga la variable alienAlive del alien seleccionado
			cmp r2, #0 									@Comparacion de alienAlive con 0
			bne alienEnd 								@Si no son iguales entonces se salta a alienEnd (el alien esta vivo)
			add r0, #4 									@Se suma 4 al contador
			cmp r0, #60 								@Comparacion del contador con 60
			beq screenWin 								@Si son iguales entonces se salta a screenWin (todos los aliens estan muertos)
			b CheckWinCicle 							@Sino entonces se repite el ciclo

	alienEnd:
	pop {r11, r12, pc} 									@Se retiran los registros almacenados en el SP

	UpdateAlienYPosition:
		push {r0, r1} 									@Almacenamiento de registros en SP
		ldr r0, =alienyPosition 						@Se apunta a la posicion en Y del alien
		ldr r1, [r0, counter] 							@Carga la posicion en Y del alien seleccionado
		add r1, #100 									@Suma 100 a la posicion en Y
		str r1, [r0, counter] 							@Se almacena la posicion en Y

		ldr r0,=player_points 							@Se apunta a los puntos del jugador
		ldr r1, [r0] 									@Carga el valor de los puntos del jugador
		add r1, #1 										@Suma 1 a los puntos del jugador
		str r1, [r0]  									@Se almacenan los puntos del jugador
		pop {r0, r1} 									@Se retiran los registros almacenados en el SP
		mov pc, lr 										@Se asigna el LR al PC

State:
	.word 0
	
.globl alienAlive
alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

.globl alienxPosition
alienxPosition:
	.word 12, 137, 262, 387, 512, 29, 154, 279, 404, 519, 12, 137, 262, 387, 512

.globl alienyPosition
alienyPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250
