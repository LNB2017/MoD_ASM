.thumb
.include "_Support_Defs.asm"

@r0=bg layer, r1=row number

push	{r4,r14}
mov		r4,r0
mov		r0,r1
mov		r1,#0x10
_blh	DivMod
lsl		r0,#7
add		r0,r4
mov		r1,#0
mov		r2,#0
Loop1:
str		r1,[r0]
add		r0,#4
add		r2,#1
cmp		r2,#0x20
blt		Loop1
pop		{r4}
pop		{r0}
bx		r0

.ltorg
