.thumb
.include "_Augury_Defs.asm"

.global Create_Augury_Proc
.global Set_Up_Augury_Proc
.global SetUpAuguryTextStuff
.global Draw_Augury_Text_Layer0
.global Draw_Augury_Text_Layer1
.global Draw_Augury_Text_Layer2
.global Augury_KeypressCheckAndSprites


Create_Augury_Proc:
push	{r4,r14}
mov		r4,r0
ldr		r0,[r4,#0x58]	@not sure
_blh	EndProc
ldr		r0,=Augury_Proc
mov		r1,r4
_blh	StartBlockingProc
@mov		r1,#0
@strh	r1,[r0,#Proc_DoNotResetParametersBool]
mov		r0,r4
_blh	0x807ACE8		@blocks sprites? idk
pop		{r4}
pop		{r0}
bx		r0
.ltorg



Set_Up_Augury_Proc:
@ r0=proc pointer
push    {r4-r7,r14}
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset
	@ clear all 
mov     r0,#0
_blh    #0x80026BC
	@ red background graphics
ldr     r0,=#0x8336D5C       
ldr     r1,=#0x6008000       
_blh    Decompress
	@ red background palette
ldr		r0,=gChapterData
ldrb	r0,[r0,#0x14]
mov		r1,#0x40
tst		r0,r1
beq		Aug_LoadNormalPalette
ldr     r0,=#0x833C01C
b		Aug_PaletteFound
Aug_LoadNormalPalette:
ldr		r0,=Augury_Alt_BG_Palette
Aug_PaletteFound:
mov     r1,#(Augury_BG_Layer_Palette<<5) @*0x20  
mov     r2,#0x20
_blh    CopyToPaletteBuffer
	@ red background construction
ldr     r0,=BGLayer3
mov     r1,#(Augury_BG_Layer_Palette<<4) @*0x10
lsl     r1,#8
_blh    #0x8090854      @function that draws the augury background on given layer r0 with palette r1
	@ load ui graphics (for the hand sprite)
_blh	LoadObjUIGfx
	@ Initialize augury graphics
ldr     r0,=Augury_Graphics
ldr     r1,=#(0x6010000+0x20*Augury_Graphics_Tile_Number)
_blh    Decompress
ldr     r0,=Augury_Palette
mov     r1,#(Augury_Graphics_Palette_Bank+0x10)
lsl     r1,#5
mov     r2,#0x20    @length
_blh    CopyToPaletteBuffer
	@ set up sprite transparency for the box under the explanation
ldr		r0,=gLCDControlBuffer
mov		r1,#BLDCNT
ldr		r2,=#0x830	@sprites onto layer 3
strh	r2,[r0,r1]
mov		r1,#BLDALPHA
ldr		r2,=#0x070E	@coefficients; 6 is for sprite, E for layer 3
strh	r2,[r0,r1]
b		SkipLiteralPool1
.ltorg
SkipLiteralPool1:
	@ proc initialization
mov     r0,#0
strb    r0,[r4,#Proc_RowNumber]    @current row for bottow text
mov     r0,#(8*(4))
strb    r0,[r4,#Proc_HandY]    @current y pixel position for the hand
mov		r0,#0
strb	r0,[r4,#Proc_GoalLetter]	@ start at A
strh	r0,[r4,#Proc_SpriteTimer]
ldr     r5,=gChapterData
ldrb    r5,[r5,#0xE] @loading current chapter
strb    r5,[r4,#Proc_LatestChapter]
mov		r0,r5
_blh	Is_Base_Map			@ defined elsewhere
cmp		r0,#0
beq		Aug_StoreDisplayChapter
	@ if it is a base map, get the next non-base map
mov		r0,r5
mov		r1,#1
bl		GetNextNonBaseMap
mov		r5,r0
Aug_StoreDisplayChapter:
strb    r5,[r4,#Proc_DisplayChapter]
_blh    0x808F470 @function that gets the win ratio for combat rank
strb    r0,[r4,#Proc_CombatRatio]
ldr		r3,=Augury_CombatRankValuesTable
mov		r1,#0
CombatRankLoop:
ldrb	r2,[r3]
cmp		r0,r2
bge		End_CombatRankLoop
add		r3,#1
add		r1,#1
cmp		r1,#4
blt		CombatRankLoop
End_CombatRankLoop:
strb	r1,[r4,#Proc_CombatRank]
_blh    0x808F4F0 @function that gets the number of killed units for survival rank
strb    r0,[r4,#Proc_Losses]
ldr		r3,=Augury_SurvivalRankValuesTable
mov		r1,#0
SurvivalRankLoop:
ldrb	r2,[r3]
cmp		r0,r2
ble		End_SurvivalRankLoop
add		r3,#1
add		r1,#1
cmp		r1,#4
blt		SurvivalRankLoop
End_SurvivalRankLoop:
strb	r1,[r4,#Proc_SurvivalRank]
_blh    0x808F30C @function that gets the current turncount for tactics rank
strh    r0,[r4,#Proc_TurnCount]
mov		r5,r0
mov		r6,#0
TacticsRankLoop:
ldrb	r0,[r4,#Proc_LatestChapter]
mov		r1,#Tactics
mov		r0,r6
bl		RankValueGetter
cmp		r5,r0
ble		End_TacticsRankLoop
add		r6,#1
cmp		r6,#4
blt		TacticsRankLoop
End_TacticsRankLoop:
strb	r6,[r4,#Proc_TacticsRank]
_blh    0x808F648 @function that gets the sum of levels in the whole army for power rank
strh    r0,[r4,#Proc_TotalLevels]
mov		r5,r0
mov		r6,#0
PowerRankLoop:
ldrb	r0,[r4,#Proc_LatestChapter]
mov		r1,#Power
mov		r0,r6
bl		RankValueGetter
cmp		r5,r0
bge		End_PowerRankLoop
add		r6,#1
cmp		r6,#4
blt		PowerRankLoop
End_PowerRankLoop:
strb	r6,[r4,#Proc_PowerRank]
_blh    0x8084D34 @function that gets the sum of experience in the whole army for Exp rank
str     r0,[r4,#Proc_TotalExp]
mov		r5,r0
mov		r6,#0
ExpRankLoop:
ldrb	r0,[r4,#Proc_LatestChapter]
mov		r1,#Experience
mov		r0,r6
bl		RankValueGetter
cmp		r5,r0
bge		End_ExpRankLoop
add		r6,#1
cmp		r6,#4
blt		ExpRankLoop
End_ExpRankLoop:
strb	r6,[r4,#Proc_ExpRank]
_blh    0x8017104 @function that gets the total funds (gold + sale worth of all items) for funds rank 
str     r0,[r4,#Proc_TotalFunds]
mov		r5,r0
mov		r6,#0
FundsRankLoop:
ldrb	r0,[r4,#Proc_LatestChapter]
mov		r1,#Funds
mov		r0,r6
bl		RankValueGetter
cmp		r5,r0
bge		End_FundsRankLoop
add		r6,#1
cmp		r6,#4
blt		FundsRankLoop
End_FundsRankLoop:
strb	r6,[r4,#Proc_FundsRank]
adr		r3,OverallRankingTable1
ldrb	r0,[r4,#Proc_TacticsRank]
ldrb	r2,[r3,r0]
add		r3,#5
ldrb	r0,[r4,#Proc_SurvivalRank]
ldrb	r1,[r3,r0]
add		r2,r1
add		r3,#5
ldrb	r0,[r4,#Proc_FundsRank]
ldrb	r1,[r3,r0]
add		r2,r1
add		r3,#5
ldrb	r0,[r4,#Proc_CombatRank]
ldrb	r1,[r3,r0]
add		r2,r1
add		r3,#5
ldrb	r0,[r4,#Proc_ExpRank]
ldrb	r1,[r3,r0]
add		r2,r1
add		r3,#5
ldrb	r0,[r4,#Proc_PowerRank]
ldrb	r1,[r3,r0]
add		r2,r1
adr		r3,OverallRankTable2
mov		r1,#0
sub		r1,#1
OverallRankLoop:
ldrh	r0,[r3]
cmp		r2,r0
bge		End_OverallRankLoop
add		r3,#2
add		r1,#1
cmp		r1,#4
blt		OverallRankLoop
End_OverallRankLoop:
cmp		r1,#0
bge		Label438929832
mov		r1,#5
Label438929832:
strb	r1,[r4,#Proc_OverallRank]
	@ not returning anything, pop and bx r0
pop     {r4-r7}
pop     {r0}
bx      r0
.ltorg
OverallRankingTable1:
.byte 200, 160, 120, 80, 40
.byte 95, 75, 55, 35, 15
.byte 80, 60, 40, 20, 0
.byte 90, 70, 50, 30, 10
.byte 80, 60, 40, 20, 0
.byte 85, 65, 45, 25, 5
.align
OverallRankTable2:
.short 630, 530, 390, 250, 120, 0


SetUpAuguryTextStuff:
push	{r4-r7,r14}
mov		r4,r0
	@ TODO: Load custom text palette
_blh	Font_InitDefault
	@ Initialize certain text structs
ldr     r5,=InitialTextStruct
mov		r0,r5
mov     r1,#DescriptionTileSpace
_blh    TextInit
add		r5,#8
mov		r0,r5
mov		r1,#1
_blh	TextInit
mov		r0,r5
adr		r1,Aug_PercentSignText
_blh	Text_AppendString
add		r5,#8
mov		r0,r5
mov		r1,#1
_blh	TextInit
mov		r0,#2
strb	r0,[r5,#2]		@ update x coord manually because I'm too lazy to call the proper function for this
mov		r0,r5
adr		r1,Aug_MinusSignText
_blh	Text_AppendString
add		r5,#8
mov		r0,r5
mov		r1,#1
_blh	TextInit
mov		r0,#3
strb	r0,[r5,#3]		@ update palette manually
mov		r0,r5
adr		r1,Aug_xText
_blh	Text_AppendString
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg
Aug_PercentSignText:
.byte 0x82, 0xC3, 0, 0
Aug_MinusSignText:
.byte 0x82, 0xCF, 0, 0
Aug_xText:
.byte 0x82, 0xB0, 0, 0

Draw_Augury_Text_Layer0:
	@ r0=proc pointer
push    {r4-r7,r14}
add		sp,#-8
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset
ldr     r6,=Augury_Attributes_Table
AugLayer0_begin_loop:
	@ check if there's an entry
ldr     r0,[r6]
cmp     r0,#0
beq     AugLayer0_end_loop
	@ Augury_Attributes_Table_Entry(x_coord, y_coord, text_color, number_of_tiles, text_pointer)
ldrb    r0,[r6,#3]
str		r0,[sp]
ldr		r0,[r6,#4]
str		r0,[sp,#4]
mov		r0,#0
ldrb    r2,[r6]
ldrb    r3,[r6,#1]
lsl     r2,#1
lsl     r3,#6
ldr     r1,=BGLayer0
add     r1,r2
add     r1,r3
ldrb    r2,[r6,#2]
mov		r3,#0
_blh	DrawTextInline,r5		@r0 = Text Struct (0 for temporary), r1 = Output tile pointer root, r2 = color id, r3 = local x start, [sp] = tile width, [sp+4] = String pointer			
add     r6,#8
b       AugLayer0_begin_loop
AugLayer0_end_loop:
ldr		r6,=Augury_OtherLayer0Stuff
AugLayer0_Loop2:
ldr		r0,[r6]
cmp		r0,#0
beq		End_AugLayer0_Loop2
mov		r1,r7
ldr		r5,[r6,#4]
bl		bx_r5
add		r6,#8
b		AugLayer0_Loop2
End_AugLayer0_Loop2:
add		sp,#8
pop     {r4-r7}
pop     {r0}
bx      r0
.ltorg

bx_r5:
bx		r5
.align


Draw_Augury_Text_Layer1:
push	{r4-r7,r14}
mov		r4,r0
mov		r7,r4
add     r4,#Proc_InitialOffset
ldr		r0,=BGLayer1
mov		r1,#0
_blh	FillBgMap
ldr		r6,=Augury_Layer1Stuff
AugLayer1_Loop:
ldr		r0,[r6]
cmp		r0,#0
beq		End_AugLayer1_Loop
mov		r1,r7
ldr		r5,[r6,#4]
bl		bx_r5
add		r6,#8
b		AugLayer1_Loop
End_AugLayer1_Loop:
mov     r0,#2
_blh    EnableBGSyncByMask
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg


Draw_Augury_Text_Layer2:
	@ r0=proc pointer
push    {r4-r7,r14}
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset
ldr     r5,=InitialTextStruct
ldr     r6,=Rank_Description_Table
mov		r0,r5
_blh	TextClear
	@ call TextAppend with r0=text struct, r1=pointer to text
mov     r0,r5
ldrb    r1,[r4,#Proc_RowNumber]
lsl     r1,#2 @each entry of the table is 4 bytes
ldr     r1,[r6,r1]
_blh    Text_AppendString
	@ Call TextDraw with r0=text struct, r1=bg2 + x<<1 + y<<6*/
mov     r0,r5
ldr     r1,=(BGLayer2 + 0x40*DescriptionY + 2*DescriptionX)
_blh    TextDraw
	@ Updating BGLayer2 on vblank
mov     r0,#4
_blh    EnableBGSyncByMask
pop     {r4-r7}
pop     {r0}
bx      r0
.ltorg



Augury_KeypressCheckAndSprites:
push	{r4-r7,r14}
mov		r4,r0
mov		r6,r4
add		r4,#Proc_InitialOffset
ldr		r5,=gpKeyStatus
ldr		r5,[r5]
bl		Augury_DisplaySprites
	@ B
Aug_CheckBPress:
ldrh	r0,[r5,#8]
mov		r1,#2
tst		r0,r1
beq		Aug_CheckLeftRightPress
mov		r0,r6
_blh	BreakProcLoop
mov		r0,#MenuBackingOutNoise
_blh	PlaySoundWrapper
b		End_Aug_KeypressCheckAndMapSprites
	@ right/left (with A)
Aug_CheckLeftRightPress:
ldrh	r0,[r5,#6]
mov		r1,#0x30		@left/right
tst		r0,r1
beq		Aug_CheckUpPress
mov		r1,#1
ldrh	r3,[r5,#4]
mov		r2,#1			@ A
tst		r3,r2
beq		Aug_LeftOrRightPress
mov		r1,#5			@ faster scrolling when pressing A as well
Aug_LeftOrRightPress:
mov		r2,#0x20
tst		r0,r2
beq		Aug_LeftRightPress
neg		r1,r1
Aug_LeftRightPress:
ldrb	r0,[r4,#Proc_DisplayChapter]
bl		GetNextNonBaseMap
strb	r0,[r4,#Proc_DisplayChapter]
mov		r0,r6
bl		Draw_Augury_Text_Layer1
mov		r0,#MenuChangingOptionsNoise
_blh	PlaySoundWrapper
b		End_Aug_KeypressCheckAndMapSprites
	@ up/down
Aug_CheckUpPress:
ldrh	r0,[r5,#6]
mov		r1,#0x40
tst		r0,r1
beq		Aug_CheckDownPress
mov		r0,#1
neg		r0,r0
b		Aug_UpDownPress
Aug_CheckDownPress:
ldrh	r0,[r5,#6]
mov		r1,#0x80
tst		r0,r1
beq		Aug_CheckLRPress
mov		r0,#1
Aug_UpDownPress:
ldrb	r1,[r4,#Proc_RowNumber]
add		r1,r0
cmp		r1,#0
bge		Aug_UpDownPress_Label1
mov		r1,#6
b		Aug_UpDownPress_Label2
Aug_UpDownPress_Label1:
cmp		r1,#6
ble		Aug_UpDownPress_Label2
mov		r1,#0
Aug_UpDownPress_Label2:
strb	r1,[r4,#Proc_RowNumber]
lsl		r1,#4
add		r1,#0x20
strb	r1,[r4,#Proc_HandY]
mov		r0,r6
bl		Draw_Augury_Text_Layer2
mov		r0,#MenuChangingOptionsNoise
_blh	PlaySoundWrapper
b		End_Aug_KeypressCheckAndMapSprites
	@ L/R
Aug_CheckLRPress:
ldrh	r0,[r5,#8]
mov		r1,#1
lsl		r1,#8
tst		r0,r1
beq		Aug_CheckLPress
mov		r0,#1
b		Aug_LRPRess
Aug_CheckLPress:
ldrh	r0,[r5,#8]
mov		r1,#2
lsl		r1,#8
tst		r0,r1
beq		End_Aug_KeypressCheckAndMapSprites
mov		r0,#1
neg		r0,r0
Aug_LRPRess:
ldrb	r1,[r4,#Proc_GoalLetter]
add		r1,r0
cmp		r1,#0
bge		Aug_LRPress_Label1
mov		r1,#3
b		Aug_LRPress_Label2
Aug_LRPress_Label1:
cmp		r1,#3
ble		Aug_LRPress_Label2
mov		r1,#0
Aug_LRPress_Label2:
strb	r1,[r4,#Proc_GoalLetter]
mov		r0,r6
bl		Draw_Augury_Text_Layer1
mov		r0,#PageSwapNoise
_blh	PlaySoundWrapper
End_Aug_KeypressCheckAndMapSprites:
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg


Augury_DisplaySprites:
push	{r4-r7,r14}
add		sp,#-4
mov		r4,r0
add		r4,#Proc_InitialOffset
ldrh	r0,[r4,#Proc_SpriteTimer]
add		r0,#1
cmp		r0,#48
blt		Augury_DisplaySprites_Label1
mov		r0,#0
Augury_DisplaySprites_Label1:
strh	r0,[r4,#Proc_SpriteTimer]
	@ B: Back
mov		r0,#0xD		@ root node index
mov		r1,#BBack_x
mov		r2,#BBack_y
ldr		r5,=(((Augury_Graphics_Palette_Bank)<<0xC)+Augury_Graphics_Tile_Number)
str		r5,[sp]
adr		r3,BBack_OAM_Base
_blh	RegisterObjectSafe,r7
	@ L/R: Toggle
add		r5,#5
mov		r0,#0xD
mov		r1,#LRToggle_x
mov		r2,#LRToggle_y
str		r5,[sp]
adr		r3,LRToggle_OAM_Base
_blr	r7
	@ A+cross
add		r5,#8
@mov		r0,#0xD
@mov		r1,#APlus_x
@mov		r2,#APlus_y
@str		r5,[sp]
@adr		r3,APlus_OAM_Base
@_blr	r7
	@ left arrow
add		r5,#4
mov		r0,#4
mov		r1,#LeftArrow_x
mov		r2,#LeftArrow_y
ldrh	r3,[r4,#Proc_SpriteTimer]
lsr		r3,#3
add		r3,r5
str		r3,[sp]
adr		r3,LeftArrow_OAM_Base
_blr	r7
	@ right arrow
mov		r0,#4
mov		r1,#RightArrow_x
mov		r2,#RightArrow_y
ldrh	r3,[r4,#Proc_SpriteTimer]
@add		r3,#20
@cmp		r3,#48
@blt		Augury_DisplaySprites_Label2
@sub		r3,#48
@Augury_DisplaySprites_Label2:
lsr		r3,#3
add		r3,r5
str		r3,[sp]
adr		r3,RightArrow_OAM_Base
_blr	r7
	@ fast forward arrows
ldr		r0,=gpKeyStatus
ldr		r0,[r0]		
ldrh	r0,[r0,#4]
mov		r1,#1
tst		r0,r1
beq		NoFastForwardArrows
mov		r0,#4
mov		r1,#(LeftArrow_x+8)
mov		r2,#LeftArrow_y
ldrh	r3,[r4,#Proc_SpriteTimer]
lsr		r3,#3
add		r3,r5
str		r3,[sp]
adr		r3,LeftArrow_OAM_Base
_blr	r7
mov		r0,#4
mov		r1,#(RightArrow_x+8)
mov		r2,#RightArrow_y
ldrh	r3,[r4,#Proc_SpriteTimer]
@add		r3,#20
@cmp		r3,#48
@blt		Augury_DisplaySprites_Label3
@sub		r3,#48
@Augury_DisplaySprites_Label3:
lsr		r3,#3
add		r3,r5
str		r3,[sp]
adr		r3,RightArrow_OAM_Base
_blr	r7
b		Augury_DisplaySprites_Label4
NoFastForwardArrows:
mov		r0,#0xD
mov		r1,#(LeftArrow_x+12)
mov		r2,#(LeftArrow_y-1)
mov		r3,r5
add		r3,#10
str		r3,[sp]
adr		r3,AOnly_OAM_Base
_blr	r7
Augury_DisplaySprites_Label4:
	@ hand
mov		r0,#Augury_Hand_x
ldrb	r1,[r4,#Proc_HandY]
_blh	UpdateHandCursor
	@ boxes under explanation
add		r5,#6
mov		r0,#4
mov		r1,#ExplanationBox_X
mov		r2,#ExplanationBox_Y
str		r5,[sp]
adr		r3,ExplanationBox_OAM_Base
_blr	r7
add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg
BBack_OAM_Base:
.short 2
.short 0x4000, 0x8000, 0
.short 0x8000, 0x0020, 4
.align
LRToggle_OAM_Base:
.short 2
.short 0x4000, 0x8000, 0
.short 0x4000, 0x8020, 4
.align
APlus_OAM_Base:
.short 1
.short 0x4000, 0x8000, 0
.align
LeftArrow_OAM_Base:
.short 1
.short 0x8000, 0x0000, 0
.align
RightArrow_OAM_Base:
.short 1
.short 0x8000, 0x1000, 0		@ flip
.align
AOnly_OAM_Base:
.short 1
.short 0x8000, 0x0000, 0
.align
ExplanationBox_OAM_Base:
.short 8
.short 0x4400, 0x8000, 0x0C00
.short 0x4400, 0x8020, 0x0C00
.short 0x4400, 0x8040, 0x0C00
.short 0x4400, 0x8060, 0x0C00
.short 0x4400, 0x8080, 0x0C00
.short 0x4400, 0x80A0, 0x0C00
.short 0x4400, 0x80C0, 0x0C00
.short 0x0400, 0x40E0, 0x0C00
.align

.include "Augury_Funcs_Part2.asm"
