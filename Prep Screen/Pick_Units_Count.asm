.thumb

push	{r14}
cmp		r0,#0
bne		GoBack
ldr		r3,Is_Base_Map
mov		r14,r3
.short	0xF800
cmp		r0,#0
bne		GoBack
mov		r0,r6
ldr		r3,=#0x8079EA0
mov		r14,r3
.short	0xF800
GoBack:
mov		r0,#7
pop		{r1}
bx		r1

.ltorg
Is_Base_Map:
@
