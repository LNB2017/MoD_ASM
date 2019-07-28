.thumb
.include "_Talk_Defs.asm"

push	{r4,r14}
mov		r4,r0
_blh	0x807A59C		@not sure (redisplays the prep screen options and stuff?)
ldr		r0,[r4,#0x50]
mov		r1,#0
_blh	GoToProcLabel	@restores the sprites (banner, pointer thingy, and hand)
mov		r0,r4
mov		r1,#0xF
_blh	GoToProcLabel	@maybe go to label 0xF if this doesn't work (0xC/0xF/1 seem to be options)
pop		{r4}
pop		{r0}
bx		r0

.ltorg
