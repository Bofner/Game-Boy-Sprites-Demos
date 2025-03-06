;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $B500 $0101 $0102 $0103 $0104 $0105 $0106 $0100 $0107 $0106 $0108 $0206 $0109 $0700 $010A $010B 
.DW $010C $010D $010E $010F $0100 $0110 $0111 $0112 $0111 $010F $0113 $1B00 $0114 $0115 $0100 $0116 
.DW $0104 $0116 $0100 $0205 $0117 $0118 $0107 $0106 $0118 $0104 $0500 $0119 $011A $0100 $011B $010D 
.DW $011C $0100 $011D $010E $011E $011F $0110 $0111 $011F $010D $5400 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
