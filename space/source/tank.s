.globl tank
tank:

	bl tankMovement

	push {lr}

	ldr r0, =tank_blue
	ldr r1, =player_Xposition
	ldr r1, [r1]
	ldr r2, =player_Yposition
	ldr r2, [r2]
	mov r3, #0

	bl DrawImageTransparency

	pop {pc}


tankMovement:

	push {lr}
	bl KeyboardUpdate
	bl KeyboardGetChar 			/*Se obtiene el caracter que se presiono en el teclado*/
	pop {lr}
	teq r0,#0
	beq tankMovement

	cmp r0, #'a' 	
	push {lr}			
	bleq leftMove
	pop {lr}

	cmp r0, #'d' 
	push {lr}				
	bleq rightMove
	pop {lr}

	mov pc, lr

leftMove:
	ldr r1, =player_Xposition
	ldr r2, [r1]
	sub r2, #10
	cmp r2, #0
	movlt r2, #0

	str r2, [r1]

	mov pc, lr


rightMove:

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