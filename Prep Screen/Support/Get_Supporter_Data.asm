.thumb
.include "_Support_Defs.asm"

@r0=unit data, r1=support id

push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
_blh	GetNumberOfSupports
cmp		r0,r5
ble		RetZero
ldr		r0,[r4]
ldr		r0,[r0,#0x2C]
add		r0,#4
mov		r1,#0x18
mul		r1,r5
add		r0,r1
b		GoBack
RetZero:
mov		r0,#0
GoBack:
pop		{r4-r5}
pop		{r1}
bx		r1

.ltorg
