.thumb
.include "_Support_Defs.asm"

@r0 = unit pointer

push	{r4-r6,r14}
mov		r4,r0
_blh	GetNumberOfSupports
cmp		r0,#0
beq		GoBack
mov		r6,r0
mov		r5,#0
SupportLoop:
mov		r0,r4
mov		r1,r5
_blh	CanUnitSupportByIndex
cmp		r0,#0
bne		GoBack
@if no support, get next one
add		r5,#1
cmp		r5,r6
blt		SupportLoop
mov		r0,#0
GoBack:
pop		{r4-r6}
pop		{r1}
bx		r1

.ltorg
