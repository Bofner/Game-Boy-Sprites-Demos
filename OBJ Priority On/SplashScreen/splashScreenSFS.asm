.SECTION "SFS Splash Screen"

SFS:
;==============================================================
; Set Scene ID
;==============================================================
	ld hl, sceneID
	ld a, SCENE_SFS
	ld (hli), a				;ld hl, sceneComplete
	ld (hl), 0

;==============================================================
; Load Assets
;==============================================================
;-----------------------------------------
; Background
;-----------------------------------------
	ld a, (modelType)
	cp SGB_MODE
	jr z, +
;SFS Splash Screen Tiles
	ld de, SFSAssets@Tiles
	ld hl, $9000
	ld bc, SFSAssets@TilesEnd - SFSAssets@Tiles
	call MemCopy
	jr ++
+:
;SGB SFS Splash Screen Tiles
	ld de, SFSAssets@SGBTiles
	ld hl, $9000
	ld bc, SFSAssets@SGBTilesEnd - SFSAssets@SGBTiles
	call MemCopy

++:
;SFS Splash Screen Map
	ld de, SFSAssets@Map
	ld hl, $9800
	ld bc, SFSAssets@MapEnd - SFSAssets@Map
	call CopySingleScreenTileMap
	
	ld a, (modelType)
	cp CGB_MODE
	jp z, @InitCGBPalette


@SetSFSPalette:
;Determine what palette to set
	ld hl, SFSAssets@SGB@Palette
	call SendSGBPacket

@InitDMGPalette:
; Set DMG Palette
	ld a, (SFSAssets@SGB@MonochromePal)
	ld (rBGP), a
	jr +

@InitSGBPalette:


@InitCGBPalette:
	ld c, 0*8				;Palette #0 (BG)
	ld b, BG_PALETTE
	ld hl, SFSAssets@@BakgroundGB@CGBPal
	call SetCGBPalette
+:
;-----------------------------------------
; Objects
;-----------------------------------------
;SFS Shimmer Objects
.ENUM $FE00 EXPORT
    topShimmer INSTANCEOF structOAM      ;Shimmer effect
    botShimmer INSTANCEOF structOAM      ;Shimmer effect
.ENDE
.DEF SHIMMER_SPEED $01
;-----------------------------------------
;Top Shimmer OAM data
    ld hl, topShimmer.yPos
;Y-Position
    ld a, 48 + 16	;Y Position has a 16 pixel offset down
    ld (hli), a		;ld hl, topShimmer.xPos
;X-Position
    ld a, 0 + 8		;X Position has an 8 pixel offset to the right
    ld (hli), a		;ld hl, topShimmer.tileID
;Tile ID
    ld a, 0
    ld (hli), a		;ld hl, topShimmer.flags
;Attribute flags
	ld a, OAMF_PRI | OAMF_PAL0
    ld (hl), a
;-----------------------------------------
;Bottom Shimmer OAM data
    ld hl, botShimmer.yPos
;Y-Position
    ld a, (topShimmer.yPos)
    add a, 24		;Y Position is further down than the top shimmer
    ld (hli), a		;ld hl, topShimmer.xPos
;X-Position
	ld a, (topShimmer.xPos)
    add a, 16		;X Position is further right than the top shimmer
    ld (hli), a		;ld hl, topShimmer.tileID
;Tile ID
    ld a, 0
    ld (hli), a		;ld hl, topShimmer.flags
;Attribute flags
	ld a, OAMF_PRI | OAMF_PAL0
    ld (hl), a
;-----------------------------------------
;Load Shimmer Tiles
	ld de, SFSAssets@ShimmerTiles
	ld hl, $8000
	ld bc, SFSAssets@ShimmerTilesEnd - SFSAssets@ShimmerTiles
	call MemCopy

SetSFSShimmerPalette:
	ld a, (modelType)
	cp CGB_MODE
	jr z, CGB_InitShimmerPalette
	cp SGB_MODE
	;jr z, InitShimmerSGBPalette
; Set palettes
	ld a, $00 											;All white
	ld (rOBP0), a
	jr +

InitShimmerSGBPalette:


CGB_InitShimmerPalette
	ld c, 0*8
	ld b, OBJ_PALETTE
	ld hl, SFSAssets@ObjectPalette
	call SetCGBPalette
+:
;==============================================================
; Main program
;==============================================================
	call ScreenOnObj16
	ei
	
SFSLoop:
-: 
; Wait until it's *not* VBlank
    ld a, [rLY]
    cp 144
    jp nc, SFSLoop
@WaitVBlank:
    ld a, [rLY]
    cp 144
    jp c, @WaitVBlank

	ld c, $F0
	scf
	ccf
	dec bc

;Move our shimmers across the screen
;Bottom
	ld a, (botShimmer.xPos)
	add a, SHIMMER_SPEED
    ld (botShimmer.xPos), a
;Top
    ld a, (topShimmer.xPos)
	add a, SHIMMER_SPEED
    ld (topShimmer.xPos), a
;Check if we have gone across the screen yet
	cp 250
	jp c, SFSLoop
;Animation finished, so move on
	ld hl, sceneComplete
	ld (hl), 1

;Clean up the screen
	call ScreenOff
	xor a
;2 shimmers, so our counter is 8 bytes
	ld b, _sizeof_topShimmer * 2
	ld hl, topShimmer
-:
	ld (hli), a
	dec b
	cp b
	jr nz, -


	ret

;==============================================================
; Assets
;==============================================================
SFSAssets:
	@BackgroundGB:
		@@Tiles:
			.INCBIN "..\\assets\\splashScreen\\colorSFS.chr"
		@@TilesEnd:

		@@Map
			.INCBIN "..\\assets\\splashScreen\\colorSFS.map"
		@@MapEnd

		@@CGBPal:
			.INCBIN "..\\assets\\splashScreen\\colorSFS.pal"
			.DW	END_OF_DATA	
		@@CGBPalEnd

		@@DMGPal
			.DB		%11101001 		
			;  	   C3,C2,C1,BG
		@@DMGPalEnd

;----------------------------------------------------------------

	@BackGroundSGB:
		@@SGBTiles:
			.INCBIN "..\\assets\\splashScreen\\sgbSFS.chr"
		@@SGBTilesEnd:

		@@SGBMap
			.INCBIN "..\\assets\\splashScreen\\sgbSFS.map"
		@@SGBMapEnd

		@@SGBPal:
			.INCLUDE "..\\assets\\splashScreen\\sgsSFS.inc"
		@@SGBPalEnd:

		@@DMGPal
			.DB		%11100100		
			;      C3,C2,C1,BG
		@@DMGPalEnd

;----------------------------------------------------------------

	@Sprite:
		@@ShimmerTiles:
			.INCBIN "..\\assets\\splashScreen\\shimmerSFS.chr"
		@@ShimmerTilesEnd

		@@ObjectPalette1:
			.INCBIN "..\\assets\\splashScreen\\shimmerSFS.pal"
			.DW	END_OF_DATA	
		@@ObjectPalette1End

		@@ObjectPalette1CGB
			.DB $9A
			.DW	END_OF_DATA	
		@@ObjectPalette1CGBEnd

		@@DMGPal
			.DB		%11100100		
			;      C3,C2,C1,BG
		@@DMGPalEnd

.ENDS



