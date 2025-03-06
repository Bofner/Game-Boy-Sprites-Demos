;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $00C0
;Raw tile data 
.DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $FC $00 $FC $CC $FC $00 $30 $00 $30 $00 $30 $00 $30 $00 $30 
.DB $00 $FE $00 $FE $3E $FE $00 $C0 $00 $C0 $00 $F8 $00 $F8 $38 $F8 
.DB $00 $78 $00 $FC $30 $FC $0C $CC $00 $F0 $80 $F8 $40 $7C $30 $3C 
.DB $00 $F8 $00 $FC $38 $FE $00 $C6 $00 $C6 $00 $FC $00 $FC $30 $FE 
.DB $00 $78 $00 $FC $30 $FC $00 $CC $00 $CC $00 $CC $00 $CC $00 $CC 
.DB $00 $C6 $00 $EE $00 $FE $00 $FE $00 $FE $00 $FE $28 $FE $10 $D6 
.DB $00 $30 $00 $30 $00 $30 $30 $30 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $C0 $00 $FE $00 $FE $FE $FE $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $CC $00 $FC $84 $FC $78 $78 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $08 $CE $00 $C6 $00 $C6 $C6 $C6 $00 $00 $00 $00 $00 $00 $00 $00 
.DB $00 $C6 $00 $C6 $00 $C6 $C6 $C6 $00 $00 $00 $00 $00 $00 $00 $00 