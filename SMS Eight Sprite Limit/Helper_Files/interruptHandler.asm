;Get here after coming from $0038
InterruptHandler:
;Check if we are at VBlank, Bit 7 tells us that
    ld a, (VDPStatus)
    bit 7, a                ;Z is set if bit is 0
    jp nz, VBlank           ;If bit 7 is 1, then we are at VBlank

;=========================================================
; HBlank
;=========================================================
HBlank:
    ld hl, VDPStatus
    bit 5, a                        ;A = VDPStatus already
    jr z, +
    set 5, (hl)                     ;Sprite collision      
+:
	ld hl, (nextHBlankStep)		    ;\ JUMP to next step for HBLANK
	jp (hl)					        ;/

;Potential idea. This game will only use HBlank for parallax... I think. 
;This current iteration is good for when a bunch of different things are happening
;But I if I use this loading step to instead set up the next X-Scroll speed,
;That might make this slightly more efficient (and faster), so we would only have to do
/*
    ld hl, (nextXScrollValue)		    ;Load next Hscroll value
    ld a, (hl)
    out (PORT_VDP_ADDRESS), a
	ld a, $88
	out (PORT_VDP_ADDRESS), a		;Set BG X-Scroll to whatever
    ld bc, $02                      ;One WORD
    add hl, bc                      ;HL points to next scrollX value
    ld (nextXScrollValue), hl
    exx
    ex af, af'
    ei
    reti
;Then at VBlank, the first value in the chain would replace this bad value,
;Or maybe the last one in the chain is 0, and we have a HUD at the top of the 
;screen, so VBlank uses this to change the value, and then point to the first
;one in the chain to restart the cycle
*/


FirstHBlank:
    ld hl, +
    ld (nextHBlankStep), hl         ;Prepare the step for the next HBLANK
    ld hl, scrollX0
    ld a, (hl)
	out (PORT_VDP_ADDRESS), a
	ld a, $88
	out (PORT_VDP_ADDRESS), a		;Set BG X-Scroll to whatever
    exx
    ex af, af'
    ei
    reti

+:
    ld hl, FirstHBlank
    ld (nextHBlankStep), hl         ;Prepare the step for the next HBLANK
    ld hl, scrollX1
    ld a, (hl)
	out (PORT_VDP_ADDRESS), a
	ld a, $88
	out (PORT_VDP_ADDRESS), a		;Set BG X-Scroll to something
    exx
    ex af, af'
    ei
    reti

;=========================================================
; VBlank
;=========================================================
;If we are on the last scanline
VBlank:
;We are at VBlank
    ld hl, VDPStatus
    bit 7, a                        ;A = VDPStatus already
    jr z, +
    set 7, (hl)                     ;Sprite collision 
+:
;Update frame count up to 60
    ld hl, frameCount               ;Update frame count
    ld a, 60                        ;Check if we are at 60
    cp (hl)
    jr nz, +                        ;If we are, then reset
ResetFrameCount:
    ld (hl), -1
+:
    inc (hl)                        ;Otherwise, increase

EndVBlank:
;Swap shadow registers and registers back
    exx
    ex af, af'
    ei
;Leave
    reti


