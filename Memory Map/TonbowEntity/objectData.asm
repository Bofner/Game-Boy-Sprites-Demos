;==============================================================
; Tonbow Entity's Object Data
;==============================================================
@ObjectData
	@@GlideUp:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@@FlapUp:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@@DashUp:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	@@DeadUp:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 
	@@UpEnd:

	;----

	@@GlideDown:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	@@FlapDown:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	@@DashDown:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_UD_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	@@DeadDown:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;----------------------------

	@@GlideRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@@FlapRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr


	@@DashRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	@@DeadRight:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 
	@@FrameRightEnd:

	;--------------------------------------

	@@GlideLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_GLIDE_VRAM_ABS  >> 4)				;tileID
		
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr

	@@FlapLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE											;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_FLAP_VRAM_ABS  >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr

	@@DashLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE											;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_LR_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00			;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00			;objectAtr
	@@DeadLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;--------------------

	@@GlideUpRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@@FlapUpRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr

	@@DashUpRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0							;objectAtr
	@@DeadUpRight:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;--------------------
	
	@@GlideUpLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr

	@@FlapUpLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr


	@@DashUpLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00					;objectAtr
	@@DeadUpLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 

	;--------------------
	
	@@GlideDownRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00				;objectAtr

	@@FlapDownRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00				;objectAtr


	@@DashDownRight:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 									;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)			;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00				;objectAtr
	@@DeadDownRight:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 


	;--------------------
	
	@@GlideDownLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 | $00		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 | $00		;objectAtr

	@@FlapDownLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 | $00		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 | $00		;objectAtr


	@@DashDownLeft:
	;-------------------
	;OAM Handler Data
	;-------------------
	;How many objects we need to write for this Entity
		.DB		TONBOW_NUM_OBJS										;numObjects
	;OBJ Size (8x8 or 8x16)
		.DB		TONBOW_SIZE 										;sizeOBJ
	;Shape of our Entity $WidthHeight (Measured in OBJs)
		.DB		TONBOW_SHAPE										;shape
	;-------------------
	;OAM Data
	;-------------------
	;Tile ID 1/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 | $00		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 | $00		;objectAtr
	@@DeadDownLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 
@Tiles:
	;UP AND DOWN
	@@UpDown:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@DashEnd:
	@@UpDownEnd:
	;LEFT AND RIGHT
	@@LeftRight:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@DashEnd:

	@@LeftRightEnd:
	;DIAGONAL
	@@Diagonal:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\multiColorBlock.inc"
		@@@DashEnd:
	@@DiagEnd: