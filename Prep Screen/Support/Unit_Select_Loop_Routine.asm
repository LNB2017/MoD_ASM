.thumb
.include "_Support_Defs.asm"

.equ LeftRightKeyPress, Display_Sprites+4
.equ UpDownKeyPress, LeftRightKeyPress+4
.equ Draw_Unit_Row, UpDownKeyPress+4
.equ Clear_Row, Draw_Unit_Row+4
.equ Start_R_Bubble_Support_Screen, Clear_Row+4
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

@left/right arrow key presses
ldr		r0,[sp]
ldr		r3,LeftRightKeyPress
_blr	r3
cmp		r0,#0
beq		LeftRightDone
@update current unit
ldrb	r1,[r4,#Proc_UnitCurrentChar]
add		r1,r0
strb	r1,[r4,#Proc_UnitCurrentChar]
ldrb	r1,[r4,#Proc_UnitCurrentColumn]
add		r1,r0
strb	r1,[r4,#Proc_UnitCurrentColumn]
@update the hand
mov		r2,#(8*(2+UnitTextLength+1))	@2 for map sprite, 1 for separator column
cmp		r0,#0
bge		StoreHand
neg		r2,r2
StoreHand:
ldrb	r1,[r4,#Proc_UnitHandX]
add		r1,r2
strb	r1,[r4,#Proc_UnitHandX]
@play noise
mov		r0,#MenuChangingUnitsNoise
mov		r1,#2
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
ldrh	r1,[r5,#4]
mov		r2,#2
lsl		r2,#8
tst		r1,r2
beq		NormalUpDown
@If L was pressed, scroll 1 full page. If there's not enough entries to scroll, scroll as much as possible. If no scrolling is possible, move the hand to the top/bottom of the column.
cmp		r0,#0
bgt		LPlusDown
@LPlusUp
ldrb	r0,[r4,#Proc_UnitTopRow]
cmp		r0,#0
bgt		LPlusUpScrolling
@LPlusUpNotScrolling (because we're at the top)
ldrb	r0,[r4,#Proc_UnitCurrentRow]
neg		r0,r0
b		SetParametersLNoPageChange
LPlusUpScrolling:
ldrb	r1,[r4,#Proc_UnitTopRow]
mov		r0,#NumberOfUnitRows
cmp		r1,r0
bge		Label1
mov		r0,r1
Label1:
neg		r0,r0
b		SetParametersLPageChange
LPlusDown:
ldrb	r0,[r4,#Proc_UnitTopRow]
add		r0,#(NumberOfUnitRows-1)
ldrb	r1,[r4,#Proc_UnitLastRow]
cmp		r0,r1
blt		LPlusDownScrolling
@LPlusDownNotScrolling (because we're at the bottom page already)
ldrb	r2,[r4,#Proc_UnitCurrentRow]
sub		r0,r1,r2		@number of rows to move the hand by
mov		r2,#NumberOfUnitColumns
mul		r2,r1
ldrb	r3,[r4,#Proc_UnitCurrentColumn]
add		r2,r3
ldrb	r3,[r4,#Proc_UnitLastCharSlot]
cmp		r2,r3
ble		SetParametersLNoPageChange
sub		r0,#1		@this should only happen if there's an odd number of units
b		SetParametersLNoPageChange
LPlusDownScrolling:
@r0=current last row, r1=max last row
sub		r0,r1,r0
cmp		r0,#NumberOfUnitRows
ble		SetParametersLPageChange
mov		r0,#NumberOfUnitRows
b		SetParametersLPageChange
SetParametersLNoPageChange:
@gotta update currentRow, currentChar, and the hand y coordinate
cmp		r0,#0
bne		Label37
b		CheckForLayerShift			@if we're not moving anything, then pretend this didn't happen
Label37:
ldrb	r1,[r4,#Proc_UnitCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_UnitCurrentRow]
mov		r1,#NumberOfUnitColumns
mul		r1,r0
ldrb	r2,[r4,#Proc_UnitCurrentChar]
add		r2,r1
strb	r2,[r4,#Proc_UnitCurrentChar]
lsl		r1,r0,#4
ldrb	r2,[r4,#Proc_UnitHandY]
add		r2,r1
strb	r2,[r4,#Proc_UnitHandY]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#2
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
SetParametersLPageChange:
@gotta update topRow, currentRow, currentChar, and the background layers; the hand stays in the same place
@r0=number of rows to add/subtract
ldrb	r1,[r4,#Proc_UnitTopRow]
add		r1,r0
strb	r1,[r4,#Proc_UnitTopRow]
ldrb	r1,[r4,#Proc_UnitCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_UnitCurrentRow]
ldrb	r1,[r4,#Proc_UnitCurrentChar]
mov		r2,#NumberOfUnitColumns
mul		r2,r0
add		r1,r2
strb	r1,[r4,#Proc_UnitCurrentChar]
mov		r1,#Proc_CurrentLayer0
ldsh	r1,[r4,r1]
lsl		r2,r0,#4
add		r1,r2
strh	r1,[r4,#Proc_CurrentLayer0]
strh	r1,[r4,#Proc_NewLayer0]
ldr		r2,=gLCDControlBuffer
strh	r1,[r2,#BG0VOFS]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#1
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
NormalUpDown:
cmp		r0,#0
bgt		NormalDown
@NormalUp
ldrb	r1,[r4,#Proc_UnitTopRow]
ldrb	r2,[r4,#Proc_UnitCurrentRow]
add		r2,r0
cmp		r1,r2
blt		SetParametersMoveHand1Row
@UpAndScroll (if already at top of page, move hand; otherwise, do scroll effect
cmp		r1,#0
ble		SetParametersMoveHand1Row
b		SetParametersScroll1Row
NormalDown:
ldrb	r1,[r4,#Proc_UnitTopRow]
add		r1,#(NumberOfUnitRows-1)
ldrb	r2,[r4,#Proc_UnitCurrentRow]
add		r2,r0
cmp		r1,r2
bgt		SetParametersMoveHand1Row
ldrb	r3,[r4,#Proc_UnitLastRow]
cmp		r2,r3	@is new row going to be last row?
blt		SetParametersScroll1Row
@if scrolling into the last row, we need to check if there is a unit directly under the current one. If there is not, we update the hand x coordinate, currentColumn, and currentChar to jump to the left.
ldrb	r1,[r4,#Proc_UnitCurrentChar]
add		r1,#NumberOfUnitColumns
ldrb	r2,[r4,#Proc_UnitLastCharSlot]
cmp		r1,r2
ble		SetParametersMoveHand1Row
sub		r2,r1,r2
ldrb	r1,[r4,#Proc_UnitCurrentChar]
sub		r1,r2
strb	r1,[r4,#Proc_UnitCurrentChar]
ldrb	r1,[r4,#Proc_UnitCurrentColumn]
sub		r1,r2
strb	r1,[r4,#Proc_UnitCurrentColumn]
mov		r1,#(8*(2+UnitTextLength+1))
mul		r2,r1
ldrb	r1,[r4,#Proc_UnitHandX]
sub		r1,r2
strb	r1,[r4,#Proc_UnitHandX]
@b		SetParametersMoveHand1Row
SetParametersMoveHand1Row:	@r0=number to add (-1 or 1); no scrolling necessary
ldrb	r1,[r4,#Proc_UnitCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_UnitCurrentRow]
mov		r2,#NumberOfUnitColumns
mul		r2,r0
ldrb	r1,[r4,#Proc_UnitCurrentChar]
add		r1,r2
strb	r1,[r4,#Proc_UnitCurrentChar]
lsl		r2,r0,#4
ldrb	r1,[r4,#Proc_UnitHandY]
add		r1,r2
strb	r1,[r4,#Proc_UnitHandY]
mov		r0,#MenuChangingUnitsNoise
mov		r1,#2
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
SetParametersScroll1Row:	@r0=number to add (-1 or 1)
ldrb	r1,[r4,#Proc_UnitTopRow]
add		r1,r0
strb	r1,[r4,#Proc_UnitTopRow]
ldrb	r1,[r4,#Proc_UnitCurrentRow]
add		r1,r0
strb	r1,[r4,#Proc_UnitCurrentRow]
mov		r2,#NumberOfUnitColumns
mul		r2,r0
ldrb	r1,[r4,#Proc_UnitCurrentChar]
add		r1,r2
strb	r1,[r4,#Proc_UnitCurrentChar]
lsl		r2,r0,#4
mov		r1,#Proc_NewLayer0
ldsh	r1,[r4,r1]
add		r1,r2
strh	r1,[r4,#Proc_NewLayer0]
lsl		r2,r0,#2
mov		r1,#Proc_CurrentLayer0
ldsh	r1,[r4,r1]
add		r1,r2
strh	r1,[r4,#Proc_CurrentLayer0]
ldr		r2,=gLCDControlBuffer
strh	r1,[r2,#BG0VOFS]
ldrb	r1,[r4,#Proc_UnitTopRow]
cmp		r0,#0
blt		Label3
add		r1,#(NumberOfUnitRows-1)
Label3:
ldr		r0,[sp]
ldr		r3,Draw_Unit_Row
_blr	r3
mov		r0,#1
_blh	EnableBGSyncByMask
mov		r0,#MenuChangingUnitsNoise
mov		r1,#2
mov		r2,#1					@update bubble if necessary
b		PlaySoundAndGoSomewhere
CheckForLayerShift:
mov		r0,#Proc_CurrentLayer0
ldsh	r0,[r4,r0]
mov		r1,#Proc_NewLayer0
ldsh	r1,[r4,r1]
cmp		r0,r1
beq		UpDownDone
blt		ScrollDown
@ScrollUp:
sub		r0,#4
strh	r0,[r4,#Proc_CurrentLayer0]
ldr		r2,=gLCDControlBuffer
strh	r0,[r2,#BG0VOFS]
cmp		r0,r1
bgt		UpDownDone
ldrb	r1,[r4,#Proc_UnitTopRow]
add		r1,#NumberOfUnitRows
b		Label4
ScrollDown:
add		r0,#4
strh	r0,[r4,#Proc_CurrentLayer0]
ldr		r2,=gLCDControlBuffer
strh	r0,[r2,#BG0VOFS]
cmp		r0,r1
blt		UpDownDone
ldrb	r1,[r4,#Proc_UnitTopRow]
sub		r1,#1
Label4:
ldr		r0,=BGLayer0
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
mov		r0,#MenuBackingOutNoise			@menu closing noise
mov		r1,#0x1B
mov		r2,#0					@do not update bubble
b		PlaySoundAndGoSomewhere
B_Done:

@A press
ldrh	r0,[r5,#0x8]
mov		r1,#1
tst		r0,r1
beq		A_Done
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#2
tst		r0,r1
bne		A_Done							@pressing A does nothing when R bubble is up
ldrb	r0,[r4,#Proc_NumberOfSupports]
cmp		r0,#0
bgt		Label6
mov		r0,#MenuInvalidOptionNoise
mov		r1,#3
mov		r2,#0
b		PlaySoundAndGoSomewhere
Label6:
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
orr		r0,r1
strb	r0,[r4,#Proc_PaneNumber]
mov		r0,#MenuSelectNoise
mov		r1,#0x1A
mov		r2,#0
b		PlaySoundAndGoSomewhere
A_Done:

b		GoBack

PlaySoundAndGoSomewhere:
@r0=sound, r1=label to go to, r2=bool to check whether to update the bubble or not
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
@sprites
ldr		r0,[sp]
ldr		r3,Display_Sprites
_blr	r3

mov		r0,#3
_blh	EnableBGSyncByMask

add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Display_Sprites:
@
