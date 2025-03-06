;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $2900 $0101 $0102 $0103 $0104 $0105 $0106 $0100 $0107 $0100 $0108 $0100 $0109 $0100 $0104 $010A 
.DW $0106 $010B $0300 $010C $010D $010E $010F $010C $0110 $0100 $0111 $0100 $0112 $0100 $0110 $0100 
.DW $0113 $0114 $0115 $0113 $FF00 $1B00 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
