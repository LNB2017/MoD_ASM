.thumb
.include "_Support_Defs.asm"

.equ Create_Background, Support_BG_TSA+4
.equ Banner_Graphics, Create_Background+4
.equ Banner_Palette, Banner_Graphics+4

push	{r4-r7,r14}
add		sp,#-4
str		r0,[sp]
mov		r4,r0
add		r4,#Proc_InitialOffset

@Set up the background
_blh	GetMenuGraphicsAndPalette
ldr		r0,Support_BG_TSA
ldr		r1,=(BGLayer2+ 0x40*SupportBG_Y + 2*SupportBG_X)
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
@ldr		r2,=(((8*(TalkBG_X+1))<<8)|(8*(TalkBG_X+1+SpaceForText+3)))	@left and right (for simplicity's sake, just make them be the screen width)
mov		r2,#240
strh	r2,[r0,r1]
mov		r1,#WIN0V
ldr		r2,=(((8*SupportEntry_Y)<<8)|(8*(SupportEntry_Y+(2*NumberOfSupports))))
strh	r2,[r0,r1]
mov		r1,#WININ
mov		r2,#0x1F
strh	r2,[r0,r1]	@enable everything in winin
mov		r1,#WINOUT
mov		r2,#0x1C	@don't show layer 0 or 1
strh	r2,[r0,r1]
mov		r1,#BLDCNT
ldr		r2,=#0x830	@sprites onto layer 3
strh	r2,[r0,r1]
mov		r1,#BLDALPHA
ldr		r2,=#0x060E	@coefficients; 6 is for sprite, E for layer 3
strh	r2,[r0,r1]

@Set up the unit list
ldr		r5,=UnitListLocation
mov		r6,#1
mov		r7,#0
UnitLoop:
mov		r0,r6
_blh	GetUnitData
cmp		r0,#0
beq		NextUnit
ldr		r1,[r0]
cmp		r1,#0
beq		NextUnit
ldrh	r1,[r0,#0xC]
mov		r2,#4
tst		r1,r2
bne		NextUnit
str		r0,[r5]
add		r7,#1
add		r5,#4
NextUnit:
add		r6,#1
cmp		r6,#0x3F
ble		UnitLoop
ldr		r0,=UnitCountLocation
strb	r7,[r0]
sub		r7,#1
strb	r7,[r4,#Proc_UnitLastCharSlot]
lsr		r7,#1
strb	r7,[r4,#Proc_UnitLastRow]

@initialize font
_blh	Font_InitDefault

@initialize text structs
ldr		r5,=UnitTextStruct
mov		r6,#((NumberOfUnitColumns*(NumberOfUnitRows+1))+NumberOfSupports+1)
TextAllocateLoop:
mov		r0,r5
mov		r1,#UnitTextLength
_blh	TextInit
add		r5,#8
sub		r6,#1
cmp		r6,#0
bgt		TextAllocateLoop

@make a new glowy green proc
ldr		r0,[sp]
_blh	NewGreenTextColorManager

@make sure the stuff turns up
mov		r0,#7								@layers 0, 1, and 2
_blh	EnableBGSyncByMask

@End
add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Support_BG_TSA:
@


@mov		r1,#WIN0H
@ldr		r2,=(((8*(SupportBG_X+1))<<8)|(8*(SupportBG_X+1+1+2*(UnitTextLength+2))))	@left and right; right side = left side + 2*(name + map sprite) + 1 tile separator
@strh	r2,[r0,r1]
@mov		r1,#WIN0V
@ldr		r2,=(((8*(SupportBG_Y+1))<<8)|(8*(SupportBG_Y+1+NumberOfUnits)))			@NumberOfUnits is already doubled
@strh	r2,[r0,r1]
@mov		r1,#WIN1H
@ldr		r2,=((8*SupportEntry_X<<8)|(8*(SupportEntry_X+SupportEntryLength)))
@strh	r2,[r0,r1]
@mov		r1,#WIN1V
@ldr		r2,=((8*SupportEntry_Y<<8)|(8*(SupportEntry_Y+(2*NumberOfSupports))))
@strh	r2,[r0,r1]
@mov		r1,#WININ
@mov		r2,#0x1F
@lsl		r3,r2,#8
@orr		r2,r3
@strh	r2,[r0,r1]	@enable everything in win0 and win1
@mov		r1,#WINOUT
@mov		r2,#0x1E	@don't show layer 0
