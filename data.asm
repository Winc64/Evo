;==========================================================
; Evolution: DirectX 9
; Winc64 Operating System
; Version 2014.12
; Copyright 1990-2014 Bert Novilla (satpro)
;==========================================================

; Filename:  data.h
; Description: program variables

;==========================================================


;----------------------------------------------------------
; VIDEO MEMORY    VIDEOMEM    $F0:0000 (8 BANKS, 512K)
; SPRITE MEMORY   SPRITEMEM   $EF:0000 (1 BANK, 32K)
; ROM             ROMMEM      $F8:0000 (8 BANKS, 512K)
;----------------------------------------------------------


DATA SECTION
align 4


;-------
;WINDOWS
;-------
hInstance           dd          ?                 ;app ID
WindowHandle        dd          ?                 ;main window handle
msg                 MSG
wc                  WNDCLASSEX
hdc                 dd          ?                 ;main window's DC

;---------
;EVOLUTION
;---------
ScreenWidth         dd          ?                 ;user's desktop X-resolution
ScreenHeight        dd          ?                 ;user's desktop Y-resolution
gpu                 iGRAPHICS                     ;graphics processor
Showtime            DD          ?                 ;0 = sleep, 1 = it's Showtime!
lpPaint             PAINTSTRUCT                   ;for WndProc: ON_PAINT

;----
;TEMP
;----
lpPoint             POINT                         ;generic point structure
SrcRect             RECT                          ;generic source rectangle structure
DstRect             RECT                          ;generic dest rectangle structure
;RegECX              dd          ?                 ;temp debug

;-------------------------------------------------------------------------------------------------------------

;---------------------
;TABLE OF GPU DEFAULTS
;---------------------

tbl_GPUDefaults
db 1                                                                  ;gpu.Ctrl.DisplayEnable
db 6                                                                  ;gpu.Ctrl.BackColor
db 14                                                                 ;gpu.Ctrl.ForeColor
dd 256 dup 0                                                          ;gpu.Ctrl.Palette

dd 16 dup 1                                                           ;gpu.Spr.Enable
dd 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15                              ;gpu.Spr.DataPtr
dd 0,100,200,300,400,500,600,700,800,900,1000,1100,1200,320,640,960   ;gpu.Spr.SpriteX
dd 0,50,100,150,200,250,300,350,400,450,500,550,600,650,700,718       ;gpu.Spr.SpriteY
dd 16 dup 0                                                           ;gpu.Spr.SrcCKEnable
dd 16 dup 0                                                           ;gpu.Spr.DstCKEnable
dd 16 dup 0                                                           ;gpu.Spr.SrcColorKey
dd 16 dup 0                                                           ;gpu.Spr.DstColorKey

;-------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------------------


;==========
;FONTS
;==========
;LogFont             LOGFONT   <>                  ;holds info about a font
;hFontObject         dd        ?                   ;holds handle to the CBM font
;hOldFont            dd        ?                   ;holds handle to previous font
;hTitleFont          dd        ?                   ;holds handle to large title font for "Evolution"
;hAuthorFont         dd        ?                   ;holds handle to large title font for "Conceived and Written by Bert Novilla"

;hOldBkMode          dd        ?                   ;holds handle to previous background paint mode
;hOldTextColor       dd        ?                   ;holds handle to previous text color
;hOldBkColor         dd        ?                   ;holds handle to previous background color

;-------
;STRINGS
;-------
;szWelcome
;db "Evolution",0                                  ;splash text
;align 4

;szAuthor
;db "Conceived and Written by Bert Novilla",13,10
;db "c 2014, Mom E.'s Bad Boy",0                   ;written by

align 4
WindowClassName
db  "Main",0                                      ;window class name string

align 4
WindowTitle
db  "Evo9",0                            ;window title string
;align 4

;szPhilosopher
;db  "Philosopher-Regular.ttf",0                   ;font filename
;align 4

;szC64ProMono
;db  "C64_Pro_Mono-STYLE.ttf",0                   ;font filename
;align 4

;szFace_PHILO
;db "Philosopher",0                                ;font name
;align 4

;szFace_CBM
;db "C64 Pro Mono",0                                ;font name
align 4

;===================================================================================================



;LiberationMono-Regular.ttf
;LiberationSerif-Regular.ttf



;db "01234567890123456789012345678901234567890123456789012345678901234567890123456789",13,10
;db "2015",0
;db "Conceived and Written by",13,10
;db "Bert Novilla (satpro)",13,10
;db "c 2014  Mom E.'s Bad Boy"
;align 4

;---------------------------------------------------------------------------------------------------
;===================================================================================================

align 4
MainMemory                                  ;16 MB RAM
db (256*66536)   dup ?


;===================================================================================================






