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
.DB $00 $0F $05 $10 $0A $20 $15 $20 $0A $20 $15 $20 $0B $11 $00 $0F 
.DB $03 $03 $07 $05 $0A $0E $1C $1C $28 $38 $30 $30 $00 $00 $00 $00 
.DB $00 $00 $38 $B8 $74 $DC $7A $CE $7E $C6 $5E $E2 $FC $3C $40 $BE 
.DB $6A $C1 $54 $81 $2A $81 $54 $81 $28 $42 $00 $3C $00 $00 $00 $00 