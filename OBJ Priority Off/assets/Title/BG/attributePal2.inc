;Data for 16 byte packet that sets a block for SGB Palette 2
;Command Code: 
;Byte 0 - Command*8+Length (length=1..7)
.DB $21

;Number of Data sets
;Byte 1	- Number of Data Sets
.DB $01

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000001

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB %00000010

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $03

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 Rows
.DB $04

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $0C

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $06

;Extra Bytes (7-15)
; 8-D   Data Set #2 (if any)
; E-F   Data Set #3 (continued at 0-3 in next packet) (if any)
.DB $00 $00 $00 $00 $00 $00 $00 $00 
;End of SGB Packet