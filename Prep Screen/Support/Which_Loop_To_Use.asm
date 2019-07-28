.thumb
.include "_Support_Defs.asm"

push	{r14}
mov		r1,r0
add		r1,#Proc_InitialOffset
ldrb	r1,[r1,#Proc_PaneNumber]
mov		r2,#1
tst		r1,r2
beq		GoBack
mov		r1,#0x1A
_blh	GoToProcLabel
GoBack:
pop		{r0}
bx		r0

.ltorg
