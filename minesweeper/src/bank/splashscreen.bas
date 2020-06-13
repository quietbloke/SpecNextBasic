#autoline 10
DEFPROC SplashScreen()
  PROC PrintCentered("QuietBloke Productions",10)
  PROC PrintCentered("presents",12)
  PROC PrintCentered("MineSweeper",14)
  LET done=0
  REPEAT 
    LET k$= INKEY$
    IF K$=" " THEN LET done=1
  REPEAT UNTIL done=1
ENDPROC
;
DEFPROC PrintCentered(m$, row)
  LOCAL %x
  LET %x= (32 - LEN (m$)) / 2
  PRINT AT row,%x;m$
ENDPROC
