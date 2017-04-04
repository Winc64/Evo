
;==========================================================
;Evolution DirectX9
; PC-based Retro Game Console
; Version 2015.06
; Copyright 2015 Bert Novilla (satpro)
 
; Filename:  
; Description: 

;==========================================================



#define LINKFILES
#define DONKEYLIB_H
#define USE_IUNKNOWN

;
;	RESOURCE IDs
;

#define ICON_MAIN             1000
#define CUR_MAIN              1002

;==========

;---------------
;WINDOWS/DIRECTX
;---------------
#include "windows.h"
#include "macros.h"
#include "d3d9.h"
#include "d3dx9.h"
#include "resource.h"

;==========

;---------
;EVOLUTION
;---------
#include "constants.asm"                            ;constants, definitions
#include "structures.asm"                           ;structures, macros
;#include "palette.asm"					;color palette tables in both RGB & FP


;==============================================================================

CODE SECTION
align 16

Start:                                            ;program entry point


;==========

;------------
;CALL WINMAIN
;------------
  call WinMain                                    ;main program loop
  invoke ExitProcess, eax                         ;ends the process, quits



;==============================================================================
       
;*************************************************************************************************************
#include "data.asm"                               ;general data
;#include "tables.asm"                             ;math tables, default palette
#include "tbl_RGB_16to32.asm"

cbm_8025
INCBIN ".\Res\chargen80x25"

#include "winmain.asm"                            ;program main loop
#include "wndproc.asm"                            ;program message handler
#include "dx9.asm"                       ;initialize DirectX
#include "ShowSplash.asm"
#include "fake_osboot.asm"

;#include "SendBorder.asm"					;copy BORDER surface to FINAL surface
#include "SendVic.asm"						;copy VIC surface to FINAL surface
;#include "SendFinal.asm"					;copy FINAL surface to BACK surface
;#include "SendOverlay.asm"					;copy OVERLAY surface to BACK surface
;#include "refresh.asm"                            ;update display
;#include "refresh_video.asm"                      ;copy/convert raw video ram to staging surface
;#include "refresh_s.asm"                          ;copy/convert raw sprite ram to 1024x64 sprite surface

;*************************************************************************************************************
       
