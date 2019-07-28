.thumb

@inserted at E288
@if on the prep screen, don't start a specific proc which shows the map briefly

.equ origin, 0xE288
.equ Func_D85C, . + 0xD85C - origin

push	{r4,r14}
mov		r4,r0
add		r0,#0x46
ldrb	r0,[r0]
mov		r1,#4		@seems to indicate start button was pressed
tst		r0,r1
beq		RetZero		@didn't press Start, so no issues
ldr		r0,=#0x202AA48
ldrb	r0,[r0,#0x14]
mov		r1,#0x10
tst		r0,r1
bne		Label1		@if prep screen, skip the proc that shows the map briefly
mov		r0,r4
bl		Func_D85C
Label1:
add		r4,#0x44
mov		r0,#0xFF
strb	r0,[r4]
mov		r0,#2
b		GoBack
RetZero:
mov		r0,#0
GoBack:
pop		{r4}
pop		{r1}
bx		r1

.ltorg
