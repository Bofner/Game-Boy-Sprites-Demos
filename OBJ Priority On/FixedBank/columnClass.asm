.RAMSECTION "Column Class RAM" BANK 0 SLOT 3
;Column data
	column.0 		INSTANCEOF columnStructure
	column			INSTANCEOF columnStructure 4
	column.overflow INSTANCEOF overflowColumnStructure
.ENDS

.SECTION "Column Class"
;DEPENDENCIES: entityStructure, columnListStructure
;================================================================================
; Executes subroutines for Entities, or redirects to speficic Entity Handler
;================================================================================
;Constants for Column Class
	.DEF	NOT_IN_COLUMN						$00
	.DEF	COLUMN_0							%00000001
	.DEF	COLUMN_1							%00000010
	.DEF	COLUMN_2							%00000100
	.DEF	COLUMN_3							%00001000
	.DEF	COLUMN_4							%00010000
	.DEF	COLUMN_BITMAP_SET					%00000001

;Constant values
	.DEF	COLUMN_WIDTH						$20
	.DEF	COLUMN_NUM_POINTERS					$08
	.DEF	OVERFLOW_COLUMN_NUM_POINTERS		$20

;Column Bitmap constants
	.DEF	COLUMN_IS_FULL						%11111111
	.DEF	OVERFLOW_FULL						32
	.DEF	ADD_TO_COLUMN						%00000001
	.DEF	REMOVE_FROM_COLUMN					%11111110
	.DEF	BITMAP_LENGTH						$08
	.DEF	TOTAL_OVERFLOW_BITMAPS				$04

;Column Data
	.DEF	COL_0_XPOS							$00
	.DEF	COL_1_XPOS							COL_0_XPOS + COLUMN_WIDTH
	.DEF	COL_2_XPOS							COL_1_XPOS + COLUMN_WIDTH
	.DEF	COL_3_XPOS							COL_2_XPOS + COLUMN_WIDTH
	.DEF	COL_4_XPOS							COL_3_XPOS + COLUMN_WIDTH

;Hitbox Type
	.DEF	DMG_HITBOX							%00000001
	.DEF	ATK_HITBOX							%00000000
	

ColumnClass:
;==============================================================
; Adds Entity to Column(s)
;==============================================================
;
;Parameters: HL = column.activePointersBitmap, DE = entity.atkHitbox.columnsBitmap
;Returns: None
;Affects: TBD
@AddToColumn:
;Add a pointer to entity.atkHitbox.width
	push de									;\
	push af									; } Save our registers for our 
	push hl									; } column loop
	push bc									;/
	;Check if we have an open spot in our column
		inc de									;DE = atkHitbox.width
		ld a, l									;\
		ld ($FF00 + aux16BitVarLO), a				; } Save the Active Pointer Bitmap 
		ld a, h									; } for later
		ld ($FF00 + aux16BitVarHI), a				;/
		ld a, (hli)								;A = (activePointersBitmap), HL = atkHitboxPointer.0
		cp COLUMN_IS_FULL
		jr z, @@AddToOverflowColumn				;If no space, add to Overflow Column
	;Find our open pointer
	@@FindOpenPointer:
		ld b, ADD_TO_COLUMN

	-:
		rrca 									;Check for zero
		jr nc, @@WriteToPointer
		inc hl									;HL = atkHitboxPointer.CURRENT + 1
		inc hl									;HL = atkHitboxPointer.NEXT
		rlc b									;Update Bitmap Position for new pointer 
		jr -
	@@WriteToPointer:
	;Copy  DE to (HL)... write the pointer
		;HL = atkHitboxPointer.N
		;DE = atkHitbox.width
		ld a, e
		ld (hli), a								;HL = atkHitboxPointer.N + 1
		ld a, d
		ld (hl), a
	;Update our Active Pointer Bitmaps

		ld a, ($FF00 + aux16BitVarLO)
		ld l, a
		ld a, ($FF00 + aux16BitVarHI)
		ld h, a									;HL = column.n.activePointerBitmap
		ld a, (hl)
		or b									;A is updated with new pointer
		ld (hl), a								;Bitmap is updated with new pointer
	@@Return:
	pop bc									;\
	pop hl									; } Recover our registers for our 
	pop af									; } column loop
	pop de									;/
	
	ret

	@@AddToOverflowColumn:
	;Find our empty bitmap and OVERWRITE aux16Var to save it's address
		;DE = atkHitbox.width
		ld hl, column.overflow.numEntities
		ld a, (hli)								;HL = activePointersBitmap.0
		cp OVERFLOW_FULL
		jr nc, @@Return
		ld bc, $00
		jr +
	-:
		inc bc									;Number of times we've gone through the loop
	+:
		ld a, (hli)								;HL = activePointersBitmap.NEXT
		cp COLUMN_IS_FULL
		jr z, -
	;We've found a free pointer within these 8 pointers
	;Save our Bitmap
		dec hl									;Proper Bitmap
		ld a, l									;\
		ld ($FF00 + aux16BitVarLO), a			; } Save the Active Pointer Bitmap 
		ld a, h									; } for later
		ld ($FF00 + aux16BitVarHI), a			;/
		ld a, (hl)								;A = Bitmap
		ld hl, column.overflow.numEntities		;Update Number of Entities
		inc (hl)
		sla c									;x2
		sla c									;x4
		sla c									;x8 for number of pointers per Bitmap
		ld hl, column.overflow.entity.atkHitboxPointer.0
		add hl, bc								;HL = within 8 pointers of the free pointer
	;Find our open pointer
		jr @@FindOpenPointer

		ret


;==============================================================
; Removes Entity from a Column
;==============================================================
;
;Parameters: HL = column.activePointersBitmap, DE = entity.atkHitbox.columnsBitmap
;Returns: None
;Affects: TBD
@RemoveFromColumn:
;Find the entity's pointer in our column
	push de									;\
	push af									; } Save our registers for our 
	push hl									; } column loop
	push bc									;/
	;Check if the pointer matches the address
		inc de									;DE = atkHitbox.width
		ld b, REMOVE_FROM_COLUMN				;B = Bitmap Updater
		ld c, $00								;C will be our counter
		ld a, l
		ld ($FF00 + aux16BitVarLO), a
		ld a, h
		ld ($FF00 + aux16BitVarHI), a			;Save Bitmap
		inc hl									;HL = column.entity.atkHitboxPointer.0
	-:
	;Check if we have searched the entire column
		ld a, c
		cp BITMAP_LENGTH
		jr z, @@RemoveFromOverflowColumn
	;Check the lobyte to see if it's a match
		ld a, (hli)								;HL = column.entity.atkHitboxPointer.CURRENT + 1
		cp e
		jr z, @@CheckHiByte
		inc hl									;HL = column.entity.atkHitboxPointer.NEXT
		rlc b									;Shift Bitmap Updater
		inc c									;Increase our counter
		jr -									
	@@CheckHiByte:
	;Check if the hibyte is also a match
		ld a, (hli)								;HL = column.entity.atkHitboxPointer.NEXT
		cp d
		jr z, @@RemovePointer
		rlc b									;Shift Bitmap Updater
		jr -

	@@RemovePointer:
	;Change Pointer to point to RET
		ld de, ColumnClass@KnownRet
		dec hl
		dec hl									;HL = atkHitboxPointer.current
		ld a, e
		ld (hli), a								;HL = atkHitboxPointer + 1
		ld a, d
		ld (hl), a								;Pointer updated
	;Update Bitmap
		ld a, ($FF00 + aux16BitVarLO)
		ld l, a
		ld a, ($FF00 + aux16BitVarHI)
		ld h, a									;HL = activePointersBitmap
		ld a, (hl)								;A = (activePointersBitmap)
		and b									
		ld (hl), a								;Bitmap is updated


	@@Return:
	pop bc									;\
	pop hl									; } Recover our registers for our 
	pop af									; } column loop
	pop de									;/
	
	ret

	@@RemoveFromOverflowColumn:
	;Setup for Overflow Column Ponter removal
		ld hl, column.overflow.entity.atkHitboxPointer.0
		ld b, REMOVE_FROM_COLUMN				;Set bitmap updater
		ld c, $00
		xor a
		ld ($FF00 + lobyte(aux8BitVar)), a		;Our Bitmap Pointer Counter
	-:
	;Check if we are at the end
		ld a, ($FF00 + lobyte(aux8BitVar))
		cp TOTAL_OVERFLOW_BITMAPS
		jr nc, @@Return							;If we have checked all pointers, leave
	;Check if we are at the end of the bitmap
		ld a, c
		cp BITMAP_LENGTH
		jr c, @@@CheckLoByte
	;If we are at the end in the bitmap, then move to the next one
		ld b, REMOVE_FROM_COLUMN				;Reset bitmap updater
		ld c, $00								;Reset bitmap counter
		ld a, ($FF00 + lobyte(aux8BitVar))
		inc a
		ld ($FF00 + lobyte(aux8BitVar)), a		;Update Bitmap Pointer Counter
	;Run our actual check on the pointer address
		@@@CheckLoByte:
		;Check the lobyte to see if it's a match
			ld a, (hli)								;HL = column.entity.atkHitboxPointer.CURRENT + 1
			cp e
			jr z, @@@CheckHiByte
			inc hl									;HL = column.entity.atkHitboxPointer.NEXT
			rlc b									;Shift Bitmap Updater
			jr -									
		@@@CheckHiByte:
		;Check if the hibyte is also a match
			ld a, (hli)								;HL = column.entity.atkHitboxPointer.NEXT
			cp d
			jr z, @@@RemovePointer
			rlc b									;Shift Bitmap Updater
			jr -

		@@@RemovePointer:
		;Change Pointer to point to RET
			ld de, ColumnClass@KnownRet
			dec hl
			dec hl									;HL = atkHitboxPointer.current
			ld a, e
			ld (hli), a								;HL = atkHitboxPointer + 1
			ld a, d
			ld (hl), a								;Pointer updated
		;Update Bitmap
			ld a, ($FF00 + lobyte(aux8BitVar))		;A = bitmap offset
			ld hl, column.overflow.activePointersBitmap.0
			ld d, $00
			ld e, a
			add hl, de								;HL = column.activePointersBitmap.N
			ld a, (hl)								;A = (activePointersBitmap)
			and b									
			ld (hl), a								;Bitmap is updated

		jr @@Return

		ret


;==============================================================
; Check for collision within a Column
;==============================================================
;
;Parameters: HL = entity.dmgHitbox.columnsBitmap
;Returns: None
;Affects: A, BC, DE, HL
@CheckColumnCollision:
;Save all of the dmgHitbox data
	;HL = entity.dmgHitbox.columnsBitmap
	ld a, (hli)									;HL = dmgHitbox.width
	ld ($FF00 + aux16BitVarLO), a				;Save (dmgHitbox.columnsBitmap)
	xor a
	ld ($FF00 + aux16BitVarHI), a				;Save Column Offset
	ld a, (hli)									;HL = dmgHitbox.height
	ld ($FF00 + lobyte(temp8BitA)), a			;temp8BitA = (dmgHitbox.width)
	ld a, (hli)									;HL = dmgHitbox.y1
	ld ($FF00 + lobyte(temp8BitB)), a			;temp8BitB = (dmgHitbox.height)
	ld a, (hli)									;HL = dmgHitbox.x1
	ld ($FF00 + lobyte(temp8BitC)), a			;temp8BitC = (dmgHitbox.y1)
	ld a, (hli)									;HL = atkHitbox.columnsBitmap
	ld ($FF00 + lobyte(temp8BitD)), a			;temp8BitD = (dmgHitbox.x1)
	inc hl										;HL = atkHitbox.width
	ld a, l
	ld ($FF00 + ptrA16BitLO), a
	ld a, h
	ld ($FF00 + ptrA16BitHI), a			;Save dmgHitbox Entity's atkHitbox.width Address

	@@FindDmgHitboxColumns:
	;Find the column we need to check
		ld a, ($FF00 + aux16BitVarLO)
		ld b, a									;B = dmgHitbox.columnsBitmap
		ld a, ($FF00 + aux16BitVarHI)							
		ld c, a									;A = Column Offset
		ld hl, column.0
	-:
		xor a									;Check if dmgHitbox is in any more columns
		cp b
		jp z, @@CollisionCheckComplete			;If no, then finish check
		srl b
		jr c, @@SetupCollisionCheck				;Check for column using bitmap
		inc c									;No colunm, then inc our offset
		jr -	

	@@SetupCollisionCheck:
	;Save the column offset and bitmap
		ld a, b
		ld ($FF00 + aux16BitVarLO), a			;Save Bitmap
		ld a, c									;A = Column Offset
		inc a									;Columns will always be adjacent, and we need to check the next column on the next loop, not the 0th
		ld ($FF00 + aux16BitVarHI), a			;Save Offset
		ld b, _sizeof_columnStructure
	;Check if offest is 0
		xor a
		cp c
		jr z, @@@ApplyColumnOffset

		@@@ColumnOffsetLoop:	
		;Loop to get to correct column.dmgHitbox offset
			add a, b								;A = Column Offset.next
			dec c
			jr nz, @@@ColumnOffsetLoop

		@@@ApplyColumnOffset:
		;Use offset to get to column.dmgHitbox
			ld e, a
			ld d, $00
			add hl, de								;HL = column.dmgHitbox
			ld de, columnStructure.activePointersBitmap - columnStructure.xPos
			add hl, de								;HL = activePointersBitmap
		;Set up loop for only checking on hitboxes in the column
			ld b, (hl)								;B = Bitmap
			inc hl									;HL = (lobyte(column.atkHitboxPointer.0)

	@@RunCollisionCheck:

		@@@CheckBitmap:
		;Use Bitmap to check for Attack Hitboxes
			xor a
			cp b
			jr z, @@ColumnCheckComplete				;If Bitmap == 0, then Column is finished
			srl b
			jr nc, @@@CheckBitmap

		@@@CheckForSameEntityOrRetHi:
		;Check if the pointer belongs to the dmgHitbox's entity
			ld a, (hli)								;HL = (hitbyte(column.atkHitboxPointer.CURRENT)
			ld e, a															
			ld a, (hli)								;HL = (lobyte(column.atkHitboxPointer.NEXT)
			ld d, a									;DE = atkHitbox.width
		;Check Hibyte for same entity
			ld a, ($FF00 + ptrA16BitHI)	
			cp d
			jr z, @@@CheckSameEntityHitboxLo		;If same, then check the Lobyte too
		;Check Hibyte for KnownRet	
			ld a, hibyte(ColumnClass@KnownRet)
			cp d
			jr z, @@@CheckKnownRetLo				;If same, then check if it's KnownRet
		
		@@@CheckSameEntityHitboxLo:
		;Check Lobyte for same entity
			ld a, ($FF00 + ptrA16BitLO)
			cp e
			jr nz, @@@CheckForHitboxOverlap			;If not same entity, then check collision
			jr @@@CheckBitmap							;Otherwise, go back to the check

		@@@CheckKnownRetLo:
		;Check Lobyte for KnownRet	
			ld a, lobyte(ColumnClass@KnownRet)
			cp e
			jr z, @@@CheckBitmap					;If KnownRet, then don't check collision
		;If not, then run overlap check

		@@@CheckForHitboxOverlap:
		;DE = atkHitbox.width, temp8BitA = (dmgHitbox.width), temp8BitB = (dmgHitbox.height)
		;temp8BitC = (dmgHitbox.y1), temp8BitD = (dmgHitbox.x1)
			push hl				;Preserve Hitbox Pointer
			;Setup our collision check
				push de
				pop hl									;HL = atkHitbox.width
				ld a, (hli)								;A = (atkHitbox.width), HL = atkHitbox.height
				ld ($FF00 + lobyte(temp8BitE)), a		;temp8BitE = (atkHitbox.width)
				ld a, (hli)								;A = (atkHitbock.height), HL = atkHitbox.y
				ld ($FF00 + lobyte(temp8BitF)), a		;temp8BitF = (atkHitbox.height)
				ld a, (hli)								;A = (atkHitbox.y), HL = atkHitbox.x
				ld ($FF00 + lobyte(aux8BitVar)), a		;aux8BitVar = (atkHitbox.y)
				ld a, ($FF00 + lobyte(temp8BitE))		;A = atkHitbox.width
				add a, (hl)								;A = atkHitbox.width + x
			;If dmg.x > atk.x+w then no overlap, and atk is LEFT of dmg
				ld c, a									;C = atk.x+w
				ld a, ($FF00 + lobyte(temp8BitD))		;A = dmg.x
				inc a									;Change >= into a >
				cp c
				jr nc, @@@RecoverHitboxPointerAndReturn
			;AND If dmg.x+w < atk.x, then there is at least X overlap
				;A = dmg.x + 1
				dec a									;A = dmgHitbox.x
				ld c, a									;C = dmgHitbox.x
				ld a, ($FF00 + lobyte(temp8BitA))		;A = dmgHitbox.width
				add a, c								;A = dmgHitbox.x+width
				ld c, (hl)								;C = atkHitbox.x
				cp c
				jr c, @@@RecoverHitboxPointerAndReturn
			;AND If atk.y > dmg.y+h then atkHitbox is BELOW dmgHitbox
				ld a, ($FF00 + lobyte(temp8BitB))		;A = dmgHitbox.height
				ld c, a									;C = dmgHitbox.height
				ld a, ($FF00 + lobyte(temp8BitC))		;A = dmgHitbox.y
				add a, c								;A = dmgHitbox.h+y
				ld c, a									;C = dmgHitbox.h+y
				ld a, ($FF00 + lobyte(aux8BitVar))		;A = atkHitbox.y
				cp c
				jr nc, @@@RecoverHitboxPointerAndReturn
			;AND If dmg.y < atk.y+h  then we MUST have overlap, and COLLISION
				ld c, a									;C = atkHitbox.y
				ld a, ($FF00 + lobyte(temp8BitF))		;A = atkHitbox.height
				add a, c								;A = atkHitbox.y+h
				ld c, a									;C = atkHitbox.y+h
				ld a, ($FF00 + lobyte(temp8BitC))		;A = dmgHitbox.y
				inc a									;Make >= into >
				cp c
				jr nc, @@@RecoverHitboxPointerAndReturn
				
		@@@CollisionFound:
		;Set event for the Attcking Entity
			ld de, entityStructure.eventID - entityStructure.atkHitbox.x1
			add hl, de									;HL = atkEntity.eventID
			ld (hl), ATK_HITBOX_COLLISION				;entity.eventID = Attack Collision
		;Set Event for the Damaged Entity
			ld a, ($FF00 + ptrA16BitLO)
			ld l, a
			ld a, ($FF00 + ptrA16BitHI)
			ld h, a										;HL = dmgEntity.atkHitbox
			ld de, entityStructure.eventID - entityStructure.atkHitbox.width
			add hl, de									;HL = dmgEntity.eventID
			ld (hl), DMG_HITBOX_COLLISION				;entity.eventID = Damage Collision
			

		@@@RecoverHitboxPointerAndReturn:
		;Finished checking this atkHitbox for collision
			pop hl				;Recover Hitbox Pointer
			jr @@@CheckBitmap


	@@ColumnCheckComplete:

		jp ColumnClass@CheckColumnCollision@FindDmgHitboxColumns


	@@CollisionCheckComplete:

		ret


	


;==============================================================
; Updates Entity's Current Columns
;==============================================================
;
;Parameters: HL = entity.atkHitbox.columns, D = DMG_HITBOX or ATK_HITBOX
;Returns: None
;Affects: A, BC, DE, HL, aux8BitVar
@UpdateEntityCurrentColumns:
	push de										;Save Hitbox type
	;Save Entity's current Column Status
		ld a, (hli)									;HL = atkHitbox.width
		ld ($FF00 + lobyte(aux8BitVar)), a
	;Check entity's atkHitbox.width and atkHitbox.x1
		ld a, (hli)									;HL = atkHitbox.height, A = (width)
		inc hl										;HL = atkHitbox.y1
		inc hl										;HL = atkHitbox.x1
		add a, (hl)									;A = atkHitbox's (x2)
		call @@QuickDivide32
		ld d, a										;D = col.max
		ld a, (hl)									;A = (atkHitbox.x1)
		call @@QuickDivide32
		ld e, a										;E = col.min
	;Set up our column bitmap
		ld b, COLUMN_BITMAP_SET
	;Set col.min Bitmap
		xor a
		cp e
		jr z, @@DoneWithColumnMinShift
		-:
		sla b
		dec e
		jr nz, -
		@@DoneWithColumnMinShift:
		ld e, b										;E = col.min BITMAP 
	;Set col.max Bitmap
		ld b, COLUMN_BITMAP_SET
		xor a
		cp d
		jr z, @@DoneWithColumnMaxShift
		-:
		sla b
		dec d
		jr nz, -
		@@DoneWithColumnMaxShift:
		ld d, b										;D = col.max BITMAP 
		ld a, d
		sub a, e									;A = col.dif
		or d										;A = Column Bitmap
	;Compare with original Column bitmap
		ld b, a										;B = New Column Bitmap
		ld a, ($FF00 + lobyte(aux8BitVar))			;A = Old Column Bitmap
		ld de, hitboxStructure.columnsBitmap - hitboxStructure.x1
		add hl, de									;HL = hitbox.columns
		cp b										;Did it change?
		jr z, @@NoChangeInColumns

	;Update atkHitbox.columns
		ld (hl), b									;Update hitbox.columns
;Check if we are dealing with a Damage or Attack Hitbox
	pop de
	rrc d										;Check if it is a Damage Hitbox or Attack Hitbox
	ret nz										;If damage, then return

;Update Columns from min to max
	;B = New Column Bitmap
	;A = Old Column Bitmap

;Remove from columns
	ld b, a										;B = OLD Column Bitmap
	ld a, (hl)									;A = NEW Column Bitmap
	xor b										;A = Changed Bitmap
	and b										;A = Removed Bitmap
	call @@CheckRemovedColumns

;Add to columns
	push de
	pop hl										;HL = entity.hitbox.columnsBitmap
	ld a, ($FF00 + lobyte(aux8BitVar))			;A = Old Column Bitmap
	ld b, (hl)									;B = NEW Column Bitmap
	xor b										;A = Changed Bitmap
	and b										;A = Removed Bitmap
	call @@CheckAddedColumns
;Recover our entity
	push de
	pop hl

	ret

;--------
	@@CheckRemovedColumns:
		ld de, column.0.activePointersBitmap
		ld bc, _sizeof_columnStructure
		push de										;\ 
		push hl										; } DE = entity.hitbox.columnsBitmap,
		pop de										; } HL = column.0 
		pop hl										;/ 
	-:
		cp $00
		ret z
		srl a
		call c, ColumnClass@RemoveFromColumn
		add hl, bc									;HL = column.next
		jr -
;--------
	@@CheckAddedColumns:
		ld de, column.0.activePointersBitmap
		ld bc, _sizeof_columnStructure
		push de										;\ 
		push hl										; } DE = entity.hitbox.columnsBitmap,
		pop de										; } HL = column.0 
		pop hl										;/ 
	-:
		cp $00
		ret z
		srl a
		call c, ColumnClass@AddToColumn
		add hl, bc									;HL = column.next
		jr -
;--------
	@@QuickDivide32:
		srl a								;/2
		srl a								;/4
		srl a								;/8
		srl a								;/16
		srl a								;/32
		ret
;--------
@@NoChangeInColumns:
;We didn't get to POP our DE, so let's get rid of that
	pop de

	ret

	




;==============================================================
; Initializes columns
;==============================================================
;
;Parameters: 
;Returns: None
;Affects: TBD
@Initialize:
	ld hl, column.0
	ld a, COL_0_XPOS
	ld b, COLUMN_NUM_POINTERS
	call @@InitColumn
	ld hl, column.1
	ld a, COL_1_XPOS
	ld b, COLUMN_NUM_POINTERS
	call @@InitColumn
	ld hl, column.2
	ld a, COL_2_XPOS
	ld b, COLUMN_NUM_POINTERS
	call @@InitColumn
	ld hl, column.3
	ld a, COL_3_XPOS
	ld b, COLUMN_NUM_POINTERS
	call @@InitColumn
	ld hl, column.4
	ld a, COL_4_XPOS
	ld b, COLUMN_NUM_POINTERS
	call @@InitColumn
	ld hl, column.overflow
	ld b, OVERFLOW_COLUMN_NUM_POINTERS
	call @@InitPointers
	ld hl, column.overflow
	xor a
	ld (hli), a							;numEntities = 0, HL = activePointersBitmap.0
	ld (hli), a							;HL = activePointersBitmap.1
	ld (hli), a							;HL = activePointersBitmap.2
	ld (hli), a							;HL = activePointersBitmap.3
	ld (hl), a


	ret

	;Parameters: HL = column.n, A = column.n.xPos, B = Number of Pointers
	@@InitColumn:
		ld (hli), a							;HL = column.n.width
		ld (hl), COLUMN_WIDTH				
		inc hl								;HL = column.n.activePointers
	@@InitPointers:
		xor a
		ld (hli), a							;HL = column.n.pointer.0
	-:
		ld (hl), lobyte(ColumnClass@KnownRet)
		inc hl
		ld (hl), hibyte(ColumnClass@KnownRet)
		inc hl								;HL = column.n.pointer.next
		dec b
		jr nz, -
@KnownRet:
	ret


.ENDS