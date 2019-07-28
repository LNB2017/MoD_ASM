.thumb
.include "_Support_Defs.asm"

@r0=proc, r1=unit number

.equ Get_Support_By_Index, Get_Supporter_Data+4
.equ Get_Pairing_Type, Get_Support_By_Index+4
.equ DashesTextID, Get_Pairing_Type+4

push	{r4-r7,r14}
add		sp,#-0x1C
str		r0,[sp,#0x18]
mov		r4,r0
add		r4,#Proc_InitialOffset
mov		r6,r1

mov		r0,r6
mov		r1,#(NumberOfSupports+1)
_blh	DivMod
ldr		r5,=SupportTextStruct
lsl		r0,#3
add		r5,r0		@text struct pointer
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r7,=UnitListLocation
add		r7,r0
ldr		r7,[r7]		@unit data pointer
mov		r0,r5
_blh	TextClear	@clear the text tiles

mov		r0,#0
str		r0,[sp]
str		r0,[sp,#4]
str		r0,[sp,#8]
mov		r0,sp
mov		r1,#0x1B	@C
strb	r1,[r0]
mov		r1,#0x1A	@B
strb	r1,[r0,#2]
mov		r1,#0x19	@A
strb	r1,[r0,#4]
mov		r0,r7
mov		r1,r6
ldr		r3,Get_Supporter_Data
_blr	r3
str		r0,[sp,#0x10]
mov		r0,r7
mov		r1,r6
ldr		r3,Get_Pairing_Type
_blr	r3
cmp		r0,#1
beq		APlusSupport
cmp		r0,#2
beq		SSupport
b		Label1
APlusSupport:
mov		r0,r13
mov		r1,#APlus1
strb	r1,[r0,#6]
mov		r1,#APlus2
strb	r1,[r0,#8]
b		Label1
SSupport:
mov		r0,r13
mov		r1,#0x18	@S
strb	r1,[r0,#6]
Label1:
mov		r0,r7
mov		r1,r6
ldr		r3,Get_Support_By_Index
_blr	r3
str		r0,[sp,#0x14]
lsr		r0,#1		@just get the rank, for the grey text
mov		r1,sp
mov		r2,#GreyText
cmp		r0,#4
bge		GreyTextDone
strb	r2,[r1,#9]
strb	r2,[r1,#7]
cmp		r0,#3
beq		GreyTextDone
strb	r2,[r1,#5]
cmp		r0,#2
beq		GreyTextDone
strb	r2,[r1,#3]
cmp		r0,#1
beq		GreyTextDone
strb	r2,[r1,#1]
GreyTextDone:
ldr		r0,[sp,#0x14]	@support level
mov		r1,#1
tst		r0,r1
beq		GreenTextDone
mov		r1,sp
mov		r2,#GreenText
strb	r2,[r1,r0]
GreenTextDone:

@get the layer offset to write to
mov		r0,r6
mov		r1,#0x10
_blh	DivMod
lsl		r0,#7
ldr		r7,=BGLayer1
add		r7,r0

@draw icon
ldr		r0,[sp,#0x10]	@support data
ldrb	r0,[r0]			@char id
_blh	GetAffinityIcon
mov		r1,r0
mov		r0,r7
mov		r2,#0x50
lsl		r2,#8			@palette
_blh	DrawIcon
add		r7,#4

@check whether the support is maxed out for name display
ldr		r0,[sp,#0x14]
cmp		r0,#8
blt		GetTextString
mov		r0,r5
mov		r1,#GreenText
_blh	Text_SetColorId
GetTextString:
ldr		r0,[sp,#0x10]	@support data
ldrb	r0,[r0]			@char id
_blh	GetUnitByCharID
cmp		r0,#0
bne		CheckIfDead
ldr		r0,[sp,#0x14]
cmp		r0,#0
bne		GetActualName	@if you have a support of some kind, then show the name even if the unit doesn't exist yet
b		ShowDashedName
CheckIfDead:
ldrh	r1,[r0,#0xC]
mov		r2,#4
tst		r1,r2
bne		ShowDashedName
GetActualName:
ldr		r0,[sp,#0x10]	@support data
ldrb	r0,[r0]			@char id
_blh	GetCharacterData
ldrh	r0,[r0]
b		CopyName
ShowDashedName:
ldr		r0,DashesTextID
CopyName:
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
mov		r1,r7
_blh	TextDraw
add		r7,#(2*(UnitTextLength+1))

@draw the letters
mov		r5,sp
DrawLettersLoop:
ldrb	r2,[r5]
cmp		r2,#0
beq		EndDrawingLetters
ldrb	r1,[r5,#1]
mov		r0,r7
_blh	DrawSpecialUiChar
add		r5,#2
add		r7,#2
b		DrawLettersLoop
EndDrawingLetters:

add		sp,#0x1C
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Get_Supporter_Data:
@
