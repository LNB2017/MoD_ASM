.thumb
.include "_Support_Defs.asm"

@r0=proc

push	{r4-r6,r14}
mov		r4,r0
mov		r6,r4
add		r4,#Proc_InitialOffset

ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#2
and		r0,r1
cmp		r0,#0
beq		GoBack
ldr		r0,=gpKeyStatus
ldr		r0,[r0]
ldrh	r0,[r0,#8]
mov		r1,#0x81
lsl		r1,#1			@R or B closes the bubble
and		r0,r1
cmp		r0,#0
beq		GoBack

_blh	CloseRBubble
ldr		r0,Fill_In_Affinity_Bubble_Proc
_blh	DeleteEachProc	@just in case, although it should be done by this point
ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#0xFD
and		r0,r1
strb	r0,[r4,#Proc_PaneNumber]
mov		r0,#1

GoBack:
pop		{r4-r6}
pop		{r1}
bx		r1

.ltorg
Fill_In_Affinity_Bubble_Proc:
@
