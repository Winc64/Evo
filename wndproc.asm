;==========================================================
; Evolution: DirectX 9
; Winc64 Operating System
; Version 2014.12
; Copyright 1990-2014 Bert Novilla (satpro)
;==========================================================

; Filename:  wndproc.asm
; Description: program message handler

;==========================================================

CODE SECTION
ALIGN 16

;----------------------
;WINDOW MESSAGE HANDLER
;----------------------
WndProc FRAME hwnd, uMsg, wParam, lParam
uses ebx, esi, edi

  mov eax, [uMsg]                                 ;get message sent by Windows
  
;==========


;SWITCH:


;------------
;CASE_COMMAND
;------------

;CASE_COMMAND:
;  cmp eax, WM_COMMAND
;  jne > CASE_KEYDOWN

;mov eax, [wParam]
;and eax, 0x0000ffff

;cmp eax, ID_EXIT_ITEM
;jne > CASE_OUT

;invoke SendMessage, [WindowHandle], WM_CLOSE, 0, 0
;  invoke PostQuitMessage, 0                       ;exit via the message loop
;  jmp CASE_OUT                                    ;return 0



;CASE_OUT:
;  xor eax, eax                                    ;return 0
;  ret

;==========
/*
case WM_COMMAND:
            switch(LOWORD(wParam))
            {
                case ID_FILE_EXIT:

                break;
                case ID_STUFF_GO:

                break;
            }
        break;
        case WM_CLOSE:
            DestroyWindow(hwnd);
        break;
        case WM_DESTROY:
            PostQuitMessage(0);
        break;
        default:
            return DefWindowProc(hwnd, Message, wParam, lParam);
    }
    return 0;
*/






;------------
;CASE_KEYDOWN
;------------

CASE_KEYDOWN:
  cmp eax, WM_KEYDOWN
  jne > CASE_ACTIVATE

  mov eax, [wParam]                               	;get the keycode

  cmp eax, VK_F1									;F1-Settings
  je > K_Q

  cmp eax, VK_F2									;F2-Tools
  je > K_Q

  cmp eax, VK_F3									;F3-About
  je > K_Q

  cmp eax, VK_F4									;F4-Fullscreen
  je > K_Q

  cmp eax, VK_F5									;F5-Help
  je > K_Q

  cmp eax, VK_F6									;F6-Exit
  je > K_Q

  cmp eax, 0x51										;Q-Exit
  je > K_Q
  
  cmp eax, VK_ESCAPE
  je > K_ESCAPE



  xor eax, eax                                    	;return 0
  ret


;*********   INI FILES, PROPER CLIENT SIZE, ABOUT BITMAP   *********


;-------------------------
;USER PRESSED "Q" OR "ESC"                        ;quit the program
;-------------------------
K_Q:
K_ESCAPE:
                                                  ;CONFIRM (Y/N)
;  invoke MessageBox, [WindowHandle], 'Do you really want to exit?', 'Confirm', MB_YESNO
;  cmp eax, IDYES                                ;"Y" = Yes, "N" = No
;  je >
;  ret

  invoke DestroyWindow, [WindowHandle]            ;destroy window and send a WM_DESTROY message
  xor eax, eax                                    ;return 0
  ret

  
;-------------
;CASE_ACTIVATE
;-------------

CASE_ACTIVATE:
  cmp eax, WM_ACTIVATE
  jne > CASE_PAINT                                ;if not WM_ACTIVATE then branch to next check

  mov eax, [wParam]                               ;get wParam
  and eax, 0x0000ffff                             ;get LOWORD(wParam)
  cmp eax, WA_INACTIVE                            ;compare to WA_INACTIVE message
  jne >                                           ;branch to mark Showtime TRUE if not equal
    
  mov D[Showtime], FALSE                          ;else mark Showtime FALSE (sleep)
  xor eax, eax                                    ;return 0
  ret
    
: mov D[Showtime], TRUE                           ;mark Showtime TRUE (awake)
  xor eax, eax                                    ;return 0
  ret


;----------
;CASE_PAINT
;----------

CASE_PAINT:
  cmp eax, WM_PAINT
  jne > CASE_DESTROY                              ;if not WM_PAINT then branch to next check

  invoke BeginPaint, [WindowHandle], addr lpPaint
  invoke EndPaint, [WindowHandle], addr lpPaint

  xor eax, eax                                    ;return 0
  ret

;------------
;CASE_DESTROY
;------------

CASE_DESTROY:                                     ;WM_DESTROY is sent when the window is being destroyed
  cmp eax, WM_DESTROY
  jne > CASE_CREATE                                 ;if not WM_DESTROY then branch to next check

  invoke PostQuitMessage, 0                       ;exit via the message loop
  xor eax, eax                                    ;return 0
  ret

;---------
;WM_CREATE
;---------

CASE_CREATE:
  cmp eax, WM_CREATE
  jne >> CASE_DEFAULT                             ;not in message list, so call Windows default proc


;#define ID_NEW_RECORD_ITEM		1001
;#define ID_SAVE_RECORD_ITEM		1002
;#define ID_QUIT_ITEM			1003
;#define ID_SHOW_ALL_ITEM		1004
;#define ID_SELECT_REPORT_ITEM	1005

DATA SECTION
align 4

hMenu		dd ?
hMenuPopup	dd ?

CODE SECTION

;	invoke CreatePopupMenu
;		mov [hMenuPopup], eax

;	invoke CreateMenu
;		mov [hMenu], eax

;	invoke AppendMenu, [hMenu], MF_STRING, ID_NEW_RECORD_ITEM, "New Record"
;	invoke AppendMenu, [hMenu], MF_STRING, ID_SAVE_RECORD_ITEM, "Save Record"
;	invoke AppendMenu, [hMenuPopup], MF_STRING, ID_QUIT_ITEM, "&Quit"

;	invoke AppendMenu, [hMenu], MF_STRING | MF_POPUP, [hMenuPopup], "&File"

;==========

;	invoke CreatePopupMenu
;		mov [hMenuPopup], eax

;	invoke AppendMenu, [hMenuPopup], ID_SHOW_ALL_ITEM, "Show &All Data"
;	invoke AppendMenu, [hMenuPopup], MF_STRING, ID_SELECT_REPORT_ITEM, "S&elect Report"

;	invoke AppendMenu, [hMenu], MF_STRING | MF_POPUP, [hMenuPopup], "&Reports"

;	invoke SetMenu, [WindowHandle], [hMenu]
  
  xor eax, eax                                    ;return 0
  ret


;------------------------
;DEFAULT WINDOW PROCEDURE
;------------------------

CASE_DEFAULT:
  invoke DefWindowProcA, [hwnd],[uMsg],[wParam],[lParam]
  ret

WndProc   ENDF

;=============================================================================================================
;=============================================================================================================
;=============================================================================================================

;-------------------------------------------------------------------------------------------------------------
;ON_KEYDOWN
;-------------------------------------------------------------------------------------------------------------
/*
;ON_KEYDOWN:
  cmp eax, WM_KEYDOWN
  jne > ON_ACTIVATE

  mov eax, [wParam]                               ;get the keycode
  cmp eax, VK_ESCAPE
  je > K_ESCAPE

  cmp eax, 0x51
  je > K_Q
  
  cmp eax, 0x4d
  je > K_MINIMIZE



  xor eax, eax                                    ;return 0
  ret


;---------------------------------------------
;USER PRESSED "M" (MINIMIZE SCREEN TO TASKBAR)
;---------------------------------------------
K_MINIMIZE:


  xor eax, eax                                    ;return 0
  ret



;-------------------------
;USER PRESSED "Q" OR "ESC"                        ;quit the program
;-------------------------
K_Q:
K_ESCAPE:
                                                  ;CONFIRM (Y/N)
;  invoke MessageBox, [WindowHandle], 'Do you really want to exit?', 'Confirm', MB_YESNO
;  cmp eax, IDYES                                ;"Y" = Yes, "N" = No
;  je >
;  ret

  invoke DestroyWindow, [WindowHandle]            ;destroy window and send a WM_DESTROY message
  xor eax, eax                                    ;return 0
  ret
  
;-------------------------------------------------------------------------------------------------------------
;WM_ACTIVATE
;-------------------------------------------------------------------------------------------------------------

ON_ACTIVATE:
  cmp eax, WM_ACTIVATE
  jne > ON_PAINT                                  ;if not WM_ACTIVATE then branch to next check

  mov eax, [wParam]                               ;get wParam
  and eax, 0x0000ffff                             ;get LOWORD(wParam)
  cmp eax, WA_INACTIVE                            ;compare to WA_INACTIVE message
  jne >                                           ;branch to mark Showtime TRUE if not equal
    
  mov D[Showtime], FALSE                          ;else mark Showtime FALSE (sleep)
  xor eax, eax                                    ;return 0
  ret
    
: mov D[Showtime], TRUE                           ;mark Showtime TRUE (awake)
  xor eax, eax                                    ;return 0
  ret
    
;-------------------------------------------------------------------------------------------------------------
;WM_PAINT
;-------------------------------------------------------------------------------------------------------------

ON_PAINT:
  cmp eax, WM_PAINT
  jne > ON_DESTROY                                ;if not WM_PAINT then branch to next check

  invoke BeginPaint, [WindowHandle], addr lpPaint
  invoke EndPaint, [WindowHandle], addr lpPaint

  xor eax, eax                                    ;return 0
  ret

;-------------------------------------------------------------------------------------------------------------
;WM_DESTROY
;-------------------------------------------------------------------------------------------------------------
ON_DESTROY:                                       ;WM_DESTROY is sent when the window is being destroyed
  cmp eax, WM_DESTROY
  jne > ON_CREATE                                 ;if not WM_DESTROY then branch to next check

  invoke PostQuitMessage, 0                       ;exit via the message loop
  xor eax, eax                                    ;return 0
  ret

;-------------------------------------------------------------------------------------------------------------
;WM_CREATE
;-------------------------------------------------------------------------------------------------------------

ON_CREATE:
  cmp eax, WM_CREATE
  jne > WMDef                                     ;not in Evolution's message list, so call Windows default proc

  xor eax, eax                                    ;return 0
  ret

;-------------------------------------------------------------------------------------------------------------
;DEFAULT WINDOW PROCEDURE FOR ALL OTHER MESSAGES
;-------------------------------------------------------------------------------------------------------------

WMDef:
  invoke DefWindowProcA, [hwnd],[uMsg],[wParam],[lParam]
  ret

WndProc   ENDF

;=============================================================================================================
*/