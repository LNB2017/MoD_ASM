.thumb
.include "_Prep_Screen_Defs.asm"

push	{r14}
add		r0,#0x2C
ldrb	r0,[r0]
mov		r2,#0
mov		r1,#1
tst		r0,r1
bne		RetMinusOne
ldr		r3,Is_Base_Map
_blr	r3
cmp		r0,#0
bne		RetMinusOne
mov		r0,#0
b		GoBack
RetMinusOne:
mov		r0,#1
neg		r0,r0
GoBack:
pop		{r1}
bx		r1

.align
Is_Base_Map:
@
