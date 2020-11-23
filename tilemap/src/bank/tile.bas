#autoline 10

DEFPROC TileOpen()
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

DEFPROC TileClip(x1,x2,y1,y2)
  ; X left position
  REG %$1B, x1:;8
  ; X right position : Note The X xo-ords are internally doubled so we specify a value 0 - 159
  REG %$1B, x2:;151
  ; Y top position
  REG %$1B, y1:;16
  ; Y bottom position
  REG %$1B, y2:;239
ENDPROC

DEFPROC TileClose()
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

; Initialise writing to the tile palette starting from index
DEFPROC TilePaletteWriteInit(%i)
  ; Set the palette
  REG %$43,%@00110000:; select tilemap palette
  REG %$40,%i:; select palette index
ENDPROC 

; Set the next colour in the palette
DEFPROC TilePaletteWrite(%c)
  REG %$41,%c: ; set the colour
ENDPROC 

; Set the transparency colour index offset
DEFPROC TilePaletteSetTransparent(%c)
  ; Set which palette index is transparent (0- 15, hex 0 - F), default is 0.
  ; bits 7-4 = reseved
  ; bits 3-0 = index value
  REG %$4C, %c
ENDPROC

DEFPROC TileGetAddress(%t)
  LOCAL %a
  %a = %$4000 + ($10 * 256) + (t*32)
ENDPROC =%a

DEFPROC TileSet(%x,%y,%t,%f)
  POKE %$4000+(x*2)+(y*80),%t
  POKE %$4000+(x*2)+(y*80)+1,%f
ENDPROC




