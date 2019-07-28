.thumb
.include "_Prep_Screen_Defs.asm"

push	{r14}
add		r0,#0x2C
ldrb	r0,[r0]
mov		r1,#1
tst		r0,r1
bne		RetMinusOne
ldr		r0,=#0x202AA48
ldrb	r0,[r0,#0x14]
mov		r1,#0x20			@normally 60, to include not showing up on hard mode, but I'm removing this
tst		r0,r1
bne		RetMinusOne
mov		r0,#0
b		GoBack
RetMinusOne:
mov		r0,#1
neg		r0,r0
GoBack:
pop		{r1}
bx		r1

.ltorg
