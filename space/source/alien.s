.globl alien
alien:
	push {r12}
	counter .req r12


	pop {r12}


alienAlive:
	.word 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3

xPosition:
	.word 100, 300, 500, 700, 900, 100, 300, 500, 700, 900, 100, 300, 500, 700, 900 

yPosition:
	.word 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 250, 250, 250, 250, 250