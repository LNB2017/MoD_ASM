.thumb
.include "_Prep_Screen_Defs.asm"

@r0=proc

push	{r4,r14}
mov		r4,r0
add		r0,#0x29
ldrb	r0,[r0]
cmp		r0,#0
bne		GoBack		@don't want this showing up on Page 1
mov		r0,r4
mov		r1,#0x11	@Label
_blh	GoToProcLabel
ldr		r0,=gChapterData
add		r0,#Option2Byte
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0
blt		GoBack
mov		r0,#MenuSelectNoise
_blh	PlaySound
GoBack:
pop		{r4}
pop		{r0}
bx		r0

.ltorg
