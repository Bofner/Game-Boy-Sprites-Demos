.BANK 1 SLOT 1
.ORG $0000
;-----------------------------------------
; Variables, Entities, Objects etc.
;-----------------------------------------
;SFS Shimmer Objects
.RAMSECTION "SFS Variables and Entities" BANK 0 SLOT 3 RETURNORG
;Variables:
	endSFSTimer				db				;Once the shimmers disapear, start a timer to move on
.ENDS

.INCLUDE "..\\SplashScreen\\shimmerEntityClass.asm"

.SECTION "SFS Splash Screen"
SFS:
;==============================================================
; Constants
;==============================================================
	.DEF	END_TIMER_START_VALUE		$40

;==============================================================
; Initialize BG Scrolling
;==============================================================
;We're gonna set everything to zero since there's no movement on Splash Screen
	xor a
	ld hl, stdScreenScroll.yVel		
	ld (hli), a											;ld hl, stdScreenScroll.yFracPos
	ld (hli), a											;ld hl, stdScreenScroll.yPos
	ld (hli), a											;ld hl, stdScreenScroll.xVel
	ld (hli), a											;ld hl, stdScreenScroll.xFracPos
	ld (hli), a											;ld hl, stdScreenScroll.xPos
	
;==============================================================
; Initialize Variables
;==============================================================
	ld a, END_TIMER_START_VALUE
	ld (endSFSTimer), a

;==============================================================
; Load Assets
;==============================================================
SFSLoadBackgroundAssets:
;Start by turning off the screen
	call ScreenOff
	@GameBoy:
	;-----------------------------------------
	; GB Background tiles
	;-----------------------------------------
	;SFS Splash Screen GB Tiles
		ld de, SFSAssets@BackgroundGB@Tiles
		ld hl, TILE_VRAM_9000
		call TileAndMapHandler

	;-----------------------------------------
	; GB Background Map
	;-----------------------------------------
	;SFS Splash Screen GB Tiles
		ld de, SFSAssets@BackgroundGB@Map
		ld hl, MAP_VRAM_9800
		call TileAndMapHandler

	;-----------------------------------------
	; DMG/CGB Palette
	;-----------------------------------------
	;Check if we are running CGB, SGB or DMG hardware
		ld a, (modelType)
		cp CGB_MODE
		jp z, @@InitCGBPalette

		@@InitDMGPalette:
		; Set DMG palette
			ld a, (SFSAssets@BackgroundGB@DMGPal)
			ld (rBGP), a

		;Check if we are running in SGB
			ld a, (modelType)
			cp SGB_MODE
			jp z, @SuperGameBoy

			jp SFSLoadEntityAssets

		@@InitCGBPalette:
		;Set CGB palette
			ld c, 0*8				;Palette #0 (BG)
			ld b, BG_PALETTE
			ld hl, SFSAssets@BackgroundGB@CGBPal
			call SetCGBPalette
	
			jp SFSLoadEntityAssets

	
	@SuperGameBoy:
	;-----------------------------------------
	; DMG/SGB Palette
	;-----------------------------------------
		@@InitSGBPalette:
		;Start by setting our SGB palette
			ld hl, SFSAssets@BackgroundSGB@SGBPal
			call SendSGBPacket

			jp SFSLoadEntityAssets
	
	
SFSLoadEntityAssets:
	;-----------------------------------------
	; Shimmer Entity tiles
	;-----------------------------------------
	;SFS Shimmer Entity Tiles
		ld de, SFSAssets@Entities@ShimmerTiles
		ld hl, TILE_VRAM_8000
		call TileAndMapHandler

	;-----------------------------------------
	; DMG/CGB Palette
	;-----------------------------------------
	;Check if we are running CGB, SGB or DMG hardware
		ld a, (modelType)
		cp CGB_MODE
		jp z, @InitCGBPalette
		cp SGB_MODE
		jp z, @InitSGBPalette


	@InitDMGPalette:
	; And after we set the DMG palette 
		ld a, (SFSAssets@Entities@Object1DMGPal)
		ld (rOBP0), a

		jp @InitSFSShimmer

	@InitSGBPalette:
	; And after we set the DMG palette 
		ld a, (SFSAssets@Entities@Object1SGBPal)
		ld (rOBP0), a

		jp @InitSFSShimmer

	@InitCGBPalette:
	;Set CGB palette
		ld c, 0*8				;Palette #0 (OBJ)
		ld b, OBJ_PALETTE
		ld hl, SFSAssets@Entities@Object1CGBPal
		call SetCGBPalette
		
		jp @InitSFSShimmer

	@InitSFSShimmer:
	;Initialize our Shimmer Entities
		;Top
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		;Set yPos
		ld de, initYPosVar
		ld a, hibyte(TOP_SHIMMER_START_Y)
		ld (de), a
		inc de
		ld a, lobyte(TOP_SHIMMER_START_Y)
		ld (de), a
		;Set xPos
		ld de, initXPosVar
		ld a, hibyte(TOP_SHIMMER_START_X)
		ld (de), a
		inc de
		ld a, lobyte(TOP_SHIMMER_START_X)
		ld (de), a
		;Set timer
		ld a, $00
		ld (aux8BitVar), a
		;Set UpdateEntityPointer
		ld de, ShimmerEntityClass@UpdateShimmer
		;Set ObjectDataPointer
		ld bc, ShimmerEntityClass@ObjectData
		call ShimmerEntityClass@InitializeEntity

	;Bottom
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		;Set yPos
		ld de, initYPosVar
		ld a, hibyte(BOT_SHIMMER_START_Y)
		ld (de), a
		inc de
		ld a, lobyte(BOT_SHIMMER_START_Y)
		ld (de), a
		;Set xPos
		ld de, initXPosVar
		ld a, hibyte(BOT_SHIMMER_START_X)
		ld (de), a
		inc de
		ld a, lobyte(BOT_SHIMMER_START_X)
		ld (de), a
		;Set timer
		ld a, $00
		ld (aux8BitVar), a
		;Set UpdateEntityPointer
		ld de, ShimmerEntityClass@UpdateShimmer
		;Set ObjectDataPointer
		ld bc, ShimmerEntityClass@ObjectData
		call ShimmerEntityClass@InitializeEntity		

SFSSetUp:
; Turn the LCD on with 8x16 Objects and BG
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_BG8800
    ld (rLCDC), a

;Set Game State to the SFSLoop
	;Load next Game State
	ld a, lobyte(SFSLoop)
	ld ($FF00 + lobyte(nextGameState)), a
	ld a, hibyte(SFSLoop)
	ld ($FF00 + (hibyte(nextGameState))), a		;(nextGameState) = HL
;Set the correct bank
	ld a, SFS_TITLE_ROM_BANK
	ld ($FF00 + lobyte(nextGameStateBank)), a
;And set the flag to change the state
	ld a, CHANGE_GAME_STATE_FLAG
	ld ($FF00 + lobyte(changeGameStateFlag)), a

;Fade the screen in
	;call FadeIn

SFSLoop:

;Check if We are ready to go to the next Game State
	ld a, (entityList.numEntities)
	cp $00
	ret nz

;Set Game State to the SFSLoop
	;Load next Game State
	ld a, lobyte(EndStateSFS)
	ld ($FF00 + lobyte(nextGameState)), a
	ld a, hibyte(EndStateSFS)
	ld ($FF00 + (hibyte(nextGameState))), a		;(nextGameState) = HL
;Set the correct bank
	ld a, SFS_TITLE_ROM_BANK
	ld ($FF00 + lobyte(nextGameStateBank)), a
;And set the flag to change the state
	ld a, CHANGE_GAME_STATE_FLAG
	ld ($FF00 + lobyte(changeGameStateFlag)), a

EndStateSFS:
;Our shimmers have disappeared, time to get ready to move to the next screen
	xor a
	ld hl, endSFSTimer
	dec (hl)
	ret nz

	ld hl, entityList.entity.0.yPos
	ld (hl), 0
	ld hl, entityList.entity.1.yPos
	ld (hl), 0

;Fade out the screen
	;call FadeOutToBlack

;Set Game State to the Title Screen
	;Load next Game State
	ld a, lobyte(TestRoomInit)
	ld ($FF00 + lobyte(nextGameState)), a
	ld a, hibyte(TestRoomInit)
	ld ($FF00 + (hibyte(nextGameState))), a		;(nextGameState) = HL
;Set the correct bank
	ld a, TEST_ROOM_BANK
	ld ($FF00 + lobyte(nextGameStateBank)), a
;And set the flag to change the state
	ld a, CHANGE_GAME_STATE_FLAG
	ld ($FF00 + lobyte(changeGameStateFlag)), a


	ret

;==============================================================
; Assets
;==============================================================
SFSAssets:
	@BackgroundGB:
		@@Tiles:
			.INCLUDE "..\\assets\\splashScreen\\BG\\SFSLogoTiles.inc"
		@@TilesEnd:

		@@Map:
			.INCLUDE "..\\assets\\splashScreen\\BG\\SFSLogoMap.inc"
		@@MapEnd:

		@@CGBPal:
			.INCBIN "..\\assets\\splashScreen\\BG\\cgbSFS.pal"
			.DW	END_OF_DATA	
		@@CGBPalEnd:

		@@DMGPal:
			.DB		%11101000 		
			;  	   C3,C2,C1,BG
		@@DMGPalEnd:
		

;----------------------------------------------------------------

	@BackgroundSGB:
		@@SGBPal:
			.INCLUDE "..\\assets\\splashScreen\\BG\\SFSLogoSGBPal.inc"
		@@SGBPalEnd:

		/*
		@@DMGPal:
			.DB		%11101000 		
			;  	   C3,C2,C1,BG
		@@DMGPalEnd:
		*/
		


;----------------------------------------------------------------

	@Entities:
		@@ShimmerTiles:
			.INCLUDE "..\\assets\\splashScreen\\OBJ\\shimmerSFSTiles.inc"
		@@ShimmerTilesEnd:

		@@Object1CGBPal:
			.INCBIN "..\\assets\\splashScreen\\OBJ\\shimmerSFS.pal"
			.DW	END_OF_DATA	
		@@Object1CGBPalEnd:

		@@Object1SGBPal:
			.DB		%01010101		
			;      C3,C2,C1,BG
		@@Object1SGBPalEnd:

		@@Object1DMGPal:
			.DB		%11111111		
			;      C3,C2,C1,BG
		@@Object1DMGPalEnd:

	;----------------------------------------------------------------

	@Audio:
		@@SteelJingleStudios:

		@@SteelJingleStudiosEnd:

.ENDS
