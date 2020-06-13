#autoline 10
DEFPROC InitVars()
; global stuff
LET gWidth = 10:;  cells across
LET gHeight = 10:; cells down
LET mines = INT(gwidth * gHeight / 8):; number of mines
; %g array used to store grid cell info 
; NOTE : grid array stored include 1 cell padding on all sides
; %c array used to store cell colours based on flag combinations  
; bit 0-4 number of neighbouring mines
; bit 5 contains mine
; bit 6 uncovered
; bit 7 flagged 
LET mineFlag     =%@00010000
LET uncoveredFlag=%@00100000
LET flaggedFlag  =%@01000000
LET gridFlagsMask=%@11110000
LET gridValueMask=%@00001111
LET gOffsetX = -1:; x offset of grid on screen
LET gOffsetY = -1:; y offset of grid on screen
;
LET px = 1:; player xpos
LET py = 1:; player ypos
LET opx = 1:; old player xpos
LET opy = 1:; old player ypos
LET pFlashRate = 2:; speed of cursor flash
LET pFlash = 0:; is cursor on or off
LET pFlashCount = 0:; time time flash toggles
;
LET finished = 0
LET mineHit = 0
ENDPROC