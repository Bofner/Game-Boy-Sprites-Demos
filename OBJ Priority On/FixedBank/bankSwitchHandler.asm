.RAMSECTION "Bank Switching RAM" BANK 0 SLOT 3 RETURNORG
;Bank Switching
	currentROMBank       		db		;Indicates the ROM bank currently being used
	currentLevelROMBank			db		;Indicates which ROM bank is being used for the level code
	currentSRAMBank       		db		;Indicates the SRAM bank currently being used
	backUpROMBank				db		;Used for checking if we need to switch banks
.ENDS

.SECTION "Bank Switching"
;================================================================================
; All subroutines and data related to bank switching
;================================================================================
;Bank Data
	.DEF	START_SRAM_BANK_SWITCH		$4000
	.DEF	START_ROM_BANK_SWITCH		$2000
	.DEF	TOGGLE_SRAM					$1000
	.DEF	SRAM_ON						$0A
	.DEF	SRAM_OFF					$00
;Banks
	.DEF	FIXED_ROM_BANK				$00
	.DEF	SFS_TITLE_ROM_BANK			$01
	.DEF	TEST_ROOM_BANK				$03

;==============================================================
; Handles ROM Bank Switching
;==============================================================
;
;Parameters: A = Desired bank to switch to
;Returns: None
;Affects: HL
SwitchROMBank:
	ld hl, START_ROM_BANK_SWITCH
	ld (hl), a
	ld hl, currentROMBank
	ld (hl), a

	ret

;==============================================================
; Handles SRAM Bank Switching
;==============================================================
;
;Parameters: A = Desired bank to switch to $00-$03
;Returns: None
;Affects: HL
SwitchSRAMBank:
	ld hl, START_SRAM_BANK_SWITCH
	ld (hl), a
	ld hl, currentSRAMBank
	ld (hl), a

	ret


;==============================================================
; Turns SRAM on or off
;==============================================================
;
;Parameters: A = SRAM_ON or SRAM_OFF
;Returns: None
;Affects: HL
ToggleSRAM:
	ld hl, TOGGLE_SRAM
	ld (hl), a

	ret

.ENDS