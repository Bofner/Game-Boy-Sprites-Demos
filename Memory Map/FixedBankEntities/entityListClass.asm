
.RAMSECTION "Entity Classes and Entity List Class Data" BANK 0 SLOT 3 ORGA $C000 RETURNORG FORCE
;Entity and Entity List related data and structures, starting fromt he beginning of WRAM
	OAMBuffer						dsb $100	;A buffer for the OAM
	objectCount     				db      	;How many objects are on screen on current frame (Reset at the beginning of each frame)
	initYPosVar						dw			;Variable used to hold an initialization Y-Pos ($UNUSED,WHOLEMSB $WHOLELSB,FRAC)
	initXPosVar						dw			;Variable used to hold an initialization X-Pos ($UNUSED,WHOLEMSB $WHOLELSB,FRAC)
	init8BitVar0					db			;Variable used to hold an 8-bit value used in initialization
	init8BitVar1					db			;Variable used to hold an 8-bit value used in initialization
	init16BitVar					dw			;Variable used to hold a 16-bit value used in initialization
	entityList 			INSTANCEOF 	entityListStructure		;The list itself
.ENDS

.SECTION "Entity List Class"
;================================================================================
; All subroutines and data related to the Entity List Class
;================================================================================
;Entity List related constants
	.DEF	NOT_IN_LIST						$FF
	.DEF	ENTITY_LIST_MAX_SIZE			40
	.DEF	BIT_COUNTER						8
	.DEF 	FIRST_ENTITY					entityList.entity.0.eventID
	.DEF	ACTIVE_ENTITY_SEARCH_MASK		%00000001
	.DEF	ACTIVE_ENTITY_BYTE_MASK			%00110000
	.DEF	ACTIVE_ENTITY_BIT_MASK			%00000111
	.DEF	ACTIVE_ENTITY_SET_MASK			%00000001
	.DEF	ACTIVE_ENTITY_RES_MASK			%00000001			;Must be CPL'd
	.DEF	ACTIVE_ENTITY_INC_BYTE			%00010000
	.DEF	BITMAP_FULL						$FF
	.DEF	ENTITY_BITMAP_START				$00
	.DEF	ENTITY_BITMAP_START_INDEX		$00
	.DEF	LAST_BITMAP						$04

;Entity Event IDs
	.DEF	INACTIVE_ENTITY			$EF
	.DEF	ACTIVATE_SUCCESS		$EF
	.DEF	ACTIVATE_FAILURE		$00
	.DEF	NO_EVENT				$00
	.DEF	ATK_HITBOX_COLLISION	$01
	.DEF	DMG_HITBOX_COLLISION	$02

;Potential Entity States
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

;Entity related constants
	

EntityListClass:

;==============================================================
; Adds an Entity to the Entity List
;==============================================================
;
;Parameters: None
;Returns: HL = eventID, temp8BitA = Player Number (0 -> NOT Player)
;Affects: A, BC, DE, HL, aux8BitVar
@ActivateEntity:
		ld hl, entityList.numEntities
		ld a, (hl)
		ld hl, entityList.activationFailure
		cp ENTITY_LIST_MAX_SIZE
		ret nc										;Don't add it if we have too many Entities
	;If we are good, bump that counter up
		ld hl, entityList.numEntities
		inc a
		ld (hli), a									;Also ld hl, entity.0.eventID
		dec a										;But we still need to actually add the Entity
		ld hl, FIRST_ENTITY
		ld de, entityList.bitmap.0
		ld c, ENTITY_BITMAP_START					;C will act like our currentBitmapLocation ($BYTE,$BIT --> $0-3,0-7)
													;In this case, we are starting at BYTE $00, BIT %0
		ld hl, aux8BitVar							;Use as a counter
		ld (hl), ENTITY_BITMAP_START				;Start at $00
	
	@@ActivateFirstInactiveEntity:
		ld b, ACTIVE_ENTITY_SEARCH_MASK
		ld a, (de)
		cp BITMAP_FULL
		jr z, @@@SetupNextBitmap
	;Start our search
		jr @@@CheckForInactiveEntity
		@@@SetupNextBitmap:
		;If we didn't find one here, check the next 8 Entities in the list
			ld b, ACTIVE_ENTITY_SEARCH_MASK
			ld a, c						;\
			and ACTIVE_ENTITY_BYTE_MASK	; } Increase the BYTE position and
			add ACTIVE_ENTITY_INC_BYTE	; } reset the BIT position
			ld c, a						;/
			inc de
			ld a, ($FF00 + lobyte(aux8BitVar))
			add a, 8
			ld ($FF00 + lobyte(aux8BitVar)), a		;Update Entity Counter
		@@@CheckForInactiveEntity:
		;Search through the list for the first inactive Entity
			ld a, (de)					;A = (bitmap.n)
			and b
			jr z, @@ActivateInActiveEntityList
		;We did not find an Inactive Entity, so check if we need to move to the next byte
			sla b
			inc (hl)									;increase our counter
			inc c										;Increase BIT position
			;xor a
			;or c										;Check if we are at the end of our list
			;jr z, @@@SetupNextBitmap		
			jr @@@CheckForInactiveEntity	

;We shouldn't get to this part of the code
	ret

	@@ActivateInActiveEntityList:
	;Activate our Entity in the Entity List and Active Entity List
	;Start by getting to the correct BYTE in the bitmap
		ld a, c
		and ACTIVE_ENTITY_BYTE_MASK				;Only going from 0-3
		swap a									;BYTE counter now in LSNibble							
		ld d, 0
		ld e, a
		ld hl, entityList.bitmap.0
		add hl, de								;ld hl, bitmap.inactiveEntityByte
	;Now get to the corret BIT in the bitmap
		ld a, c
		and ACTIVE_ENTITY_BIT_MASK				;A = The BIT we want to SET
		ld b, a									;B becomes our counter
		ld c, ACTIVE_ENTITY_SET_MASK			;C is our mask which we will use to SET
		xor a
		cp b									;Check if we are to SET BIT 0
		jr z, +
	-:
		sla c									;Move ahead one BIT
		dec b
		jr nz, -
	+:
		ld a, (hl)								;Grab our bitmap
		or c
		ld (hl), a								;Bit has been activated
	@@ActivateInEntityList:
	;Get to the correct location in the Entity List
		ld de, entityList.entity.0.eventID
		ld a, ($FF00 + lobyte(aux8BitVar))						;ld a, Entity List Position Counter
		ld h, $00
		ld l, a									;ld de, Counter value
		add hl, hl								;x2
		add hl, hl								;x4
		add hl, hl								;x8
		add hl, hl								;x16
		add hl, hl								;x32 Since our Entity is 32 bytes
		add hl, hl								;x64 Since our Entity was 64 bytes								
		add hl, de								;ld hl, entity.NEXTINACTIVE.eventID
	;Set value to be deactivated just incase the entity doesnt get initialized 
		ld (hl), ACTIVATE_SUCCESS 				;Same as DEACTIVE_ENTITY
	;Check if we need to set Player Pointer
		ld a, ($FF00 + lobyte(temp8BitA))		;A = Player(?) Number
		cp $00
		jr z, @@ReturnFromActivation			;\
		cp PLAYER_FOUR_ENTITY					; } If 0 or too big, don't set pointer
		jr nc, @@ReturnFromActivation			;/
	;If we get here, then set pointer
		push hl
			ld hl, playerOneEntityPointer - 2	;Set up our offset
			sla a								;Double a (because pointers are WORDS)
			ld d, $00
			ld e, a
			add hl, de							;HL = Player Pointer
			push hl
			pop bc								;BC = Player Pointer
		pop hl									;HL = entity.NEXTFREE.eventID
			ld a, l
			ld (bc), a
			inc bc								;BC = hibyte(Player Pointer)
			ld a, h
			ld (bc), a							;Playere Pointer is set
	;Reset Pointer parameter
		xor a
		ld ($FF00 + lobyte(temp8BitA)), a	;Reset temp8BitA so we don't overwrite our pointer by accident
		

	@@ReturnFromActivation:			
	;Return with HL = entity.NEXTFREE.eventID
		
	ret
@ActivateEntityEnd:


;/*
;==============================================================
; Updates all Entities in the Entity List
;==============================================================
;
;Parameters: None
;Returns: None
;Affects: A, BC, DE, HL, AUX8BITVAR
@UpdateAllEntities:
;First clear OAM and reset our object counter
	ld a, (objectCount)
	ld b, a									;B = Counter
	xor a
	cp b
	jr z, +
	ld hl, OAMBuffer
	ld de, _sizeof_OAMEntryStructure
-:
	ld (hl), a
	add hl, de
	dec b
	jr nz, -
+:
	xor a
	ld (objectCount), a
;Reset our Entities Updated Count
	ld a, (entityList.numEntities)
	cp $00
	ret z										;If no Entities, then don't do anything
	ld hl, entityList.numStartEntities
	ld (hl), a									;Save how many entities we had before updating
	xor a
	ld hl, entityList.entitiesUpdated
	ld (hli), a									;ld hl, entityList.bitmap.0
;Set up our loop by finding our position in the bitmap
	ld a, (entityList.shuffleOAMPos)
	and ACTIVE_ENTITY_BYTE_MASK
	swap a										;A = $0,Byte
	ld (entityList.shuffleBitmapIndex), a		;Save the bitmap index for our shuffleOAMPos
	ld d, $00
	ld e, a
	add hl, de									;HL = bitmap.shuffleOAMPos
	ld de, entityList.currentBitmapLocation
	ld (de), a									;Save bitmap location
	ld c, (hl)									;C = (bitmap.shuffleOAMPos) (Byte)
	ld b, a										;B = Loop counter
	ld hl, entityList.entity.0
	ld de, _sizeof_entityStructure
	cp $00
	jr z, +										;If we only have one entity, don't shuffle
-:
;Loop to get to the proper Entity in our EntityList
	add hl, de
	dec b
	jr nz, -
+:
;HL = entityList.entity.shuffleOAMPos(byte)
	ld a, (entityList.shuffleOAMPos)
	and ACTIVE_ENTITY_BIT_MASK					;A = $0,Bit
	ld (aux8BitVar), a							;Save our BIT location for later
	ld b, a					
	ld de, 	_sizeof_entityStructure			
	xor a
	cp b
	jr z, +
-:
;After this loop: HL = entity.shuffleOAMPos, C = (bitmap.shuffleOAMPos)
	srl c
	add hl, de
	dec b
	jr nz, -
+:
	ld a, (aux8BitVar)							;Recall BIT location
	ld b, a										;B = Bitmap Location
	ld a, BIT_COUNTER							;8 BITs per BYTE
	sub b									
	ld b, a										;B = bitmap.remainingBits
	xor a
	ld de, _sizeof_entityStructure
;At this point: A = 0, B = bitmap.remainingBits, C = bitmap.shuffleOAMPos, 
;				HL = entity.shuffleOAMPos, DE = _sizeof_entityStructure
@@CycleThroughBitmap:
-:
;Begin our OAM Suffle Loop
	xor a
	cp c									;Check if we have active entities
;If there are no more active entities in this bitmap byte, then leave
	jp z, EntityListClass@UpdateAllEntities@ByteFinish
	dec b									;Decrease our remaining bits
	srl c
	jr nc, ++
	push bc
	push hl
		;Jump/call the Entitiy's Event Handler
		;HL = entity.eventID
		push hl
			;ld (hl), UPDATE_ENTITY
			ld de, entityStructure.entityUpdatePointer - entityStructure.eventID
			add hl, de					;HL = entityStructure.entityUpdatePointer
			push hl
			pop de						;Swap HL and DE, DE = entityStructure.entityUpdatePointer
			ld a, (de)
			ld l, a
			inc de
			ld a, (de)
			ld h, a						;HL = EntityClass@EventHandler
		pop de							;DE = entity.eventID
		ld bc, @@ReturnFromEntityUpdate
		push bc						;Make our JP HL function as a CALL HL
		jp hl						;call EntityClass@EventHandler
	@@ReturnFromEntityUpdate:
		ld hl, entityList.entitiesUpdated
		inc (hl)
	pop hl
	pop bc
	xor a
++:	
;Check if we are at the end of the Entity List		
	xor a
	cp b
	jr z, @@ByteFinish
	ld de, _sizeof_entityStructure	
	add hl, de									;HL = entity.next
	ld a, (entityList.entitiesUpdated)
	ld d, a
	ld a, (entityList.numStartEntities)
	cp d
	jr nz, -
;Check if we have any more Active Entities or not
	ld a, (entityList.numEntities)
	cp $00
	jr z, @@NoMoreEntities
;UpdateshuffleOAMPos by checking our Active Entity bitmap for the next Active Entity in the list
	ld hl, entityList.bitmap.0
	ld a, (entityList.shuffleBitmapIndex)
	ld d, $00
	ld e, a
	add hl, de									;HL = bitmap.shuffleOAMPos
	ld de, entityList.shuffleOAMPos 
	ld a, (de)		
	inc a										;A = (shuffleOAMPos) + 1							
	and ACTIVE_ENTITY_BIT_MASK
;Check if we moved into a new byte
	jr nz, ++
---:
;We need to move to the next byte or go back to the top
	ld a, (entityList.shuffleBitmapIndex)
	cp LAST_BITMAP
	jr nz, +
;We need to reset back to the top of our Low Priority Bitmap
	ld a, ENTITY_BITMAP_START_INDEX
	ld (entityList.shuffleBitmapIndex), a
	ld hl, entityList.bitmap.0
	ld de, entityList.currentBitmapLocation
	ld a, ENTITY_BITMAP_START
	ld (de), a
	xor a
	ld b, a										;For our BIT counter
	ld c, (hl)
	cp c
	jr z, ---
	jr +++
+:
;We need to advance to the next byte in the Low Priority Bitmap
	inc hl										;HL = bitmap.next
	inc a
	ld (entityList.shuffleBitmapIndex), a		;Move our shuffleBitmapIndex to the next byte too
	ld a, (entityList.shuffleOAMPos)
	and ACTIVE_ENTITY_BYTE_MASK
	ld (entityList.shuffleOAMPos), a
	xor a
	ld c, (hl)									;If this byte is empty, no need to check it
	cp c
	jr z, ---
++:
;Check if this bitmap byte is empty
	ld c, (hl)									;C = bitmap.current
	ld b, a										;B = Counter
	ld (aux8BitVar), a							;Save for later
--:
;Get to the proper BIT location
	srl c
	dec b
	jr nz, --
;Now do the actual check for an empty byte
	xor a
	cp c
	jr z, ---
	ld a, (aux8BitVar)							;Bring back the counter from before
	ld b, a										;B = current BIT we are on
-:
+++:
;Cycle through for the next Active Entity
	srl c
	jr nc, -
;We found the next Active Entity
	ld a, (entityList.shuffleBitmapIndex)
	swap a
	or b										;A = new shuffleOAMPos
	ld (entityList.shuffleOAMPos), a

	ret

	@@NoMoreEntities:
		ld a, ENTITY_BITMAP_START
		ld (entityList.shuffleOAMPos), a
		;end
	ret

	@@ByteFinish:
	;Check if we have any more entities we need to update
		ld a, (entityList.entitiesUpdated)
		ld c, a
		ld a, (entityList.numStartEntities)
		sub a, c
		ld ($FF00 + aux16BitVarLO), a			;Save Remaining Entities
		cp $00
		ret z
	;Set up for next byte of the bitmap
		ld de, entityList.currentBitmapLocation
		ld a, (de)
		cp LAST_BITMAP
		jr nc, ++
	;Set up for the next byte of the bitmap
		inc a
		ld (de), a								;UpdateCurrentBitmapLocation
		ld de, (entityList.bitmap.0)
		add a, e								
		ld e, a									;DE = Next Bitmap
		ld a, (de)
		ld c, a
	;C = (bitmap.next)
	/*

	*/
	;B = remaining bits in the Bitmap, so entity.next is B entities away
		;inc b				
		ld a, BIT_COUNTER
		cp b
		jr nz, +
	;B == 8
		ld de, _sizeof_entityStructure * 8 ;8 bits per byte in the bitmap
		add hl, de											;ld hl, next bitmap Byte of entities
		ld de, entityList.currentBitmapLocation
		;ld a, (de)
		;inc a
		;ld (de), a
		jr @@ByteFinish
	+:
	;B != 8			
		xor a								;Check if B = 0
		cp b
		jr nz, +
		inc b								;If so, then set to 1 so we can get to the next bitmap
	+:	 
		ld de, _sizeof_entityStructure
	-:
	;Loop to get to our proper entity
		add hl, de
		dec b
		jr nz, -
	;HL = entity.next
		ld b, BIT_COUNTER
	;B = 8 BITs per BYTE
	;Make sure this bitmap contains active entities
		xor a
		cp c
		jr z, @@ByteFinish
		ld a, ($FF00 + aux16BitVarLO)
		cp $00
		jp nz, EntityListClass@UpdateAllEntities@CycleThroughBitmap

		ret
	++:
	;We reached the end, so we need to go to the beginning of the Entity List
		ld a, ENTITY_BITMAP_START
		ld (entityList.currentBitmapLocation), a
		ld hl, entityList.bitmap.0
		ld c, (hl)
		ld b, BIT_COUNTER
		ld hl, entityList.entity.0
		xor a
	;Make sure this bitmap contains active entities
		cp c
		jr z, @@ByteFinish
		ld a, ($FF00 + aux16BitVarLO)
		cp $00
		jp nz, EntityListClass@UpdateAllEntities@CycleThroughBitmap

		ret
@UpdateAllEntitiesEnd:

;==============================================================
; Removes Entity from the Entity List
;==============================================================
;
;Parameters: HL = entity.eventID
;Returns: None
;Affects: TBD
@DeactivateEntity:
	;Deactivate Entity
		ld a, INACTIVE_ENTITY
		ld (hl), a
	;Set Entity as Inactive in our Active Entity List
	;Get the difference between the current entity.current and entity.0
		push hl
			ld de, entityStructure.yPos - entityStructure.eventID
			add hl, de						;ld hl, entity.yPos
			xor a
			ld (hl), a						;Set yPos to 0 so OAM will remove the Object
		pop de								;ld de, entity.eventID
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
	;Decrease numEntities
		ld de, entityList.numEntities
		ld a, (de)
		dec a
		ld (de), a
	;Find the Position in the bitmap
		xor a
		srl l								;/2
		rra
		srl l								;/4
		rra
		srl l								;/8
		rra
		srl a								;Move over one more time to make the proper nibble
		;L = BYTE, A = BIT
		;or l								;Put em together
		swap a								;And put them in the correct order of $BYTE,BIT
		ld de, entityList.bitmap.0
		add hl, de							;ld hl, bitmap.currentLocation
		ld b, a
		ld c, ACTIVE_ENTITY_RES_MASK
	;Make the RESET MASK for the bit we want deactivated
		xor a
		cp b
		jr z, +
	-:
		sla c
		dec b
		jr nz, -
	+:
		ld a, c
		cpl
		ld c, a
	;Deactivate the Entity
		ld a, (hl)
		and c
		ld (hl), a
		;end
	ret
@DeactivateEntityEnd:

EntityListClassEnd: ;TEMPORARY
;==============================================================
; Initilize Entity List
;==============================================================
;
;Parameters: None
;Returns: None
;Affects: A, BC, HL
InitializeEntityList:
;Set our initial values for the Entity List
	ld hl, entityList
	xor a
;Set all entities to be inactive
	ld (hli), a							;HL = entity.0
	ld bc, entityList.activationFailure - entityList.entity.0
-:
	ld a, INACTIVE_ENTITY
	ld (hli), a	
	xor a								
	dec bc
	or b
	jr nz, -
	or c
	jr nz, -
;Make sure our activationFailure is set
	;HL = entityList.activationFailure
	ld (hl), ACTIVATE_FAILURE
	inc hl											;ld hl, numStartEntities
	ld (hl), $00
	inc hl											;ld hl, shuffleOAMPos
	ld a, ENTITY_BITMAP_START
	ld (hli), a										;$LoPriorirty,BitZero
	;Also ld hl, shuffleBitmapIndex
	;and ACTIVE_ENTITY_BYTE_MASK					;Don't need due to default value
	;swap a
	ld (hli), a										
	;Also ld hl, currentBitmapLocation
	;swap a
	ld (hli), a
	;Also ld hl, EntitiesUpdated
	xor a
	ld (hli), a
	;Also ld, hl, bitmap.0
	ld (hli), a
	;Also ld, hl, bitmap.1
	ld (hli), a
	;Also ld, hl, bitmap.2
	ld (hli), a
	;Also ld, hl, bitmap.3
	ld (hli), a
	;Also ld, hl, bitmap.4
	ld (hl), a
	ld hl, objectCount
	ld (hl), a
	;end
	ret






.ENDS