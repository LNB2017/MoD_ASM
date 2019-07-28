.thumb
.include "_Talk_Defs.asm"

@r0=proc, r1=slot number on screen; should already have already checked if this entry exists

push	{r4-r7,r14}
mov		r4,r0
mov		r6,r1
ldr		r0,[r4,#Proc_TalkEntryPointer]	@pointer to entries
mov		r1,#Proc_ListOfTalks
add		r1,r6
ldrb	r1,[r4,r1]		@slot number
ldr		r3,Get_Talk_Entry
_blr	r3
mov		r7,r0
mov		r0,r6
mov		r1,#(NumberOfEntriesAtOnce+1)
_blh	DivMod
ldr		r5,=InitialTextStruct
lsl		r0,#3
add		r5,r0
ldrh	r0,[r7,#4]		@text id
_blh	GetStringFromIndex
mov		r1,r0
mov		r0,r5
_blh	Text_AppendString
mov		r0,r6
mov		r1,#0x10
_blh	DivMod
lsl		r1,r0,#7
mov		r0,r5
ldr		r4,=(BGLayer0+(TalkBG_X+1)*2)
add		r4,r1
mov		r1,r4
_blh	TextDraw
ldrb	r5,[r7,#2]		@number of stars
add		r4,#(SpaceForText*2)
ldr		r2,=(Star_Tile_Number+(Star_Palette_Bank<<0xC))
add		r3,r2,#1
.if Star_Justifying == 0		@left
	StarLoop:
	cmp		r5,#0
	ble		FinishedDrawing
	strh	r2,[r4]
	mov		r1,r4
	add		r1,#0x40
	strh	r3,[r1]
	add		r4,#2
	sub		r5,#1
	b		StarLoop
.elseif Star_Justifying == 1	@right
	add		r4,#4
	StarLoop:
	cmp		r5,#0
	ble		FinishedDrawing
	strh	r2,[r4]
	mov		r1,r4
	add		r1,#0x40
	strh	r3,[r1]
	sub		r4,#2
	sub		r5,#1
	b		StarLoop
.endif
FinishedDrawing:
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg


.ltorg
Get_Talk_Entry:
@
