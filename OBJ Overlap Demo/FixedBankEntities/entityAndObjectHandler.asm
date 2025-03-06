.RAMSECTION "Entity and Object Handler RAM" BANK 0 SLOT 3 ORGA $C000 RETURNORG FORCE
;Entity related structures
	OAMBuffer						dsb $100
	objectCount     				db      	;How many objects are on screen on current frame (Reset at the beginning of each frame)
	currentYPos						db			;Variable to store the current entity's yPos during OAMBuffer writing
	currentXpos						db			;Variable to store the current entity's xPos during OAMBuffer writing
	initYPosVar						dw			;Variable used to hold an initialization Y-Pos ($UNUSED,WHOLEMSB $WHOLELSB,FRAC)
	initXPosVar						dw			;Variable used to hold an initialization X-Pos ($UNUSED,WHOLEMSB $WHOLELSB,FRAC)
	init8BitVar0					db			;Variable used to hold an 8-bit value used in initialization
	init8BitVar1					db			;Variable used to hold an 8-bit value used in initialization
	init16BitVar					dw			;Variable used to hold a 16-bit value used in initialization
	entityList 			INSTANCEOF 	entityListStructure		
	column 	   			INSTANCEOF 	columnStructure 5	
.ENDS

.SECTION "Entity and Object Handler"
;================================================================================
; Executes subroutines for Entities, or redirects to speficic Entity Handler
;================================================================================
;Object Constants
	.DEF	OBJECT_COUNT_MAX	40	
;DMA Constants
	.DEF	HRAM				$FF80
;Entity Constants
	.DEF	ENTITY_COUNT_MAX	OBJECT_COUNT_MAX
	.DEF	HIGH_PRIORITY		$01
	.DEF	LOW_PRIORITY		$00
;Entity Types
	.DEF	PLAYER				$00
	.DEF	NPC					$01
	.DEF	ENEMY				$02
	.DEF	PROJECTILE			$03
;Entity IDs
	.DEF	SFS_SHIMMER			$00		

;General Entity Event IDs
	.DEF	INACTIVE_ENTITY		$EF
	.DEF	ACTIVATE_SUCCESS	$EF
	.DEF	ACTIVATE_FAILURE	$00
	.DEF	NO_EVENT			$00
	.DEF	UPDATE_POSITION		$01
	.DEF	UPDATE_OAM_BUFFER	$02
	.DEF	MAX_EVENT_VALUE		$03

;Non-unique Special Entity Event IDs
	.DEF	INIT_ENTITY			%10000000
	.DEF	UPDATE_ENTITY		%10000001
	.DEF	UPDATE_FROM_STATE	%10000010

;Potential Entity States  for using with BIT N, R8
	.DEF	BIT_DOWN			$07
	.DEF	BIT_UP				$06
	.DEF	BIT_LEFT			$05
	.DEF	BIT_RIGHT			$04
	.DEF	BIT_STR				$03
	.DEF	BIT_SEL 			$02
	.DEF	BIT_B				$01
	.DEF	BIT_A   			$00
	
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
	
	

;==============================================================
; Handles Entity Events using the entityID 
;==============================================================
;
;Parameters: HL = entity.eventID
;Returns: None
;Affects: A, BC, DE, HL
EntityEventHandler:
;Determine if this is a General Entity Event (GEE) or a Specific Entity Event (SEE)
;GEE will have BIT 7 RES, but SEE will have BIT 7 SET
	ld a, (hl)							
	bit 7, a
	jp z, @GeneralEntityEventHandler
;If SEE, then find out which ROM bank the Entity Class resides in, and jump to its Update Subroutine using a JP HL
	push hl
	pop de								;ld de, entity.entityEventID
	inc hl								;ld hl, entity.entityClassBank
;We may need to change banks if the Entity isn't in the fixed bank
	ld a, (hl)
	ld (backUpROMBank), a				;Save the ROM bank
	xor a
	cp (hl)
	jr z, +
	ld a, (currentLevelROMBank)
	cp (hl)
	call nz, SwitchROMBank
+:
	inc de								;ld de, entity.entityClassBank
	inc de								;ld de, entity.entityEventHandlerPointer
	ld a, (de)
	ld l, a
	inc de
	ld a, (de)
	ld h, a								;ld hl, EntityClass@EventHandler
	inc de								;ld de, entity.state
	ld bc, @ReturnFromEntityRoutine
	push bc								;Make our JP HL function as a CALL HL
	jp hl
	@ReturnFromEntityRoutine:
	;Make sure we are on the correct ROM Bank when we return to the level code
		xor a
		ld hl, backUpROMBank
		cp (hl)
		jr z, +								;If it is in the Fixed Bank, then no problems
		ld a, (currentLevelROMBank)
		cp (hl)
		call nz, SwitchROMBank
	+:
		;end
	ret									


;Handles any Events that are dealt in the same way no matter the Entity ID
	;Parameters: HL = ld hl, entity.eventID
	@GeneralEntityEventHandler:
	;Check if we have an out of bounds event
		ld a, (hl)
		cp MAX_EVENT_VALUE
		ret nc
	;Use a jump table to jump to the specific event
		push hl							;Save entity.eventID
	;3 * N + GeneralEntityEventJumpTable
		ld c, a
		add c
		add c                           ;3 * N 
		ld h, 0
		ld l, a
		ld de, GeneralEntityEventJumpTable 
		add hl, de                      ;3 * N + DPadJumpTable
		jp hl                           ;Jump to specific input subroutine
	;This RET is just for safety, as each possible jump has its own RET
		;end
	ret

	;Convert the xFracPos and yFracPos into xPos and yPos
		;Parameters: SP = entity.eventID
		@@UpdatePosition:
			pop hl							;Recover entity.eventID
		;Use velocity to update the yPosition
			ld de, entityStructure.yVel - entityStructure.eventID
			add hl, de						;ld hl, entity.yVel
			ld a, (hli)						;ld hl, yFracPos
			add a, (hl)
		;Check if we need to carry into the MSB
			call c, @@@HandleCarry
			ld (hl), a
			call @@@ConvertNFracPosToNPos
		;Use velocity to update the xPosition
			;ld hl, entity.xVel
			ld a, (hli)						;ld hl, xFracPos
			add a, (hl)
		;Check if we need to carry into the MSB
			call c, @@@HandleCarry
			ld (hl), a
			call @@@ConvertNFracPosToNPos
			;end
		;end
	ret

			;Parameters: A = (entity.nVel), HL = entity.nFracPos
			@@@HandleCarry:
			;Find out if it was a negative or positive carry
				cp $80
				jr nc, @@@@NegativeCarry
				@@@@PositiveCarry:
				;Carry was positive, so add value to the MSB
					inc hl						;ld hl, entity.nFracPos.MSB
				;Carry into MSB without affecting the UNUSED bits
					ld a, (hl)
					inc a
					and $0F
					ld (hld), a					;ld hl, entity.nFracPos.LSB						
					;end	
				ret
				@@@@NegativeCarry:
				;Carry was negative, so subtract value from the MSB
					inc hl						;ld hl, entity.nFracPos.MSB
				;Carry into MSB without affecting the UNUSED bits
					ld a, (hl)
					dec a
					ld (hld), a					;ld hl, entity.nFracPos.LSB
					;end	
				ret


			;Parameters: HL = entity.nFracPos
			@@@ConvertNFracPosToNPos:
			;Converts the fractional WORD into a whole BYTE
				ld a, (hli)						;A = $LSB,FRAC
				and $F0							;A = $LSB,0
				ld b, a							;B = $LSB,0
				ld a, (hli)						;A = $0,MSB
				;ld hl, entity.nPos
				or b							;A = $LSB,MSB
				swap a							;A = $MSB,LSB
				ld (hli), a						;ld hl, entity.xVel/mass

				ret


	;Update the OAMBuffer
		;Parameters: SP = entity.eventID
		@@UpdateOAMBuffer:
			pop hl								;ld hl, entity.eventID
		;Set DE = (entity.objectDataPointer)
			ld de, entityStructure.objectDataPointer - entityStructure.eventID
			add hl, de							;ld hl, entity.objectDataPointer
			ld a, (hli)
			ld e, a
			ld a, (hl)
			ld d, a								;ld de, (entity.objectDataPointer)
			ld a, (de)
		;Store the yPos of our Entity for future use
			ld bc, entityStructure.yPos - (entityStructure.objectDataPointer + 1)
			add hl, bc
			ld a, (hli)							;ld hl, entity.xVel
			ld (currentYPos), a
			inc hl								;ld hl, entity.xFracPos
			inc hl								;WORD
			inc hl								;ld hl, entity.xPos
			ld a, (hl)
			ld (currentXpos), a
		;Check if we have the space to add an Entity with this many objects
			ld a, (de)							;A = # of OBJs that make up the Entity
			ld b, a								;B = # of OBJs that make up the Entity
			ld a, (objectCount)					;A = # OBJs on screen
			cp OBJECT_COUNT_MAX
			ret nc
		;If we got here, then we have enough space. We just need to get to the proper space in OAMBuffer
			sla a								;A x 2
			sla a								;A x 4 (since each entry in OAMBuffer is 4 bytes)
			ld b, $00
			ld c, a
			ld hl, OAMBuffer
			add hl, bc							;ld hl, OAMBuffer.object.yPos
		;We are at the next available spot in the OAMBuffer
			push de
			push hl
			pop de
			pop hl								;SWAP HL and DE
		;So now HL = Entity@ObjectData (Number of OBJs) and DE = OAMBuffer.object.yPos
			ld a, (hli)							;A = # of OBJs that make up the Entity	
			ld b, a								;B = # of OBJs that make up the Entity						
		;B will be used as our loop counter
		-:
		;Add yPos offset to the yPos
			;ld hl, OAMBuffer.object.yPos
			;ld de, objectData.yPosOffset
			ld a, (currentYPos)
			add a, (hl)		
			ld (de), a
			inc de								;ld de, OAMBuffer.object.xPos
			inc hl								;ld hl, objectData.xPosOffset
		;Add yPos offset to the yPos
			ld a, (currentXpos)
			add a, (hl)		
			ld (de), a
			inc de								;ld de, OAMBuffer.object.tileID
			inc hl								;ld hl, objectData.tileID
		;Write the tile ID
			ld a, (hli)							;ld hl, objectData.attributeFlags
			ld (de), a
			inc de								;ld de, OAMBuffer.object.attributeFlags
		;Write the attribute flags
			ld a, (hli)							;ld hl, objectDataNEXT.yPosOffset
			ld (de), a
			inc de								;ld de, OAMBuffer.objectNEXT.yPos
		;Update objectCount
			ld a, (objectCount)
			inc a
			ld (objectCount), a
		;Check if we have more OBJs to write to OAMBuffer
			dec b
			jr nz, -

			;end
		;end
	ret


GeneralEntityEventJumpTable:
;Each event has a number, and the Jump Table's entries correspond to the event numbers
;If there is no event
    ret                         ;JP is 3 bytes...
    nop                         ;...RET is only 1...
    nop                         ;...So 2 NOPs are added for cushion
;For the event UPDATE_POSITION
	jp EntityEventHandler@GeneralEntityEventHandler@UpdatePosition
;For the event UPDATE_OAM_BUFFER
	jp EntityEventHandler@GeneralEntityEventHandler@UpdateOAMBuffer

;Extra protection ret
	ret

.ENDS

;========================================================================================

.SECTION "DMA Transfer"
DMAToHRAM:
	ld hl, DMATransferRoutine
	ld b, DMATransferRoutineEnd-DMATransferRoutine
	ld c, lobyte(RunDMATransfer)
	call WriteToHRAM

	ret

;Parameters: A = HIGH BYTE of source address
DMATransferRoutine:
    ld (rDMA), a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 M-cycles
-:
	dec a           ; 1 M-cycle
	jr nz, -    ; 3 M-cycles
    ret
DMATransferRoutineEnd:

.ENDS

;==============================================================
; Fixed Bank Entity Classes
;==============================================================
.INCLUDE "..\\FixedBankEntities\\entityListClass.asm"
.INCLUDE "..\\FixedBankEntities\\shimmerClass.asm"
;.INCLUDE "..\\FixedBankEntities\\playerOneClass.asm"
.INCLUDE "..\\FixedBankEntities\\cursorClass.asm"