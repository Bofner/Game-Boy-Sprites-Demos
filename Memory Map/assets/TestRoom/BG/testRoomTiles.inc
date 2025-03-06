;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $01D0
;Raw tile data 
.DB $FF $FF $EB $C0 $97 $80 $AA $80 $85 $80 $8A $80 $81 $80 $82 $80 
.DB $FF $FF $FF $00 $FF $00 $FF $00 $FF $00 $BF $00 $7F $00 $AF $00 
.DB $FF $FF $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 
.DB $FF $FF $FF $00 $83 $00 $99 $18 $99 $00 $99 $00 $83 $02 $FF $7C 
.DB $FF $FF $FF $00 $C3 $00 $99 $18 $99 $00 $81 $00 $99 $18 $FF $66 
.DB $FF $FF $FF $00 $C3 $00 $CF $0C $E7 $20 $F3 $10 $C3 $00 $FF $3C 
.DB $FF $FF $FF $00 $99 $00 $99 $00 $81 $00 $99 $18 $99 $00 $FF $66 
.DB $FF $FF $FF $00 $81 $00 $E7 $66 $E7 $00 $E7 $00 $E7 $00 $FF $18 
.DB $FF $FF $FF $00 $83 $00 $9F $1C $87 $00 $9F $18 $83 $00 $FF $7C 
.DB $FF $FF $FF $00 $FF $00 $FF $0C $F3 $1E $E1 $3F $E0 $3F $E0 $3F 
.DB $FF $FF $FF $00 $FF $00 $FF $30 $CF $78 $87 $FC $07 $FC $07 $FC 
.DB $FF $FF $FF $03 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 
.DB $80 $80 $80 $80 $80 $80 $80 $80 $80 $80 $80 $80 $C0 $C0 $FF $FF 
.DB $5F $00 $AB $00 $17 $00 $2A $00 $05 $00 $0A $00 $01 $00 $FF $FF 
.DB $FF $00 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $00 $FF $FF 
.DB $FF $00 $FF $FF $00 $FF $00 $FF $00 $FF $FF $FF $FF $00 $FF $FF 
.DB $FF $00 $FF $80 $FF $80 $FF $80 $FF $80 $FF $80 $FF $00 $FF $FF 
.DB $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $FF 
.DB $FF $00 $83 $00 $99 $18 $99 $00 $83 $02 $99 $18 $FF $66 $FF $FF 
.DB $FF $00 $C3 $00 $99 $18 $99 $00 $99 $00 $C3 $42 $FF $3C $FF $FF 
.DB $FF $00 $BB $00 $93 $00 $83 $00 $AB $28 $AB $00 $FF $54 $FF $FF 
.DB $F0 $1F $F8 $0F $FC $07 $FE $03 $FF $01 $FF $00 $FF $00 $FF $FF 
.DB $0F $F8 $1F $F0 $3F $E0 $7F $C0 $FF $80 $FF $00 $FF $00 $FF $FF 
.DB $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $03 $FF $FF 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $04 $00 $04 $04 $00 $00 $00 
.DB $00 $00 $00 $00 $00 $20 $00 $20 $20 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $00 $40 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $04 $00 $00 $00 $00 $00 $00 $00 