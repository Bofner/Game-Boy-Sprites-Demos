.SECTION "Kaikuro Class"
KaikuroEntityClass:
;================================================================================
; All subroutines and data related to the SFS Shimmer Kaikuro Class
;================================================================================
;Change the following throughout the entire class
; Kaikuro: 		Captial letter of the entity (Entity)
; kaikuro: 		Lower case letter of the entity (entity)
; KAIKURO:		Constant values (ENTITY)
;==============================================================
; Constants
;==============================================================
;Init Values
	.DEF 	KAIKURO_START_Y				$0100 + $0100	;96 = $60.0 + yPos Offset
	.DEF	KAIKURO_START_X	 			$0080 + $0080	;40 = $28.0 + xPos Offset
	.DEF	KAIKURO_SPEED				$10				;$LSB,FRAC
	.DEF	KAIKURO_TIMER_INIT_VALUE	$00

;Kaikuro OBJ data
	.DEF	KAIKURO_NUM_OBJS			$0A				;Number of OBJs entity uses
	.DEF	KAIKURO_SIZE				$08				;8x8 ($08) or 8x16 ($10)
	.DEF	KAIKURO_SHAPE				$A1				;Shape of our Entity $WidthHeight (Measured in OBJs)

;VRAM Absolute Data
	.DEF 	KAIKURO_VRAM				$8240

;Attack Hitbox
	.DEF	KAIKURO_ATK_HITBOX_VERT_OFFSET	$05
	.DEF	KAIKURO_ATK_HITBOX_WIDTH		$08		
	.DEF	KAIKURO_ATK_HITBOX_HEIGHT		$06	
	.DEF	KAIKURO_DMG_HITBOX_WIDTH		$08		
	.DEF	KAIKURO_DMG_HITBOX_HEIGHT		$06	




;==============================================================
; Updates the Kaikuro
;==============================================================
;
;Parameters: DE = kaikuro.eventID (Should be coming from EntityList@UpdateEntities)
;Returns: None
;Affects: DE
@UpdateKaikuro:
	;Grab Event ID 
	push de									;Save entity.eventID
	pop hl									;HL = entity.eventID

;Check if dead
	ld a, (hl)
	cp DMG_HITBOX_COLLISION
	jp z, KaikuroEntityClass@DyingKaikuro

;Adjust animation
	call @AdjustFrame

;Update Animation based off of state
	@@UpdateAnimation:							;Label used for skipping checks during dash
		call @UpdateEntityAnimation

;Update Positions of entity and Hitboxes
	push hl								;Save entity.eventID
		;call @UpdatePositions
	pop hl								;HL = entity.eventID

;Add Entity to the OAM Buffer
	call GeneralEntityEvents@OAMHandler

	
	ret


;==============================================================
; Adjust what frame of animation Kaikuro is on
;==============================================================
@AdjustFrame:

	ret


;==============================================================
; Update Kaikuro animation based off current state
;==============================================================
@UpdateEntityAnimation:

	ret

;==============================================================
; Update Kaikuro Position and Hitbox positions
;==============================================================
@UpdatePositions:
	@@UpdateObjectPosition:
;Save previous xPos to see if we need to update our column
		ld de, entityStructure.xPos - entityStructure.eventID
		add hl, de						;HL = entity.xPos
		ld a, (hl)						;A = (entity.xPos)
		ld de, entityStructure.eventID - entityStructure.xPos
		add hl, de						;HL = entity.eventID
		push af
			call GeneralEntityEvents@UpdatePosition
			;HL = dmgHitbox

		;Update atkHitbox location
			call @@UpdateHitboxes
			;HL = entity.atkHitbox
			;B = New (entity.xPos)
		pop af							;A = Old (entity.xPos)

	@@UpdateCurrentColumns:
	;Update location of atkHitbox in regards to the columns if need be
		ld d, ATK_HITBOX
		cp b							;If no change in xPos, don't bother
		call nz, ColumnClass@UpdateEntityCurrentColumns
	;Copy columnBitmap for dmgHitbox, since same
		ld a, (hl)						;A = atkHitbox.columnsBitmap
		ld de, -_sizeof_hitboxStructure
		add hl, de									;HL = dmghitBox
		ld (hl), a						;Bitmap Column Copied 

	@@CheckCollision:
	;Check if we are invincible, if invincible, skip collision detection (entity.state)
	;HL = dmghitBox
	ld a, ($FF00 +  playerOneEntityPointerLO)
	ld e,a
	ld a, ($FF00 +  playerOneEntityPointerHI)
	ld d,a								;DE = player.eventID
	inc hl								;HL = kaikuro.dmgHitbox.width
	ld a, (hli)									;HL = dmgHitbox.height
	ld ($FF00 + lobyte(temp8BitA)), a			;temp8BitA = (dmgHitbox.width)
	ld a, (hli)									;HL = dmgHitbox.y1
	ld ($FF00 + lobyte(temp8BitB)), a			;temp8BitB = (dmgHitbox.height)
	ld a, (hli)									;HL = dmgHitbox.x1
	ld ($FF00 + lobyte(temp8BitC)), a			;temp8BitC = (dmgHitbox.y1)
	ld a, (hli)									;HL = atkHitbox.columnsBitmap
	ld ($FF00 + lobyte(temp8BitD)), a			;temp8BitD = (dmgHitbox.x1)
	ld bc, entityStructure.eventID - entityStructure.atkHitbox.columnsBitmap
	add hl, bc									;HL = kaikuro.eventID
	ld a, l
	ld ($FF00 + ptrA16BitLO), a
	ld a, h
	ld ($FF00 + ptrA16BitHI), a
	push hl
	;Swap HL and DE
		push hl
		push de
		pop hl
		pop de
		ld bc, entityStructure.atkHitbox.width -entityStructure.eventID
		add hl, bc								;HL = player.atkHitbox.width
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
			ld bc, entityStructure.eventID - entityStructure.atkHitbox.x1
			add hl, bc									;HL = atkEntity.eventID
			ld a, (hl)
			cp DMG_HITBOX_COLLISION
			jr z, +								;If Tonbow is being killed, then don't change its event
			ld (hl), ATK_HITBOX_COLLISION				;entity.eventID = Attack Collision
		+:
		;Set Event for the Damaged Entity
			ld a, ($FF00 + ptrA16BitLO)
			ld l, a
			ld a, ($FF00 + ptrA16BitHI)
			ld h, a										;HL = dmgEntity.atkHitbox
			ld (hl), DMG_HITBOX_COLLISION				;entity.eventID = Damage Collision
			

		@@@RecoverHitboxPointerAndReturn:
		;Finished checking this atkHitbox for collision
	pop hl


	;Check if we are being hit by something
		;call ColumnClass@CheckColumnCollision


	ret

	@@UpdateHitboxes:
	;Attack Hitbox
		dec hl									;HL = entity.xPos
		ld b, (hl)
		ld de, entityStructure.yPos - entityStructure.xPos
		add hl, de								;HL = entity.yPos
		ld a, (hl)
	;Set X and Y. Width and Height stay constant
		ld de, entityStructure.atkHitbox.y1 - entityStructure.yPos
		add hl, de								;HL = entity.atkHitbox.y1
		sub a, OBJ_YPOS_OFFSET					;Adjust for offset
		add a, KAIKURO_ATK_HITBOX_VERT_OFFSET	;Adjust for how the sprite appears on screen
		ld ($FF00 + lobyte(temp8BitA)), a		;Save atkHitbox.x
		ld (hli), a								;HL = entity.atkHitbox.x1
		ld a, b
		sub a, OBJ_XPOS_OFFSET
		ld ($FF00 + lobyte(temp8BitB)), a		;Save atkHitbox.y
		ld (hl), a
		ld de, entityStructure.dmgHitbox.y1 - entityStructure.atkHitbox.x1 
		add hl, de								;HL = entity.dmgHitbox
	;Damage Hitbox
		ld a, ($FF00 + lobyte(temp8BitA))		;A = atkHitbox.y
		ld (hli), a								;HL = dmg.x
		ld a, ($FF00 + lobyte(temp8BitB))		;A = atkHitbox.x
		ld (hl), a								
		ld de, entityStructure.atkHitbox - entityStructure.dmgHitbox.x1 
		add hl, de								;HL = entity.dmgHitbox
	
		
		ret

;==============================================================
; Dying Kaikuro
;==============================================================
;
;Parameters: HL = kaikuro.eventID 
;Affects: A, HL, DE
@DyingKaikuro:
;Check what stage of death the Kaikuro is at

;Update animation

;Get rid of Attack Hitbox
	push hl
		ld de, entityStructure.atkHitbox - entityStructure.eventID
		add hl, de							;HL = kaikuro.atkHitbox.columnsBitmap
		ld a, (hl)							;B = kaikuro.columnsBitmap
		push hl
		pop de								;DE = kaikuro.atkHitbox.columnsBitmap
		ld hl, column.0.activePointersBitmap

		@@CheckRemovedColumns:
		ld bc, _sizeof_columnStructure
	-:
		cp $00
		jr z, +
		srl a
		call c, ColumnClass@RemoveFromColumn
		add hl, bc									;HL = column.next
		jr -
;Remove from columns
	+:

	
	pop hl
;If totally dead, remove from list
	jp EntityListClass@DeactivateEntity

;==============================================================
; Initializes the Kaikuro
;==============================================================
;
;Parameters: HL = kaikuro.eventID 
;Affects: A, HL, DE
@Initialize:
;Initialize General properties
	push hl
	;Set yPos
		ld de, initYPosVar
		ld a, hibyte(KAIKURO_START_Y)
		ld (de), a
		inc de
		ld a, lobyte(KAIKURO_START_Y)
		ld (de), a
	;Set xPos
		ld de, initXPosVar
		ld a, hibyte(KAIKURO_START_X)
		ld (de), a
		inc de
		ld a, lobyte(KAIKURO_START_X)
		ld (de), a
	;Set timer
		ld a, KAIKURO_TIMER_INIT_VALUE
		ld (aux8BitVar), a
	;Set UpdateEntityPointer
		ld bc, KaikuroEntityClass@ObjectData
	;Set ObjectDataPointer
		ld de, KaikuroEntityClass@UpdateKaikuro
		call GeneralEntityEvents@InitializeEntity
	pop hl
	push hl
	;Set up xPos, yPos, and atkHitbox
		call GeneralEntityEvents@UpdatePosition	
		ld (hl), $00							;entity.dmgHitbox.columnsBitmap = $00
		;HL = atkHitbox
		dec hl									;HL = entity.xPos
		ld b, (hl)
		ld de, entityStructure.yPos - entityStructure.xPos
		add hl, de								;HL = entity.yPos
		ld a, (hl)
		ld de, entityStructure.atkHitbox.columnsBitmap - entityStructure.yPos
		add hl, de								;HL = entity.atkHitbox.columnsBitmap
		ld (hl), $00
		inc hl									;HL = entity.atkHitbox.width
		ld (hl), KAIKURO_ATK_HITBOX_WIDTH
		inc hl									;HL = entity.atkHitbox.height
		ld (hl), KAIKURO_ATK_HITBOX_HEIGHT
		inc hl									;HL = entity.atkHitbox.y1
		sub a, OBJ_YPOS_OFFSET					;Adjust for offset
		add a, KAIKURO_ATK_HITBOX_VERT_OFFSET	;Adjust for how the sprite appears on screen
		ld ($FF00 + lobyte(temp8BitA)), a		;Save yPos
		ld (hli), a								;HL = entity.atkHitbox.x1
		ld a, b
		sub a, OBJ_XPOS_OFFSET
		ld ($FF00 + lobyte(temp8BitB)), a		;Save xPos
		ld (hl), a
		ld de, entityStructure.dmgHitbox.columnsBitmap - entityStructure.atkHitbox.x1
		add hl, de								;HL = dmgHitbox.columnsBitmap
		ld (hl), $00
		inc hl									;HL = dmg.width
		ld (hl), KAIKURO_DMG_HITBOX_WIDTH
		inc hl									;HL = dmg.height
		ld (hl), KAIKURO_DMG_HITBOX_HEIGHT
		inc hl									;HL = dmg.y1
		ld a, ($FF00 + lobyte(temp8BitA))		;A = atkHitbox.y
		ld (hli), a								;HL = dmg.x
		ld a, ($FF00 + lobyte(temp8BitB))		;A = atk.x
		ld (hl), a
	;Set up Columns
		ld de, entityStructure.atkHitbox.columnsBitmap - entityStructure.dmgHitbox.x1
		add hl, de								;HL = atkHitbox
		ld d, ATK_HITBOX
		call ColumnClass@UpdateEntityCurrentColumns
	pop hl

		ret

;==============================================================
; Kaikuro's Object Data
;==============================================================
@ObjectData
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		KAIKURO_NUM_OBJS								;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		KAIKURO_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		KAIKURO_SHAPE									;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $00 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $10 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $20 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $30 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $40 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $50 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $60 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $70 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $80 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr
	;Tile ID 1/10
		.DB 	lobyte(KAIKURO_VRAM + $90 >> 4)						;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0										;objectAtr

@Tiles:
;Just the one set
	@@Eight:
		.INCLUDE "..\\assets\\FixedBankEntities\\elevenObjs\\elevenObjsTiles.inc"
	@@EightEnd:

.ENDS