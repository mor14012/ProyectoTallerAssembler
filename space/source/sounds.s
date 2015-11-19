@Universidad del Valle de Guatemala
@Taller de Assembler
@Sección: 11
@Martha Ligia Naranjo Franky
@Proyecto 2
@20/11/2015
@Juan Diego Benitez Caceres.	Carne: 14124
@Diego Alberto Morales Ibanez. 	Carne: 14012

@-----------MACROS-----------
@ -----------setGpio----------
@ Permite encender o apagar
@ un pin (led) especifico.
@-----Parametros de Entrada--
@ 	pin: Numero de pin
@ 	value: 1=High 0=Low
@-----Parametros de Salida---
@ Enciende o apaga el pin
@ seleccionado
@----------------------------
.macro setGpio puerto, estado
    mov r0, \puerto
    mov r1, \estado
    push {lr}
    bl SetGpio
    pop {lr}
.endm

.globl shotSound
shotSound:
	push {lr} 						@Almacenamiento de registro en SP
	mov r2, #50 					@Inicializacion de contador
	push {r2} 						@Almacenamiento de contador en SP
    ciclo3:
		mov r0, #25 				@Inicializacion del buzzer
	    mov r1, #1
	    push {lr}
	    bl SetGpioFunction 			@Llamada a subrutina SetGpioFunction
		pop {lr}
		setGpio #25, #0 			@Se envia un 0 al buzzer
		
		ldr r0, = 1250 				@Tiempo para frecuencia del sonido
		push {lr}
		bl Wait 					@Llamada a Wait
		pop {lr}
		SetGpio #25, #1 			@Se envia un 1 al buzzer
		
		ldr r0, = 1250 				@Tiempo para frecuencia del sonido
		push {lr} 	
		bl Wait 					@Llamada a Wait
		pop {lr}
		pop {r2} 					@Se retira el contador del SP
		sub r2, #1 					@Se resta 1 al contador
		cmp r2, #0 					@Comparacion del contador con 0
		push {r2} 					@Almacenamiento del contador en el SP
		bne ciclo3 					@Si no es igual a 0 entonces se repite el ciclo
		pop {r2} 					@Se retiran los registros del SP
		pop {pc}


.globl specialSound
specialSound:
	push {lr} 						@Almacenamiento de registro en SP
	mov r2, #50 					@Inicializacion de contador
	push {r2} 						@Almacenamiento de contador en SP
    cicloSP:
		mov r0, #25 				@Inicializacion del buzzer
	    mov r1, #1
	    push {lr}
	    bl SetGpioFunction 			@Llamada a subrutina SetGpioFunction
		pop {lr}
		setGpio #25, #0 			@Se envia un 0 al buzzer
		
		ldr r0, = 650 				@Tiempo para frecuencia del sonido
		push {lr}
		bl Wait 					@Llamada a Wait
		pop {lr}
		SetGpio #25, #1 			@Se envia un 1 al buzzer
		
		ldr r0, = 650 				@Tiempo para frecuencia del sonido
		push {lr}
		bl Wait 					@Llamada a Wait
		pop {lr}
		pop {r2} 					@Se retira el contador del SP
		sub r2, #1 					@Se resta 1 al contador
		cmp r2, #0 					@Comparacion del contador con 0
		push {r2} 					@Almacenamiento del contador en el SP
		bne cicloSP 				@Si no es igual a 0 entonces se repite el ciclo
		pop {r2} 					@Se retiran los registros del SP
		pop {pc}

@Parametros de entrada
@R0: frecuencia
@R1: delay 
.globl buzzer
buzzer: 	
	push {r12, lr} 					@Almacenamiento de registro en SP
	mov r12, r0 					@Movimiento de frecuencia a r12
	mov r2, r1 					 	@Inicializacion de contador
	push {r2} 						@Almacenamiento de contador en SP
	mov r0, #25 					@Inicializacion del buzzer
    mov r1, #1
    push {lr}
    bl SetGpioFunction 				@Llamada a subrutina SetGpioFunction
	pop {lr}	
    buzzerCicle:
		setGpio #25, #0 			@Se envia un 0 al buzzer
		
		mov r0, r12 				@Tiempo para frecuencia del sonido
		push {lr}
		bl Wait 					@Llamada a Wait
		pop {lr}
		setGpio #25, #1 			@Se envia un 1 al buzzer
		
		mov r0, r12				    @Tiempo para frecuencia del sonido
		push {lr}
		bl Wait 					@Llamada a Wait
		pop {lr}
		pop {r2} 					@Se retira el contador del SP
		sub r2, #1 					@Se resta 1 al contador
		cmp r2, #0 					@Comparacion del contador con 0
		push {r2} 					@Almacenamiento del contador en el SP
		bne buzzerCicle 			@Si no es igual a 0 entonces se repite el ciclo
		pop {r2} 					@Se retiran los registros del SP
		pop {r12, pc}