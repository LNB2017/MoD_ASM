.thumb
.include "_Support_Defs.asm"

push	{r4-r7,r14}
mov		r7,r0
mov		r4,r7
add		r4,#Proc_InitialOffset

@clear layer 0
ldr		r0,=BGLayer1
mov		r1,#0
_blh	ClearLayer

@initialize things for the support pane
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
add		r0,r1
ldr		r0,[r0]
_blh	GetNumberOfSupports
strb	r0,[r4,#Proc_NumberOfSupports]
cmp		r0,#0
beq		UpdateBG
sub		r0,#1
strb	r0,[r4,#Proc_SupportLastRow]

@draw each row
ldrb	r5,[r4,#Proc_SupportTopRow]
mov		r6,r5
add		r6,#(NumberOfSupports-1)
ldrb	r0,[r4,#Proc_SupportLastRow]
cmp		r0,r6
bge		DrawSupportLoop
mov		r6,r0
DrawSupportLoop:
mov		r0,r7
mov		r1,r5
ldr		r3,Draw_Support_Row
_blr	r3
add		r5,#1
cmp		r5,r6
ble		DrawSupportLoop

UpdateBG:
mov		r0,#3
_blh	EnableBGSyncByMask

pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Draw_Support_Row:
@
