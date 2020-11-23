#autoline 10
; tilemap
; Created by QuietBloke 2020 
; 
; #define C=3

RUN AT 3: ; May as well use all that processor power

BANK NEW iobank
LOAD "IO.bas" BANK iobank

BANK NEW tilebank
LOAD "tile.bas" BANK tilebank

BANK iobank PROC InitKeyboard()

PROC InitDisplay()
BANK tilebank PROC TileOpen()
BANK tilebank PROC TileClip(0,0,0,0)
PROC SetTilePalette()
PROC CreateTiles()
PROC DrawTiles()
BANK tilebank PROC TileClip(0,159,0,255)

FOR %l=0 TO 31
  BANK tilebank PROC TileSet(%l,%l,1,0)
  BANK tilebank PROC TileSet(%39-l,%l,1,2)
NEXT %l

finished = 0
; game loop
REPEAT
  BANK iobank PROC ReadKeyboard()

  IF %k(7) & 1 = 1 THEN finished = 1
REPEAT UNTIL finished = 1

PAUSE 0

BANK tilebank PROC TileClose()
STOP 

; -------------------------------------

DEFPROC InitDisplay()
  LAYER 1,1
  PAPER 0
  CLS
  BORDER 1
ENDPROC

DEFPROC SetTilePalette()
  BANK tilebank PROC TilePaletteWriteInit(1)

  BANK tilebank PROC TilePaletteWrite(%@11111111)
  BANK tilebank PROC TilePaletteWrite(%@11100000)
  BANK tilebank PROC TilePaletteWrite(%@00011100)
  BANK tilebank PROC TilePaletteWrite(%@00000011)

  BANK tilebank PROC TilePaletteSetTransparent(%$f)
ENDPROC

DEFPROC DrawTiles()
  BANK tilebank PROC TileSet(8,4,1,0)
  BANK tilebank PROC TileSet(10,4,2,0)
  BANK tilebank PROC TileSet(12,4,3,0)

  ; NOTE :
  ; bit 3 = xmirror  = 8
  ; bit 2 = ymirror  = 4
  ; bit 1 = Rotate   = 2
  BANK tilebank PROC TileSet(20,4,3,%@0000)
  BANK tilebank PROC TileSet(22,4,3,%@0010)
  BANK tilebank PROC TileSet(24,4,3,%@0100)
  BANK tilebank PROC TileSet(26,4,3,%@1010)
ENDPROC

DEFPROC CreateTiles()
  ; now lets just poke some data to the first tile data
  LOCAL %a

  FOR %t=0 TO 3
    BANK tilebank PROC TileGetAddress(%t) TO %a
    FOR %p=0 TO 31
      READ %v
      POKE %a+p,%v
    NEXT %p
  NEXT %t
ENDPROC

; tile data 8x8 pixels. 4 bits per pixel
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00
DATA %$00,%$01,%$10,%$00
DATA %$00,%$01,%$10,%$00
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00

DATA %$20,%$00,%$00,%$00
DATA %$02,%$00,%$00,%$00
DATA %$00,%$20,%$00,%$00
DATA %$00,%$02,%$00,%$00
DATA %$00,%$00,%$20,%$00
DATA %$00,%$00,%$02,%$00
DATA %$00,%$00,%$00,%$20
DATA %$00,%$00,%$00,%$02

DATA %$30,%$00,%$00,%$00
DATA %$33,%$00,%$00,%$00
DATA %$33,%$30,%$00,%$00
DATA %$33,%$33,%$00,%$00
DATA %$33,%$33,%$30,%$00
DATA %$33,%$33,%$33,%$00
DATA %$33,%$33,%$33,%$30
DATA %$33,%$33,%$33,%$33

DATA %$44,%$44,%$44,%$44
DATA %$44,%$44,%$44,%$44
DATA %$44,%$44,%$44,%$44
DATA %$44,%$44,%$44,%$44
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00
DATA %$00,%$00,%$00,%$00
