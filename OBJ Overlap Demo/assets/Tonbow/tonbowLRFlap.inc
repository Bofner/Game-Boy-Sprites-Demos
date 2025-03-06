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
.DB $00 $00 $00 $0F $0A $10 $05 $10 $0A $10 $05 $08 $03 $05 $7D $7E 
.DB $AA $F7 $7D $7E $03 $05 $05 $08 $0A $10 $05 $10 $0A $10 $00 $0F 
.DB $00 $00 $00 $E0 $A0 $10 $50 $00 $A0 $10 $4C $2C $9E $52 $3D $E7 
.DB $DD $67 $3D $E7 $9E $52 $4C $2C $A0 $10 $50 $00 $A0 $10 $00 $E0 