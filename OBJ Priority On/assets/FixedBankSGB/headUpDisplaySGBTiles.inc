;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $0190
;Raw tile data 
.DB $FF $FF $D4 $EB $E8 $97 $D5 $AA $FA $85 $F5 $8A $FE $81 $FD $82 
.DB $FF $FF $00 $FF $00 $FF $00 $FF $00 $FF $40 $BF $80 $7F $50 $AF 
.DB $FF $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF 
.DB $FF $FF $00 $FF $7C $83 $7E $99 $66 $99 $66 $99 $7E $83 $7C $FF 
.DB $FF $FF $00 $FF $3C $C3 $7E $99 $66 $99 $7E $81 $7E $99 $66 $FF 
.DB $FF $FF $00 $FF $3C $C3 $3C $CF $38 $E7 $1C $F3 $3C $C3 $3C $FF 
.DB $FF $FF $00 $FF $66 $99 $66 $99 $7E $81 $7E $99 $66 $99 $66 $FF 
.DB $FF $FF $00 $FF $7E $81 $7E $E7 $18 $E7 $18 $E7 $18 $E7 $18 $FF 
.DB $FF $FF $00 $FF $7C $83 $7C $9F $78 $87 $78 $9F $7C $83 $7C $FF 
.DB $FF $FF $00 $FF $00 $FF $0C $FF $12 $F3 $21 $E1 $20 $E0 $20 $E0 
.DB $FF $FF $00 $FF $00 $FF $30 $FF $48 $CF $84 $87 $04 $07 $04 $07 
.DB $FF $FF $03 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF 
.DB $FF $80 $FF $80 $FF $80 $FF $80 $FF $80 $FF $80 $FF $C0 $FF $FF 
.DB $A0 $5F $54 $AB $E8 $17 $D5 $2A $FA $05 $F5 $0A $FE $01 $FF $FF 
.DB $00 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $80 $7F $FF $FF 
.DB $00 $FF $FF $FF $00 $00 $00 $00 $00 $00 $FF $FF $00 $FF $FF $FF 
.DB $00 $FF $80 $FF $80 $FF $80 $FF $80 $FF $80 $FF $00 $FF $FF $FF 
.DB $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $FF $FF 
.DB $00 $FF $7C $83 $7E $99 $66 $99 $7E $83 $7E $99 $66 $FF $FF $FF 
.DB $00 $FF $3C $C3 $7E $99 $66 $99 $66 $99 $7E $C3 $3C $FF $FF $FF 
.DB $00 $FF $44 $BB $6C $93 $7C $83 $7C $AB $54 $AB $54 $FF $FF $FF 
.DB $10 $F0 $08 $F8 $04 $FC $02 $FE $01 $FF $00 $FF $00 $FF $FF $FF 
.DB $08 $0F $10 $1F $20 $3F $40 $7F $80 $FF $00 $FF $00 $FF $FF $FF 
.DB $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $01 $FF $03 $FF $FF $FF 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 