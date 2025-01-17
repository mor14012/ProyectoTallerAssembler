@Pantalla de Inicio
.globl screen1
screen1:
	ldr r0,=menu
	mov r1, #0
	mov r2, #0
	bl DrawImage

	ldr r0,=menuControls
	ldr r1,=329
	ldr r2,=700
	bl DrawImage

	screen1Cicle:
			bl KeyboardUpdate
			bl KeyboardGetChar 			/*Se obtiene el caracter que se presiono en el teclado*/

		teq r0, #'j' 		
		beq screen2
		teq r0, #'i' 	
		beq screen5
		teq r0, #'s'
		beq screen6

		
		ldr r1,=FirstStepCounter
		ldr r2, [r1]
		add r2, #4
		teq r2, #68
		moveq r2, #0
		ldr r1,=FirstStepCounter
		str r2, [r1]

		ldr r0,=FirstStep
		ldr r0, [r0, r2]
		mov r1, #200
		bl buzzer


		b screen1Cicle
	
	b screen1

@Pantalla de seleccion de personaje
.globl screen2
screen2:

	ldr r0, =select
	mov r1, #0
	mov r2, #0
	bl DrawImage

	ldr r0,=selectControls
	ldr r1,=329
	ldr r2,=700
	bl DrawImage

	ldr r0, =tank_red
	ldr r1, =350
	ldr r2, =300
	mov r3, #0
	bl DrawImageTransparency

	ldr r0, =tank_green
	ldr r1, =350
	ldr r2, =425
	mov r3, #0
	bl DrawImageTransparency


	ldr r0, =tank_blue
	ldr r1, =550
	ldr r2, =300
	mov r3, #0
	bl DrawImageTransparency


	ldr r0, =tank_white
	ldr r1, =550
	ldr r2, =425
	mov r3, #0
	bl DrawImageTransparency

	screen2Cicle:
		ldr r1,=FirstStepCounter
		ldr r2, [r1]
		add r2, #4
		teq r2, #68
		moveq r2, #0
		ldr r1,=FirstStepCounter
		str r2, [r1]

		ldr r0,=FirstStep
		ldr r0, [r0, r2]
		mov r1, #230
		bl buzzer

		bl KeyboardUpdate
		bl KeyboardGetChar 			

		mov r1, #0
		
		teq r0, #'r' 		
		moveq r1, #1
		teq r0, #'v'
		moveq r1, #2
		teq r0, #'a'
		moveq r1, #3
		teq r0, #'b'
		moveq r1, #4 	

		teq r1, #0
		beq screen2Cicle

		ldrne r2, =selectedTank
		strne r1, [r2]

		b screen3

@Pantalla de juego
.globl screen3
screen3:
	ldr r0, =mann
	mov r1, #0
	mov r2, #0
	bl DrawImage 		
	screen3Cicle:
		 		
		bl alien

		bl tank

		ldr r1,=DayOneCounter
		ldr r2, [r1]
		add r2, #4
		teq r2, #280
		moveq r2, #0
		ldr r1,=DayOneCounter
		str r2, [r1]

		ldr r0,=DayOne
		ldr r0, [r0, r2]
		mov r1, #100
		bl buzzer
		
		b screen3Cicle

@Pantalla de resultados
.globl screen4
screen4:
	.globl screenGameOver
	screenGameOver: 			@Si perdio se carga este fondo
		ldr r0,=gameover
		mov r1, #0
		mov r2, #0
		bl DrawImage
		b screen4Cicle	
	
	.globl screenWin
	screenWin: 					@Si gana se carga este fondo (y la medalla respectiva)
		ldr r0,=win
		mov r1, #0
		mov r2, #0
		bl DrawImage

		@@NEW POINTS AND BADGES
		ldr r1, =player_points
		ldr r1, [r1]
		ldr r0,=bronze
		cmp r1, #128
		ldrle r0,=silver
		cmp r1, #64
		ldrle r0,=gold

		ldr r1,=392
		ldr r2,=384
		ldr r3, =46884
		bl DrawImageTransparency


		screen4Cicle:
			b screen4Cicle

@Pantalla de instrucciones
.globl screen5
screen5:
	ldr r0,=instructions
	mov r1, #0
	mov r2, #0
	bl DrawImage

	bl KeyboardUpdate
	bl KeyboardGetChar

	cmp r0, #'m'
	beq screen1

	ldr r1,=FirstStepCounter
	ldr r2, [r1]
	add r2, #4
	teq r2, #68
	moveq r2, #0
	ldr r1,=FirstStepCounter
	str r2, [r1]

	ldr r0,=FirstStep
	ldr r0, [r0, r2]
	mov r1, #150
	bl buzzer

	b screen5

.globl screen6
screen6:
	mov r0, #0
	mov r1, #1
	ldr r2,=1024
	ldr r3,=768
	bl DrawRectangle

	screen6Cicle:
		ldr r0,=alien1_a
		ldr r1,=468
		ldr r2,=352
		bl DrawImage

		ldr r0,=500000
		bl Wait
		
		ldr r0,=alien1_b
		ldr r1,=468
		ldr r2,=352
		bl DrawImageTransparency
				
		b screen6Cicle
