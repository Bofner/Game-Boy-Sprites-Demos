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
.DB $01 $01 $02 $03 $07 $05 $17 $14 $13 $12 $09 $09 $00 $07 $16 $1B 
.DB $09 $12 $12 $27 $25 $0B $11 $2B $05 $1B $01 $0B $01 $05 $00 $00 
.DB $C0 $C0 $20 $E0 $F0 $D0 $F4 $14 $E4 $24 $48 $C8 $80 $F0 $B4 $6C 
.DB $48 $A4 $A4 $F2 $52 $E8 $C4 $6A $50 $EC $C0 $E8 $40 $D0 $80 $80 