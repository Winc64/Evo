



;"SendVic.asm"



SendVic	FRAME
uses esi, edi

LOCAL SrcPitch

;--


;-----------------------
;LOCK VIC SURFACE (DEST)
;-----------------------
mov D[DstRect.left], SPRITEWIDTH
mov D[DstRect.right], SCREENWIDTH + SPRITEWIDTH

mov D[DstRect.top], SPRITEHEIGHT
mov D[DstRect.bottom], SCREENHEIGHT + SPRITEHEIGHT

stdmethod(IDirect3DSurface9.LockRect, pp_Vic, addr lockedRect, addr DstRect, NULL)
	DxError("LockRect: Vic surface")

;==========

;----------------------------------------------
;CONVERT & COPY VIC MEMORY (RAM) TO VIC SURFACE
;----------------------------------------------

mov al, 0x41
call Print

;src, dst
mov esi, addr MainMemory+VIDEOMEM									;source
mov edi, [lockedRect.pBits]												;dest

mov eax, SCREENWIDTH
shl eax, 1
mov [SrcPitch], eax

;-----

mov edx, SCREENHEIGHT															;row counter

R1:
mov ecx, SCREENWIDTH-1														;column counter

C1:
  movzx eax, W[esi+ecx*2]                         ;get source word, which becomes an index (16 bpp)
  mov eax, [tbl_RGB_16to32+eax*4]									;get conversion from table
  mov [edi+ecx*4], eax                            ;put dest dword (32 bpp)
  dec ecx                                         ;decrement column counter
  jns < C1                                        ;branch to next column until column counter = -1

  add esi, [SrcPitch]                             ;advance to next source row
  add edi, [lockedRect.Pitch]                     ;advance to next dest row
  
  dec edx                                         ;dec row counter
  jnz < R1                                        ;branch to next row until row counter = 0
  
stdmethod(IDirect3DSurface9.UnlockRect, pp_Vic)		;unlock surface

;==========




;---------------------------------
;COPY VIC SURFACE TO FINAL SURFACE
;---------------------------------

/*
HRESULT UpdateSurface(
  [in]  IDirect3DSurface9 *pSourceSurface,
  [in]  const RECT *pSourceRect,
  [in]  IDirect3DSurface9 *pDestinationSurface,
  [in]  const POINT *pDestinationPoint
*/

mov D[SrcRect.left], SPRITEWIDTH
mov D[SrcRect.right], SCREENWIDTH + SPRITEWIDTH
mov D[SrcRect.top], SPRITEHEIGHT
mov D[SrcRect.bottom], SCREENHEIGHT + SPRITEHEIGHT

mov D[lpPoint.x], SPRITEWIDTH
mov D[lpPoint.y], SPRITEHEIGHT

stdmethod(IDirect3DDevice9.UpdateSurface, pp_Device, [pp_Vic], addr SrcRect, [pp_Final], addr lpPoint)
  DxError("Unable to update VIC surface")


mov eax, TRUE
ret

ENDF

