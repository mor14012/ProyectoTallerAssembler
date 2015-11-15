.globl tank
tank:
	push {lr}

	bl tankMovement

	ldr r0, =selectedTank
	ldr r0, [r0]
	cmp r0, #1
	ldreq r0, =tank_red

	cmp r0, #2
	ldreq r0, =tank_green

	cmp r0, #3
	ldreq r0, =tank_blue

	cmp r0, #4
	ldreq r0, =tank_white

	ldr r1, =player_Xposition
	ldr r1, [r1]
	ldr r2, =player_Yposition
	ldr r2, [r2]
	mov r3, #0

	bl DrawImageTransparency

	pop {pc}

.globl tankMovement
tankMovement:

	push {lr}
	bl KeyboardUpdate
	bl KeyboardGetChar 			/*Se obtiene el caracter que se presiono en el teclado*/

	cmp r0, #'a' 		
	bleq leftMove
	cmp r0, #'d' 	
	bleq rightMove
	pop {pc}

leftMove:
	ldr r0,=mann
	ldr r1,=tank_white
	ldr r2,=player_Xposition
	ldr r2, [r2]
	ldr r3,=player_Yposition
	ldr r3,[ r3]

	bl DrawBackground

	ldr r1, =player_Xposition
	ldr r2, [r1]
	sub r2, #10
	cmp r2, #0
	movlt r2, #0

	str r2, [r1]

	mov pc, lr


rightMove:
	ldr r0,=mann
	ldr r1,=tank_white
	ldr r2,=player_Xposition
	ldr r2, [r2]
	ldr r3,=player_Yposition
	ldr r3,[ r3]

	bl DrawBackground

	ldr r1, =player_Xposition
	ldr r2, [r1]
	add r2, #10
	cmp r2, #1004
	movgt r2, #1004

	str r2, [r1]
	
	mov pc, lr

.globl player_Xposition
player_Xposition: .word 452

.globl player_Yposition
player_Yposition: .word 700


.globl player_lives
player_lives: .word 3

.globl player_points
player_points: .word 0

.globl player_special
player_special: .word 1

.globl selectedTank
selectedTank: .word 0

