	.file	"main.c"
.text
	.balign 2
	.global	PreApplicationMode
	.type	PreApplicationMode, @function
PreApplicationMode:
; start of function
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	BIS.B	#65, &P1DIR
	BIS.B	#1, &P1OUT
	AND.B	#-65, &P1OUT
	BIS.B	#16, &BCSCTL1
	BIS.B	#32, &BCSCTL3
	MOV.W	#1200, &TA0CCR0
	MOV.W	#272, &TA0CTL
	MOV.W	#112, &TA0CCTL1
	MOV.W	#600, &TA0CCR1
 ; 183 "main.c" 1
	bis.w #216, SR
 ; 0 "" 2
	; start of epilogue
	RET
	.size	PreApplicationMode, .-PreApplicationMode
	.balign 2
	.global	ta1_isr
	.section	__interrupt_vector_9,"ax",@progbits
	.word	ta1_isr
	.text
	.type	ta1_isr, @function
ta1_isr:
; start of function
; attributes: interrupt 
; framesize_regs:     2
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          2
; elim ap -> fp       4
; elim fp -> sp       0
; saved regs: R12
	; start of prologue
	PUSH	R12
	; end of prologue
	BIC.W	#1, &TA0CCTL1
	MOV.W	&Mode, R12
	CMP.W	#0, R12 { JNE	.L3
	XOR.B	#65, &P1OUT
	BR	#.L2
.L3:
	MOV.W	#0, &TA0CCTL1
	BIC.W	#208, 2(SP)
.L2:
	; start of epilogue
	POP	R12
	RETI
	.size	ta1_isr, .-ta1_isr
	.balign 2
	.global	InitializeButton
	.type	InitializeButton, @function
InitializeButton:
; start of function
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	BIC.B	#8, &P1DIR
	BIS.B	#8, &P1OUT
	BIS.B	#8, &P1REN
	BIS.B	#8, &P1IES
	BIC.B	#8, &P1IFG
	BIS.B	#8, &P1IE
	; start of epilogue
	RET
	.size	InitializeButton, .-InitializeButton
	.global	__mspabi_mpyl
	.balign 2
	.global	main
	.type	main, @function
main:
; start of function
; framesize_regs:     2
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          2
; elim ap -> fp       4
; elim fp -> sp       0
; saved regs: R10
	; start of prologue
	PUSH	R10
	; end of prologue
	MOV.W	#23168, &WDTCTL
	MOV.B	&CALBC1_1MHZ, &BCSCTL1
	MOV.B	&CALDCO_1MHZ, &DCOCTL
	AND.B	#-7, &BCSCTL2
	CALL	#InitializeButton
	BIS.B	#65, &P1DIR
	AND.B	#-66, &P1OUT
	BIS.B	#4, &P1DIR
	BIS.B	#4, &P1OUT
	MOV.W	#0, &Mode
	CALL	#PreApplicationMode
	MOV.W	#-24480, &ADC10CTL1
	MOV.W	#14392, &ADC10CTL0
	; Begin 1000 cycle delay
	PUSH	r13
	MOV.W	#331, r13
1:	SUB.W	#1, r13
	JNE	1b
	POP	r13
	; End 1000 cycle delay
 ; 113 "main.c" 1
	eint { nop
 ; 0 "" 2
	MOV.B	#6, &P1SEL
	MOV.B	#6, &P1SEL2
	BIS.B	#-128, &UCA0CTL1
	MOV.B	#104, &UCA0BR0
	MOV.B	#0, &UCA0BR1
	MOV.B	#2, &UCA0MCTL
	BIC.B	#1, &UCA0CTL1
	MOV.W	#__mspabi_mpyl, R10
.L11:
	BIS.W	#3, &ADC10CTL0
 ; 131 "main.c" 1
	bis.w #24, SR
 ; 0 "" 2
	MOV.W	&ADC10MEM, R12
	MOV.W	#761, R14
	MOV.B	#0, R15
	ADD	#-630, R12 ; cy
	MOV.B	#0, R13
	ADDC	#-1, R13
	CALL	R10
	CMP.W	#0, R13 { JGE	.L8
	ADD	#1023, R12 ; cy
	ADDC	#0, R13
.L8:
	CALL	#__mspabi_sral_10
	AND	#0xff, R12
.L10:
	BIT.B	#2, &IFG2 { JEQ	.L10
	MOV.B	R12, &UCA0TXBUF
	XOR.B	#1, &P1OUT
	MOV.W	#2400, &TA0CCR0
	MOV.W	#272, &TA0CTL
	MOV.W	#2400, &TA0CCR1
	MOV.W	#16, &TA0CCTL1
 ; 153 "main.c" 1
	bis.w #216, SR
 ; 0 "" 2
	BR	#.L11
	.size	main, .-main
	.balign 2
	.global	port1_isr
	.section	__interrupt_vector_3,"ax",@progbits
	.word	port1_isr
	.text
	.type	port1_isr, @function
port1_isr:
; start of function
; attributes: interrupt 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	MOV.B	#0, &P1IFG
	BIC.B	#8, &P1IE
	MOV.W	#23069, &WDTCTL
	BIC.B	#1, &IFG1
	BIS.B	#1, &IE1
	MOV.W	#0, &TA0CCTL1
	AND.B	#-66, &P1OUT
	MOV.W	#1, &Mode
	BIC.W	#208, 0(SP)
	; start of epilogue
	RETI
	.size	port1_isr, .-port1_isr
	.balign 2
	.global	wdt_isr
	.section	__interrupt_vector_11,"ax",@progbits
	.word	wdt_isr
	.text
	.type	wdt_isr, @function
wdt_isr:
; start of function
; attributes: interrupt 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	BIC.B	#1, &IE1
	BIC.B	#1, &IFG1
	MOV.W	#23168, &WDTCTL
	BIS.B	#8, &P1IE
	; start of epilogue
	RETI
	.size	wdt_isr, .-wdt_isr
	.balign 2
	.global	adc10_isr
	.section	__interrupt_vector_6,"ax",@progbits
	.word	adc10_isr
	.text
	.type	adc10_isr, @function
adc10_isr:
; start of function
; attributes: interrupt 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	BIC.W	#16, 0(SP)
	; start of epilogue
	RETI
	.size	adc10_isr, .-adc10_isr
	.comm	Mode,2,2
	.comm	TXByte,2,2
	.ident	"GCC: (SOMNIUM Technologies Limited - msp430-gcc 5.3.0.219) 5.3.0"
