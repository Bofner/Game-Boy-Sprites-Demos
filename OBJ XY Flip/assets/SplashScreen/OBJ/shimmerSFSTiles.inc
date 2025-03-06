;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111
;Size of uncompressed tile data:
.DW $0020
;Raw tile data 
.DB $80 $00 $80 $00 $40 $00 $40 $00 $20 $00 $20 $00 $10 $00 $10 
.DB $00 $08 $00 $08 $00 $04 $00 $04 $00 $02 $00 $02 $00 $01 $00 
.DB $01 $00 