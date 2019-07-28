.thumb
.include "_Support_Defs.asm"

.equ Get_Supporter_Data, Create_R_Bubble+4

push	{r4-r7,r14}
add		sp,#-4
str		r0,[sp]
mov		r4,r0
add		r4,#Proc_InitialOffset

ldrb	r0,[r4,#Proc_PaneNumber]
mov		r1,#2
orr		r0,r1
strb	r0,[r4,#Proc_PaneNumber]
mov		r1,#1
tst		r0,r1
bne		SupportRBubble

@UnitRBubble
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
add		r0,r1
ldr		r0,[r0]
ldr		r0,[r0]					@char data
ldrb	r0,[r0,#9]				@affinity
mov		r1,#1					@show C rank
ldrb	r2,[r4,#Proc_UnitHandX]
ldrb	r3,[r4,#Proc_UnitHandY]
@add		r3,#4
b		CallCreateBubble

SupportRBubble:
ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
add		r0,r1
ldr		r5,[r0]					@r5=current unit data
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
_blh	GetCharIdBySupportIndex
mov		r6,r0
_blh	GetUnitByCharID
mov		r7,r0					@r7=partner's unit data
cmp		r7,#0
bne		Label1
mov		r0,r6
_blh	GetCharacterData
b		Label2
Label1:
ldr		r0,[r0]
Label2:
ldrb	r6,[r0,#9]				@r6=affinity
ldrb	r0,[r4,#Proc_SupportCurrentColumn]
cmp		r0,#0
bne		Label3
@if 0, get current rank
cmp		r7,#0
beq		Label3			@if partner doesn't exist yet, rank = 0 (shows --)
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
_blh	GetSupportLevelByIndex
Label3:					@r0 = rank
cmp		r0,#4
blt		Label4
@if 4, we need to figure out if it's A+ or S. If A+, put 4, if S, put 5.
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
ldr		r3,Get_Supporter_Data
_blr	r3
ldrb	r0,[r0,#2]		@0 for none, 1 for A+, 2 for S
cmp		r0,#3
bne		Label5
mov		r0,#2			@if we got here, then that means there must be an S support (this is Hector/Lyn or Eliwood/Lyn)
Label5:
add		r0,#3
Label4:
mov		r1,r0
mov		r0,r6
ldrb	r2,[r4,#Proc_SupportHandX]
ldrb	r3,[r4,#Proc_SupportHandY]
@add		r3,#

CallCreateBubble:
ldr		r6,Create_R_Bubble
_blr	r6
add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Create_R_Bubble:
@
