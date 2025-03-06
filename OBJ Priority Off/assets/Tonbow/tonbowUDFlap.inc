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
.DB $01 $01 $02 $03 $07 $05 $07 $04 $13 $2A $29 $45 $14 $43 $2A $41 
.DB $17 $42 $2A $41 $15 $43 $29 $45 $01 $39 $01 $01 $01 $01 $00 $00 
.DB $C0 $C0 $20 $E0 $F0 $D0 $F0 $10 $E4 $2A $4A $D1 $94 $E1 $AA $41 
.DB $74 $A1 $AA $C1 $54 $E1 $CA $51 $40 $CE $C0 $C0 $40 $C0 $80 $80 