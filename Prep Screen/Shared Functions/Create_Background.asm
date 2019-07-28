.thumb

@r0=tsa offset, r1=bg buffer address to start drawing to, @r2=palette bank
@tsa has first two bytes as length and height, then shorts to copy

push	{r4-r7,r14}
mov		r5,r1
ldrb	r6,[r0]		@length
ldrb	r7,[r0,#1]	@height
add		r4,r0,#2
lsl		r2,#0xC
Loop1:
mov		r3,r6
mov		r1,r5
Loop2:
ldrh	r0,[r4]
orr		r0,r2
strh	r0,[r1]
add		r4,#2
add		r1,#2
sub		r3,#1
cmp		r3,#0
bgt		Loop2
add		r5,#0x40	@next row
sub		r7,#1
cmp		r7,#0
bgt		Loop1
pop		{r4-r7}
pop		{r0}
bx		r0
