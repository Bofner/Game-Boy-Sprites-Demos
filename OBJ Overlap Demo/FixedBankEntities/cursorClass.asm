.SECTION "Cursor Class "
CursorClass:
;================================================================================
; All subroutines and data related to the Cursor Entity Class
;================================================================================

;==============================================================
; Constants
;==============================================================
	.DEF 	CURSOR_VRAM_INDEX 					$00
	.DEF 	CURSOR_TITLE_START_Y				$05E0 + $0100		;94 = $60.0 + yPos Offset
	.DEF	CURSOR_TITLE_START_X				$0280 + $0080		;40 = $28.0 + xPos Offset
	.DEF	CURSOR_TITLE_NUM_POSITIONS			$02					;numPositions = 3, where we start from 0
	.DEF	CURSOR_TITLE_POSITION_DISTANCE		$10					;positionDistance = $10
	.DEF	CURSOR_MOVE_UP				DPAD_UP
	.DEF	CURSOR_MOVE_DOWN			DPAD_DOWN
	.DEF	CURSOR_DELAY				$0A
	.DEF	CURSOR_ANIMATION_TIME		$0C
	.DEF	CURSOR_X_Y_POS_OFFSET		$00
	.DEF	CURSOR_0_VRAM_INDEX			$00
	.DEF	CURSOR_1_VRAM_INDEX			$01
	.DEF	CURSOR_0_VRAM				$8000
	.DEF	CURSOR_1_VRAM				$8010


;==============================================================
; Updates the Entity
;==============================================================
;
;Parameters: DE = entity.state
;Returns: None
;Affects: DE
	@UpdateAI:
	;Grab Event ID and State
		push de									;Save entity.state
		pop hl									;ld hl, entity.state
		ld bc, entityStructure.eventID - entityStructure.state
		add hl, bc								;ld hl, entity.eventID
	;AI logic goes here

		jr +					;This is done automatically due to code structure

;==============================================================
; Updates the Entity based off of entity.state
;==============================================================
;
;Parameters: DE = entity.state, HL = entity.eventID
;Returns: None
;Affects: TBD
	@UpdateFromState:
		pop hl						;HL = entity.eventID
	+:
	;Check if our timer is counting down
		ld bc, cursorStructure.timer - cursorStructure.eventID
		add hl, bc								;ld hl, cursor.timer
		ld a, (hl)
		ld bc, cursorStructure.eventID - cursorStructure.timer
		add hl, bc								;ld hl, cursor.eventID
		cp $00
		jr z, +
		jp @UpdateRestOfEntity 						;Don't move up if our timer isn't at 0
	+:
	;Check State for Actions
		;ld de, entity.state
		ld a, (de)
		ld bc, @UpdateRestOfEntity
	;Use our JP as a call, but make it so we skip the rest of the checks if we hit one
		push bc
		cp DPAD_UP
		jp z, @MoveUp
		cp DPAD_DOWN
		jp z, @MoveDown
		pop bc

;Parameters: DE = entity.state, HL = entity.eventID
	@UpdateRestOfEntity:
	/*
	;Cursor doesn't need smooth movement, so we can skip this, as it just gets updated in @MoveUp and @MoveDown
		ld a, UPDATE_POSITION
		ld (hl), a
		push hl
		call EntityEventHandler
		pop hl									;ld hl, entity.eventID
	*/
	;Update the animation frame
		ld bc, cursorStructure.animationTimer - cursorStructure.eventID
		add hl, bc								;ld hl, cursor.animationTimer
	;Check if we need to change frames
		xor a
		cp (hl)
		jr nz, +
	;Reset timer
		ld (hl), CURSOR_ANIMATION_TIME
	+:
	;Check if we are halfway done yet
		ld a, CURSOR_ANIMATION_TIME
		srl a
		cp (hl)
		jr c, +
	;Decrement the timer
		dec (hl)
		ld bc, cursorStructure.objectDataPointer - cursorStructure.animationTimer
		add hl, bc								;ld hl, entity.objectDataPointer
	;Change to frame 0
		ld bc, @ObjectData@AnimationFrame0
		ld (hl), c
		inc hl
		ld (hl), b
		jr ++
	+:
	;Decrement the timer
		dec (hl)
		ld bc, cursorStructure.objectDataPointer - cursorStructure.animationTimer
		add hl, bc								;ld hl, entity.objectDataPointer
	;Change to frame 1
		ld bc, @ObjectData@AnimationFrame1
		ld (hl), c
		inc hl
		ld (hl), b
	++:
		ld bc, cursorStructure.eventID - (cursorStructure.objectDataPointer + 1)
		add hl, bc								;ld hl, cursorStructure.eventID

	;Add some conditional statement
		;call EntityList@DeactivateEntity

	;Add Entity to the OAM Buffer
		ld a, UPDATE_OAM_BUFFER
		ld (hl), a
		push hl
		call EntityEventHandler
		pop hl

		ld bc, cursorStructure.timer - cursorStructure.eventID
		add hl, bc								;ld hl, cursor.timer
		xor a
		cp (hl)
		ret z									;If it's 0, then no worries
	;Decrease timer if bigger than zero
		dec (hl)

		;end
	ret


;==============================================================
; Moves Cursor Up
;==============================================================
;
;Parameters: DE = entity.state, HL = entity.eventID
;Returns: None
;Affects: A, BC
	@MoveUp:
	;Check if we can actually move up
		;ld hl, entity.eventID
		ld bc, cursorStructure.currentPosition - cursorStructure.eventID
		add hl, bc								;ld hl, cursor.currentPosition
		ld a, (hli)								;ld hl, cursor.positionDistance
		cp $00
		jr nz, +
			ld bc, cursorStructure.eventID - cursorStructure.positionDistance
			add hl, bc								;ld hl, cursor.eventID
		ret 									;Don't move up if we are at the top
	;We can move up, so let's do it
	+:
	;Grab the distance we need to move our cursor
		ld a, (hld)								;ld hl, cursor.currentPosition
		dec (hl)								;Update cursor position by one
	;Update yPos
		ld bc, cursorStructure.yPos - cursorStructure.currentPosition
		add hl, bc								;ld hl, cursor.yPos
	;Do a 2's compliment to get a subtraction
		cpl
		inc a
	;Do the subtraction
		add a, (hl)
		ld (hl), a								;yPos updated
	;Set the timer for when we can move again
		ld bc, cursorStructure.timer - cursorStructure.yPos
		add hl, bc								;ld hl, cursor.timer
		ld (hl), CURSOR_DELAY
	;Return HL to its original state
		ld bc, cursorStructure.eventID - cursorStructure.timer
		add hl, bc								;ld hl, cursor.eventID
	
		ret

;==============================================================
; Moves Cursor Down
;==============================================================
;
;Parameters: DE = entity.state
;Returns: None
;Affects: A, BC
	@MoveDown:
	;Check if we can actually move down
		;ld hl, entity.eventID
		ld bc, cursorStructure.numPositions - cursorStructure.eventID
		add hl, bc								;ld hl, cursor.numPositions
		ld a, (hli)								;ld hl, cursor.currentPosition, A = numPosition
		dec a									;Can only do a >= check
		cp (hl)
		jr nc, +
			ld bc, cursorStructure.eventID - cursorStructure.currentPosition
			add hl, bc								;ld hl, cursor.eventID
		ret 									;Don't move up if we are at the top
	;We can move down, so let's do it
	+:
	;Grab the distance we need to move our cursor
		inc hl									;ld hl, cursor.positionDistance
		ld a, (hld)								;ld hl, cursor.currentPosition
		inc (hl)								;Update cursor position by one
	;Update yPos
		ld bc, cursorStructure.yPos - cursorStructure.currentPosition
		add hl, bc								;ld hl, cursor.yPos
	;Do the addition
		add a, (hl)
		ld (hl), a								;yPos updated
	;Set the timer for when we can move again
		ld bc, cursorStructure.timer - cursorStructure.yPos
		add hl, bc								;ld hl, cursor.timer
		ld (hl), CURSOR_DELAY
	;Return HL to its original state
		ld bc, cursorStructure.eventID - cursorStructure.timer
		add hl, bc								;ld hl, cursor.eventID
	
		ret
	


;==============================================================
; Initializes the Entity
;==============================================================
;
;Parameters:  init8BitVar0 = numPositions, init8BitVar1 = positionDistance, initYPos = yFracPos, initXPos = xFracPos
;Returns: None
;Affects: A, HL
	@Initialize:
	;Activate an Entity in the Entity List
		ld a, LOW_PRIORITY
		call EntityList@ActivateEntity
		;ld hl, sfsShimmerEntity.eventID
		ld a, (hl)
		cp ACTIVATE_SUCCESS
		ret nz								;If the entity didn't get added, then we shouldn't initialize it
		jr +								;Don't need to pull the entity.eventID
;Parameters: SP = entity.eventID, initYPos = yFracPos, initXPos = xFracPos
	@InitializeExistingEntity:
		pop hl								;HL = entity.eventID
	+:
	;Save entity.eventID for later, and save our Cursor position data
		push hl
	;Initialize our Entity					
		ld a, NO_EVENT
		ld (hli), a				
		;Also ld hl, entity.entityClassBank			
		ld a, FIXED_ROM_BANK	
		ld (hli), a			
		;Also ld hl, entity.entityUpdatePointer	
		;The location WORD of it's event handler
			ld de, CursorClass@UpdateAI
			ld a, e
			ld (hli), a
			ld a, d
			ld (hli), a							
		;Also ld hl, entity.state
		ld a, IDLE
		ld (hli), a		
		;Also ld hl, entity.timer
		xor a
		ld (hli), a			
		;Also ld hl, entity.objectDataPointer
			ld de, @ObjectData
			ld a, e
			ld (hli), a
			ld a, d
			ld (hli), a				
		;Also ld hl, entity.entityType
		ld a, PROJECTILE
		ld (hli), a							
		;Also ld hl, entity.currentColumn
		ld a, NOT_IN_COLUMN	
		ld (hli), a												
		;Also ld hl, entity.pageNum
		;xor a
		ld (hli), a							
		;Also ld hl, entity.yVel
		;xor a
		ld (hli), a			
		;Also ld hl, entity.yFracPos
		ld a, (initYPosVar+1)
		ld (hli), a		
		ld a, (initYPosVar)	
		ld (hli), a		
		;Also ld hl, entity.yPos
		xor a
		ld (hli), a		
		;Also ld hl, entity.xVel
		ld (hli), a			
		;Also ld hl, entity.xFracPos
		ld a, (initXPosVar+1)
		ld (hli), a		
		ld a, (initXPosVar)
		ld (hli), a				
		;Also ld hl, entity.xPos
		xor a
		ld (hli), a							
		;Also ld hl, entity.hurtbox.mass
		;xor a
		ld (hli), a							
		;Also ld hl, entity.hurtbox.width
		ld de, cursorStructure.numPositions - cursorStructure.hurtbox.width
		add hl, de							;HL = cursorStructure.numPositions
		ld a, (init8BitVar0)
		ld (hli), a
		;Also ld hl, tonbowCursor.currentPosition
		xor a
		ld (hli), a
		;Also ld hl, tonbowCursor.positionDistance
		ld a, (init8BitVar1)
		ld (hli), a
		;Also ld hl, tonbowCursor.animationTimer
		ld (hl), CURSOR_ANIMATION_TIME
		pop hl								;HL = entity.eventID
		ld a, UPDATE_POSITION
		ld (hl), a
		push hl
		call EntityEventHandler
		pop hl									;ld hl, entity.eventID

		ret


;==============================================================
; Tonbow Cursor's Object Data
;==============================================================
;Cursor has 2 states, but it's only one object in size
	@ObjectData:
	;First Flap Frame
		@@AnimationFrame0:
		;How many objects we need to write for this Entity
			.DB		$01
		;How much to adjust this Object's yPos by
			.DB		CURSOR_X_Y_POS_OFFSET
		;How much to adjust this Object's xPos by
			.DB		CURSOR_X_Y_POS_OFFSET
		;Tile ID
			.DB 	CURSOR_0_VRAM_INDEX
		;Object attribute flags
			.DB 	OAMF_PAL0
		;One 8x16 Object, so finished
	;Second Flap Frame
		@@AnimationFrame1:
		;How many objects we need to write for this Entity
			.DB		$01
		;How much to adjust this Object's yPos by
			.DB		CURSOR_X_Y_POS_OFFSET
		;How much to adjust this Object's xPos by
			.DB		CURSOR_X_Y_POS_OFFSET
		;Tile ID
			.DB 	CURSOR_1_VRAM_INDEX
		;Object attribute flags
			.DB 	OAMF_PAL0
		;One 8x16 Object, so finished4
	@ObjectDataEnd:


.ENDS