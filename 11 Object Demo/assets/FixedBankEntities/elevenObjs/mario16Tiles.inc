;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $0080
;Raw tile data 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $01 $01 $07 $06 $0F $08 
.DB $1D $13 $33 $2F $2D $3E $7B $7C $9B $FC $9C $FF $89 $FF $63 $7F 
.DB $30 $3F $3C $3F $7F $4F $FC $87 $F8 $8F $F8 $8F $9C $E7 $43 $7F 
.DB $7F $7F $7F $7F $7F $7F $3F $3F $3F $3F $47 $79 $41 $7E $7F $7F 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $E0 $E0 $F0 $10 $18 $E8 
.DB $FC $FC $FE $FE $BC $4C $B8 $E8 $B8 $E8 $7C $84 $04 $FC $FC $FC 
.DB $F8 $F8 $10 $F0 $F0 $F0 $7C $DC $3A $EE $3A $FE $7A $DE $FC $9C 
.DB $F8 $F8 $F0 $F0 $B0 $F0 $60 $E0 $E0 $E0 $70 $90 $98 $E8 $F8 $F8 