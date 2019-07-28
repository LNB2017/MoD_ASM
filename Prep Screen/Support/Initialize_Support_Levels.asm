.thumb
.include "_Support_Defs.asm"

.equ Set_Support_By_Index, Get_Supporter_Data+4
@r0=unit pointer

push	{r4-r6,r14}
mov		r5,r0
_blh	GetNumberOfSupports
mov		r6,r0
mov		r4,#0
SupportLoop:
cmp		r4,r6
bge		GoBack
mov		r0,r5
mov		r1,r4
ldr		r3,Get_Supporter_Data
_blr	r3
ldrb	r2,[r0,#1]		@initial level
mov		r0,r5
mov		r1,r4
ldr		r3,Set_Support_By_Index
_blr	r3
add		r4,#1
b		SupportLoop
GoBack:
pop		{r4-r6}
pop		{r0}
bx		r0

.ltorg
Get_Supporter_Data:
@
