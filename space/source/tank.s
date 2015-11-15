.globl tank
tank:
	push {lr}

	ldr r0, =tank_blue
	ldr r1, =player_Xposition
	ldr r1, [r1]
	ldr r2, =player_Yposition
	ldr r2, [r2]
	mov r3, #0

	bl DrawImageTransparency

	pop {pc}


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