#autoline 10
DEFPROC InitVars()
    LET cx = 1:; cursor xpos
    LET cy = 1:; cursor ypos

    LET pFlashRate = 10:; speed of cursor flash
    LET pFlash = 0:; is cursor on or off
    LET pFlashCount = 0:; time time flash toggles
    ;
    LET finished = 0
ENDPROC