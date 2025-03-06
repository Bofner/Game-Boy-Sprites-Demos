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
.DB $00 $00 $01 $01 $0A $0A $00 $0F $1F $0A $03 $2D $04 $33 $12 $2F 
.DB $03 $2B $07 $15 $0A $0E $1C $1D $28 $3A $30 $31 $00 $00 $00 $00 
.DB $00 $00 $38 $38 $74 $5C $7A $4E $7E $C6 $5E $E2 $FC $3C $40 $B0 
.DB $32 $EA $B4 $DC $50 $A8 $14 $BC $90 $40 $00 $E0 $00 $00 $00 $00 