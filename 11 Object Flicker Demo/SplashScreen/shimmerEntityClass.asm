.SECTION "Shimmer EntityClass"
ShimmerEntityClass:
;================================================================================
; All subroutines and data related to the SFS Shimmer Entity Class
;================================================================================

;==============================================================
; Constants
;==============================================================
	.DEF 	SFS_SHIMMER_VRAM_INDEX 		$00
	.DEF	SHIMMER_MOVE_RIGHT			DPAD_RIGHT					;Same as DPAD_RIGHT input
	.DEF 	TOP_SHIMMER_START_Y			$0400						; 48 + 16 = 64.0 = $40.0 Y Position has a 16 pixel offset down
	.DEF	TOP_SHIMMER_START_X			$0080						;  0 +  8 =  8.0 = $08.0 X Position has an 8 pixel offset right
	.DEF 	BOT_SHIMMER_START_Y			TOP_SHIMMER_START_Y + $0100 ;TOP_SHIMMER_START_Y + 16
	.DEF	BOT_SHIMMER_START_X			TOP_SHIMMER_START_X + $00C0 ;Same horizontal as topShimmer
	.DEF	SHIMMER_SPEED				$10							;$LSB,FRAC
	.DEF	SHIMMER_X_Y_POS_OFFSET		$00
	.DEF	SHIMMER_X_LIMIT				150							;For deactivation
	.DEF	SHIMMER_NUM_OBJ				$01
	.DEF	SHIMMER_SIZE				$10
	.DEF	SHIMMER_SHAPE				$11


;==============================================================
; Updates the SFS Shimmer AI
;==============================================================
;
;Parameters: DE = entity.eventID (Should be coming from EntityList@UpdateEntities)
;Returns: None
;Affects: A, DE, HL
@UpdateShimmer:
;Grab Event ID 
	push de										;Save entity.eventID
	pop hl										;HL = entity.eventID
;If Shimmer makes it across the screen, then remove it
	ld de, entityStructure.xPos - entityStructure.eventID
	add hl, de									;HL = shimmer.xPos
	ld a, (hl)									;HL = (shimmer.xPos)
	ld de, entityStructure.eventID - entityStructure.xPos
	add hl, de									;HL = shimmer.eventID
	cp SHIMMER_X_LIMIT
	jp nc, EntityListClass@DeactivateEntity
;Execute movement logic
	call @MoveRight			
;Update Position
	push hl
		call GeneralEntityEvents@UpdatePosition
	pop hl
;Add to OAM
	call GeneralEntityEvents@OAMHandler

	ret


;==============================================================
; Moves Shimmer Right
;==============================================================
;
;Parameters: HL = entity.eventID
;Returns: None
;Affects: A, BC
	@MoveRight:
	;Set xVel so our Shimmer can move right
		;ld hl, entity.eventID
		ld bc, entityStructure.xVel - entityStructure.eventID
		add hl, bc								;ld hl, entity.xVel
		ld a, SHIMMER_SPEED
		ld (hl), a
		ld bc, entityStructure.eventID - entityStructure.xVel
		add hl, bc

		ret
	


;==============================================================
; Initializes the SFS Shimmer Entity
;==============================================================
;
;Parameters:  	HL = entity.eventID 
;			  	DE = EntityClass@UpdateEntity
;				BC = EntityClass@ObjectData
;			  	aux8BitVar = ENTITY_TIMER_INIT_VALUE
;				initYPos = yFracPos
;				initXPos = xFracPos
;Returns: None
;Affects: A, DE, HL
@InitializeEntity:

		call GeneralEntityEvents@InitializeEntity

		ret


;==============================================================
; SFS Shimmer Entity's Object Data
;==============================================================
;SFS Shimmer only has 1 state, so we only need to worry about the one object
@ObjectData:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		SHIMMER_NUM_OBJ										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		SHIMMER_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		SHIMMER_SHAPE										;shape
	;Tile ID
		.DB 	SFS_SHIMMER_VRAM_INDEX
	;Object attribute flags
		.DB 	OAMF_PRI | OAMF_PAL0
	;One 8x16 Object, so finished
	@ObjectDataEnd:

.ENDS