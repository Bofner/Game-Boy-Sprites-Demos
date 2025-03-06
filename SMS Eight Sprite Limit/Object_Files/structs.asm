;==============================================================
;All Structs that are sprites MUST have the following
;==============================================================
.struct spriteStruct
    sprNum          db      ;The draw-number of the sprite 
    spriteSize      db      ;$08 or $10 for 8x8 or 8x16
    width           db      ;The width of the OBJ     
    height          db      ;The height of the OBJ
    yPos            db      ;The Y coord of the OBJ's top left corner
    xPos            db      ;The X coord of the OBJ's top left corner
    cc              db      ;The first character code for the OBJ 
    xCenter         db      ;The X coord of the OBJ's center
    yCenter         db      ;The Y coord of the OBJ's center
.endst

;==============================================================
; Hit Box structure
;==============================================================
.struct hitBoxStruct
    y1                    db      ;Top left corner of Hitbox yPos
    x1                    db      ;Top left corner of Hitbox xPos
    y2                    db      ;Bottom right corner of Hitbox yPos
    x2                    db      ;Bottom right corner of Hitbox xPos
    width                 db      ;How far across Hitbox stretches in pixels, if 0, then invincible
    height                db      ;How far down the Hitbox stretches in pixels
.endst

;==============================================================
;Used when writing sprite data to the buffers
;==============================================================
.struct spriteBufferTemporaryVariablesStruct
    spriteSize      db      ;$08 or $10
    width           db      ;Stores the width
    volatileHeight  db      ;Height value that changes
    height          db      ;Stores the height
    yPos            db      ;The Y coord of the OBJ (volatile)
    xPos            db      ;The X coord of the OBJ (volatile)
    volatileXPos    db      ;xPos, but it changes
    cc              db      ;The first character code for the OBJ (volatile)
.endst


;==============================================================
; Palette structure
;==============================================================
.struct paletteStruct
    color0      db
    color1      db
    color2      db
    color3      db
    color4      db
    color5      db
    color6      db
    color7      db
    color8      db
    color9      db
    colorA      db
    colorB      db
    colorC      db
    colorD      db
    colorE      db
    colorF      db
.endst

;==============================================================
; Parallax Scrolling structure
;==============================================================
.struct parallaxScrollStruct
    xPos                    db  ;Actual Value sent to VDP Register 
    xFracPos                dw  ;Fractional position $WHOLELO, FRAC $UNUSED, WHOLEHI
.endst

;==============================================================
; Enemy Structure
;==============================================================
.struct enemyStruct
    hitBox instanceof hitBoxStruct
    state                       db          ;Is it alive? Dead? Dying? Spawning? etc
                                            ;$01 = Alive, $FF = Dying, $00 = Dead
    updateAIPointer             dw          ;Points to the subroutine to update the AI
    instanceof spriteStruct
    yFracPos                    dw          ;Fractional position $WHOLELO, FRAC $UNUSED, WHOLEHI
    xFracPos                    dw          ;
    yVel                        db          ;Velocity %SYYYFFFF 
    xVel                        db          ;Velocity %SXXXFFFF 
    animationTimer              db
    spawnTimer                  db

;Any special enemy traits can go down here
    
.endst

;==============================================================
; Enemy List structure
;==============================================================
.struct enemyListStruct
    shotCount             db      ;How many shots are on screen        
    shotCountMax          db      ;How many enemies are on screen
    enemyCount            db      ;How many enemies are on screen
    enemyCountMax         db      ;How many enemies does the current level allow?
    enemy0                dw      ;Pointer to enemy.hitBox.y1
    enemy1                dw      ;Pointer to enemy.hitBox.y1
    enemy2                dw      ;Pointer to enemy.hitBox.y1
    enemy3                dw      ;Pointer to enemy.hitBox.y1
    enemy4                dw      ;Pointer to enemy.hitBox.y1
    enemy5                dw      ;Pointer to enemy.hitBox.y1
    enemy6                dw      ;Pointer to enemy.hitBox.y1
    enemy7                dw      ;Pointer to enemy.hitBox.y1
    enemy8                dw      ;Pointer to enemy.hitBox.y1
    enemy9                dw      ;Pointer to enemy.hitBox.y1
    enemyA                dw      ;Pointer to enemy.hitBox.y1
    enemyB                dw      ;Pointer to enemy.hitBox.y1
    enemyC                dw      ;Pointer to enemy.hitBox.y1
    enemyD                dw      ;Pointer to enemy.hitBox.y1
    enemyE                dw      ;Pointer to enemy.hitBox.y1
    enemyF                dw      ;Pointer to enemy.hitBox.y1
    removedFlag           db      ;Flag for if enemy is removed from list
.endst


