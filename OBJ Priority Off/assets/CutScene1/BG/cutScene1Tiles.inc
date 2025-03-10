;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111
;Size of uncompressed tile data:
.DW $0C70
;Raw tile data 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $04 $00 $00 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $04 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $40 $00 $00 $22 $45 $22 $04 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $0E $00 $0E $00 $0E $00 $18 $00 $1E $0E $71 $06 $69 
.DB $C2 $04 $02 $00 $0A $00 $08 $00 $00 $00 $01 $06 $01 $06 $01 $06 
.DB $00 $00 $00 $40 $00 $02 $00 $03 $00 $00 $00 $00 $80 $30 $80 $00 
.DB $00 $00 $00 $00 $00 $20 $00 $00 $04 $38 $04 $00 $00 $00 $00 $60 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $40 $80 $70 $00 $31 $40 
.DB $00 $00 $00 $00 $07 $00 $0B $14 $03 $1C $01 $06 $00 $00 $20 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $80 $00 $04 $00 $06 $18 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $01 $01 $0F $03 $0E $03 
.DB $00 $00 $02 $07 $13 $1F $31 $3F $E8 $FF $80 $FF $4C $FF $C4 $FF 
.DB $82 $FD $21 $FE $97 $F8 $98 $FF $0C $FF $08 $FF $21 $FE $12 $FF 
.DB $00 $80 $F0 $00 $24 $D8 $D0 $2E $7D $82 $FF $00 $CB $34 $40 $BF 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $80 $00 $C0 $00 $E0 $00 $F0 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $80 $00 $00 $00 $00 $00 $00 $00 
.DB $02 $00 $00 $00 $00 $04 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $06 $18 $07 $08 $02 $0C $00 $0E $00 $C2 $00 $40 $00 $00 $00 $00 
.DB $01 $02 $01 $02 $00 $00 $00 $00 $00 $00 $01 $0E $03 $8C $00 $0F 
.DB $80 $00 $80 $03 $00 $13 $08 $13 $0C $F0 $3C $C0 $0E $F0 $0E $01 
.DB $00 $20 $00 $80 $00 $80 $00 $80 $00 $00 $00 $00 $00 $07 $02 $0D 
.DB $30 $42 $00 $00 $00 $01 $00 $00 $00 $00 $1D $02 $07 $18 $07 $18 
.DB $20 $00 $C0 $00 $80 $00 $01 $04 $00 $06 $88 $07 $98 $04 $08 $80 
.DB $01 $38 $01 $30 $01 $20 $80 $01 $00 $01 $00 $00 $00 $00 $03 $00 
.DB $1F $17 $0F $0F $DF $1F $DF $1F $FF $3F $3F $3F $7F $7F $FF $7F 
.DB $FE $FF $FF $FF $FD $FF $FC $FF $FF $FF $FF $FF $FF $FF $FC $FF 
.DB $02 $FF $40 $FF $EA $FF $FB $FF $FF $FF $FF $FF $B7 $FF $0F $FF 
.DB $10 $FF $1E $F1 $4E $F9 $01 $FE $00 $FF $83 $FC $B1 $FE $98 $FF 
.DB $F8 $00 $38 $C0 $3C $C0 $7C $80 $76 $88 $32 $CC $03 $FC $21 $DE 
.DB $08 $07 $00 $00 $00 $00 $03 $04 $03 $04 $81 $06 $01 $06 $00 $00 
.DB $00 $00 $00 $00 $08 $00 $00 $00 $00 $80 $80 $00 $84 $40 $00 $00 
.DB $00 $06 $00 $0E $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $20 $00 $00 $00 $01 $00 $01 $00 $00 
.DB $01 $0E $00 $00 $00 $00 $00 $00 $00 $00 $00 $82 $00 $82 $00 $00 
.DB $0E $11 $0F $30 $0D $72 $1E $61 $18 $67 $00 $7F $00 $03 $00 $00 
.DB $02 $05 $00 $80 $C0 $2E $60 $86 $40 $A0 $40 $A0 $48 $80 $00 $00 
.DB $00 $00 $20 $00 $10 $00 $00 $00 $00 $00 $C0 $00 $00 $00 $02 $00 
.DB $01 $02 $01 $02 $81 $00 $00 $1C $00 $1C $19 $24 $19 $24 $1D $20 
.DB $FF $7F $FF $1F $FF $0F $7F $2F $FF $7F $FF $3F $FE $0E $FF $07 
.DB $F8 $FF $FE $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF $FF 
.DB $87 $FF $37 $FF $F7 $FF $FF $FF $F7 $FF $E5 $FF $FD $FF $FC $FF 
.DB $98 $FF $DE $FF $C0 $FF $C2 $FF $C2 $FF $D1 $FF $F1 $FF $FF $FF 
.DB $30 $CF $00 $FF $27 $F8 $E3 $FC $E3 $DC $E2 $DD $C0 $FF $20 $FF 
.DB $00 $00 $00 $00 $18 $00 $00 $01 $00 $01 $00 $01 $60 $01 $E0 $0C 
.DB $01 $06 $01 $06 $11 $06 $31 $46 $31 $C6 $70 $80 $70 $80 $E0 $00 
.DB $00 $00 $04 $00 $0E $00 $1F $00 $1F $00 $1F $00 $1F $00 $1F $00 
.DB $00 $00 $00 $00 $C0 $00 $22 $00 $DB $40 $E1 $20 $FA $10 $FD $08 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $80 $00 $C0 $00 $20 $00 
.DB $20 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $01 $00 $01 $00 $01 $40 $00 $00 $00 $00 $00 $00 $01 $00 $01 
.DB $00 $F8 $F0 $08 $F0 $0C $C0 $20 $00 $00 $00 $00 $00 $00 $00 $0C 
.DB $3D $00 $30 $00 $00 $00 $00 $00 $03 $04 $01 $1E $00 $1F $00 $1F 
.DB $FF $7F $FF $3F $7F $0F $FF $07 $FF $03 $FF $07 $FF $0F $E6 $04 
.DB $F7 $F7 $E1 $E1 $E7 $E0 $67 $60 $77 $70 $FF $FF $FB $FF $E2 $FE 
.DB $FE $FF $C6 $FF $FE $FF $FC $FF $FC $FF $C6 $E1 $8A $81 $1E $01 
.DB $3E $FF $7E $FF $BE $FF $FA $8F $BA $8F $9A $8F $B0 $BF $B2 $FF 
.DB $E0 $FE $C0 $FE $80 $FE $00 $F8 $00 $FC $03 $FC $02 $FC $10 $F8 
.DB $EF $10 $67 $18 $2F $10 $2C $10 $2C $10 $E0 $10 $00 $00 $00 $00 
.DB $00 $00 $00 $88 $80 $00 $00 $01 $00 $01 $00 $1D $00 $1C $00 $1C 
.DB $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $01 $00 $03 $00 
.DB $1F $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $80 $FF $00 
.DB $FE $00 $FF $4E $FE $0F $FF $0F $FF $0F $FF $0F $FF $27 $FF $13 
.DB $D0 $00 $60 $00 $B0 $00 $D8 $00 $F6 $80 $FA $C0 $ED $F0 $FF $F8 
.DB $00 $00 $00 $00 $00 $00 $40 $00 $20 $00 $00 $00 $40 $00 $84 $00 
.DB $00 $00 $01 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $0F $00 $07 $00 $07 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $E7 $00 $C7 $00 $01 $00 $00 $00 $18 $00 $08 $00 $00 $00 $00 $00 
.DB $FE $FE $FE $FE $FF $FF $3F $3F $1F $1F $07 $07 $00 $00 $00 $00 
.DB $1E $03 $1C $03 $3A $1F $A1 $BF $C4 $FF $15 $FC $75 $FC $00 $00 
.DB $BA $FF $5A $FF $50 $FF $44 $FB $86 $C9 $82 $40 $86 $C0 $34 $00 
.DB $10 $E0 $10 $80 $30 $00 $B0 $00 $90 $00 $F0 $00 $00 $00 $00 $00 
.DB $00 $00 $30 $08 $F0 $08 $F0 $09 $F3 $00 $03 $04 $03 $00 $E0 $18 
.DB $00 $01 $00 $03 $00 $00 $00 $80 $00 $3E $1C $02 $0C $12 $04 $1A 
.DB $03 $00 $03 $00 $03 $02 $03 $02 $01 $00 $11 $01 $00 $00 $02 $00 
.DB $FF $00 $FF $00 $FF $00 $FF $03 $FF $00 $FF $C1 $BF $81 $4F $0C 
.DB $FF $07 $FF $03 $FF $83 $FF $03 $FF $3E $FF $7F $FF $87 $FF $01 
.DB $FB $FC $FF $FE $FF $FE $FF $90 $FF $00 $FF $10 $FF $0C $FF $02 
.DB $C4 $00 $A0 $00 $50 $00 $B0 $00 $E8 $00 $F0 $00 $FC $00 $F8 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $03 $03 $04 $04 $05 $05 $06 $07 
.DB $00 $00 $00 $00 $00 $00 $E0 $A0 $FC $C0 $3F $C0 $3F $C0 $03 $FF 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $C0 $00 $E0 $E0 
.DB $18 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $00 $01 $00 $01 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $98 $06 $F8 $04 $D8 $20 $98 $60 $40 $21 $00 $00 $00 $00 $00 $00 
.DB $00 $1C $00 $1A $00 $2A $00 $7E $0C $F2 $0E $F0 $1C $02 $00 $00 
.DB $04 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $97 $07 $49 $01 $02 $00 $01 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $FF $80 $FF $C0 $FF $C0 $3F $00 $5F $1F $07 $01 $00 $00 $00 $00 
.DB $FF $00 $FF $00 $FF $00 $FF $18 $FF $E0 $FF $FF $FF $1F $00 $0F 
.DB $FC $00 $FD $00 $FE $00 $F9 $06 $E3 $1C $8C $F0 $3C $C0 $03 $F2 
.DB $00 $03 $F0 $F2 $7C $0E $94 $6F $03 $3F $47 $3F $FF $00 $FF $80 
.DB $04 $FC $01 $38 $04 $1C $04 $9C $85 $FD $82 $F1 $FF $00 $FF $00 
.DB $60 $60 $60 $20 $67 $20 $7B $60 $E0 $E0 $08 $FF $FF $03 $FF $03 
.DB $0C $00 $F0 $00 $19 $00 $FE $00 $01 $01 $FF $E4 $FF $F0 $FF $FC 
.DB $00 $00 $00 $00 $C0 $00 $00 $00 $80 $80 $F0 $30 $F0 $00 $E8 $00 
.DB $00 $00 $00 $00 $03 $03 $04 $04 $08 $08 $0E $0C $09 $08 $01 $09 
.DB $00 $3C $8C $C3 $A2 $8D $01 $38 $01 $60 $80 $80 $07 $07 $1F $18 
.DB $00 $00 $00 $0F $41 $8D $78 $89 $71 $81 $65 $85 $CD $0D $99 $09 
.DB $00 $00 $18 $E0 $FE $FC $05 $FE $80 $FF $82 $FD $82 $FD $82 $FD 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $80 $80 $80 $80 $C0 $80 
.DB $00 $00 $00 $00 $00 $00 $01 $01 $01 $01 $00 $03 $1E $1F $3F $3F 
.DB $00 $1E $13 $7C $0F $F1 $8F $AF $FC $87 $03 $9F $82 $C2 $C2 $F3 
.DB $01 $60 $8B $7A $BF $FA $6C $E8 $B9 $AF $70 $27 $DE $4F $BE $3F 
.DB $FF $20 $FF $60 $FF $80 $FF $88 $7F $82 $7F $81 $7F $80 $7F $90 
.DB $FF $00 $FF $00 $FF $00 $FF $03 $FF $00 $FF $00 $FF $C0 $FF $67 
.DB $FF $07 $FF $87 $FF $FE $FF $FE $FF $0E $FF $00 $FF $00 $FF $C0 
.DB $FF $FC $FF $FF $FF $1F $FF $07 $FF $07 $FF $80 $FF $01 $FF $03 
.DB $FC $00 $FE $00 $FC $00 $F8 $00 $F0 $00 $E0 $00 $F0 $80 $F0 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $01 $01 $01 $03 $03 $07 $03 $0F 
.DB $01 $19 $21 $3D $70 $7F $D0 $FF $D0 $FF $40 $FF $E1 $FF $A9 $FF 
.DB $0F $08 $02 $7C $00 $FC $00 $F9 $03 $E3 $F0 $F7 $F0 $DF $F1 $FE 
.DB $39 $09 $4B $3B $03 $FB $3B $FB $C3 $FF $00 $FF $01 $FE $C0 $3F 
.DB $82 $FD $82 $FD $80 $FF $82 $FD $80 $FF $80 $FF $FF $00 $00 $FF 
.DB $E0 $40 $E0 $60 $F0 $20 $F8 $F8 $FC $00 $FC $00 $FC $00 $04 $F8 
.DB $00 $00 $00 $00 $01 $01 $01 $01 $00 $03 $00 $02 $7C $7F $FD $E4 
.DB $7F $68 $FF $F9 $FF $FF $1F $1F $0F $EF $0F $4F $0E $8E $1E $9E 
.DB $C2 $72 $C3 $33 $83 $33 $C8 $30 $80 $30 $80 $80 $00 $00 $00 $00 
.DB $78 $BE $C0 $F0 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $67 $18 $33 $1C $1B $0E $0F $08 $27 $20 $0F $08 $07 $00 $02 $02 
.DB $FF $1F $FF $03 $FF $00 $FF $80 $FF $00 $FF $00 $FF $00 $FF $00 
.DB $FF $90 $FF $00 $FF $80 $FF $60 $FF $18 $FF $06 $FF $01 $FF $00 
.DB $FF $00 $FF $00 $FF $00 $FC $00 $F8 $00 $F8 $00 $FC $80 $FC $60 
.DB $E0 $00 $E0 $00 $80 $00 $00 $00 $00 $00 $00 $00 $04 $00 $00 $00 
.DB $0F $1F $0F $1F $1F $1F $1F $3F $1F $3F $1F $3F $3F $3F $3F $3F 
.DB $A8 $FF $F8 $FF $F4 $FF $D3 $FF $EA $FF $EC $FF $F9 $FE $F7 $F8 
.DB $E3 $FC $0F $F0 $1E $E1 $38 $C7 $68 $97 $C8 $37 $88 $77 $08 $F7 
.DB $FF $00 $FF $00 $FF $00 $7F $80 $7F $80 $7F $80 $9F $60 $6F $90 
.DB $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FD $01 $FA $08 
.DB $FA $04 $FE $00 $FE $00 $FE $18 $DE $18 $CE $C8 $A6 $88 $A2 $B8 
.DB $00 $00 $00 $00 $00 $00 $02 $02 $02 $02 $03 $03 $00 $01 $00 $01 
.DB $00 $00 $00 $00 $1E $1F $3F $3A $FF $E1 $BF $BF $1F $1F $1F $9F 
.DB $0F $E1 $0F $1F $0F $DF $8E $DE $8E $FE $00 $C0 $00 $80 $00 $80 
.DB $40 $A0 $00 $80 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $08 $00 $04 $00 $02 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $FF $80 $7F $40 $3F $30 $DB $19 $45 $01 $03 $03 $08 $00 $00 $00 
.DB $FF $00 $FF $00 $FF $00 $FF $00 $FF $20 $FF $1E $FF $81 $7F $40 
.DB $FE $78 $FF $18 $FF $0F $FF $10 $FC $20 $F8 $20 $F0 $E0 $80 $80 
.DB $1F $3F $1F $3F $1E $3F $1D $3E $13 $3C $05 $1F $06 $1F $07 $1F 
.DB $EE $F1 $D8 $E7 $70 $8F $F8 $07 $FF $00 $FE $FE $FC $DC $8D $FC 
.DB $08 $F7 $09 $F6 $0B $F4 $1F $E0 $FF $03 $7C $64 $BC $24 $BD $24 
.DB $6F $90 $6F $90 $FF $07 $F0 $70 $F4 $F0 $36 $30 $B0 $30 $BE $3F 
.DB $FB $08 $F8 $48 $FF $CF $FE $CF $FA $CF $F1 $CF $83 $FF $3F $CF 
.DB $E8 $F8 $D8 $F8 $30 $F0 $60 $E0 $60 $E0 $C0 $C0 $80 $80 $80 $80 
.DB $0C $0C $0E $0E $0C $0E $0A $0E $06 $06 $00 $07 $04 $00 $00 $00 
.DB $0E $5F $02 $CA $40 $00 $40 $40 $60 $60 $40 $40 $40 $40 $40 $40 
.DB $1E $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $20 $00 $00 $00 
.DB $07 $0F $03 $0F $03 $0F $00 $07 $00 $03 $00 $00 $00 $00 $00 $00 
.DB $F0 $FE $FE $FF $FF $FF $FF $FF $3F $FF $3F $3F $07 $07 $00 $00 
.DB $34 $2C $F7 $EF $D0 $EF $F7 $EF $E7 $FF $F7 $FF $F7 $FF $30 $38 
.DB $38 $3F $E3 $FF $FF $FF $FF $FF $FF $FF $FE $FE $E0 $E0 $00 $00 
.DB $7E $EE $F8 $E8 $F0 $E0 $E0 $E0 $C0 $C0 $00 $00 $00 $00 $00 $00 
.DB $FF $FF $FF $80 $FF $BF $F0 $B0 $E0 $A0 $E0 $A0 $E0 $A1 $E0 $A1 
.DB $FF $FF $FF $00 $FF $FF $00 $00 $00 $40 $00 $C0 $00 $C0 $00 $E0 
.DB $FF $FF $FF $00 $FF $FF $00 $00 $00 $02 $00 $03 $00 $07 $00 $07 
.DB $FF $FF $FF $01 $FF $FD $0F $0D $07 $05 $07 $05 $07 $85 $07 $85 
.DB $FF $FF $FF $80 $FF $BF $F0 $BF $E0 $BF $E0 $BF $E0 $BF $E0 $BF 
.DB $FF $FF $FF $00 $FF $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF 
.DB $FF $FF $FF $01 $FF $FD $0F $FD $07 $FD $07 $FD $07 $FD $07 $FD 
.DB $E0 $A3 $E0 $A3 $E0 $A7 $E1 $A7 $E1 $AE $E2 $AE $E3 $AE $E3 $AE 
.DB $00 $E0 $70 $F0 $D8 $98 $B8 $08 $69 $09 $CB $0E $9E $0E $3F $1E 
.DB $00 $0F $00 $0F $78 $7F $DC $9F $BE $0F $6E $0F $CE $07 $9F $07 
.DB $07 $85 $07 $C5 $07 $C5 $07 $C5 $07 $C5 $07 $E5 $07 $E5 $07 $F5 
.DB $E0 $BF $E0 $BF $E0 $BF $E0 $BF $E0 $BF $E0 $BF $E0 $BF $E0 $BF 
.DB $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF 
.DB $00 $FF $3E $C1 $7E $81 $66 $81 $7C $81 $66 $81 $7E $81 $00 $81 
.DB $00 $FF $3C $C3 $7E $81 $66 $81 $7E $81 $7E $81 $66 $81 $00 $99 
.DB $00 $FF $3C $C3 $7E $81 $66 $81 $7C $81 $7E $81 $66 $81 $00 $99 
.DB $00 $FF $26 $D9 $6E $91 $7C $81 $7C $83 $6E $81 $66 $91 $00 $99 
.DB $00 $FF $08 $F7 $18 $E7 $18 $E7 $18 $E7 $00 $E7 $18 $E7 $00 $E7 
.DB $07 $FD $07 $FD $07 $FD $07 $FD $07 $FD $07 $FD $07 $FD $07 $FD 
.DB $E7 $AF $EF $AF $ED $AF $E5 $A7 $E3 $A7 $E1 $A7 $E1 $A7 $E1 $A7 
.DB $7F $3E $FF $73 $FF $E1 $BF $C0 $FF $C0 $DD $E3 $D9 $67 $DB $E7 
.DB $3F $0F $FF $1F $FB $3F $F3 $FF $09 $FF $C0 $FF $F0 $FF $E0 $7F 
.DB $87 $F5 $87 $F5 $C7 $E5 $E7 $E5 $E7 $E5 $E7 $E5 $47 $C5 $07 $85 
.DB $00 $FF $3F $C0 $7F $80 $FF $00 $F0 $00 $E0 $0F $E0 $1F $E0 $1F 
.DB $00 $FF $F8 $07 $FC $03 $FE $01 $0F $00 $07 $F0 $07 $F8 $07 $F8 
.DB $00 $FF $C0 $3F $E0 $1F $70 $0F $38 $87 $18 $C7 $00 $E7 $00 $FF 
.DB $00 $FF $00 $FF $0C $F3 $1C $E3 $1C $E3 $1C $E3 $3C $C3 $7C $83 
.DB $00 $FF $01 $FE $03 $FC $03 $FC $07 $F8 $07 $F8 $07 $F8 $07 $F8 
.DB $00 $FF $80 $7F $C0 $3F $C0 $3F $E0 $1F $E0 $1F $E0 $1F $E0 $1F 
.DB $E1 $A3 $E2 $A1 $E1 $A2 $E3 $A0 $E3 $A1 $E3 $A1 $E3 $A0 $E1 $A0 
.DB $B3 $CF $F3 $8F $FB $07 $FC $C3 $FE $E1 $FF $E0 $FF $C4 $FF $4C 
.DB $E0 $FF $C0 $FF $28 $D7 $50 $AF $00 $FF $00 $FE $80 $7C $00 $F0 
.DB $07 $85 $07 $85 $07 $05 $07 $05 $07 $05 $07 $05 $07 $05 $07 $05 
.DB $00 $1F $00 $FF $00 $FF $00 $FF $07 $F8 $07 $F8 $07 $F8 $00 $F8 
.DB $07 $F8 $0F $F0 $1E $E0 $3C $C1 $F8 $03 $F0 $07 $E0 $0F $00 $1F 
.DB $00 $FF $01 $FE $03 $FC $07 $F8 $7F $80 $FE $00 $FC $01 $00 $03 
.DB $F8 $03 $F0 $07 $E0 $0F $C0 $1F $00 $3F $00 $FF $00 $FF $00 $FF 
.DB $07 $F8 $07 $F8 $03 $F8 $01 $FC $00 $FE $03 $FC $01 $FC $00 $FE 
.DB $E0 $1F $E0 $1F $C0 $1F $80 $3F $00 $7F $C0 $3F $80 $3F $00 $7F 
.DB $E1 $A0 $E0 $A0 $E1 $A0 $E3 $A0 $F3 $B0 $FF $BF $FF $80 $FF $FF 
.DB $FE $F1 $F8 $07 $E0 $DF $F0 $CF $FC $C3 $FF $FF $FF $00 $FF $FF 
.DB $00 $E0 $18 $E0 $0F $F3 $1F $E3 $7F $87 $FF $FF $FF $00 $FF $FF 
.DB $07 $05 $07 $05 $87 $05 $C7 $05 $CF $0D $FF $FD $FF $01 $FF $FF 
.DB $E0 $BF $E0 $BF $E0 $BF $E0 $BF $F0 $BF $FF $BF $FF $80 $FF $FF 
.DB $00 $FF $00 $FF $00 $FF $00 $FF $00 $FF $FF $FF $FF $00 $FF $FF 
.DB $07 $FD $07 $FD $07 $FD $07 $FD $0F $FD $FF $FD $FF $01 $FF $FF 