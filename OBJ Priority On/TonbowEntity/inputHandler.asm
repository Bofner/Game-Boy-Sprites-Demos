;==============================================================
; Check for player input
;==============================================================
;Parameters: DE = JR Table Address
@CheckPlayerDirections:
;Check Directions
	ld a, (currentKeyPress1)
	and DPAD_DOWN | DPAD_UP | DPAD_LEFT | DPAD_RIGHT
	swap a
	jr @JumpToJRTable
@CheckPlayerButtons:
;Check buttons
	ld a, (currentKeyPress1)
	and STR_BUTTON | SEL_BUTTON | B_BUTTON | A_BUTTON
@JumpToJRTable:
;2 * N + ActionButtonJumpTable
	ld c, a
	add a, c						;2 * N
	push hl
	pop bc							;BC = entity.eventID
	ld h, 0
	ld l, a
	;DE = JR Table Address
	add hl, de                      ;2 * N + ActionButtonJumpTable
	jp hl                           ;Jump to specific input subroutine

;==============================================================
; Check DPad
;==============================================================
@CheckDirectionalInput:
;Check if we are dashing
	inc hl								;HL = entity.state
	ld a, (hld)							;HL = entity.eventID
	and TONBOW_DASH
	jp nz, @CheckDirectionalInputEnd							
	@@ResetTonbowVelocity:
	;Reset the yVelocity
		xor a
		ld de, entityStructure.yVel - entityStructure.eventID
		add hl, de							;HL = tonbow.yVel
		ld (hl), a
	;Reset the xVelocity
		ld de, entityStructure.xVel - entityStructure.yVel
		add hl, de							;HL = tonbow.yVel
		ld (hl), a
		ld de, entityStructure.eventID - entityStructure.xVel
		add hl, de							;HL = tonbow.eventID
	@@ResetTonbowVelocityEnd:
	ld de, TonbowEntityClass@DirectionalJumpTable
	call @CheckPlayerDirections

@CheckDirectionalInputEnd:
	ret
	
;==============================================================
; Tonbow Directional JR Table
;==============================================================
@DirectionalJumpTable:
	;Each event has a number, and the Jump Table's entries correspond to the event numbers
	;If there is no event
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Right
	jr TonbowEntityClass@MoveRight
	;If we pressed Left
	jr TonbowEntityClass@MoveLeft
	;If we pressed Right & Left
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Up
	jr TonbowEntityClass@MoveUp
	;If we pressed Up & Right
	jr TonbowEntityClass@MoveUpRight
	;If we pressed Up & Left
	jr TonbowEntityClass@MoveUpLeft
	;If we pressed Up & Left & Right
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Down
	jr TonbowEntityClass@MoveDown
	;If we pressed Down & Right
	jr TonbowEntityClass@MoveDownRight
	;If we pressed Down & Left
	jr TonbowEntityClass@MoveDownLeft
	;If we pressed Down & Left & Right
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Down & Up
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Down & Up & Right
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Down & Up & Left
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Down & Up & Left & Right
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
    
	;Extra protection ret
	ret


;==============================================================
; Apply vertical movement
;==============================================================
;Parameters: BC = entity.eventID
;Returns: None
;Affects: A, BC, DE, HL 
@MoveDown:
	ld a, TONBOW_SPEED
	ld d, TONBOW_DOWN
	jr @VerticalMovement
@MoveUp:
;Set UP speed and UP state
	ld a, -TONBOW_SPEED
	ld d, TONBOW_UP
;Parameters: A = Speed (+/-), D = Direction (Up/Down)
@VerticalMovement:
	push bc						
	pop hl 						;HL = entity.eventID
	ld bc, entityStructure.yVel - entityStructure.eventID
	add hl, bc
;If pressed, move Up
	;A = (+/-)TONBOW_SPEED
	ld (hl), a
;And adjust state
	ld bc, entityStructure.state - entityStructure.yVel
	add hl, bc					;HL = entity.states
	ld a, (hl)
;Check if strafing
	bit 7, a					;Is Strafe Bit set?
	ret nz
;If not, then adjust our direction
	and TONBOW_RESET_DIRECTION
	;D = TONBOW_DOWN/TONBOW_UP
	or d
	ld (hl), a					;State is now updated

	ret

@MoveUpRight:
	ld a, -TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_UR
	push bc
	call @VerticalMovement
	pop bc
	ld a, TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_UR
	jr @HorizontalMovement
@MoveUpLeft:
	ld a, -TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_UL
	push bc
	call @VerticalMovement
	pop bc
	ld a, -TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_UL
	jr @HorizontalMovement
@MoveDownRight:
	ld a, TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_DR
	push bc
	call @VerticalMovement
	pop bc
	ld a, TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_DR
	jr @HorizontalMovement
@MoveDownLeft:
	ld a, TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_DL
	push bc
	call @VerticalMovement
	pop bc
	ld a, -TONBOW_DIAG_NORM_SPEED
	ld d, TONBOW_DL
	jr @HorizontalMovement


;==============================================================
; Apply horizontal movement
;==============================================================
;Parameters: BC = entity.eventID
;Returns: None
;Affects: A, BC, DE, HL 
@MoveLeft:
	ld a, -TONBOW_SPEED
	ld d, TONBOW_LEFT
	jr @HorizontalMovement
@MoveRight:
	ld a, TONBOW_SPEED
	ld d, TONBOW_RIGHT
;Parameters: A = Speed (+/-), D = Direction (Up/Down)
@HorizontalMovement:
	push bc						
	pop hl 						;HL = entity.eventID
	ld bc, entityStructure.xVel - entityStructure.eventID
	add hl, bc
;If pressed, move Up
	;A = (+/-)TONBOW_SPEED
	ld (hl), a
;And adjust state
	ld bc, entityStructure.state - entityStructure.xVel
	add hl, bc					;HL = entity.states
	ld a, (hl)
;Check if strafing
	bit 7, a					;Is Strafe Bit set?
	ret nz
;If not, then adjust our direction
	and TONBOW_RESET_DIRECTION
	;D = TONBOW_LEFT/TONBOW_RIGHT
	or d
	ld (hl), a					;State is now updated

	ret

;==============================================================
; Button Check
;==============================================================
@CheckButtons:
	@@ResetTonbowStrafe:
		inc hl								;HL = entity.state
		ld a, STRAFE_RESET
		and (hl)
		ld (hl), a
		dec hl								;HL = entity.eventID
	@@ResetTonbowStrafeEnd:

	ld de, TonbowEntityClass@ButtonJumpTable
	call @CheckPlayerButtons

	ret

;==============================================================
; Dash Check
;==============================================================
@CheckDash:
	ld a, (hl)							;A = (entity.state)
	and TONBOW_DASH
	cp TONBOW_DASH
	jr nz, @CheckDashReset

@HandleDashContinuation:
;Handle the continuation of a dash
	inc hl								;HL = entity.timer
	ld a, (hl)
	cp $00
	jr z, @@EndDash
	dec (hl)
	dec hl						;HL = entity.state
	dec hl						;HL = entity.eventID
	pop de													;\
	ld de, TonbowEntityClass@UpdateTonbow@UpdateAnimation	; } Change RET destination
	push de													;/
	ret
		@@EndDash:
			dec hl						;HL = entity.state

@CheckDashReset:
;Check if our Dash Reset Timer has reached zero yet
	ld de, tonbowStructure.dashResetTimer - tonbowStructure.state
	add hl, de 							;HL = tonbow.dashResetTimer
	ld a, (hl)
	cp $00
	jr z, +
;It has not reached zero yet
	dec (hl)
+:
	ld de, tonbowStructure.state - tonbowStructure.dashResetTimer
	add hl, de 							;HL = tonbow.state

	ret

;==============================================================
; Tonbow Button JR Table
;==============================================================
@ButtonJumpTable:
	;Each event has a number, and the Jump Table's entries correspond to the event numbers
	;If there is no event
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed A
	jr TonbowEntityClass@AButton
	jr TonbowEntityClass@BButton
	;If we pressed B & A
	jr TonbowEntityClass@BothButtons
	;If we pressed Select
	jr TonbowEntityClass@SelectButton
	;If we pressed Select & A
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Select & B
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Select & B & A
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start
	jr TonbowEntityClass@StartButton
	;If we pressed Start & A
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start & B
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start & B & A
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start & Select
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start & Select & A
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start & Select & B
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
	;If we pressed Start & Select & B & A
	ret                         ;JR is 2 bytes...
    nop                         ;...So RET and NOP
    
	;Extra protection ret
	ret

;==============================================================
; Tonbow A Button
;==============================================================
;
;Parameters: BC = entity.eventID
;Returns: None
;Affects: A, BC
@AButton:
;Check if we can dash
	push bc						
	pop hl 						;HL = entity.eventID
	ld de, tonbowStructure.dashResetTimer - tonbowStructure.eventID
	add hl, de					;HL = tonbow.dashResetTimer
	ld a, (hl)
	cp $00
	ret nz
;Tonbow Dash
	ld de, tonbowStructure.state - tonbowStructure.dashResetTimer 
	add hl, de					;HL = tonbow.dashResetTimer
	ld a, (hl)		
;Set Tonbow Animation			
	and TONBOW_ANIMATION_RESET	
	or TONBOW_DASH				;Set Tonbow to Dashing
	ld (hli), a					;HL = entity.timer
	ld (aux8BitVar), a			;Save Tonbow State
;Hijack animation timer for our dash
	ld (hl), TONBOW_DASH_LENGTH_TIMER_VALUE
	ld de, tonbowStructure.dashResetTimer - tonbowStructure.timer
	add hl, de					;HL = tonbow.dashResetTimer
;Set our Dash Reset Timer
	ld (hl), TONBOW_DASH_RESET_TIMER_VALUE
;Reset our velocities
	@@ResetTonbowVelocity:
		;Reset the yVelocity
			xor a
			ld de, entityStructure.yVel - tonbowStructure.dashResetTimer
			add hl, de							;HL = tonbow.yVel
			ld (hl), a
		;Reset the xVelocity
			ld de, entityStructure.xVel - entityStructure.yVel
			add hl, de							;HL = tonbow.yVel
			ld (hl), a
			ld de, entityStructure.eventID - entityStructure.xVel
			add hl, de							;HL = tonbow.eventID
	@@ResetTonbowVelocityEnd:
;Set up a JR table
	ld a, (aux8BitVar)			;A = (tonbow.state)
	and TONBOW_CURRENT_DIRECTION
	srl a
	srl a	;Directions now are represented by a number that corresponds to JR table entries
;2 * N + ActionButtonJumpTable
	ld de, TonbowEntityClass@DashJumpTable
	ld c, a
	add a, c						;2 * N
	push hl
	pop bc							;BC = entity.eventID
	ld h, 0
	ld l, a
	;DE = JR Table Address
	add hl, de                      ;2 * N + ActionButtonJumpTable
	jp hl                           ;Jump to specific input subroutine

	ret
;==============================================================
; Tonbow B Button
;==============================================================
;
;Parameters: BC = entity.eventID
;Returns: None
;Affects: A, BC
@BButton:
;Tonbow Strafe
	push bc						
	pop hl 						;HL = entity.eventID
	inc hl						;HL = entity.state
	;ld bc, entityStructure.state - entityStructure.eventID
	;add hl, bc
	ld a, (hl)
	or STRAFE_SET
	ld (hl), a

	ret
;==============================================================
; Tonbow A & B Button
;==============================================================
;
;Parameters: BC = entity.eventID
;Returns: None
;Affects: A, BC
@BothButtons:
;Tonbow Strafe
	call @BButton
	jr @AButton

	ret
;==============================================================
; Tonbow Start Button
;==============================================================
;
;Parameters: BC = entity.eventID
;Returns: None
;Affects: A, BC
@StartButton:

	ret
;==============================================================
; Tonbow Select Button
;==============================================================
;
;Parameters: DE = entity.eventID
;Returns: None
;Affects: A, BC
@SelectButton:

	ret

@DashJumpTable:
		jr @@DashUp
		jr @@DashDown
		jr @@DashRight
		jr @@DashLeft
		jr @@DashUpRight
		jr @@DashUpLeft
		jr @@DashDownRight
		jr @@DashDownLeft

	@@DashUp:
		ld a, -TONBOW_DASH_SPEED
		ld d, TONBOW_UP
		jp TonbowEntityClass@VerticalMovement
		;ret

	@@DashDown:
		ld a, TONBOW_DASH_SPEED
		ld d, TONBOW_DOWN
		jp TonbowEntityClass@VerticalMovement
		;ret

	@@DashLeft:
		ld a, -TONBOW_DASH_SPEED
		ld d, TONBOW_LEFT
		jp TonbowEntityClass@HorizontalMovement
		;ret

	@@DashRight:
		ld a, TONBOW_DASH_SPEED
		ld d, TONBOW_RIGHT
		jp TonbowEntityClass@HorizontalMovement
		;ret

	@@DashUpRight:
		ld a, -TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_UR
		push bc
			call TonbowEntityClass@VerticalMovement
		pop bc
		ld a, TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_UR
		jp TonbowEntityClass@HorizontalMovement
		;ret

	@@DashUpLeft:
		ld a, -TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_UL
		push bc
			call TonbowEntityClass@VerticalMovement
		pop bc
		ld a, -TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_UL
		jp TonbowEntityClass@HorizontalMovement
		;ret

	@@DashDownRight:
		ld a, TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_DR
		push bc
			call TonbowEntityClass@VerticalMovement
		pop bc
		ld a, TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_DR
		jp TonbowEntityClass@HorizontalMovement

	@@DashDownLeft:
		ld a, TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_DL
		push bc
			call TonbowEntityClass@VerticalMovement
		pop bc
		ld a, -TONBOW_DIAG_DASH_NORM_SPEED
		ld d, TONBOW_DL
		jp TonbowEntityClass@HorizontalMovement
		;ret