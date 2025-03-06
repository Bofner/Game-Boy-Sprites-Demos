;Data Packet # 1

;Data for 16 byte packet that creates a CHR ATR
;Command Code:
;Byte 0 - Command*8+Length (length=1..7)
.DB $39

;Number of Data sets
;Byte 1	- Number of Data Sets
.DB $02

;Extra Bytes to fill up the Data Packet
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
;End of SGB Data Packets