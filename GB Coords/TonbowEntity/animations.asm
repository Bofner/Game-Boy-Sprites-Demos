;==============================================================
; Adjust Animation
;==============================================================
@AdjustFrame:
	;If neither then reset our action
		ld a, (hl)							;A = (entity.state)
		and TONBOW_ANIMATION_RESET
		ld (hli), a							;HL = entity.timer
		ld a, (hl)
		cp $00
		jr nz, @@NoTimerReset
		@@TimerReset:
			ld (hl), TONBOW_TIMER_INIT_VALUE
		@@NoTimerReset:
		dec (hl)							;Decrease our timer
		ld a, (hld)							;HL = entity.state, A = (entity.timer)
	;If timer is halfway finished, change to frame 2
		cp TONBOW_TIMER_INIT_VALUE / 2
		jr c, @@SetFrame2
		@@SetFrame1:
			ld a, (hl)						;A = (entity.state)
			or TONBOW_FRAME1
			ld (hl), a
			jr @AdjustFrameEnd
		@@SetFrame2:
			ld a, (hl)						;A = (entity.state)
			or TONBOW_FRAME2
			ld (hl), a
	@AdjustFrameEnd:

	dec hl									;HL = entity.eventID

	ret

;==============================================================
; Update Entity Animation based on state
;==============================================================
@UpdateEntityAnimation:
	push hl									;Save entity.eventID
		inc hl								;HL = entity.state
		ld a, (hl)							;A = (entity.state)
		and TONBOW_CURRENT_DIRECTION		;The %111 direction entry
		srl a
		srl a
		ld b, a								;B = our counter for finding Object Data
		push hl
		ld hl, TonbowEntityClass@ObjectData
		ld de, TONBOW_OBJ_DATA_SIZE_DIRECTION
		xor a
		cp b
		jr z, @@FindAction
		@@FindDirection:
		-:
			add hl, de						;HL = Tonbow Object Data Direction.Frame1
			dec b
			cp b
			jr nz, -
		@@FindAction:
			pop de							;DE = entity.state
			ld a, (de)						;A = (entity.State)
			and TONBOW_DEAD					;The %11 direction entry
			ld b, a
			ld de, TONBOW_OBJ_DATA_SIZE_ACTION
			xor a
			cp b
			jr z, @@SetObjectDataPointer
		-:
			add hl, de						;HL = objData.DIRECTION.nextAction
			dec b
			cp b
			jr nz, -

		@@SetObjectDataPointer:
			push hl
			pop bc							;BC = objData.direction.action
	pop hl									;HL = entity.eventID
	push hl									;Save entity.eventID
			ld de, entityStructure.objectDataPointer - entityStructure.eventID
			add hl, de						;HL = entity.objectDataPointer
			ld a, c
			ld (hli), a
			ld a, b
			ld (hl), a						;Object Data Pointer is updated		
	pop hl									;HL = entity.eventID
@UpdateEntityAnimationEnd:

	ret