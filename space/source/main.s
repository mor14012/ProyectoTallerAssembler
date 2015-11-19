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

.section .init
.globl _start
_start:

b main


.section .text

main:

	mov sp,#0x8000

	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

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

	bl SetGraphicsAddress

	ldr r4, =Button
	ldr r4, [r4]
	ldr r5, =Led
	ldr r5, [r5]

	SetIO r4, #0
	SetIO r5, #1

	SetWrite r5, #1

	bl UsbInitialise

	b screen1
	
loop$:

	b loop$

.section .data
.globl Button, Led
Button:
	.word 8
Led:
	.word 11
