#autoline 10
DEFPROC HelpScreen()
  LAYER 1,2: ; Use HiRes mode 64 x 24
  PAPER 0
  BRIGHT 0
  INK 7
  CLS

  PROC PrintCentered("Pattern Edit HELP",0)
;
  print at 1,0;"---------------"
  print at 1,16;"---------------"

  ; Display layer 1 over the other layers
  LAYER OVER 4
  LET done=0
  REPEAT 
    LET k$= INKEY$
    IF K$ <> "" THEN LET done=1
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
