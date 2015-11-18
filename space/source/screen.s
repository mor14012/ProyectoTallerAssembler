@Pantalla de Inicio
.globl screen1
screen1:
	ldr r0,=menu
	mov r1, #0
	mov r2, #0
	bl DrawImage

	screen1ciclo:
			bl KeyboardUpdate
			bl KeyboardGetChar 			/*Se obtiene el caracter que se presiono en el teclado*/

		cmp r0, #'j' 		
		beq screen2
		cmp r0, #'i' 	
		beq screen5
		cmp r0, #'s'
		beq screenLoop

		mov r0, #' '
		b screen1ciclo
	
	b screen1

@Pantalla de seleccion de personaje
.globl screen2
screen2:

	ldr r0, =select
	mov r1, #0
	mov r2, #0
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
		bl KeyboardUpdate
		bl KeyboardGetChar 			/*Se obtiene el caracter que se presiono en el teclado*/
		
		mov r1, #0

		cmp r0, #'r' 		
		moveq r1, #1
		cmp r0, #'v'
		moveq r1, #2
		cmp r0, #'a'
		moveq r1, #3
		cmp r0, #'b'
		moveq r1, #4 	

		cmp r1, #0
		ldrne r2, =selectedTank
		strne r1, [r2]

		b screen3

@Pantalla de juego
.globl screen3
screen3:
	ldr r0, =mann
	mov r1, #0
	mov r2, #1
	bl DrawImage 		
	screen3Cicle:
		bl tank 		
		bl alien
		b screen3Cicle

@Salida
.globl screenLoop
screenLoop:
	//Pintar cuadrado negro
	b screenLoop

@Pantalla de resultados
.globl screen4
screen4:
	
	b screen4

@Pantalla de instrucciones
.globl screen5
screen5:
	
	b screen5

