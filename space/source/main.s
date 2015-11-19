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

@ -----------SetIO----------
@ Permite configurar un pin
@ con escritura o lectura
@-----Parametros de Entrada--
@ 	pin: Numero de pin
@ 	value: 0=Lectura, 1=Escritura
@-----Parametros de Salida---
@ Configura el pin correspondiente
@ como lectura o escritura
@----------------------------
.macro SetIO pin, value
	mov r0, \pin
	mov r1, \value
	bl SetGpioFunction
.endm

/******************************************************************************
*	main.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the input02 operating system, that 
*	demonstrates a command line interface.
*
*	main.s contains the main operating system, and IVT code.
******************************************************************************/

/*
* .globl is a directive to our assembler, that tells it to export this symbol
* to the elf file. Convention dictates that the symbol _start is used for the 
* entry point, so this all has the net effect of setting the entry point here.
* Ultimately, this is useless as the elf itself is not used in the final 
* result, and so the entry point really doesnt matter, but it aids clarity,
* allows simulators to run the elf, and also stops us getting a linker warning
* about having no entry point. 
*/
.section .init
.globl _start
_start:

/*
* Branch to the actual main code.
*/
b main

/*
* This command tells the assembler to put this code with the rest.
*/
.section .text

/*
* main is what we shall call our main operating system method. It never 
* returns, and takes no parameters.
* C++ Signature: void main(void)
*/
main:

/*
* Set the stack point to 0x8000.
*/
	mov sp,#0x8000

/* 
* Setup the screen.
*/

	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

/* 
* Check for a failed frame buffer.
*/
	teq r0,#0
	bne noError$
		
	mov r0,#16
	mov r1,#1
	bl SetGpioFunction

	mov r0,#16
	mov r1,#0
	bl SetGpio

	error$:
		b error$

	noError$:


/*
* Let our drawing method know where we are drawing to.
*/
	bl SetGraphicsAddress

	ldr r4, =Button
	ldr r4, [r4]
	ldr r5, =Led
	ldr r5, [r5]

	SetIO r4, #0
	SetIO r5, #1

	SetWrite r5, #1

	bl UsbInitialise
	
reset$:
	mov sp,#0x8000
	
	/*1.Limpiar pantalla*/
	bl TerminalClear
	
	/*2.Mensaje bienvenida*/
	ldr r0,=welcome
	mov r1,#welcomeEnd-welcome
	bl Print

loop$:	
	
	/*2.Prompt*/
	ldr r0,=prompt
	mov r1,#promptEnd-prompt
	bl Print
	
	/*3.Leer comando ingresado*/
	ldr r0,=command
	mov r1,#commandEnd-command
	bl ReadLine

	teq r0,#0
	beq loopContinue$

	mov r4,r0 /*comando ingresado*/
	
	ldr r5,=command
	ldr r6,=commandTable
	
	ldr r7,[r6,#0] /*cadena*/
	ldr r9,[r6,#4] /*etiqueta*/
	commandLoop$:
		ldr r8,[r6,#8]
		sub r1,r8,r7 
		/*compara si es comando valido (letra inicial)*/
		cmp r1,r4
		bgt commandLoopContinue$

		mov r0,#0	
		commandName$:
		/*compara letra x letra */
			ldrb r2,[r5,r0]
			ldrb r3,[r7,r0]
			teq r2,r3			
			bne commandLoopContinue$
			add r0,#1
			teq r0,r1
			bne commandName$

		ldrb r2,[r5,r0]
		teq r2,#0
		teqne r2,#' '
		bne commandLoopContinue$

		mov r0,r5
		mov r1,r4
		mov lr,pc
		mov pc,r9 /*salta a etiqueta de commandTable*/
		b loopContinue$

	commandLoopContinue$:
		add r6,#8
		mov r7,r8
		ldr r9,[r6,#4]
		teq r9,#0
		bne commandLoop$	
	
	/*Sino es comando válido mostrar mensaje y regresar al paso 2*/
	ldr r0,=commandUnknown
	mov r1,#commandUnknownEnd-commandUnknown
	ldr r2,=formatBuffer
	ldr r3,=command
	bl FormatString

	mov r1,r0
	ldr r0,=formatBuffer
	bl Print

loopContinue$:
	/*actualiza pantalla*/ 
	bl TerminalDisplay
	b loop$

echo:
	cmp r1,#5
	movle pc,lr

	add r0,#5
	sub r1,#5 
	b Print

ok:
	teq r1,#5
	beq okOn$
	teq r1,#6
	beq okOff$
	mov pc,lr

	okOn$:
		ldrb r2,[r0,#3]
		teq r2,#'o'
		ldreqb r2,[r0,#4]
		teqeq r2,#'n'
		movne pc,lr
		mov r1,#0
		b okAct$

	okOff$:
		ldrb r2,[r0,#3]
		teq r2,#'o'
		ldreqb r2,[r0,#4]
		teqeq r2,#'f'
		ldreqb r2,[r0,#5]
		teqeq r2,#'f'
		movne pc,lr
		mov r1,#1

	okAct$:
		mov r0,#16
		b SetGpio

juego:
	b screen1
	
.section .data
.align 2

.globl Button, Led
Button:
	.word 8
Led:
	.word 11


welcome:
	.ascii "Bienvenido al Endurance. Los alienigenas estan invadiendo Mann. Es tu mision detenerlos, si decides aceptarla. \n si \n no"
welcomeEnd:
.align 2
prompt:
	.ascii "\n{ "
promptEnd:
.align 2
command:
	.rept 128
		.byte 0
	.endr
commandEnd:
.byte 0
.align 2
commandUnknown:
	.ascii "El comando `%s' no es valido.\n"
commandUnknownEnd:
.align 2
formatBuffer:
	.rept 256
	.byte 0
	.endr
formatEnd:

.align 2
commandStringEcho: .ascii "echo"
commandStringReset: .ascii "reset"
commandStringOk: .ascii "ok"
commandStringCls: .ascii "cls"
commandStringSi: .ascii "si"
commandStringEnd:

.align 2
commandTable:
.int commandStringEcho, echo
.int commandStringReset, reset$
.int commandStringOk, ok
.int commandStringCls, TerminalClear
.int commandStringSi, juego
.int commandStringEnd, 0
