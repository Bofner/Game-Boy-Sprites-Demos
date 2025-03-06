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
.DB $00 $00 $00 $00 $00 $06 $02 $05 $01 $04 $02 $05 $01 $03 $7D $7E 
.DB $AA $F7 $7D $7E $01 $03 $02 $05 $01 $04 $02 $05 $00 $06 $00 $00 
.DB $00 $00 $00 $C0 $40 $A0 $20 $80 $40 $A0 $0C $AC $5E $B2 $3D $E7 
.DB $DD $67 $3D $E7 $5E $B2 $0C $AC $40 $A0 $20 $80 $40 $A0 $00 $C0 