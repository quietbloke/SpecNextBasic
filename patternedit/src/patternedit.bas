#autoline 10
; Pattern Editor
; Created by QuietBloke 2020 
; 
; #define C=3

RUN AT 3: ; May as well use all that processor power
;PROC InitDisplay()

BANK NEW tempbank
LOAD "globalvars.bas" BANK tempbank
BANK tempbank PROC InitVars()
BANK tempbank CLEAR

BANK NEW tempbank
LOAD "splashscreen.bas" BANK tempbank
BANK tempbank PROC SplashScreen()
BANK tempbank CLEAR

BANK NEW helpbank
LOAD "helpscreen.bas" BANK helpbank

BANK NEW iobank
LOAD "IO.bas" BANK iobank

PROC InitDisplay()

BANK iobank PROC InitKeyboard()

; game loop
REPEAT
  BANK iobank PROC ReadKeyboard()

  if %k(6) & 1 = 1 AND (k(1) & 8 = 8) THEN IF cy > 0 THEN PROC HideSpriteCursor(): cy=cy-1
  if %k(6) & 1 = 1 & (k(1) & 16 = 16) THEN IF cy < 15 THEN PROC HideSpriteCursor(): cy=cy+1

  if %k(6) & 1 = 1 & (k(0) & 16 = 16) THEN IF cx > 0 THEN PROC HideSpriteCursor(): cx=cx-1
  if %k(6) & 1 = 1 & (k(1) & 4 = 4) THEN IF cx < 15 THEN PROC HideSpriteCursor(): cx=cx+1

  ; The . Key will plot a pixel 
  if % ( k(7) & 6 = 6 ) THEN STOP

  IF %k(5) & 16 = 16 THEN BANK helpbank PROC HelpScreen()

  PROC ShowSpriteCursor()

REPEAT UNTIL finished = 1

STOP 
;
; Layer 1 at the back. This can be used to display any borders
; around specific sprites on the display
; Layer 2 in the middle. This layer shares the pallete of the sprites
; and is used to display the colour picker.
; Sprites. These are on the top. They are used to show
;   The zoomed in current pattern. User draws on this
;   The current pattern shown in normal size
;   The selected patterns for animation
;   An animated pattern
;   All 64 patterns.

; 
DEFPROC InitDisplay()
  PROC InitLayerOne()
  PROC InitLayerTwo()
  PROC InitSprites()
;LAYER 1,1:; standard res
;  BORDER 0: INK 0: PAPER 7
; CLS 
ENDPROC
;
DEFPROC InitLayerOne()

  LAYER 1,1: ; Use Standard Res mode
  PAPER 7
  CLS

  BORDER 1

  LAYER OVER 1: ; Layer 2 over Sprite over Layer 1
  ; Do all the stuff we need to do
  ; eg load the pattern / pslletes from files
  ; or ask if we want to load exisitng or new file

  ; for now fill the back with enough data for one sprite pattern
ENDPROC

DEFPROC InitLayerTwo()
  ; Select layer 2, and clear all pixels to transparent.
  ; This will mean Layer 1 can have the screen 
  LAYER 2
  LAYER 2,1
  PAPER 227
  CLS

  ; Render the palette
  %c=0
  FOR %y=0 to 15
    FOR %x=0 TO 15
      PROC LAYERERASE(%x*6+128+32,%y*6,5,5,%c)
      %c=%c+1
    NEXT %x
  NEXT %y
ENDPROC

DEFPROC InitSprites()
  BANK NEW patternBank
  BANK patternBank ERASE 227

  ; Temp code to draw something in the first pattern
  BANK patternBank POKE 0,255
  BANK patternBank POKE 15,255
  BANK patternBank POKE 240,255
  BANK patternBank POKE 255,255

  ; and display the sprite
  SPRITE CLEAR
  SPRITE BANK patternBank
  SPRITE PRINT 1

  ; Display a zoomed version of the sprite contianing pattern 0
  ; last 2 paramters are the sprite scale in x and y.
  ; a 3 inidicates 8x zoom
  SPRITE 0,32,32,0,%@00000001,0,3,3

  ; Also display a sprite with pattern 0 normal size
  ;  SPRITE 1,32 + (16*8)+8,32+8,0,1
  SPRITE 1,32 + (16*8)+8,32+8+6*16,0,1

  ; placeholder sprites
  ; show the animation frames ( up to 6? or 8 ?)
  FOR %x=0 TO 6
  ;    SPRITE %x+2,%x*16+(21*8),22*6,0,1
    SPRITE %x+2, 32 + (16*8)+8,%x*16 + 32,0,1
  NEXT %x

  %s = 8

  FOR %y=0 TO 1
    FOR %x=0 TO 15
      SPRITE %s,32,128+32,0,1
    NEXT %x
  NEXT %y
ENDPROC

DEFPROC ShowSpriteCursor()
  LAYER 2
  LOCAL %c
  pFlashCount=pFlashCount+1
  IF pFlashCount > pFlashRate THEN pFlash=1-pFlash: pFlashCount = 0

  IF pFlash=0 THEN %c=127: ELSE %c=227
  INK %c
  PROC LAYERERASE(cx*8,cy*8,8,8,%c)
;    PROC LAYERERASE(cx*8+1,cy*8+1,6,6,227)
ENDPROC

DEFPROC HideSpriteCursor()
  PROC LAYERERASE(cx*8,cy*8,8,8,227)
  pFlashCount=0
  pFlash = 0
ENDPROC

; Basic command LAYER ERASE doesnt work in CSpect
; so lets wrap it in a Proc so we can carry on developing
; using CSpect and then we can switch for the prod build
DEFPROC LAYERERASE(%x,%y,%w,%h,%c)
  INK %c
  FOR %v=0 TO %h-1
    PLOT %x,%y+v
    DRAW %w-1,0 
  NEXT %v
ENDPROC
