;Data Packet # 1

;Data for 16 byte packet that creates a BLK ATR
;Command Code:
;Byte 0 - Command*8+Length (length=1..7)
.DB $22

;Number of Data sets
;Byte 1	- Number of Data Sets
.DB $03

;Data Set #1

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
.DB $01

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $0C

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $01

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $11

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $07

;Data Set #2

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
.DB $02

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $02

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $09

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $07

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0F

;Data Set #3

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
.DB $03

;Data Packet # 2

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $0C

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $09

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $11

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0F

;Extra Bytes to fill up the Data Packet
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
;End of SGB Data Packets