#autoline 10
DEFPROC InitVars()
    ; Cursor on the current sprite pattern
    cx = 7:; cursor xpos
    cy = 7:; cursor ypos

    ; Cursor on the current palette colour
    px = 15:; palette cursor xpos
    py = 15:; palette cursor ypos

    ; Cursor on the current pattern
    tx = 0:; palette cursor xposi
    ty = 0:; palette cursor ypos
    copyPattern=0:; Index of the pattern marked to be copied

    pFlashRate = 4:; speed of cursor flash; this must be bit ( 1,2,4,8,16,32 etc)
    pFlash = 0:; is cursor on or off
    pFlashCount = 0:; time time flash toggles

    active = 0:; indicates what area has focus (sprite=0, palette=1, patten=2) 
    finished = 0:; application has finished
ENDPROC