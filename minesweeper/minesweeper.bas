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
 370 PROC SplashScreen()
 380 PROC InitCellTypes()
 390 CLS
 400 PRINT "reseting"
 410 PROC ResetGrid()
 420 PRINT "laying mines"
 430 PROC LayMines()
 440 CLS
 450 PROC DrawGrid()
 460 ; game loop
 470 REPEAT
 480 PROC UpdatePlayerCursor()
 490 PROC DrawPlayerCell()
 500 PROC DrawInfo()
 510 IF mineHit THEN LET finished = 1
 520 REPEAT UNTIL finished = 1
 530 PROC UncoverGrid()
 540 PROC DrawGrid()
 550 PRINT AT 20,0;"BOOM"
 560 STOP 
 570 ;
 580 DEFPROC GetGridCell(%x,%y)
 590 LOCAL %i
 600 ; return zero if coords are out of bounds
 610 IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC=0 
 620 LET %i=%y* INT {gWidth+2}+x
 630 ENDPROC =%g[i]
 640 ;
 650 DEFPROC SetGridCell(%x,%y,%v)
 660 LOCAL %i
 670 ; do nothing if coords are out of bounds
 680 IF %x < 1 OR y < 1 OR x > INT {gWidth} OR y > INT {gHeight} THEN ENDPROC 
 690 LET %i=%y* INT {gWidth+2}+x
 700 LET %g[i]=%v
 710 ENDPROC 
 720 ;
 730 DEFPROC DrawGridCell(%x,%y)
 740 LOCAL %c,%d,v,c$
 750 PROC GetGridCell(%x,%y) TO %c
 760 LET v = %c & INT{gridValueMask}
 770 ; IF v > 0 THEN LET c$= STR$ v: ELSE LET c$=" "
 780 LET c$= STR$ v
 790 IF %c & INT {mineFlag} THEN LET c$="*" 
 800 LET %d = %c & INT{gridFlagsMask} >> 4
 810 PAPER %c[d]: INK %c[d]
 820 IF v > 0 THEN IF %c & INT{uncoveredFlag} > 0 THEN INK 0
 830 PRINT AT %y+INT {gOffsetY},%x+INT {gOffsetX};c$
 840 PAPER 0
 850 ENDPROC 
 860 ;
 870 DEFPROC UpdatePlayerCursor()
 880 LOCAL %v
 890 ; see if the player is moving the cursor
 900 LET k$= INKEY$ 
 910 LET opx = px
 920 LET opy = py
 930 IF k$ = "a" AND px > 1 AND pFlashCount = 0 THEN LET px = px - 1
 940 IF k$ = "d" AND px < gWidth AND pFlashCount = 0 THEN LET px = px + 1
 950 IF k$ = "w" AND py > 1 AND pFlashCount = 0 THEN LET py = py - 1
 960 IF k$ = "s" AND py < gHeight AND pFlashCount = 0 THEN LET py = py + 1
 970 IF k$="." THEN PROC UncoverCell(px,py): PROC DrawGridCell(px,py): PROC GetGridCell(px,py) TO %v: IF %v& INT {mineFlag} THEN LET mineHit=1: LET pFlashCount=0: LET pFlash=0
 980 IF k$ = "f" THEN PROC GetGridCell(px,py) TO %v: LET %v = %v ^ INT{flaggedFlag}: PROC SetGridCell(px,py, %v)
 990 IF k$ = "g" THEN PROC DrawGrid()
1000 LET pFlashCount = pFlashCount + 1
1010 IF pFlashCount > pFlashRate THEN LET pFlashCount = 0: LET pFlash = NOT pflash  
1020 ENDPROC 
1030 ;
1040 DEFPROC DrawPlayerCell()
1050 IF opx <> px OR opy <> py THEN PROC DrawGridCell(opx,opy)
1060 INK 7
1070 IF pFlash THEN PRINT AT py+gOffsetY,px+gOffsetX;"@": ELSE PROC DrawGridCell(px,py)
1080 ENDPROC 
1090 ;
1100 DEFPROC DrawInfo()
1110 PRINT AT 20,1;"Mines : "+ STR$ mines
1120 ENDPROC 
1130 ;
1140 DEFPROC UncoverCell(%x,%y)
1150 LOCAL %c,%v
1160 IF %y < 1 THEN ENDPROC
1170 IF %x < 1 THEN ENDPROC
1180 IF %y > INT {gHeight} THEN ENDPROC
1190 IF %x > INT {gWidth} THEN ENDPROC
1200 PROC GetGridCell(%x,%y) TO %c
1210 ; If cell already uncovered then we are done
1220 IF %c & INT {uncoveredFlag} > 0 THEN ENDPROC
1230 LET %c = %c | INT {uncoveredFlag}
1240 PROC SetGridCell(%x,%y,%c)
1250 PROC DrawGridCell(%x,%y)
1260 IF %c & INT {mineFlag} > 0 THEN ENDPROC
1270 ; If the cell has no adjacent mines then uncover surrounding cells as well
1280 LET %v = %c & INT {gridValueMask}
1290 IF %v > 0 THEN ENDPROC
1300 ; Cell is in the clear so we uncover surrounding cells
1310 PROC UncoverCell(%x-1,%y)
1320 PROC UncoverCell(%x+1,%y)
1330 PROC UncoverCell(%x,%y-1)
1340 PROC UncoverCell(%x,%y+1)
1350 PROC UncoverCell(%x-1,%y-1)
1360 PROC UncoverCell(%x+1,%y-1)
1370 PROC UncoverCell(%x-1,%y+1)
1380 PROC UncoverCell(%x+1,%y+1)
1390 ENDPROC 
1400 ;
1410 DEFPROC DrawGrid()
1420 LOCAL %x,%y
1430 LET endY=gHeight-1
1440 LET endX=gWidth-1
1450 FOR %y=1 TO gHeight
1460 FOR %x=1 TO gWidth
1470 PROC DrawGridCell(%x,%y)
1480 NEXT %x
1490 NEXT %y
1500 ENDPROC 
1510 ;
1520 DEFPROC LayMines()
1530 LOCAL %l,%x,%y,%c
1540 RANDOMIZE 
1550 FOR %l=1 TO mines
1560 ; Loop until we find a clear cell 
1570 REPEAT
1580 LET %x = % RND INT {gWidth} + 1
1590 LET %y = % RND INT {gHeight} + 1
1600 PROC GetGridCell(%x,%y) TO %c
1610 REPEAT UNTIL %c & INT {mineFlag} = 0
1620 ; Cell is Clear so drop a mine
1630 PROC SetGridCell(%x,%y,mineFlag)
1640 PROC DrawGridCell(%x,%y)
1650 PROC IncMineCounts(%x,%y)
1660 NEXT %l
1670 ENDPROC 
1680 ;
1690 DEFPROC IncMineCounts(%x,%y)
1700 LOCAL %a,%b,%c
1710 FOR %a=%y-1 TO %y+1
1720 FOR %b=%x-1 TO %x+1
1730 PROC GetGridCell(%b,%a) TO %c
1740 LET %c=%c+1
1750 PROC SetGridCell(%b,%a,%c)
1760 NEXT %b
1770 NEXT %a
1780 ENDPROC
1790 ;
1800 DEFPROC ResetGrid()
1810 LOCAL %x,%y
1820 FOR %y=1 TO gHeight
1830 FOR %x=1 TO gWidth
1840 PROC SetGridCell(%x,%y,0)
1850 NEXT %x
1860 NEXT %y
1870 ENDPROC 
1880 ;
1890 DEFPROC UncoverGrid()
1900 LOCAL %x,%y
1910 FOR %y=1 TO gHeight
1920 FOR %x=1 TO gWidth
1930 PROC GetGridCell(%x,%y) TO %c
1940 LET %c=%c | INT {uncoveredFlag}
1950 PROC SetGridCell(%x,%y,%c)
1960 NEXT %x
1970 NEXT %y
1980 ENDPROC 
1990 ;
2000 DEFPROC InitDisplay()
2010 ;LAYER 1,1:; standard res
2020 BORDER 0: INK 7: PAPER 0
2030 CLS 
2040 ENDPROC
2050 ;
2060 DEFPROC InitCellTypes()
2070 LET %c[0]=7
2080 LET %c[INT{mineFlag} >> 4]=7
2090 LET %c[INT{uncoveredFlag} >> 4]=4
2100 LET %c[INT{uncoveredFlag+mineFlag} >> 4]=2
2110 LET %c[INT{flaggedFlag} >> 4]=3
2120 LET %c[INT{flaggedFlag+mineFlag} >> 4]=3
2130 LET %c[INT{flaggedFlag+uncoveredFlag} >> 4]=3:; still show flag for uncovered cell that is not a mine
2140 LET %c[INT{flaggedFlag+uncoveredFlag+mineFlag} >> 4]=2
2150 ENDPROC
2160 ;
2170 DEFPROC SplashScreen()
2180 PROC PrintCentered("QuietBloke Productions",10)
2190 PROC PrintCentered("presents",12)
2200 PROC PrintCentered("MineSweeper",14)
2210 LET done=0
2220 REPEAT 
2230 LET k$= INKEY$
2240 IF K$=" " THEN LET done=1
2250 REPEAT UNTIL done=1
2260 ENDPROC
2270 ;
2280 DEFPROC PrintCentered(m$, row)
2290 LOCAL %x
2300 LET %x= (32 - LEN (m$)) / 2
2310 PRINT AT row,%x;m$
2320 ENDPROC

