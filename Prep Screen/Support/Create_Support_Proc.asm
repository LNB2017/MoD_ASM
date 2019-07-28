.thumb
.include "_Support_Defs.asm"

push	{r4,r14}
mov		r4,r0
ldr		r0,[r4,#0x58]	@not sure
_blh	EndProc
ldr		r0,Support_Proc
mov		r1,r4
_blh	StartBlockingProc
add		r0,#(Proc_InitialOffset + Proc_ResetParameters)
mov		r1,#0
strb	r1,[r0]
mov		r0,r4
_blh	0x807ACE8		@blocks sprites? idk
pop		{r4}
pop		{r0}
bx		r0

.ltorg
Support_Proc:
@
