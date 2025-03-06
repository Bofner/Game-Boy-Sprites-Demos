;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $0040
;Raw tile data 
.DB $00 $00 $00 $0E $02 $09 $01 $04 $04 $1A $08 $13 $05 $09 $02 $05 
.DB $03 $03 $07 $05 $0A $0E $1C $1C $28 $38 $30 $30 $00 $00 $00 $00 
.DB $00 $00 $38 $38 $74 $5C $7A $CE $FE $46 $5E $E2 $FC $3C $50 $A8 
.DB $48 $E4 $84 $72 $50 $8A $20 $56 $00 $30 $00 $00 $00 $00 $00 $00 