
;==========================================================
; Evolution DirectX 9
; PC-based Computer Emulator w/ 32-bit, 65x-based cpu
; 1280x720x32 graphics, 32 64x64 full-color sprites
; Version 2014.10
; Copyright 2008-2014 Bert Novilla (satpro)
; Mom E.'s Bad Boy
 
; Filename:  structures.h
; Description: structures

;==========================================================


CONST SECTION

;---------------------------------------------------------------------------------------------------

;graphics
;--------
iCONTROL  STRUCT

  DisplayEnable     db            0     ;0-1    0 = DISPLAY DISABLED, 1 = DISPLAY ENABLED
  BackColor         db            0     ;0-255  BACKGROUND COLOR
  ForeColor         db            0     ;0-255  FOREGROUND COLOR

  Palette           dd 256 dup    0     ;0-255    256 RGB QUADS (X, R, G, B)
  
iCONTROL  ENDS

;---------------------------------------

iSPRITE   STRUCT                        ;Range    Description

  Enable            dd 16 dup     0     ;0-1      0 = SPRITE DISABLED, 1 = SPRITE ENABLED
  DataPtr           dd 16 dup     0     ;0-15     4K data bank holding visible sprite image data
  SpriteX           dd 16 dup     0     ;         SPRITE X COORDINATES
  SpriteY           dd 16 dup     0     ;         SPRITE Y COORDINATES
                                        ;         (X = 0-704, Y = 0-464)
  SrcCKEnable       dd 16 dup     0     ;0-1      0 = SRC COLORKEY DISABLED, 1 = SRC COLORKEY ENABLED
  DstCKEnable       dd 16 dup     0     ;0-1      0 = DST COLORKEY DISABLED, 1 = DST COLORKEY ENABLED
  SrcColorKey       dd 16 dup     0     ;0-255    SOURCE COLORKEY VALUE
  DstColorKey       dd 16 dup     0     ;0-255    DEST COLORKEY VALUE

iSPRITE   ENDS

;---------------------------------------

iGRAPHICS   STRUCT

  Ctrl              iCONTROL            ;
  Spr               iSPRITE             ;

iGRAPHICS   ENDS

;---------------------------------------




;==================================================================================================





