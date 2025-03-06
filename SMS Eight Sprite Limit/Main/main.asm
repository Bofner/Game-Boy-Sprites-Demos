;==============================================================
; WLA-DX banking setup
;==============================================================
.memorymap
    slotsize $7FF0	
    slot 0 $0000	

    slotsize $10	
    slot 1 $7FF0	

    slotsize $4000	
    slot 2 $8000	

    defaultslot 2	
.endme

.rombankmap
    bankstotal 4

    banksize $7FF0
    banks 1

    banksize $10
    banks 1

    banksize $4000
    banks 2
.endro


;==============================================================
; SMS defines
;==============================================================
.define PORT_VDP_ADDRESS  $BF 
.define VDPData     $BE
.define VRAMWrite   $4000
.define VRAMRead    $0000
.define CRAMWrite   $C000
.define NameTable   $3800
.define TextBox     $3CCC

.define paletteSize $10

.define UpBounds    $02
.define DownBounds  $BD
.define LeftBounds  $05
.define RightBounds $FD

.define NO_SCENE_ID $FF


;==============================================================
; SDSC tag and ROM header
;==============================================================

.sdsctag 0.1, "Template", "Hope this helps ya","Bofner"

.bank 0 slot 0
.org $0000
;==============================================================
; Boot Section
;==============================================================

    di              ;Disable interrupts
    im 1            ;Interrupt mode 1
    jp init         ;Jump to the initialization program

;==============================================================
; Interrupt Handler
;==============================================================
.orga $0038
;Swap shadow registers and registers
    ex af, af'
    exx 
;Get the status of the VDP
        in a,(PORT_VDP_ADDRESS)     ;Get status of VDP
                                    ;Bit 7:     1 = VBlank 0 = HBlank
                                    ;Bit 6:     1 = >=9 sprites on raster
                                    ;Bit 5:     1 = Sprite collision
                                    ;Bit 4-0:   No function
        ;ld (VDPStatus), a           ;Save to check if we are at VBLANK
        or a                        ;Check if POS or NEG (Bit 7 OFF or ON)
        jp p, HBlank                ;If bit 7 is 0, then we are at HBlank
;Do specific scanline-based tasks
        jp VBlank
;VBlank and HBlank will handle returning
        ;reti

;==============================================================
; Pause button handler
;==============================================================
.org $0066
;Swap shadow registers and registers for pause protection
    ex af, af'
    exx 
        ld a, (sceneID)
    ;If Scene ID is invalid, do nothing
        cp NO_SCENE_ID
        jp nc, EndPauseHandling
        ;ld a, (optionsByte)
        ;bit 3, a
        ;jr nz, EndPauseHandling
    ;Else...
    ;3 * N + PauseJumpTable
        ld c, a
        add a, c
        add a, c                           ;3 * N 
        ld h, 0
        ld l, a
        ld de, PauseJumpTable
        add hl, de                      ;3 * N + DPadJumpTable
        jp hl                           ;Jump to specific input subroutine

EndPauseHandling:
;Swap shadow registers and register back to end protection
    exx
    ex af, af'

    retn

;==============================================================
; What to do if we unpause
;==============================================================
UnpauseHandler:
    ld hl, sceneID
    ld a, (pauseSceneID)
    ld (hl), a

;Temporary Jerkiness fix
    
;End Jerkiness fix
    jp EndPauseHandling                         ;retn   

;==============================================================
; Pause Jump Table
;==============================================================
PauseJumpTable:
;Where to jump when PAUSE button hit
    jp EndPauseHandling                                         ;$00 = SFS Splash Screen
;Do correct action based on Scene ID                            ;$XX = Scene ID
    jp EndPauseHandling                                         ;$01 = Pause Screen
    jp EndPauseHandling                                         ;$02 = Title Screen
    jp EndPauseHandling                                         ;$03 = Level


;==============================================================
; Include our STRUCTS so we can create them in MAIN
;==============================================================
.include "..\\Object_Files\\structs.asm"


;==============================================================
; Boiler Variables 
;============================================================== 
.enum $c000 export
    ;SATBuffer
    VBuffer         dsb $40         ;Holds the yPos for all sprites
    HCBuffer        dsb $80         ;Holds the xPos and CC for all sprites


    VDPStatus       db          ;Holds VDP Status from the interrupt
                                ;Bit 7:     1 = VBlank
                                ;Bit 6:     1 = >=9 sprites on raster
                                ;Bit 5:     1 = Sprite collision
                                ;Bit 4-0:   No function
    nextHBlankStep  dw          ;Variable that tells where to go for next HBlank

    DCInput         db          ;$DC input
    DDInput         db          ;$DD input

    spriteCount     db          ;How many sprites are on screen on current frame (Reset at th beginning of each frame)
    SBTVS instanceof spriteBufferTemporaryVariablesStruct   ;Used for writing to the SATBuffers

    frameCount      db          ;Used to count frames in intervals of 60

    scrollX0        db          ;Parallax X Scroll
    scrollX1        db          ;Parallax X Scroll
    scrollX2        db          ;Parallax X Scroll
    scrollX3        db          ;Parallax X Scroll
    scrollX4        db          ;Parallax X Scroll
    scrollX5        db          ;Parallax X Scroll
    scrollX6        db          ;Parallax X Scroll
    scrollX7        db          ;Parallax X Scroll
    scrollX8        db          ;Parallax X Scroll
    scrollX9        db          ;Parallax X Scroll
    scrollXA        db          ;Parallax X Scroll
    scrollXB        db          ;Parallax X Scroll
    scrollXC        db          ;Parallax X Scroll
    scrollXD        db          ;Parallax X Scroll
    scrollXE        db          ;Parallax X Scroll
    scrollXF        db          ;Parallax X Scroll

    scrollX0Frac    dw          ;Fractional position $WHOLELO, FRAC $UNUSED, WHOLEHI
    scrollX1Frac    dw          ;Fractional position $WHOLELO, FRAC $UNUSED, WHOLEHI

    scrollY         db          ;Generic, no parallax scrollY

    currentBGPal instanceof paletteStruct   ;Used for Fade
    currentSPRPal instanceof paletteStruct  ;Used for Fade
    targetBGPal instanceof paletteStruct    ;Used for Fade
    targetSPRPal instanceof paletteStruct   ;Used for Fade

    enemyList instanceof enemyListStruct        ;List of enemies on screen

    sceneComplete   db          ;Used to determine if a scene is finished or not
    sceneID         db          ;Used to determine the scene we are on ($00 = SFS, $01 = Title, $FF = Pause, etc.)         
    pauseSceneID    db          ;The scene ID of the screen we were just coming from

    ;$c000 to $dfff is the space I have to work with for variables and such
    endByte         db          ;The first piece of available data post boiler-plate data
    
.ende



;==============================================================
; Game Constants
;==============================================================



;=============================================================================
; Special numbers 
;=============================================================================

.define postBoiler  endByte     ;Location in memory that is past the boiler plate stuff


;==============================================================
; Start up/Initialization
;==============================================================
init: 
    ld sp, $dff0

;==============================================================
; Set up VDP Registers
;==============================================================
;This is VDP Intialization data
    ld hl,VDPInitData                       ; point to register init data.
    ld b,VDPInitDataEnd - VDPInitData       ; 11 bytes of register data.
    ld c, $80                               ; VDP register command byte.
    call SetVDPRegisters
    

;==============================================================
; Clear VRAM
;==============================================================
;Set first color in sprite palette to black
    ld hl, $c010 | CRAMWrite
    call SetVDPAddress
;Next we send the BG palette data
    ld (hl), $00
    ld bc, $01
    call CopyToVDP

    call BlankScreen
    
    call ClearVRAM

;==============================================================
; Setup general sprite variables
;==============================================================
;Let a hold zero
    xor a

    ld hl, frameCount
    ld (hl), a

;Initialize the number of sprites on the screen
    ld hl, spriteCount      ;Set sprite count to 0
    ld (hl), a              ;

;==============================================================
; Game sequence
;==============================================================

    ei

    call SteelFingerStudios

    call LevelTemplate


;==============================================================
; Include Game Mechanic Files
;==============================================================
.include "..\\Player_Input\\controllerOneInput.asm"

;==============================================================
; Include Helper Files
;==============================================================
.include "..\\Helper_Files\\helperFunctions.asm"
.include "..\\Helper_Files\\interruptHandler.asm"


;==============================================================
; Include Level Files
;==============================================================
.include "..\\Splash_Screen\\steelFingerStudios.asm"
.include "..\\Level_Files\\level.asm"

;==============================================================
; Assets
;==============================================================
.include "..\\assets\\assets.asm"





