;================================================================================
;General VDP Functions
;================================================================================

;Tells VDP where it should be writing/reading data from in VRAM
;Parameters: HL = address
;Affects: No registers
SetVDPAddress:
    push af                     ;For safe keeping
        ld a, l                 ;Little endian
        out (PORT_VDP_ADDRESS), a     
        ld a, h
        out (PORT_VDP_ADDRESS), a
    pop af
    ret


;================================================================================


;Copies data to the VRAM
;Parameters: HL = data address, BC = data length
;Affects: A, HL, BC
CopyToVDP:
    
-:  ld a, (hl)                  ;Get data byte from location @ HL
    out (VDPData), a
    inc hl                      ;Point to next data byte
    dec bc                      ;Decrease our counter
    ld a, b
    or c
    jr nz, -
    ret

;================================================================================

;Copies data to the VRAM quickly, and only 127-bytes
;Parameters: HL = data address, B = data length
;Affects: HL, BC
FastCopyToVDP:
    ld c, VDPData                       ;We want to write data
    otir                                ;Write contents of HL to C with B bytes
    ret


;================================================================================


;Sets one or more VDP Registers (Each one contains a byte)
;Parameters: HL = data address, B = # of registers to update 
;            C = Which VDP regiseter $8(register#)
;Affects: A, B, C, HL
SetVDPRegisters:
-:  ld a,(hl)                            ; load one byte of data into A.
    out (PORT_VDP_ADDRESS),a                   ; output data to VDP command port.
    ld a,c                               ; load the command byte.
    out (PORT_VDP_ADDRESS),a                   ; output it to the VDP command port.
    inc hl                               ; inc. pointer to next byte of data.
    inc c                                ; inc. command byte to next register.
    djnz -                               ; jump back to '-' if b > 0.   
    ret

;================================================================================


;Updates a single VDP Register 
;Parameters: A = register data (one byte) C = Which VDP regiseter $8(register#)
;Affects: A, C, B
UpdateVDPRegister:
    out (PORT_VDP_ADDRESS), a                 ;Load data into CDP
    ld a, c
    out (PORT_VDP_ADDRESS), a                 ;Tell it which register to put it to
    ret


;================================================================================
;Visual Effects
;================================================================================

;Clears VRAM
;Parameters: 
;Affects: A, B, C, HL
ClearVRAM:  
    ;First, let's set the VRAM write address to $0000
    ld hl, $0000 | VRAMWrite
    call SetVDPAddress
    ;Next, let's clear the VRAM with a bunch of zeros
    ld bc, $4000        ;Counter for our zeros in VRAM
-:  xor a
    out (VDPData), a    ;Output data in A to VRAM address (which auto increments)
    dec bc              ;Adjust the counter
    ld a, b             
    or c                ;Check if we are at zero
    jr nz,-             ;If not, loop back up
    ret 


;================================================================================


;Clears the SATBuff
;Parameters: 
;Affects: A, B, HL
ClearSATBuff:
    ld hl, VBuffer
    ld b, $40
    xor a
-:
    ld (hl), a
    inc hl
    djnz -

    ld hl, HCBuffer
    ld b, $80
    xor a
-:
    ld (hl), a
    inc hl
    djnz -

    ret


;================================================================================


;Disables the display
;Parameters: 
;Affects: A, B, C, HL
BlankScreen:
        ;Turn on screen (Maxim's explanation is too good not to use)
    ld a, %00100000
;           ||||||`- Zoomed sprites -> 16x16 pixels
;           |||||`-- Not doubled sprites -> 1 tile per sprite, 8x8
;           ||||`--- Mega Drive mode 5 enable
;           |||`---- 30 row/240 line mode
;           ||`----- 28 row/224 line mode
;           |`------ VBlank interrupts
;            `------- Enable display    
    ld c, $81
    call UpdateVDPRegister
    ret


;================================================================================


;Updates the BG Palette from the buffer
;Parameters: 
;Affects: A, HL, BC
LoadBackgroundPalette:
;Load Background Palette in VRAM
    ld hl, $c000 | CRAMWrite
    call SetVDPAddress
    ld hl, currentBGPal.color0
    ld bc, $10
    call CopyToVDP

    ret


;================================================================================


;Updates the SPR Palette from the buffer
;Parameters: 
;Affects: A, BC, HL
LoadSpritePalette:
;Load Sprite Palette in VRAM
    ld hl, $c010 | CRAMWrite
    call SetVDPAddress
    ld hl, currentSPRPal.color0
    ld bc, $10
    call CopyToVDP

    ret


;================================================================================



;Writes a palette to the buffer
;Parameters: HL = currentPalette.color0, DE = Palette address, B = size of palette
;Affects: A, HL, DE, B
PalBufferWrite:  
    ld a, (de)
    ld (hl), a
    inc hl
    inc de
    djnz PalBufferWrite

    ret
    

;================================================================================
;Sprite Subroutines
;================================================================================

;Updates any sprite-OBJ DE is our *pointer, and HL is used for
;   updating the properties of the sprite
;Parameters: HL = sprite.sprNum
;Affects: DE, A, BC
MultiUpdateSATBuff:
;================================================================================
;Update Sprite X, Y and CC
;================================================================================
    ;Determine Sprite Number
    ld a, (spriteCount)
    ld (hl), a                      ;Set Sprite number
;This is potentially where we would grab the pointer for an array to alter drawing order
    
;Store all of our necesarry values into our temporary structure
    ;Store sprite size
    inc hl                          ;ld hl, OBJ.spriteSize
    ld a, (hl)
    ld (SBTVS.spriteSize), a
    ;Store width
    inc hl                          ;ld hl, OBJ.width
    ld a, (hl)
    ld (SBTVS.width), a             
    ;Store height
    inc hl                          ;ld hl, OBJ.height
    ld a, (hl)
    ld (SBTVS.height), a     
    ld (SBTVS.volatileHeight), a
    ;Store yPos
    inc hl                          ;ld hl, OBJ.yPos
    ld a, (hl)
    ld (SBTVS.yPos), a           
    ;Store xPos
    inc hl                          ;ld hl, OBJ.xPos
    ld a, (hl)
    ld (SBTVS.xPos), a      
    ld (SBTVS.volatileXPos), a
    ;Store cc
    inc hl                          ;ld hl, OBJ.cc
    ld a, (hl)
    ld (SBTVS.cc), a            

;Calculate xCenter and yCenter
    ;Formula: 
    ;           xCetner = xPos + (WIDTH * 4)
    ;           yCetner = yPos + (HEIGHT * 4)

    ;xCenter
    inc hl                          ;ld hl, OBJ.xCenter
    ld a, (SBTVS.width)
    add a, a                        ;width * 2
    add a, a                        ;width * 4
    ld b, a                         ;store 4*WIDTH in register B
    ld a, (SBTVS.xPos)
    add a, b                        ;xCetner = xPos + (WIDTH * 4)
    ld (hl), a                      ;Update xCenter
    ;yCenter
    inc hl                          ;ld hl, OBJ.yCenter
    ld a, (SBTVS.height)
    add a, a                        ;width * 2
    add a, a                        ;width * 4
    ld b, a                         ;store 4*WIDTH in register B
    ld a, (SBTVS.yPos)
    add a, b                        ;xCetner = yPos + (HEGHT * 4)
    ld (hl), a                      ;Update yCenter

;Now actually start to fill out the buffer, We now no longer have access to our OBJ
;Update xPos and CC
    ld hl, HCBuffer
    ;Point to correct sprite xPosition
    ld de, spriteCount              ;\
    ld a, (de)                      ;/ Grab Sprite counter and leave it in DE
    add  a, a                       ;Double the value since each time we write X and CC
    ld b, $00
    ld c, a
    add hl, bc                      ;Advance vBuffer to the 1 before correct sprite's hPosition
MUSB_xPosCCWriteAcross:
    ld a, (SBTVS.width)
    ld b, a                         ;Set up our DJNZ counter
    ld a, (SBTVS.xPos)
    ld (SBTVS.volatileXPos), a      ;Reset our volatileXPos
    ;Fill our xPos and CC for each sprite, which will change
-:
    ld a, (SBTVS.volatileXPos)
    ld (hl), a
    add a, $08                      ;Next sprite is 8 pixels to the left
    ld (SBTVS.volatileXPos), a
    inc hl                          ;ld hl, SAT.cc
    ld a, (SBTVS.cc)
    ld (hl), a
    ld c, a                         ;Save our CC value
    ld a, (SBTVS.spriteSize)
    rrca                            ;\
    rrca                            ; } If 16 -> 2, If 8 -> 1
    rrca                            ;/
    add a, c                        ;location of next CC
    ld (SBTVS.cc), a                ;Update CC for next sprite
    inc hl
    djnz -
    ;Check if we need to write any more rows
    ld a, (SBTVS.volatileHeight)
    sub 1
    ld (SBTVS.volatileHeight), a    ;Update the volatile height
    cp $00                          ;If it's zero, then we are done
    jr nz, MUSB_xPosCCWriteAcross   ;If it's not zero, then write another row


MUSB_resetVolatileHeight:
;Reset our height before working on yPos
    ld a, (SBTVS.height)
    ld (SBTVS.volatileHeight), a   


;Update yPos
    ld hl, VBuffer                  ;ld hl, sprite0.vPos
    ;Point to correct sprite vPosition
    ld de, spriteCount              ;\
    ld a, (de)                      ;/ Grab Sprite counter and leave it in DE
    ld b, $00
    ld c, a
    add hl, bc                      ;Advance vBuffer to the 1 before correct sprite's vPosition
MUSB_yPosWriteAcross:
    ld a, (SBTVS.width)
    ld b, a                         ;Set up our DJNZ counter
    ld a, (SBTVS.yPos)
    ;Fill out the yPos for each of the sprites
    ;Write the same data across each row, since y-values won't change
-:
    ld a, (SBTVS.yPos)
    ld (hl), a                      ;Set sprites vPos
    ld a, (de)                      ;\
    inc a                           ; }Increment the spriteCounter by 1
    ld (de), a                      ;/
    inc hl                          ;Point to next sprite
    djnz -
    ;Check if we need to write any more rows
    ld a, (SBTVS.yPos)              ;\
    ld b, a                         ; }
    ld a, (SBTVS.spriteSize)        ;  } Update yPos for the row beneath it
    add a, b                        ; }
    ld (SBTVS.yPos), a              ;/
    ld a, (SBTVS.volatileHeight)
    sub 1
    ld (SBTVS.volatileHeight), a    ;Update the volatile height
    cp $00                          ;If it's zero, then we are done
    jr nz, MUSB_yPosWriteAcross     ;If it's not zero, then write another row
                         
    ld (hl), $D0                    ;Sprite terminator at next sprite

    ret


;================================================================================


;Updates the Sprite Attribute table with the SAT Buffer
;Parameters: None
;Affects: B, C, HL
UpdateSAT:
    
;Set vPositions
    ld hl, $3f00 | VRAMWrite            ;Telling the VDP where to write this data
    call SetVDPAddress                  
    ld a, (spriteCount)
    ld b, a                             ;Load the SAT with only the sprites' vPos that exist
    inc b                               ;As well as the terminator byte
    ld c, VDPData                       ;We want to write data
    ld hl, VBuffer                      ;We are writing the contents of the SAT buffer
    otir                                ;Write contents of HL to C with B bytes
;Set xPos and CC
    ld hl, $3f80 | VRAMWrite            ;Telling the VDP where to write this data
    call SetVDPAddress                  ;\
    ld a, (spriteCount)                 ; }
    add a, a                            ; } Load the SAT with only the sprites' xPos and cc that exist
    ld b, a                             ; } And the terminator byte
    inc b                               ;/
    ld c, VDPData                       ;We want to write data
    ld hl, HCBuffer                     ;We are writing the contents of the SAT buffer
    otir                                ;Write contents of HL to C with B bytes
    ;This will always be the first thing to happen at after VBLANK
    ;So we will use this opportunity to reset the spriteUpdateCount
    ld hl, spriteCount
    ld (hl), 0
    ret


;================================================================================
;Hit Box Subroutines
;================================================================================
;Checks if two hitboxes are overlapping
;Parameters: HL = hitBoxB.width, DE = hitBoxA.width
;Affects: A, BC, HL, DE
;Returns: A = TRUE ($01) or FALSE ($00)
CheckCollisionTwoHitboxes:
;Check if either hitBox is area 0
    ld a, (hl)
    cp $00
    jp z, NoHitBoxCollisionDetected
    ld a, (de)
    cp $00
    jp z, NoHitBoxCollisionDetected


;----------------------------------
;Check if one hitBox is to the left of the other
    ld b, $FF                                   ;The NEG equivalent of 0
    ld c, hitBoxStruct.x1 - hitBoxStruct.width
    add hl, bc                                  ;ld hl, hitBoxB.x1
    ex de, hl           
    ld c, hitBoxStruct.x2 - hitBoxStruct.width                        
    add hl, bc
    ex de, hl                                   ;ld de, hitBoxA.x2

    ld a, (de)                                  ;A = hitBoxA.x2
    ;ld b, (hl)                                 ;B = hitBoxB.x1
    cp (hl)               ;If hitBoxA's RIGHT is SMALLER than hitBoxB's LEFT, then hitBoxA is to the left
    jp c, NoHitBoxCollisionDetected
DoubleCheckLeft:
    ;ld b, $FF
    ld c, hitBoxStruct.x1 - hitBoxStruct.x2
    ex de, hl
    add hl, bc
    ex de, hl                                   ;ld de, hitBoxA.x1

    ld b, 0
    ld c, hitBoxStruct.x2 - hitBoxStruct.x1
    add hl, bc                                  ;ld hl, hitBoxB.x2
    

    ld a, (de)                                  ;A = hitBoxA.x1
    ld b, (hl)                                  ;B = hitBoxB.x2
    inc b                  ;We can ony do a (>=) comparison, so this gives us a (>) comparison
    cp b                   ;If hitBoxA's LEFT is LARGER than hitBoxB's RIGHT, then hitBoxB is to the LEFT
    jp nc, NoHitBoxCollisionDetected


;----------------------------------
;Check if one is above the other
    ld b, $FF
    ld c, hitBoxStruct.y2 - hitBoxStruct.x2
    add hl, bc                                  ;ld hl, hitBoxB.y2
    ld c, hitBoxStruct.y1 - hitBoxStruct.x1
    ex de, hl
    add hl, bc
    ex de, hl                                   ;ld de, hitBoxA.y1

    ld a, (de)                                  ;A = hitBoxA.y1
    ld b, (hl)                                 ;B = hitBoxB.y2
    inc b                  ;We can ony do a (>=) comparison, so this gives us a (>) comparison
    cp b                   ;If hitBoxA's TOP is LARGER than hitBoxB's BOTTOM, then hitBoxB is ABOVE
    jr nc, NoHitBoxCollisionDetected
DoubleCheckAbove:
    ld b, $FF
    ld c, hitBoxStruct.y1 - hitBoxStruct.y2
    add hl, bc                                  ;ld hl, hitBoxB.y1
    ld b, 0
    ld c, hitBoxStruct.y2 - hitBoxStruct.y1
    ex de, hl
    add hl, bc
    ex de, hl                                   ;ld de, hitBoxA.y2

    ld a, (de)                                  ;A = hitBoxA.y2
    ;ld b, (hl)                                 ;B = hitBoxB.y1
    cp (hl)                ;If hitBoxA's BOTTOM is SMALLER than hitBoxB's TOP, then hitBoxA is ABOVE
    jr c, NoHitBoxCollisionDetected

    jp HitBoxCollisionDetected


;----------------------------------
;Collision detected
HitBoxCollisionDetected:
    ld a, 1

    ret

;----------------------------------
;No Collision detected
NoHitBoxCollisionDetected:
    ld a, 0

    ret
;================================================================================
;Background Subroutines
;================================================================================


;Writes text to the screen in the dialogue box area (bottom)
;Parameters: DE = Message
;Affects: A, BC, HL, DE
TextToScreen:
    ;First, let's set the RAM address to the correct tile map
    ld b, 0                                 ;Reset counter
    ld c, $00                               ;Set offset
    ld hl, TextBox | VRAMWrite
    call SetVDPAddress
    ;Then we can put stuff to the screen
    ex de, hl               ;load data in HL (from DE)
-:  ld a,25             
    cp b                    ;Check if we are at the end of the line
    jr nz, Write            ;
  
    ;We are writing on a new line, adding BC ($0040)
    push hl
        ld b, 0             ;Reset Counter
        ld a, c
        add a, $40
        ld c, a
        ld hl, TextBox | VRAMWrite
        add hl, bc
        add hl, bc          ;We are double spacing the text
        call SetVDPAddress   
    pop hl
    
Write:
    ld a, (hl)              ;Read until we hit $ff
    cp $ff                  ;
    jr z,+                  ;
    out (VDPData), a        ;
    xor a                   ;
    out (VDPData), a        ;
    inc hl                  ;
    inc b                   ;Increase counter
    jr -                                    ;
+:  ret

;================================================================================
/*
;Checks if a sprite is colliding with a tagible BG tile
;Parameters: H = (spriteX), E = (spriteY)
;Returns: A = collision is true (1) or false (0)
;Affects: A, B, DE, HL
BGTileCollision:
    ;The formula is TILE = $3800 + OMEGAx + OMEGAy where
    ; OMEGAx = $02 * [($Spritex - H-scroll)/8]
    ; OMEGAy = $40 * [($Spritey - V-scroll)/8] (No remainders)

    ;-------------------------------
    ;Adjust for H-scroll
    ;-------------------------------
    ld a, h                     ;Set y value
    ld hl, scrollX              ;Adjust for the H-scroll
    ld l, (hl)                  ;
    sub l                       ;
    ld h, a                     ;
    ;-------------------------------
    ;Find Nametable X coordinate
    ;-------------------------------
    ld d, 8                     ;Each space in Nametable is 8 pixels wide
    call Div8Bit
    ld a, l                     ;Result of division goes to A    
    add a, a                    ;Multiply by 2 --> each Nametable X increases by $02 bytes
    ld hl, colXOffset
    ld (hl), a                  ;Keeping track of the Nametable X-offset
    ;-------------------------------
    ;Adjust for V-scroll
    ;-------------------------------
    ld a, e                     ;The y-coordinate of our sprite 
    ld hl, scrollY              ;Adjusted for V-scroll
    ld l, (hl)                  ;
    add a, l                    ;        
    ld h, a
    ;-------------------------------
    ;Find Nametable Y coordinate
    ;-------------------------------
    ;ld h, e                     
    ld d, 8                     ;Each space in Nametable is 8 pixels tall
    call Div8Bit
    ld a, $40                   ;Nametable y-offset increases by $40 for each square unit
    ld d, 0                     ;This way DE has our 8-bit spriteY coordinate
    ld e,  l                    ;converted to tile location in square units
    call Mult8Bit               ;Square units converted to Nametable Address offset, HL = Product
    ;-------------------------------
    ;Create the Nametable Offset
    ;-------------------------------
    ld de, $3801                ;We want to add OMEGA to $3800 (Nametable) but the collision flag is little endian, so $3800 + 1
    add hl, de                  ;Add OMEGAy to our equation
    ld d, 0
    ld ix, colXOffset           ;Recall the x-offset
    ld e, (ix + 0)              ;Loading DE with the x-offset
    add hl, de                  ;Add OMEGAx to our equation
    ;Fixing a collision detected when we enter "beyond" the name table
    ld a, $3f                   ;Value beyond the Nametable
    cp h                        ;Check if our Nametable offset is... too offset
    jr z, +                     ;If it is, we don't want to check for collision...
    call SetVDPAddress          ;We want to read from it now
    in a, (VDPData)             ;read data to register A
    and $80                     ;Checking bit 7 for the collision flag
    ret
+:
    ld a, $00                   ;So we just say there is no collision and return
    ret
*/

;================================================================================
;Mathematics
;================================================================================

;An alteration on the division algorithm used by Sean Mclaughlin in
;   Learn TI-83 Plus Assembly In 28 Days
;Divides one 8 bit number by another 8 bit number
;Parameters: H = Dividend, D = Divisor D/H  
;Returns: L = Quotient, A = Remainder
;Affects: A, B, D, HL
Div8Bit:
    xor a               ;Clear out A register
    ld l,  a            ;   and L register
    ld b, 8
Div8Loop:
    add hl, hl          ;shift H one to the left
    rla                 ;Put the carry into bit 0 of register A
    jr c, Div8Sub       ;If the carry flag gets set, we subtract
    cp d                ;If A is greater than or equal to D, we subtract
    jr nc, Div8Sub
    djnz Div8Loop       ;Otherwise, we refresh
    ret
Div8Sub:
    sub d               ;Subtract D from A
    inc l               ;Add to our quotient
    djnz Div8Loop
    ret


;================================================================================


;Used the logic from Learn TI-83 Plus Assembly In 28 Days
;Multiplies one 8-bit number by another 8 bit number
;Parameters: A = multiplier, DE = Multiplicand
;Returns: HL = 16-bit product
;Affects: A, HL, DE, B
Mult8Bit:
    ld hl, 0                ;Zero our product to start
    ld b, 8                 ;B is our 8-bit counter
Mult8Loop:
    srl a                   ;Shift A multiplier to the right
    jr c, Mult8Add          ;If there's a carry, then we add
    sla e                   ;Shift E left and bit 7 to carry
    rl d                    ;Take the carry from E into D
    djnz Mult8Loop          ;If we have gone through 8 bits,
    ret                     ;Then we exit
Mult8Add:
    add hl, de              ;Add the multiplicand to the product
    sla e                   ;Shift E left and bit 7 to carry
    rl d                    ;Take the carry from E into D
    djnz Mult8Loop          ;If we have gone through the 8 bits,
    ret                     ;Then we exit


;================================================================================


/*
;-----> Generate a random number
;Output A = Answer 0 <= A <= 255
;All registers are preserved except: af
;From WIKITI, based off the pseudorandom number generator featured 
;in Ion by Joe Wingbermuehle
RandomNumberGenerator:
        push    hl
        push    de
        ld      hl,(randSeed)
        ld      a,r
        ld      d,a
        ld      e,(hl)
        add     hl,de
        add     a,l
        xor     h
        ld      (randSeed),hl
        pop     de
        pop     hl
        ret
*/


;===================================================
;Fading
;===================================================

;===================================================
;Fade to black
;===================================================

;Causes the screen to fade to black
;Parameters: Both palette buffers must be next to each other in memory BG then SPR
;Affects: A, HL, BC, DE
FadeToBlack:
    ld a, $03
BigBlackLoop:
    push af
    ld hl, currentBGPal.color0
    ld b, $10                           ;Full length of the palette
    ld c, %00000011                     ;RED Bitmask
    ld d, %00000001                     ;Darken REDs by 1
    ld e, %00111100                     ;Reset REDs

InnerBlackLoop:                         ;LOOP
;Darken Background COLORs
    ld a, (hl)                          ;ld a, (currentBGPal.colorCurrent)
    and c                               ;COLOR Bitmask
    cp $00                              ;If zero, skip the subtraction
    jr z, +
    sub d                               ;Darken Amount
    push af
        ld a, e                         ;ld a, COLOR reset
        and (hl)                        ;Reset COLOR 
        ld (hl), a                      ;And store it in buffer
    pop af
    or (hl)                             ;Update COLOR with new, darkened version
    ld (hl), a                          ;Darken BG COLOR by 1 and save to buffer

+:
    push de
        ld de, paletteSize
        add hl, de                      ; ld hl, currentSPRPal.colorCurrent
    pop de                             
;Darken Sprite COLORs
    ld a, (hl)
    and c                              ;COLOR Bitmask
    cp $00
    jr z, +
    sub d                               ;Darken Amount
    push af
        ld a, e                         ;ld a, COLOR reset
        and (hl)                        ;Reset COLOR 
        ld (hl), a                      ;And store it in buffer
    pop af
    or (hl)                             ;Update COLOR with new, darkened version
    ld (hl), a                          ;Darken SPR COLOR by 1 and save to buffer

+:  
    inc hl                              ;ld hl, currentSPRPal.colorNext
    push de
        ld de, -16
        add hl, de                      ; ld hl, currentBGPal.colorNext
    pop de

    djnz InnerBlackLoop                 ;Loop back for the next color in palette

;Smoothe out the fading process
    ld b, $03                           ;How many times to go through the loop
-:
    xor a
    ld (VDPStatus), a           
    halt                                
    ld a, (VDPStatus)             ;Check if we are at VBlank
    or a
    jp p, -                       ;If P, then bit 7 = 0, so HBLANK
    djnz -
;Reset VDP Status
    xor a
    ld (VDPStatus), a 

;Timer so that we don't write to VRAM while drawing the border
    ld a, $EF
-:
    dec a
    cp $00
    jr nz, -  

;Update the graphics during VBlank to avoid artifacts
    push bc
    push hl
        call LoadBackgroundPalette
        call LoadSpritePalette          ;Update palettes in VRAM
    pop hl
    pop bc
    
;Set our new color Bitmasks
    ld a, c                             ;ld a, COLOR Bitmask
    cp %00000011                        ;Is it RED?
    jr z, +
    cp %00001100                        ;Is it Green?
    jr z, ++
    cp %00110000                        ;Is it Blue?
    jr z, +++   

;Go from RED to GREEN 
+:                 
    ld hl, currentBGPal.color0
    ld b, $10                           ;Full length of the palette
    ld c, %00001100                     ;GREEN Bitmask
    ld d, %00000100                     ;Darken GREENs by 1
    ld e, %00110011                     ;Reset GREENs
    jp InnerBlackLoop

;Go from GREEN to BLUE 
++:
    ld hl, currentBGPal.color0
    ld b, $10                           ;Full length of the palette
    ld c, %00110000                     ;BLUE Bitmask
    ld d, %00010000                     ;Darken BLUEs by 1
    ld e, %00001111                     ;Reset BLUEs
    jp InnerBlackLoop

;All done
+++:
    pop af
    dec a
    cp $00
    jp nz, BigBlackLoop                 ;Making our own djnz because it's too big

    ret


;================================================================================


;Causes the screen to fade in from black
;Parameters: Both palette buffers must be next to each other in memory BG then SPR
;Affects: A, HL, BC, DE
FadeIn:
    ld a, $03
BigInLoop:
    push af
    ld hl, currentBGPal.color0
    ld ix, targetBGPal.color0
    ld b, $10                           ;Full length of the palette
    ld c, %00110000                     ;BLUE Bitmask
    ld d, %00010000                     ;Lighten BLUEs by 1
    ld e, %00001111                     ;Reset BLUEs

InnerInLoop:                                      ;LOOP
;Lighten Background COLORs
    ld a, (ix+0)                        ;ld a, (currentBGPal.colorCurrent)
    and c                               ;COLOR Bitmask
    ld iyl, a                           ;Save target COLOR value
    ld a, (hl)
    and c                               ;Compare with current value
    cp iyl                              ;If TARGET, skip the addition
    jr z, +
    ld a, (hl)                          ;ld a, (currentBGPal.colorCurrent)
    and c                               ;COLOR Bitmask

    add a, d                            ;Lighten Amount
    push af
        ld a, e                         ;ld a, COLOR reset
        and (hl)                        ;Reset COLOR 
        ld (hl), a                      ;And store it in buffer
    pop af
    or (hl)                             ;Update COLOR with new, lightened version
    ld (hl), a                          ;Lighten BG COLOR by 1 and save to buffer

+:
    push de
        ld de, paletteSize
        add hl, de                      ;ld hl, currentSPRPal.colorCurrent
        add ix, de                      ;ld ix, currentSPRPal.colorCurrent
    pop de              

;Lighten Sprite COLORs
    ld a, (ix+0)                        ;ld a, (currentBGPal.colorCurrent)
    and c                               ;COLOR Bitmask
    ld iyl, a                           ;Save target COLOR value
    ld a, (hl)
    and c                               ;Compare with current value
    cp iyl                              ;If TARGET, skip the addition
    jr z, +

    add a, d                            ;Lighten Amount
    push af
        ld a, e                         ;ld a, COLOR reset
        and (hl)                        ;Reset COLOR 
        ld (hl), a                      ;And store it in buffer
    pop af
    or (hl)                             ;Update COLOR with new, lightened version
    ld (hl), a                          ;Lighten SPR COLOR by 1 and save to buffer

+:  
    inc hl                              ;ld hl, currentSPRPal.colorNext
    inc ix                              ;ld ix, targetSPRPal.colorNext
    push de
        ld de, -16                      ;Go back to BGPal
        add hl, de                      ;ld hl, currentBGPal.colorNext
        add ix, de                      ;ld ix, targetBGPal.colorNext
    pop de
    
    djnz InnerInLoop                    ;Loop back for the next color in palette

;Smoothe out the fading process
    ld b, $03                           ;How many times to go through the loop
-:
    xor a
    ld (VDPStatus), a           
    halt                                
    ld a, (VDPStatus)             ;Check if we are at VBlank
    or a
    jp p, -                       ;If P, then bit 7 = 0, so HBLANK
    djnz -
;Reset VDP Status
    xor a
    ld (VDPStatus), a 

;Timer so that we don't write to VRAM while drawing the border
    ld a, $EF
-:
    dec a
    cp $00
    jr nz, -                  

;Update the graphics during VBlank to avoid artifacts
    push bc
    push hl
        call LoadBackgroundPalette
        call LoadSpritePalette          ;Update palettes in VRAM
    pop hl
    pop bc

;Set our new color Bitmasks
    ld a, c                             ;ld a, COLOR Bitmask
    cp %00110000                        ;Is it BLUE?
    jr z, +
    cp %00001100                        ;Is it GREEN?
    jr z, ++
    cp %00000011                        ;Is it RED?
    jr z, +++   

;Go from BLUE to GREEN 
+:                 
    ld hl, currentBGPal.color0
    ld ix, targetBGPal.color0
    ld b, $10                           ;Full length of the palette
    ld c, %00001100                     ;GREEN Bitmask
    ld d, %00000100                     ;Lighten GREENs by 1
    ld e, %00110011                     ;Reset GREENs
    jp InnerInLoop

;Go from GREEN to RED 
++:
    ld hl, currentBGPal.color0
    ld ix, targetBGPal.color0
    ld b, $10                           ;Full length of the palette
    ld c, %00000011                     ;RED Bitmask
    ld d, %00000001                     ;Lighten REDs by 1
    ld e, %00111100                     ;Reset REDs
    jp InnerInLoop

;All done
+++:
    pop af
    dec a
    cp $00
    jp nz, BigInLoop                    ;Making our own djnz because it's too big

    ret


;================================================================================

