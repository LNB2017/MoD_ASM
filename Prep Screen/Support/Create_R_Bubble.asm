.thumb
.include "_Support_Defs.asm"

@r0=affinity, r1=rank (0-4), r2=x, r3=y

push	{r4-r7,r14}
mov		r4,r0
mov		r5,r1

@initialize the bubble struct thingy (all that's important are the coordinates)
ldr		r6,=RBubbleStruct
strb	r2,[r6,#0x10]
strb	r3,[r6,#0x11]
mov		r1,#0
str		r1,[r6]
str		r1,[r6,#4]
str		r1,[r6,#8]
str		r1,[r6,#0xC]
strh	r1,[r6,#0x12]
str		r1,[r6,#0x14]
str		r1,[r6,#0x18]
ldr		r0,=RBubblePointerToStruct
str		r6,[r0]

@initialize the hand (probably not necessary)
ldr		r0,=RBubbleHandCoords
strh	r1,[r0]
strh	r1,[r0,#2]

ldr		r0,=R_Bubble_Proc
_blh	FindProc
mov		r7,r0
cmp		r7,#0
bne		Label1
@if it doesn't exist, make a new one
ldr		r0,=R_Bubble_Proc
mov		r1,#3
_blh	StartProc
mov		r7,r0
add		r0,#0x52
mov		r1,#0
strb	r1,[r0]				@this allows the "bubble opening" noise to play
mov		r0,r7
ldrb	r1,[r6,#0x10]
ldrb	r2,[r6,#0x11]
_blh	Func_70AFC			@sets 38 and 3A
mov		r0,r7
_blh	Func_70B20			@sets 40 and 42
b		Label2
Label1:
mov		r1,r7
add		r1,#0x30
ldrh	r0,[r1]
strh	r0,[r1,#0x8]
ldrh	r0,[r1,#0x2]
strh	r0,[r1,#0xA]
ldrh	r0,[r1,#0x4]
strh	r0,[r1,#0x10]
ldrh	r0,[r1,#0x6]
strh	r0,[r1,#0x12]
Label2:
str		r6,[r7,#0x2C]
mov		r1,r7
add		r1,#0x48
mov		r0,#0
strh	r0,[r1]			@48
strh	r0,[r1,#6]		@4E
mov		r0,#0xC			@suspect that's the number of frames it takes to fully open the box
strh	r0,[r1,#2]		@4A
ldrh	r0,[r6,#0x12]	@text id, which we're not using
strh	r0,[r1,#4]		@4C
mov		r0,#0
_blh	SetFontGlyphSet
@44 and 46 are length and height of box
mov		r1,r7
add		r1,#0x44
mov		r0,#Affinity_R_Bubble_Length
strh	r0,[r1]
mov		r0,#Affinity_R_Bubble_Height
strh	r0,[r1,#2]
mov		r0,r7
ldrb	r1,[r6,#0x10]
ldrb	r2,[r6,#0x11]
_blh	Func_70A70		@sets 3C and 3E
_blh	Func_71514
ldr		r6,Fill_In_Affinity_Bubble_Proc
mov		r0,r6
_blh	DeleteEachProc
mov		r0,r6
mov		r1,#3
_blh	StartProc
str		r4,[r0,#0x58]
str		r5,[r0,#0x5C]

pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Fill_In_Affinity_Bubble_Proc:
@
