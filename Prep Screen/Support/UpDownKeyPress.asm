.thumb
.include "_Support_Defs.asm"

@r0=proc

@returns -1 for up, 0 for none, +1 for down

push	{r4-r7,r14}
mov		r4,r0
mov		r6,r4
add		r4,#Proc_InitialOffset
ldr		r5,=gpKeyStatus
ldr		r5,[r5]

ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
bne		SupportPane

@UnitPane
@Up
ldrh	r0,[r5,#6]
mov		r1,#0x40
tst		r0,r1
beq		UnitDownPress
ldrb	r0,[r4,#Proc_UnitCurrentRow]
cmp		r0,#0
ble		RetZero			@if on top row, can't go further
b		RetMinusOne
@Down
UnitDownPress:
ldrh	r0,[r5,#6]
mov		r1,#0x80
tst		r0,r1
beq		RetZero
ldrb	r0,[r4,#Proc_UnitCurrentRow]
ldrb	r1,[r4,#Proc_UnitLastRow]
cmp		r0,r1
blt		RetOne
b		RetZero

SupportPane:
@Up
ldrh	r0,[r5,#6]
mov		r1,#0x40
tst		r0,r1
beq		SupportDownPress
ldrb	r0,[r4,#Proc_SupportCurrentRow]
cmp		r0,#0
ble		RetZero
b		RetMinusOne
@Down
SupportDownPress:
ldrh	r0,[r5,#6]
mov		r1,#0x80
tst		r0,r1
beq		RetZero
ldrb	r0,[r4,#Proc_SupportCurrentRow]
ldrb	r1,[r4,#Proc_SupportLastRow]
cmp		r0,r1
bge		RetZero
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
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
