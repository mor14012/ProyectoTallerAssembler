.globl alien
alien:
	push {r11, r12, lr}
	
	counter .req r12
	state .req r11

	mov counter, #0

	CheckAlien:
		ldr r0, =alienAlive
		ldr r0, [r0, counter]
		
		cmp counter, #60
		beq screen1

		cmp r0, #0
		addeq counter, #4
		beq CheckAlien

	LoadAlien:
		ldr state, =State
		ldr state, [r11]
		and state, #0b000001
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

	EraseOldAlien:
		push {r0}
		mov r1, r0
		ldr r0,=mann
		ldr r2,=alienxPosition
		ldr r2, [r2, counter]
		ldr r3,=alienyPosition
		ldr r3, [r3, counter]
		bl DrawBackground
		pop {r0}

	UpdateAlienXPosition:
		ldr r1,=alienxPosition
		ldr r1, [r1, counter]
		ldr r2, =State
		ldr r2, [r2]
		cmp r2, #32
		subge r1, #25 
		addlt r1, #25 			/*Los aliens se mueven 15 pixeles a la izquierda*/

		cmp r2, #31
		bleq UpdateAlienYPosition

		cmp r2, #63
		bleq UpdateAlienYPosition
		

		ldr r2, =alienxPosition
		str r1, [r2, counter]

	DrawAlien: 							
		ldr r1,=alienxPosition
		ldr r1, [r1, counter]
		ldr r2,=alienyPosition
		ldr r2, [r2, counter]
		ldr r3, =0
		bl DrawImageTransparency

	add counter, #4
	cmp counter, #60
	bne CheckAlien

	UpdateAlienState:
		ldr r0,=State
		ldr r1, [r0]
		add r1, #1
		cmp r1, #64
		moveq r1, #0
		str r1, [r0]


	pop {r11, r12, pc}

	UpdateAlienYPosition:
		push {r0, r1}

		ldr r0, =alienyPosition
		ldr r1, [r0, counter]
		add r1, #100
		str r1, [r0, counter]

		pop {r0, r1}

		mov pc, lr

State:
	.word 0

.globl alienAlive
alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

.globl alienxPosition
alienxPosition:
	.word 12, 137, 262, 387, 512, 29, 154, 279, 404, 519, 12, 137, 262, 387, 512

alienyPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250
