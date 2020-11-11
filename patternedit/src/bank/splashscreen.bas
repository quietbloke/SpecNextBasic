#autoline 10
DEFPROC SplashScreen()
  LAYER 1,1: ; Use Standard Res mode
  PAPER 7
  CLS

  PROC PrintCentered("QuietBloke Productions",10)
  PROC PrintCentered("presents",12)
  PROC PrintCentered("pattern editor V0.1",14)

  ; Display layer 1 over the other layers
  LAYER OVER 4

  PAUSE 120

  ; Put layr 1 at the bottom again
  LAYER OVER 0
ENDPROC
;

DEFPROC PrintCentered(m$, row)
  LOCAL %x
  LET %x= (32 - LEN (m$)) / 2
  PRINT AT row,%x;m$
ENDPROC
