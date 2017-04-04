;==========================================================
; Evolution: DirectX 9
; Winc64 Operating System
; Version 2015.1
; Copyright 1990-2015 Bert Novilla (satpro)
;==========================================================

; Filename:  
; Description: 

;==========================================================



CONST SECTION

;-------------------------------------------------------------------------------------------------------------

;------------------------
;MEMORY ADDRESS CONSTANTS
;------------------------
VIDEOMEM = 0xf00000
ROMMEM = 0xf80000











;-------------------------------------------------------------------------------------------------------------




;32x32 sprites use 16-bit ptr ($0800 bytes data each)

;------------------
;SURFACES (SCREENS)
;------------------
#define SCREENWIDTH			640     									;# of visible pixels horizontally
#define SCREENHEIGHT		400 											;# of visible pixels vertically

#define SPRITEWIDTH     32      									;# of pixels horizontally
#define SPRITEHEIGHT    32      									;# of pixels vertically

#define VICWIDTH				SCREENWIDTH  + SPRITEWIDTH + SPRITEWIDTH		;visible pixels + borders
#define VICHEIGHT				SCREENHEIGHT + SPRITEHEIGHT + SPRITEHEIGHT	;visible pixels + borders

#define FINALWIDTH    	VICWIDTH									;visible pixels + borders horizontally
#define FINALHEIGHT   	VICHEIGHT									;visible pixels + borders vertically

;-------
;SPRITES
;-------
#define MIN_SPRITE_X    0                         		;min sprite X-coordinate
#define MIN_SPRITE_Y    0                         		;min sprite Y-coordinate
#define MAX_SPRITE_X    SCREENWIDTH + SPRITEWIDTH   	;max sprite X-coordinate + 1
#define MAX_SPRITE_Y    SCREENHEIGHT + SPRITEHEIGHT 	;max sprite Y-coordinate + 1

#define MAX_SPRITES       16                      ;# of sprites (32)


;-------------------------------------------------------------------------------------------------------------

;-------------
;BIT POSITIONS
;-------------
#define bit15                   0x8000
#define bit14                   0x4000
#define bit13                   0x2000
#define bit12                   0x1000
#define bit11                   0x0800
#define bit10                   0x0400
#define bit9                    0x0200
#define bit8                    0x0100
#define bit7                    0x80
#define bit6                    0x40
#define bit5                    0x20
#define bit4                    0x10
#define bit3                    0x8
#define bit2                    0x4
#define bit1                    0x2
#define bit0                    0x1

;==========
;CPU
;==========
#define CYC_PER_SEC             12000000                    ;cycles per second (evenly divisible by CPU2IO_RATIO)
#define FRM_PER_SEC             30                          ;frames per second
#define CYC_PER_FRM             CYC_PER_SEC/FRM_PER_SEC     ;(400,000) cycles per frame = cps / fps
#define CPU2IO_RATIO            12                          ;# cpu cycles per i/o cycle
#define CPU_RESET_ADDR          0x0000                      ;cpu addr @ reset
#define CPU_RESET_BANK          0xf8                        ;cpu bank @ reset
#define DEF_SP                  0xfffe                      ;default stack pointer
#define DEF_DP                  0xef00                      ;default Direct Page
#define DEF_SR                  0                           ;default Status Register
#define DEF_REGAXY              0                           ;default CPU Registers

;==========

;---------------
;STATUS REGISTER
;---------------
#define sr_CARRY                bit0    ;Carry (0 = clear, 1 = set)
#define sr_ZERO                 bit1    ;Zero (0 = clear, 1 = set)
#define sr_MODE_XY              bit23	;XY Register (00 = 32-bit, 01 = 16-bit, 10 = 8-bit, 11 = unused)
#define sr_MODE_AM              bit45	;AM Register (00 = 32-bit, 01 = 16-bit, 10 = 8-bit, 11 = unused)
#define sr_OVERFLOW             bit6    ;Overflow (0 = clear, 1 = set)
#define sr_SIGN                 bit7    ;Sign (0 = clear, 1 = set)

;==========

#define LOW                     0
#define HIGH                    1

#define CLEAR                   0
#define SET                     1

#define OFF                     0
#define ON                      1

;-------------------------------------------------------------------------------------------------------------






;-------------
;COLOR PALETTE
;-------------

;----------
;CBM COLORS
;----------
#define cbmBlack         0
#define cbmWhite         1
#define cbmRed           2
#define cbmCyan          3
#define cbmPurple        4
#define cbmGreen         5
#define cbmBlue          6
#define cbmYellow        7
#define cbmOrange        8
#define cbmBrown         9
#define cbmLightRed      10
#define cbmDarkGray      11
#define cbmMedGray       12
#define cbmLightGreen    13
#define cbmLightBlue     14
#define cbmLightGray     15

;-----------
;HTML COLORS
;-----------
#define Black            16
#define Navy             17
#define DarkBlue         18
#define MedBlue          19
#define Blue             20
#define DarkGreen        21
#define Green            22
#define Teal             23
#define DarkCyan         24
#define DeepSkyBlue      25
#define DarkTurquoise    26
#define MedSpringGreen   27
#define Lime             28
#define SpringGreen      29
#define Aqua             30
#define Cyan             30
#define MidnightBlue     31
#define DodgerBlue       32
#define LightSeaGreen    33
#define ForestGreen      34
#define SeaGreen         35
#define DarkSlateGray    36
#define DarkSlateGrey    36
#define LimeGreen        37
#define MedSeaGreen      38
#define Turquoise        39
#define RoyalBlue        40
#define SteelBlue        41
#define DarkSlateBlue    42
#define MedTurquoise     43
#define Indigo           44
#define DarkOliveGreen   45
#define CadetBlue        46
#define CornflowerBlue   47
#define MedAqua          48
#define DimGray          49
#define DimGrey          49
#define SlateBlue        50
#define OliveDrab        51
#define SlateGray        52
#define SlateGrey        52
#define LightSlateGray   53
#define LightSlateGrey   53
#define MedSlateBlue     54
#define LawnGreen        55
#define Chartreuse       56
#define Aquamarine       57
#define Maroon           58
#define Purple           59
#define Olive            60
#define Gray             61
#define Grey             61
#define SkyBlue          62
#define LightSkyBlue     63
#define BlueViolet       64
#define DarkRed          65
#define DarkMagenta      66
#define SaddleBrown      67
#define DarkSeaGreen     68
#define LightGreen       69
#define MedPurple        70
#define DarkViolet       71
#define PaleGreen        72
#define DarkOrchid       73
#define YellowGreen      74
#define Sienna           75
#define Brown            76
#define DarkGray         77
#define DarkGrey         77
#define LightBlue        78
#define GreenYellow      79
#define PaleTurquoise    80
#define LightSteelBlue   81
#define PowderBlue       82
#define FireBrick        83
#define DarkGoldenRod    84
#define MedOrchid        85
#define RosyBrown        86
#define DarkKhaki        87
#define Silver           88
#define MedVioletRed     89
#define IndianRed        90
#define Peru             91
#define Chocolate        92
#define Tan              93
#define LightGray        94
#define LightGrey        94
#define Thistle          95
#define Orchid           96
#define GoldenRod        97
#define PaleVioletRed    98
#define Crimson          99
#define Gainsboro        100
#define Plum             101
#define BurlyWood        102
#define LightCyan        103
#define Lavender         104
#define DarkSalmon       105
#define Violet           106
#define PaleGoldenRod    107
#define LightCoral       108
#define Khaki            109
#define AliceBlue        110
#define HoneyDew         111
#define Azure            112
#define SandyBrown       113
#define Wheat            114
#define Beige            115
#define WhiteSmoke       116
#define MintCream        117
#define GhostWhite       118
#define Salmon           119
#define AntiqueWhite     120
#define Linen            121
#define LightGoldenRod   122
#define OldLace          123
#define Red              124
#define Fuchsia          125
#define Magenta          125
#define DeepPink         126
#define OrangeRed        127
#define Tomato           128
#define HotPink          129
#define Coral            130
#define DarkOrange       131
#define LightSalmon      132
#define Orange           133
#define LightPink        134
#define Pink             135
#define Gold             136
#define PeachPuff        137
#define NavajoWhite      138
#define Moccasin         139
#define Bisque           140
#define MistyRose        141
#define BlanchedAlmond   142
#define PapayaWhip       143
#define LavenderBlush    144
#define SeaShell         145
#define Cornsilk         146
#define LemonChiffon     147
#define FloralWhite      148
#define Snow             149
#define Yellow           150
#define LightYellow      151
#define Ivory            152
#define PackersGreen     153
#define PackersGold      154

;----------
;GRAYSHADES
;----------
#define GRAY_BLACK       160
#define GRAY2            161
#define GRAY3            162
#define GRAY4            163
#define GRAY5            164
#define GRAY6            165
#define GRAY7            166
#define GRAY8            167
#define GRAY9            168
#define GRAY10           169
#define GRAY11           170
#define GRAY12           171
#define GRAY13           172
#define GRAY14           173
#define GRAY15           174
#define GRAY16           175
#define GRAY17           176
#define GRAY18           177
#define GRAY19           178
#define GRAY20           179
#define GRAY21           180
#define GRAY22           181
#define GRAY23           182
#define GRAY24           183
#define GRAY25           184
#define GRAY26           185
#define GRAY27           186
#define GRAY28           187
#define GRAY29           188
#define GRAY30           189
#define GRAY31           190
#define GRAY_WHITE       191
#define White            191
#define EXTCOLOR         192
#define TRANSPARENT		 255

;==========

;----------------------------------
;RGB MACRO  e.g. --> RGB(128,255,0)
;----------------------------------
;RGB 		macro %red,%green,%blue
;        	xor eax,eax  
;        	mov ah,%blue  
;        	shl eax,8  
;        	mov ah,%green  
;        	mov al,%red  
;endm  

;--------------
;VARIABLE TYPES
;--------------
;#define CLOCK dd
;%CLOCK STRUCT
;	DD
;ENDS


