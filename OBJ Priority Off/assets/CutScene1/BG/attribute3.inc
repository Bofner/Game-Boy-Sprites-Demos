;Data for 16 byte packet that sets a line for SGB Palette 3
;Command Code: 
;Byte 0 - Command*8+Length (length=1..7)
.DB $29

;Number of Data sets
;Byte 1	- Number of Data Sets
.DB $02

;2 Data Set #1
;Bit 0- 4 - Line Number ( X- or Y- coor dinate, depending on bit 7)
;Bit 5- 6 - Palette Number ( 0- 3)
;Bit 7 - H/V Mode Bit ( 0=Vertical line, 1=Hor izontal Line)
.DB %01110010

;2 Data Set #2
;Bit 0- 4 - Line Number ( X- or Y- coor dinate, depending on bit 7)
;Bit 5- 6 - Palette Number ( 0- 3)
;Bit 7 - H/V Mode Bit ( 0=Vertical line, 1=Hor izontal Line)
.DB %01110011


;Extra Bytes (7-15)
; 8-D   Data Set #2 (if any)
; E-F   Data Set #3 (continued at 0-3 in next packet) (if any)
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
;End of SGB Packet