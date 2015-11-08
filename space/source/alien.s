.globl alien
alien:
	push {r11, r12}
	counter .req r12
	state .req r11

	mov counter, #0

	CheckAlien:
		ldr r0, =alienAlive
		ldr r0, [r0, counter]
		cmp r0, #0
		addeq counter, #4
		beq CheckAlien
	LoadAlien:
		ldr state, =State
		ldr state, [r11]
		cmp state, #0
		beq spriteA 	/*Si el estado esta en 0, se hace el spriteA*/
		bne spriteB 	/*Si el estado esta en 1, se hace el spriteB*/
		

		spriteA:
			cmp r0, #1
			ldreq r0,=alien1_a
			ldreq r1,=alien1_aWidth
			ldreq r2,=alien1_aHeight
			cmp r0, #2
			ldreq r0,=alien2_a
			ldreq r1,=alien2_aWidth
			ldreq r2,=alien2_aHeight
			cmp r0, #3
			ldreq r0,=alien3_a
			ldreq r1,=alien3_aWidth
			ldreq r2,=alien3_aHeight

			ldr r3,=alienxPosition
			ldr r3, [r3, counter]

			ldr r4,=alienyPosition
			


			ldr r0, =alienxPosition
			ldr r0, [r0, counter]
			//mov r1, poxy



		spriteB:
			cmp r0, #1
			ldreq r0,=alien1_b
			ldreq r1,=alien1_bWidth
			ldreq r2,=alien1_bHeight
			cmp r0, #2
			ldreq r0,=alien2_b
			ldreq r1,=alien2_bWidth
			ldreq r2,=alien2_bHeight
			cmp r0, #3
			ldreq r0,=alien3_b
			ldreq r1,=alien3_bWidth
			ldreq r2,=alien3_bHeight



		ldr r2, =alien1_aHeight
		ldrh r2, [r2]
		ciclo:

		//dibujar pixel
		sub r2, #1

		cmp r0, #1
		@ldalien1_a



@ R0: Matriz de la imagen
@ R1: Ancho de la imagen
@ R2: Alto de la imagen
@ R3: Posicion en X 
@ Stack: Posicion en Y 


/*alien1_b.png
alien2_a.png
alien2_b.png
alien3_a.png
alien3_b.png
sprites.png
tank_blue.png
tank_green.png
tank_red.png
tank_white.png
*/



	pop {r11, r12}

State:
	.word 0

alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

alienxPosition:
	.word 100, 300, 500, 700, 900, 100, 300, 500, 700, 900, 100, 300, 500, 700, 900 

alienyPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250
