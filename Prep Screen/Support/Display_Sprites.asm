.thumb
.include "_Support_Defs.asm"

@r0 = proc

push	{r4-r7,r14}
add		sp,#-8
str		r0,[sp,#4]
mov		r4,r0
add		r4,#Proc_InitialOffset

@map sprites - this should both decompress and display
ldrb	r5,[r4,#Proc_UnitTopRow]
lsl		r5,#1
mov		r6,r5
add		r6,#(NumberOfUnitRows*NumberOfUnitColumns)
ldr		r0,=UnitCountLocation
ldrb	r0,[r0]
cmp		r0,r6
bge		Label2
mov		r6,r0
Label2:
mov		r7,#0
MapSpriteLoop:
ldr		r0,=Create_SMS
mov		r14,r0
mov		r1,#(8*(UnitText_X-2))
mov		r2,#1
tst		r2,r7
beq		Label3
add		r1,#(8*(2+UnitTextLength+1))
Label3:
mov		r2,#Proc_CurrentLayer0
ldsh	r2,[r4,r2]
mov		r3,#Proc_NewLayer0
ldsh	r3,[r4,r3]
sub		r2,r3,r2		@new - current
add		r2,#(8*UnitText_Y)
lsr		r3,r7,#1
lsl		r3,#4
add		r2,r3
ldr		r3,=UnitListLocation
lsl		r0,r5,#2
add		r3,r0
ldr		r3,[r3]
mov		r0,#3
.short	0xF800
add		r5,#1
add		r7,#1
cmp		r5,r6
blt		MapSpriteLoop

@Update the frame of said map sprites
_blh	SMS_SyncDirect

@Cursor timer (which is also used for palette changing stuff
ldrb	r0,[r4,#Proc_CursorTimer]
add		r0,#1
cmp		r0,#0x3F
ble		Label1
mov		r0,#0
Label1:
strb	r0,[r4,#Proc_CursorTimer]

@Palette changing (for the little bar behind the name/the support letter being highlighted)
ldrb	r0,[r4,#Proc_CursorTimer]
lsr		r0,#2
lsl		r0,#1
adr		r1,GlowingPaletteColors
ldrh	r0,[r1,r0]
ldr		r1,=PaletteBuffer
mov		r2,#(Banner_Palette_Bank+0x10)
lsl		r2,#5
add		r1,r2
add		r1,#(2*0xF)			@place in the palette with the changing colors
strh	r0,[r1]

@banner
mov		r5,#0			@counter
ldr		r6,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number)
BannerBGLoop:
mov		r0,#0xD			@root node index, not sure this makes a difference
lsl		r1,r5,#5		@x
mov		r2,#BannerBG_Y	@y
adr		r3,BannerBG_OAM_Base	@oam data pointer
str		r6,[sp]			@base oam2 data (for now, just priority)
_blh	RegisterObjectSafe,r7
add		r5,#1
cmp		r5,#8
blt		BannerBGLoop

@banner text
mov		r0,#0xD
mov		r1,#BannerText_X
mov		r2,#BannerText_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+4)
str		r3,[sp]
adr		r3,BannerText_OAM_Base
_blh	RegisterObjectSafe,r7

@help - page scroll
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
beq		ShowHelpPageScroll
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
cmp		r0,#4
bge		EndHelpPageScroll
ShowHelpPageScroll:
mov		r0,#0xD
mov		r1,#LHelp_X
mov		r2,#LHelp_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+19)
str		r3,[sp]
adr		r3,LHelp_OAM_Base
_blh	RegisterObjectSafe,r7
EndHelpPageScroll:

@help - info
mov		r0,#0xD
mov		r1,#RHelp_X
mov		r2,#RHelp_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+28)
str		r3,[sp]
adr		r3,RHelp_OAM_Base
_blh	RegisterObjectSafe,r7

@help - b back
mov		r0,#0xD
mov		r1,#BHelp_X
mov		r2,#BHelp_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+77)
str		r3,[sp]
adr		r3,BHelp_OAM_Base
_blh	RegisterObjectSafe,r7

@unit pane hand
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
bne		StationaryUnitHand
ldrb	r0,[r4,#Proc_UnitHandX]
ldrb	r1,[r4,#Proc_UnitHandY]
_blh	UpdateHandCursor
b		UnitPaneHandComplete
StationaryUnitHand:
mov		r0,#2
ldrb	r1,[r4,#Proc_UnitHandX]
sub		r1,#0xC
ldrb	r2,[r4,#Proc_UnitHandY]
mov		r3,#0
str		r3,[sp]
ldr		r3,=HandOAMBasePointer
_blh	RegisterObjectSafe,r7
UnitPaneHandComplete:

@support pane hand
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
beq		SupportPaneHandComplete
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
cmp		r0,#0
bne		ShowSupportCursor
ldrb	r0,[r4,#Proc_SupportHandX]
ldrb	r1,[r4,#Proc_SupportHandY]
_blh	UpdateHandCursor
b		SupportPaneHandComplete
ShowSupportCursor:
ldrb	r0,[r4,#Proc_CursorTimer]
lsr		r0,#1
mov		r1,#0xF
and		r0,r1
adr		r5,CursorPosition
ldrb	r5,[r5,r0]
mov		r3,#2
str		r3,[sp]
ldr		r7,=RegisterObjectSafe
@top left
mov		r0,#2
ldrb	r1,[r4,#Proc_SupportHandX]
sub		r1,r5
ldrb	r2,[r4,#Proc_SupportHandY]
sub		r2,r5
adr		r3,CursorOAMBasePointer1
_blr	r7
@top right
mov		r0,#2
ldrb	r1,[r4,#Proc_SupportHandX]
add		r1,r5
ldrb	r2,[r4,#Proc_SupportHandY]
sub		r2,r5
adr		r3,CursorOAMBasePointer2
_blr	r7
@bottom left
mov		r0,#2
ldrb	r1,[r4,#Proc_SupportHandX]
sub		r1,r5
ldrb	r2,[r4,#Proc_SupportHandY]
add		r2,r5
adr		r3,CursorOAMBasePointer3
_blr	r7
@bottom right
mov		r0,#2
ldrb	r1,[r4,#Proc_SupportHandX]
add		r1,r5
ldrb	r2,[r4,#Proc_SupportHandY]
add		r2,r5
adr		r3,CursorOAMBasePointer4
_blr	r7
@Glowing thingy behind letter
mov		r0,#0xD
ldrb	r1,[r4,#Proc_SupportHandX]
ldrb	r2,[r4,#Proc_SupportHandY]
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+76)
str		r3,[sp]
adr		r3,Support_Glowing_Thingy_OAM_Base
_blr	r7
SupportPaneHandComplete:

@glowing thingy behind current unit
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
bne		GlowingThingBehindUnitDone
mov		r0,#0xD
ldrb	r1,[r4,#Proc_UnitHandX]
ldrb	r2,[r4,#Proc_UnitHandY]
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+68)
str		r3,[sp]
adr		r3,Unit_Glowing_Thingy_OAM_Base
_blh	RegisterObjectSafe,r7
GlowingThingBehindUnitDone:

@scrolling arrows
@UnitUpArrow
ldr		r7,=ShowScrollingArrows
mov		r5,#0xC9
lsl		r5,#6
ldrb	r0,[r4,#Proc_UnitTopRow]
cmp		r0,#0
ble		UnitDownArrow
mov		r0,#(4*(SupportBG_X+1+2+UnitTextLength+1+2+UnitTextLength))
mov		r1,#(8*(SupportBG_Y))
mov		r2,r5
mov		r3,#1
_blr	r7
UnitDownArrow:
ldrb	r0,[r4,#Proc_UnitTopRow]
add		r0,#(NumberOfUnitRows-1)
ldrb	r1,[r4,#Proc_UnitLastRow]
cmp		r0,r1
bge		SupportUpArrow
mov		r0,#(4*(SupportBG_X+1+2+UnitTextLength+1+2+UnitTextLength))
mov		r1,#(8*(SupportBG_Y+2*NumberOfUnitRows)+8)
mov		r2,r5
mov		r3,#0
_blr	r7
SupportUpArrow:
ldrb	r0,[r4,#Proc_SupportTopRow]
cmp		r0,#0
ble		SupportDownArrow
mov		r0,#((8*SupportEntry_X)+(4*(2+UnitTextLength+1+4))-4)
mov		r1,#(8*(SupportBG_Y))
mov		r2,r5
mov		r3,#1
_blr	r7
SupportDownArrow:
ldrb	r0,[r4,#Proc_SupportTopRow]
add		r0,#NumberOfSupports
ldrb	r1,[r4,#Proc_SupportLastRow]
cmp		r0,r1
bge		EndScrollingArrow
mov		r0,#((8*SupportEntry_X)+(4*(2+UnitTextLength+1+4))-4)
mov		r1,#(8*(SupportBG_Y+2*NumberOfSupports)+8)
mov		r2,r5
mov		r3,#0
_blr	r7
EndScrollingArrow:

add		sp,#8
pop		{r4-r7}
pop		{r0}
bx		r0

.align
BannerBG_OAM_Base:
.short 1		@number of objects
.short 0x0400	@alpha blending, 32x32 object
.short 0x8000	@32x32 object
.short 0x0C00	@priority, higher priority = drawn first and thus end up behind others

.align
BannerText_OAM_Base:
.short 5
.short 0x4400, 0x8000, 0x0C00	@alpha blending, 32x16, high priority
.short 0x4400, 0x8020, 0x0C04
.short 0x4400, 0x8040, 0x0C08
.short 0x0400, 0x4060, 0x0C0C	@alpha blending, 16x16, high priority
.short 0x8400, 0x0070, 0x0C0E	@alpha blending, 8x16, high priority

.align
LHelp_OAM_Base:
.short 3
.short 0x4000, 0x8000, 0x0000
.short 0x4000, 0x8020, 0x0004
.short 0x8000, 0x0040, 0x0008

.align
RHelp_OAM_Base:
.short 1
.short 0x4000, 0x8000, 0x0000

.align
BHelp_OAM_Base:
.short 2
.short 0x4000, 0x8000, 0x0000
.short 0x8000, 0x0020, 0x0004

.align
CursorOAMBasePointer1:
.short 1
.short 0x0000, 0x01FC, 0x0000
CursorOAMBasePointer2:
.short 1
.short 0x0000, 0x1004, 0x0000
CursorOAMBasePointer3:
.short 1
.short 0x0009, 0x21FC, 0x0000
CursorOAMBasePointer4:
.short 1
.short 0x0009, 0x3004, 0x0000

.align
Unit_Glowing_Thingy_OAM_Base:
.short 2
.short 0x4008, 0x4000, 0x0800
.short 0x4008, 0x4020, 0x0804

.align
Support_Glowing_Thingy_OAM_Base:
.short 1
.short 0x8000, 0x0000, 0x0800

.align
CursorPosition:
.byte 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0, 0, 0, 0, 1

.align
GlowingPaletteColors:
.short 0x618C, 0x65CD, 0x6A0F, 0x6E50, 0x7291, 0x76D2, 0x7B14, 0x7F55, 0x7F55, 0x7B14, 0x76D3, 0x7291, 0x6E50, 0x6A0F, 0x65CD, 0x618C

.ltorg
