.SECTION "Game State Routines"
;================================================================================
; Routines involving the Game State
;================================================================================
;The location of our Current Game State Address must be placed right after our CALL
;The CALL opcode is $CD NN NN, where NN NN is the address we want, which is 1 byte after $CD
;NOTE, we probably need to take BANK SWITCHING into account for this. 
.DEF	GAME_STATE_HRAM_ADDRESS		JumpToCorrectGameState + 1
.DEF	INITIAL_GAME_STATE			SFS

;Parameters: HL = New Game State Address
;Returns: None
;Affects: A, C, HL, HRAM
UpdateGameState:
;Point to the address in the CALL opcode in HRAM
	ld c, lobyte(GAME_STATE_HRAM_ADDRESS)
	ld a, l
	ld ($FF00+c), a
	inc c
	ld a, h
	ld ($FF00+c), a

	ret

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


;--------------------------------
; Initialization of Game State
;--------------------------------
;Only called once at the beginning of the program
GameStateRoutineToHRAM:
	ld hl, JumpToCorrectGameStateRoutine
	ld b, JumpToCorrectGameStateRoutineEnd-JumpToCorrectGameStateRoutine
	ld c, lobyte(JumpToCorrectGameState)
	call WriteToHRAM

	ret

;This is the initial state that our Game State should be in. NOTE: the Game State will change 
JumpToCorrectGameStateRoutine:
	call INITIAL_GAME_STATE
	ret
JumpToCorrectGameStateRoutineEnd:

.ENDS