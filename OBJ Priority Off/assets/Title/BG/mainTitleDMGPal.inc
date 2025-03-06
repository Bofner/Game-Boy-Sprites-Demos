;Data for 16 byte packet that sets SGB Palettes 0 and 1 
;Header
.DB $01
;Color Data
.DW $7fff $294a $0000 $5294 $0000 $0000 $0000
;Extra Byte
.DB $00 
;End of SGB Packet
 
;Data for 16 byte packet that sets SGB Palettes 2 and 3 
;Header
.DB $09
;Color Data
.DW $0000 $ $ $ $ $ $
;Extra Byte
.DB $00 
;End of SGB Packet
 
