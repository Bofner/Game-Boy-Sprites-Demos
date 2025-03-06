
;============================================================================================
; Constant Data
;============================================================================================
;BANK defines for easy switching around and readability
.define     SFSBank                 $0002
.define     LevelBank               $0003

;Data for an all black palette
FadedPalette:
    .db $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
FadedPaletteEnd:

; There are 11 registers, so 11 data
VDPInitData:
              .db %00010100             ; reg. 0

              .db %10100000             ; reg. 1

              .db $ff                   ; reg. 2, Name table at $3800

              .db $ff                   ; reg. 3 Always set to $ff

              .db $ff                   ; reg. 4 Always set to $ff

              .db $ff                   ; reg. 5 Address for SAT, $ff = SAT at $3f00 

              .db $ff                   ; reg. 6 Base address for sprite patterns

              .db $f0                   ; reg. 7 Overrscan Color at Sprite Palette 1   

              .db $00                   ; reg. 8 Horizontal Scroll

              .db $00                   ; reg. 9 Vertical Scroll

              .db $ff                   ; reg. 10 Raster line interrupt off
VDPInitDataEnd:


;============================================================================================
; STEELFINGER STUDIOS
;============================================================================================
.bank SFSBank
.org $0000
;========================================================
; Background
;========================================================
SteelFingerBGPalette:
    .include "..\\assets\\palettes\\backgrounds\\steelFinger_bgPal.inc"
SteelFingerBGPaletteEnd:
;----------------
; BG Tiles
;----------------
SteelFingerTiles:
    .include "..\\assets\\tiles\\backgrounds\\steelFingerStudios_tiles.inc"
SteelFingerTilesEnd:
;----------------
; BG Maps
;----------------
SteelFingerStudiosMap:
    .include "..\\assets\\maps\\steelFingerStudios_map.inc"
SteelFingerStudiosMapEnd:
;========================================================
; Sprites
;========================================================
SteelFingerSPRPalette:
    .include "..\\assets\\palettes\\sprites\\steelFinger_SprPal.inc"
SteelFingerSPRPaletteEnd:
;----------------
; Shimmer
;----------------
SteelFingerShimmerTiles:
    .include "..\\assets\\tiles\\sprites\\sfsShimmer\\sfsShimmer_tiles.inc" 
SteelFingerShimmerTilesEnd:


;============================================================================================
; Level Data
;============================================================================================
.bank LevelBank
.org $0000
;========================================================
; Background
;========================================================
;----------------
; Palettes
;----------------
demoBackgroundPalette:
    .include "..\\assets\\palettes\\backgrounds\\demoBackground.inc"
demoBackgroundPaletteEnd:

;----------------
; BG Tiles
;----------------
demoBackgroundTiles:
    .include "..\\assets\\tiles\\backgrounds\\demoBackground.inc"
demoBackgroundTilesEnd:

;----------------
; BG Maps
;----------------
demoBackgroundMap:
    .include "..\\assets\\maps\\demoBackground.inc"
demoBackgroundMapEnd:

;========================================================
; Sprite
;========================================================
;----------------
; Palette
;----------------
spritePalette:
    .include "..\\assets\\palettes\\sprites\\sprites.inc"
spritePaletteEnd:
;----------------
; Sprites
;----------------
OneTiles:
    .include "..\\assets\\tiles\\sprites\\one.inc" 
OneTilesEnd:
TwoTiles:
    .include "..\\assets\\tiles\\sprites\\two.inc" 
TwoTilesEnd:
ThreeTiles:
    .include "..\\assets\\tiles\\sprites\\three.inc" 
ThreeTilesEnd:
FourTiles:
    .include "..\\assets\\tiles\\sprites\\four.inc" 
FourTilesEnd:
FiveTiles:
    .include "..\\assets\\tiles\\sprites\\five.inc" 
FiveTilesEnd:
SixTiles:
    .include "..\\assets\\tiles\\sprites\\six.inc" 
SixTilesEnd:
SevenTiles:
    .include "..\\assets\\tiles\\sprites\\seven.inc" 
SevenTilesEnd:
EightTiles:
    .include "..\\assets\\tiles\\sprites\\eight.inc" 
EightTilesEnd:
NineTiles:
    .include "..\\assets\\tiles\\sprites\\nine.inc" 
NineTilesEnd:


