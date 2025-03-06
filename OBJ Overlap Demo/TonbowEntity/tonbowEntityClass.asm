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
	.DEF	TONBOW_NUM_OBJS							$01
	.DEF	TONBOW_SIZE								$08
	.DEF	TONBOW_SHAPE							$11

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
	.DEF	TONBOW_OBJ_DATA_SIZE_DIRECTION			TonbowEntityClass@ObjectData@UpEnd - TonbowEntityClass@ObjectData@GlideUp
	.DEF	TONBOW_OBJ_DATA_SIZE_ACTION				TonbowEntityClass@ObjectData@FlapUp - TonbowEntityClass@ObjectData@GlideUp

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

	;Damage Hitbox
	.DEF	TONBOW_DMG_HITBOX_WIDTH					$07
	.DEF	TONBOW_DMG_HITBOX_HEIGHT				$06
	.DEF	TONBOW_DMG_HITBOX_VERT_OFFSET			$05
	.DEF	TONBOW_DMG_HITBOX_HORI_OFFSET			$05

	;Attack Hitbox
	.DEF 	HITBOX_POS_MASK							%00000001
	.DEF	TONBOW_ATK_HITBOX_VERT_WIDTH			$10		
	.DEF	TONBOW_ATK_HITBOX_VERT_HEIGHT			$08	
	.DEF	TONBOW_ATK_HITBOX_HORI_WIDTH			$08		
	.DEF	TONBOW_ATK_HITBOX_HORI_HEIGHT			$10	
	.DEF	TONBOW_ATK_HITBOX_DIAG_WIDTH			$0B		
	.DEF	TONBOW_ATK_HITBOX_DIAG_HEIGHT			$0B	
	

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

;Check
	.DEF TONBOW_DASHING							$FE
	.DEF TONBOW_DONE							$00
	

;==============================================================
; Animations, hitboxes etc.
;==============================================================
.INCLUDE "..\\TonbowEntity\\animations.asm"
.INCLUDE "..\\TonbowEntity\\positions.asm"

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
	ld a, (hl)
	cp DMG_HITBOX_COLLISION
	;jp z, EntityListClass@DeactivateEntity


;Check if we are dead
		inc hl								;HL = entity.state
		ld a, (hl)
		and TONBOW_DEAD
		cp TONBOW_DEAD
		;jr z, @DeadTonbow

;Check if we are dashing
	call @CheckDash						
	
;Adjust animation
	call @AdjustFrame

;Check the buttons
	push hl									;Save entity.ID
		call @CheckButtons
	pop hl									;HL = entity.eventID

;Check the DPad
	push hl									;Save entity.ID
		call @CheckDirectionalInput
	pop hl									;HL = entity.eventID
	
;Update Animation based off of state
	@@UpdateAnimation:							;Label used for skipping checks during dash
		call @UpdateEntityAnimation

;Update Positions of Tonbow and Hitboxes
	push hl								;Save entity.eventID
		call @UpdatePositions
	pop hl								;HL = entity.eventID

;Add Entity to the OAM Buffer
	call GeneralEntityEvents@OAMHandler

	ret

.INCLUDE "..\\TonbowEntity\\inputHandler.asm"

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
		ld de, TonbowEntityClass@UpdateTonbow
		;Set ObjectDataPointer
		ld bc, TonbowEntityClass@ObjectData
		call GeneralEntityEvents@InitializeEntity
		;Returns us with HL = tonbow.atkHitbox
		ld (hl), $00
		inc hl							;HL = tonbow.atkHitBox.width
		ld (hl), TONBOW_ATK_HITBOX_VERT_WIDTH
		inc hl							;HL = tonbow.atkHitbox.height
		ld (hl), TONBOW_ATK_HITBOX_VERT_HEIGHT
	pop hl
	push hl
	;Set up xPos, yPos, and atkHitbox
		call GeneralEntityEvents@UpdatePosition	
		ld (hl), $00							;tonbow.dmgHitbox.columnsBitmap = $00
		;HL = dmgHitbox
		call TonbowEntityClass@UpdateHitboxes
	/*	
		dec hl									;HL = tonbow.xPos
		ld b, (hl)
		ld de, tonbowStructure.yPos - tonbowStructure.xPos
		add hl, de								;HL = tonbow.yPos
		ld a, (hl)
		ld de, tonbowStructure.atkHitbox.y1 - tonbowStructure.yPos
		add hl, de								;HL = tonbow.atkHitbox.y1
		sub a, OBJ_YPOS_OFFSET						;Adjust for offset
		ld (hli), a								;HL = tonbow.atkHitbox.x1
		ld a, b
		sub a, OBJ_XPOS_OFFSET
		ld (hl), a
	;Set up Columns
		ld de, hitboxStructure.columnsBitmap - hitboxStructure.x1
		add hl, de								;HL = atkHitbox
	*/
		ld d, DMG_HITBOX
		call ColumnClass@UpdateEntityCurrentColumns
		ld de, tonbowStructure.atkHitbox - tonbowStructure.dmgHitbox
		add hl, de						;HL = tonbow.dmgHitbox
		ld d, ATK_HITBOX
		call ColumnClass@UpdateEntityCurrentColumns
		
		
	pop hl
;Initialize Tonbow Specific properties
	;HL = tonbow.eventID
	ld de, tonbowStructure.timer - tonbowStructure.eventID
	add hl, de							;HL = tonbow.timer
	ld a, TONBOW_TIMER_INIT_VALUE
	ld (hli), a							;HL = tonbow.entityUpdatePointer											

	ret

.INCLUDE "..\\TonbowEntity\\objectData.asm"

TonbowEntityClassEnd:



.ENDS