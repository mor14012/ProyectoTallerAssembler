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

			b DrawAlien

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

	DrawAlien: 							@Falta aumentar la posicion en X y la posicion en Y
		ldr r3,=alienxPosition
		ldr r3, [r3, counter]
		ldr r4,=alienyPosition
		ldr r4, [r4, counter]
		push {r4}
		bl DrawImage

	UpdateAlien:
		ldr r0,=State
		mov r2, #0
		mov r3, #1
		ldr r1, [r0]
		cmp r1, #0
		streq r3, [r0]
		strne r2, [r0]


@ R0: Matriz de la imagen
@ R1: Ancho de la imagen
@ R2: Alto de la imagen
@ R3: Posicion en X 
@ Stack: Posicion en Y 


	pop {r11, r12}

State:
	.word 0

alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

alienxPosition:
	.word 100, 300, 500, 700, 900, 100, 300, 500, 700, 900, 100, 300, 500, 700, 900 

alienyPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250
