.thumb
.include "_Prep_Screen_Defs.asm"

add		r0,#0x2D
ldrb	r0,[r0]
mov		r1,#0
cmp		r0,#1
bne		GoBack
mov		r1,#1
GoBack:
mov		r0,r1
bx		r14
