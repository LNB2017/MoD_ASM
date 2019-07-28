.thumb

@r0=unit data ptr, r1=index of support partner

add		r0,#0x30	@beginning of supports
lsr		r2,r1,#1
ldrb	r0,[r0,r2]
lsl		r2,r1,#0x1F
cmp		r2,#0
blt		GetTopPart
@if bottom 4 bits
mov		r1,#0xF
and		r0,r1
b		GoBack
GetTopPart:
lsr		r0,r0,#4
GoBack:
bx		r14
