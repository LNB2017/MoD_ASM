.thumb

.equ origin, 0xD8AC
.equ Func_14728, . + 0x14728 - origin

push	{r14}
ldr		r1,[r0,#0x14]	@proc parent, which is event proc in this case
add		r1,#0x46
ldrb	r1,[r1]
mov		r2,#4
tst		r1,r2
bne		SkipFunc
ldr		r1,=#0x202AA48
ldrb	r1,[r1,#0x14]
mov		r2,#0x10
tst		r1,r2
bne		SkipFunc
bl		Func_14728
SkipFunc:
pop		{r0}
bx		r0

.ltorg
