;
; RGB_efekat_po_zelji.asm
;
; Created: 13.10.2022. 08:28:51
; Author : Aleksandar Bogdanovic
;

/* Arduino Asembler, RGB diode 800kHz. Proveriti da li je Arduino 
koji koristite dovoljno brz, ako nije, odraiditi na ESP-u. 
Analizirati protokol, odraditi interfejs gde šaljemo R, G, B tri bajta
i RGB idoda svetli u zadatoj boji*/

// Belo svetli 1 sekund to je main, zatim ide loop - crvena boja 2 sekunde, ugasi se 1 sekund, plava boja 2 sekunde, 

.include "m328pdef.inc"
.org 0x000000
rjmp main

// NOP = 1 clock cycle = 0.0625

.def sp_Loop = r18			// Spoljasni loop register
.def un_LoopL = r24			// Unutrasnji loop LOW registar
.def un_LoopH = r25			// Unutrasnji loop HIGH registar
.equ value = 39998			// Unutrasnja loop vrednost
// TONOVI
.equ _c4 = 239 ; (16000000 / 256) / 261.63 (frekvencija note C4) - 1
.equ _d4 = 213 ; (16000000 / 256) / 293.66 (frekvencija note D4) - 1
.equ _e4 = 190 ; (16000000 / 256) / 329.63 (frekvencija note E4) - 1
.equ _f4 = 179 ; (16000000 / 256) / 349.23 (frekvencija note F4) - 1
.equ _g4 = 159 ; (16000000 / 256) / 392.00 (frekvencija note G4) - 1
.equ _a4 = 141 ; (16000000 / 256) / 440.00 (frekvencija note A4) - 1
.equ _b4 = 126 ; (16000000 / 256) / 493.88 (frekvencija note B4) - 1
.equ _c5 = 118 ; (16000000 / 256) / 554.37 (frekvencija note C5) - 1
// PWM
.equ c4_ = 120 ;(16000000 / 256) / 261.63 / 2(frequency of C) - 1
.equ d4_ = 107 ;(16000000 / 256) / 293.66 / 2(frequency of D) - 1
.equ e4_ = 95 ;(16000000 / 256) / 329.63 / 2(frequency of E) - 1
.equ f4_ = 90 ;(16000000 / 256) / 349.23 / 2(frequency of F) - 1
.equ g4_ = 80 ;(16000000 / 256) / 392.00 / 2(frequency of G) - 1
.equ a4_ = 71 ;(16000000 / 256) / 440.00 / 2(frequency of A) - 1
.equ b4_ = 63 ;(16000000 / 256) / 493.88 / 2(frequency of B) - 1
.equ c5_ = 59 ;(16000000 / 256) / 523.25 / 2(frequency of C) - 1

.macro tone
	// wgm 2.0 = 0x00000111 = 7. fast PWM, TOP = OCR0A
	// Prescaler 256, 0x00000100
	// cs02.0 = 2, 0x00000010, Clear on Compare Match, set at BOTTOM, non inverting mode
	ldi r16, 0b00100011
	out TCCR0A, r16
	ldi r16, 0b00001100
	out TCCR0B, r16
	// OCR0A = _a za 440Hz
	ldi r16, @0
	out OCR0A, r16
	// OCR0B = OCR0A / 2 da bi duty cycle bio 50%
	ldi r17, @1
	out OCR0B, r17
	// Izlaz je na D5, OCR0B
	sbi ddrd, 5			// Set Bit in I/O Register
.endmacro

.macro mute
	cbi ddrd, 5			//Clear Bit in I/O Register
.endmacro

.macro delayms
	push r18
	push r24
	push r25

	ldi r18, @0/10
	call delay10ms

	pop r25
	pop r24
	pop r18
.endmacro

main:
	sbi DDRD, 4
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall delay_ms
	rcall delay_1000ms
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall white
	rcall delay_ms
	rcall delay_2000ms
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall delay_ms
	rcall delay_1000ms
loop:
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall delay_ms
	rcall delay_1000ms	
	mute
	rcall red
	rcall red
	rcall delay_ms
	delayms 300
	tone _c4, c4_	// DO
	delayms 300

	mute
	rcall black
	rcall blue
	rcall blue
	rcall delay_ms
	delayms 300
	tone _c4, c4_	// DO
	delayms 300

	mute
	rcall black
	rcall black
	rcall green
	rcall green
	rcall delay_ms
	delayms 300
	tone _g4, g4_	// SOL
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall red
	rcall red
	rcall delay_ms
	delayms 300
	tone _g4, g4_	// SOL
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall blue
	rcall blue
	rcall delay_ms
	delayms 300
	tone _a4, a4_	// LA
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall green
	rcall green
	rcall delay_ms
	delayms 300
	tone _a4, a4_	// LA
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall red
	rcall red
	rcall delay_ms
	delayms 300
	tone _g4, g4_	// SOL fa fa mi mi re re do
	delayms 500

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall blue
	rcall blue
	rcall delay_ms
	delayms 300
	tone _f4, f4_	// FA
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall green
	rcall green
	rcall delay_ms
	delayms 300
	tone _f4, f4_	// FA
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall red
	rcall red
	rcall delay_ms
	delayms 300
	tone _e4, e4_	// MI
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall blue
	rcall blue
	rcall delay_ms
	delayms 300
	tone _e4, e4_	// MI
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall green
	rcall green
	rcall delay_ms
	delayms 300
	tone _d4, d4_	// RE
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall red
	rcall red
	rcall delay_ms
	delayms 300
	tone _d4, d4_	// RE
	delayms 300

	mute
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall blue
	rcall blue
	rcall delay_ms
	delayms 400
	tone _c4, c4_	// DO
	delayms 400

	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall black
	rcall delay_ms
	rcall delay_500ms
	rjmp loop

black:
	// BLACK = 0x000000, logic 0 code
	ldi r17, 24
b1: sbi PORTD, 4				// 0.40 ms high pulse = 6 CLK cycles
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop	
	nop						// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne b1						// 1 CLK cycles
	ret

white:
	// WHITE = 0xFFFFFF, logic 1 code
	ldi r17, 24					// 24 bits
w1: sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	//
	cbi PORTD, 4				// 0.45ms low pulse
	// logic 0
	nop
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne w1						// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	ret

green:
	// GREEN = 0xFF0000
	ldi r17, 8					// counter for 1st 8 bits
// logic 1
g1:	sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	cbi PORTD, 4				// 0.45ms low pulse
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne g1						// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	//
	ldi r17, 16					// counter for remaining 16 bits
	// logic 0
g2:	sbi PORTD, 4				// 0.40ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne g2						// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms 
	ret

red:
	// RED = 0x00FF00
	ldi r17, 8					// counter for 1st 8 bits => 00
	// logic 0
red1:sbi PORTD, 4				// 0.40ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne red1					// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms
	//
	ldi r17, 8					// counter for 2nd 8 bits => XX
	// logic 1
red2:sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	cbi PORTD, 4				// 0.45ms low pulse
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne red2					// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	//
	ldi r17, 8					// counter for final 8 bits => 00
	// logic 0
red3:sbi PORTD, 4				// 0.40 ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne red3					// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms
	ret

blue:
	// BLUE = 0x0000FF
	ldi r17, 16					// counter for 1st 16 bits => 0000
	// logic 0
bl1: sbi PORTD, 4				// 0.40 ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne bl1						// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms
	//
	ldi r17, 8					// counter for final 8 bits => XX
	// logic 1
bl2:	sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	cbi PORTD, 4				// 0.45ms low pulse
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne bl2						// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	ret

delay_ms:					// delay = 50 micro seconds => reset
	ldi  r18, 2
    ldi  r19, 8
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
    ret

delay_2000ms:
	ldi  r18, 163
    ldi  r19, 87
    ldi  r20, 3
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
	ret

delay_1000ms:			// delay je od 0.5 sekunde
	ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 127
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
    rjmp PC+1
	ret

delay_300ms:
	ldi  r20, 25
    ldi  r21, 90
    ldi  r22, 178
L10:dec  r22
    brne L10
    dec  r21
    brne L10
    dec  r20
    brne L10
    nop
	ret

delay_500ms:
	 ldi  r20, 41
    ldi  r21, 150
    ldi  r22, 127
L11:dec  r22
    brne L11
    dec  r21
    brne L11
    dec  r20
    brne L11
    rjmp PC+1
	ret

	// Delay sound
	delay10ms:
		ldi un_LoopL, low(value)	// Inicijalizuje unutrasnji loop counter
		ldi un_LoopH, low(value)

	loop1:
		sbiw un_LoopL, 1			// Umanjuje unutrasnji loop registar za 1
		brne loop1				

		dec sp_Loop					// Umanjuje spoljasnji loop register za 1
		brne delay10ms
		nop
		ret



