;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $1400 $0101 $0102 $0103 $0104 $0105 $0106 $0100 $0107 $0108 $0106 $0101 $0108 $0206 $0109 $010A 
.DW $0101 $010B $0200 $010C $010D $010E $010F $010C $0110 $0100 $0111 $0112 $0113 $010C $0112 $0113 
.DW $0210 $010A $010C $0114 $6A00 $0115 $0116 $0117 $0F00 $0118 $0119 $011A $011B $011C $0F00 $011D 
.DW $011E $011F $0120 $1000 $0121 $0122 $0123 $1100 $0124 $7500 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
