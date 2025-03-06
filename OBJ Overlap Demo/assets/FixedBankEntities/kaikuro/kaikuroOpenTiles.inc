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
.DB $00 $00 $00 $00 $00 $00 $24 $24 $7E $5A $C3 $BD $BD $FF $7E $C3 
.DB $7E $DB $BD $FF $C3 $BD $7E $5A $24 $24 $00 $00 $00 $00 $00 $00 