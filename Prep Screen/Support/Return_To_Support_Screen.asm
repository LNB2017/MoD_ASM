.thumb
.include "_Support_Defs.asm"

push	{r4-r5,r14}
mov		r4,r0
add		r4,#Proc_InitialOffset
mov		r5,r0

ldrb	r0,[r4,#Proc_IsNewSupport]
cmp		r0,#0
bne		Label1
ldr		r0,SupportViewedEventID
_blh	UnsetEventID
mov		r0,#0
strb	r0,[r4,#Proc_IsNewSupport]
Label1:
mov		r0,#1
strb	r0,[r4,#Proc_ResetParameters]
mov		r0,r5
mov		r1,#0
_blh	GoToProcLabel

pop		{r4-r5}
pop		{r0}
bx		r0

.ltorg
SupportViewedEventID:
@
