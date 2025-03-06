;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $A500 $0101 $0102 $0103 $0101 $0100 $0104 $0205 $0106 $0B00 $0107 $0108 $0109 $0107 $0100 $010A 
.DW $0209 $010B $A600 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
