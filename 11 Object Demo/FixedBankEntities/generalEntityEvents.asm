;Dependency: EntityListClass is declared somewhere in RAM
.RAMSECTION "General Entity Event Data" BANK 0 SLOT 3
;General Entity Event related data 
	entityNumObjects				db			;Keep track of # of OBJs that make up the Entity
	entityObjectSize				db			;Are OBJs 8x8 or 8x16
	entityWidth						db			;Keep track of entity's width
	entityHeight					db			;Keep track of entity's heght
	entityYPos						db			;Keep track of entity's yPos
	entityXPos						db			;Keep track of entity's xPos
	
	currentRowWritten				db			;Variable to store number of objects we've written this row
	currentYPos						db			;Variable to store current entity's yPos during OAMBuffer writing
	currentXPos						db			;Variable to store current entity's xPos during OAMBuffer writing
	currentWidth					db			;Variable to store current entity's width during OAMBuffer writing
	currentHeight					db			;Variable to store current entity's height during OAMBuffer writing
;	currentObjectTileIndex			db			;Can just take from Entity Class's Object Data


.ENDS

.BANK 0 SLOT 0
.SECTION "General Entity Events"
;================================================================================
; Executes subroutines for Entities, or redirects to speficic Entity Handler
;================================================================================
;Object Constants
	.DEF	OBJECT_COUNT_MAX		40	
;Object Data Constants
	.DEF	WIDTH_MASK				%11110000
	.DEF	HEIGHT_MASK				%00001111

;Entity Constants
	.DEF	ENTITY_COUNT_MAX		OBJECT_COUNT_MAX
	.DEF	OBJ_XPOS_OFFSET			$08
	.DEF	OBJ_YPOS_OFFSET			$10

;Entity Types
	.DEF	PLAYER					$00
	.DEF	NPC						$01
	.DEF	ENEMY					$02
	.DEF	PROJECTILE				$03
;Entity IDs
	.DEF	SFS_SHIMMER				$00		
	.DEF	MAX_EVENT_VALUE			$03

;State Constants
	.DEF	LRUD_MASK				%11110000
	.DEF	BUTTON_MASK				%00001111
	.DEF	LRUD_MAX				$0A

;==============================================================
; General Entity Events 
;==============================================================
;Handles any Events that are dealt in the same way no matter the Entity ID
;Parameters: HL = entity.eventID
;Returns: None
;Affects: A, BC, DE, HL
GeneralEntityEvents:

;Convert the xFracPos and yFracPos into xPos and yPos
;Parameters: HL = entity.eventID
@UpdatePosition:
;Use velocity to update the yPosition
	ld de, entityStructure.yVel - entityStructure.eventID
	add hl, de						;HL = yVel
	ld a, (hli)						;HL = yFracPos
	ld b, a							;B = yVel
	ld a, (hl)						;A = yFracPos
	ld c, a							;C = prevYFracPos
	add a, b						;A = newYFracPos
	ld (hl), a
;Check if we need to carry into the MSB
;Find out if it was a negative or positive carry
	bit 7, b
	jr nz, +
	call c, @@HandleCarry
	jr ++
+:
	call nc, @@HandleCarry@NegativeCarry
++:
	call @@ConvertNFracPosToNPos
;Use velocity to update the xPosition
	;HL = entity.xVel
	ld a, (hli)						;HL = xFracPos
	ld b, a							;B = xVel
	ld a, (hl)						;A = xFracPos
	ld c, a							;C = prevXFracPos
	add a, b						;A = newXFracPos
	ld (hl), a
;Check if we need to carry into the MSB
;Find out if it was a negative or positive carry
	bit 7, b
	jr nz, +
	call c, @@HandleCarry
	jr ++
+:
	call nc, @@HandleCarry@NegativeCarry
++:
	call @@ConvertNFracPosToNPos

	ret

	;Parameters: A = (entity.nVel), HL = entity.nFracPos
	@@HandleCarry:		
		@@@PositiveCarry:
		;Carry was positive, so add value to the MSB
			inc hl						;HL = entity.nFracPos.MSB
		;Carry into MSB without affecting the UNUSED bits
			ld a, (hl)
			inc a
			and $0F
			ld (hld), a					;HL = entity.nFracPos.LSB						
			;end	
		ret
		@@@NegativeCarry:
		;Carry was negative, so subtract value from the MSB
			inc hl						;HL = entity.nFracPos.MSB
		;Carry into MSB without affecting the UNUSED bits
			ld a, (hl)
			dec a

			ld (hld), a					;HL = entity.nFracPos.LSB
			;end	
		ret


	;Parameters: HL = entity.nFracPos
	@@ConvertNFracPosToNPos:
	;Converts the fractional WORD into a whole BYTE
		ld a, (hli)						;A = $LSB,FRAC
		and $F0							;A = $LSB,0
		ld b, a							;B = $LSB,0
		ld a, (hli)						;A = $0,MSB
		;HL = entity.nPos
		or b							;A = $LSB,MSB
		swap a							;A = $MSB,LSB
		ld (hli), a						;HL = entity.xVel/dmgHitbox

		ret


;Update the OAMBuffer
;Parameters: HL = entity.eventID
@OAMHandler:
;Set DE = (entity.objectDataPointer)
	ld de, entityStructure.objectDataPointer - entityStructure.eventID
	add hl, de							;HL = entity.objectDataPointer
	ld a, (hli)
	ld e, a
	ld a, (hl)
	ld d, a								;DE = objectData.numObjects
;Save the Entity's Object Data
	push hl								;Save our Entity data for later
		ld a, (de)
		ld hl, entityNumObjects
		ld (hli), a							;HL = entityObjectSize
		inc de								;DE = objectData.sizeOBJ
		ld a, (de)
		ld (hli), a							;HL = entityWidth
		inc de								;DE = objectData.shape
		;Shape is saved as $WidthHeight in one byte
		ld a, (de)
		and WIDTH_MASK
		swap a								;A = $0Width
		ld (hli), a							;HL = entityHeight, DE = objectData.shape
		ld a, (de)
		and HEIGHT_MASK
		ld (hl), a					
		inc de								;DE = objectData.tileID		
	pop hl								;Recover our Entity data
;Store the yPos and xPos of our Entity for future use
	ld bc, entityStructure.yPos - (entityStructure.objectDataPointer + 1)
	add hl, bc							;HL = entity.yPos
	ld bc, entityYPos
	ld a, (hli)							;HL = entity.xVel
	ld (currentYPos), a
	ld (bc), a							;Save entityYPos
	inc bc								;BC = entityXPos
	inc hl								;HL = entity.xFracPos
	inc hl								;WORD
	inc hl								;HL = entity.xPos
	ld a, (hl)
	ld (currentXPos), a
	ld (bc), a							;Save entityXPos
;Check if we have the space to add an Entity with this many objects
	ld a, (entityNumObjects)			;A = # of OBJs that make up the Entity
	ld b, a							;B = # of OBJs that make up the Entity
	ld a, (objectCount)					;A = # OBJs on screen
	cp OBJECT_COUNT_MAX
	ret nc								;If there's not enough space, no new entity
;If we got here, then we have enough space. We just need to get to the proper space in OAMBuffer
	sla a								;A x 2
	sla a								;A x 4 (since each entry in OAMBuffer is 4 bytes)
	ld b, $00
	ld c, a
	ld hl, OAMBuffer + 40
	add hl, bc							;HL = OAMBuffer.object.yPos
;We are at the next available spot in the OAMBuffer
;So now DE = objectData.tileID and HL = OAMBuffer.object.yPos
	ld a, (entityNumObjects)			;A = # of OBJs that make up the Entity	
	ld b, a								;B = # of OBJs that make up the Entity	
	xor a
	ld (currentRowWritten), a			;We have written no objects yet			
;B will be used as our loop counter
-:
;Set yPos
	;HL = OAMBuffer.object.yPos
	ld a, (currentYPos)	
	ld (hli), a							;HL = OAMBuffer.object.xPos
;Set xPos
	;HL = OAMBuffer.object.xPos
	ld a, (currentXPos)
	ld (hli), a							;HL = OAMBuffer.object.tileID
	;DE = objectData.tileID
	ld a, (de)
	ld (hli), a							;HL = OAMBuffer.object.attributes
	inc de								;DE = objectData.objectAtr
	;HL = OAMBuffer.object.attributes
	ld a, (de)
	ld (hli), a							;HL = OAMBuffer.nextObject.yPos
	inc de								;DE = nextObjectData.tileID
;Update objectCount w/out destroying our 16-bit registers
	ld a, (objectCount)
	inc a
	ld (objectCount), a
;Update row written w/out destroying our 16-bit registers
	ld a, (currentRowWritten)
	inc a
	ld (currentRowWritten), a
;Check if we have more OBJs to write to OAMBuffer
	xor a
	dec b
	cp b
	jr nz, @@UpdateYXPos

	ret

	@@UpdateYXPos:
		;Check if we are at the end of our row
		ld a, (entityWidth)
		ld c, a								;C = entity.width
		ld a, (currentRowWritten)
		cp c
		jr z, @@@NewRow
		;If not, then x + 8
		ld a, (currentXPos)
		add a, $08							;Tile Width
		ld (currentXPos), a

		jr -
		@@@NewRow:
		;If yes, then y = currentYPos + entityObjectSize ($08 or $10) 
		ld a, (entityObjectSize)
		ld c, a								;C = $08 or $10
		ld a, (currentYPos)
		add a, c
		ld (currentYPos), a
		;And x = entityXPos 
		ld a, (entityXPos)
		ld (currentXPos), a
		;Reset our row counter
		xor a
		ld (currentRowWritten), a

		jr -

;==============================================================
; Initializes the Entity
;==============================================================
;Parameters:  	HL = entity.eventID 
;			  	DE = EntityClass@UpdateEntity
;				BC = EntityClass@ObjectData
;			  	aux8BitVar = ENTITY_TIMER_INIT_VALUE
;				initYPos = yFracPos
;				initXPos = xFracPos
;Returns: None
;Affects: A, HL, DE, BC
@InitializeEntity:
;Initialize our General Entity's properties
	;HL = entity.eventID				
	ld a, NO_EVENT
	ld (hli), a						;HL = entity.state
	ld a, IDLE	
	ld (hli), a						;HL = entity.timer
	xor a
	ld (hli), a						;HL = entityUpdatePointer
	ld a, e							
	ld (hli), a
	ld a, d
	ld (hli), a						;HL = entityObjectDataPointer
	ld a, c					
	ld (hli), a
	ld a, b
	ld (hli), a						;HL = entity.yVel
	;ld de, entityStructure.yVel - entityStructure.timer
	;add hl, de						;HL = entity.yVel
	xor a
	;A = $00
	ld (hli), a						;HL = entity.yFracPos
	ld a, (initYPosVar+1)
	ld (hli), a		
	ld a, (initYPosVar)	
	ld (hli), a						;HL = entity.yPos
	xor a
	ld (hli), a						;HL = entity.xVel
	ld (hli), a						;HL = entity.xFracPos
	ld a, (initXPosVar+1)
	ld (hli), a		
	ld a, (initXPosVar)
	ld (hli), a						;HL = entity.xPos
	xor a
	ld (hli), a		
	;Hurt and Hit boxes	

	ret

GeneralEntityEventsEnd:

.ENDS


