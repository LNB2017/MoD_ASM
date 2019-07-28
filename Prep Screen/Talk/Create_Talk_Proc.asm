.thumb
.include "_Talk_Defs.asm"

push	{r4,r14}
mov		r4,r0
ldr		r0,[r4,#0x58]	@not sure
_blh	EndProc
ldr		r0,Talk_Proc
mov		r1,r4
_blh	StartBlockingProc
mov		r1,#0
strh	r1,[r0,#Proc_DoNotResetParametersBool]
mov		r0,r4
_blh	0x807ACE8		@blocks sprites? idk
pop		{r4}
pop		{r0}
bx		r0

.ltorg
Talk_Proc:
@
