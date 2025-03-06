;==============================================================
; Update Tonbow Position
;==============================================================
@UpdatePositions:
	@@UpdateObjectPosition:
;Save previous xPos to see if we need to update our column
		ld de, tonbowStructure.xPos - tonbowStructure.eventID
		add hl, de						;HL = tonbow.xPos
		ld a, (hl)						;A = (tonbow.xPos)
		ld de, tonbowStructure.eventID - tonbowStructure.xPos
		add hl, de						;HL = tonbow.eventID
		push af
			call GeneralEntityEvents@UpdatePosition
			;HL = dmgHitbox

		;Update Hitboxes' locations
			call @UpdateHitboxes
			;HL = tonbow.dmgHitbox
			;B = New (tonbow.xPos)
		pop af							;A = Old (tonbow.xPos)

	@@UpdateCurrentColumns:
	;Update location of Damage Hitbox
		cp b							;If no change in xPos, don't bother
		jr z, @@CheckCollision
		ld d, DMG_HITBOX
		call ColumnClass@UpdateEntityCurrentColumns
	;Update location of Attack Hitbox
		ld de, _sizeof_hitboxStructure
		add hl, de						;HL = atkHitbox
		ld d, ATK_HITBOX
		call ColumnClass@UpdateEntityCurrentColumns
		;HL = tonbow.atkHitbox
	;Set up for Checking Collision
		ld de, tonbowStructure.dmgHitbox - tonbowStructure.atkHitbox
		add hl, de						;HL = tonbow.dmgHitbox


	@@CheckCollision:
	;Check if we are invincible, if invincible, skip collision detection (tonbow.state)

	;Check if we are being hit by something
		;call ColumnClass@CheckColumnCollision

		ret

;==============================================================
; Update Tonbow Hitboxes
;==============================================================
@UpdateHitboxes:
;Get the current xPos and yPos
	dec hl													;HL = tonbow.xPos
	ld a, (hl)
	ld ($FF00 + aux16BitVarLO), a							;lobyte(aux16BitVar) = xPos
	ld de, tonbowStructure.yPos - tonbowStructure.xPos
	add hl, de												;HL = tonbow.yPos
	ld a, (hl)
	ld ($FF00 + aux16BitVarHI), a							;hibyte(aux16BitVar) = yPos
;Update Damage Hitbox
	ld de, tonbowStructure.dmgHitbox.width - tonbowStructure.yPos
	add hl, de												;HL = dmgHitbox.width
	ld (hl), TONBOW_DMG_HITBOX_WIDTH
	inc hl													;HL = dmgHitbox.height
	ld (hl), TONBOW_DMG_HITBOX_HEIGHT
	inc hl													;HL = dmgHitbox.y1
	ld a, ($FF00 + aux16BitVarHI)
	add a, -OBJ_YPOS_OFFSET + TONBOW_DMG_HITBOX_VERT_OFFSET
	ld (hli), a												;HL = dmgHitbox.x1
	ld a, ($FF00 + aux16BitVarLO)
	add a, -OBJ_XPOS_OFFSET + TONBOW_DMG_HITBOX_HORI_OFFSET
	ld (hl), a												;Damage Hitbox Set!
;Update Attack Hitbox
	ld de, tonbowStructure.state - tonbowStructure.dmgHitbox.x1
	add hl, de												;HL = tonbow.atkHitbox.state
	ld a, (hld)												;A = (tonbow.state), HL = tonbow.eventID
	and TONBOW_CURRENT_DIRECTION							;A = Tonbow Direction
	srl a
	srl a													;Tonbow Direction = Number representation (0-8)
	ld ($FF00 + lobyte(aux8BitVar)), a						;aux8BitVar = Tonbow Direction Number Rep
	ld de, @HitboxJumpTable
	jp TonbowEntityClass@JumpToJRTable

	ret										;For safety


;==============================================================
; Attack Hitbox JR Table
;==============================================================
@HitboxJumpTable:
	jr @@VerticalState						;State is UP
	jr @@VerticalState						;State is DOWN
	jr @@HoirzontalState					;State is RIGHT
	jr @@HoirzontalState					;State is LEFT
	jr @@UpDiagonalState					;State is UP RIGHT
	jr @@UpDiagonalState					;State is UP LEFT
	jr @@DownDiagonalState					;State is DOWN RIGHT
	jr @@DownDiagonalState					;State is DOWN LEFT

	@@VerticalState:
	;Set Attack Hitbox
		push bc
		pop hl									;HL = tonbow.eventID
	;Find the offset for UP or DOWN
		ld a, ($FF00 + lobyte(aux8BitVar))		;A = Tonbow Direction Num Rep	
		;Bit manipulation of State's Numerical Representation to be the
		;DOWN or UP offset			
		rlca									
		rlca								
		rlca									;A = $00 or $08
	;Set atkHitbox.width & height
		ld de, tonbowStructure.atkHitbox.width - tonbowStructure.eventID
		add hl, de								;HL = tonbow.atkHitBox.width
		ld (hl), TONBOW_ATK_HITBOX_VERT_WIDTH
		inc hl									;HL = tonbow.atkHitBox.height
		ld (hl), TONBOW_ATK_HITBOX_VERT_HEIGHT
	;Set atkHitbox.y1
		inc hl									;HL = tonbow.atkHitbox.y1
		sub a, OBJ_YPOS_OFFSET
		ld b, a									;B = $00 or $08 - YPOS_OFFSET
		ld a, ($FF00 + lobyte(aux16BitVar + 1)) ;A = tonbow.yPos
		add a, b								;Add UP or DOWN offset
		ld (hli), a								;HL = tonbow.atkHitbox.x1
	;Set atkHitbox.x1
		ld a, ($FF00 + lobyte(aux16BitVar))		;A = tonbow.xPos	
		ld b, a									;B = tonbow.xPos (For comparisson)
		sub a, OBJ_XPOS_OFFSET
		ld (hl), a

		jr @@ReturnWithDamageHitbox

	@@HoirzontalState:
	;Set Attack Hitbox
		push bc
		pop hl									;HL = tonbow.eventID
	;Find the offset for RIGHT or LEFT
		ld a, ($FF00 + lobyte(aux8BitVar))		;A = Tonbow Direction Num Rep	
		;Bit manipulation of State's Numerical Representation to be the
		;RIGHT or LEFT		
		and HITBOX_POS_MASK	
		xor HITBOX_POS_MASK						;I set the directions in a silly way
		rlca									
		rlca								
		rlca									;A = $00 or $08
	;Set atkHitbox.width & height
		ld de, tonbowStructure.atkHitbox.width - tonbowStructure.eventID
		add hl, de								;HL = tonbow.atkHitBox.width
		ld (hl), TONBOW_ATK_HITBOX_HORI_WIDTH
		inc hl									;HL = tonbow.atkHitBox.height
		ld (hl), TONBOW_ATK_HITBOX_HORI_HEIGHT
	;Set atkHitbox.y1
		inc hl									;HL = tonbow.atkHitbox.y1
		ld c, a									;Save LEFT RIGHT Offset Calc
		ld a, ($FF00 + lobyte(aux16BitVar + 1))		;A = tonbow.yPos
		sub a, OBJ_YPOS_OFFSET
		ld (hli), a								;HL = tonbow.atkHitbox.x1
	;Set atkHitbox.x1	
		ld a, c									;Recover LEFT RIGHT Offset Calc
		sub a, OBJ_XPOS_OFFSET
		ld c, a									;C = $00 or $08 - XPOS_OFFSET
		ld a, ($FF00 + lobyte(aux16BitVar))		;A = tonbow.xPos
		ld b, a									;B = tonbow.xPos (For comparisson)
		add a, c								;Add RIGHT or LEFT offset
		ld (hl), a

		jr @@ReturnWithDamageHitbox

		ret
	

	@@UpDiagonalState:
	;Set Attack Hitbox
		push bc
		pop hl									;HL = tonbow.eventID
	;Find the offset for RIGHT or LEFT
		ld a, ($FF00 + lobyte(aux8BitVar))		;A = Tonbow Direction Num Rep	
		;Bit manipulation of State's Numerical Representation to be the
		;RIGHT or LEFT		
		and HITBOX_POS_MASK	
		xor HITBOX_POS_MASK
		rlca									
		rlca								
		rlca									;A = $00 or $08
	;Set atkHitbox.width & height
		ld de, tonbowStructure.atkHitbox.width - tonbowStructure.eventID
		add hl, de								;HL = tonbow.atkHitBox.width
		ld (hl), TONBOW_ATK_HITBOX_DIAG_WIDTH
		inc hl									;HL = tonbow.atkHitBox.height
		ld (hl), TONBOW_ATK_HITBOX_DIAG_HEIGHT
	;Set atkHitbox.y1
		inc hl									;HL = tonbow.atkHitbox.y1
		ld c, a									;Save LEFT RIGHT Offset Calc
		ld a, ($FF00 + lobyte(aux16BitVar + 1))		;A = tonbow.yPos
		sub a, OBJ_YPOS_OFFSET
		ld (hli), a								;HL = tonbow.atkHitbox.x1
	;Set atkHitbox.x1	
		ld a, c									;Recover LEFT RIGHT Offset Calc
		sub a, OBJ_XPOS_OFFSET
		ld c, a									;C = $00 or $08 - XPOS_OFFSET
		ld a, ($FF00 + lobyte(aux16BitVar))		;A = tonbow.xPos
		ld b, a									;B = tonbow.xPos (For comparisson)
		add a, c								;Add RIGHT or LEFT offset
		ld (hl), a

		jr @@ReturnWithDamageHitbox

	@@DownDiagonalState:
	;Set Attack Hitbox
		push bc
		pop hl									;HL = tonbow.eventID
	;Find the offset for RIGHT or LEFT
		ld a, ($FF00 + lobyte(aux8BitVar))		;A = Tonbow Direction Num Rep	
		;Bit manipulation of State's Numerical Representation to be the
		;RIGHT or LEFT		
		and HITBOX_POS_MASK	
		xor HITBOX_POS_MASK
		rlca									
		rlca								
		rlca									;A = $00 or $08
	;Set atkHitbox.width & height
		ld de, tonbowStructure.atkHitbox.width - tonbowStructure.eventID
		add hl, de								;HL = tonbow.atkHitBox.width
		ld (hl), TONBOW_ATK_HITBOX_DIAG_WIDTH
		inc hl									;HL = tonbow.atkHitBox.height
		ld (hl), TONBOW_ATK_HITBOX_DIAG_HEIGHT
	;Set atkHitbox.y1
		inc hl									;HL = tonbow.atkHitbox.y1
		ld c, a									;Save LEFT RIGHT Offset Calc
		ld a, ($FF00 + lobyte(aux16BitVar + 1))		;A = tonbow.yPos
		sub a, OBJ_YPOS_OFFSET - $08
		ld (hli), a								;HL = tonbow.atkHitbox.x1
	;Set atkHitbox.x1	
		ld a, c									;Recover LEFT RIGHT Offset Calc
		sub a, OBJ_XPOS_OFFSET
		ld c, a									;C = $00 or $08 - XPOS_OFFSET
		ld a, ($FF00 + lobyte(aux16BitVar))		;A = tonbow.xPos
		ld b, a									;B = tonbow.xPos (For comparisson)
		add a, c								;Add RIGHT or LEFT offset
		ld (hl), a

	@@ReturnWithDamageHitbox:
	;Setup for Column work
		ld de, tonbowStructure.dmgHitbox - tonbowStructure.atkHitbox.x1
		add hl, de

		ret