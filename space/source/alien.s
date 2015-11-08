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
		
		cmp r0, #1
		ldalien1_a
alien1_b.png
alien2_a.png
alien2_b.png
alien3_a.png
alien3_b.png
sprites.png
tank_blue.png
tank_green.png
tank_red.png
tank_white.png




	pop {r12, r11}

State:
	.word 0

alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

xPosition:
	.word 100, 300, 500, 700, 900, 100, 300, 500, 700, 900, 100, 300, 500, 700, 900 

yPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250