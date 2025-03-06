;Data Packet # 1

;Data for 16 byte packet that creates a BLK ATR
;Command Code:
;Byte 0 - Command*8+Length (length=1..7)
.DB $25

;Number of Data sets
;Byte 1	- Number of Data Sets
.DB $0B

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
.DB $01

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $01

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $04

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0C

;Data Set #2

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $08

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $01

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $10

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $02

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $10

;Data Set #3

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $0C

;Data Packet # 2

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $03

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $10

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $04

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $10

;Data Set #4

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $04

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $08

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $08

;Data Set #5

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $04

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $0A

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0A

;Data Packet # 3

;Data Set #6

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $04

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $0C

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0C

;Data Set #7

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $04

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $0E

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $06

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0E

;Data Set #8

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $08

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $0A

;Data Packet # 4

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0A

;Data Set #9

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $08

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $0C

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0C

;Data Set #10

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $0C

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $0E

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $0E

;Data Set #11

;Control Code
;Byte 2 - Control Code (0-7)
;Bit 0 - Change Colors inside of surrounded area     (1=Yes)
;Bit 1 - Change Colors of surrounding character line (1=Yes)
;Bit 2 - Change Colors outside of surrounded area    (1=Yes)
;Bit 3-7 - Not used (zero)
.DB %00000010

;Color Palette Desgination
;Byte 3 - Color Palette Designation
;Bit 0-1 - Palette Number for inside of surrounded area
;Bit 2-3 - Palette Number for surrounding character line
;Bit 4-5 - Palette Number for outside of surrounded area
;Bit 6-7 - Not used (zero)
.DB $0C

;Data Packet # 5

;Coordinate X1
;Byte 4 - Top Left X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y1
;Byte 5 - Top Left Y Coordinate in # of 8x8 rows
.DB $10

;Coordinate X2
;Byte 6 - Bottom Right X Coordinate in # of 8x8 Columns
.DB $0D

;Coordinate Y2
;Byte 7 - Bottom Right Y Coordinate in # of 8x8 Rows
.DB $10

;Extra Bytes to fill up the Data Packet
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
;End of SGB Data Packets