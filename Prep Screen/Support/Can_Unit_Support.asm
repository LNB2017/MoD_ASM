.thumb

.equ origin, 0x22BA4

@r0=unit ptr, r1=index in support data of person to support with

push	{r14}
ldr		r2,=#0x202AA48
ldrb	r2,[r2,#0x14]
mov		r3,#0x28
tst		r2,r3
bne		RetFalse		@no idea what these bits are
ldr		r3,Get_Support_By_Index
bl		bx_r3
mov		r1,#1
and		r0,r1			@if bottom bit is set, there's a support ready
b		GoBack
RetFalse:
mov		r0,#0
GoBack:
pop		{r1}
bx		r1

bx_r3:
bx		r3

.ltorg
Get_Support_By_Index:
@
