.thumb
.include "_Talk_Defs.asm"

.equ Create_Background, Talk_BG_TSA+4
.equ Banner_Graphics, Create_Background+4
.equ Banner_Palette, Banner_Graphics+4
.equ Star_Graphics, Banner_Palette+4
.equ Star_Palette, Star_Graphics+4
.equ Count_Talks_And_Make_List, Star_Palette+4
.equ Draw_Talk_Entry, Count_Talks_And_Make_List+4

push	{r4-r7,r14}
mov		r4,r0

ldrh	r0,[r4,#Proc_DoNotResetParametersBool]
cmp		r0,#0
beq		Label49
ldr		r0,=BGLayer0
mov		r1,#0
_blh	ClearLayer
b		Label50

Label49:
_blh 	ClearAllAndLoadMapGraphics
_blh	PutCameraCoordsOnLord
_blh 	FirstCopyMapGraphicsToBG3

@set up layer 3 scrolling...i hope
.if Default_Scrolling_BG == 1
	ldr		r0,[r4,#0x14]
	ldr		r0,[r0,#0x58]
	ldrh	r1,[r0,#0x2A]
	strh	r1,[r4,#0x2A]
	mov		r1,#0x2C
	ldrb	r2,[r0,r1]
	strb	r2,[r4,r1]
.endif

@Set up the background
_blh	GetMenuGraphicsAndPalette
ldr		r0,Talk_BG_TSA
ldr		r1,=(BGLayer1+ 0x40*TalkBG_Y + 2*TalkBG_X)
mov		r2,#1										@palette id
ldr		r3,Create_Background
_blr	r3

@Initialize banner graphics
ldr		r0,Banner_Graphics
ldr		r1,=(0x6010000+0x20*Banner_Tile_Number)
_blh	Decompress
ldr		r0,Banner_Palette
mov		r1,#(Banner_Palette_Bank+0x10)
lsl		r1,#5
mov		r2,#0x20	@length
_blh	CopyToPaletteBuffer

@Initialize star graphic
ldr		r0,Star_Graphics
ldr		r1,=(0x6000000+0x20*Star_Tile_Number)
_blh	Decompress
ldr		r0,Star_Palette
mov		r1,#Star_Palette_Bank
lsl		r1,#5
mov		r2,#0x20	@length
_blh	CopyToPaletteBuffer

@Copy scrolling arrows to object tile ram
ldr		r0,=#0x240		@tile id
mov		r1,#3			@palette id
_blh	CopyScrollingArrowTiles

@Set up windowing effect and the banner transparency
ldr		r0,=gLCDControlBuffer
mov		r1,#DISPCNT
ldrh	r2,[r0,r1]
mov		r3,#0x20
lsl		r3,#8
orr		r2,r3
strh	r2,[r0,r1]		@enable window 0 with 0x2000
mov		r1,#WIN0H
ldr		r2,=(((8*(TalkBG_X+1))<<8)|(8*(TalkBG_X+1+SpaceForText+3)))	@left and right
strh	r2,[r0,r1]
mov		r1,#WIN0V
ldr		r2,=(((8*(TalkBG_Y+1))<<8|(8*(TalkBG_Y+1+(2*NumberOfEntriesAtOnce)))))
strh	r2,[r0,r1]
mov		r1,#WININ
mov		r2,#0x1F
strh	r2,[r0,r1]	@enable everything in win0
mov		r1,#WINOUT
mov		r2,#0x1E	@don't show layer 0
strh	r2,[r0,r1]
mov		r1,#BLDCNT
ldr		r2,=#0x830	@sprites onto layer 3
strh	r2,[r0,r1]
mov		r1,#BLDALPHA
ldr		r2,=#0x060E	@coefficients; 6 is for sprite, E for layer 3
strh	r2,[r0,r1]

@intialize more text things
@NOTE: If we're here, that means there's at least 1 talk available
mov		r0,#0
strh	r0,[r4,#Proc_CurrentSlot]	@current slot number
strh	r0,[r4,#Proc_TopSlot]		@slot number at top of screen
mov		r0,#(TalkBG_Y+1)
lsl		r0,#3
neg		r0,r0
strh	r0,[r4,#Proc_CurrentBGPos]	@current shift for bg layer0
strh	r0,[r4,#Proc_NewBGPos]		@new shift for bg layer0 (for scrolling)
ldr		r3,=(gLCDControlBuffer+BG0HOFS)
strh	r0,[r3,#2]
mov		r0,r4
add		r0,#Proc_TalkEntryPointer
ldr		r3,Count_Talks_And_Make_List
_blr	r3
strh	r0,[r4,#Proc_NumberOfEntries]	@max number of options

Label50:

@initialize font
mov		r0,#0
_blh	Font_InitDefault

@initialize text structs
ldr		r5,=InitialTextStruct
mov		r6,#(NumberOfEntriesAtOnce+1)
TextAllocateLoop:
mov		r0,r5
mov		r1,#SpaceForText
_blh	TextInit
add		r5,#8
sub		r6,#1
cmp		r6,#0
bgt		TextAllocateLoop

@display text
ldrh	r6,[r4,#Proc_TopSlot]
mov		r7,r6
add		r7,#NumberOfEntriesAtOnce
ldrh	r0,[r4,#Proc_NumberOfEntries]
cmp		r0,r7
bgt		ShowTextLoop
mov		r7,r0
ShowTextLoop:
ldrh	r0,[r4,#Proc_NumberOfEntries]	@number of options
cmp		r6,r0
bge		ShowTextEnd
mov		r0,r4
mov		r1,r6
ldr		r3,Draw_Talk_Entry
_blr	r3
add		r6,#1
cmp		r6,r7
blt		ShowTextLoop

ShowTextEnd:

@make sure the stuff turns up
mov		r0,#7								@layers 0, 1, and 2
_blh	EnableBGSyncByMask

@End
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Talk_BG_TSA:
@
