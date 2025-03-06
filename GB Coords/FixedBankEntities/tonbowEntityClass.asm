.BANK 0 SLOT 0
.SECTION "Tonbow Entity Class"
TonbowEntityClass:
;================================================================================
; All subroutines and data related to the Tonbow Entity Class
;================================================================================

;==============================================================
; Tonbow Constants
;==============================================================

;Tonbow OBJ Data:
	.DEF	TONBOW_NUM_OBJS							$02
	.DEF	TONBOW_SIZE								$10
	.DEF	TONBOW_SHAPE							$21

;VRAM Absolute Data
	;Up and Down
	.DEF	TONBOW_UD_GLIDE_VRAM_ABS				$8000
	.DEF	TONBOW_UD_FLAP_VRAM_ABS					TONBOW_UD_GLIDE_VRAM_ABS + $40
	.DEF	TONBOW_UD_DASH_VRAM_ABS					TONBOW_UD_FLAP_VRAM_ABS + $40
	;Left and Right
	.DEF	TONBOW_LR_GLIDE_VRAM_ABS				TONBOW_UD_DASH_VRAM_ABS + $40
	.DEF	TONBOW_LR_FLAP_VRAM_ABS					TONBOW_LR_GLIDE_VRAM_ABS + $40
	.DEF	TONBOW_LR_DASH_VRAM_ABS					TONBOW_LR_FLAP_VRAM_ABS + $40
	;Diagonal
	.DEF	TONBOW_DIAG_FLAP_VRAM_ABS				TONBOW_LR_DASH_VRAM_ABS + $40
	.DEF	TONBOW_DIAG_GLIDE_VRAM_ABS				TONBOW_DIAG_FLAP_VRAM_ABS + $40
	.DEF	TONBOW_DIAG_DASH_VRAM_ABS				TONBOW_DIAG_GLIDE_VRAM_ABS + $40

	;OAM Data
	.DEF	TONBOW_OBJ_DATA_SIZE_DIRECTION			TonbowEntityClass@UpEnd - TonbowEntityClass@GlideUp
	.DEF	TONBOW_OBJ_DATA_SIZE_ACTION				TonbowEntityClass@FlapUp - TonbowEntityClass@GlideUp

	;Init Values
	.DEF 	TONBOW_START_Y							$0500 + $0100		;96 = $60.0 + yPos Offset
	.DEF	TONBOW_START_X	 						$0500 + $0080		;40 = $28.0 + xPos Offset
	.DEF	TONBOW_X_Y_POS_OFFSET					$08

	;Constant values
	.DEF	TONBOW_SPEED							$16					;$LSB,FRAC
	.DEF	TONBOW_DIAG_NORM_SPEED					$10
	.DEF	TONBOW_DASH_SPEED						$30
	.DEF	TONBOW_DIAG_DASH_NORM_SPEED				$21

	.DEF	TONBOW_TIMER_INIT_VALUE					$0C
	.DEF	TONBOW_DASH_RESET_TIMER_VALUE			$28
	.DEF	TONBOW_DASH_LENGTH_TIMER_VALUE			$16		

	;Attack Hitbox
	.DEF	TONBOW_ATK_HITBOX_WIDTH					$10		
	.DEF	TONBOW_ATK_HITBOX_HEIGHT				$08	
	

;Tonbow States
/*
	States follow this format:
	Bit 7   : NORMAL = 0, STRAFE = 1
	Bit 6-5 : 0
	Bit 4-2 : UP = %000, DOWN = %001, RIGHT = %010, LEFT = %011
			  UR = %100, UL   = %101, DR    = %110, DL   = %111
	Bit 1-0 : FRAME1 = %00, FRAME2 = %01, DASH = %10, DEAD = %11
	Based off of entity.timer and player input, constants will be
	OR'd with the state after it is reset
	Example:
	(entity.state) AND TONBOW_RESET_DIRECTION
	(entity.state) OR TONBOW_UP
	IF button pressed, then
		(entity.state) OR TONBOW_DASH 
	END
*/
;Direction
	.DEF	TONBOW_RESET_DIRECTION				%11100011	;Use with AND
	.DEF	TONBOW_CURRENT_DIRECTION			%00011100
	.DEF	TONBOW_UP							%00000000	;Use with OR
	.DEF	TONBOW_DOWN							%00000100	;Use with OR
	.DEF	TONBOW_RIGHT						%00001000	;Use with OR
	.DEF	TONBOW_LEFT							%00001100	;Use with OR
	.DEF	TONBOW_UR							%00010000	;Use with OR
	.DEF	TONBOW_UL							%00010100	;Use with OR
	.DEF	TONBOW_DR							%00011000	;Use with OR
	.DEF	TONBOW_DL							%00011100	;Use with OR

;Strafe
	.DEF	STRAFE_RESET						%01111111	;Use with AND
	.DEF	STRAFE_SET							%10000000	;Use with OR

;Animation
	.DEF	TONBOW_ANIMATION_RESET				%11111100	;Use with AND
	.DEF	TONBOW_FRAME1						%00000000	;Use with OR
	.DEF	TONBOW_FRAME2						%00000001	;Use with OR
	.DEF	TONBOW_DASH							%00000010	;Use with OR
	.DEF	TONBOW_DEAD							%00000011	;Use with OR


;==============================================================
; Check for player input
;==============================================================
;Parameters: DE = JR Table Address
@CheckPlayerDirections:
;Check Directions
	ld a, (currentKeyPress1)
	and DPAD_DOWN | DPAD_UP | DPAD_LEFT | DPAD_RIGHT
	swap a
	jr +
@CheckPlayerButtons:
;Check buttons
	ld a, (currentKeyPress1)
	and STR_BUTTON | SEL_BUTTON | B_BUTTON | A_BUTTON
+:
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
; Updates Tonbow
;==============================================================
;
;Parameters: DE = entity.eventID (Should be coming from EntityList@UpdateEntities)
;Returns: None
;Affects: DE
@UpdateTonbow:
;Grab Event ID
	push de									;Save entity.eventID
	pop hl									;HL = entity.eventID

;Check if there is an event to deal with
	;If idle, then continue
	;If being killed or firing or something, then execute special code
	
	@@CheckState:
	;Check if we are dead
		inc hl								;HL = entity.state
		ld a, (hl)
		and TONBOW_DEAD
		cp TONBOW_DEAD
		jr z, @@AdjustFrameEnd
	;Check if we are dashing
		ld a, (hl)							;A = (entity.state)
		and TONBOW_DASH
		cp TONBOW_DASH
		jr nz, @@CheckDashReset

	@@HandleDashContinuation:
	;Handle the continuation of a dash
		inc hl								;HL = entity.timer
		ld a, (hl)
		cp $00
		jr z, @@@EndDash
		dec (hl)
		dec hl						;HL = entity.state
		dec hl						;HL = entity.eventID
		jr @@UpdateEntityAnimation
			@@@EndDash:
				dec hl						;HL = entity.state

	@@CheckDashReset:
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

	@@AdjustFrame:
	;If neither then reset our action
		ld a, (hl)							;A = (entity.state)
		and TONBOW_ANIMATION_RESET
		ld (hli), a							;HL = entity.timer
		ld a, (hl)
		cp $00
		jr nz, @@@NoTimerReset
		@@@TimerReset:
			ld (hl), TONBOW_TIMER_INIT_VALUE
		@@@NoTimerReset:
		dec (hl)							;Decrease our timer
		ld a, (hld)							;HL = entity.state, A = (entity.timer)
	;If timer is halfway finished, change to frame 2
		cp TONBOW_TIMER_INIT_VALUE / 2
		jr c, @@@SetFrame2
		@@@SetFrame1:
			ld a, (hl)						;A = (entity.state)
			or TONBOW_FRAME1
			ld (hl), a
			jr @@AdjustFrameEnd
		@@@SetFrame2:
			ld a, (hl)						;A = (entity.state)
			or TONBOW_FRAME2
			ld (hl), a
	@@AdjustFrameEnd:

	dec hl									;HL = entity.eventID
	push hl									;Save entity.ID
	
;Check the buttons
	@@ResetTonbowStrafe:
		inc hl								;HL = entity.state
		ld a, STRAFE_RESET
		and (hl)
		ld (hl), a
		dec hl								;HL = entity.eventID
	@@ResetTonbowStrafeEnd:

	ld de, TonbowEntityClass@ButtonJumpTable
	call @CheckPlayerButtons

	pop hl									;HL = entity.eventID
	push hl									;Save entity.ID

;Check the DPad
	@@CheckDirectionalInput:
	;Check if we are dashing
		inc hl								;HL = entity.state
		ld a, (hld)							;HL = entity.eventID
		and TONBOW_DASH
		jr nz, @@CheckDirectionalInputEnd							
		@@@ResetTonbowVelocity:
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
		@@@ResetTonbowVelocityEnd:
	ld de, TonbowEntityClass@DirectionalJumpTable
	call @CheckPlayerDirections
	@@CheckDirectionalInputEnd:

	pop hl									;HL = entity.eventID
	
;Update Animation based off of state
	@@UpdateEntityAnimation:
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
		jr z, @@@FindAction
		@@@FindDirection:
		-:
			add hl, de						;HL = Tonbow Object Data Direction.Frame1
			dec b
			cp b
			jr nz, -
		@@@FindAction:
			pop de							;DE = entity.state
			ld a, (de)						;A = (entity.State)
			and TONBOW_DEAD					;The %11 direction entry
			ld b, a
			ld de, TONBOW_OBJ_DATA_SIZE_ACTION
			xor a
			cp b
			jr z, @@@SetObjectDataPointer
		-:
			add hl, de						;HL = objData.DIRECTION.nextAction
			dec b
			cp b
			jr nz, -

		@@@SetObjectDataPointer:
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
	@@UpdateEntityAnimationEnd:

	@@UpdatePosition:
	;Update Position
	push hl								;Save entity.eventID
	;Save previous xPos to see if we need to update our column
		ld de, tonbowStructure.xPos - tonbowStructure.eventID
		add hl, de						;HL = tonbow.xPos
		ld a, (hl)						;A = (tonbow.xPos)
		ld de, tonbowStructure.eventID - tonbowStructure.xPos
		add hl, de						;HL = tonbow.eventID
		push af
			call GeneralEntityEvents@UpdatePosition
			;HL = atkHitbox
		;Update atkHitbox location
			dec hl									;HL = tonbow.xPos
			ld b, (hl)
			ld de, tonbowStructure.yPos - tonbowStructure.xPos
			add hl, de								;HL = tonbow.yPos
			ld a, (hl)
			ld de, tonbowStructure.atkHitbox.y1 - tonbowStructure.yPos
			add hl, de								;HL = tonbow.atkHitbox.y1
			sub a, YPOS_OFFSET						;Adjust for offset
			ld (hli), a								;HL = tonbow.atkHitbox.x1
			ld a, b									;B = New (tonbow.xPos)
			sub a, XPOS_OFFSET
			ld (hl), a
			;HL = tonbow.atkHitbox
		pop af							; A = Old (tonbow.xPos)

	@@UpdateCurrentColumns:
	;Update location of atkHitbox in regards to the columns if need be
		cp b							;If no change in xPos, don't bother
		call nz, ColumnClass@UpdateEntityCurrentColumns

	@@CheckCollision:
	;Check if we are being hit by something
	;Check if we are invincible, if invincible, skip collision detection (tonbow.state)
		call ColumnClass@CheckColumnCollision
			
	pop hl								;HL = entity.eventID

	@@AddToOAM:
	;Add Entity to the OAM Buffer
		;HL = entity.eventID
		call GeneralEntityEvents@OAMHandler

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


;==============================================================
; Initializes the Entity
;==============================================================
;
;Parameters:  	HL = entity.eventID 
;Affects: A, HL, DE
@Initialize:
;Initialize General properties
	push hl
		;Set yPos
		ld de, initYPosVar
		ld a, hibyte(TONBOW_START_Y)
		ld (de), a
		inc de
		ld a, lobyte(TONBOW_START_Y)
		ld (de), a
		;Set xPos
		ld de, initXPosVar
		ld a, hibyte(TONBOW_START_X)
		ld (de), a
		inc de
		ld a, lobyte(TONBOW_START_X)
		ld (de), a
		;Set timer
		ld a, TONBOW_TIMER_INIT_VALUE
		ld (aux8BitVar), a
		;Set UpdateEntityPointer
		ld bc, TonbowEntityClass@UpdateTonbow
		;Set ObjectDataPointer
		ld de, TonbowEntityClass@ObjectData
		call GeneralEntityEvents@InitializeEntity
		;Returns us with HL = tonbow.atkHitbox
		ld (hl), $00
		inc hl							;HL = tonbow.atkHitBox.width
		ld (hl), TONBOW_ATK_HITBOX_WIDTH
		inc hl							;HL = tonbow.atkHitbox.height
		ld (hl), TONBOW_ATK_HITBOX_HEIGHT
	pop hl
	push hl
	;Set up xPos, yPos, and atkHitbox
		call GeneralEntityEvents@UpdatePosition	
		;HL = atkHitbox
		dec hl									;HL = tonbow.xPos
		ld b, (hl)
		ld de, tonbowStructure.yPos - tonbowStructure.xPos
		add hl, de								;HL = tonbow.yPos
		ld a, (hl)
		ld de, tonbowStructure.atkHitbox.y1 - tonbowStructure.yPos
		add hl, de								;HL = tonbow.atkHitbox.y1
		sub a, YPOS_OFFSET						;Adjust for offset
		ld (hli), a								;HL = tonbow.atkHitbox.x1
		ld a, b
		sub a, XPOS_OFFSET
		ld (hl), a
	pop hl
;Initialize Tonbow Specific properties
	;HL = tonbow.eventID
	ld de, tonbowStructure.timer - tonbowStructure.eventID
	add hl, de							;HL = tonbow.timer
	ld a, TONBOW_TIMER_INIT_VALUE
	ld (hli), a							;HL = tonbow.entityUpdatePointer	
	;The pointer WORD of it's Update Handler
	ld de, TonbowEntityClass@UpdateTonbow
	ld a, e
	ld (hli), a
	ld a, d
	ld (hli), a							;HL = tonbow.objectDataPointer
	;The pointer WORD to the beginning of OBJ data
	ld de, TonbowEntityClass@ObjectData
	ld a, e
	ld (hli), a
	ld a, d
	ld (hli), a											

	ret


;==============================================================
; Tonbow Entity's Object Data
;==============================================================
@ObjectData
	@GlideUp:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@FlapUp:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@DashUp:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	@DeadUp:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 
	@UpEnd:

	;----

	@GlideDown:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP					;objectAtr
	@FlapDown:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP					;objectAtr
	@DashDown:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP					;objectAtr
	@DeadDown:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;----------------------------

	@GlideRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@FlapRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr


	@DashRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	@DeadRight:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 
	@FrameRightEnd:

	;--------------------------------------

	@GlideLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_LR_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_LR_GLIDE_VRAM_ABS  >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr

	@FlapLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE											;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_LR_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_LR_FLAP_VRAM_ABS  >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr

	@DashLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE											;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_LR_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP			;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_LR_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP			;objectAtr
	@DeadLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;--------------------

	@GlideUpRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@FlapUpRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@DashUpRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	@DeadUpRight:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;--------------------
	
	@GlideUpLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr

	@FlapUpLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr


	@DashUpLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP					;objectAtr
	@DeadUpLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;--------------------
	
	@GlideDownRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP				;objectAtr

	@FlapDownRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP				;objectAtr


	@DashDownRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_YFLIP				;objectAtr
	@DeadDownRight:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 


	;--------------------
	
	@GlideDownLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP | OAMF_YFLIP		;objectAtr

	@FlapDownLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP | OAMF_YFLIP		;objectAtr


	@DashDownLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	@DeadDownLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

@Tiles:
	;UP AND DOWN
	@@UpDown:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\tonbowUDGlide.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\tonbowUDFlap.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\tonbowUDDash.inc"
		@@@DashEnd:
	@@UpDownEnd:
	;LEFT AND RIGHT
	@@LeftRight:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\tonbowLRGlide.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\tonbowLRFlap.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\tonbowLRDash.inc"
		@@@DashEnd:

	@@LeftRightEnd:
	;DIAGONAL
	@@Diagonal:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\tonbowDiagGlide.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\tonbowDiagFlap.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\tonbowDiagDash.inc"
		@@@DashEnd:
	@@DiagEnd:


TonbowEntityClassEnd:



.ENDS