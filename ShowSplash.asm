



CODE SECTION
align 16



/*
D3DXIMAGE_INFO Info;

D3DXGetImageInfoFromFile("c:\image.jpg", &Info);

g_pd3dDevice->CreateOffscreenPlainSurface(Info.Width, Info.Height,

Info.Format, &g_Surface, NULL);

D3DXLoadSurfaceFromFile(g_Surface, NULL, NULL, "c:\image.jpg", NULL,
D3DX_FILTER_NONE, 0xFF000000, NULL);
*/


;==========

ShowSplash FRAME
LOCAL Info				:D3DXIMAGE_INFO
LOCAL pp_Splash 	:%LPDIRECT3DSURFACE9
LOCAL hWaitObject	:%HANDLE

invoke D3DXGetImageInfoFromFile, "F:\Projects\x86\evo9\Res\evo9.jpg", addr Info
  DxError("D3DXGetImageInfoFromFile")


;==========

mov D[pp_Splash], 0

stdmethod(IDirect3DDevice9.CreateOffscreenPlainSurface, pp_Device, \
	[Info.Width], \
	[Info.Height], \
	[Info.Format], \
	D3DPOOL_DEFAULT, \
	addr pp_Splash, \
	NULL)

  DxError("Create Vic Surface")


;==========

	invoke D3DXLoadSurfaceFromFile, [pp_Splash], NULL, NULL, \
		"F:\Projects\x86\evo9\Res\evo9.jpg", NULL, D3DX_FILTER_NONE, 0xFF000000, NULL

  DxError("D3DXLoadSurfaceFromFile")


;==========

mov eax, [ScreenWidth]
shr eax, 1
mov edx, [Info.Width]
shr edx, 1
sub eax, edx
mov [DstRect.left], eax

add eax, [Info.Width]
mov [DstRect.right], eax


mov eax, [ScreenHeight]
shr eax, 1
mov edx, [Info.Height]
shr edx, 1
sub eax, edx
mov [DstRect.top], eax

add eax, [Info.Height]
mov [DstRect.bottom], eax

stdmethod(IDirect3DDevice9.StretchRect, pp_Device,	\
	[pp_Splash],	\
	NULL,	\
	[pp_Back],	\
	addr DstRect,	\
	NULL)

  DxError("Copy Splash to Backbuffer Surface")

;

stdmethod(IDirect3DDevice9.Present, pp_Device,0,0,0,0)
  DxError("Present")

/*
HANDLE CreateEvent(

    LPSECURITY_ATTRIBUTES  lpEventAttributes,	// address of security attributes  
    BOOL  bManualReset,	// flag for manual-reset event 
    BOOL  bInitialState,	// flag for initial state 
    LPCTSTR  lpName 	// address of event-object name  
   );
*/
	
	invoke CreateEvent, NULL, FALSE, FALSE, NULL
		mov [hWaitObject], eax

	invoke WaitForSingleObject, [hWaitObject], 1500
	invoke CloseHandle, [hWaitObject]
	
  SafeRelease(IDirect3DDevice9, pp_Splash)

	invoke ShowCursor, TRUE
	
ret
ENDF
