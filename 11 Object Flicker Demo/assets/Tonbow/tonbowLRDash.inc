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
.DB $00 $00 $00 $00 $04 $0A $0A $11 $01 $3C $14 $42 $02 $3F $7D $7E 
.DB $AA $F7 $7D $7E $02 $3F $14 $42 $01 $3C $0A $11 $04 $0A $00 $00 
.DB $00 $00 $00 $00 $00 $00 $98 $98 $20 $A0 $8C $4C $9E $D2 $3D $E7 
.DB $DD $67 $3D $E7 $9E $D2 $8C $4C $20 $A0 $98 $98 $00 $00 $00 $00 