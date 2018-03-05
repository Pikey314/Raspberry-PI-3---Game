/*
	r11 - score
	r12 - LEDs flashing frequency
	r7 - flag for marking that point was added
*/

	.text
	mrs r0,cpsr
	mov     r0, #0b11010011   @ Mode SVC, FIQ&IRQ disable
	msr spsr_cxsf,r0
	add r0,pc,#4
	msr ELR_hyp,r0
	eret


.include "configuration.inc"
.include "inter.inc"



/*StartMusic*/
	ldr r0, =0x3F20001C
	ldr r2, =0x3F200028
	ldr r1, = 0x010
	ldr r3,=0x000
	ldr r8,=0x9530F10
loop1A:
	ldr r9, =120
	b loop1
loop1:	
	str r8,[r0]
	BL wait1
	str r1,[r2]
	BL wait1
	subs r9,#1
	bne loop1
	b loop2A
	
loop2A:
	ldr r9, =60
	str r8,[r2]
	b loop2
loop2:	
	str r1,[r0]
	BL wait2
	str r1,[r2]
	BL wait2
	subs r9,#1
	bne loop2
	b loop3A
	
loop3A:
	ldr r9, =60
	b loop3	
loop3:	
	str r8,[r0]
	BL wait3
	str r1,[r2]
	BL wait3
	subs r9,#1
	bne loop3
	b loop4A
	
loop4A:
	ldr r9, =120
	str r8,[r2]
	b loop4	
loop4:	
	str r1,[r0]
	BL wait4
	str r1,[r2]
	BL wait4
	subs r9,#1
	bne loop4
	b loop5A
	
loop5A:
	ldr r9, =60
	b loop5
loop5:	
	str r8,[r0]
	BL wait3
	str r1,[r2]
	BL wait3
	subs r9,#1
	bne loop5
	b loop6A
	
loop6A:
	ldr r9, =60
	str r8,[r2]
	b loop6
loop6:	
	str r1,[r0]
	BL wait2
	str r1,[r2]
	BL wait2
	subs r9,#1
	bne loop6
	b loop7A
	
	
loop7A:
	ldr r9, =160
	b loop7
loop7:	
	str r8,[r0]
	BL wait1
	str r1,[r2]
	BL wait1
	subs r9,#1
	bne loop7
	str r8,[r2]
	b mainPart



/*KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKk*/







mainPart:

	ldr r11, =0
	ldr r12, =550000
	ldr r7, =0

main1:
	/* adjust cadence */
	ldr r9, =50000
	sub r12, r12, r9
	cmp r12, #0
	beq gameOver2
	
	/* clear all the LEDs */
	ldr r0, =GPBASE	
	ldr r1, =0x08420E00
	str r1, [r0, #GPCLR0]
	ldr r7, =0
	
	/* 1st LED (0 points) */
	ldr	r1, =0x200
	str r1, [r0, #GPSET0]
	BL waitWithLedOn0points
	str r1, [r0, #GPCLR0]
	BL waitWithLedOFF
	cmp r7, #1
	beq main1

	/* 2nd LED (0 points) */
	ldr	r1, =0x400
	str r1, [r0, #GPSET0]
	BL waitWithLedOn0points
	str r1, [r0, #GPCLR0]
	BL waitWithLedOFF
	cmp r7, #1
	beq main1

	/* 3rd LED (0 points) */
	ldr	r1, =0x800
	str r1, [r0, #GPSET0]
	BL waitWithLedOn0points
	str r1, [r0, #GPCLR0]
	BL waitWithLedOFF
	cmp r7, #1
	beq main1

	/* 4th LED (1 point) */
	ldr	r1, =0x20000
	str r1, [r0, #GPSET0]
	BL waitWithLedOn1point
	str r1, [r0, #GPCLR0]
	BL waitWithLedOFF
	cmp r7, #1
	beq main1

	/* 5th LED (2 points) */
	ldr	r1, =0x400000
	str r1, [r0, #GPSET0]
	BL waitWithLedOn2points
	str r1, [r0, #GPCLR0]
	BL waitWithLedOFF
	cmp r7, #1
	beq main1

	/* 6th LED (1 point) */
	ldr	r1, =0x8000000
	str r1, [r0, #GPSET0]
	BL waitWithLedOn1point
	str r1, [r0, #GPCLR0]
	BL waitWithLedOFF
	cmp r7, #1
	beq main1

gameOver2:
	/*ldr r1, =0x08420E00
	str r1, [r0, #GPCLR0]
	ldr r1, =0xA00
	str r1, [r0, #GPSET0]*/
	b endMusic

waitWithLedOn0points:
	ldr r2, =0x3F003004
	ldr r3, [r2]
	mov r4, r12
	add r4, r3, r4
ret1:
	/* check for button being pushed */
	ldr r5, =0x3F200034
	ldr r8, [r5]
	tst r8, #0b00100
	beq add0points

	/* perform regular timer work */
	ldr r3, [r2]	
	cmp r3, r4
	blt ret1
	bx lr

waitWithLedOn1point:
	ldr r2, =0x3F003004
	ldr r3, [r2]
	mov r4, r12
	add r4, r3, r4
ret2:
	/* check for button being pushed */
	ldr r5, =0x3F200034
	ldr r8, [r5]
	tst r8, #0b00100
	beq add1point

	ldr r8, [r5]
	tst r8, #0b00100
	beq main1
	
	/* perform regular timer work */
	ldr r3, [r2]	
	cmp r3, r4
	blt ret2
	
	bx lr

waitWithLedOn2points:
	ldr r2, =0x3F003004
	ldr r3, [r2]
	mov r4, r12
	add r4, r3, r4
ret3:
	/* check for button being pushed */
	ldr r5, =0x3F200034
	ldr r8, [r5]
	tst r8, #0b00100
	beq add2points
	
	ldr r8, [r5]
	tst r8, #0b00100
	beq main1

	/* perform regular timer work */
	ldr r3, [r2]	
	cmp r3, r4
	blt ret3
	
	bx lr

waitWithLedOFF:
	ldr r2, =0x3F003004
	ldr r3, [r2]
	mov r4, r12
	add r4, r3, r4
ret4:
	ldr r3, [r2]
	cmp r3, r4
	blt ret4
	bx lr

wait200ms:
	ldr r2, =0x3F003004
	ldr r3, [r2]
	ldr r4, =200000
	add r4, r3, r4
ret5:
	ldr r3, [r2]	
	cmp r3, r4
	blt ret5
	bx lr

add0points:
	B gameOver2

add1point:
	add r11, r11, #1
	ldr r7, =1
	bx lr

add2points:
	add r11, r11, #2
	ldr r7, =1
	bx lr
	
	
	
	
	
	
/*KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK*/

endMusic:
	ldr r0, =0x3F20001C
	ldr r2, =0x3F200028
	ldr r1, = 0x010
	ldr r3,=0x000
	ldr r8,=0x9530F10
loop1AB:
	ldr r9, =120
	b loop1B
loop1B:	
	str r8,[r0]
	BL wait1
	str r1,[r2]
	BL wait1
	subs r9,#1
	bne loop1B
	b loop2AB
	
loop2AB:
	ldr r9, =60
	str r8,[r2]
	b loop2B
loop2B:	
	str r1,[r0]
	BL wait4
	str r1,[r2]
	BL wait4
	subs r9,#1
	bne loop2B
	b loop3AB
	
loop3AB:
	ldr r9, =60
	b loop3B	
loop3B:	
	str r8,[r0]
	BL wait2
	str r1,[r2]
	BL wait2
	subs r9,#1
	bne loop3B
	b loop4AB
	
loop4AB:
	ldr r9, =120
	str r8,[r2]
	b loop4B
loop4B:	
	str r1,[r0]
	BL wait1
	str r1,[r2]
	BL wait1
	subs r9,#1
	bne loop4B
	b loop5AB
	
loop5AB:
	ldr r9, =60
	b loop5B
loop5B:	
	str r8,[r0]
	BL wait3
	str r1,[r2]
	BL wait3
	subs r9,#1
	bne loop5B
	b loop6AB
	
loop6AB:
	ldr r9, =60
	str r8,[r2]
	b loop6B
loop6B:	
	str r1,[r0]
	BL wait1
	str r1,[r2]
	BL wait1
	subs r9,#1
	bne loop6B
	b loop7AB
	
	
loop7AB:
	ldr r9, =160
	b loop7B
loop7B:	
	str r8,[r0]
	BL wait2
	str r1,[r2]
	BL wait2
	subs r9,#1
	bne loop7B
	str r8,[r2]
	b score



score:
	ldr r0, =0x3F20001C
	/*scoreReserved*/
	ldr r12,=0
	
	
	ldr r2, =0x3F200028
	ldr r4, =0x9530F00
	str r4,[r2]
	b oneBin
	
	
oneBin:	
	ands r12, r11, #0b000001
	cmp r12, #1
	beq ledGreen2
		
twoBin:		
	and r12, r11, #0b000010
	cmp r12, #2
	beq ledGreen1
		
threeBin:	
	and r12, r11, #0b000100
	cmp r12, #4
	beq ledYellow2
		
fourBin:
	and r12, r11, #0b001000
	cmp r12, #8
	beq ledYellow1
		
fiveBin:
	and r12, r11, #0b010000
	cmp r12, #16
	beq ledRed2
		
sixBin:
	and r12, r11, #0b100000
	cmp r12, #32
	beq ledRed1
end: b end
		
		
ledGreen2:
	ldr r1, =0x8000000
	str r1,[r0]
	b twoBin
	

ledGreen1:
	ldr r1, =0x400000
	str r1,[r0]
	b threeBin
	
ledYellow2:
	ldr r1, =0x20000
	str r1,[r0]
	b fourBin
	
ledYellow1:
	ldr r1, =0x800
	str r1,[r0]
	b fiveBin
	
ledRed2:
	ldr r1, =0x400
	str r1,[r0]
	b sixBin
	
ledRed1:
	ldr r1, =0x200
	str r1,[r0]
	bx lr




wait1:
	ldr r6,=0x3F003004
	ldr r5,[r6]
	ldr r4,=786
	add r4,r5,r4
	ret11:
		ldr r5,[r6]
		cmp r5,r4
		blt ret11
		bx lr
		
		
		
		
wait2:
	ldr r6,=0x3F003004
	ldr r5,[r6]
	ldr r4,=1524
	add r4,r5,r4
	ret22:
		ldr r5,[r6]
		cmp r5,r4
		blt ret22
		bx lr
		
wait3:
	ldr r6,=0x3F003004
	ldr r5,[r6]
	ldr r4,=1900
	add r4,r5,r4
	ret33:
		ldr r5,[r6]
		cmp r5,r4
		blt ret33
		bx lr
		
wait4:
	ldr r6,=0x3F003004
	ldr r5,[r6]
	ldr r4,=2300
	add r4,r5,r4
	ret44:
		ldr r5,[r6]
		cmp r5,r4
		blt ret44
		bx lr