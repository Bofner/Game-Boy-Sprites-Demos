;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %00001111
;Compressed tile data in the form $RunLength + $TileID written as a word ($RLID).
.DW $0100 $0201 $0102 $0103 $0201 $0102 $0103 $0201 $0102 $0103 $0201 $0102 $0103 $0101 $0104 $0105 
.DW $0106 $0207 $0108 $0109 $0207 $010A $010B $0207 $010C $010A $0107 $010D $010E $010F $0110 $0111 
.DW $0112 $0106 $1307 $0113 $0114 $0115 $0116 $1007 $0117 $0118 $0119 $011A $1007 $0106 $1307 $0106 
.DW $1307 $0113 $011B $011C $1107 $0117 $011D $011E $011F $1007 $0106 $1307 $0106 $1307 $0113 $0120 
.DW $0121 $1107 $0117 $0122 $0123 $1107 $0106 $1307 $0106 $1307 $0113 $0124 $0125 $0126 $1007 $0117 
.DW $0127 $0128 $0129 $1007 $012A $012B $1207 
;Terminator word is $0000 since we can't have a run length of length 0.
.DW $0000
