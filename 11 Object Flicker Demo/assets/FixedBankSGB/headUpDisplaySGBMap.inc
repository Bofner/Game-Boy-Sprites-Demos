;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $0100 $0101 $0102 $0103 $0104 $0105 $0106 $0202 $0107 $0108 $0105 $0107 $0202 $0109 $010A $0109 
.DW $010A $010B $010C $010D $010E $040F $0110 $0111 $0112 $0213 $0114 $0211 $0115 $0116 $0115 $0116 
.DW $0117 $FF18 $4118 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
