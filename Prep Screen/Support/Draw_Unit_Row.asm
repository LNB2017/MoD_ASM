.thumb
.include "_Support_Defs.asm"

@r0=proc, r1=row number

push	{r4-r7,r14}
add		sp,#-0xC
str		r0,[sp]
mov		r4,r0
add		r4,#Proc_InitialOffset
mov		r6,r1

@get text structs
mov		r0,#0
str		r0,[sp,#8]
mov		r0,r6
mov		r1,#(NumberOfUnitRows+1)
_blh	DivMod
ldr		r5,=UnitTextStruct
lsl		r0,#4		@times 16 because each row has 2 text structs
add		r5,r0		@text struct pointer

@get bg location
mov		r0,r6
mov		r1,#0x10
_blh	DivMod
lsl		r1,r0,#7
lsl		r0,r6,#1
str		r0,[sp,#4]
ldr		r6,=BGLayer0
add		r6,r1

DrawNameLoop:
ldr		r0,[sp,#4]
lsl		r0,#2
ldr		r7,=UnitListLocation
add		r7,r0
ldr		r7,[r7]		@unit data pointer
mov		r0,r5
_blh	TextClear	@clear the text tiles
mov		r0,r7
ldr		r3,DoesUnitHaveAnySupports
_blr	r3
cmp		r0,#0
beq		GetUnitName
mov		r0,r5
mov		r1,#GreenText
_blh	Text_SetColorId
GetUnitName:
ldr		r0,[r7]
ldrh	r0,[r0]
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r5
mov		r1,r6
_blh	TextDraw
@Figure out if we need to draw the second name
ldr		r0,[sp,#8]
cmp		r0,#0
bne		GoBack
add		r0,#1
str		r0,[sp,#8]
ldr		r0,[sp,#4]
ldrb	r1,[r4,#Proc_UnitLastCharSlot]
cmp		r0,r1
bge		GoBack
add		r0,#1
str		r0,[sp,#4]
add		r5,#8
add		r6,#(2*(2+UnitTextLength+1))
b		DrawNameLoop

GoBack:
add		sp,#0xC
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
DoesUnitHaveAnySupports:
@
