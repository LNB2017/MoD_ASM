.thumb
.include "_Support_Defs.asm"

.equ LeftRightKeyPress, Display_Sprites+4
.equ UpDownKeyPress, LeftRightKeyPress+4
.equ Draw_Support_Row, UpDownKeyPress+4
.equ Clear_Row, Draw_Support_Row+4
.equ Reset_Support_Pane_Parameters, Clear_Row+4
.equ Get_Supporter_Data, Reset_Support_Pane_Parameters+4
.equ Get_Support_By_Index, Get_Supporter_Data+4
.equ Start_R_Bubble_Support_Screen, Get_Support_By_Index+4
.equ Check_To_Close_Affinity_Bubble, Start_R_Bubble_Support_Screen+4

push	{r4-r7,r14}
add		sp,#-4
str		r0,[sp]
mov		r4,r0		@proc
add		r4,#Proc_InitialOffset
ldr		r5,=gpKeyStatus
ldr		r5,[r5]

@Close r bubble
ldr		r0,[sp]
ldr		r3,Check_To_Close_Affinity_Bubble
_blr	r3
cmp		r0,#0
beq		Close_R_Bubble_Done
b		GoBack
Close_R_Bubble_Done:

@sprites
ldr		r0,[sp]
ldr		r3,Display_Sprites
_blr	r3

@left/right arrow key presses
ldr		r0,[sp]
ldr		r3,LeftRightKeyPress
_blr	r3
cmp		r0,#0
beq		LeftRightDone
ldrb	r2,[r4,#Proc_SupportCurrentColumn]
add		r1,r0,r2
strb	r1,[r4,#Proc_SupportCurrentColumn]
@r2=previous y, r1=current y
lsl		r3,r0,#3
cmp		r1,#0
beq		FromNameToC		@if new = 0, only way to get there is to press Left on C
cmp		r2,#0
bne		Label7			@if old = 0, only place to go is right to C
FromNameToC:
mov		r3,#(8*(2+UnitTextLength+1)+4)
cmp		r0,#0
bgt		Label7
neg		r3,r3
Label7:
ldrb	r2,[r4,#Proc_SupportHandX]
add		r2,r3
strb	r2,[r4,#Proc_SupportHandX]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#0x1A
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
LeftRightDone:

@up/down arrow key presses
ldr		r0,[sp]
ldr		r3,UpDownKeyPress
_blr	r3
cmp		r0,#0
bne		Label5
b		CheckForLayerShift
Label5:
@Check for L being pressed in conjunction with an arrow key
ldrb	r1,[r4,#Proc_SupportCurrentColumn]
cmp		r1,#4
bge		NormalUpDown	@can't L scroll in the S column, to make my life easier
ldrh	r1,[r5,#4]
mov		r2,#2
lsl		r2,#8
tst		r1,r2
beq		NormalUpDown
@If L was pressed, scroll 1 full page. If there's not enough entries to scroll, scroll as much as possible. If no scrolling is possible, move the hand to the top/bottom of the column.
cmp		r0,#0
bgt		LPlusDown
@LPlusUp
ldrb	r0,[r4,#Proc_SupportTopRow]
cmp		r0,#0
bgt		LPlusUpScrolling
@LPlusUpNotScrolling (because we're at the top)
ldrb	r0,[r4,#Proc_SupportCurrentRow]
neg		r0,r0
b		SetParametersLNoPageChange
LPlusUpScrolling:
ldrb	r1,[r4,#Proc_SupportTopRow]
mov		r0,#NumberOfSupports
cmp		r1,r0
bge		Label1
mov		r0,r1
Label1:
neg		r0,r0
b		SetParametersLPageChange
LPlusDown:
ldrb	r0,[r4,#Proc_SupportTopRow]
add		r0,#(NumberOfSupports-1)
ldrb	r1,[r4,#Proc_SupportLastRow]
cmp		r0,r1
blt		LPlusDownScrolling
@LPlusDownNotScrolling (because we're at the bottom page already)
ldrb	r2,[r4,#Proc_SupportCurrentRow]
ldrb	r0,[r4,#Proc_SupportLastRow]
sub		r0,r2
b		SetParametersLNoPageChange
LPlusDownScrolling:
@r0=current last row, r1=max last row
sub		r0,r1,r0
cmp		r0,#NumberOfSupports
ble		SetParametersLPageChange
mov		r0,#NumberOfSupports
b		SetParametersLPageChange
SetParametersLNoPageChange:
@gotta update currentRow and the hand y coordinate
cmp		r0,#0
beq		CheckForLayerShift			@if we're not moving anything, then pretend this didn't happen
ldrb	r1,[r4,#Proc_SupportCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_SupportCurrentRow]
lsl		r1,r0,#4
ldrb	r2,[r4,#Proc_SupportHandY]
add		r2,r1
strb	r2,[r4,#Proc_SupportHandY]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#0x1A
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
SetParametersLPageChange:
@gotta update topRow, currentRow, and the background layers; the hand stays in the same place
@r0=number of rows to add/subtract
ldrb	r1,[r4,#Proc_SupportTopRow]
add		r1,r0
strb	r1,[r4,#Proc_SupportTopRow]
ldrb	r1,[r4,#Proc_SupportCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_SupportCurrentRow]
mov		r1,#Proc_CurrentLayer1
ldsh	r1,[r4,r1]
lsl		r2,r0,#4
add		r1,r2
strh	r1,[r4,#Proc_CurrentLayer1]
strh	r1,[r4,#Proc_NewLayer1]
ldr		r2,=gLCDControlBuffer
strh	r1,[r2,#BG1VOFS]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#5
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
NormalUpDown:
@add check for whether we are in the S column, and if yes, whether the new row also has an S option; if it does not, then move x stuff to the left
mov		r6,r0
ldrb	r1,[r4,#Proc_SupportCurrentColumn]
cmp		r1,#4
blt		Label8
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
add		r0,r1
ldr		r0,[r0]
ldrb	r1,[r4,#Proc_SupportCurrentRow]
add		r1,r6
ldr		r3,Get_Supporter_Data
_blr	r3
ldrb	r0,[r0,#2]
cmp		r0,#0
bne		Label8			@there's an option, yay!
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
sub		r0,#1
strb	r0,[r4,#Proc_SupportCurrentColumn]
ldrb	r0,[r4,#Proc_SupportHandX]
sub		r0,#8
strb	r0,[r4,#Proc_SupportHandX]
Label8:
mov		r0,r6
cmp		r0,#0
bgt		NormalDown
@NormalUp
ldrb	r1,[r4,#Proc_SupportTopRow]
ldrb	r2,[r4,#Proc_SupportCurrentRow]
add		r2,r0
cmp		r1,r2
blt		SetParametersMoveHand1Row
@UpAndScroll (if already at top of page, move hand; otherwise, do scroll effect
cmp		r1,#0
ble		SetParametersMoveHand1Row
b		SetParametersScroll1Row
NormalDown:
ldrb	r1,[r4,#Proc_SupportTopRow]
add		r1,#(NumberOfSupports-1)
ldrb	r2,[r4,#Proc_SupportCurrentRow]
add		r2,r0
cmp		r1,r2
bgt		SetParametersMoveHand1Row
ldrb	r3,[r4,#Proc_SupportLastRow]
cmp		r2,r3	@is new row going to be last row?
blt		SetParametersScroll1Row
SetParametersMoveHand1Row:	@r0=number to add (-1 or 1); no scrolling necessary
ldrb	r1,[r4,#Proc_SupportCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_SupportCurrentRow]
lsl		r2,r0,#4
ldrb	r1,[r4,#Proc_SupportHandY]
add		r1,r2
strb	r1,[r4,#Proc_SupportHandY]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#0x1A
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
SetParametersScroll1Row:	@r0=number to add (-1 or 1)
ldrb	r1,[r4,#Proc_SupportTopRow]
add		r1,r0
strb	r1,[r4,#Proc_SupportTopRow]
ldrb	r1,[r4,#Proc_SupportCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_SupportCurrentRow]
lsl		r2,r0,#4
mov		r1,#Proc_NewLayer1
ldsh	r1,[r4,r1]
add		r1,r2
strh	r1,[r4,#Proc_NewLayer1]
lsl		r2,r0,#2
mov		r1,#Proc_CurrentLayer1
ldsh	r1,[r4,r1]
add		r1,r2
strh	r1,[r4,#Proc_CurrentLayer1]
ldr		r2,=gLCDControlBuffer
strh	r1,[r2,#BG1VOFS]
ldrb	r1,[r4,#Proc_SupportTopRow]
cmp		r0,#0
blt		Label3
add		r1,#(NumberOfSupports-1)
Label3:
ldr		r0,[sp]
ldr		r3,Draw_Support_Row
_blr	r3
mov		r0,#1
_blh	EnableBGSyncByMask
mov		r0,#MenuChangingUnitsNoise
mov		r1,#0x1A
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
CheckForLayerShift:
mov		r0,#Proc_CurrentLayer1
ldsh	r0,[r4,r0]
mov		r1,#Proc_NewLayer1
ldsh	r1,[r4,r1]
cmp		r0,r1
beq		UpDownDone
blt		ScrollDown
@ScrollUp:
sub		r0,#4
strh	r0,[r4,#Proc_CurrentLayer1]
ldr		r2,=gLCDControlBuffer
strh	r0,[r2,#BG1VOFS]
cmp		r0,r1
bgt		UpDownDone
ldrb	r1,[r4,#Proc_SupportTopRow]
add		r1,#NumberOfSupports
b		Label4
ScrollDown:
add		r0,#4
strh	r0,[r4,#Proc_CurrentLayer1]
ldr		r2,=gLCDControlBuffer
strh	r0,[r2,#BG1VOFS]
cmp		r0,r1
blt		UpDownDone
ldrb	r1,[r4,#Proc_SupportTopRow]
sub		r1,#1
Label4:
ldr		r0,=BGLayer1
ldr		r3,Clear_Row
_blr	r3
@b		UpDownDone
UpDownDone:

@R press
ldrh	r0,[r5,#0x8]
mov		r1,#1
lsl		r1,#8
tst		r0,r1
beq		R_Done
ldr		r0,[sp]
ldr		r3,Start_R_Bubble_Support_Screen
_blr	r3
b		GoBack
R_Done:

@B press
ldrh	r0,[r5,#0x8]
mov		r1,#2
tst		r0,r1
beq		B_Done
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#0xFE
and		r0,r1
strb	r0,[r4,#Proc_PaneNumber]
mov		r0,r4
ldr		r3,Reset_Support_Pane_Parameters
_blr	r3
mov		r0,#MenuBackingOutNoise			@menu closing noise
mov		r1,#0x2
mov		r2,#0
b		PlaySoundAndGoSomewhere
B_Done:

@A press
ldrh	r0,[r5,#0x8]
mov		r1,#1
tst		r0,r1
beq		A_Done
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
cmp		r0,#0
beq		InvalidAPress
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
ldr		r0,[r1,r0]
ldrb	r1,[r4,#Proc_SupportCurrentRow]
ldr		r3,Get_Support_By_Index
_blr	r3
add		r0,#1		@in case the support is unlocked but not played yet
lsr		r0,#1
ldrb	r1,[r4,#Proc_SupportCurrentColumn]
cmp		r0,r1
bge		ValidAPress
InvalidAPress:
mov		r0,#MenuInvalidOptionNoise
mov		r1,#0x1A
mov		r2,#0
b		PlaySoundAndGoSomewhere
ValidAPress:
mov		r0,#MenuSelectNoise
mov		r1,#0x2A
mov		r2,#0
b		PlaySoundAndGoSomewhere
A_Done:

b		GoBack

PlaySoundAndGoSomewhere:
@r0=sound, r1=label to go to
mov		r6,r1
mov		r7,r2
cmp		r0,#0
beq		UpdateBubbleCheck
ldr		r1,=gChapterData
add		r1,#Option2Byte
ldrb	r1,[r1]
lsl		r1,#0x1E
cmp		r1,#0
blt		UpdateBubbleCheck
_blh	PlaySound
UpdateBubbleCheck:
cmp		r7,#0
beq		GoToLabelInR6
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#2
tst		r0,r1
beq		GoToLabelInR6
ldr		r0,[sp]
ldr		r3,Start_R_Bubble_Support_Screen
_blr	r3
GoToLabelInR6:
ldr		r0,[sp]
mov		r1,r6
_blh	GoToProcLabel

GoBack:
mov		r0,#3
_blh	EnableBGSyncByMask

add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Display_Sprites:
@
