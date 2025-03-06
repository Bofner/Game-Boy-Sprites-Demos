.SECTION "SGB Related Operations"

;Parameters: HL = Data Packet Address
;Returns: None
;Affects: A, BC, DE, HL
;Sends a data packet to SNES. Data packet format is as follows:
;1. 1 Pulse: Start Signal
;2. 1 Byte: Header Byte (Command Code x 8 + # of packets)
;3. 15 Bytes: Data
;4. 1 Bit: Stop Bit (0)
SendSGBPacket:
    ld a, (hl)              ;Put the Header Byte into A
    and %00000111           ;Number of packets to send
    ld e, a
@StartPulse:
;Set P14 and P15 to 0 to send the start pulse
    xor a
    ld (rP1), a
;Then set P14 and P15 to High
    ld a, P1F_4 | P1F_5
    ld (rP1), a
;Get our data ready to send
    ld b, $10               ;16 bytes
@BeginByteTransfer:
;Start transferring Data
    ld c, $08               ;8 Bits per byte
    ld a, (hli)             ;Point HL to next byte and put current byte into A
    ld d, a                 ;Then put them into D
@SetBit0:
;Send a 0
    bit 0, d                ;Check if bit is 0 or 1
    jr nz, @SetBit1
    ld a, P1F_5            ;Set P14 to 0 and P15 to 1 to send a 0
    jr @SendNextBit

@SetBit1:
;Send a 1
    ld a, P1F_4            ;Set P14 to 1 and P15 to 0 to send a 1

@SendNextBit:
;Send bit
    ld (rP1), a
;Then set P14 and P15 to High
    ld a, P1F_4 | P1F_5
    ld (rP1), a
;Set up next bit to send
    rr d                    ;Rotate D so that next bit is now the zero bit
    dec c                   ;Check if we have reached the last bit
    jr nz, @SetBit0
@SendNextByte:
;Set up next byte to send
    dec b                   ;Check if we reached the last byte
    jr nz, @BeginByteTransfer
@StopBit:
;Send the Stop Bit
    ld a, P1F_5            ;Set P14 to 0 and P15 to 1 to send a 0
    ld (rP1), a
;Then set P14 and P15 to High
    ld a, P1F_4 | P1F_5
    ld (rP1), a
;Check if we have more packets to send
    call @Wait4Frames
    dec e                   ;Check if we reached the last packet
    jp nz, @StartPulse

    ret

@Wait4Frames:
    ld      bc, 7000                ; 12 cycles
    @@WaitLoop:
    nop                             ; 4 cycles
    nop                             ; 4 cycles
    nop                             ; 4 cycles
    dec     bc                      ; 8 cycles
    ld      a,  b                   ; 4 cycles
    or      c                       ; 4 cycles
    jr      nz, @@WaitLoop   ; 12 cycles if jumps, 8 if not

    ret

MaskFreezeSGB:
    /*
    Byte Content
    0 Command*8+Length ( fixed length=1)
    1 Game Boy Screen Mask ( 0-3)
        0 Cancel Mask ( Display activated)
        1 Freeze Screen (Keep displaying current picture)
        2 Blank Screen (Black)
        3 Blank Screen (Color 0)
    2- F Not used ( zer o)
    */
    .DB $B9
    .DB $01
    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
MaskFreezeSGBEnd:

MaskUnfreezeSGB:
    /*
    Byte Content
    0 Command*8+Length ( fixed length=1)
    1 Game Boy Screen Mask ( 0-3)
        0 Cancel Mask ( Display activated)
        1 Freeze Screen (Keep displaying current picture)
        2 Blank Screen (Black)
        3 Blank Screen (Color 0)
    2- F Not used ( zer o)
    */
    .DB $B9
    .DB $00
    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
MaskUnfreezeSGBEnd:

MaskBlackSGB:
    /*
    Byte Content
    0 Command*8+Length ( fixed length=1)
    1 Game Boy Screen Mask ( 0-3)
        0 Cancel Mask ( Display activated)
        1 Freeze Screen (Keep displaying current picture)
        2 Blank Screen (Black)
        3 Blank Screen (Color 0)
    2- F Not used ( zer o)
    */
    .DB $B9
    .DB $02
    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
MaskBlackSGBEnd:

Mask0IndexColorSGB:
    /*
    Byte Content
    0 Command*8+Length ( fixed length=1)
    1 Game Boy Screen Mask ( 0-3)
        0 Cancel Mask ( Display activated)
        1 Freeze Screen (Keep displaying current picture)
        2 Blank Screen (Black)
        3 Blank Screen (Color 0)
    2- F Not used ( zer o)
    */
    .DB $B9
    .DB $03
    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 
Mask0IndexColorSGBEnd:

SGBPackets:
    @ShiokaraPalette:
        .INCLUDE "..\\assets\\FixedBankSGB\\shiokaraSGB2Pal.inc"
    @ShiokaraPaletteEnd:

    @FullScreenPalette0ATR:
		.INCLUDE "..\\assets\\FixedBankSGB\\fullScreenPal0.inc"
	@FullScreenPalette0ATREnd:

;--------------------------
SGBHeadsUpDisplay:
    @Tiles:
        .INCLUDE "..\\assets\\FixedBankSGB\\headUpDisplaySGBTiles.inc"
    @TilesEnd:

    @Attribute:
        .INCLUDE "..\\assets\\FixedBankSGB\\headsUpDisplaySGBAttribute.inc"
    @AttributeEnd:

    @DMGPal:
		.DB		%11010010		
		;  	   C3,C2,C1,BG
	@DMGPalEnd:
 
.ENDS