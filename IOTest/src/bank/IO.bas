#autoline 10

DEFPROC InitKeyboard()
    ; store previous state
    FOR %l=0 TO 7
        LET %k(l)=31:    ; State of key 0 = up, 1 = dowm
        LET %k(l+10)=0:  ; previous states from %k(0). (For internal use)
        LET %k(l+20)=0:  ; State if key state has just flipped from 0 to 1
        LET %k(l+30)=0:  ; Previous states from %k(20). (For internal use)
    NEXT %l
ENDPROC

DEFPROC ReadKeyboard()
    ; store previous state
    FOR %l=0 TO 7
        LET %k(l+10)=%k(l)
        LET %k(l+30)=%k(l+20)
    NEXT %l
    
    rem xor the inputs as the default is that a 1 indicates then key is not pressed
    LET %k(0)=% (IN 63486^255)&31: ; 1 to 5
    LET %k(1)=% (IN 61438^255)&31: ; 0 to 6

    LET %k(2)=% (IN 64510^255)&31: ; Q to T
    LET %k(3)=% (IN 57342^255)&31: ; Y to P

    LET %k(4)=% (IN 65022^255)&31: ; A to G
    LET %k(5)=% (IN 49150^255)&31: ; Enter to H

    LET %k(6)=% (IN 65278^255)&31: ; CapsShift, Z to V
    LET %k(7)=% (IN 32766^255)&31: ; Space, Sym, M to B

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
