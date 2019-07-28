.thumb
.include "_Talk_Defs.asm"

push	{r4-r5,r14}
mov		r4,r0
ldr		r0,=gChapterData
add		r0,#Option2Byte
ldrb	r0,[r0]
lsl		r0,#0x1E
cmp		r0,#0
blt		SoundDone
mov		r0,#MenuSelectNoise
_blh	PlaySound
SoundDone:
ldr		r0,[r4,#Proc_TalkEntryPointer]
ldrh	r1,[r4,#Proc_CurrentSlot]
add		r1,#Proc_ListOfTalks
add		r1,r4
ldrb	r1,[r1]
ldr		r3,Get_Talk_Entry
_blr	r3
mov		r5,r0
ldrb	r0,[r5,#1]		@event id to set
_blh	SetEventID
ldr		r0,[r5,#8]
mov		r1,r4
_blh	CallEventEngineWithProc
pop		{r4-r5}
pop		{r0}
bx		r0

.ltorg
Get_Talk_Entry:
@
