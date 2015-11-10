.globl alien
alien:
	push {r11, r12, lr}
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
		bne spriteB 	
		
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

	UpdateAlienPosition:
		ldr r3,=alienxPosition
		ldr r4, [r3, counter]
		add r4, #5
		str r4, [r3, counter]

	DrawAlien: 							
		ldr r3,=alienxPosition
		ldr r3, [r3, counter]
		ldr r4,=alienyPosition
		ldr r4, [r4, counter]
		push {r4}
		bl DrawImage

	add counter, #4
	cmp counter, #60
	bne CheckAlien

	UpdateAlienState:
		ldr r0,=State
		mov r2, #0
		mov r3, #1
		ldr r1, [r0]
		cmp r1, #0
		streq r3, [r0]
		strne r2, [r0]

	bl clear

	pop {r11, r12, pc}


State:
	.word 0

alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

alienxPosition:
	.word 100, 300, 500, 700, 900, 100, 300, 500, 700, 900, 100, 300, 500, 700, 900 

alienyPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250
