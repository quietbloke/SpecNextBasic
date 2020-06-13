#autoline 10
; Mine Sweeper
; Created by QuietBloke 2020 
; 
RUN AT 3
PROC InitDisplay()

BANK NEW bnk
LOAD "globalvars.bas" BANK bnk
BANK bnk PROC InitVars()
BANK bnk CLEAR

BANK NEW bnk
LOAD "splashscreen.bas" BANK bnk
BANK bnk PROC SplashScreen()
BANK bnk CLEAR

PROC InitCellTypes()
CLS
PRINT "reseting"
PROC ResetGrid()
PRINT "laying mines"
PROC LayMines()
CLS
PROC DrawGrid()
; game loop
REPEAT
  PROC UpdatePlayerCursor()
  PROC DrawPlayerCell()
  PROC DrawInfo()
  IF mineHit THEN LET finished = 1
REPEAT UNTIL finished = 1
PROC UncoverGrid()
PROC DrawGrid()
PRINT AT 20,0;"BOOM"
STOP 
;
DEFPROC GetGridCell(%x,%y)
  LOCAL %i
  ; return zero if coords are out of bounds
  IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC=0 
  LET %i=%y* INT {gWidth+2}+x
ENDPROC =%g[i]
;
DEFPROC SetGridCell(%x,%y,%v)
  LOCAL %i
  ; do nothing if coords are out of bounds
  IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC 
  LET %i=%y* INT {gWidth+2}+x
  LET %g[i]=%v
ENDPROC 
;
DEFPROC DrawGridCell(%x,%y)
  LOCAL %c,%d,v,c$
  PROC GetGridCell(%x,%y) TO %c
  LET v = %c & INT{gridValueMask}
  ; IF v > 0 THEN LET c$= STR$ v: ELSE LET c$=" "
  LET c$= STR$ v
  IF %c & INT {mineFlag} THEN LET c$="*" 
  LET %d = %c & INT{gridFlagsMask} >> 4
  PAPER %c[d]: INK %c[d]
  IF v > 0 THEN IF %c & INT{uncoveredFlag} > 0 THEN INK 0
  PRINT AT %y+INT {gOffsetY},%x+INT {gOffsetX};c$
  PAPER 0
ENDPROC 
;
DEFPROC UpdatePlayerCursor()
  LOCAL %v
  ; see if the player is moving the cursor
  LET k$= INKEY$ 
  LET opx = px
  LET opy = py
  IF k$ = "a" AND px > 1 AND pFlashCount = 0 THEN LET px = px - 1
  IF k$ = "d" AND px < gWidth AND pFlashCount = 0 THEN LET px = px + 1
  IF k$ = "w" AND py > 1 AND pFlashCount = 0 THEN LET py = py - 1
  IF k$ = "s" AND py < gHeight AND pFlashCount = 0 THEN LET py = py + 1
  IF k$="." THEN PROC UncoverCell(px,py): PROC DrawGridCell(px,py): PROC GetGridCell(px,py) TO %v: IF %v& INT {mineFlag} THEN LET mineHit=1: LET pFlashCount=0: LET pFlash=0
  IF k$ = "f" THEN PROC GetGridCell(px,py) TO %v: LET %v = %v ^ INT{flaggedFlag}: PROC SetGridCell(px,py, %v)
  IF k$ = "g" THEN PROC DrawGrid()
  LET pFlashCount = pFlashCount + 1
  IF pFlashCount > pFlashRate THEN LET pFlashCount = 0: LET pFlash = NOT pflash  
ENDPROC 
;
DEFPROC DrawPlayerCell()
  IF opx <> px OR opy <> py THEN PROC DrawGridCell(opx,opy)
  INK 7
  IF pFlash THEN PRINT AT py+gOffsetY,px+gOffsetX;"@": ELSE PROC DrawGridCell(px,py)
ENDPROC 
;
DEFPROC DrawInfo()
  PRINT AT 20,1;"Mines : "+ STR$ mines
ENDPROC 
;
DEFPROC UncoverCell(%x,%y)
  LOCAL %c,%v
  IF %y < 1 THEN ENDPROC
  IF %x < 1 THEN ENDPROC
  IF %y > INT {gHeight} THEN ENDPROC
  IF %x > INT {gWidth} THEN ENDPROC
  PROC GetGridCell(%x,%y) TO %c
  ; If cell already uncovered then we are done
  IF %c & INT {uncoveredFlag} > 0 THEN ENDPROC
  LET %c = %c | INT {uncoveredFlag}
  PROC SetGridCell(%x,%y,%c)
  PROC DrawGridCell(%x,%y)
  IF %c & INT {mineFlag} > 0 THEN ENDPROC
  ; If the cell has no adjacent mines then uncover surrounding cells as well
  LET %v = %c & INT {gridValueMask}
  IF %v > 0 THEN ENDPROC
  ; Cell is in the clear so we uncover surrounding cells
  PROC UncoverCell(%x-1,%y)
  PROC UncoverCell(%x+1,%y)
  PROC UncoverCell(%x,%y-1)
  PROC UncoverCell(%x,%y+1)
  PROC UncoverCell(%x-1,%y-1)
  PROC UncoverCell(%x+1,%y-1)
  PROC UncoverCell(%x-1,%y+1)
  PROC UncoverCell(%x+1,%y+1)
ENDPROC 
;
DEFPROC DrawGrid()
  LOCAL %x,%y
  LET endY=gHeight-1
  LET endX=gWidth-1
  FOR %y=1 TO gHeight
  FOR %x=1 TO gWidth
  PROC DrawGridCell(%x,%y)
  NEXT %x
  NEXT %y
ENDPROC 
;
DEFPROC LayMines()
  LOCAL %l,%x,%y,%c
  RANDOMIZE 
  FOR %l=1 TO mines
    ; Loop until we find a clear cell 
    REPEAT
      LET %x = % RND INT {gWidth} + 1
      LET %y = % RND INT {gHeight} + 1
      PROC GetGridCell(%x,%y) TO %c
    REPEAT UNTIL %c & INT {mineFlag} = 0
    ; Cell is Clear so drop a mine
    PROC SetGridCell(%x,%y,mineFlag)
    PROC DrawGridCell(%x,%y)
    PROC IncMineCounts(%x,%y)
  NEXT %l
ENDPROC 
;
DEFPROC IncMineCounts(%x,%y)
  LOCAL %a,%b,%c
  FOR %a=%y-1 TO %y+1
    FOR %b=%x-1 TO %x+1
      PROC GetGridCell(%b,%a) TO %c
      LET %c=%c+1
      PROC SetGridCell(%b,%a,%c)
    NEXT %b
  NEXT %a
ENDPROC
;
DEFPROC ResetGrid()
  LOCAL %x,%y
  FOR %y=1 TO gHeight
    FOR %x=1 TO gWidth
      PROC SetGridCell(%x,%y,0)
    NEXT %x
  NEXT %y
ENDPROC 
;
DEFPROC UncoverGrid()
  LOCAL %x,%y
  FOR %y=1 TO gHeight
    FOR %x=1 TO gWidth
      PROC GetGridCell(%x,%y) TO %c
      LET %c=%c | INT {uncoveredFlag}
      PROC SetGridCell(%x,%y,%c)
    NEXT %x
  NEXT %y
ENDPROC 
;
DEFPROC InitDisplay()
;LAYER 1,1:; standard res
  BORDER 0: INK 7: PAPER 0
  CLS 
ENDPROC
;
DEFPROC InitCellTypes()
  LET %c[0]=7
  LET %c[INT{mineFlag} >> 4]=7
  LET %c[INT{uncoveredFlag} >> 4]=4
  LET %c[INT{uncoveredFlag+mineFlag} >> 4]=2
  LET %c[INT{flaggedFlag} >> 4]=3
  LET %c[INT{flaggedFlag+mineFlag} >> 4]=3
  LET %c[INT{flaggedFlag+uncoveredFlag} >> 4]=3:; still show flag for uncovered cell that is not a mine
  LET %c[INT{flaggedFlag+uncoveredFlag+mineFlag} >> 4]=2
ENDPROC