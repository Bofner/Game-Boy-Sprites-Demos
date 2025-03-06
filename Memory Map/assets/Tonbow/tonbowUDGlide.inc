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
.DB $01 $01 $02 $03 $07 $05 $07 $04 $03 $02 $11 $2F $2A $41 $00 $7F 
.DB $0B $16 $14 $23 $01 $3D $01 $01 $01 $01 $01 $01 $01 $01 $00 $00 
.DB $C0 $C0 $20 $E0 $F0 $D0 $F0 $10 $E0 $20 $44 $FA $AA $C1 $80 $7F 
.DB $68 $B4 $94 $E2 $40 $DE $C0 $40 $40 $C0 $C0 $C0 $40 $C0 $80 $80 