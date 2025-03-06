;==============================================================
; WLA-DX banking setup 
;==============================================================
.MEMORYMAP
	SLOTSIZE $4000
	SLOT 0 $0000					;Fixed ROM Bank
	SLOT 1 $4000					;Switchable ROM Bank
	SLOT 2 $A000					;Cartridge SRAM
	SLOT 3 $C000					;Game Boy Work RAM
	SLOT 4 $E000					;Echo RAM and High RAM
	DEFAULTSLOT 0
.ENDME
.ROMBANKMAP
	BANKSTOTAL 4
	BANKSIZE $4000
	BANKS 4
.ENDRO
.DEF BANK_SETUP 1	;Tells hardwareWLA-DX not to write the banks
;==============================================================
; Game Boy Header 
;==============================================================
.GBHEADER
	NAME "11 OBJ Demo"
	ROMGBC
	ROMSGB
	CARTRIDGETYPE $01
    ROMSIZE $01
	RAMSIZE $00
	COUNTRYCODE $00
	LICENSEECODEOLD $33
	VERSION $00
.ENDGB
.NINTENDOLOGO
.DEF GB_HEADER 1	;Tells hardwareWLA-DX not to write the header

;==============================================================
; Hardware Defines and structures
;==============================================================
.INCLUDE "hardwareWLA-DX.inc"
.INCLUDE "structs.asm"

;==============================================================
; Global Constants
;==============================================================
;VRAM Locations
	.DEF 	TILE_VRAM_8000		$8000
	.DEF 	TILE_VRAM_8800		$8800
	.DEF 	TILE_VRAM_9000		$9000
	.DEF 	MAP_VRAM_9800		$9800
	.DEF	MAP_VRAM_9C00		$9C00

;Hardware version checks and values
	.DEF	DMG_CHECK			$01
	.DEF	SGB_CHECK			$14
	.DEF	CGB_CHECK			$11
	.DEF	DMG_MODE			$00
	.DEF	SGB_MODE			$01
	.DEF	CGB_MODE			$02

;Key words
	.DEF	BG_PALETTE			$00
	.DEF	OBJ_PALETTE			$02
	.DEF	END_OF_DATA			$FFFF
	.DEF 	NO_FINISH			$00
	.DEF	WRITE_FINISH		$01
	.DEF	VBLANK_FINISH		$10
	.DEF	VBLANK_WRITE_FINISH	$11


;Scene values?
	.DEF	SCENE_SFS				$00
	.DEF	SCENE_TITLE				$01	

;==============================================================
; Fixed Bank Routines and Handlers
;==============================================================
.INCLUDE "..\\FixedBank\\interruptHandlers.asm"
.INCLUDE "..\\FixedBank\\bankSwitchHandler.asm"
;.INCLUDE "..\\FixedBank\\memoryRoutines.asm"
.INCLUDE "..\\FixedBank\\graphicsRoutines.asm"
.INCLUDE "..\\FixedBank\\gameplayRoutines.asm"
.INCLUDE "..\\FixedBank\\controllerInput.asm"
.INCLUDE "..\\FixedBank\\soundRoutines.asm"
.INCLUDE "..\\FixedBank\\sgb.asm"
;.INCLUDE "..\\FixedBank\\gameStateRoutines.asm" ;Part of HRAM now
.INCLUDE "..\\FixedBank\\hramRoutines.asm"


;==============================================================
; Fixed Bank Classes
;==============================================================
.INCLUDE "..\\FixedBankEntities\\entityListClass.asm"
.INCLUDE "..\\FixedBankEntities\\generalEntityEvents.asm"
.INCLUDE "..\\FixedBankEntities\\kaikuroEntityClass.asm"
.INCLUDE "..\\FixedBank\\columnClass.asm"
;.INCLUDE "..\\FixedBankEntities\\tonbowEntityClass.asm"
.INCLUDE "..\\TonbowEntity\\tonbowEntityClass.asm"


;==============================================================
; Global Variables
;==============================================================
.RAMSECTION "Global Variables" APPENDTO "Entity Classes and Entity List Class Data" RETURNORG
;Player 1 Controller
	;%DULR(ST)(SEL)BA
	previousKeyPress1			db		;The previous state of key presses for player 1
	currentKeyPress1			db		;The current state of key presses for player 1
	newKeyPress1				db		;The most recent state of key presses for player 1
;Player 2 Controller	
	previousKeyPress2			db		;The previous state of key presses for player 2
	currentKeyPress2			db		;The current state of key presses for player 2
	newKeyPress2				db		;The most recent state of key presses for player 2

;Background 
	stdScreenScroll INSTANCEOF 	stdScreenScrollStructure
	;Any special parallax screen scrolling will be declared within the level file
	nextHBlankStep  			dw      ;Variable that tells where to go for next HBlank
	frameFinish					db		;$00 = NO_FINISH, $01 = WRITE_FINISH, $11 = VBLANK_FINISH
	frameCount     		 		db      ;Used to count frames in intervals of 60	
	targetBWPalette				db		;Target palette for a fade in

;Misc
	endBoiler					db		;The last variable

.ENDS

;==============================================================
; Jump Vectors
;==============================================================
	
.BANK 0 SLOT 0
.ORG $0040
VBlank:
	push af
	xor a
	pop af
	reti

.ORG $0100
.SECTION "Vec_Jump" size 4 force
	nop
	jp Start
.ENDS
	
;==============================================================
; Main Code
;==============================================================

.ORG $150
.SECTION "Outer Framework"

Start:
;==============================================================
; Hardware Check
;==============================================================
;Check initial value of A to see if we are running on CGB or DMG/SGB
	nop
	cp CGB_CHECK						;If A == $11, then CGB mode
	jp z, CGBMode

CheckSuperGameBoy:
;Check initial value of C is to see if we are running in SGB mode
	ld a, SGB_CHECK						;If C == $14, then SGB mode
	cp c
	jr nz, DMGMode

SGBMode:
;We are running SGB Hardware
	ld hl, modelType
	ld (hl), SGB_MODE
	jp InitializeGame

DMGMode:
;We are running DMG hardware
	ld hl, modelType
	ld (hl), DMG_MODE
	jp InitializeGame

;We are running on GBC
CGBMode:
;We are running CGB hardware
	ld hl, modelType
	ld (hl), CGB_MODE
	jp InitializeGame

InitializeGame:
;==============================================================
; Initialize basic GB Functions
;==============================================================
;Enable VBlank
	ld a, IEF_VBLANK
    ld (rIE),	a				; VBlank interruption enabled
;Setup stack pointer
	di
	ld sp, $DFF0

;Set up LCDC
	ld a, (rLCDC)
	and %10000000
	or  %00000001
	ld (rLCDC), a
	
;Turn screen off
	call ScreenOff

;Clear VRAM
	ld hl, $8000
	xor a
-:
	ld (hl), a
	inc hl
	bit 5, h
	jp z, -

;Clear OAM
    ld a, 0
    ld b, 160
    ld hl, _OAMRAM
ClearOAM:
    ld (hli), a
    dec b
    jp nz, ClearOAM

SetUpHRAM:
	call DMAToHRAM
	call GameStateRoutineToHRAM
	xor a
	ld ($FF00 + lobyte(changeGameStateFlag)), a
	ld hl, playerOneEntityPointer
	ld bc, ptrF16Bit - playerOneEntityPointer
-:
	xor a
	ldi (hl), a
	dec bc
	ld a, b
	or c
	jr nz, -

ClearWRAM:
;Perform our memory initialization
	xor a
	ld bc, $DFFF - $C000
	ld hl, $C000
-:
	xor a
	ld (hli), a
	dec bc
	or b
	jr nz, -
	or c
	jr nz, -

;==============================================================
; Set up Entity related features
;==============================================================
	;call EntityList@Initialize

;==============================================================
; Set up Columns
;==============================================================
	call ColumnClass@Initialize

;==============================================================
; Main Program Routine
;==============================================================
;Setup our Game State
/*
ld a, lobyte(Title)
	ld ($FF00 + lobyte(nextGameState)), a
	ld a, hibyte(Title)
	ld ($FF00 + (hibyte(nextGameState))), a		;(nextGameState) = HL
	ld a, SFS_TITLE_ROM_BANK
	ld c, lobyte(nextGameStateBank)
	ld ($FF00+c), a
	call HRAM_UpdateGameState
*/
;Set up SFS and Title Bank
	ld hl, currentLevelROMBank
	ld a, SFS_TITLE_ROM_BANK
	ld (hl), a
	
;Turn on the LCD to enable VBlank
	call ScreenOnObj8

MainGameLoop:
;Main Loop Outline
	;We want a big main loop to control the following:
	;The graphics (BG, Window and Sprites) to be updated in a predictable way
	;HBlank/Raster control (Though done in it's own ASM file)
	;Fade in and fade out the screen
	;Check for input on P1 (and maybe P2?)
	;Update Scrolling

;Fade in and out
	;Will be called for from the current state, and current state must be saved
	;We will skip doing anything with the current state and won't updated OBJs or BG Scrolling
	;Will simply fade to black (index 0b11) or fade in from black
	;On finish, it will restore the game state
	;It will be a fixed bank routine

;The CALL Table
	;This table will simply check the current STATE of the game, and then JP to the correct state (SFS, Title, Opening, Stage 1 etc.)
	;--> Maybe we could halve the amount of potential states (255-->127) so that we can use a CALL table instead like this:
	;And BEFORE we make a JP to the CALL Table, we check to see if the current value falls within our 
	;State Max. If it's too big, then we can abort, and perhaps soft reset the game 
	;Same with if it's an odd number (stuck in an infinite loop), we can just back out and reset
/*
;-------------------------------------
; Current State CALL table
;-------------------------------------
;Go to the SteelFinger Studios Splash Screen
	call SFS
;RETURN to MainLoop
    ret                         ;CALL is 3 bytes...
    nop                         ;...RET is only 1...
    nop                         ;...So 2 NOPs are added for cushion
;Go to the スペース蜻蛉 Title screen
	call Title
;RETURN to MainLoop
    ret                         ;CALL is 3 bytes...
    nop                         ;...RET is only 1...
    nop                         ;...So 2 NOPs are added for cushion
;Go to the Opening Cutscene
	call OpeningCustscene
;RETURN to MainLoop
    ret                         ;CALL is 3 bytes...
    nop                         ;...RET is only 1...
    nop                         ;...So 2 NOPs are added for cushion
	.
	.
	.

	;We will also need to initialize our states, but NOT every time, so we will have to keep track of
	;whether or not they've been initialized. 
	;I think we should have a "EndState" Subroutine in the fixed bank to reset any of the variables
	;that are used for any given state such as currentState, holdState, and stateInitComplete

	;ALTERNATIVE IDEA: Instead of a CALL table, we could have a WORD that just saves the 16-address
	;of where we need to JP to for our current state. That way we can INIT once, and then just update
	;the address without having a table. If we put it into HRAM then maybe we can execute it as code
	;instead of having to do a weird JP HL while pushing the current address to the SP????
	;For example, as part of every "EndState" we can update the JP or CALL instruction saved at HRAM
	;For example, a CALL is 3 bytes, $CD NN NN, where NN NN is the 16-bit address. We can save this
	;Address is HRAM, and simply do a write to HRAM of 2 bytes at NN NN, without even changing the CALL
	;Or if we are CALLing to HRAM, perhaps a JP would make more sense. $C3 NN NN
*/

;Wait until it's *not* VBlank
    ld a, (rLY)
    cp 144
    jr nc, MainGameLoop
	@WaitVBlank:
		ld a, (rLY)
		cp 144
		jr c, @WaitVBlank

;Update OAM
@UpdateOAM:
	ld a, hibyte(OAMBuffer)
	call HRAM_RunDMATransfer
@UpdateOAMEnd:

;Update Game State
@UpdateGameState:
;Check if we need to update the game state
	ld a, ($FF00 + lobyte(changeGameStateFlag))
	cp CHANGE_GAME_STATE_FLAG
	jr nz, @UpdateGameStateFinish
		call HRAM_UpdateGameState
@UpdateGameStateFinish:

;Update the current keys being pressed
	call UpdateKeys

;Update all currently active entities
	call EntityListClass@UpdateAllEntities


;Jump to logic to handle the current Game State
	call HRAM_JumpToCorrectGameState

;Restart
	jr MainGameLoop

-:
	nop
	nop
	nop
	jr -
MainGameLoopEnd:

;If we somehow end up here, just reset the Software
	jp Start
	
.ENDS

;==============================================================
; Level Files (Various banks)
;==============================================================
.INCLUDE "..\\SplashScreen\\sfs.asm"
.INCLUDE "..\\TestRoom\\testRoom.asm"













	