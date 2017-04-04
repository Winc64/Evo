
;0x382878
;0x352879

CODE SECTION
align 16

Winc64_boot:


;----------------------------
;FILL VIDEO RAM WITH CBM BLUE
;----------------------------

mov edx, addr MainMemory+VIDEOMEM

mov ecx, (640*400/2)-1

mov ax, 0x1caf
shl eax, 16
mov ax, 0x1caf

:
mov [edx+ecx*4], eax
dec ecx
jns <


;--------------------
;INIT CURSOR LOCATION
;--------------------
mov W[CursorX], 0
mov W[CursorY], 0

mov W[TextColor], 0xffff ;0x3997







ret

;--------------

DATA SECTION
align 4

CursorX 	dw ?
CursorY		dw ?
TextColor dd ?

tbl_5120	;Y-cell
dd 0*5120,1*5120,2*5120,3*5120,4*5120,5*5120,6*5120,7*5120,8*5120,9*5120
dd 10*5120,11*5120,12*5120,13*5120,14*5120,15*5120,16*5120,17*5120,18*5120,19*5120
dd 20*5120,21*5120,22*5120,23*5120,24*5120,25*5120,26*5120,27*5120,28*5120,29*5120
dd 30*5120,31*5120,32*5120,33*5120,34*5120,35*5120,36*5120,37*5120,38*5120,39*5120
dd 40*5120,41*5120,42*5120,43*5120,44*5120,45*5120,46*5120,47*5120,48*5120,49*5120

tbl_8			;X-cell
dd 0*8,1*8,2*8,3*8,4*8,5*8,6*8,7*8,8*8,9*8
dd 10*8,11*8,12*8,13*8,14*8,15*8,16*8,17*8,18*8,19*8
dd 20*8,21*8,22*8,23*8,24*8,25*8,26*8,27*8,28*8,29*8
dd 30*8,31*8,32*8,33*8,34*8,35*8,36*8,37*8,38*8,39*8
dd 40*8,41*8,42*8,43*8,44*8,45*8,46*8,47*8,48*8,49*8
dd 50*8,51*8,52*8,53*8,54*8,55*8,56*8,57*8,58*8,59*8
dd 60*8,61*8,62*8,63*8,64*8,65*8,66*8,67*8,68*8,69*8
dd 70*8,71*8,72*8,73*8,74*8,75*8,76*8,77*8,78*8,79*8



;--------------

CODE SECTION
align 16

Print FRAME
uses esi, edi
LOCAL char

mov [char], al

;DEST: set up screen cell location: =(Y*5120) + (X*8)
mov edi, addr MainMemory+VIDEOMEM
mov ecx, [CursorY]
add edi, [tbl_5120+ecx*4]
mov edx, [CursorX]
add edi, [tbl_8+edx*4]

;SRC: set up character data location: =(char# * 8)
mov esi, addr cbm_8025
movzx eax, B[char]
shl eax, 3
add esi, eax


;print the character

mov bx, [TextColor]
mov dl, 8												;row counter

getchar:
mov al, [esi]

mov ecx, 7											;column counter
shift:
rcr al, 1
jnc > nextbit

mov [edi+ecx*2], bx




nextbit:
dec ecx
jns < shift

nextbyte:
inc esi
add edi, 640

dec dl
jnz < getchar

ret
ENDF
