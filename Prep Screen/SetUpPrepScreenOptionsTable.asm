.thumb
.include "_Prep_Screen_Defs.asm"

@copies the relevant options to ram. no idea why this wasn't a table to begin with
@r0=proc

.equ origin, 0x79424
.equ CreatePrepScreenTableEntryInRAM, . + 0x7CC34 - origin
.equ bx_r2, . + 0x9DF18 - origin

push	{r4-r5,r14}
add		sp,#-8
mov		r4,r0
ldr		r5,PrepScreenOptionsTable
TableLoop:
ldr		r2,[r5]			@usability routine; returns -1 to not display, otherwise r0=palette index
cmp		r2,#0
blt		LoopFinished	@0xFFFFFFFF is the terminator
mov		r3,#0			@palette (0=white, if anything else, the usability routine returns it)
cmp		r2,#0
beq		StoreEntry
mov		r0,r4
bl		bx_r2
cmp		r0,#0
blt		NextEntry
mov		r3,r0
StoreEntry:
ldrh	r0,[r5,#0xA]	@r-button text
str		r0,[sp]
ldrb	r0,[r5,#0xC]	@whatever this is
str		r0,[sp,#4]
ldr		r0,[r5,#4]		@effect routine (what happens when you press A)
ldrb	r1,[r5,#0xD]	@bool to not display (0=show, 1=hide)
ldrh	r2,[r5,#8]		@display text id
bl		CreatePrepScreenTableEntryInRAM
NextEntry:
add		r5,#0x10
b		TableLoop
LoopFinished:
add		sp,#8
pop		{r4-r5}
pop		{r0}
bx		r0

.align
PrepScreenOptionsTable:
@
