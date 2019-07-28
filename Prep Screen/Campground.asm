.thumb

.equ Campground_Graphics, Is_Base_Map+4

@r0=normal battleground graphics pointer

push	{r4,r14}
mov		r4,r0
ldr		r3,Is_Base_Map
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		Label1
ldr		r4,Campground_Graphics
Label1:
mov		r0,r4
ldr		r1,=#0x6017000
ldr		r3,=#0x8013CA4		@lz77 decompress
mov		r14,r3
.short	0xF800
ldr		r0,=#0x8326E64		@palette
mov		r1,#0xB0
lsl		r1,#2
pop		{r4}
pop		{r2}
bx		r2

.ltorg
Is_Base_Map:
@
