.thumb
.include "_Prep_Screen_Defs.asm"

push	{r4,r14}
mov		r4,r0

ldr		r0,[r4,#0x58]	@not sure
_blh	EndProc

ldr		r0,=gChapterData
ldrb	r0,[r0,#0xE]
_blh	GetChapterEvents
ldr		r0,[r0,#0x18]		@ending events
@ldr		r0,EndEvents
mov		r1,r4
_blh	CallEventEngineWithProc

mov		r0,r4
_blh	0x807ACE8		@blocks sprites? idk

pop		{r4}
pop		{r0}
bx		r0

.ltorg
EndEvents:
@
