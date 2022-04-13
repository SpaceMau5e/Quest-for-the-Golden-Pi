;Created by Devin Kaltenbaugh
;Version 1.5 Dev Edition

INCLUDE "emu8086.inc"

org 100h

;Hide flashing cursor
mov CH, 32                                          
mov AH, 1h                                          
int 10h                                             

;Wipe the screen       
call CLEAR_SCREEN                                                                                                                 

call textRender

call SceneManager

ret 

SceneManager Proc
    
    call CLEAR_SCREEN
    
    Intro:   
    call mapRender
    
    call spawnPlayer
    
    call textRender
    call textRender
    
    call NPCManager
    
    inc sceneNPC
    
    call NPCManager
    
    call textRender
    call textRender
    
    inc sceneNPC
    
    call NPCManager
    
    call CLEAR_SCREEN
    
    Maze:
    
    mov sceneMap, 1
    
    call mapRender
    
    call spawnPlayer
                     
    gameLoop:
        cmp ItemsManagerOn, 1
        jnz checkWin:             
            call ItemsManager
        
        checkWin:
        cmp hasPi, 1
        jnz checkLost:
            cmp xPos, 14
            jnz checkLost:
                cmp yPos, 14
                jnz checkLost:
                    jmp hasWon:
                    
        checkLost:
        cmp hasKilled, 1
        jnz checkInput:
            jmp hasLost:
        
        checkInput:  
        mov Ah, 1h
        int 16h ;Check for buffer input 
        jz no_Input:
            
        mov AH, 0h
        int 16h ;Pulld buffered input
        
        call playerMove ;Run the playerMove procedure
        
        checkStalk:
        cmp hasKilled, 1
        jz checkLost:
            cmp isStalk, 1
            jz startStalker:
                cmp hasPi, 1
                jnz no_input:
                    cmp xPos, 2
                    jnz no_input:
                        cmp yPos, 1
                        jnz no_input:
                            
                            inc isStalk
                            call spawnStalker
                            
                            mov sceneText, 11
                            
                            call textRender
                            
                            jmp no_input:
                            
                            startStalker:
                            call followOn 
        
        no_Input:    
        jmp gameLoop:
    
    hasLost:
    call CLEAR_SCREEN
    
    mov sceneMap, 0
    
    call mapRender
    
    mov sceneNPC, 5
    
    call NPCManager
    
    mov sceneText, 7
    
    call textRender
    call textRender
    
    mov sceneNPC, 4
    
    call NPCManager
    
    mov sceneText, 10
    
    call textRender
    
    hlt
    
    hasWon:
    call CLEAR_SCREEN
    
    mov sceneMap, 0
    
    call mapRender
    
    mov sceneNPC, 3
    
    call NPCManager
    
    mov sceneText, 5
    
    call textRender
    call textRender
    
    inc sceneNPC
    
    call NPCManager
    
    mov sceneText, 9
    
    call textRender      
       
    hlt
    ret
SceneManager Endp



DEFINE_CLEAR_SCREEN

checkCount DW ?

holdB DW ?

sceneMap DB 0
 
mapRender Proc
    
    map1:
    cmp sceneMap, 0
    jnz map2:
    mov CX, throneRoomend - offset throneRoom     
    mov BP, offset throneRoom
    jmp drawMap:     
         
    map2: 
    mov CX, mazeRoomend - offset mazeRoom     
    mov BP, offset mazeRoom
    
    drawMap:
    mov AL, 1
	mov BH, 0
	mov BL, 0000_0111b 
	mov DL, 0
	mov DH, 0
	push CS
	pop ES
	mov AH, 13h
	int 10h
	
	call drawProps
	
	inc sceneMap
    ret
mapRender Endp

mazeRoom DB 0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh, 0Ah, 0Dh 
         DB 0DBh,0,0,0,0,0,0DBh,0DBh,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0DBh,0,0DBh,0DBh,0,0,0DBh,0,0DBh,0DBh,0DBh,0DBh,0,0DBh,0DBh, 0Ah, 0Dh
         DB 0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0,0,0,0,0,0DBh,0,0DBh,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0,0DBh,0,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0,0DBh,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0DBh,0DBh,0,0,0,0,0,0,0,0,0DBh,0,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0DBh,0DBh,0,0DBh,0,0DBh,0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0,0,0,0DBh,0,0,0DBh,0,0,0DBh,0DBh,0DBh,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0DBh,0DBh,0,0,0,0DBh,0DBh,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0DBh,0,0DBh,0,0DBh,0,0,0DBh,0,0DBh,0,0,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0DBh,0,0DBh,0,0DBh,0DBh,0,0DBh,0,0DBh,0DBh,0DBh,0DBh,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0,0,0,0,0DBh,0DBh,0,0,0DBh,0DBh,0,0,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0DBh,0,0DBh,0,0DBh,0,0,0DBh,0,0DBh,0,0,0DBh,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0DBh,0,0DBh,0,0DBh,0,0DBh,0DBh,0,0DBh,0DBh,0,0DBh,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0,0,0DBh,0,0,0,0DBh,0DBh,0,0,0,0,0DBh,0,0DBh, 0Ah, 0Dh
         DB 0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh, 0Ah, 0Dh
mazeRoomend:  

throneRoom DB 0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh, 0Ah, 0Dh   
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh   
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh    
           DB 0DBh,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh, 0Ah, 0Dh    
           DB 0DBh,0,0DBh,0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0,0DBh, 0Ah, 0Dh     
           DB 0DBh,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh, 0Ah, 0Dh       
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh        
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh         
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh          
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh           
           DB 0DBh,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh, 0Ah, 0Dh             
           DB 0DBh,0,0DBh,0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0DBh,0DBh,0DBh,0,0,0DBh, 0Ah, 0Dh                
           DB 0DBh,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh,0,0,0,0DBh, 0Ah, 0Dh                  
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh                 
           DB 0DBh,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0DBh, 0Ah, 0Dh                      
           DB 0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh,0DBh, 0Ah, 0Dh
throneRoomend:                                                                                         

drawProps Proc
    
    Props0:
    cmp sceneMap, 0
    jnz Props1:
    jmp placeProps0
    
    Props1:
    cmp sceneMap, 1
    jmp placeProps1
    
    
    placeProps0:
    
    mov CX, ArLimit
    mov BX, 0
    drawLoop:
        mov checkCount, CX
        mov holdB, BX
        
        mov DH, yPosAr + BX
        mov DL, xPosAr + BX
        mov BX, 0
        mov AH, 2h
        int 10h
        
        mov BX, holdB
        
        mov AL, charAr + BX
        mov BL, colorAr + BX
        mov BH, 0
        mov CX, 1
        mov AH, 9h
        int 10h
        
        mov BX, holdB
        mov CX, checkCount
        
        inc BX
        
        loop drawLoop
        
    jmp drawPropsend:
    
    
    placeProps1:
    mov DH, 14
    mov DL, 15
    mov BH, 0
    mov AH, 2h
    int 10h
    
    mov AL, 219
    mov CX, 1
    mov BL, 6
    mov AH, 9h
    int 10h
    
    drawPropsend:
    ret
drawProps Endp

charAr DB 219,219,219,2,2,205,205,187,188,186,186

colorAr DB 6,6,6,4,3,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh

xPosAr DB 0,0,15,13,13,13,13,14,14,14,14

yPosAr DB 7,8,10,8,7,6,9,6,9,8,7

ArLimit equ 11



npcHoldB DW ?

npcAdventurer DB 4,4,4,4,4,4,4,4,4,4,0

npcHunter0 DB 3,4,3,4,3,9

npcHunter1 DB 4,4,4,4,4,4,4,4,4,4,0

npcSurvivor DB 2,2,2,2,2,2,2,2,2,2,9

npcDaughter DB 4,4,1,4,1,9

movLimit = 11

npcChar DB 0
npcColor DB 0
npcXPos DB 16
npcYPos DB 16

sceneNPC DB 0

NPCManager Proc
    
    posAdventurer:
    cmp sceneNPC, 0
    jnz posHunter0:
    mov npcXPos, 11
    mov npcYPos, 7
    jmp moveCursor:
        
    posHunter0:
    cmp sceneNPC, 1
    jnz posHunter1:
    mov npcXPos, 13
    mov npcYPos, 4
    jmp moveCursor:
        
    posHunter1:
    cmp sceneNPC, 2
    jnz posSurvivor:
    mov npcXPos, 11
    mov npcYPos, 7
    jmp moveCursor:
        
    posSurvivor:
    cmp sceneNPC, 3
    jnz posDaughter:
    mov npcXPos, 1
    mov npcYPos, 7
    jmp moveCursor:
        
    posDaughter:
    cmp sceneNPC, 4
    jnz posKiller:
    mov npcXPos, 14
    mov npcYPos, 10
    jmp moveCursor:
        
    posKiller:
    cmp sceneNPC, 5
    mov npcXPos, 1
    mov npcYPos, 7
    
    moveCursor:
    mov DH, npcYPos
    mov DL, npcXPos
    mov BH, 0
    mov AH, 2h
    int 10h
    
    mov CX, movLimit
    mov BX, 0
    
    npcMovementLoop:
        mov checkCount, CX
        mov npcHoldB, BX
        
        mov DH, npcYPos
        mov DL, npcXPos
        
        mov AL, 0
        mov BH, 0
        mov CX, 1
        mov AH, 9h
        int 10h
        
        mov BX, npcHoldB
        
        Adventurer:
        cmp sceneNPC, 0
        jnz Hunter0:
        mov npcChar, 1
        mov npcColor, 0eh
        mov AL, npcAdventurer + BX
        jmp moveChar:
        
        Hunter0:
        cmp sceneNPC, 1
        jnz Hunter1:
        mov npcChar, 2
        mov npcColor, 2h
        mov AL, npcHunter0 + BX
        jmp moveChar:        
        
        Hunter1:
        cmp sceneNPC, 2
        jnz Survivor:
        mov npcChar, 2
        mov npcColor, 2h
        mov AL, npcHunter1 + BX
        jmp moveChar: 
        
        Survivor:
        cmp sceneNPC, 3
        jnz Daughter:
        mov npcChar, 1
        mov npcColor, 0eh
        mov AL, npcSurvivor + BX
        jmp moveChar: 
        
        Daughter:
        cmp sceneNPC, 4
        jnz Killer:
        mov npcChar, 2
        mov npcColor, 0dh
        mov AL, npcDaughter + BX
        jmp moveChar: 
        
        Killer:
        cmp sceneNPC, 5
        mov npcChar, 2
        mov npcColor, 2
        mov AL, npcSurvivor + BX    
        
        
        moveChar:
        cmp AL, 9
        jz nullChar:
        
        checkUp:
        cmp AL, 1
        jnz checkRight:
        dec DH
        jmp writeChar:
        
        checkRight:
        cmp AL, 2
        jnz checkDown:
        inc DL
        jmp writeChar:
        
        checkDown:
        cmp AL, 3
        jnz checkLeft:
        inc DH
        jmp writeChar:
        
        checkLeft:
        cmp AL, 4
        jnz EraseChar:
        dec DL
        
        writeChar:
        mov BH, 0
        mov AH, 2h
        int 10h
        
        mov npcYPos, DH
        mov npcXPos, DL
        
        mov AL, npcChar
        mov BL, npcColor
        mov CX, 1
        mov AH, 9h
        int 10h
        jmp loopInc:
        
        EraseChar:
        mov BH, 0
        mov AH, 2h
        int 10h
        
        mov AL, 0
        mov BL, 0
        mov CX, 1
        mov AH, 9h
        int 10h
        jmp loopInc
        
        nullChar:
        mov checkCount, 1
        
        mov BH, 0
        mov AH, 2h
        int 10h
        
        mov AL, npcChar
        mov BL, npcColor
        mov CX, 1
        mov AH, 9h
        int 10h
        jmp loopInc
        
        loopInc:
        mov AH, 86h
        mov CX, 07h
        mov DX, 240h
        int 15h
        
        mov CX, checkCount
        mov BX, npcHoldB
        inc BX
        
        loop npcMovementLoop 
    
    
    mov AX, 0
    mov BX, 0
    mov CX, 0    
    ret
NPCManager Endp


sceneText DB 0

textRender Proc
       
    check0:
    cmp sceneText, 0
    jnz check1:
    mov CX, welcomeMsgend - offset welcomeMsg
    mov BP, offset welcomeMsg
    jmp runText:
    
    check1:
    cmp sceneText, 1
    jnz check2:
    mov CX, introTextKing1end - offset introTextKing1
    mov BP, offset introTextKing1
    jmp runText:
    
    check2:
    cmp sceneText, 2
    jnz check3:
    mov CX, introTextKing2end - offset introTextKing2
    mov BP, offset introTextKing2
    jmp runText:
    
    check3:
    cmp sceneText, 3
    jnz check4:
    mov CX, introTextHunter1end - offset introTextHunter1
    mov BP, offset introTextHunter1
    jmp runText:
    
    check4:
    cmp sceneText, 4
    jnz check5:
    mov CX, introTextHunter2end - offset introTextHunter2
    mov BP, offset introTextHunter2
    jmp runText:
    
    check5:
    cmp sceneText, 5
    jnz check6:
    mov CX, endingTextKingW1end - offset endingTextKingW1
    mov BP, offset endingTextKingW1
    jmp runText:
    
    check6:
    cmp sceneText, 6
    jnz check7:
    mov CX, endingTextKingW2end - offset endingTextKingW2
    mov BP, offset endingTextKingW2
    jmp runText:
    
    check7:
    cmp sceneText, 7
    jnz check8:
    mov CX, endingTextKingL1end - offset endingTextKingL1
    mov BP, offset endingTextKingL1
    jmp runText:
    
    check8:
    cmp sceneText, 8
    jnz check9:
    mov CX, endingTextKingL2end - offset endingTextKingL2
    mov BP, offset endingTextKingL2
    jmp runText:
    
    check9:
    cmp sceneText, 9
    jnz check10:
    mov CX, survivedMsgend - offset survivedMsg
    mov BP, offset survivedMsg
    jmp runText:
    
    check10:
    cmp sceneText, 10
    jnz check11:
    mov CX, diedMsgend - offset diedMsg
    mov BP, offset diedMsg
    
    check11:
    cmp sceneText, 11
    jnz endProc:
    mov CX, hunterMsgend - offset hunterMsg
    mov BP, offset hunterMsg
    
    runText:
    mov AL, 1
    mov BH, 0
    mov BL, 0000_1011b 
    mov DL, 0
    mov DH, 17
    push CS
    pop ES
    mov AH, 13h
    int 10h
    
    endProc:
    inc sceneText
    
    mov CX, 4ch
    mov DX, 4840h
    mov AH, 86h
    int 15h
    
    ret
textRender Endp


endingTextKingW1 DB "================================", 0Ah, 0Dh
                 DB "| Young Adventurer,            |", 0Ah, 0Dh
                 DB "|   You have managed to find   |", 0Ah, 0Dh
                 DB "|   the golden pi and avoid    |", 0Ah, 0Dh
                 DB "|   hunter. As a reward for    |", 0Ah, 0Dh
                 DB "|   this heroic act I give you |", 0Ah, 0Dh
                 DB "================================", 0Ah, 0Dh
endingTextKingW1end:
    
endingTextKingW2 DB "================================", 0Ah, 0Dh
                 DB "|   my daughters hand in       |", 0Ah, 0Dh
                 DB "|   marriage. Come on out my   |", 0Ah, 0Dh
                 DB "|   darling Clare.             |", 0Ah, 0Dh
                 DB "|                              |", 0Ah, 0Dh
                 DB "|                              |", 0Ah, 0Dh
                 DB "================================", 0Ah, 0Dh
endingTextKingW2end:

endingTextKingL1 DB "================================", 0Ah, 0Dh
                 DB "| Sir Hunter,                  |", 0Ah, 0Dh
                 DB "|   You have returned with     |", 0Ah, 0Dh
                 DB "|   the golden pi before the   |", 0Ah, 0Dh
                 DB "|   young adventurer. So as    |", 0Ah, 0Dh
                 DB "|   promised I will give you   |", 0Ah, 0Dh
                 DB "================================", 0Ah, 0Dh
endingTextKingL1end:

endingTextKingL2 DB "================================", 0Ah, 0Dh
                 DB "|   my daughters hand in       |", 0Ah, 0Dh
                 DB "|   marriage. Come on out my   |", 0Ah, 0Dh
                 DB "|   dear Clare.                |", 0Ah, 0Dh
                 DB "|                              |", 0Ah, 0Dh
                 DB "|                              |", 0Ah, 0Dh
                 DB "================================", 0Ah, 0Dh
endingTextKingL2end:

introTextKing1 DB "================================", 0Ah, 0Dh
               DB "| Young Adventurer,            |", 0Ah, 0Dh
               DB "|   I have a quest for you,    |", 0Ah, 0Dh
               DB "|   find me the golden pi      |", 0Ah, 0Dh
               DB "|   which was lost in the      |", 0Ah, 0Dh
               DB "|   maze some years ago. And   |", 0Ah, 0Dh
               DB "================================", 0Ah, 0Dh
introTextKing1end:
    
introTextKing2 DB "================================", 0Ah, 0Dh
               DB "|   should you succeed I will  |", 0Ah, 0Dh
               DB "|   reward you greatly. Now    |", 0Ah, 0Dh
               DB "|   go forth into the maze     |", 0Ah, 0Dh
               DB "|   brave young adventurer.    |", 0Ah, 0Dh
               DB "|                              |", 0Ah, 0Dh
               DB "================================", 0Ah, 0Dh
introTextKing2end:

introTextHunter1 DB "================================", 0Ah, 0Dh
                 DB "| My Lord,                     |", 0Ah, 0Dh
                 DB "|   I swear to you I will      |", 0Ah, 0Dh
                 DB "|   return with the golden     |", 0Ah, 0Dh
                 DB "|   pi before that adventurer  |", 0Ah, 0Dh
                 DB "|   And as a reward, I ask     |", 0Ah, 0Dh
                 DB "================================", 0Ah, 0Dh
introTextHunter1end:
    
introTextHunter2 DB "================================", 0Ah, 0Dh
                 DB "|   that simply give me your   |", 0Ah, 0Dh
                 DB "|   daughters hand in          |", 0Ah, 0Dh
                 DB "|   marriage.                  |", 0Ah, 0Dh
                 DB "|                              |", 0Ah, 0Dh
                 DB "|                              |", 0Ah, 0Dh
                 DB "================================", 0Ah, 0Dh
introTextHunter2end:

welcomeMsg DB "================================", 0Ah, 0Dh
           DB "|/                            \|", 0Ah, 0Dh
           DB "|          WELCOME TO          |", 0Ah, 0Dh
           DB "|       The Quest for the      |", 0Ah, 0Dh
           DB "|           Golden Pi          |", 0Ah, 0Dh
           DB "|\                            /|", 0Ah, 0Dh
           DB "================================", 0Ah, 0Dh
welcomeMsgend:
    
survivedMsg DB "================================", 0Ah, 0Dh
            DB "|                              |", 0Ah, 0Dh
            DB "|         YOU SURVIVED         |", 0Ah, 0Dh
            DB "|                              |", 0Ah, 0Dh
            DB "|     ...and got the girl!     |", 0Ah, 0Dh
            DB "|                              |", 0Ah, 0Dh
            DB "================================", 0Ah, 0Dh
survivedMsgend:

diedMsg DB "================================", 0Ah, 0Dh
        DB "|                              |", 0Ah, 0Dh
        DB "|           YOU DIED           |", 0Ah, 0Dh
        DB "|                              |", 0Ah, 0Dh
        DB "|     The Hunter has won...    |", 0Ah, 0Dh
        DB "|                              |", 0Ah, 0Dh
        DB "================================", 0Ah, 0Dh
diedMsgend:

hunterMsg DB "================================", 0Ah, 0Dh
          DB "|  Thanks for finding the      |", 0Ah, 0Dh
          DB "|     golden pi for me. Now    |", 0Ah, 0Dh
          DB "|     its time for you to die! |", 0Ah, 0Dh
          DB "|                              |", 0Ah, 0Dh
          DB "|   (New Objective: Survive)   |", 0Ah, 0Dh
          DB "================================", 0Ah, 0Dh
hunterMsgend:


ItemsManagerOn DB 1

goldenPiXPos DB 1 
goldenPiYPos DB 1

hasSpawned DB 0
hasPi DB 0

ItemsManager Proc
    
    cmp hasSpawned, 0
    jnz checkCollision:
        mov BH, 0
        mov DH, goldenPiYPos
        mov DL, goldenPiXPos
        mov AH, 2h
        int 10h
        
        mov AL, 227
        mov BL, 0eh
        mov CX, 1
        mov AH, 9h
        int 10h
        
        inc hasSpawned
        jmp ItemsManagerEnd:    
    
    checkCollision:
    mov BH, 0
    mov DH, goldenPiYPos
    mov DL, goldenPiXPos
    mov AH, 2h
    int 10h
    
    mov BH, 0
    mov AH, 08h
    int 10h
    
    cmp Al, 1
    jnz ItemsManagerEnd:
    
    inc hasPi
    dec ItemsManagerOn
    
    
    ItemsManagerEnd:
    ret
ItemsManager Endp


left    equ 61h                                     
right   equ 64h
up      equ 77h
down    equ 73h

;Define player and goal start
xPos DB 14
yPos DB 14 

playerMove Proc
    
    mov DH, yPos
    mov DL, xPos
    
    ;Checks for left input
    isLeft:
        cmp AL, left
        jnz isRight:
        dec DL
        cmp isStalk, 1
        jnz runMove:
        mov carryOver, 4
        jmp runMove:
    
    ;Checks for right input
    isRight:
        cmp AL, right
        jnz isUp:
        inc DL
        cmp isStalk, 1
        jnz runMove:
        mov carryOver, 2
        jmp runMove:
    
    ;Checks for up input    
    isUp:
        cmp AL, up
        jnz isDown:
        dec DH
        cmp isStalk, 1
        jnz runMove:
        mov carryOver, 1
        jmp runMove:
    
    ;Checks for down input
    isDown:
        cmp AL, down
        jnz endMove:
        inc DH
        cmp isStalk, 1
        jnz runMove:
        mov carryOver, 3 
    
    ;Moves the curosr and places character    
    runMove:
        mov txPos, DL
        mov tyPos, DH
        
        call checkHit
        cmp isWall, 1
        jz hitWall:
        
        cmp hasKilled, 1
        jz endMove:        
        
        mov DH, yPos
        mov DL, xPos
        mov AH, 2h
        int 10h ;Set cursor location
        
        mov AL, 32
        mov CX, 1
        mov AH, 0Ah
        int 10h ;Write null char to cursor location
        
        mov DH, tyPos
        mov DL, txPos
        mov BL, 0eh 
        mov BH, 0
        mov AH, 2h
        int 10h ;Set cursor location
        
        mov AL, 1h
        mov AH, 9h
        int 10h ;Write player char to cursor location
        
        ;Update X,Y pos of player in memory
        mov xPos, DL
        mov yPos, DH
        jmp endMove:
    
    ;Beep if the player hit a wall                   
    hitWall:
    mov AL, 7
    putc AL
    dec isWall
    cmp isStalk, 1
        jnz endMove:
        mov carryOver, 0
    
    endMove:
    ret
playerMove Endp


setYPos DB ?
setXPos DB ?

scenePos DB 0

spawnPlayer Proc
    
    scene0Pos:
    cmp scenePos, 0
    jnz scene1Pos:
    mov setYPos, 7
    mov setXPos, 11
    jmp setCursorPos:
    
    scene1Pos:
    cmp scenePos, 1
    mov setYPos, 14
    mov setXPos, 14
    
    setCursorPos:                                  
    mov BH, 0
    mov DH, setYPos
    mov DL, setxPos
    mov AH, 2h
    int 10h ;Set cursor location                                        

    mov AL, 01h
    mov BL, 0eh
    mov CX, 1
    mov AH, 09h
    int 10h
    
    inc scenePos       
           
    ret       
spawnPlayer Endp


isStalk DB 0

hColor DB 2
hChar DB 2

hxPos DB 5
hyPos DB 1

wallHits DW 0
mov1 DB 4
mov2 DB 4
mov3 DB 4
carryOver DB ?

followOn Proc
    
    mov DH, hyPos
    mov DL, hxPos
    mov BX, 0
    mov AH, 2h
    int 10h
    
    mov BX, wallHits
    
    checkNext:
    mov AL, mov1 + BX
    
    moveUp:
    cmp AL, 1
    jnz moveRight:
    dec DH
    jmp makeMove:
    
    moveRight:
    cmp AL, 2
    jnz moveDown:
    inc DL
    jmp makeMove:
    
    moveDown:
    cmp AL, 3
    jnz moveLeft:
    inc DH
    jmp makeMove:
    
    moveLeft:
    cmp AL, 4
    jnz skipMove:
    dec DL
    jmp makeMove:
    
    skipMove:
    inc BX
    inc wallHits
    jmp checkNext:
    
    makeMove:
    mov AL, 0
    mov CX, 1
    mov AH, 0Ah
    int 10h
    
    mov AH, 2h
    int 10h
    
    mov AL, hChar
    mov BL, hColor
    mov AH, 9h
    int 10h 
    
    mov hxPos, DL
    mov hyPos, DH     
    
    call shiftMem
    
    mov AL, xPos
    mov AH, yPos
    
    mov txPos, Al
    mov tyPos, Ah
    
    call checkHit
    
    followOnend:
    ret
followOn Endp

shiftMem Proc
    
    mov AL, mov2
    mov AH, mov3
    mov BL, carryOver
    
    mov mov1, AL
    mov mov2, AH
    mov mov3, BL
    mov carryOver, 0
    
    ret
shiftMem Endp

spawnStalker Proc
    
    mov BX, 0
    mov DH, hyPos
    mov DL, hxPos
    mov AH, 2h
    int 10h
    
    mov AL, hChar
    mov BL, hColor
    mov CX, 1
    mov AH, 9h
    int 10h
    
    ret
spawnStalker Endp 


txPos DB ?
tyPos DB ?

hasKilled DB 0
isWall DB 0

checkHit Proc
    
    mov DL, txPos
    mov DH, tyPos
    mov BH, 0
    mov AH, 2h
    int 10h
    
    mov AH, 8h
    int 10h
    
    checkHitWall:
    cmp AL, 219
    jnz checkHitHunter:
        inc isWall
        jmp checkHitend:   
    
    checkHitHunter:
    cmp AL, 2
    jnz checkHitend:
        inc hasKilled
    
    checkHitend:
    ret
checkHit Endp