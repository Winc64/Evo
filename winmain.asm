
;==========================================================
;Evolution DirectX9
; PC-based Retro Game Console
; Version 2015.06
; Copyright 2015 Bert Novilla (satpro)
;==========================================================

; Filename: winmain.asm 
; Description: main program loop

;==========================================================


CODE SECTION


WinMain:
uses ebx, esi, edi

;==========

  invoke GetModuleHandle, NULL                    ;get the program's instance ID
    mov	[hInstance], eax                            ;store it

;==========

;----------------------------
;RAISE THE PROGRAM'S PRIORITY
;----------------------------
  invoke GetCurrentProcess                        ;the answer is returned in eax
  
  invoke SetPriorityClass, eax, HIGH_PRIORITY_CLASS   ;set new priority
  StdError("Set Priority Class")

;==========

;------------
;FAKE OS BOOT
;------------
call Winc64_boot





;==========

;----------------------
;CREATE THE MAIN WINDOW
;----------------------
	invoke ZeroMemory, addr wc, SIZEOF WNDCLASSEX   ;clear WNDCLASSEX structure
  
	mov D[wc.cbSize], sizeof WNDCLASSEX             ;fill in a WNDCLASSEX structure
;	mov D[wc.style], CS_HREDRAW | CS_VREDRAW
	mov D[wc.lpfnWndProc], addr WndProc             ;ptr to window procedure

	mov eax, [hInstance]
		mov [wc.hInstance], eax

	mov [wc.lpszClassName], addr WindowClassName    ;ptr to window name ("Main")

	invoke GetStockObject, BLACK_BRUSH              ;black background
		mov D[wc.hbrBackground], eax

;==========
;-------------
;LOAD APP ICON
;-------------
	invoke LoadIcon, [hInstance], ICON_MAIN         ;32x32
	StdError("LoadIcon 32")

	mov D[wc.hIcon], eax                            ;= app icon


;------------------
;LOAD CUSTOM CURSOR
;------------------
	invoke LoadCursor, [hInstance], CUR_MAIN        ;load "Star Trekkie" cursor
	StdError("LoadCursor")

	mov [wc.hCursor], eax      	                    ;= arrow cursor

;==========

;--------------------
;REGISTER MAIN WINDOW
;--------------------
	invoke RegisterClassEx, addr wc                 ;register the window
	StdError("RegisterClassEx")

	invoke ShowCursor, FALSE
	
;==========

;--------------------------------------------------
;RETRIEVE FULL-SCREEN DIMENSIONS FOR CreateWindowEx
;CALCULATE LOCATION, SIZE OF BLIT TO BACK BUFFER
;--------------------------------------------------
  invoke GetSystemMetrics, SM_CXSCREEN
  mov [ScreenWidth], eax                            ;save user's monitor X-resolution
  
  invoke GetSystemMetrics, SM_CYSCREEN
  mov [ScreenHeight], eax                            ;save user's monitor Y-resolution

;==========

;#define ID_SETTINGS_ITEM		1001
;#define ID_TOOLS_ITEM			1002
;#define ID_FULLSCREEN_ITEM		1003
;#define ID_ABOUT_ITEM			1004
;#define ID_HELP_ITEM			1005
;#define ID_EXIT_ITEM			1006


;	invoke CreateMenu
;		mov [hMenu], eax

;	invoke CreatePopupMenu
;		mov [hMenuPopup], eax


;	invoke AppendMenu, [hMenuPopup], MF_STRING, ID_QUIT_ITEM, "&Quit"
;	invoke AppendMenu, [hMenu], MF_STRING | MF_POPUP, [hMenuPopup]/* ID_FILE_ITEM */, "&File"

;	invoke AppendMenu, [hMenu], MF_STRING, ID_SETTINGS_ITEM, "F1-Settings"
;	invoke AppendMenu, [hMenu], MF_STRING, ID_FULLSCREEN_ITEM, "F2-Tools"
;	invoke AppendMenu, [hMenu], MF_STRING, ID_FULLSCREEN_ITEM, "F3-Fullscreen"
;	invoke AppendMenu, [hMenu], MF_STRING, ID_ABOUT_ITEM, "F4-About"
;	invoke AppendMenu, [hMenu], MF_STRING, ID_HELP_ITEM, "F5-Help"
;	invoke AppendMenu, [hMenu], MF_STRING, ID_EXIT_ITEM, "F6-Exit"



;----------------------
;CREATE THE MAIN WINDOW
;----------------------
 invoke CreateWindowEx, 0, Addr WindowClassName, Addr WindowTitle,        \
   WS_POPUP | WS_VISIBLE, CW_USEDEFAULT, CW_USEDEFAULT, \
   CW_USEDEFAULT, CW_USEDEFAULT, 0, NULL, [hInstance], 0

	StdError("CreateWindowEx")

	mov [WindowHandle], eax                         ;store the new window handle

;==========

;---------------------------
;FOCUS, SHOW THE MAIN WINDOW
;---------------------------
;	invoke ShowWindow, [WindowHandle], SW_SHOWNORMAL	;show the window
;	invoke UpdateWindow, [WindowHandle]

;==========



;------------------
;INITIALIZE DIRECTX
;------------------
  invoke StartDirectX                       ;initialize DirectX
		StdError("Start DirectX")
;  test eax, eax                             ;check for error
;  hint.branch jnz >

;  Invoke MessageBox, [WindowHandle], 'Error initializing DirectX.', 'Error', MB_OK
;  xor eax, eax                                    ;error, show msgbox then exit (retval = FALSE)
;  ret                                             ;error, exit

:















/*
call Refresh
  test eax, eax                                   ;check for error
  hint.branch jnz >

  Invoke MessageBox, [WindowHandle], 'Error refreshing video.', 'Error', MB_OK
  xor eax, eax                                    ;error, show msgbox then exit (retval = FALSE)
  ret                                             ;error, exit

:
*/

/*
int d3d::EnterMsgLoop( bool (*ptr_display)(float timeDelta) )
{
MSG msg;
::ZeroMemory(&msg, sizeof(MSG));
static float lastTime = (float)timeGetTime();
while(msg.message != WM_QUIT)
{
if(::PeekMessage(&msg, 0, 0, 0, PM_REMOVE))
{
::TranslateMessage(&msg);
::DispatchMessage(&msg);
}
else
{
float currTime = (float)timeGetTime();
float timeDelta = (currTime -
lastTime)*0.001f;
ptr_display(timeDelta); // call display function
lastTime = currTime;
}
}
return msg.wParam;
}
*/
;=============================================================================================================
;
;                                               ------------
;                                               MESSAGE LOOP
;                                               ------------
;
;=============================================================================================================

MessageLoop:
  invoke PeekMessage, addr msg, 0, 0, 0, PM_NOREMOVE  ;peek to see if a message is waiting (without removing message)
    test eax, eax                                 ;if = 0, then no message is waiting
    jz > GoToSleep                                ;if = 0, branch and sleep until a message is posted

  invoke GetMessage, addr msg, 0, 0, 0            ;retrieve messages from the queue
    test eax, eax                                 ;if message = 0 (WM_QUIT)
    jz > ExitEvolution                            ;it's time to quit so branch out

  invoke TranslateMessage, addr msg               ;translate virtual-key messages into character messages
  invoke DispatchMessageW, addr msg               ;send the message to WndProc for processing
  jmp < MessageLoop                               ;return to the message loop

GoToSleep:                                        ;yield to other threads if there are no messages in the queue
  invoke WaitMessage                              ;sleep while waiting for a message to come in
  jmp < MessageLoop                               ;return to loop

;---------
;EXIT HERE
;---------
ExitEvolution:

  call StopDirectX                                  ;shut down DirectX
  mov eax, TRUE                                   ;retval = TRUE (OKAY)
  
  ret                                             ;exit here


ENDU
;-------------------------------------------------------------------------------------------------------------


