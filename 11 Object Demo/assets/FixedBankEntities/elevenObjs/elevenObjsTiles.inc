;Header byte follows this format:
;7:     1 = TILE, 0 = MAP
;6:     1 = Uncompressed
;5 & 4: 00 = SCRN, 01 = TALL
;       10 = WIDE, 11 = FULL
;0-3: Unused but set to 1
.DB %11001111

;Size of uncompressed tile data:
.DW $00B0
;Raw tile data 
.DB $7E $00 $FF $00 $FF $10 $FF $10 $FF $10 $FF $10 $FF $10 $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $04 $FF $3C $FF $20 $FF $3C $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $04 $FF $3C $FF $04 $FF $3C $7E $00 
.DB $7E $00 $FF $00 $FF $24 $FF $24 $FF $3C $FF $04 $FF $04 $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $20 $FF $3C $FF $04 $FF $3C $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $20 $FF $3C $FF $24 $FF $3C $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $04 $FF $04 $FF $04 $FF $04 $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $24 $FF $3C $FF $24 $FF $3C $7E $00 
.DB $7E $00 $FF $00 $FF $3C $FF $24 $FF $3C $FF $04 $FF $04 $7E $00 
.DB $7E $00 $FF $00 $FF $5E $FF $52 $FF $52 $FF $52 $FF $5E $7E $00 
.DB $7E $00 $FF $00 $FF $24 $FF $24 $FF $24 $FF $24 $FF $24 $7E $00 