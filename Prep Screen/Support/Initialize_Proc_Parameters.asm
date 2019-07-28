.thumb
.include "_Support_Defs.asm"

push	{r4,r14}
mov		r4,r0
add		r4,#Proc_InitialOffset

@Gotta do this first, otherwise the layer stuff gets reset
_blh 	ClearAllAndLoadMapGraphics
_blh	PutCameraCoordsOnLord
_blh 	FirstCopyMapGraphicsToBG3
@for R bubble stuff
mov		r0,#0
mov		r1,#0xE	@palette bank
_blh	Func_70E70

ldrb	r0,[r4,#Proc_ResetParameters]
cmp		r0,#1
bne		Label1
@restore layers after returning from playing a support
ldr		r2,=gLCDControlBuffer
mov		r0,#(8*UnitText_X)
neg		r0,r0
strh	r0,[r2,#BG0HOFS]
ldrh	r0,[r4,#Proc_CurrentLayer0]
strh	r0,[r2,#BG0VOFS]
mov		r0,#(8*SupportEntry_X)
neg		r0,r0
strh	r0,[r2,#BG1HOFS]
ldrh	r0,[r4,#Proc_CurrentLayer1]
strh	r0,[r2,#BG1VOFS]

b		GoBack

Label1:
@Unit
mov		r0,#0
strb	r0,[r4,#Proc_PaneNumber]
strb	r0,[r4,#Proc_UnitCurrentChar]
@UnitLastCharSlot set up in Set_Up_Support_Viewer
strb	r0,[r4,#Proc_UnitTopRow]
@UnitLastRow set up in Set_Up_Support_Viewer
strb	r0,[r4,#Proc_UnitCurrentRow]
strb	r0,[r4,#Proc_UnitCurrentColumn]
@Sprites
strb	r0,[r4,#Proc_CursorTimer]
mov		r0,#(8*(UnitText_X-2)-4)
strb	r0,[r4,#Proc_UnitHandX]
mov		r0,#(8*UnitText_Y)
strb	r0,[r4,#Proc_UnitHandY]
@Layer stuff
ldr		r2,=gLCDControlBuffer
mov		r0,#(8*UnitText_X)
neg		r0,r0
strh	r0,[r2,#BG0HOFS]
mov		r0,#(8*UnitText_Y)
neg		r0,r0
strh	r0,[r2,#BG0VOFS]
strh	r0,[r4,#Proc_CurrentLayer0]
strh	r0,[r4,#Proc_NewLayer0]

@Support
mov		r0,r4
ldr		r3,Reset_Support_Pane_Parameters
_blr	r3

GoBack:
pop		{r4}
pop		{r0}
bx		r0

.ltorg
Reset_Support_Pane_Parameters:
@
