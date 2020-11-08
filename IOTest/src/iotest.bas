#autoline 10
RUN AT 2

LET finished=0

INK 7
PAPER 0
CLS

; %k() stores all the states of the key
REPEAT
    PROC ReadKeyboard()
    PROC DisplayKeysDown()
REPEAT UNTIL finished=1
STOP

DEFPROC ReadKeyboard()
    ; store previous state
    FOR %l=0 TO 7
        LET %k(l+10)=%k(l)
        LET %k(l+30)=%k(l+20)
    NEXT %l
    
    rem xor the inputs as the default is that a 1 indicates then key is not pressed
    LET %k(0)=% IN 63486^255: ; 5 to 1
    LET %k(1)=% IN 61438^255: ; 6 to 0

    LET %k(2)=% IN 64510^255: ; Q to T
    LET %k(3)=% IN 57342^255: ; P to Y

    LET %k(4)=% IN 65022^255: ; A to G
    LET %k(5)=% IN 49150^255: ; Enter to H

    LET %k(6)=% IN 65278^255: ; caps shift to V
    LET %k(7)=% IN 32766^255: ; Space to B

    REM in offset 20 we store bits that have been set compared to previous setting
    REM eg: key pressed : 00001 current, 00000 prev,
    REM 00001 xor 00000 = 00001
    REM 00001 & 00001 = 00001

    REM eg: key remains pressed : 00001 current, 00000 prev,
    REM 00001 xor 00001 = 00000
    REM 00000 & 00001 = 00000

    REM eg: key released 00000 current, 00001 prev,
    REM 00000 xor 00001 = 00001
    REM 00001 & 00000 = 00000

    FOR %l=0 TO 7
        LET %k(l+20)=%k(l)^(k(l+10)) & k(l)
    NEXT %l            
ENDPROC

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
    PROC DisplayKey(3,2,"1",0,%@00001)
    PROC DisplayKey(4,2,"2",0,%@00010)
    PROC DisplayKey(5,2,"3",0,%@00100)
    PROC DisplayKey(6,2,"4",0,%@01000)
    PROC DisplayKey(7,2,"5",0,%@10000)
ENDPROC

DEFPROC Display1()
    PROC DisplayKey(13,2,"6",1,%@10000)
    PROC DisplayKey(14,2,"7",1,%@01000)
    PROC DisplayKey(15,2,"8",1,%@00100)
    PROC DisplayKey(16,2,"9",1,%@00010)
    PROC DisplayKey(17,2,"0",1,%@00001)
ENDPROC

DEFPROC Display2()
    PROC DisplayKey(3,3,"Q",2,%@00001)
    PROC DisplayKey(4,3,"W",2,%@00010)
    PROC DisplayKey(5,3,"E",2,%@00100)
    PROC DisplayKey(6,3,"R",2,%@01000)
    PROC DisplayKey(7,3,"T",2,%@10000) 
ENDPROC

DEFPROC Display3()
    PROC DisplayKey(13,3,"Y",3,%@10000)
    PROC DisplayKey(14,3,"U",3,%@01000)
    PROC DisplayKey(15,3,"I",3,%@00100)
    PROC DisplayKey(16,3,"O",3,%@00010)
    PROC DisplayKey(17,3,"P",3,%@00001)
ENDPROC

DEFPROC Display4()
    PROC DisplayKey(3,4,"A",4,%@00001)
    PROC DisplayKey(4,4,"S",4,%@00010)
    PROC DisplayKey(5,4,"D",4,%@00100)
    PROC DisplayKey(6,4,"F",4,%@01000)
    PROC DisplayKey(7,4,"G",4,%@10000)
ENDPROC

DEFPROC Display5()
    PROC DisplayKey(13,4,"H",5,%@10000)
    PROC DisplayKey(14,4,"J",5,%@01000)
    PROC DisplayKey(15,4,"K",5,%@00100)
    PROC DisplayKey(16,4,"L",5,%@00010)
    PROC DisplayKey(17,4,"Ent",5,%@00001)
ENDPROC

DEFPROC Display6()
    PROC DisplayKey(1,5,"Shf",6,%@00001)
    PROC DisplayKey(4,5,"Z",6,%@00010)
    PROC DisplayKey(5,5,"X",6,%@00100)
    PROC DisplayKey(6,5,"C",6,%@01000)
    PROC DisplayKey(7,5,"V",6,%@10000)
ENDPROC

DEFPROC Display7()
    PROC DisplayKey(13,5,"B",7,%@10000)
    PROC DisplayKey(14,5,"N",7,%@01000)
    PROC DisplayKey(15,5,"M",7,%@00100)
    PROC DisplayKey(16,5,"Sym",7,%@00010)
    PROC DisplayKey(19,5,"Spc",7,%@00001)
ENDPROC

; %x xpos, %y ypos, l$ label, %s state array pos, %m mask
DEFPROC DisplayKey(%x,%y,l$,%s,%m)
    IF %k(s)&m <> 0 THEN INK 3: ELSE INK 1
    IF %k(s+20)&m <> 0 THEN INK 7
    PRINT AT %y,%x;l$
ENDPROC
{}