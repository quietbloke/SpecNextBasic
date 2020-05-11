  10 ; Mine Sweeper
  20 ; Created by QuietBloke 2020
  30 ;
  40 ; global stuff
  50 LET gWidth = 10:;  cells across
  60 LET gHeight = 10:; cells down
  70 LET mines = INT(gwidth * gHeight / 8):; number of mines
  80 ; %g array used to store grid cell info 
  90 ; NOTE : grid array stored include 1 cell padding on all sides
 100 ; %c array used to store cell colours based on flag combinations  
 110 
 120 ; bit 0-4 number of neighbouring mines
 130 ; bit 5 contains mine
 140 ; bit 6 uncovered
 150 ; bit 7 flagged 
 160 LET mineFlag     =%@00010000
 170 LET uncoveredFlag=%@00100000
 180 LET flaggedFlag  =%@01000000
 190 LET gridFlagsMask=%@11110000
 200 LET gridValueMask=%@00001111
 210 LET gOffsetX = -1:; x offset of grid on screen
 220 LET gOffsetY = -1:; y offset of grid on screen
 230 ;
 240 LET px = 1:; player xpos
 250 LET py = 1:; player ypos
 260 LET opx = 1:; old player xpos
 270 LET opy = 1:; old player ypos
 280 LET pFlashRate = 2:; speed of cursor flash
 290 LET pFlash = 0:; is cursor on or off
 300 LET pFlashCount = 0:; time time flash toggles
 310 ;
 320 LET finished = 0
 330 LET mineHit = 0
 340 ;
 350 RUN AT 3
 360 PROC InitDisplay()
 365 PROC SplashScreen()
 370 PROC InitCellTypes()
 380 PRINT "reseting"
 390 PROC ResetGrid()
 400 PRINT "laying mines"
 410 PROC LayMines()
 420 CLS
 430 PROC DrawGrid()
 440 ; game loop
 450 REPEAT
 460 PROC UpdatePlayerCursor()
 470 PROC DrawPlayerCell()
 480 PROC DrawInfo()
 490 IF mineHit THEN LET finished = 1
 500 REPEAT UNTIL finished = 1
 510 PROC UncoverGrid()
 520 PROC DrawGrid()
 530 PRINT AT 20,0;"BOOM"
 540 STOP 
 550 ;
 560 DEFPROC GetGridCell(%x,%y)
 570 LOCAL %i
 580 ; return zero if coords are out of bounds
 590 IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC=0 
 600 LET %i=%y* INT {gWidth+2}+x
 610 ENDPROC =%g[i]
 620 ;
 630 DEFPROC SetGridCell(%x,%y,%v)
 640 LOCAL %i
 650 ; do nothing if coords are out of bounds
 660 IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC 
 670 LET %i=%y* INT {gWidth+2}+x
 680 LET %g[i]=%v
 690 ENDPROC 
 700 ;
 710 DEFPROC DrawGridCell(%x,%y)
 720 LOCAL %c,%d,v,c$
 730 PROC GetGridCell(%x,%y) TO %c
 740 LET v = %c & INT{gridValueMask}
 750 ; IF v > 0 THEN LET c$= STR$ v: ELSE LET c$=" "
 760 LET c$= STR$ v
 770 IF %c & INT {mineFlag} THEN LET c$="*" 
 780 LET %d = %c & INT{gridFlagsMask} >> 4
 790 PAPER %c[d]: INK %c[d]
 800 IF v > 0 THEN IF %c & INT{uncoveredFlag} > 0 THEN INK 0
 810 PRINT AT %y+INT {gOffsetY},%x+INT {gOffsetX};c$
 820 PAPER 0
 830 ENDPROC 
 840 ;
 850 DEFPROC UpdatePlayerCursor()
 860 LOCAL %v
 870 ; see if the player is moving the cursor
 880 LET k$= INKEY$ 
 890 LET opx = px
 900 LET opy = py
 910 IF k$ = "a" AND px > 1 AND pFlashCount = 0 THEN LET px = px - 1
 920 IF k$ = "d" AND px < gWidth AND pFlashCount = 0 THEN LET px = px + 1
 930 IF k$ = "w" AND py > 1 AND pFlashCount = 0 THEN LET py = py - 1
 940 IF k$ = "s" AND py < gHeight AND pFlashCount = 0 THEN LET py = py + 1
 950 IF k$="." THEN PROC UncoverCell(px,py): PROC DrawGridCell(px,py): PROC GetGridCell(px,py) TO %v: IF %v& INT {mineFlag} THEN LET mineHit=1: LET pFlashCount=0: LET pFlash=0
 960 IF k$ = "f" THEN PROC GetGridCell(px,py) TO %v: LET %v = %v ^ INT{flaggedFlag}: PROC SetGridCell(px,py, %v)
 970 IF k$ = "g" THEN PROC DrawGrid()
 980 LET pFlashCount = pFlashCount + 1
 990 IF pFlashCount > pFlashRate THEN LET pFlashCount = 0: LET pFlash = NOT pflash  
1000 ENDPROC 
1010 ;
1020 DEFPROC DrawPlayerCell()
1030 IF opx <> px OR opy <> py THEN PROC DrawGridCell(opx,opy)
1040 INK 7
1050 IF pFlash THEN PRINT AT py+gOffsetY,px+gOffsetX;"@": ELSE PROC DrawGridCell(px,py)
1060 ENDPROC 
1070 ;
1080 DEFPROC DrawInfo()
1090 PRINT AT 20,1;"Mines : "+ STR$ mines
1100 ENDPROC 
1110 ;
1120 DEFPROC UncoverCell(%x,%y)
1130 LOCAL %c,%v
1140 IF %y < 1 THEN ENDPROC
1150 IF %x < 1 THEN ENDPROC
1160 IF %y > INT {gHeight} THEN ENDPROC
1170 IF %x > INT {gWidth} THEN ENDPROC
1180 PROC GetGridCell(%x,%y) TO %c
1190 ; If cell already uncovered then we are done
1200 IF %c & INT {uncoveredFlag} > 0 THEN ENDPROC
1210 LET %c = %c | INT {uncoveredFlag}
1220 PROC SetGridCell(%x,%y,%c)
1230 PROC DrawGridCell(%x,%y)
1240 IF %c & INT {mineFlag} > 0 THEN ENDPROC
1250 ; If the cell has no adjacent mines then uncover surrounding cells as well
1260 LET %v = %c & INT {gridValueMask}
1270 IF %v > 0 THEN ENDPROC
1280 ; Cell is in the clear so we uncover surrounding cells
1290 PROC UncoverCell(%x-1,%y)
1300 PROC UncoverCell(%x+1,%y)
1310 PROC UncoverCell(%x,%y-1)
1320 PROC UncoverCell(%x,%y+1)
1330 PROC UncoverCell(%x-1,%y-1)
1340 PROC UncoverCell(%x+1,%y-1)
1350 PROC UncoverCell(%x-1,%y+1)
1360 PROC UncoverCell(%x+1,%y+1)
1370 ENDPROC 
1380 ;
1390 DEFPROC DrawGrid()
1400 LOCAL %x,%y
1410 LET endY=gHeight-1
1420 LET endX=gWidth-1
1430 FOR %y=1 TO gHeight
1440 FOR %x=1 TO gWidth
1450 PROC DrawGridCell(%x,%y)
1460 NEXT %x
1470 NEXT %y
1480 ENDPROC 
1490 ;
1500 DEFPROC LayMines()
1510 LOCAL %l,%x,%y,%c
1520 RANDOMIZE 
1530 FOR %l=1 TO mines
1540 ; Loop until we find a clear cell 
1550 REPEAT
1560 LET %x = % RND INT {gWidth} + 1
1570 LET %y = % RND INT {gHeight} + 1
1580 PROC GetGridCell(%x,%y) TO %c
1590 REPEAT UNTIL %c & INT {mineFlag} = 0
1600 ; Cell is Clear so drop a mine
1610 PROC SetGridCell(%x,%y,mineFlag)
1620 PROC DrawGridCell(%x,%y)
1630 PROC IncMineCounts(%x,%y)
1640 NEXT %l
1650 ENDPROC 
1660 ;
1670 DEFPROC IncMineCounts(%x,%y)
1680 LOCAL %a,%b,%c
1690 FOR %a=%y-1 TO %y+1
1700 FOR %b=%x-1 TO %x+1
1710 PROC GetGridCell(%b,%a) TO %c
1720 LET %c=%c+1
1730 PROC SetGridCell(%b,%a,%c)
1740 NEXT %b
1750 NEXT %a
1760 ENDPROC
1770 ;
1780 DEFPROC ResetGrid()
1790 LOCAL %x,%y
1800 FOR %y=1 TO gHeight
1810 FOR %x=1 TO gWidth
1820 PROC SetGridCell(%x,%y,0)
1830 NEXT %x
1840 NEXT %y
1850 ENDPROC 
1860 ;
1870 DEFPROC UncoverGrid()
1880 LOCAL %x,%y
1890 FOR %y=1 TO gHeight
1900 FOR %x=1 TO gWidth
1910 PROC GetGridCell(%x,%y) TO %c
1920 LET %c=%c | INT {uncoveredFlag}
1930 PROC SetGridCell(%x,%y,%c)
1940 NEXT %x
1950 NEXT %y
1960 ENDPROC 
1970 ;
1980 DEFPROC InitDisplay()
1990 ;LAYER 1,1:; standard res
2000 BORDER 0: INK 7: PAPER 0
2010 CLS 
2020 ENDPROC
2030 ;
2040 DEFPROC InitCellTypes()
2050 LET %c[0]=7
2060 LET %c[INT{mineFlag} >> 4]=7
2070 LET %c[INT{uncoveredFlag} >> 4]=4
2080 LET %c[INT{uncoveredFlag+mineFlag} >> 4]=2
2090 LET %c[INT{flaggedFlag} >> 4]=3
2100 LET %c[INT{flaggedFlag+mineFlag} >> 4]=3
2110 LET %c[INT{flaggedFlag+uncoveredFlag} >> 4]=3:; still show flag for uncovered cell that is not a mine
2120 LET %c[INT{flaggedFlag+uncoveredFlag+mineFlag} >> 4]=2
2130 ENDPROC
2195 ;
2200 DEFPROC SplashScreen()
2210 PROC PrintCentered("QuietBloke Productions",10)
2212 PROC PrintCentered("presents",12)
2214 PROC PrintCentered("MineSweeper",14)
2216 LET done=0
2220 REPEAT 
2230 LET k$= INKEY$
2240 IF K$=" " THEN LET done=1
2250 REPEAT UNTIL done=1
2260 ENDPROC
2270 ;
2300 DEFPROC PrintCentered(m$, row)
2305 LOCAL %x
2320 LET %x= (32 - LEN (m$)) / 2
2330 PRINT AT row,%x;m$
2340 ENDPROC