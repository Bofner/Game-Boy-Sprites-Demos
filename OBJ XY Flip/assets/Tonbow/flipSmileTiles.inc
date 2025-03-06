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
.DB $3A $3A $22 $22 $32 $32 $23 $23 $00 $00 $07 $07 $0F $08 $1F $10 
.DB $3F $24 $3F $2A $3F $20 $38 $27 $38 $27 $1C $13 $0F $08 $07 $07 
.DB $5C $5C $54 $54 $5C $5C $50 $50 $00 $00 $E0 $E0 $F0 $10 $F8 $08 
.DB $FC $24 $FC $54 $FC $04 $1C $E4 $1C $E4 $38 $C8 $F0 $10 $E0 $E0 