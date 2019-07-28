.thumb

@r0=unit ptr, r1=index

push	{r4-r7,r14}
mov		r4,r0
mov		r5,r1
ldr		r3,Get_Support_By_Index
bl		bx_r3
add		r6,r0,#1
mov		r0,r4
mov		r1,r5
mov		r2,r6
ldr		r3,Set_Support_By_Index
bl		bx_r3

@EDIT THIS PART TO CHECK IF THE NEXT LEVEL IS AVAILABLE

cmp		r6,#8
blt		GoBack
@if S/A+, remove any other potential S/A+ conversations
mov		r0,r4
ldr		r3,=#0x8022A85		@gets number of support partners
bl		bx_r3
mov		r7,r0
SupportLoop:
cmp		r7,#0
blt		GoBack
cmp		r7,r5
beq		CheckNextSupport
mov		r0,r4
mov		r1,r7
ldr		r3,Get_Support_By_Index
bl		bx_r3
cmp		r0,#7
bne		CheckNextSupport
mov		r0,r4
mov		r1,r7
mov		r2,#6
ldr		r3,Set_Support_By_Index
bl		bx_r3
CheckNextSupport:
sub		r7,#1
b		SupportLoop
GoBack:
pop		{r4-r7}
pop		{r0}
bx		r0

bx_r3:
bx		r3

.ltorg
.equ Set_Support_By_Index, Get_Support_By_Index+4
Get_Support_By_Index:
@
