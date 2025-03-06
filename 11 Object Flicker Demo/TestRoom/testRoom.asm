.BANK 3 SLOT 1
.ORG $0000
.SECTION "Test Room"
TestRoomInit:
;==============================================================
; Constants
;==============================================================
	.DEF	TESTROOM_KAIKURO_OPEN_VRAM_ABS		TONBOW_DIAG_DASH_VRAM_ABS + $40	
	.DEF	TESTROOM_KAIKURO_CLOSE_VRAM_ABS		TESTROOM_KAIKURO_OPEN_VRAM_ABS + $20

;==============================================================
; Initialize level's ROM Bank
;==============================================================
	ld hl, currentLevelROMBank
	ld a, TEST_ROOM_BANK
	ld (hl), a
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
TestRoomBackgroundAssets:
;Start by turning off the screen
	call ScreenOff
	@GameBoy:
	;-----------------------------------------
	; GB Background tiles
	;-----------------------------------------
	;Title Tiles
		ld de, TestRoomAssets@BackgroundGB@Tiles
		ld hl, TILE_VRAM_9000
		call TileAndMapHandler
	;-----------------------------------------
	; GB Background Map
	;-----------------------------------------
	;Title Map
		ld de, TestRoomAssets@BackgroundGB@Map
		ld hl, MAP_VRAM_9800
		call TileAndMapHandler

	;-----------------------------------------
	; DMG/CGB Palette
	;-----------------------------------------
	;Check if we are running CGB or DMG hardware
		ld a, (modelType)
		cp CGB_MODE
		jp z, @@InitCGBPalette

	;Check if we are running in SGB
		ld a, (modelType)
		cp SGB_MODE
		jp z, @SuperGameBoy

		@@InitDMGPalette:
		; Set DMG palette
			ld a, (TestRoomAssets@BackgroundGB@DMGPal)
			ld (rBGP), a

			jp TestRoomLoadEntities

		@@InitCGBPalette:
		;Set CGB palette
			;ld c, 0*8				;Palette #0 (BG)
			;ld b, BG_PALETTE
			;ld hl, TestRoomAssets@BackgroundGB@CGBPal
			;call SetCGBPalette

		;Bank Switch VRAM to write the Attribute Map
	
			jp TestRoomLoadEntities

	
	@SuperGameBoy:
	;-----------------------------------------
	; DMG/SGB Palette
	;-----------------------------------------

		@@InitSGBPalette:
		;Freeze GB Screen
			ld hl, MaskFreezeSGB
			call SendSGBPacket

		; Set DMG palette
			ld a, (TestRoomAssets@BackgroundGB@DMGPal)
			ld (rBGP), a
		;Start by setting our SGB palette 0 and 1
			ld hl, TestRoomAssets@SGBAssets@SGBPal
			call SendSGBPacket
		;And SGB palette 2 and 3
			ld hl, TestRoomAssets@SGBAssets@SGBPal + $10
			call SendSGBPacket
		;And send out Attribute Files
			ld hl, TestRoomAssets@SGBAssets@SGBATR
			call SendSGBPacket
		
		;Unfreeze GB Screen
			ld hl, MaskUnfreezeSGB
			call SendSGBPacket

			jp TestRoomLoadEntities
	
	
TestRoomLoadEntities:
;-----------------------------------------
; Tonbow Tiles
;-----------------------------------------
	;Tonbow Up and Down Glide
		ld de, TonbowEntityClass@Tiles@UpDown@Glide
		ld hl, TONBOW_UD_GLIDE_VRAM_ABS
		call TileAndMapHandler

	;Tonbow Up and Down Flap
		ld de, TonbowEntityClass@Tiles@UpDown@Flap
		ld hl, TONBOW_UD_FLAP_VRAM_ABS
		call TileAndMapHandler

	;Tonbow Up and Down Dash
		ld de, TonbowEntityClass@Tiles@UpDown@Dash
		ld hl, TONBOW_UD_DASH_VRAM_ABS
		call TileAndMapHandler
;----
	;Tonbow Left and Right Glide
		ld de, TonbowEntityClass@Tiles@LeftRight@Glide
		ld hl, TONBOW_LR_GLIDE_VRAM_ABS
		call TileAndMapHandler

	;Tonbow Left and Right Flap
		ld de, TonbowEntityClass@Tiles@LeftRight@Flap
		ld hl, TONBOW_LR_FLAP_VRAM_ABS
		call TileAndMapHandler

	;Tonbow Left and Right Dash
		ld de, TonbowEntityClass@Tiles@LeftRight@Dash
		ld hl, TONBOW_LR_DASH_VRAM_ABS
		call TileAndMapHandler
;----
	;Tonbow Diagonal Glide
		ld de, TonbowEntityClass@Tiles@Diagonal@Glide
		ld hl, TONBOW_DIAG_GLIDE_VRAM_ABS
		call TileAndMapHandler

	;Tonbow Diagonal Flap
		ld de, TonbowEntityClass@Tiles@Diagonal@Flap
		ld hl, TONBOW_DIAG_FLAP_VRAM_ABS
		call TileAndMapHandler

	;Tonbow Diagonal Dash
		ld de, TonbowEntityClass@Tiles@Diagonal@Dash
		ld hl, TONBOW_DIAG_DASH_VRAM_ABS
		call TileAndMapHandler

;----
	;Mario 8
		ld de, KaikuroEntityClass@Tiles@Eight
		ld hl, KAIKURO_VRAM
		call TileAndMapHandler

	;Mario 16

	;-----------------------------------------
	; DMG/CGB Palette
	;-----------------------------------------
	;Check if we are running CGB or DMG hardware
		ld a, (modelType)
		//cp CGB_MODE
		//jp z, @InitCGBPalette
		cp SGB_MODE
		jp z, @InitSGBPalette


	@InitDMGPalette:
	; And after we set the DMG palette 
		ld a, (TestRoomAssets@ObjectsGB@Object0DMGPal)
		ld (rOBP0), a

		jp @InitPlayer

	@InitSGBPalette:
	; And after we set the DMG palette 
		ld a, (TestRoomAssets@ObjectsGB@Object0DMGPal)
		ld (rOBP0), a

		jp @InitPlayer

	/*
	@InitCGBPalette:
	;Set CGB palette
		ld c, 0*8				;Palette #0 (OBJ)
		ld b, OBJ_PALETTE
		ld hl, TitleAssets@Entities@Object1CGBPal
		call SetCGBPalette
		
		jp @InitSFSShimmer
*/
	@InitPlayer:
	;Add Tonbow to the screen
		ld a, PLAYER_ONE_ENTITY
		ld ($FF00 + lobyte(temp8BitA)), a
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call TonbowEntityClass@Initialize

		
	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.1.xFracPos + 1
		ld (hl), $01
		ld hl, entityList.entity.1.xFracPos
		ld (hl), $00
	;Change Graphic Data
		ld hl, entityList.entity.1.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData1)
		ld hl, entityList.entity.1.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData1)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.2.xFracPos + 1
		ld (hl), $01
		ld hl, entityList.entity.2.xFracPos
		ld (hl), $80
	;Change Graphic Data
		ld hl, entityList.entity.2.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData2)
		ld hl, entityList.entity.2.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData2)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.3.xFracPos + 1
		ld (hl), $02
		ld hl, entityList.entity.3.xFracPos
		ld (hl), $00
	;Change Graphic Data
		ld hl, entityList.entity.3.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData3)
		ld hl, entityList.entity.3.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData3)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.4.xFracPos + 1
		ld (hl), $02
		ld hl, entityList.entity.4.xFracPos
		ld (hl), $80
	;Change Graphic Data
		ld hl, entityList.entity.4.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData4)
		ld hl, entityList.entity.4.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData4)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.5.xFracPos + 1
		ld (hl), $03
		ld hl, entityList.entity.5.xFracPos
		ld (hl), $00
	;Change Graphic Data
		ld hl, entityList.entity.5.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData5)
		ld hl, entityList.entity.5.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData5)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.6.xFracPos + 1
		ld (hl), $03
		ld hl, entityList.entity.6.xFracPos
		ld (hl), $80
	;Change Graphic Data
		ld hl, entityList.entity.6.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData6)
		ld hl, entityList.entity.6.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData6)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.7.xFracPos + 1
		ld (hl), $04
		ld hl, entityList.entity.7.xFracPos
		ld (hl), $00
	;Change Graphic Data
		ld hl, entityList.entity.7.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData7)
		ld hl, entityList.entity.7.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData7)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.8.xFracPos + 1
		ld (hl), $04
		ld hl, entityList.entity.8.xFracPos
		ld (hl), $80
	;Change Graphic Data
		ld hl, entityList.entity.8.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData8)
		ld hl, entityList.entity.8.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData8)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.9.xFracPos + 1
		ld (hl), $05
		ld hl, entityList.entity.9.xFracPos
		ld (hl), $00
	;Change Graphic Data
		ld hl, entityList.entity.9.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData9)
		ld hl, entityList.entity.9.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData9)

	;Add Number to the screen
		call EntityListClass@ActivateEntity
		;HL = entity.eventID
		call KaikuroEntityClass@Initialize
	;Change Starting pos
		ld hl, entityList.entity.10.xFracPos + 1
		ld (hl), $05
		ld hl, entityList.entity.10.xFracPos
		ld (hl), $80
	;Change Graphic Data
		ld hl, entityList.entity.10.objectDataPointer + 1
		ld (hl), hibyte(KaikuroEntityClass@ObjectData10)
		ld hl, entityList.entity.10.objectDataPointer
		ld (hl), lobyte(KaikuroEntityClass@ObjectData10)



	; Turn the LCD on with 8x16 Objects and BG
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BG8800
    ld (rLCDC), a

;Set Game State to the TestRoomLoop
	;Load next Game State
	ld a, lobyte(TestRoomLoop)
	ld ($FF00 + lobyte(nextGameState)), a
	ld a, hibyte(TestRoomLoop)
	ld ($FF00 + (hibyte(nextGameState))), a		;(nextGameState) = HL
;Set the correct bank
	ld a, TEST_ROOM_BANK
	ld ($FF00 + lobyte(nextGameStateBank)), a
;And set the flag to change the state
	ld a, CHANGE_GAME_STATE_FLAG
	ld ($FF00 + lobyte(changeGameStateFlag)), a

;Fade the screen in
	;call FadeIn

TestRoomLoop:

;End conditions
;Set Game State to the Story
	;ld hl, Story
	;call UpdateGameState
;Set Game State to the Arcade
	;ld hl, Arcade
	;call UpdateGameState
;Set Game State to the Options
	;ld hl, TitleOptions
	;call UpdateGameState

	;ld hl, Cutscene1
	;call UpdateGameState

	ret

;==============================================================
; Assets
;==============================================================
TestRoomAssets:
	@BackgroundGB:
		@@Tiles:
			.INCLUDE "..\\assets\\TestRoom\\BG\\testRoomTiles.inc"
		@@TilesEnd:

		@@Map:
			.INCLUDE "..\\assets\\TestRoom\\BG\\testRoomMap.inc"
		@@MapEnd:

		@@DMGPal:
			.DB		%11100100		
			;  	   C3,C2,C1,BG
		@@DMGPalEnd:

	@ObjectsGB:
		@@Object0DMGPal:
			.DB		%11010110		
			;      C3,C2,C1,BG
		@@Object0DMGPalEnd:

	@SGBAssets:
		@@SGBPal:
			.INCLUDE "..\\assets\\TestRoom\\BG\\testRoomPal.inc"
		@@SGBPalEnd:

		@@SGBATR:
			.INCLUDE "..\\assets\\TestRoom\\BG\\testRoomBLK.inc"
		@@SGBATREnd:

.ENDS