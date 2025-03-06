;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $7900 $0101 $0102 $0103 $0104 $0105 $0106 $0107 $0108 $0109 $010A $010B $010C $010D $010E $010F 
.DW $0107 $0110 $0111 $0200 $0112 $0113 $0114 $0115 $0116 $0117 $0118 $0119 $011A $011B $011C $011D 
.DW $011E $011F $0120 $0118 $0121 $0122 $0500 $0101 $0102 $0103 $0123 $0124 $0125 $0126 $010B $0127 
.DW $0128 $0102 $0129 $0800 $0112 $0113 $0114 $012A $012B $012C $012D $011C $012E $012F $0113 $0130 
.DW $A400 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
