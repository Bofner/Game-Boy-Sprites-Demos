;Data Packet # 1

;Data for 16 byte packet that creates a LIN ATR
;Command Code:
;Byte 0 - Command*8+Length (length=1..7)
.DB $29

;Number of Data sets
;Byte 1	- Number of Data Sets
.DB $01

;Data Set #1

;Bit 0- 4 - Line Number ( X or Y coordinate, depending on bit 7)
;Bit 5- 6 - Palette Number ( 0- 3)
;Bit 7 - H/V Mode Bit ( 0=Vertical line, 1=Horizontal Line)
.DB $CB

;Extra Bytes to fill up the Data Packet
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
;End of SGB Data Packets