.thumb
.include "_Prep_Screen_Defs.asm"

push	{r14}
ldr		r3,IsCurrentChapterBaseMap
_blr	r3
cmp		r0,#0
beq		GoBack
mov		r0,#1
neg		r0,r0
GoBack:
pop		{r1}
bx		r1

.align
IsCurrentChapterBaseMap:
@
