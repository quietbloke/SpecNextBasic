#autoline 10
RUN AT 2

LET finished=0

INK 7
PAPER 0
CLS

; Load the IO code into a bank
BANK NEW iobank
LOAD "IO.bas" BANK iobank

BANK iobank PROC InitKeyboard()
; %k() stores all the states of the key
REPEAT
    BANK iobank PROC ReadKeyboard()
    PROC DisplayKeysDown()
REPEAT UNTIL finished=1
STOP

DEFPROC DisplayKeysDown()
    IF %k(0) <> k(10) OR (k(20) <> k(30)) THEN PROC Display0()
    IF %k(1) <> k(11) OR (k(21) <> k(31)) THEN PROC Display1()
    IF %k(2) <> k(12) OR (k(22) <> k(32)) THEN PROC Display2()
    IF %k(3) <> k(13) OR (k(23) <> k(33)) THEN PROC Display3()
    IF %k(4) <> k(14) OR (k(24) <> k(34)) THEN PROC Display4()
    IF %k(5) <> k(15) OR (k(25) <> k(35)) THEN PROC Display5()
    IF %k(6) <> k(16) OR (k(26) <> k(36)) THEN PROC Display6()
    IF %k(7) <> k(17) OR (k(27) <> k(37)) THEN PROC Display7()
ENDPROC

DEFPROC Display0()
    PROC DisplayKey(%3,%2,"1",0,%@00001)
    PROC DisplayKey(%4,%2,"2",0,%@00010)
    PROC DisplayKey(%5,%2,"3",0,%@00100)
    PROC DisplayKey(%6,%2,"4",0,%@01000)
    PROC DisplayKey(%7,%2,"5",0,%@10000)

    INK 7
    IF %k(0)=0 THEN PRINT AT 2+10,1;"      ";"  ": ELSE PRINT AT 2+10,1;"%k(0)=";%k(0);"  "
ENDPROC

DEFPROC Display1()
    PROC DisplayKey(%10,%2,"6",1,%@10000)
    PROC DisplayKey(%11,%2,"7",1,%@01000)
    PROC DisplayKey(%12,%2,"8",1,%@00100)
    PROC DisplayKey(%13,%2,"9",1,%@00010)
    PROC DisplayKey(%14,%2,"0",1,%@00001)

    INK 7
    IF %k(1)=0 THEN PRINT AT 2+10,10;"      ";"  ": ELSE PRINT AT 2+10,10;"%k(1)=";%k(1);"  "
ENDPROC

DEFPROC Display2()
    PROC DisplayKey(%3,%3,"Q",%2,%@00001)
    PROC DisplayKey(%4,%3,"W",%2,%@00010)
    PROC DisplayKey(%5,%3,"E",%2,%@00100)
    PROC DisplayKey(%6,%3,"R",%2,%@01000)
    PROC DisplayKey(%7,%3,"T",%2,%@10000) 

    INK 7
    IF %k(2)=0 THEN PRINT AT 3+10,1;"      ";"  ": ELSE PRINT AT 3+10,1;"%k(2)=";%k(2);"  "
ENDPROC

DEFPROC Display3()
    PROC DisplayKey(%10,%3,"Y",%3,%@10000)
    PROC DisplayKey(%11,%3,"U",%3,%@01000)
    PROC DisplayKey(%12,%3,"I",%3,%@00100)
    PROC DisplayKey(%13,%3,"O",%3,%@00010)
    PROC DisplayKey(%14,%3,"P",%3,%@00001)

    INK 7
    IF %k(3)=0 THEN PRINT AT 3+10,10;"      ";"  ": ELSE PRINT AT 3+10,10;"%k(3)=";%k(3);"  "
ENDPROC

DEFPROC Display4()
    PROC DisplayKey(%3,%4,"A",%4,%@00001)
    PROC DisplayKey(%4,%4,"S",%4,%@00010)
    PROC DisplayKey(%5,%4,"D",%4,%@00100)
    PROC DisplayKey(%6,%4,"F",%4,%@01000)
    PROC DisplayKey(%7,%4,"G",%4,%@10000)

    INK 7
    IF %k(4)=0 THEN PRINT AT 4+10,1;"      ";"  ": ELSE PRINT AT 4+10,1;"%k(4)=";%k(4);"  "
ENDPROC

DEFPROC Display5()
    PROC DisplayKey(%10,%4,"H",%5,%@10000)
    PROC DisplayKey(%11,%4,"J",%5,%@01000)
    PROC DisplayKey(%12,%4,"K",%5,%@00100)
    PROC DisplayKey(%13,%4,"L",%5,%@00010)
    PROC DisplayKey(%14,%4,"Ent",%5,%@00001)

    INK 7
    IF %k(5)=0 THEN PRINT AT 4+10,10;"      ";"  ": ELSE PRINT AT 4+10,10;"%k(5)=";%k(5);"  "
ENDPROC

DEFPROC Display6()
    PROC DisplayKey(%1,%5,"Shf",6,%@00001)
    PROC DisplayKey(%4,%5,"Z",6,%@00010)
    PROC DisplayKey(%5,%5,"X",6,%@00100)
    PROC DisplayKey(%6,%5,"C",6,%@01000)
    PROC DisplayKey(%7,%5,"V",6,%@10000)

    INK 7
    IF %k(6)=0 THEN PRINT AT 5+10,1;"      ";"  ": ELSE PRINT AT 5+10,1;"%k(6)=";%k(6);"  "
ENDPROC

DEFPROC Display7()
    PROC DisplayKey(%10,%5,"B",7,%@10000)
    PROC DisplayKey(%11,%5,"N",7,%@01000)
    PROC DisplayKey(%12,%5,"M",7,%@00100)
    PROC DisplayKey(%13,%5,"Sym",7,%@00010)
    PROC DisplayKey(%16,%5,"Spc",7,%@00001)

    INK 7
    IF %k(7)=0 THEN PRINT AT 5+10,10;"      ";"  ": ELSE PRINT AT 5+10,10;"%k(7)=";%k(7);"  "
ENDPROC

; %x xpos, %y ypos, l$ label, %s state array pos, %m mask
DEFPROC DisplayKey(%x,%y,l$,%s,%m)
;    PRINT AT 1,1;"x=";%x;"%y=";%y;"l$=";l$;"%s=";%s;"%m=";%m
;    PAUSE 0
    LOCAL %i
    %i=2
    IF %k(s)&m <> 0 THEN %i=4

    IF %k(s+20)&m <> 0 THEN %i=7
    INK %i
    PRINT AT %y,%x;l$

;    IF %k(s)&m=0 THEN PRINT AT %y+10,%x;"0": ELSE PRINT AT %y+10,%x;"1"
;    PRINT AT %y+10,%x; %m
ENDPROC
