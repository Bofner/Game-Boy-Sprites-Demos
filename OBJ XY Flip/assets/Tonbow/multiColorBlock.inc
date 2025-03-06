;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %10001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $1100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $02FF 
.DW $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $01FF $0100 $10FF 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
