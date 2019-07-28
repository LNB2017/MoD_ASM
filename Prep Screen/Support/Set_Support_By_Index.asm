.thumb

@r0=unit data ptr, r1=index of support partner,r2=value to set it to

add		r0,#0x30	@beginning of supports
lsr		r3,r1,#1
add		r0,r3
ldrb	r3,[r0]
lsl		r1,#0x1F
cmp		r1,#0
blt		TopPart
@if bottom part
lsr		r3,#4
lsl		r3,#4
b		AddSupport
TopPart:
lsl		r3,#0x1C
lsr		r3,#0x1C
lsl		r2,#4
AddSupport:
orr		r3,r2
strb	r3,[r0]
bx		r14
