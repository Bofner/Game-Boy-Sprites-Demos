SteelFingerStudios:
;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

    inc hl                                  ;ld hl, sceneID
    ld (hl), $00

;Switch to correct bank for SFS ASsets
    ld a, SFSBank
    ld ($FFFF), a

;==============================================================
; Memory (Structures, Variables & Constants) 
;==============================================================

.enum $DFFF - $30 export
    topShimmer instanceof spriteStruct      ;Shimmer effect
    botShimmer instanceof spriteStruct      ;Shimmer effect
.ende

;==============================================================
; Clear Data
;==============================================================
    
    call ClearVRAM

    call ClearSATBuff

;==============================================================
; Load SFS Palettes
;==============================================================
;Write current BG palette to currentPalette struct
    ld hl, currentBGPal.color0
    ld de, FadedPalette
    ld b, $10
    call PalBufferWrite

;Write current SPR palette to currentPalette struct
    ld hl, currentSPRPal.color0
    ld de, FadedPalette
    ld b, $10
    call PalBufferWrite

;Write target BG palette to targetPalette struct
    ld hl, targetBGPal.color0
    ld de, SteelFingerBGPalette
    ld b, $10
    call PalBufferWrite

;Write target SPR palette to targetPalette struct
    ld hl, targetSPRPal.color0
    ld de, SteelFingerSPRPalette
    ld b, $10
    call PalBufferWrite

;Actually update the palettes in VRAM
    call LoadBackgroundPalette
    call LoadSpritePalette
    

;==============================================================
; Load SFS Tiles
;==============================================================
;Load SteelFginer Studios Screen
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, SteelFingerTiles
    ld bc, SteelFingerTilesEnd-SteelFingerTiles
    call CopyToVDP

;Load SteelFginer Studios Sprites
    ld hl, $2000 | VRAMWrite
    call SetVDPAddress
    ld hl, SteelFingerShimmerTiles
    ld bc, SteelFingerShimmerTilesEnd-SteelFingerShimmerTiles
    call CopyToVDP

;==============================================================
; Load SFS Map
;==============================================================

    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, SteelFingerStudiosMap
    ld bc, SteelFingerStudiosMapEnd-SteelFingerStudiosMap
    call CopyToVDP


;==============================================================
; Intialize our objects
;==============================================================
;Top Shimmer
    ld hl, topShimmer.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, topShimmer.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, topShimmer.height
    ld (hl), $01                        
    inc hl                              ;ld hl, topShimmer.yPos
    ld (hl), 62
    inc hl                              ;ld hl, topShimmer.xPos

    ld (hl), 1
    inc hl                              ;ld hl, topShimmer.cc
    ld (hl), $00

;Bottom Shimmer
    ld hl, botShimmer.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, botShimmer.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl
    ld (hl), $01                        ;ld hl, botShimmer.height
    inc hl                              ;ld hl, botShimmer.yPos
    ld (hl), 86
    inc hl                              ;ld hl, botShimmer.xPos
    ld (hl), 9
    inc hl                              ;ld hl, botShimmer.cc
    ld (hl), $00



;==============================================================
; Set HBlank
;==============================================================
    ld a, $FF                               ;$FF no interrupts
    ld c, $8A
    call UpdateVDPRegister

;==============================================================
; Turn on screen
;==============================================================
;Draw the SFS Shimmer
    ld hl, topShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB
    ld hl, botShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB

;Must manually call due to not wanting to update all strips every frame
    ;call EndSprites

;Update VRAM before display turns on
    call UpdateSAT

 ;Turn on screen (Maxim's explanation is too good not to use)
    ld a, %01100010
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Doubled sprites -> 2 tile per sprite, 8x16
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister
  
    
;==============================================================
; Game logic 
;==============================================================

;Fade screen in
    call FadeIn

SFSLoop:       ;This is the loop
    halt
;Prevent sprite scrambling if pause button is hit
    ld a,(VDPStatus)       ;Check if we are at VBlank
    or a
    jp p, SFSLoop               ;If not on VBlank, don't execute this code   

;Update Sprites
    call UpdateSAT
;Reset VBlank status
    ld hl, VDPStatus
    ld a, (hl)
    res 7, a
    ld (hl), a

;Draw the SFS Shimmer (In this case, all sprites)
    ld hl, topShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB
    ld hl, botShimmer.sprNum
    call MultiUpdateSATBuff             ;Our shimmers are 1x1, so they will work with the 8x8 MUSB
    ;call EndSprites


;Move shimmer across the screen
    ld hl, topShimmer.xPos

    ld a, (hl)
    add a, $03
    ld (hl), a
    ld hl, botShimmer.xPos
    ld a, (hl)
    add a, $03
    ld (hl), a

;Check if shimmer has wrapped around the screen
    ld a, (topShimmer.xPos)
    cp $00
    jr nz, +
;Complete scene
    ld hl, sceneComplete
    ld (hl), $01


;Shimmer hasn't wrapped yet, so scene isn't over   
+:
;Check if scene has finished
    ld a, (sceneComplete)
    cp $00
    jp z, +
    ld b, $2A
-:
    halt
    djnz -

    call FadeToBlack
    call BlankScreen
;Set up next screen for starting with 0 sprites
    ld hl, spriteCount
    ld (hl), $00

    ret


;Scene isn't finished, so loop
+:  
    
    jp SFSLoop     ;Keep us on the title screen





