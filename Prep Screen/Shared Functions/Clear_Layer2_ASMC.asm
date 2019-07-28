.thumb
.include "../_Prep_Screen_Defs.asm"

@clears layer 2

push	{r14}
ldr		r0,=(gLCDControlBuffer+BG2CNT)
ldrb	r1,[r0]
mov		r2,#0xF3
and		r1,r2
strb	r1,[r0]		@Starting address of character tile data
ldr		r0,=BGLayer2
mov		r1,#0
_blh	ClearLayer
mov		r0,#4
_blh	EnableBGSyncByMask
pop		{r0}
bx		r0

.ltorg
