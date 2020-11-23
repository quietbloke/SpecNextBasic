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

; active 0 = main editor
; active 1 = palette selector
; active 3 = pattern selector
LET active=0

; game loop
REPEAT
  BANK iobank PROC ReadKeyboard()
  ; i selects sprite
  ; o selects palette
  ; p selects pattern
  IF %k(3)&4=4 THEN active=0: BORDER 0
  IF %k(3)&2=2 THEN active=1: BORDER 1
  IF %k(3)&1=1 THEN active=2: BORDER 2

  IF active=0 THEN PROC handleSprite()
  IF active=1 THEN PROC handlePalette()
  IF active=2 THEN PROC handlePattern()

  IF %k(5) & 16 = 16 THEN BANK helpbank PROC HelpScreen()

  ; Whatever has happened for now always make sure
  ; the current pattern is displayed in the main sprite and the normal sized sprite
  SPRITE 0,32,32,(ty*16)+tx,%@00000001,0,3,3
  SPRITE 1,32+(16*8)+8,32+8+6*16,(ty*16)+tx,1

  PROC UpdateCursor()
  PROC ShowSpriteCursor()
  PROC ShowPaletteCursor()
  PROC ShowPatternCursor()

REPEAT UNTIL finished = 1

STOP 

DEFPROC HandleSprite()
  if %k(6) & 1 = 1 AND (k(1) & 8 = 8) THEN IF cy > 0 THEN PROC HideSpriteCursor(): cy=cy-1
  if %k(6) & 1 = 1 & (k(1) & 16 = 16) THEN IF cy < 15 THEN PROC HideSpriteCursor(): cy=cy+1

  if %k(6) & 1 = 1 & (k(0) & 16 = 16) THEN IF cx > 0 THEN PROC HideSpriteCursor(): cx=cx-1
  if %k(6) & 1 = 1 & (k(1) & 4 = 4) THEN IF cx < 15 THEN PROC HideSpriteCursor(): cx=cx+1

  ; The . Key will plot the pixel 
  IF %(k(7)&6=6) THEN PROC PlotPixelToPattern(ty*16+tx,cx,cy,py*16+px)

  ; The z Key will clear the pixel 
  IF %(k(6)&2=2) THEN PROC PlotPixelToPattern(ty*16+tx,cx,cy,227)
ENDPROC

DEFPROC HandlePalette()
  if %k(6) & 1 = 1 AND (k(1) & 8 = 8) THEN IF py > 0 THEN PROC HidePaletteCursor(): py=py-1
  if %k(6) & 1 = 1 & (k(1) & 16 = 16) THEN IF py < 15 THEN PROC HidePaletteCursor(): py=py+1

  if %k(6) & 1 = 1 & (k(0) & 16 = 16) THEN IF px > 0 THEN PROC HidePaletteCursor(): px=px-1
  if %k(6) & 1 = 1 & (k(1) & 4 = 4) THEN IF px < 15 THEN PROC HidePaletteCursor(): px=px+1
ENDPROC

DEFPROC HandlePattern()
  if %k(6) & 1 = 1 AND (k(1) & 8 = 8) THEN IF ty > 0 THEN PROC HidePatternCursor(): ty=ty-1
  if %k(6) & 1 = 1 & (k(1) & 16 = 16) THEN IF ty < 3 THEN PROC HidePatternCursor(): ty=ty+1

  if %k(6) & 1 = 1 & (k(0) & 16 = 16) THEN IF tx > 0 THEN PROC HidePatternCursor(): tx=tx-1
  if %k(6) & 1 = 1 & (k(1) & 4 = 4) THEN IF tx < 15 THEN PROC HidePatternCursor(): tx=tx+1
ENDPROC

; Layer 1 at the back. This can be used to display any borders
; around specific sprites on the display.
; Sprites. These are on the top. They are used to show
;   The zoomed in current pattern. User draws on this
;   The current pattern shown in normal size
;   The selected patterns for animation
;   An animated pattern
;   All 64 patterns.
; Layer 2. This layer shares the pallete of the sprites
; and is used to
;   Display the colour picker.
;   Display the grid on the main sprite
;   Display the cursors for the main sprite, palette and patterns 
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
  LAYER 2,1
  PAPER 227
  CLS

  ; Render the palette
  %c=0
  FOR %y=0 to 15
    FOR %x=0 TO 15
      PROC LAYERERASE(%x*6+128+32,%y*6,6,6,%c)
      %c=%c+1
    NEXT %x
  NEXT %y

  INK 0
  ; Render the grid over the main sprite
  FOR %x=0 to 16
    PLOT 0,%x*8
    DRAW 8*16,0
    PLOT %x*8,0
    DRAW 0,8*16
  NEXT %x

  ; Render the grid over the palette
  FOR %x=0 to 16
    PLOT 160,%x*6
    DRAW 6*16,0
    PLOT %x*6+160,0
    DRAW 0,6*16
  NEXT %x

  ; Render the grid over the pattern
  FOR %x=0 to 16
    PLOT 0,%x*16+128
    DRAW 16*16,0
    PLOT %x*16,128
    DRAW 0,4*16
  NEXT %x
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
  ;  SPRITE 0,32,32,0,%@00000001,0,3,3

  ; Also display a sprite with pattern 0 normal size
  ;  SPRITE 1,32 + (16*8)+8,32+8,0,1
  ;  SPRITE 1,32 + (16*8)+8,32+8+6*16,0,1

  ; placeholder sprites
  ; show the animation frames ( up to 6? or 8 ?)
  FOR %x=0 TO 6
  ;    SPRITE %x+2,%x*16+(21*8),22*6,0,1
    SPRITE %x+2, 32 + (16*8)+8,%x*16 + 32,0,1
  NEXT %x

  %s = 8

  FOR %y=0 TO 3
    FOR %x=0 TO 15
      SPRITE %s,%x*16+32,%y*16+128+32,%y*16+x,1
      %s = %s + 1
    NEXT %x
  NEXT %y
ENDPROC

; Pattern, xpos, ypos, colour
DEFPROC PlotPixelToPattern(%p,%x,%y,%c)
  BANK patternBank POKE % ((p*256)+(y*16)+x),%c
  SPRITE BANK patternBank
ENDPROC

; Make the cursor flash
DEFPROC UpdateCursor()
  pFlashCount=pFlashCount+1
  IF pFlashCount > pFlashRate THEN pFlash=1-pFlash: pFlashCount = 0
ENDPROC

DEFPROC ShowCursor(%x,%y,w,h)
  LAYER 2
  IF pFlash=0 THEN ch=227:cv=255: ELSE ch=255:cv=227
  INK ch: PLOT %x,%y: DRAW w,0: INK cv: DRAW 0,h: INK ch: DRAW w*-1,0: INK cv: DRAW 0,h*-1
ENDPROC

DEFPROC HideCursor(%x,%y,w,h)
  LAYER 2
  INK 0: PLOT %x,%y: DRAW w,0: DRAW 0,h: DRAW w*-1,0: DRAW 0,h*-1
ENDPROC

DEFPROC ShowSpriteCursor()
  PROC ShowCursor(cx*8,cy*8,8,8)
ENDPROC

DEFPROC HideSpriteCursor()
  PROC HideCursor(cx*8,cy*8,8,8)
ENDPROC

DEFPROC ShowPaletteCursor()
  PROC ShowCursor(px*6+160,py*6,6,6)
ENDPROC

DEFPROC HidePaletteCursor()
  PROC HideCursor(px*6+160,py*6,6,6)
ENDPROC

DEFPROC ShowPatternCursor()
  LAYER 2
  INK 255

;  PLOT tx*16,ty*16+128: DRAW 15,0: DRAW 0,15: DRAW -15,0: DRAW 0,-15 
  IF pFlash=0 THEN ch=222:cv=0: ELSE ch=0:cv=222
;  INK ch: PLOT tx*16,ty*16+128: DRAW 15,0: INK cv: DRAW 0,15: INK ch: DRAW -15,0: INK cv: DRAW 0,-15

  PROC ShowCursor(tx*16,ty*16+128,16,16)
ENDPROC

DEFPROC HidePatternCursor()
  LAYER 2
  INK 227

;  PLOT tx*16,ty*16+128: DRAW 15,0: DRAW 0,15: DRAW -15,0: DRAW 0,-15 
  PROC HideCursor(tx*16,ty*16+128,16,16)
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
