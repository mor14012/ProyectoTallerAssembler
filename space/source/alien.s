.globl alien
alien:
	push {r11, r12, lr}
	bl clear
	
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
			cmp r0, #2
			ldreq r0,=alien2_a
			cmp r0, #3
			ldreq r0,=alien3_a

			b DrawAlien

		spriteB:
			cmp r0, #1
			ldreq r0,=alien1_b
			cmp r0, #2
			ldreq r0,=alien2_b
			cmp r0, #3
			ldreq r0,=alien3_b

	UpdateAlienPosition:
		ldr r1,=alienxPosition
		ldr r2, [r1, counter]
		add r2, #5
		str r2, [r1, counter]

	DrawAlien: 							
		ldr r1,=alienxPosition
		ldr r1, [r1, counter]
		ldr r2,=alienyPosition
		ldr r2, [r2, counter]
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

	pop {r11, r12, pc}


State:
	.word 0

alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

alienxPosition:
	.word 100, 300, 500, 700, 900, 100, 300, 500, 700, 900, 100, 300, 500, 700, 900 

alienyPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250
