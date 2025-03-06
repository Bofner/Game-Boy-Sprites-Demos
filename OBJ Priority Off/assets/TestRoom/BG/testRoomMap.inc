;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $1A00 $0101 $0302 $0103 $0F00 $0104 $0300 $0105 $0F00 $0104 $0300 $0105 $0106 $0107 $0108 $0109 
.DW $010A $0100 $010B $0800 $0104 $0300 $0105 $0F00 $010C $030D $010E $0F00 $0104 $030F $0105 $0F00 
.DW $0104 $030F $0105 $0106 $0107 $0108 $0109 $010A $0100 $0110 $0800 $0104 $030F $0105 $0F00 $010C 
.DW $030D $010E $0F00 $0104 $0311 $0105 $0F00 $0104 $0311 $0105 $0106 $0107 $0108 $0109 $010A $0100 
.DW $0112 $0800 $0104 $0311 $0105 $0F00 $010C $030D $010E $0F00 $0104 $0313 $0105 $0F00 $0104 $0313 
.DW $0105 $0106 $0107 $0108 $0109 $010A $0100 $0114 $0800 $0104 $0313 $0105 $0F00 $0115 $0316 $0117 
.DW $0900 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
