;================================================================
; Level Template
;================================================================
LevelTemplate:

;==============================================================
; Scene beginning
;==============================================================
    ld hl, sceneComplete
    ld (hl), $00

    inc hl                                  ;ld hl, sceneID
    ld (hl), $03

;Switch to correct bank for SFS Assets
    ld a, LevelBank
    ld ($FFFF), a

;Start off with no sprites
    ld hl, spriteCount
    ld (hl), $00

;==============================================================
; Memory (Structures, Variables & Constants) 
;==============================================================

;Structures and Variables
.enum postBoiler export
    ;nada db
    one instanceof spriteStruct
    two instanceof spriteStruct
    three instanceof spriteStruct
    four instanceof spriteStruct
    five instanceof spriteStruct
    six instanceof spriteStruct
    seven instanceof spriteStruct
    eight instanceof spriteStruct
    nine instanceof spriteStruct
.ende

;Constants
.define SPRITEYPOS     $40


;==============================================================
; Clear VRAM
;==============================================================
    call BlankScreen

    call ClearVRAM

    call ClearSATBuff


;==============================================================
; Load Palette
;==============================================================
;All black palette to be used once we are making things pretty
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
    ld de, demoBackgroundPalette
    ld b, $10
    call PalBufferWrite


;Write target SPR palette to targetPalette struct
    ld hl, targetSPRPal.color0
    ld de, spritePalette
    ld b, $10
    call PalBufferWrite


;Actually update the palettes in VRAM
    call LoadBackgroundPalette
    call LoadSpritePalette

;==============================================================
; Load BG tiles 
;==============================================================
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ld hl, demoBackgroundTiles
    ld bc, demoBackgroundTilesEnd-demoBackgroundTiles
    call CopyToVDP



;==============================================================
; Write background map
;==============================================================
    ld hl, $3800 | VRAMWrite
    call SetVDPAddress
    ld hl, demoBackgroundMap
    ld bc, demoBackgroundMapEnd-demoBackgroundMap
    call CopyToVDP


;==============================================================
; Load Sprite tiles 
;==============================================================
    
    ld hl, $2000 | VRAMWrite
    call SetVDPAddress
    ld hl, OneTiles
    ld bc, NineTilesEnd-OneTiles
    call CopyToVDP

;==============================================================
; Intialize our Variables
;==============================================================
    xor a
    
;Boilers
    ld hl, scrollX0          ;Set horizontal scroll to zero
    ld (hl), a              ;

    ld hl, scrollY          ;Set vertical scroll to zero
    ld (hl), a              ;

    ld hl, frameCount       ;Set frame count to 0
    ld (hl), a              ;   


;==============================================================
; Intialize our objects
;==============================================================

 call InitSprites

;==============================================================
; Set Registers for HBlank
;==============================================================

    ld a, $FF                               ;$07 = HBlank every 8 scanlines
    ld c, $8A
    call UpdateVDPRegister

;Blank Left Column
    ld a, %00010100                         ;BIT 5 BLANK column
    ld c, $80
    call UpdateVDPRegister

;=============================================================
; Set Scene
;=============================================================
    ld hl, sceneID
    ld (hl), $02


;==============================================================
; Turn on screen
;==============================================================
 ;(Maxim's explanation is too good not to use)
    ld a, %01100010
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Doubled sprites -> 8x16
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister

    ei

;========================================================
; Game Logic
;========================================================

    ld hl, one.sprNum
    call MultiUpdateSATBuff
    ld hl, two.sprNum
    call MultiUpdateSATBuff
    ld hl, three.sprNum
    call MultiUpdateSATBuff
    ld hl, four.sprNum
    call MultiUpdateSATBuff
    ld hl, five.sprNum
    call MultiUpdateSATBuff
    ld hl, six.sprNum
    call MultiUpdateSATBuff
    ld hl, seven.sprNum
    call MultiUpdateSATBuff
    ld hl, eight.sprNum
    call MultiUpdateSATBuff

    ld hl, nine.sprNum
    call MultiUpdateSATBuff

    halt
    call UpdateSAT

    call FadeIn

LevelLoop:
;Start LOOP
    halt
;Update SAT after VBLANK
    call UpdateSAT

;Update the rest of the numbers
    ld hl, one.sprNum
    call MultiUpdateSATBuff
    ld hl, two.sprNum
    call MultiUpdateSATBuff
    ld hl, three.sprNum
    call MultiUpdateSATBuff
    ld hl, four.sprNum
    call MultiUpdateSATBuff
    ld hl, five.sprNum
    call MultiUpdateSATBuff
    ld hl, six.sprNum
    call MultiUpdateSATBuff
    ld hl, seven.sprNum
    call MultiUpdateSATBuff
    ld hl, eight.sprNum
    call MultiUpdateSATBuff

;Update sprite 9
    ld hl, nine.sprNum
    call MultiUpdateSATBuff

;Check to see if Up or Down is pressed
    call XX_InputCheck
    
    

;End Loop
    jp LevelLoop


InitSprites:
;One
    ld hl, one.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 10
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $00
;Two
    ld hl, two.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 40
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $02
;3
    ld hl, three.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 70
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $04
;4
    ld hl, four.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 100
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $06
;5
    ld hl, five.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 130
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $08
;6
    ld hl, six.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 160
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $0A
;7
    ld hl, seven.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 190
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $0C
;8
    ld hl, eight.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), SPRITEYPOS
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 220
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $0E
;9
    ld hl, nine.sprNum
    inc hl                              ;ld hl, spriteSize
    ld (hl), $10                        ;8x16
    inc hl                              ;ld hl, sprite.width
    ;Sprite is 1x1 for 8x16
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.height
    ld (hl), $01                        
    inc hl                              ;ld hl, sprite.yPos
    ld (hl), 100
    inc hl                              ;ld hl, sprite.xPos
    ld (hl), 100
    inc hl                              ;ld hl, sprite.cc
    ld (hl), $10

    ret

