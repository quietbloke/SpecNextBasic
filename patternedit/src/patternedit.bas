#autoline 10
; Pattern Editor
; Created by QuietBloke 2020 
; 
; #define C=3
patternBank=0
helpbank=0:; HelpScreen
iobank=0:; Keyboard Input
tempbank=0:; Used for globalvars and splashscreen 

RUN AT 3: ; May as well use all that processor power

; For now Always load/save the palette data file as "TEST.SPR"
BANK NEW patternBank

ON ERROR BANK patternBank ERASE 227: SAVE "TEST.SPR" BANK patternBank

;BANK NEW patternBank
LOAD "TEST.SPR" BANK patternBank

ON ERROR

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

  ; ctrl is down and S pressed then save the data
  IF %k(7)&2=2 AND (k(24)&2=2) THEN SAVE "TEST.SPR" BANK patternBank

  ; ctrl is down and Q pressed then end the app
  IF %k(7)&2=2 AND (k(22)&1=1) THEN STOP
  
; Whatever has happened for now always make sure
  ; the current pattern is displayed in the main sprite and the normal sized sprite
  SPRITE 0,32,32,(ty*16)+tx,%@00000001,0,3,3
  SPRITE 1,32+(17*8)-8,32+2*16,(ty*16)+tx,1

  ; this is the aminating sprite ( eventually)
  SPRITE 2,32+(17*8)-8,32+5*16,(ty*16)+tx,1

  PROC UpdateCursor()
  PROC ShowSpriteCursor()
  PROC ShowPaletteCursor()
  PROC ShowPatternCursor()

REPEAT UNTIL finished = 1

;
; Read back all the palette data
; and write it to the palette bank

SAVE "TEST.SPR" BANK patternBank

STOP 

DEFPROC HandleSprite()
  IF %k(6)&1=1 AND (k(1)&8=8) THEN PROC HideSpriteCursor():cy=cy-1
  IF cy < 0 THEN cy=15

  IF %k(6)&1=1 AND (k(1)&16=16) THEN PROC HideSpriteCursor():cy=cy+1
  IF cy > 15 THEN cy=0

  IF %k(6)&1=1 AND (k(0)&16=16) THEN PROC HideSpriteCursor():cx=cx-1
  IF cx < 0 THEN cx=15

  IF %k(6)&1=1 AND (k(1)&4=4) THEN PROC HideSpriteCursor():cx=cx+1
  IF cx > 15 THEN cx=0

  ; The . Key will plot the pixel 
  IF %(k(7)&6=6) THEN PROC PlotPixelToPattern(ty*16+tx,cx,cy,py*16+px)

  ; The z Key will clear the pixel 
  IF %(k(6)&2=2) THEN PROC PlotPixelToPattern(ty*16+tx,cx,cy,227)

  ; The s Key will select the colour of the pixel
  IF %(k(4)&2=2) THEN PROC GetPixelColourFromPattern(ty*16+tx,cx,cy)
ENDPROC

DEFPROC HandlePalette()
  if %k(6) & 1 = 1 AND (k(1) & 8 = 8) THEN IF py > 0 THEN PROC HidePaletteCursor(): py=py-1
  if %k(6) & 1 = 1 & (k(1) & 16 = 16) THEN IF py < 15 THEN PROC HidePaletteCursor(): py=py+1

  if %k(6) & 1 = 1 & (k(0) & 16 = 16) THEN IF px > 0 THEN PROC HidePaletteCursor(): px=px-1
  if %k(6) & 1 = 1 & (k(1) & 4 = 4) THEN IF px < 15 THEN PROC HidePaletteCursor(): px=px+1
ENDPROC

DEFPROC HandlePattern()
  IF %k(6)&1=1 AND (k(1)&8=8) THEN IF ty > 0 THEN PROC HidePatternCursor():ty=ty-1
  IF %k(6)&1=1&(k(1)&16=16) THEN IF ty < 3 THEN PROC HidePatternCursor():ty=ty+1

  IF %k(6)&1=1&(k(0)&16=16) THEN IF tx > 0 THEN PROC HidePatternCursor():tx=tx-1
  IF %k(6)&1=1&(k(1)&4=4) THEN IF tx < 15 THEN PROC HidePatternCursor():tx=tx+1

  ; ctrl-c key press will make a note of the current pattern
  IF %k(7)&2=2 AND (k(26)&8=8) THEN copyPattern=(ty*16)+tx 

  ; ctrl-p key press will copy the noted pattern to the current pattern
  IF %k(7)&2=2 AND (k(23)&1=1) THEN PROC PatternPaste(copyPattern,(ty*16)+tx)
ENDPROC

DEFPROC PatternPaste(%s,%t)
  FOR %p=0 TO 255
    %b=%BANK INT {patternBank} PEEK (s*256+p)
    BANK patternBank POKE %(t*256+p),%b
  NEXT %p
  SPRITE BANK patternBank
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
  ; BRIGHT 1

  CLS

  BORDER 0

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
  FOR %x=0 to 15
    PLOT 0,%x*8+7
    DRAW 8*16-1,0
    PLOT %x*8+7,0
    DRAW 0,8*16-1
  NEXT %x

  ; Render the grid over the palette
  FOR %x=0 to 16
    PLOT 160,%x*6
    DRAW 6*16,0
    PLOT %x*6+160,0
    DRAW 0,6*16
  NEXT %x

  ; Render the grid over the pattern
;  FOR %x=0 to 16
;    PLOT 0,%x*16+128
;    DRAW 16*16,0
;    PLOT %x*16,128
;    DRAW 0,4*16
;  NEXT %x
ENDPROC

DEFPROC InitSprites()
  ; Assign patterns to the sprite and enable sprites
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

  %s = 3
  FOR %x=0 TO 7
    SPRITE %x+s,32+(17*8)+8,%x*16+32,%x,1:; For now anim frames are pattern 0-7
  NEXT %x

   %s = 11

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

DEFPROC GetPixelColourFromPattern(%p,%x,%y)
  %c=%BANK INT{patternBank} PEEK ((p*256)+(y*16)+x)
  %y=%(c/16)
  %x=%(c-(y*16))
  PROC HidePaletteCursor()
  px=%x
  py=%y
ENDPROC

; Make the cursor flash
DEFPROC UpdateCursor()
  pFlashCount=pFlashCount+1
  IF pFlashCount > pFlashRate THEN pFlash=1-pFlash: pFlashCount = 0
ENDPROC

DEFPROC ShowCursor(%x,%y,w,h)
  LAYER 2
  IF pFlash=0 THEN ch=0:cv=255: ELSE ch=255:cv=0
  INK ch: PLOT %x,%y: DRAW w,0: INK cv: DRAW 0,h: INK ch: DRAW w*-1,0: INK cv: DRAW 0,h*-1
ENDPROC

DEFPROC HideCursor(%x,%y,w,h,%c)
  LAYER 2
  
  INK %c: PLOT %x,%y: DRAW w,0: DRAW 0,h: DRAW w*-1,0: DRAW 0,h*-1
ENDPROC

DEFPROC ShowSpriteCursor()
  PROC ShowCursor(cx*8-1,cy*8-1,8,8)
ENDPROC

DEFPROC HideSpriteCursor()
  PROC HideCursor(cx*8-1,cy*8-1,8,8,0)
ENDPROC

DEFPROC ShowPaletteCursor()
  PROC ShowCursor(px*6+160,py*6,6,6)
ENDPROC

DEFPROC HidePaletteCursor()
  PROC HideCursor(px*6+160,py*6,6,6,0)
ENDPROC

DEFPROC ShowPatternCursor()
  PROC ShowCursor(tx*16,ty*16+128,15,15)
ENDPROC

DEFPROC HidePatternCursor()
  PROC HideCursor(tx*16,ty*16+128,15,15,227)
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
