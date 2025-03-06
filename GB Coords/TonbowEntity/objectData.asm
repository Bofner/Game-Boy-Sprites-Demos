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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr

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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr

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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr
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
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP					;objectAtr
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
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP					;objectAtr
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
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_UD_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP					;objectAtr
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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr

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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr


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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_LR_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr
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
		.DB 	lobyte((TONBOW_LR_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_LR_GLIDE_VRAM_ABS  >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr

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
		.DB 	lobyte((TONBOW_LR_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_LR_FLAP_VRAM_ABS  >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr

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
		.DB 	lobyte((TONBOW_LR_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP			;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_LR_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP			;objectAtr
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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr

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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr

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
		.DB 	OAMF_PAL0 | $00 							;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00 							;objectAtr
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
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr

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
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr


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
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP					;objectAtr
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
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP				;objectAtr

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
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP				;objectAtr


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
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP				;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)	;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_YFLIP				;objectAtr
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
		.DB 	lobyte((TONBOW_DIAG_GLIDE_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_GLIDE_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP | OAMF_YFLIP		;objectAtr

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
		.DB 	lobyte((TONBOW_DIAG_FLAP_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_FLAP_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP | OAMF_YFLIP		;objectAtr


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
		.DB 	lobyte((TONBOW_DIAG_DASH_VRAM_ABS + $20) >> 4)		;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	;----
	;Tile ID 2/2
		.DB 	lobyte(TONBOW_DIAG_DASH_VRAM_ABS >> 4)				;tileID
	;Object attribute flags
		.DB 	OAMF_PAL0 | $00  | OAMF_XFLIP | OAMF_YFLIP		;objectAtr
	@@DeadDownLeft:
	.DB TONBOW_NUM_OBJS TONBOW_SIZE TONBOW_SHAPE $00 $00 $00 $00 
@Tiles:
	;UP AND DOWN
	@@UpDown:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\tonbowUDGlide.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\tonbowUDFlap.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\tonbowUDDash.inc"
		@@@DashEnd:
	@@UpDownEnd:
	;LEFT AND RIGHT
	@@LeftRight:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\tonbowLRGlide.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\tonbowLRFlap.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\tonbowLRDash.inc"
		@@@DashEnd:

	@@LeftRightEnd:
	;DIAGONAL
	@@Diagonal:
		@@@Glide:
			.INCLUDE "..\\assets\\Tonbow\\tonbowDiagGlide.inc"
		@@@GlideEnd:
		@@@Flap:
			.INCLUDE "..\\assets\\Tonbow\\tonbowDiagFlap.inc"
		@@@FlapEnd:
		@@@Dash:
			.INCLUDE "..\\assets\\Tonbow\\tonbowDiagDash.inc"
		@@@DashEnd:
	@@DiagEnd: