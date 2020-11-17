#autoline 10
; tilemap
; Created by QuietBloke 2020 
; 
; #define C=3

RUN AT 0: ; May as well use all that processor power

BANK NEW iobank
LOAD "IO.bas" BANK iobank
BANK iobank PROC InitKeyboard()

PROC InitDisplay()
PROC EnableTileLayer()
PROC TileLayerClip(0,0,0,0)
PROC SetTilePalette()
PROC CreateTiles()
PROC DrawTiles()
PROC TileLayerClip(0,159,0,255)

FOR %l=4 TO 9
  PROC SetTile(%l,%l,1,0)
NEXT %l

finished = 0
; game loop
REPEAT
  BANK iobank PROC ReadKeyboard()

  IF %k(7) & 1 = 1 THEN finished = 1
REPEAT UNTIL finished = 1

PAUSE 0

PROC CloseTileLayer()
STOP 

; -------------------------------------

DEFPROC InitDisplay()
  LAYER 1,1
  PAPER 0
  CLS
  BORDER 1
ENDPROC

DEFPROC EnableTileLayer()
  %t=%$00
  %d=%$10

  ; Create a TileSet 40 x 32. ( 1280 )
  ; The TileMap will be set to use 0x6f00 ( -> 0x7eff) (28415 + 1279 )

  ; First lets Enable the tilemap mode
  ; bit 7 - 1 = enable tilemap
  ; bit 6 - 0 = select 40x32 
  ; bit 5 - 0 = Keep Attribute byte in tilemap
  ; bit 4 - 0 = Select palette 0
  ; bit 3 - Reserved
  ; bit 2 - Reserved
  ; bit 1 - 0 = Do not enable 512 tile mode
  ; bit 0 - 1 = Force tilemap over ULA mode
  REG %$6B, %@10000001

  ; Set the default Tilemap attribute
  ; Only need to set this if bit 5 was set when enabling the mode.
  ; Basically each tile no longer has an attribute byte but instead they all have this one
  ; bit 7-4 = Palette Offset
  ; bit 3 = xmirror
  ; bit 2 = ymirror
  ; bit 1 = Rotate
  ; bit 0 = ULA Over tilemap
  ;REG %$6C, %@00000000

  ; Specify the base offset ( in 256 byte pages )
  ; within the ULA 16K bank where we will store the tilemap.
  ; bit 7-6 = ignored
  ; bit 5-0 = MSB of the address ( decimal 0 - 63, hex 00 to 3f)
  ; NOTE : 40 x 32 = 1280 bytes or 5 pages ( 5 x 256 )
  REG %$6E, %t

  ; Specify the base offset ( in 256 byte pages )
  ; within the ULA 16K bank where we will store the tile definitions.
  ; bit 7-6 = ignored
  ; bit 5-0 = MSB of the address ( decimal 0 - 63, hex 00 to 3f)
  ; NOTE : Each tile definition 32 bytes
  ;  As each tile is 8 x 8 pixels
  ;  and each pixel is represented in 4 bits.
  REG %$6F, %d

  ; Set the visible size of the tilenmap ( the clip window )
  ; This is achived with multiple calls to the port.
 ENDPROC

DEFPROC TileLayerClip(x1,x2,y1,y2)
  ; X left position
  REG %$1B, x1:;8
  ; X right position : Note The X xo-ords are internally doubled so we specify a value 0 - 159
  REG %$1B, x2:;151
  ; Y top position
  REG %$1B, y1:;16
  ; Y bottom position
  REG %$1B, y2:;239
ENDPROC

DEFPROC SetTilePalette()
  ; Set the palette
  REG %$43,%@00110000:; select tilemap palette
  REG %$40,1:; select palette index
  REG %$41,%@11111111: ; set the colour
  REG %$41,%@11100000: ; set the colour
  REG %$41,%@00011100: ; set the colour
  REG %$41,%@00000011: ; set the colour

  ; Set which palette index is transparent (0- 15, hex 0 - F), default is 0.
  ; bits 7-4 = reseved
  ; bits 3-0 = index value
  REG %$4C, %$f

ENDPROC

DEFPROC SetTile(%x,%y,%t,%f)
  POKE %$4000+(x*2)+(y*80),%t
  POKE %$4000+(x*2)+(y*80)+1,%f
ENDPROC

DEFPROC DrawTiles()
  PROC SetTile(8,4,1,0)
  PROC SetTile(10,4,2,0)
  PROC SetTile(12,4,3,0)

  ; NOTE :
  ; bit 3 = xmirror  = 8
  ; bit 2 = ymirror  = 4
  ; bit 1 = Rotate   = 2
  PROC SetTile(20,4,3,%@0000)
  PROC SetTile(22,4,3,%@0010)
  PROC SetTile(24,4,3,%@0100)
  PROC SetTile(26,4,3,%@1010)
ENDPROC

DEFPROC CloseTileLayer()
  ; Create a TileSet 40 x 32. ( 1280 )
  ; The TileMap will be set to use 0x6f00 ( -> 0x7eff) (28415 + 1279 )

  ; First lets Enable the tilemap mode
  ; bit 7 - 1 = enable tilemap
  ; bit 6 - 0 = select 40x32 
  ; bit 5 - 0 = Keep Attribute byte in tilemap
  ; bit 4 - 0 = Select palette 0
  ; bit 3 - Reserved
  ; bit 2 - Reserved
  ; bit 1 - 0 = Do not enable 512 tile mode
  ; bit 0 - 1 = Force tilemap over ULA mode
  REG %$6B,%@00000000

  ; Clean up the memory for the default display
  CLS
ENDPROC

DEFPROC GetTileAddress(%t)
  LOCAL %a
  %a = %$4000 + ($10 * 256) + (t*32)
ENDPROC =%a

DEFPROC CreateTiles()
  ; now lets just poke some data to the first tile data
  LOCAL %a

  FOR %t=0 TO 3
    PROC GetTileAddress(%t) TO %a
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
