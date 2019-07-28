.thumb
.include "_Support_Defs.asm"

push	{r4,r14}
mov		r1,r0
add		r1,#(Proc_InitialOffset+Proc_IsNewSupport)
ldrb	r1,[r1]
cmp		r1,#0
beq		Label1
mov		r4,r0
_blh	ClearLayer0And1
ldr		r0,=BGLayer2
mov		r1,#0
_blh	ClearLayer
mov		r0,#7
_blh	EnableBGSyncByMask
mov		r0,r4
_blh	DisplaySupportIncreasedPopup
Label1:
pop		{r4}
pop		{r0}
bx		r0

.ltorg
