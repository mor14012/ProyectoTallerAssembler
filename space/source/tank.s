@-*-*-*-*-*-*-*-*-*-*-*-*-*-*
@-----------MACROS-----------
@-*-*-*-*-*-*-*-*-*-*-*-*-*-*

@ -----------SetWrite----------
@ Permite encender o apagar
@ un pin (led) especifico.
@-----Parametros de Entrada--
@ 	pin: Numero de pin
@ 	value: 1=High 0=Low
@-----Parametros de Salida---
@ Enciende o apaga el pin
@ seleccionado
@----------------------------
.globl SetWrite
.macro SetWrite pin, value
	mov r0, \pin
	mov r1, \value
	bl SetGpio
.endm

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


tankMovement:

	push {lr}
	bl KeyboardUpdate
	bl KeyboardGetChar 			/*Se obtiene el caracter que se presiono en el teclado*/

	cmp r0, #'a' 		
	bleq leftMove
	cmp r0, #'d' 	
	bleq rightMove
	cmp r0, #'s' 	
	bleq collision
	
	@@GPIO Button
	ldr r0, =Button
	ldr r0, [r0]
	bl GetGpio

	cmp r0, #0
	push {r0-r3}
	push {lr}
	blne specialSound
	pop {lr}
	pop {r0-r3}
	cmp r0, #0
	blne specialPower

	pop {pc}

leftMove:
	push {lr}
	ldr r0,=mann
	ldr r1,=tank_white
	ldr r2,=player_Xposition
	ldr r2, [r2]
	ldr r3,=player_Yposition
	ldr r3,[ r3]

	bl DrawBackground

	ldr r1, =player_Xposition
	ldr r2, [r1]
	sub r2, #40
	cmp r2, #0
	movlt r2, #0

	str r2, [r1]

	pop {pc}



rightMove:
	push {lr}
	ldr r0,=mann
	ldr r1,=tank_white
	ldr r2,=player_Xposition
	ldr r2, [r2]
	ldr r3,=player_Yposition
	ldr r3,[ r3]

	bl DrawBackground

	ldr r1, =player_Xposition
	ldr r2, [r1]
	add r2, #40
	cmp r2, #904
	movgt r2, #904

	str r2, [r1]

	pop {pc}
	
collision:
	push {r12, lr}

	push {r0-r3}
	push {lr}
	bl shotSound
	pop {lr}
	pop {r0-r3}

	ccounter .req r12 		
	mov ccounter, #56

	ldr r0, =player_Xposition
	ldr r0, [r0]
	ldr r1, =tank_whiteWidth
	ldrh r1, [r1]
	lsr r1, #1
	add r0, r1 		

	collisionAlien:
		ldr r1, =alienxPosition
		ldr r1, [r1, ccounter]

		ldr r2, =alienAlive
		ldr r2, [r2, ccounter]

		cmp ccounter, #-4
		popeq {r12, pc}

		teq r2, #0
		subeq ccounter, #4
		beq collisionAlien

		teq r2, #1
		ldreq r3, =alien1_aWidth

		teq r2, #2
		ldreq r3, =alien2_aWidth

		teq r2, #3
		ldreq r3, =alien3_aWidth

		ldrh r3, [r3]
		add r3, r1 	
@@ R0: centro del canon
@@ R1: Posicion X del alien
@@ R3: Posicion X del alien mas el Width
		cmp r0, r1
		blt cicleEnd
		cmpge r0, r3
		movle r2, #0

		cicleEnd:
			ldr r1, =alienAlive
			str r2, [r1, ccounter]
			cmp r2, #0
			ldreq r0, =mann
			ldreq r1, =alien3_a
			ldreq r2, =alienxPosition
			ldreq r2, [r2, ccounter]
			ldreq r3, =alienyPosition
			ldreq r3, [r3, ccounter]
			pusheq {lr}
			bleq DrawBackground
			popeq {lr}
			popeq {r12, pc}

			sub ccounter, #4
			cmp ccounter, #-4
			bne collisionAlien
	
	.unreq ccounter

	pop {r12, pc}

specialPower:
	push {r12, lr}	
	ldr r0, =player_special
	ldr r1, [r0]
	teq r1, #0 			@verificacion
	popeq {r12, pc}

	mov r1, #0
	str r1, [r0]

	ccounter .req r12 		
	mov ccounter, #56

	ldr r0, =player_Xposition
	ldr r0, [r0]
	ldr r1, =tank_whiteWidth
	ldrh r1, [r1]
	lsr r1, #1
	add r0, r1 		

	collisionAlienSpecial:
		ldr r1, =alienxPosition
		ldr r1, [r1, ccounter]

		ldr r2, =alienAlive
		ldr r2, [r2, ccounter]

		cmp ccounter, #-4
		popeq {r12, pc}

		teq r2, #0
		subeq ccounter, #4
		beq collisionAlienSpecial

		teq r2, #1
		ldreq r3, =alien1_aWidth

		teq r2, #2
		ldreq r3, =alien2_aWidth

		teq r2, #3
		ldreq r3, =alien3_aWidth

		ldrh r3, [r3]
		add r3, r1 	
@@ R0: centro del canon
@@ R1: Posicion X del alien
@@ R3: Posicion X del alien mas el Width
		cmp r0, r1
		blt cicleEndSpecial
		cmpge r0, r3
		movle r2, #0

		cicleEndSpecial:
			ldr r1, =alienAlive
			str r2, [r1, ccounter]
			cmp r2, #0
			push {r0}
			ldreq r0, =mann
			ldreq r1, =alien3_a
			ldreq r2, =alienxPosition
			ldreq r2, [r2, ccounter]
			ldreq r3, =alienyPosition
			ldreq r3, [r3, ccounter]
			bleq DrawBackground
			pop {r0}

			sub ccounter, #4
			cmp ccounter, #-4
			bne collisionAlienSpecial
	
	ldr r0,=Led
	ldr r0, [r0]
	SetWrite r0, #0

	.unreq ccounter

	pop {r12, pc}



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

