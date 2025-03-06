.SECTION "Player Class" SEMIFREE
PlayerOneClass:
;================================================================================
; All subroutines and data related to the Player Entity Class
;================================================================================

;==============================================================
; Constants
;==============================================================
	.DEF 	PLAYER_ONE_ARCADE_START_Y				$0400						; 48 + 16 = 64.0 = $40.0 Y Position has a 16 pixel offset down
	.DEF	PLAYER_ONE_ARCADE_START_X				$0080						;  0 +  8 =  8.0 = $08.0 X Position has an 8 pixel offset right
/*
;Other potential Entity States
	.DEF	IDLE				%00000000
	.DEF	A_BUTTON			%00000001
	.DEF	B_BUTTON			%00000010
	.DEF	SEL_BUTTON			%00000100
	.DEF	STR_BUTTON			%00001000
	.DEF	DPAD_RIGHT			%00010000
	.DEF	DPAD_LEFT			%00100000
	.DEF	DPAD_UP				%01000000
	.DEF	DPAD_DOWN			%10000000
	.DEF	A_AND_B_BUTTON		%00000011
	.DEF	DEAD				$FF
	.DEF	DYING				$FE
	.DEF	SPAWNING			$FD
;State Constants
	.DEF	LRUD_MASK			%11110000
	.DEF	BUTTON_MASK			%00001111
	.DEF	LRUD_MAX			$0A
*/

;==============================================================
; Updates the Player's Input
;==============================================================
;
;Parameters: DE = entity.state
;Returns: None
;Affects: DE
	@Update:
	;Poll for controller input to update State
		ld a, IDLE
		ld (de), a
		call UpdateKeys
		ld a, (currentKeyPress1)
		ld (de), a

	;Send new State to the assigned Entity
		push de									;Save entity.state
		pop hl									;ld hl, entity.state
		ld bc, playerEntityStructure.eventID - playerEntityStructure.state
		add hl, bc								;ld hl, entity.eventID
		push hl									;SP = player.eventID
			ld bc, playerEntityStructure.entityUpdatePointer - playerEntityStructure.eventID
			add hl, bc								;HL = playerStructure.entityUpdatePointer
			push hl
			pop bc									;BC = playerStructure.entityUpdatePointer
			ld a, (bc)
			ld l, a
			inc bc
			ld a, (bc)
			ld h, a
			jp hl									;Jump to Entity's Update subroutine

	;Shouldn't reach this point in code
		;end
	ret


;==============================================================
; Initializes Player One
;==============================================================
;
;Parameters:  BC = Entity@InitializeExistingEntity, initYPos = yFracPos, initXPos = xFracPos
;Returns: None
;Affects: A, BC, DE, HL
	@InitializeEntity:
	;Activate an Entity in the Entity List
		ld a, HIGH_PRIORITY
		push bc
		call EntityList@ActivateEntity
		pop bc
		;ld hl, playerOne.eventID
		ld a, (hl)
		cp ACTIVATE_SUCCESS
		ret nz								;If the entity didn't get added, then we shouldn't initialize it
	;Parameters: HL = entity.eventID, BC = Entity@InitializeExistingEntity,
			   ; initYPos = yFracPos, initXPos = xFracPos
	@InitializeExistingPlayer:
	;Call Entity@InitializeExistingEntity
		ld de, +
		push de								;Set our JP HL to be a CALL HL
		push hl								;Put player.eventID on top of SP
		push bc
		pop hl								;HL = Entity@InitializeExistingEntity
		jp hl								;Call Entity@InitializeExistingEntity
	+:
	;Set up our Player's Update Pointer
		;HL = player.eventID
		ld bc, playerEntityStructure.playerUpdatePointer - playerEntityStructure.eventID
		add hl, bc							;ld hl, player.playerUpdatePointer
		ld bc, PlayerOneClass@Update
		ld a, c
		ld (hli), a
		ld a, b
		ld (hli), a	
		;end
	ret

.ENDS