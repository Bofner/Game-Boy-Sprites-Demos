.SECTION "Memory Routines"
;================================================================================
; Any multi-purpose memory-related routines
;================================================================================


;==============================================================
; Copies memory to another place in RAM (VRAM, SRAM, OAM etc.)
;==============================================================
;
;Parameters: DE = Source, HL = Destination, BC = Length
;Returns: None
;Affects: A, HL, DE, BC
MemCopy:
	ld a, (de)
	ld (hli), a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, MemCopy
	ret



;==============================================================
; Math Test Routine
;==============================================================
;
;Parameters: de = entity.x.eventID
;Returns: None
;Affects: A, HL, DE, BC
TestRoutine:
;Get the difference between the current entity.current and entity.0
	ld hl, entityList.entity.0
	ld a, e
	sub a, l
	ld l, a
	ld a, d
	sbc a, h
	ld h, a
;Find the ID difference
	srl h								;/2
	rr l
	srl h								;/4
	rr l
	srl h								;/8
	rr l
	srl h								;/16
	rr l
	srl h								;/32
	rr l
	srl h								;/64
	rr l
;Find the Position in the bitmap
	xor a
	srl l								;/2
	rra
	srl l								;/4
	rra
	srl l								;/8
	rra
	srl a								;Move over one more time to make the proper nibble
	or l								;Put em together
	swap a								;And put them in the correct order of $BYTE,BIT
;L = BYTE, A = BIT

	ret


.ENDS