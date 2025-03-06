.SECTION "HRAM Routines"
;================================================================================
; Anything to do with HRAM
;================================================================================
;DMA Constants
	.DEF	HRAM						$FF80
	.DEF	INITIAL_GAME_STATE			SFS
	.DEF	CHANGE_GAME_STATE_FLAG		$FF
	.DEF	KEEP_GAME_STATE_FLAG		$00

;Parameters: HL = Start address, B = length of write, C = HRAM Address to write to (c, lobyte(ADDRESS))
WriteToHRAM:
	@Copy:
		ld a, (hli)
		ld ($FF00+c), a
		inc c
		dec b
		jr nz, @Copy
		;end
	ret

.ENDS

.SECTION "DMA Transfer"
DMAToHRAM:
	ld hl, DMATransferRoutine
	ld b, DMATransferRoutineEnd-DMATransferRoutine
	ld c, lobyte(HRAM_RunDMATransfer)
	call WriteToHRAM

	ret

;Parameters: A = HIGH BYTE of source address
DMATransferRoutine:
    ld (rDMA), a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 M-cycles
-:
	dec a           ; 1 M-cycle
	jr nz, -    ; 3 M-cycles
    ret
DMATransferRoutineEnd:

.ENDS

.SECTION "Game State Routines"
;================================================================================
; Routines involving the Game State
;================================================================================
;The location of our Current Game State Address must be placed right after our CALL
;The CALL opcode is $CD NN NN, where NN NN is the address we want, which is 1 byte after $CD
;NOTE, we probably need to take BANK SWITCHING into account for this. 
.DEF	GAME_STATE_HRAM_ADDRESS		HRAM_JumpToCorrectGameState + 1


;Parameters: HL = New Game State Address, nextGameStateBank = Address's bank
;MUST RETURN TO FIXED BANK ($00)
;Returns: None
;Affects: A, C, HL, HRAM
UpdateGameState:
;Check if the new Game State is in the same Bank
	ld a, (currentROMBank)
	ld b, a										;B = Current ROM Bank
	ld a, ($FF00 + lobyte(nextGameStateBank))	;A = New Game State Bank
	cp b
	jr z, @BanksOkay
	push hl
		call SwitchROMBank
	pop hl
@BanksOkay:
;Point to the address in the CALL opcode in HRAM
	ld c, lobyte(GAME_STATE_HRAM_ADDRESS)
	ld a, ($FF00 + lobyte(nextGameState))
	ld ($FF00+c), a
	inc c
	ld a, ($FF00 + hibyte(nextGameState))
	ld ($FF00+c), a
	ld a, KEEP_GAME_STATE_FLAG
	ld ($FF00 + lobyte(changeGameStateFlag)), a

	ret
UpdateGameStateEnd:

;Parameters: None
;Returns: None
;Affects: A, C, HL, HRAM
HoldCurrentGameState:
	ld c, lobyte(GAME_STATE_HRAM_ADDRESS)
	ld a, ($FF00+c)
	ld l, a
	inc c
	ld a, ($FF00+c)
	ld h, a
	ld c, lobyte(holdGameState)
	ld a, l
	ld ($FF00+c), a
	inc c
	ld a, h
	ld ($FF00+c), a

	ret
HoldCurrentGameStateEnd:

;--------------------------------
; Initialization of Game State
;--------------------------------
;Only called once at the beginning of the program
GameStateRoutineToHRAM:
;JP to game state
	ld hl, JumpToCorrectGameStateRoutine
	ld b, JumpToCorrectGameStateRoutineEnd-JumpToCorrectGameStateRoutine
	ld c, lobyte(HRAM_JumpToCorrectGameState)
	call WriteToHRAM
;Hold State
	ld hl, HoldCurrentGameState
	ld b, HoldCurrentGameStateEnd-HoldCurrentGameState
	ld c, lobyte(HRAM_HoldCurrentGameState)
	call WriteToHRAM
;Update Game State
	ld hl, UpdateGameState
	ld b, UpdateGameStateEnd-UpdateGameState
	ld c, lobyte(HRAM_UpdateGameState)
	call WriteToHRAM

	ret

;This is the initial state that our Game State should be in. NOTE: the Game State will change 
JumpToCorrectGameStateRoutine:
	call INITIAL_GAME_STATE
	ret
JumpToCorrectGameStateRoutineEnd:

.ENDS

.RAMSECTION "HRAM" BANK 0 SLOT 4 ORGA HRAM RETURNORG FORCE
;The DMA Transfer Routine
	HRAM_RunDMATransfer				dsb 	DMATransferRoutineEnd-DMATransferRoutine
;Game State Routine
	HRAM_JumpToCorrectGameState		dsb		JumpToCorrectGameStateRoutineEnd-JumpToCorrectGameStateRoutine
	HRAM_HoldCurrentGameState		dsb		HoldCurrentGameStateEnd-HoldCurrentGameState
	HRAM_UpdateGameState			dsb		UpdateGameStateEnd-UpdateGameState
	
;Game States Data
	holdGameState					dw		;Game State Held for Fades or some other future reason
	changeGameStateFlag				db		;Check if we want to change the game state
	nextGameState					dw		;The Game State we want to switch to
	nextGameStateBank				db		;The bank data for the next game state
;Hardware version
	modelType						db		;Are we running on DMG ($00), SGB ($01), or CGB ($02)
;Player Data
	playerOneEntityPointer			dw		;Pointer to the Player One entity
	playerTwoEntityPointer			dw		;Pointer to the Player Two entity
	playerThreeEntityPointer		dw		;Pointer to the Player Three entity
	playerFourEntityPointer			dw		;Pointer to the Player Four entity
;8-Bit Variables
	aux8BitVar        				db		;Used for any kind of 8-bit variable we need
	temp8BitA						db		;Temporary 8-bit Data Storage
	temp8BitB						db		;Temporary 8-bit Data Storage
	temp8BitC						db		;Temporary 8-bit Data Storage
	temp8BitD						db		;Temporary 8-bit Data Storage
	temp8BitE						db		;Temporary 8-bit Data Storage
	temp8BitF						db		;Temporary 8-bit Data Storage
;16-Bit Variables
	aux16BitVar        				dw		;Used for any kind of 16-bit variable we need
	ptrA16Bit 						dw		;Used to point to a 16 bit address
	ptrB16Bit 						dw		;Used to point to a 16 bit address
	ptrC16Bit 						dw		;Used to point to a 16 bit address
	ptrD16Bit 						dw		;Used to point to a 16 bit address
	ptrE16Bit 						dw		;Used to point to a 16 bit address
	ptrF16Bit 						dw		;Used to point to a 16 bit address

.ENDS

;Player Constants
.DEF	playerOneEntityPointerLO	lobyte(playerOneEntityPointer)
.DEF	playerOneEntityPointerHI	lobyte(playerOneEntityPointer + 1)	
.DEF	PLAYER_ONE_ENTITY			$01
.DEF	PLAYER_TWO_ENTITY			$02
.DEF	PLAYER_THREE_ENTITY			$03
.DEF	PLAYER_FOUR_ENTITY			$04

.DEF	aux16BitVarLO				lobyte(aux16BitVar)
.DEF	aux16BitVarHI				lobyte(aux16BitVar + 1)
.DEF	ptrA16BitLO					lobyte(ptrA16Bit)
.DEF	ptrA16BitHI					lobyte(ptrA16Bit + 1)
.DEF	ptrB16BitLO					lobyte(ptrB16Bit)
.DEF	ptrB16BitHI					lobyte(ptrB16Bit + 1)
.DEF	ptrC16BitLO					lobyte(ptrC16Bit)
.DEF	ptrC16BitHI					lobyte(ptrC16Bit + 1)
.DEF	ptrD16BitLO					lobyte(ptrD16Bit)
.DEF	ptrD16BitHI					lobyte(ptrD16Bit + 1)
.DEF	ptrE16BitLO					lobyte(ptrE16Bit)
.DEF	ptrE16BitHI					lobyte(ptrE16Bit + 1)
.DEF	ptrF16BitLO					lobyte(ptrF16Bit)
.DEF	ptrF16BitHI					lobyte(ptrF16Bit + 1)
