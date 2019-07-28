.thumb
.include "_Talk_Defs.asm"

push	{r4-r7,r14}
add		sp,#-4
mov		r4,r0		@proc
ldr		r5,=gpKeyStatus
ldr		r5,[r5]

@layer 3 scrolling
.if Default_Scrolling_BG == 1
	mov		r0,r4
	ldr		r0,[r4,#0x14]
	ldr		r0,[r0,#0x58]
	_blh	0x8082498
.endif

@arrow keys
ldrh	r6,[r4,#Proc_CurrentSlot]
mov		r0,r6
ldrh	r1,[r4,#Proc_NumberOfEntries]
mov		r2,#0			@no looping around
_blh	SlotNumberAfterArrowKeyPress		@also plays the sound
strh	r0,[r4,#Proc_CurrentSlot]	@update current slot
cmp		r0,r6
beq		EndArrowKeyCheck
@Check for L press
ldrh	r1,[r5,#4]
mov		r2,#2
lsl		r2,#8
tst		r1,r2
beq		NormalUpDown
cmp		r0,r6
bgt		LPlusDown
@LPlusUp
ldrh	r1,[r4,#Proc_TopSlot]
cmp		r1,#0
bgt		LPlusUpScrolling
@LPlusUpNotScrolling (because we're at the top)
neg		r0,r6
b		SetParametersLNoPageChange
LPlusUpScrolling:
ldrh	r1,[r4,#Proc_TopSlot]
mov		r0,#NumberOfEntriesAtOnce
cmp		r1,r0
bge		Label23
mov		r0,r1
Label23:
neg		r0,r0
b		SetParametersLPageChange
LPlusDown:
ldrh	r0,[r4,#Proc_TopSlot]
add		r0,#(NumberOfEntriesAtOnce)
ldrh	r1,[r4,#Proc_NumberOfEntries]
cmp		r0,r1
blt		LPlusDownScrolling
@LPlusDownNotScrolling (because we're at the bottom page already)
sub		r1,#1
sub		r0,r1,r6
b		SetParametersLNoPageChange
LPlusDownScrolling:
@r0=current last row, r1=max last row
sub		r0,r1,r0
cmp		r0,#NumberOfEntriesAtOnce
ble		SetParametersLPageChange
mov		r0,#NumberOfEntriesAtOnce
b		SetParametersLPageChange
SetParametersLNoPageChange:
@gotta update currentRow
cmp		r0,#0
beq		EndArrowKeyCheck			@if we're not moving anything, then pretend this didn't happen
add		r1,r0,r6
strh	r1,[r4,#Proc_CurrentSlot]
b		EndArrowKeyCheck
SetParametersLPageChange:
@gotta update topRow, currentRow, and the background layers
@r0=number of rows to add/subtract
ldrh	r1,[r4,#Proc_TopSlot]
add		r1,r0
strh	r1,[r4,#Proc_TopSlot]
add		r1,r0,r6
strh	r1,[r4,#Proc_CurrentSlot]
mov		r1,#Proc_CurrentBGPos
ldsh	r1,[r4,r1]
lsl		r2,r0,#4
add		r1,r2
strh	r1,[r4,#Proc_CurrentBGPos]
strh	r1,[r4,#Proc_NewBGPos]
ldr		r2,=gLCDControlBuffer
strh	r1,[r2,#BG0VOFS]
mov		r1,#1
strh	r1,[r4,#Proc_DoNotResetParametersBool]
mov		r0,r4
mov		r1,#0x5
_blh	GoToProcLabel
b		EndArrowKeyCheck

NormalUpDown:
cmp		r0,r6
blo		ScrolledUp
ScrolledDown:
ldrh	r1,[r4,#Proc_TopSlot]
add		r1,#(NumberOfEntriesAtOnce)
ldrh	r2,[r4,#Proc_NumberOfEntries]
cmp		r1,r2
beq		EndArrowKeyCheck
sub		r1,#1
cmp		r0,r1
blt		EndArrowKeyCheck
mov		r0,#1
add		r1,#1
b		ScrollingStuff
ScrolledUp:
ldrh	r1,[r4,#Proc_TopSlot]
cmp		r1,#0
beq		EndArrowKeyCheck		@if 0, can't scroll up any more
cmp		r0,r1
bgt		EndArrowKeyCheck		@if not at top slot, no need to scroll
mov		r0,#1
neg		r0,r0
sub		r1,#1
ScrollingStuff:
ldrh	r2,[r4,#Proc_TopSlot]
add		r2,r0
strh	r2,[r4,#Proc_TopSlot]
ldrh	r2,[r4,#Proc_NewBGPos]
lsl		r0,#4
add		r2,r0
strh	r2,[r4,#Proc_NewBGPos]
mov		r0,r4
ldr		r3,Draw_Talk_Entry
_blr	r3
@stuff for windowing goes here
EndArrowKeyCheck:

@Background shifting
mov		r0,#Proc_CurrentBGPos
ldsh	r0,[r4,r0]		@current bg position
mov		r1,#Proc_NewBGPos
ldsh	r1,[r4,r1]		@new bg position
cmp		r0,r1
beq		EndBGShift
mov		r2,#4
cmp		r0,r1
blt		Label1
neg		r2,r2
Label1:
add		r0,r2
strh	r0,[r4,#Proc_CurrentBGPos]
ldr		r3,=(gLCDControlBuffer+BG0HOFS)
strh	r0,[r3,#2]
cmp		r0,r1
bne		EndBGShift
ldrh	r0,[r4,#Proc_TopSlot]
cmp		r2,#0
blt		Label2
@if < 0, then we're scrolling up, and thus get rid of the top
sub		r0,#1
b		Label3
Label2:
@if > 0, then going down
add		r0,#NumberOfEntriesAtOnce
Label3:
mov		r6,r0
mov		r1,#(NumberOfEntriesAtOnce+1)
_blh	DivMod
lsl		r0,#3
ldr		r1,=InitialTextStruct
add		r0,r1
_blh	TextClear
@clear the row
mov		r0,r6
mov		r1,#0x10
_blh	DivMod
lsl		r1,r0,#7
ldr		r0,=BGLayer0
add		r0,r1
mov		r1,r0
add		r1,#0x40
mov		r2,#0
mov		r3,#0	@counter
ClearingLoop:
strh	r2,[r0]
str		r2,[r1]
add		r0,#2
add		r1,#2
add		r3,#1
cmp		r3,#0x20
blt		ClearingLoop

EndBGShift:
mov		r0,#1
_blh	EnableBGSyncByMask

@sprite stuff
@banner background
mov		r6,#0			@counter
ldr		r7,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number)
str		r7,[sp]			@base oam2 data (for now, just priority)
BannerBGLoop:
mov		r0,#0xD			@root node index, not sure this makes a difference
lsl		r1,r6,#5		@x
mov		r2,#BannerBG_Y	@y
adr		r3,BannerBG_OAM_Base	@oam data pointer
_blh	RegisterObjectSafe,r7
add		r6,#1
cmp		r6,#8
blt		BannerBGLoop
@banner text
mov		r0,#0xD
mov		r1,#BannerText_X
mov		r2,#BannerText_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+4)
str		r3,[sp]
adr		r3,BannerText_OAM_Base
_blh	RegisterObjectSafe,r7
@hand
mov		r0,#(8*(TalkBG_X+1)-3)
mov		r1,#(8*(TalkBG_Y+1))
ldrh	r2,[r4,#0x36]		@current slot
ldrh	r3,[r4,#0x38]		@top slot
sub		r2,r2,r3
lsl		r2,#4
add		r1,r2
_blh	UpdateHandCursor
@scrolling arrows
ldrh	r0,[r4,#0x38]			@top slot
cmp		r0,#0
beq		DownScrollingArrow
mov		r2,#0xC9
lsl		r2,#6				@no idea what this is
mov		r0,#(8*14)			@just center it
mov		r1,#(8*(TalkBG_Y)+4)
mov		r3,#1				@arrow orientation?
_blh	ShowScrollingArrows, r6

DownScrollingArrow:
ldrh	r0,[r4,#0x38]			@top slot
add		r0,#NumberOfEntriesAtOnce
ldrh	r1,[r4,#0x3E]			@max number of entries in this tab
cmp		r0,r1
bge		ScrollingArrowsComplete
mov		r2,#0xC9
lsl		r2,#6
mov		r0,#(8*14)			@just center it
mov		r1,#(8*(TalkBG_Y+1+(2*NumberOfEntriesAtOnce))+4)
mov		r3,#0				@arrow orientation?
_blh	ShowScrollingArrows, r6
ScrollingArrowsComplete:

@Help - b back
mov		r0,#0xD
mov		r1,#BHelp_X
mov		r2,#BHelp_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+68)
str		r3,[sp]
adr		r3,BHelp_OAM_Base
_blh	RegisterObjectSafe,r6
@Help - page scroll
mov		r0,#0xD
mov		r1,#LHelp_X
mov		r2,#LHelp_Y
ldr		r3,=(((Banner_Palette_Bank)<<0xC)+Banner_Tile_Number+23)
str		r3,[sp]
adr		r3,LHelp_OAM_Base
_blh	RegisterObjectSafe,r6

@Keypresses other than arrows
ldrh	r0,[r5,#0x8]

CheckBButton:
mov		r1,#2
tst		r0,r1
beq		CheckAButton
ldr		r0,=gChapterData
add		r0,#Option2Byte
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0
blt		GoToBLabel
mov		r0,#MenuBackingOutNoise			@menu closing noise
_blh	PlaySound
GoToBLabel:
@put scrolling back
.if Default_Scrolling_BG == 1
	ldr		r0,[r4,#0x14]
	ldr		r0,[r0,#0x58]
	ldrh	r1,[r4,#0x2A]
	strh	r1,[r0,#0x2A]
	mov		r1,#0x2C
	ldrb	r2,[r4,r1]
	strb	r2,[r0,r1]
.endif
@and let's get out of here
mov		r0,r4
mov		r1,#0xB
_blh	GoToProcLabel
b		GoBack

CheckAButton:
mov		r1,#1
tst		r0,r1
beq		GoBack
mov		r0,r4
mov		r1,#0xA
_blh	GoToProcLabel

GoBack:
add		sp,#4
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
.short 0x4400, 0x8060, 0x0C0C
.short 0x0400, 0x4080, 0x0C10	@alpha blending, 16x16, high priority

.align
LHelp_OAM_Base:
.short 3
.short 0x4000, 0x8000, 0x0000
.short 0x4000, 0x8020, 0x0004
.short 0x8000, 0x0040, 0x0008

.align
BHelp_OAM_Base:
.short 2
.short 0x4000, 0x8000, 0x0000
.short 0x8000, 0x0020, 0x0004

.ltorg
Draw_Talk_Entry:
@
