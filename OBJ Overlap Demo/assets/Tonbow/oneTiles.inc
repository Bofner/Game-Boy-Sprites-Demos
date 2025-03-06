;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $0010
;Raw tile data 
.DB $7E $7E $FF $FF $FF $F7 $FF $E7 $FF $F7 $FF $F7 $FF $E3 $7E $7E 