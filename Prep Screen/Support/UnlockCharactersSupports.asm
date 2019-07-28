.thumb
.include "_Support_Defs.asm"

.equ Get_Supporter_Data, Get_Support_By_Index+4
.equ Set_Support_By_Index, Get_Supporter_Data+4

@r0=unit data

push	{r4-r7,r14}
add		sp,#-8
mov		r4,r0
_blh	GetNumberOfSupports
cmp		r0,#0
beq		GoBack
mov		r7,r0
mov		r6,#0		@counter
mov		r5,#0		@bool for whether unit has a paired support
Loop1:
cmp		r6,r7
bge		EndLoop1
mov		r0,r4
mov		r1,r6
ldr		r3,Get_Support_By_Index
_blr	r3
cmp		r0,#8
blt		NextSupport1
mov		r5,#1
b		EndLoop1
NextSupport1:
add		r6,#1
b		Loop1
EndLoop1:
mov		r6,#0
Loop2:
cmp		r6,r7
bge		GoBack
mov		r0,r4
mov		r1,r6
ldr		r3,Get_Support_By_Index
_blr	r3
cmp		r0,#8
bge		NextSupport2
mov		r1,#1
tst		r0,r1
bne		NextSupport2		@if they already have 1 waiting, don't unlock the next
lsr		r1,r0,#1
add		r2,r1,#1				@next level of support
cmp		r2,#4
blt		Label2
cmp		r5,#0
bne		NextSupport2
Label2:
str		r0,[sp]
str		r1,[sp,#4]
mov		r0,r4
mov		r1,r6
ldr		r3,Get_Supporter_Data
_blr	r3
ldr		r1,[sp,#4]
add		r0,#4
add		r0,r1
ldrb	r0,[r0]				@chapter id at which this level of support is unlocked
ldr		r1,=gChapterData
ldrb	r1,[r1,#0xE]
cmp		r0,r1
bgt		NextSupport2
mov		r0,r4
mov		r1,r6
_blh	GetCharIdBySupportIndex
_blh	GetUnitByCharID
cmp		r0,#0
beq		NextSupport2
ldrh	r1,[r0,#0xC]
mov		r2,#4
tst		r1,r2
bne		NextSupport2	@don't support dead units
ldr		r2,[sp]
add		r2,#1
mov		r0,r4
mov		r1,r6
ldr		r3,Set_Support_By_Index
_blr	r3
NextSupport2:
add		r6,#1
b		Loop2
GoBack:
add		sp,#8
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Get_Support_By_Index:
@
