.thumb
.include "_Support_Defs.asm"

@r0=proc

@returns -1 for left, 0 for none, +1 for right

push	{r4-r7,r14}
add		sp,#-4
str		r0,[sp]
mov		r4,r0
add		r4,#Proc_InitialOffset
ldr		r5,=gpKeyStatus
ldr		r5,[r5]
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
bne		SupportPane

@UnitPane
@Left
ldrh	r0,[r5,#6]
mov		r1,#0x20
tst		r0,r1
beq		UnitRightPress
ldrb	r0,[r4,#Proc_UnitCurrentColumn]
cmp		r0,#0
ble		RetZero
b		RetMinusOne
@Right
UnitRightPress:
ldrh	r0,[r5,#6]
mov		r1,#0x10
tst		r0,r1
beq		RetZero
ldrb	r0,[r4,#Proc_UnitCurrentColumn]
cmp		r0,#1
bge		RetZero
ldrb	r0,[r4,#Proc_UnitCurrentChar]
ldrb	r1,[r4,#Proc_UnitLastCharSlot]
cmp		r0,r1
bge		RetZero
b		RetOne

SupportPane:
@Left
ldrh	r0,[r5,#6]
mov		r1,#0x20
tst		r0,r1
beq		SupportRightPress
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
cmp		r0,#0
ble		RetZero
b		RetMinusOne
@Right
SupportRightPress:
ldrh	r0,[r5,#6]
mov		r1,#0x10
tst		r0,r1
beq		RetZero
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
cmp		r0,#4
bge		RetZero
cmp		r0,#3
blt		RetOne		@if name/C/B, we can go right. If A, need to check if there's an S/A+
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
add		r0,r1
ldr		r0,[r0]
ldrb	r1,[r4,#Proc_SupportCurrentRow]
ldr		r3,Get_Supporter_Data
_blr	r3
ldrb	r0,[r0,#2]
cmp		r0,#0
beq		RetZero
b		RetOne

RetMinusOne:
mov		r0,#1
neg		r0,r0
b		GoBack
RetZero:
mov		r0,#0
b		GoBack
RetOne:
mov		r0,#1
GoBack:
add		sp,#4
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
Get_Supporter_Data:
@
