#autoline 10
DEFPROC HelpScreen()
  LAYER 1,2: ; Use HiRes mode 64 x 24
  PAPER 0
  BRIGHT 0
  INK 7
  CLS

  PROC PrintCentered("Pattern Edit HELP",0)
;
  PRINT AT 1,0;"          General               "
  PRINT AT 2,0;"--------------------------------"
  PRINT AT 3,0;"Arrow keys to move active cursor"
  PRINT AT 4,0;"i Select Sprite Editor"
  PRINT AT 5,0;"o Select Palette "
  PRINT AT 6,0;"p Select Patterns"

  PRINT AT 8,0; "       Sprite Editor            "
  PRINT AT 9,0; "--------------------------------"
  PRINT AT 10,0; ". Paint pixel                   "
  PRINT AT 11,0; "z Clear pixel                   "
  PRINT AT 12,0; "s Select colour of pixel        "

  PRINT AT 15,0; "           Palette              "
  PRINT AT 16,0; "--------------------------------"
 
  PRINT AT 1,32; "           Pattern              "
  PRINT AT 2,32; "--------------------------------"
  

  PRINT AT 2,32;"---------------"


  PROC PrintCentered("Press Break to return to the Editor ",23)

  ; Display layer 1 over the other layers
  LAYER OVER 4
  LET done=0
  ; Escape will return
  REPEAT
    BANK iobank PROC ReadKeyboard()

    IF % (k(0) & 1 = 1) AND (k(6) & 1 = 1) THEN done=1
  REPEAT UNTIL done=1

  ; Put layer 1 at the bottom again
  LAYER OVER 1
  LAYER 1,0
  PAPER 7
  CLS
ENDPROC
;
DEFPROC PrintCentered(m$, row)
  LOCAL %x
  LET %x= (64 - LEN (m$)) / 2
  PRINT AT row,%x;m$
ENDPROC
