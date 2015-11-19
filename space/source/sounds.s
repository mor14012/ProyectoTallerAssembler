/*Macro utilizado para el uso del buzzer*/
.macro setGpio puerto, estado
    mov r0, \puerto
    mov r1, \estado
    push {lr}
    bl SetGpio
    pop {lr}
.endm

.globl shotSound
shotSound:

	push {lr}
	mov r2, #50 					/*Nuestro contador*/
	push {r2} 						/*Se guarda R2 porque lo utilizan las subrutinas*/
    ciclo3:
		mov r0, #25
	    mov r1, #1
	    push {lr}
	    bl SetGpioFunction
		pop {lr}
		setGpio #25, #0
		
		ldr r0, = 1250 				/*Tiempo para la frecuencia del sonido*/
		push {lr}
		bl Wait
		pop {lr}
		SetGpio #25, #1
		
		ldr r0, = 1250 				/*Tiempo para la frecuencia del sonido*/
		push {lr}
		bl Wait
		pop {lr}
		pop {r2} 					/*Regresamos el contador*/
		sub r2, #1 					/*Le restamos 1 al contador*/
		cmp r2, #0 					/*contador = 0?*/
		push {r2} 					/*Volvemos a guardar R2 en el stack*/
		bne ciclo3 					/*Si aun no es 0 el contador, que siga sonando la bocina.*/
		pop {r2} 					/*Regresamos R2 que fue guardado arriba de bne ciclo3*/
	pop {pc}


.globl specialSound
specialSound:

	push {lr}
	mov r2, #50 					/*Nuestro contador*/
	push {r2} 						/*Se guarda R2 porque lo utilizan las subrutinas*/
    cicloSP:
		mov r0, #25
	    mov r1, #1
	    push {lr}
	    bl SetGpioFunction
		pop {lr}
		setGpio #25, #0
		
		ldr r0, = 650 				/*Tiempo para la frecuencia del sonido*/
		push {lr}
		bl Wait
		pop {lr}
		SetGpio #25, #1
		
		ldr r0, = 650 				/*Tiempo para la frecuencia del sonido*/
		push {lr}
		bl Wait
		pop {lr}
		pop {r2} 					/*Regresamos el contador*/
		sub r2, #1 					/*Le restamos 1 al contador*/
		cmp r2, #0 					/*contador = 0?*/
		push {r2} 					/*Volvemos a guardar R2 en el stack*/
		bne cicloSP 					/*Si aun no es 0 el contador, que siga sonando la bocina.*/
		pop {r2} 					/*Regresamos R2 que fue guardado arriba de bne ciclo3*/
	pop {pc}