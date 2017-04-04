;==========================================================
; Evolution: DirectX 9
; Version 2017.1
; Copyright 2010-2017 Bert Novilla (satpro)
;==========================================================

; Filename:  startDirectX.asm
; Description: DirectX 9 startup

;==========================================================


;----------------------------------------------------------
; VIDEO MEMORY    VIDEOMEM    $40:0000 (16 BANKS, 64 BANKS)
; GPU I/O MEMORY  GPUMEM      $78:4000
; SPRITE MEMORY   SPRITEMEM   $80:0000 (16 BANKS, 64 BANKS)
; ROM             ROMMEM      $C0:0000
;----------------------------------------------------------


;===================================================================================================
;===================================================================================================

DATA SECTION
align 4

;--------------------
;DIRECT3D9 INTERFACES
;--------------------
pp_DIRECT3D9        LPDIRECT3D9 ?   				;D3D9 object interface
pp_Device           LPDIRECT3DDEVICE9 ?   	;device interface

pp_Back             LPDIRECT3DSURFACE9 ?    ;back buffer surface interface
pp_Vic							LPDIRECT3DSURFACE9 ?		;VIC (incl. border area) surface interface
pp_Sprite						LPDIRECT3DSURFACE9 ?		;SPRITE surface interface
pp_Final						LPDIRECT3DSURFACE9 ?		;FINAL, composite surface

;---------------
;DATA STRUCTURES
;---------------
d3dpp               D3DPRESENT_PARAMETERS   ;presentation parameters structure
lockedRect          D3DLOCKED_RECT					;for surface mapping
pt                  POINT

;===================================================================================================
;===================================================================================================


CODE SECTION
ALIGN 16

StartDirectX 	FRAME						;returns FALSE if an error occurs


;-------------------------------
;CREATE THE DIRECT3D 9 INTERFACE
;-------------------------------
	mov D[pp_DIRECT3D9], 0                  ;zero the interface ptr
  
invoke Direct3DCreate9, D3D_SDK_VERSION
  StdError("Direct3DCreate9")

	mov [pp_DIRECT3D9], eax

;==========

;----------------------------
;CREATE THE DIRECT3D 9 DEVICE
;----------------------------
	mov D[pp_Device], 0                  	;zero the interface ptr

invoke ZeroMemory, addr d3dpp, sizeof D3DPRESENT_PARAMETERS

	mov eax, [ScreenWidth]
  mov [d3dpp.BackBufferWidth], eax
	
	mov eax, [ScreenHeight]
  mov [d3dpp.BackBufferHeight], eax
  mov D[d3dpp.BackBufferFormat], D3DFMT_X8R8G8B8
  mov D[d3dpp.BackBufferCount], 1
  mov D[d3dpp.MultiSampleType], D3DMULTISAMPLE_NONE
  mov D[d3dpp.SwapEffect], D3DSWAPEFFECT_DISCARD

  mov eax, [WindowHandle]
  mov [d3dpp.hDeviceWindow], eax

  mov D[d3dpp.Windowed], FALSE
  mov D[d3dpp.EnableAutoDepthStencil], FALSE
;  mov D[d3dpp.Flags], D3DPRESENTFLAG_LOCKABLE_BACKBUFFER
;  mov D[d3dpp.FullScreen_RefreshRateInHz], D3DPRESENT_RATE_DEFAULT
  mov D[d3dpp.PresentationInterval], D3DPRESENT_INTERVAL_DEFAULT    ;ONE

stdmethod(IDirect3D9.CreateDevice, pp_DIRECT3D9, \
    D3DADAPTER_DEFAULT, \
    D3DDEVTYPE_HAL, \
    [WindowHandle], \
		D3DCREATE_SOFTWARE_VERTEXPROCESSING, \
    addr d3dpp, \
    addr pp_Device)

  DxError("CreateDevice")

;==========

;-------------------
;GET THE BACK BUFFER
;-------------------
	mov D[pp_Back], 0                  	;zero the interface ptr

  stdmethod(IDirect3DDevice9.GetBackBuffer, pp_Device,  \ ;HRESULT GetBackBuffer(
    0, 0, D3DBACKBUFFER_TYPE_MONO, addr pp_Back)

  DxError("GetBackBuffer")

  stdmethod(IDirect3DSurface9.Release, pp_Back)

;==========

;------------------------------------------
;CREATE VIC SURFACE (INCLUDING BORDER AREA)
;------------------------------------------
mov D[pp_Vic], 0

stdmethod(IDirect3DDevice9.CreateOffscreenPlainSurface, pp_Device, \
	VICWIDTH, \
	VICHEIGHT, \
	D3DFMT_X8R8G8B8, \
	D3DPOOL_SYSTEMMEM, \
	addr pp_Vic, \
	NULL)

  DxError("Create Vic Surface")

;==========

;------------------------------
;CREATE FINAL COMPOSITE SURFACE
;------------------------------

mov D[pp_Final], 0

stdmethod(IDirect3DDevice9.CreateOffscreenPlainSurface, pp_Device, \
	FINALWIDTH, \
	FINALHEIGHT, \
	D3DFMT_X8R8G8B8, \
	D3DPOOL_DEFAULT, \
	addr pp_Final, \
	NULL)

  DxError("Create Final Surface")

;==========

/*
HRESULT ColorFill(
  [in]  IDirect3DSurface9 *pSurface,
  [in]  const RECT *pRect,
  [in]  D3DCOLOR color
);
*/

stdmethod(IDirect3DDevice9.ColorFill, pp_Device, \
	[pp_Final], \
	NULL, \
	0)
;	0x6C5EB5)

  DxError("ColorFill Final Surface")




;===============================================================

/*
HRESULT UpdateSurface(
  [in]  IDirect3DSurface9 *pSourceSurface,
  [in]  const RECT *pSourceRect,
  [in]  IDirect3DSurface9 *pDestinationSurface,
  [in]  const POINT *pDestinationPoint
);
*/

mov D[lpPoint.x], 32
mov D[lpPoint.y], 32
mov D[SrcRect.left], 32
mov D[SrcRect.top], 32
mov D[SrcRect.right], 640+32
mov D[SrcRect.bottom], 400+32


stdmethod(IDirect3DDevice9.UpdateSurface, pp_Device, \
	[pp_Vic], \
	addr SrcRect, \
	[pp_Final], \
	addr lpPoint)

  DxError("UpdateSurface")






;==========





;=============================================================

;"SendBorder.asm"
;invoke SendBorder							;copy BORDER surface to FINAL surface

;=============================================================

;"SendVic.asm"

;=============================================================

;"SendVic.asm"
;invoke SendOverlay								;copy VIC surface to FINAL surface

;=============================================================

;"SendFinal.asm"
;invoke SendFinal							;copy FINAL surface to BACKBUFFER surface

;=============================================================


;==========

;==========

;--------------------------------
;COPY  SURFACE TO  SURFACE
;--------------------------------

;HRESULT StretchRect(
;  [in]  IDirect3DSurface9 *pSourceSurface,
;  [in]  const RECT *pSourceRect,
;  [in]  IDirect3DSurface9 *pDestSurface,
;  [in]  const RECT *pDestRect,
;  [in]  D3DTEXTUREFILTERTYPE Filter

stdmethod(IDirect3DDevice9.StretchRect, pp_Device,	\
	[pp_Final],	\
	NULL,	\
	[pp_Back],	\
	NULL,	\
	NULL)

  DxError("Copy to Backbuffer Surface")



call ShowSplash
  DxError("ShowSplash")


stdmethod(IDirect3DDevice9.ColorFill, pp_Device, \
	[pp_Final], \
	NULL, \
	0x7060b8) ;0)
;	0x6C5EB5)

  DxError("ColorFill Final Surface")

invoke SendVic								;copy VIC surface to FINAL surface

stdmethod(IDirect3DDevice9.StretchRect, pp_Device,	\
	[pp_Final],	\
	NULL,	\
	[pp_Back],	\
	NULL,	\
	NULL)

  DxError("Copy to Backbuffer Surface")



;=============================================================
;--------------------
;FLIP BUFFER TO FRONT
;--------------------

;HRESULT Present(
;  [in]  const RECT *pSourceRect,
;  [in]  const RECT *pDestRect,
;  [in]  HWND hDestWindowOverride,
;  [in]  const RGNDATA *pDirtyRegion

stdmethod(IDirect3DDevice9.Present, pp_Device,0,0,0,0)
  DxError("Present")

;==========






    mov eax, TRUE
    ret

ENDF


;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------



ALIGN 16

StopDirectX FRAME

;==========

  cmp D[pp_DIRECT3D9], NULL                            ;test if D3Draw object ptr = 0 (a null ptr)
  je >> StopDxOut                                      ;if = 0 then ptr is already released so exit

;==========

  SafeRelease(IDirect3DDevice9, pp_Final)
  SafeRelease(IDirect3DDevice9, pp_Vic)
  SafeRelease(IDirect3DDevice9, pp_Back)
  SafeRelease(IDirect3DDevice9, pp_Device)
  SafeRelease(IDirect3D9, pp_DIRECT3D9)          ;if !=0 then call Release, zero the ptr

StopDxOut:
  mov eax, TRUE                         ;return true
  ret

ENDF







;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------------



/*
;---------------------------------------------
;CREATE "GDI" SURFACE
;	This is the 976x608 GDI surface.
;	Data from here blitted to VIC FINAL surface.
;---------------------------------------------
;HRESULT CreateOffscreenPlainSurface(
;  [in]           UINT Width,
;  [in]           UINT Height,
;  [in]           D3DFORMAT Format,
;  [in]           D3DPOOL Pool,
;  [out, retval]  IDirect3DSurface9 **ppSurface,
;  [in]           HANDLE *pSharedHandle

	mov D[pp_Gdi], 0                  	;zero the interface ptr

  stdmethod(IDirect3DDevice9.CreateOffscreenPlainSurface, pp_Device,  \
	GDIWIDTH,	\
	GDIHEIGHT,	\
	D3DFMT_X8R8G8B8, 	\
	D3DPOOL_DEFAULT,	\
	addr pp_Gdi,		\
	NULL)

  DxError("Create Gdi Surface")
*/
;==========


;---------------------------------------------
;CREATE "OVERLAY" SURFACE
;	This is the 976x608 OVERLAY surface.
;	Data is blitted from here to FINAL surface.
;---------------------------------------------
;HRESULT CreateOffscreenPlainSurface(
;  [in]           UINT Width,
;  [in]           UINT Height,
;  [in]           D3DFORMAT Format,
;  [in]           D3DPOOL Pool,
;  [out, retval]  IDirect3DSurface9 **ppSurface,
;  [in]           HANDLE *pSharedHandle
/*
	mov D[pp_Overlay], 0                  	;zero the interface ptr

  stdmethod(IDirect3DDevice9.CreateOffscreenPlainSurface, pp_Device,  \
	OVERLAYWIDTH,	\
	OVERLAYHEIGHT,	\
	D3DFMT_A8R8G8B8, 	\
	D3DPOOL_DEFAULT,	\
	addr pp_Overlay,		\
	NULL)

  DxError("Create Overlay Surface")

;==========

*/



