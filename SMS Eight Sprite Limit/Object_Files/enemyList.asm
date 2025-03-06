;================================================================
; Handles anything dealing with the Enemy List
;================================================================

;================================================================
; Add enemy to enemy list
;================================================================
;Add an enemy to the Enemy list in the first ZERO location
;Parameters: DE = enemy.hitBox.width
;Affects: HL, DE, B
AddToEnemyList:
;First, check and make sure that we have don't have too many enemies
    ld hl, enemyList.enemyCount
    ld a, (hl)
    inc hl                          ;ld hl, enemyList.enemyLevelMax
    cp (hl)
    ret nc                          ;If we are at max, then don't add
;Enter loop for finding nearest ZERO enemy
    ld b, $0F
    dec hl                          ;ld hl, enemyList.enemyCount
;And update Enemy Counter
    inc (hl)
-:
    inc hl                          ;We are dealing with WORDS
    inc hl                          ;ld hl, enemyList.enemyX
    ld a, (hl)
    cp $00
    jp z, PlaceEnemyInList          ;If ZERO, then we can add enemy here
    djnz -
PlaceEnemyInList:
;Add enemy to list (Little endian)
    ld (hl), e
    inc hl
    ld (hl), d

ListAddEnd:
    ret


;================================================================
; Remove an enemy from the list
;================================================================
;Remove an enemy from the Enemy list and move any other enemies up the list so we leave no gaps
;Parameters: HL = enemyList.enemyX, C = enemy number
;Affects: HL, DE, A, C
RemoveFromEnemyList:
;Set current enemy to ZERO
    ;ld hl, enemyList.enemyX LO
    ld (hl), $00
    inc hl                              ;ld hl, enemyList.enemyX HI
    ld (hl), $00
    ld a, (enemyList.enemyCount)
    cp c
    jp z, ListRemoveEnd                ;If we are removing the last enemy, dont move other up
;Move the rest of the enemies up the list, and replace them with zeros when moved
-:
    inc hl                              ;ld hl, enemyList.enemyX+1 LO
    ld d, (hl)
    ld (hl), $00
    inc hl                              ;ld hl, enemyList.enemyX+1 HI
    ld e, (hl)
    ld (hl), $00
    dec hl                              ;ld hl, enemyList.enemyX+1 LO
    dec hl                              ;ld hl, enemyList.enemyX HI
    ld (hl), e
    dec hl                              ;ld hl, enemyList.enemyX LO
    ld (hl), d
    ld de, $0003
    add hl, de                          ;ld hl, enemyList.enemyX+2 LO
    inc c
    ld a, (enemyList.enemyCount)        
    cp $01                              ;If we only had 1 enemy, then we are done
    jp z, ListRemoveEnd
    sub a, $02                          ;Otherwise, check if our enemy counter > remaining enemies
    cp c
    jr nc, -
ListRemoveEnd:
;Update current Enemy count
    ld hl, enemyList.enemyCount
    dec (hl)
    ld hl, enemyList.removedFlag
    ld (hl), $01

    ret


;================================================================
; Check if we have collision with an Enemy
;================================================================
;Check if Tonbow is taking damage from an enemy on Screen
;Parameters: 
;Affects: HL, DE, BC, A
CheckHitCollision:
;Check if Tonbow is attacking
    ;ld a, (tonbow.dashState)
    ;bit 0, a
    ;call nz, CheckTonbowAttackCollision

    ld hl, enemyList.enemyCount 
    ld b, (hl)                  ;Number of enemies saved for our DJNZ loop
    ld a, $00
    cp b
    ret z                       ;If we have no enemies, don't check
    ld c, $00                   ;This will keep track of how many loops we've gone through
-:
    ld hl, enemyList.enemy0         ;(HL) now points to enemy0.hitBox.width
    ld d, $00
    ld a, c                         ;\
    add a, a                        ;/ Double C since we are jumping with WORDS
    ld e, a
    add hl, de                      ;(HL) now points to enemy[C].hitBox.width
    ld e, (hl)                      ;\
    inc hl                          ; } Little Endian, ld de, (hl)
    ld d, (hl)                      ;/
    ld hl, tonbow.hitBox.width
    push bc
        call CheckCollisionTwoHitboxes  
    pop bc                          
    bit 0, a                        ;\ If Tonbow is colliding with enemy, then it is dead
    jp nz, TonbowDead               ;/  Use a JP because we don't need to check more if dead
    inc c
    djnz -
EnemyCollisionCheckEnd:

    ret

;Tonbow is attacking
CheckTonbowAttackCollision:
    ld hl, enemyList.enemyCount 
    ld b, (hl)                      ;Number of enemies saved for our DJNZ loop
    ld a, $00
    cp b
    ret z                           ;If we have no enemies, don't check
    ld c, $00                       ;This will keep track of how many loops we've gone through
-:
    ld hl, enemyList.enemy0         ;(HL) now points to enemy0.hitBox.width
    ld d, $00
    ld a, c                         ;\
    add a, a                        ;/ Double C since we are jumping with WORDS
    ld e, a
    add hl, de                      ;(HL) now points to enemy[C].hitBox.width
    ld e, (hl)
    inc hl
    ld d, (hl)
    ;ld hl, tonbow.hurtBox.width
    push bc
        call CheckCollisionTwoHitboxes  
    pop bc                          
    bit 0, a   
    push bc
        call nz, EnemyIsDead              ;If Enemy was hit, then make it dead
    pop bc    
+:
    inc c
    djnz -
    ret
EnemyIsDead:
;Set enemy to be dying, it'll die on it's own
    ex de, hl                   ;HL = enemyStruct.hitBox.y2 
    ld de, enemyStruct.state - enemyStruct.hitBox.y2
    add hl, de
    ld (hl), $FF   
;Set hitbox to zero for the time being, if it's still alive, the enemy will turn it back on
    ld de, enemyStruct.hitBox.width - enemyStruct.state
    add hl, de    
    ld (hl), 0                      ;ld hl, demoOrb.animationTimer
;Adjust player's score
    jp PlusScore
    ;ret


;================================================================
; Update all enemy AI
;================================================================
UpdateEnemyAI:
;This needs to be made so it can be generalized to update ALL enemies
;In our Enemy List, we will set the UpdateEnemy address of the current enemy to HL, then
;JP HL. But FIRST, we will CALL SavePCForJPHL so that we can return
;If there's no enemies, don't try to update them
    ld a, (enemyList.enemyCount)
    ld b, a                         ;For our DJNZ counter
    cp $00
    ret z                           ;If we have no enemies, don't check
;Otherwise, update the enemies AI
    ld c, $00                       ;Set C to be our counter
;Select the current enemy that we want to update
-:
    ld hl, enemyList.enemy0         ;(HL) now points to enemy0.hitBox.width
    ld d, $00     
    ld a, c                         ;\
    add a, a                        ;/ Double C since we are jumping with WORDS
    ld e, a
    add hl, de                      ;(HL) now points to enemy[C].hitBox.width
    ld e, (hl)
    inc hl
    ld d, (hl)                      ;DE = enemy[C].hitBox.width 
;Check if enemy is alive or not
    ex de, hl
    ld de, enemyStruct.state - enemyStruct.hitBox.width
    add hl, de                      ;ld hl, enemy.state
    ld a, (hl)
    cp $00
    jr nz, +
;If dead, then remove from list
    ld hl, enemyList.enemy0     ;HL now points to enemyList.enemy0
    ld d, $00
    ld a, c                     ;C still holds the number of enemies we've checked
    add a, a                    ;Double because enemies stored as WORDS
    ld e, a 
    add hl, de                  ;HL now points to enemyList.enemy(the one that is now dead)
    push bc
    call RemoveFromEnemyList
    pop bc
    djnz -
    ret
+:
;Point to that enemy's Update-Subroutine
    ld de, enemyStruct.updateAIPointer - enemyStruct.state
    add hl, de                      ;ld hl, enemy.updateAIPointer, points to desitred subroutine
    ld e, (hl)
    inc hl
    ld d, (hl)
    push de
        ld de, enemyStruct.state - (enemyStruct.updateAIPointer + 1)        ;We are on the HI bit
        add hl, de
    pop de
    ex de, hl                       ;HL = Subroutine JP location
    push bc
;Save the current Program Counter
    call SavePCForJPHL              ;\
    jp (hl)                         ;/ call hl
    pop bc
    inc c                           ;Keep track of how many enemies we've updated
    djnz -

    ret

;================================================================
; Update Enemy Graphics
;================================================================
;Updates the SAT Buffer with enemy sprites
;Parameters: None
;Affects: HL, BC, A
UpdateEnemySprites:
;Check how many enemies we have to update
    ld a, (enemyList.enemyCount)
    ld b, a                         ;For our DJNZ counter
    cp $00                          ;If there's no enemies, don't try to update them
    ret z                           ;If we have no enemies, don't check
;Otherwise, update the enemies AI
    ld c, $00                       ;Set C to be our counter
;Select the current enemy that we want to update
-:
    ld hl, enemyList.enemy0         ;(HL) now points to enemy0.hitBox.width
    ld d, $00     
    ld a, c                         ;\
    add a, a                        ;/ Double C since we are jumping with WORDS
    ld e, a
    add hl, de                      ;(HL) now points to enemy[C].hitBox.width
    ld e, (hl)
    inc hl
    ld d, (hl)                      ;DE = enemy[C].hitBox.width 
;Point to that enemy's sprNum
    ex de, hl
    ld de, enemyStruct.sprNum - enemyStruct.hitBox.width
    add hl, de                      ;ld hl, enemy.sprNum
    push bc
        call MultiUpdateSATBuff  
    pop bc
    inc c
    djnz -

    ret

;================================================================
; Initialization
;================================================================
;Initializes the enemy list
;Parameters: A = Max number of enemies on screen
;Affects: HL, B
InitEnemyList:
    ld hl, enemyList.enemyCount
    ld (hl), 0
    inc hl                          ;ld hl, enemyList.enemyLevelMax
    ld (hl), a
    ld b, $10
-:
    inc hl                          ;ld hl, enemyList.enemy.hitBox.y1 LO
    ld (hl), 0
    inc hl                          ;ld hl, enemyList.enemy.hitBox.y1 HI
    ld (hl), 0
    djnz -
    inc hl                          ;ld hl, removedFlag
    ld (hl), 0

    ret

    