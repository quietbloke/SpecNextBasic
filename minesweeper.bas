  10 ; Mine Sweeper
  20 ; Created by QuietBloke 2020
  30 ;
  40 ; global stuff
  50 LET gWidth = 10:;  cells across
  60 LET gHeight = 10:; cells down
  70 LET mines = INT(gwidth * gHeight / 8):; number of mines
  80 ; %g array used to store grid cell info 
  90 ; NOTE : grid array stored include 1 cell padding on all sides
 100 ; bit 0-4 number of neighbouring mines
 110 ; bit 5 contains mine
 120 ; bit 6 uncovered
 130 ; bit 7 flagged 
 140 LET mineFlag     =%@00100000
 150 LET uncoveredFlag=%@01000000
 160 LET flaggedFlag  =%@10000000
 170 LET gridFlagsMask=%@11110000
 180 LET gridValueMask=%@00001111
 190 LET gOffsetX = -1:; x offset of grid on screen
 200 LET gOffsetY = -1:; y offset of grid on screen
 210 ;
 220 LET px = 1:; player xpos
 230 LET py = 1:; player ypos
 240 LET opx = 1:; old player xpos
 250 LET opy = 1:; old player ypos
 260 LET pFlashRate = 2:; speed of cursor flash
 270 LET pFlash = 0:; is cursor on or off
 280 LET pFlashCount = 0:; time time flash toggles
 290 ;
 300 LET finished = 0
 310 LET mineHit = 0
 320 ;
 330 RUN AT 3
 340 PROC InitDisplay()
 350 PRINT "reseting"
 360 PROC ResetGrid()
 370 PRINT "laying mines"
 380 PROC LayMines()
 390 CLS
 400 PROC DrawGrid()
 410 ; game loop
 420 REPEAT
 430 PROC UpdatePlayerCursor()
 440 PROC DrawPlayerCell()
 450 PROC DrawInfo()
 460 IF mineHit THEN LET finished = 1
 470 REPEAT UNTIL finished = 1
 480 PROC UncoverGrid()
 490 PROC DrawGrid()
 500 PRINT AT 20,0;"BOOM"
 510 STOP 
 520 ;
 530 DEFPROC SetGridCell(%x,%y,%v)
 540 LOCAL %i
 550 ; do nothing if coords are out of bounds
 560 IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC 
 570 LET %i=%y* INT {gWidth+2}+x
 580 LET %g[i]=%v
 590 ENDPROC 
 600 ;
 610 DEFPROC GetGridCell(%x,%y)
 620 LOCAL %i
 630 ; return zero if coords are out of bounds
 640 IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC=0 
 650 LET %i=%y* INT {gWidth+2}+x
 660 ENDPROC =%g[i]
 670 ;
 680 DEFPROC DrawGridCell(%x,%y)
 690 LOCAL %c,v,c$
 700 PROC GetGridCell(%x,%y) TO %c
 710 LET v = %c & INT{gridValueMask}
 720 LET c$= STR$ v: PAPER 4:; green
 730 ;LET %c = c
 740 IF v = 0 THEN LET c$=" ": PAPER 4:; green
 750 IF %c & INT {mineFlag} THEN LET c$="X": PAPER 2:; red
 760 IF %c & INT {uncoveredFlag} = 0 THEN LET c$  = " ": PAPER 7:; white
 770 IF %c& INT {flaggedFlag}>0 THEN IF %c& INT {uncoveredFlag}=0 THEN LET c$=" ": PAPER 3:; magenta
 780 PRINT AT %y+INT {gOffsetY},%x+INT {gOffsetX};c$
 790 PAPER 0
 800 ENDPROC 
 810 ;
 820 DEFPROC UpdatePlayerCursor()
 830 LOCAL %v
 840 ; see if the player is moving the cursor
 850 LET k$ = INKEY$
 860 LET opx = px
 870 LET opy = py
 880 IF k$ = "z" AND px > 1 AND pFlashCount = 0 THEN LET px = px - 1
 890 IF k$ = "x" AND px < gWidth AND pFlashCount = 0 THEN LET px = px + 1
 900 IF k$ = "p" AND py > 1 AND pFlashCount = 0 THEN LET py = py - 1
 910 IF k$ = "l" AND py < gHeight AND pFlashCount = 0 THEN LET py = py + 1
 920 IF k$="." THEN PROC UncoverCell(px,py): PROC DrawGridCell(px,py): PROC GetGridCell(px,py) TO %v: IF %v& INT {mineFlag} THEN LET mineHit=1: LET pFlashCount=0: LET pFlash=0
 930 IF k$ = "f" THEN PROC GetGridCell(px,py) TO %v: LET %v = %v ^ INT{flaggedFlag}: PROC SetGridCell(px,py, %v)
 940 IF k$ = "g" THEN PROC DrawGrid()
 950 LET pFlashCount = pFlashCount + 1
 960 IF pFlashCount > pFlashRate THEN LET pFlashCount = 0: LET pFlash = NOT pflash  
 970 ENDPROC 
 980 ;
 990 DEFPROC DrawPlayerCell()
1000 IF opx <> px OR opy <> py THEN PROC DrawGridCell(opx,opy)
1010 INK 7
1020 IF pFlash THEN PRINT AT py+gOffsetY,px+gOffsetX;"@": ELSE PROC DrawGridCell(px,py)
1030 ENDPROC 
1040 ;
1050 DEFPROC DrawInfo()
1060 PRINT AT 20,1;"Mines : "+ STR$ mines
1070 ENDPROC 
1080 ;
1090 DEFPROC UncoverCell(%x,%y)
1100 LOCAL %c,%v
1110 IF %y < 1 THEN ENDPROC
1120 IF %x < 1 THEN ENDPROC
1130 IF %y > INT {gHeight} THEN ENDPROC
1140 IF %x > INT {gWidth} THEN ENDPROC
1150 PROC GetGridCell(%x,%y) TO %c
1160 ; If cell already uncovered then we are done
1170 IF %c & INT {uncoveredFlag} > 0 THEN ENDPROC
1180 LET %c = %c | INT {uncoveredFlag}
1190 PROC SetGridCell(%x,%y,%c)
1200 PROC DrawGridCell(%x,%y)
1210 IF %c & INT {mineFlag} > 0 THEN ENDPROC
1220 ; If the cell has no adjacent mines then uncover surrounding cells as well
1230 LET %v = %c & INT {gridValueMask}
1240 IF %v > 0 THEN ENDPROC
1250 ; Cell is in the clear so we uncover surrounding cells
1260 PROC UncoverCell(%x-1,%y)
1270 PROC UncoverCell(%x+1,%y)
1280 PROC UncoverCell(%x,%y-1)
1290 PROC UncoverCell(%x,%y+1)
1300 PROC UncoverCell(%x-1,%y-1)
1310 PROC UncoverCell(%x+1,%y-1)
1320 PROC UncoverCell(%x-1,%y+1)
1330 PROC UncoverCell(%x+1,%y+1)
1340 ENDPROC 
1350 ;
1360 DEFPROC DrawGrid()
1370 LOCAL %x,%y
1380 LET endY=gHeight-1
1390 LET endX=gWidth-1
1400 FOR %y=1 TO gHeight
1410 FOR %x=1 TO gWidth
1420 PROC DrawGridCell(%x,%y)
1430 NEXT %x
1440 NEXT %y
1450 ENDPROC 
1460 ;
1470 DEFPROC LayMines()
1480 LOCAL %l,%x,%y,%c
1490 RANDOMIZE 
1500 FOR %l=1 TO mines
1510 ; Loop until we find a clear cell 
1520 REPEAT
1530 LET %x = % RND INT {gWidth} + 1
1540 LET %y = % RND INT {gHeight} + 1
1550 PROC GetGridCell(%x,%y) TO %c
1560 REPEAT UNTIL %c & INT {mineFlag} = 0
1570 ; Cell is Clear so drop a mine
1580 PROC SetGridCell(%x,%y,mineFlag)
1590 PROC DrawGridCell(%x,%y)
1600 PROC IncMineCounts(%x,%y)
1610 NEXT %l
1620 ENDPROC 
1630 ;
1640 DEFPROC IncMineCounts(%x,%y)
1650 LOCAL %a,%b,%c
1660 FOR %a=%y-1 TO %y+1
1670 FOR %b=%x-1 TO %x+1
1680 PROC GetGridCell(%b,%a) TO %c
1690 LET %c=%c+1
1700 PROC SetGridCell(%b,%a,%c)
1710 NEXT %b
1720 NEXT %a
1730 ENDPROC
1740 ;
1750 DEFPROC ResetGrid()
1760 LOCAL %x,%y
1770 FOR %y=1 TO gHeight
1780 FOR %x=1 TO gWidth
1790 PROC SetGridCell(%x,%y,0)
1800 NEXT %x
1810 NEXT %y
1820 ENDPROC 
1830 ;
1840 DEFPROC UncoverGrid()
1850 LOCAL %x,%y
1860 FOR %y=1 TO gHeight
1870 FOR %x=1 TO gWidth
1880 PROC GetGridCell(%x,%y) TO %c
1890 LET %c=%c | INT {uncoveredFlag}
1900 PROC SetGridCell(%x,%y,%c)
1910 NEXT %x
1920 NEXT %y
1930 ENDPROC 
1940 ;
1950 DEFPROC InitDisplay()
1960 ;LAYER 1,1:; standard res
1970 BORDER 0: INK 7: PAPER 0
1980 CLS 
1990 ENDPROC
