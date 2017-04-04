#IFNDEF MACROS_H
#DEFINE MACROS_H

#IFDEF X86
	#DEFINE USERAX
#ENDIF

#IFDEF WIN64
	#DEFINE USERAX
#ENDIF

#IFDEF X64
	#DEFINE USERAX
#ENDIF

/*
Note about macros defined in the PSDK
If the macro is compile time it must be used
inline and it must be the last parameter
in the statement. If the macro is needed in
an Invoke statement and is not the last
parameter you can use the following alternate
syntax, it's not optimal but it works:

invoke function, param1, param2, macro, param3, param4

push param4, param3
push macro(1,2,3,4)
invoke function, param1, param2

For runtime macros, they cannot be used
inline. If there is no parameter supplied as
a return buffer then the return is always in
the EAX/RAX register. Every effort is made to preserve
registers however it must be assumed that the
Windows ABI register preservation rules apply.
*/

// Just a fun one from the board
// Returns tick count in EDX:EAX
#define FastGetTickCount int 0x2a

// From WinGDI
GetKValue(%cmyk) MACRO // Compile time
      (%cmyk & 0xFF)
ENDM

GetYValue(%cmyk) MACRO // Compile time
    ((%cmyk >> 8) & 0xFF)
ENDM

GetMValue(%cmyk) MACRO // Compile time
   ((%cmyk >>16) & 0xFF)
ENDM

GetCValue(%cmyk) MACRO // Compile time
   ((%cmyk>>24) & 0xFF)
ENDM

CMYK(%c,%m,%y,%k) MACRO // Compile time
	((%k) | (%y<<8) | (%m<<16)) | (%c<<24))
ENDM

// From WinNT.h

MAKELANGID(%p,%s) MACRO // Compile time
	((%s << 10) | (%p))
ENDM

PRIMARYLANGID(%lgid) MACRO // Compile time
	(%lgid & 0x3ff)
ENDM

SUBLANGID(%lgid) MACRO // Compile time
	(%lgid >> 10)
ENDM

MAKELCID(%lgid,%srtid) MACRO // Compile time
	(%srtid << 16) | (%lgid))
ENDM

MAKESORTLCID(%lgid,%srtid,%ver) MACRO // Compile time
	((%srtid << 16) | (%lgid)) | (%ver << 20))
ENDM

SORTIDFROMLCID(%lcid) MACRO // Compile time
	((%lcid >> 16) & 0xf))
ENDM

SORTVERSIONFROMLCID(%lcid) MACRO // Compile time
	((%lcid >> 20) & 0xf))
ENDM

MANDATORY_LEVEL_TO_MANDATORY_RID(%IL) MACRO // Compile time
	(%IL << 12) // * 0x01000
ENDM

#IFNDEF MAKE_HRESULT
MAKE_HRESULT(%sev,%fac,%code) MACRO // Compile time
	((%sev<<31) | (%fac<<16) | %code )
ENDM
#ENDIF

#IFNDEF MAKE_DSHRESULT
// For DirectSound HRESULT codes
MAKE_DSHRESULT(%code) MACRO // Compile time
	(0x88780000 | %code )
ENDM
#ENDIF

// From Winuser.h : these macros cannot be used inline

#IFNDEF WIN64
POINTTOPOINTS(%point) MACRO // Run time
	// Note EAX is modified by this macro
	push [%point]
	and D[esp],0xFFFF
	mov eax,[%point+4]
	shl eax,16
	or [esp],eax
	pop eax
ENDM

POINTSTOPOINT(%point,%pts) MACRO // Run time
	push %pts
	and D[esp],0xFFFF
	pop [%point]
	push %pts
	shr D[esp],16
	pop [%point+4]
ENDM
#ENDIF

// Replaces the xchg instruction which is very slow
// requires 2 registers or a register and memory
fast_xchg(%1,%2) MACRO // Run time
	xor %1,%2
	xor %2,%1
	xor %1,%2
ENDM

// From winioctl.h

CTL_CODE(%DeviceType, %Function, %Method, %Access ) MACRO // Compile time
	((%DeviceType << 16) | (%Access << 14) | (%Function << 2) | (%Method))
ENDM


DEVICE_TYPE_FROM_CTL_CODE(%ctrlCode) MACRO // Compile time
    ((%ctrlCode & 0xffff0000) >> 16)
ENDM

METHOD_FROM_CTL_CODE(%ctrlCode) MACRO // Compile time
	(%ctrlCode & 3)
ENDM

#IFNDEF WIN64
	#IFNDEF pushq
	// By Donkey
	pushq(%1) MACRO // Run time
	    PUSH [%1+4]
	    PUSH [%1]
	ENDM
	#ENDIF
#ENDIF

BREAKPOINT macro
	#IFDEF DBG_BREAKPOINTS
		INT 3
	#ENDIF
endm

#IFNDEF WIN64
	#IFNDEF ClearLocals // Run time
	// From a MASM macro by jj2007
	ClearLocals MACRO // Run time
		mov edx,edi
		// Get the size of the stack
		mov ecx,ebp
		sub ecx,esp

		// Base of local variables
		lea edi,[ebp]
		sub edi,ecx
		shr ecx,2

		// Fill with zeros
		mov eax,0
		rep stosd
		mov edi,edx
	ENDM
	#ENDIF
#ENDIF

#IFNDEF WIN64
	#IFNDEF pushguid
		pushguid(%1) MACRO // Run time
			push [%1+12]
			push [%1+8]
			push [%1+4]
			push [%1]
		ENDM
	#ENDIF
#ELSE
	#IFNDEF pushguid
		pushguid(%1) MACRO // Run time
			push [%1+8]
			push [%1]
		ENDM
	#ENDIF
#ENDIF

#IFNDEF CoInvoke
	#IF !X64
		// By Donkey
		CoInvoke(%pInterface,%Method,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
			#IF ARGCOUNT = 12
				push %9
			#ENDIF
			#IF ARGCOUNT > 10
				push %8
			#ENDIF
			#IF ARGCOUNT > 9
				push %7
			#ENDIF
			#IF ARGCOUNT > 8
				push %6
			#ENDIF
			#IF ARGCOUNT > 7
				push %5
			#ENDIF
			#IF ARGCOUNT > 6
				push %4
			#ENDIF
			#IF ARGCOUNT > 5
				push %3
			#ENDIF
			#IF ARGCOUNT > 4
				push %2
			#ENDIF
			#IF ARGCOUNT > 3
				push %1
			#ENDIF
			#IF ARGCOUNT > 2
				push %0
			#ENDIF
			push [%pInterface]
			mov eax, [%pInterface]
			mov eax,[eax]
			add eax, %Method
			call [eax]
		ENDM
	#ELSE
		// By Donkey
		// http://en.wikipedia.org/wiki/X86_calling_conventions#Microsoft_x64_calling_convention
		// There has been a further change to the function to correct the stack if needed
		CoInvoke(%pInterface,%Method,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
			#IF ARGCOUNT = 12
				push %9
				push %8
				push %7
				push %6
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT = 11
				push %8
				push %7
				push %6
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT  = 10
				push %7
				push %6
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT = 9
				push %6
				push %5
				push %4
				push %3 
			#ELSEIF ARGCOUNT = 8
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT = 7
				push %4
				push %3
			#ELSEIF ARGCOUNT = 6
				push %3
			#ENDIF

			#IF ARGCOUNT > 4
				push %2
				pop r9
				// mov r9,%2
			#ENDIF 
			#IF ARGCOUNT > 3
				push %1
				pop r8
				// mov r8,%1
			#ENDIF 
			#IF ARGCOUNT > 2
				push %0
				pop rdx
				// mov rdx,%0
			#ENDIF
			// in COM pInterface (*this) must always be defined
			sub RSP,32 // Create the shadow space
			mov rcx,[%pInterface]
			mov rax,[rcx]
			add rax, %Method
			call [rax]
			// Correct the stack
			#IF ARGCOUNT < 6
				add RSP,32
			#ELSEIF ARGCOUNT = 6
				add RSP,32 + 8
			#ELSEIF ARGCOUNT  = 7
				add RSP,32 + 16
			#ELSEIF ARGCOUNT = 8
				add RSP,32 + 24
			#ELSEIF ARGCOUNT = 9
				add RSP,32 + 32
			#ELSEIF ARGCOUNT = 10
				add RSP,32 + 40
			#ELSEIF ARGCOUNT = 11
				add RSP,32 + 48
			#ELSEIF ARGCOUNT = 12
				add RSP,32 + 56
			#ENDIF
		ENDM
	#ENDIF // WIN64
#ENDIF // CoInvoke defined

#IFNDEF cominvoke
	#IF !X64
		// By Donkey
		cominvoke(%pInterface,%Method,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
			#IF ARGCOUNT = 12
				push %9
			#ENDIF
			#IF ARGCOUNT > 10
				push %8
			#ENDIF
			#IF ARGCOUNT > 9
				push %7
			#ENDIF
			#IF ARGCOUNT > 8
				push %6
			#ENDIF
			#IF ARGCOUNT > 7
				push %5
			#ENDIF
			#IF ARGCOUNT > 6
				push %4
			#ENDIF
			#IF ARGCOUNT > 5
				push %3
			#ENDIF
			#IF ARGCOUNT > 4
				push %2
			#ENDIF
			#IF ARGCOUNT > 3
				push %1
			#ENDIF
			#IF ARGCOUNT > 2
				push %0
			#ENDIF
			push [%pInterface]
			mov eax, [%pInterface]
			mov eax,[eax]
			add eax, %Method
			call [eax]
		ENDM
	#ELSE
		// By Donkey
		// http://en.wikipedia.org/wiki/X86_calling_conventions#Microsoft_x64_calling_convention
		// There has been a further change to the function to correct the stack if needed
		cominvoke(%pInterface,%Method,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
			#IF ARGCOUNT = 12
				push %9
				push %8
				push %7
				push %6
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT = 11
				push %8
				push %7
				push %6
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT  = 10
				push %7
				push %6
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT = 9
				push %6
				push %5
				push %4
				push %3 
			#ELSEIF ARGCOUNT = 8
				push %5
				push %4
				push %3
			#ELSEIF ARGCOUNT = 7
				push %4
				push %3
			#ELSEIF ARGCOUNT = 6
				push %3
			#ENDIF

			#IF ARGCOUNT > 4
				push %2
				pop r9
				// mov r9,%2
			#ENDIF 
			#IF ARGCOUNT > 3
				push %1
				pop r8
				// mov r8,%1
			#ENDIF 
			#IF ARGCOUNT > 2
				push %0
				pop rdx
				// mov rdx,%0
			#ENDIF
			// in COM pInterface (*this) must always be defined
			sub RSP,32 // Create the shadow space
			mov rcx,[%pInterface]
			mov rax,[rcx]
			add rax, %Method
			call [rax]
			// Correct the stack
			#IF ARGCOUNT < 6
				add RSP,32
			#ELSEIF ARGCOUNT = 6
				add RSP,32 + 8
			#ELSEIF ARGCOUNT  = 7
				add RSP,32 + 16
			#ELSEIF ARGCOUNT = 8
				add RSP,32 + 24
			#ELSEIF ARGCOUNT = 9
				add RSP,32 + 32
			#ELSEIF ARGCOUNT = 10
				add RSP,32 + 40
			#ELSEIF ARGCOUNT = 11
				add RSP,32 + 48
			#ELSEIF ARGCOUNT = 12
				add RSP,32 + 56
			#ENDIF
		ENDM
	#ENDIF // WIN64
#ENDIF // cominvoke defined

;-------------------------------------------------------------------------------

#IFNDEF rgb2bgrR          // using a pre-loaded register
  rgb2bgrR(regx86) MACRO  // XRGB is loaded in a register, such as eax, etc.
    bswap regx86
    ror regx86, 8
  ENDM
#ENDIF

#IFNDEF rgb2bgrC          // using a constant (an immediate) instead
  rgb2bgrC(value) MACRO   // XRGB is loaded as a numerical value, such as 0xFFB612, etc.
    mov eax, value
    bswap eax
    ror eax, 8            // comes out as 0x12B6FF
  ENDM
#ENDIF

;-------------------------------------------------------------------------------

SafeRelease(%interface, %pptr) MACRO
  cmp D[%pptr], NULL
  je >

	push [%pptr]                  ;push the interface ptr contents
	mov eax, [%pptr]              ;copy interface contents to register
	mov eax,[eax]                       ;get the ptr stored at that address
	add eax, IUnknown.Release                    ;add the distance to method in COM vtable
	call [eax]                          ;call function at effective address

  mov D[%pptr], NULL
:
ENDM

;-------------------------------------------------------------------------------

StdError(%lpText) MACRO                 ;Windows error if retval = 0
  test eax, eax
    jnz >

  invoke MessageBox,[WindowHandle],addr %lpText,"Error",MB_OK
    xor eax, eax
    ret

align 16
:

ENDM

;-------------------------------------------------------------------------------

DxError(%lpText) MACRO                 ;DirectX okay if retval = 0
  test eax, eax
    jz >

  invoke MessageBox,[WindowHandle],addr %lpText,"Error",MB_OK
  call StopDirectX
    xor eax, eax
    ret

align 16
:

ENDM

;-------------------------------------------------------------------------------

#IFNDEF stdmethod
#IF !X64
// By Bert Novilla, 10/21/2014, adapted from CoInvoke by Donkey
// --------------------------
// Changes to original macro:
// --------------------------
// macro name changed from "CoInvoke" to "stdmethod" to ease confusion
// macro parameter order modified so that method is now before interface
// it seems more visually "intuitive" this way --> Method Name, Interface ptr, params...

//    old: CoInvoke(pp_ID3DDevice9, IDirect3DDevice9.Clear,param1,param2, etc.)

// ------------------------------------------
// Simplified example using a Dx9 method call
// ------------------------------------------
//  new syntax:
//
//  pp_Device  dd ?            ;the Device9 COM interface pptr
//
//    stdmethod(IDirect3DDevice9.Clear, pp_Device,        \
//      [Count],                                          \   ;[in]  DWORD Count
//      addr pRects,                                      \   ;[in]  const D3DRECT *pRects
//      [Flags],                                          \   ;[in]  DWORD Flags
//      [Color],                                          \   ;[in]  D3DCOLOR Color
//      0,                                                \   ;[in]  float Z
//      0)                                                    ;[in]  DWORD Stencil

;-----

stdmethod(%Method,%pInterface,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
#IF ARGCOUNT = 12
	push %9
#ENDIF
#IF ARGCOUNT > 10
	push %8
#ENDIF
#IF ARGCOUNT > 9
	push %7
#ENDIF
#IF ARGCOUNT > 8
	push %6
#ENDIF
#IF ARGCOUNT > 7
	push %5
#ENDIF
#IF ARGCOUNT > 6
	push %4
#ENDIF
#IF ARGCOUNT > 5
	push %3
#ENDIF
#IF ARGCOUNT > 4
	push %2
#ENDIF
#IF ARGCOUNT > 3
	push %1
#ENDIF
#IF ARGCOUNT > 2
	push %0
#ENDIF
	push [%pInterface]                  ;push the interface ptr contents
	mov eax, [%pInterface]              ;copy interface contents to register
	mov eax,[eax]                       ;get the ptr stored at that address
	add eax, %Method                    ;add the distance to method in COM vtable
	call [eax]                          ;call function at effective address
ENDM
	
#ELSE

// By Donkey, modified by Bert Novilla 10/21/2014
// http://en.wikipedia.org/wiki/X86_calling_conventions#Microsoft_x64_calling_convention
// There has been a further change to the function to correct the stack if needed

stdmethod(%Method,%pInterface,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
	#IF ARGCOUNT = 12
		push %9
		push %8
		push %7
		push %6
		push %5
		push %4
		push %3
	#ELSEIF ARGCOUNT = 11
		push %8
		push %7
		push %6
		push %5
		push %4
		push %3
	#ELSEIF ARGCOUNT  = 10
		push %7
		push %6
		push %5
		push %4
		push %3
	#ELSEIF ARGCOUNT = 9
		push %6
		push %5
		push %4
		push %3 
	#ELSEIF ARGCOUNT = 8
		push %5
		push %4
		push %3
	#ELSEIF ARGCOUNT = 7
		push %4
		push %3
	#ELSEIF ARGCOUNT = 6
		push %3
	#ENDIF
		#IF ARGCOUNT > 4
		push %2
		pop r9
		// mov r9,%2
	#ENDIF 
	#IF ARGCOUNT > 3
		push %1
		pop r8
		// mov r8,%1
	#ENDIF 
	#IF ARGCOUNT > 2
		push %0
		pop rdx
		// mov rdx,%0
	#ENDIF
// in COM pInterface (*this) must always be defined
	sub RSP,32 // Create the shadow space
	mov rcx,[%pInterface]
	mov rax,[rcx]
	add rax, %Method
	call [rax]
// Correct the stack
	#IF ARGCOUNT < 6
		add RSP,32
	#ELSEIF ARGCOUNT = 6
		add RSP,32 + 8
	#ELSEIF ARGCOUNT  = 7
		add RSP,32 + 16
	#ELSEIF ARGCOUNT = 8
		add RSP,32 + 24
	#ELSEIF ARGCOUNT = 9
		add RSP,32 + 32
	#ELSEIF ARGCOUNT = 10
		add RSP,32 + 40
	#ELSEIF ARGCOUNT = 11
		add RSP,32 + 48
	#ELSEIF ARGCOUNT = 12
		add RSP,32 + 56
	#ENDIF
	ENDM
	#ENDIF // WIN64
#ENDIF // stdmethod defined

;-------------------------------------------------------------------------------

#IFNDEF CInvoke
	#IFNDEF WIN64
		// By Donkey
		CInvoke(%Function,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
			#IF ARGCOUNT = 11
				push %9
			#ENDIF
			#IF ARGCOUNT > 9
				push %8
			#ENDIF
			#IF ARGCOUNT > 8
				push %7
			#ENDIF
			#IF ARGCOUNT > 7
				push %6
			#ENDIF
			#IF ARGCOUNT > 6
				push %5
			#ENDIF
			#IF ARGCOUNT > 5
				push %4
			#ENDIF
			#IF ARGCOUNT > 4
				push %3
			#ENDIF
			#IF ARGCOUNT > 3
				push %2
			#ENDIF
			#IF ARGCOUNT > 2
				push %1
			#ENDIF
			#IF ARGCOUNT > 1
				push %0
			#ENDIF
			call %Function
			#IF ARGCOUNT = 11
				add esp,40
			#ENDIF
			#IF ARGCOUNT = 10
				add esp,36
			#ENDIF
			#IF ARGCOUNT = 9
				add esp,32
			#ENDIF
			#IF ARGCOUNT = 8
				add esp,28
			#ENDIF
			#IF ARGCOUNT = 7
				add esp,24
			#ENDIF
			#IF ARGCOUNT = 6
				add esp,20
			#ENDIF
			#IF ARGCOUNT = 5
				add esp,16
			#ENDIF
			#IF ARGCOUNT = 4
				add esp,12
			#ENDIF
			#IF ARGCOUNT = 3
				add esp,8
			#ENDIF
			#IF ARGCOUNT = 2
				add esp,4
			#ENDIF
		ENDM
	#ELSE
		// By Donkey - x86-64 has no cdecl calls, just convert to a normal invoke (FASTCALL)
		CInvoke(%Function,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9) MACRO // Run time
			#IF ARGCOUNT = 11
				invoke %Function,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9
			#ENDIF
			#IF ARGCOUNT = 10
				invoke %Function,%0,%1,%2,%3,%4,%5,%6,%7,%8
			#ENDIF
			#IF ARGCOUNT = 9
				invoke %Function,%0,%1,%2,%3,%4,%5,%6,%7
			#ENDIF
			#IF ARGCOUNT = 8
				invoke %Function,%0,%1,%2,%3,%4,%5,%6
			#ENDIF
			#IF ARGCOUNT = 7
				invoke %Function,%0,%1,%2,%3,%4,%5
			#ENDIF
			#IF ARGCOUNT = 6
				invoke %Function,%0,%1,%2,%3,%4
			#ENDIF
			#IF ARGCOUNT = 5
				invoke %Function,%0,%1,%2,%3
			#ENDIF
			#IF ARGCOUNT  = 4
				invoke %Function,%0,%1,%2
			#ENDIF
			#IF ARGCOUNT = 3
				invoke %Function,%0,%1
			#ENDIF
			#IF ARGCOUNT = 2
				invoke %Function,%0
			#ENDIF
			#IF ARGCOUNT = 1
				invoke %Function
			#ENDIF
		ENDM
	#ENDIF // WIN64
#ENDIF // CInvoke defined

#IFNDEF msm
	// By Synfire
	msm(%dst,%src) MACRO // Run time
		push %src
		pop %dst
	ENDM
#ENDIF

#IFNDEF mrm
	// By Synfire
	mrm(%dst,%src,%reg) MACRO // Run time
		mov %reg, %src
		mov %dst, %reg
	ENDM
#ENDIF

#IFNDEF rgvarg
	// By Donkey
	#IFNDEF WIN64
		rgvarg(%pdisp,%narg) MACRO // Run time
			mov eax,%pdisp
			mov eax,[eax]
			add eax,16*%narg
		ENDM
	#ELSE
		rgvarg(%pdisp,%narg) MACRO // Run time
			mov rax,%pdisp
			mov rax,[rax]
			add rax,16*%narg
		ENDM
	#ENDIF
#ENDIF

#IFNDEF MEMALLOC
// By Synfire
MEMALLOC(%size) MACRO // Run time
	#IFNDEF %Process_Heap
		DATA SECTION
			%Process_Heap HANDLE ?
		CODE SECTION
			INVOKE Kernel32:GetProcessHeap
			#IFDEF USERAX
				mov [%Process_Heap], RAX
			#ELSE
				mov [%Process_Heap], EAX
			#ENDIF
	#ENDIF
	INVOKE Kernel32:HeapAlloc, [%Process_Heap], 00000008h, %size
ENDM
#ENDIF

#IFNDEF MEMFREE
// By Synfire
MEMFREE(%pmem) MACRO // Run time
	INVOKE Kernel32:HeapFree, [%Process_Heap], 0, %pmem
ENDM
#ENDIF

AdjustStack(%1) MACRO // Run time
	// By Donkey
	// When translating 32 bit to 64 bit all C calls are changed to FASTCALL
	// in order to avoid alot of search and remove for stack adjustments after
	// a C call you can either use CInvoke or this macro
	#IFNDEF WIN64
		add esp,%1
	#ENDIF
ENDM

// By E^cube

%MOV(%DESTN,%SOURCE) MACRO
#IFNDEF WIN64
mov D[%DESTN],%SOURCE
#ELSE
mov Q[%DESTN],%SOURCE
#ENDIF
ENDM

%CMP(%DESTN,%SOURCE) MACRO
#IFNDEF WIN64
cmp D[%DESTN],%SOURCE
#ELSE
cmp Q[%DESTN],%SOURCE
#ENDIF
ENDM

%ADD(%DESTN,%SOURCE) MACRO
#IFNDEF WIN64
ADD D[%DESTN],%SOURCE
#ELSE
ADD Q[%DESTN],%SOURCE
#ENDIF
ENDM

%SUB(%DESTN,%SOURCE) MACRO
#IFNDEF WIN64
SUB D[%DESTN],%SOURCE
#ELSE
SUB Q[%DESTN],%SOURCE
#ENDIF
ENDM

%INC(%DESTN) MACRO
#IFNDEF WIN64
INC D[%DESTN]
#ELSE
INC Q[%DESTN]
#ENDIF
ENDM

%DEC(%DESTN) MACRO
#IFNDEF WIN64
DEC D[%DESTN]
#ELSE
DEC Q[%DESTN]
#ENDIF
ENDM

#IF X64
RGSQREGRAX = 0x48,0x8b,0x04
RGSQREGRBX = 0x48,0x8b,0x1C
RGSQREGRCX = 0x48,0x8b,0x0C
RGSQREGRDX = 0x48,0x8b,0x14
RGSQREGRDI = 0x48,0x8b,0x3C
RGSQREGRSI = 0x48,0x8b,0x34
RGSQREGRSP = 0x48,0x8b,0x24
RGSQREGRBP = 0x48,0x8b,0x2C
RGSQREGR8 = 0x4C,0x8b,0x04
RGSQREGR9 = 0x4C,0x8b,0x0C
RGSQREGR10 = 0x4C,0x8b,0x14
RGSQREGR11 = 0x4C,0x8b,0x1C
RGSQREGR12 = 0x4C,0x8b,0x24
RGSQREGR13 = 0x4C,0x8b,0x2C
RGSQREGR14 = 0x4C,0x8b,0x34
RGSQREGR15 = 0x4C,0x8b,0x3C

readgsqword(%1,%2) macro
#IFDEF RGSQREG%1
DB 0x65,RGSQREG%1,0x25,%2,0x00,0x00,0x00
#ELSE
GoAsm_echo "readgsqword uses capitalized 64 bit register names only"
GoAsm_exit
#ENDIF
endm

WGSQREGRAX = 0x48,0x89,0x04
WGSQREGRBX = 0x48,0x89,0x1C
WGSQREGRCX = 0x48,0x89,0x0C
WGSQREGRDX = 0x48,0x89,0x14
WGSQREGRDI = 0x48,0x89,0x3C
WGSQREGRSI = 0x48,0x89,0x34
WGSQREGRSP = 0x48,0x89,0x24
WGSQREGRBP = 0x48,0x89,0x2C
WGSQREGR8 = 0x4C,0x89,0x04
WGSQREGR9 = 0x4C,0x89,0x0C
WGSQREGR10 = 0x4C,0x89,0x14
WGSQREGR11 = 0x4C,0x89,0x1C
WGSQREGR12 = 0x4C,0x89,0x24
WGSQREGR13 = 0x4C,0x89,0x2C
WGSQREGR14 = 0x4C,0x89,0x34
WGSQREGR15 = 0x4C,0x89,0x3C

writegsqword(%1,%2) macro
#IFDEF WGSQREG%2
DB 0x65,WGSQREG%2,0x25,%1,0x00,0x00,0x00
#ELSE
GoAsm_echo "writegsqword uses capitalized 64 bit register names only"
GoAsm_exit
#ENDIF
endm
#ENDIF

#IFNDEF LOWORD
// For immediates only - runtime
LOWORD(%a) MACRO
	%a&0xFFFF
endm

HIWORD(%a) MACRO
	(%a>>16)&0xFFFF
endm
#ENDIF

#ENDIF