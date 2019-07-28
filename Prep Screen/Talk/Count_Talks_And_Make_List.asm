.thumb
.include "_Talk_Defs.asm"

@r0=address to write table addres, followed by the list, or -1 if no list to make

push	{r4-r7,r14}
add		sp,#-8
mov		r4,r0
mov		r6,#0			@number of talks available
mov		r7,#0			@entry number, for storing (if necessary)
ldr		r0,=gChapterData
ldrb	r0,[r0,#0xE]
lsl		r0,#2
ldr		r1,Chapter_Talk_Pointer_Table
add		r0,r1
ldr		r5,[r0]
cmp		r5,#0
beq		GoBack
cmp		r4,#0
blt		TalkLoop
str		r5,[r4]
add		r4,#4
TalkLoop:
ldr		r0,[r5]
mov		r1,#1
cmn		r0,r1
beq		GoBack			@-1 is the terminator
ldrb	r0,[r5]			@event id to check; if not set, don't display
cmp		r0,#0
beq		IsTalkDone
_blh	CheckEventID
cmp		r0,#0
beq		NextTalk
IsTalkDone:
ldrb	r0,[r5,#1]		@this talk's event id; if set, don't display
cmp		r0,#0
beq		CheckIfCharsAreAlive
_blh	CheckEventID
cmp		r0,#0
bne		NextTalk
CheckIfCharsAreAlive:
mov		r0,r5
add		r0,#0xC
str		r0,[sp]
mov		r1,#0
str		r1,[sp,#4]
CharLoop:
ldr		r0,[sp]
ldrb	r0,[r0]
cmp		r0,#0
beq		StoreTalk
_blh	GetUnitByCharID
cmp		r0,#0
beq		NextTalk		@if unit doesn't exist, next
ldrh	r1,[r0,#0xC]
mov		r2,#4
tst		r1,r2
bne		NextTalk		@if unit is dead, next
ldr		r0,[sp]
add		r0,#1
str		r0,[sp]
ldr		r0,[sp,#4]
add		r0,#1
str		r0,[sp,#4]
cmp		r0,#8
blt		CharLoop
StoreTalk:
add		r6,#1
cmp		r4,#0
blt		GoBack			@if -1, we only want to check if there's at least 1 talk
cmp		r6,#40			@limit of talks to show, to not overflow the space provided
bge		GoBack			@we'll just stop here
strb	r7,[r4]
add		r4,#1
NextTalk:
add		r7,#1
add		r5,#LengthOfTalkEntry
b		TalkLoop
GoBack:
mov		r0,r6
add		sp,#8
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
Chapter_Talk_Pointer_Table:
@
