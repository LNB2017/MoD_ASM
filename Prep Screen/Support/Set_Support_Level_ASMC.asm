.thumb
.org 0

.equ Get_Supporter_Data, Setval_Loc+4
.equ Set_Support_By_Index, Get_Supporter_Data+4

@sets character A's support with character B to value C
@SupportWord is in form WORD A | B<<0x8 | C<<0x10

push	{r4-r7,r14}
mov		r7,r8
push	{r7}
ldr		r4,Setval_Loc
ldr		r4,[r4,#4]			@slot 1
mov		r0,#0xFF
and		r0,r4				@character A
ldr		r3,=#0x8017ABD		@find char data ptr given char id
bl		bx_r3
cmp		r0,#0
beq		GoBack
mov		r5,r0
ldr		r3,=#0x8022A85		@get number of supports
bl		bx_r3
mov		r7,r0
mov		r6,#0
lsl		r3,r4,#0x10
lsr		r3,#0x18			@Character B char id
mov		r8,r3
Loop1:
cmp		r6,r7
bge		GoBack
mov		r0,r5
mov		r1,r6
ldr		r3,Get_Supporter_Data
bl		bx_r3
ldrb	r0,[r0]
cmp		r0,r8
beq		WriteSupportPoints
add		r6,#1
b		Loop1
WriteSupportPoints:
mov		r0,r5
mov		r1,r6
lsl		r2,r4,#0x8
lsr		r2,#0x18
ldr		r3,Set_Support_By_Index
bl		bx_r3
GoBack:
pop		{r7}
mov		r8,r7
pop		{r4-r7}
pop		{r0}
bx		r0

bx_r3:
bx		r3

.ltorg
Setval_Loc:
@
