.global Augury_TacticsRank
.global Augury_TacticsTotal
.global Augury_TacticsGoal
.global Augury_TacticsDiff
.global Augury_CombatRank
.global Augury_CombatTotal
.global Augury_CombatGoal
.global Augury_CombatDiff
.global Augury_SurvivalRank
.global Augury_SurvivalTotal
.global Augury_SurvivalGoal
.global Augury_SurvivalDiff
.global Augury_ExpRank
.global Augury_ExpTotal
.global Augury_ExpGoal
.global Augury_ExpDiff
.global Augury_PowerRank
.global Augury_PowerTotal
.global Augury_PowerGoal
.global Augury_PowerDiff
.global Augury_FundsRank
.global Augury_FundsTotal
.global Augury_FundsGoal
.global Augury_FundsDiff
.global Augury_OverallRank
.global Augury_GoalLetter
.global Augury_ChapterText


Augury_TacticsRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_TacticsRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0

Augury_TacticsTotal:
push	{r14}
add		r1,#Proc_InitialOffset
ldrh	r2,[r1,#Proc_TurnCount]
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0

Augury_TacticsGoal:
push	{r4,r14}
mov		r4,r0
add		r1,#Proc_InitialOffset
ldrb	r0,[r1,#Proc_DisplayChapter]
ldrb	r2,[r1,#Proc_GoalLetter]
mov		r1,#Tactics
bl		RankValueGetter
mov		r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4}
pop		{r0}
bx		r0		

Augury_TacticsDiff:
push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
add		r5,#Proc_InitialOffset
ldrb	r0,[r5,#Proc_DisplayChapter]
ldrb	r2,[r5,#Proc_GoalLetter]
mov		r1,#Tactics
bl		RankValueGetter
ldrh	r2,[r5,#Proc_TurnCount]
sub		r2,r0,r2
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4-r5}
pop		{r0}
bx		r0	




Augury_CombatRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_CombatRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0

Augury_CombatTotal:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_CombatRatio]
mov		r1,#0
bl		Augury_DrawCombatNumber
pop		{r0}
bx		r0

Augury_CombatGoal:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r1,[r1,#Proc_GoalLetter]
ldr		r2,=Augury_CombatRankValuesTable
ldrb	r2,[r2,r1]
mov		r1,#0
bl		Augury_DrawCombatNumber
pop		{r0}
bx		r0

Augury_CombatDiff:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_GoalLetter]
ldr		r3,=Augury_CombatRankValuesTable
ldrb	r3,[r3,r2]
ldrb	r2,[r1,#Proc_CombatRatio]
sub		r2,r2,r3
mov		r1,#0
bl		Augury_DrawCombatNumber
pop		{r0}
bx		r0





Augury_SurvivalRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_SurvivalRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0

Augury_SurvivalTotal:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_Losses]
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0

Augury_SurvivalGoal:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r1,[r1,#Proc_GoalLetter]
ldr		r2,=Augury_SurvivalRankValuesTable
ldrb	r2,[r2,r1]
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0

Augury_SurvivalDiff:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_GoalLetter]
ldr		r3,=Augury_SurvivalRankValuesTable
ldrb	r3,[r3,r2]
ldrb	r2,[r1,#Proc_Losses]
sub		r2,r3,r2
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0






Augury_ExpRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_ExpRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0

Augury_ExpTotal:
push	{r14}
add		r1,#Proc_InitialOffset
ldr		r2,[r1,#Proc_TotalExp]
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0

Augury_ExpGoal:
push	{r4,r14}
mov		r4,r0
add		r1,#Proc_InitialOffset
ldrb	r0,[r1,#Proc_DisplayChapter]
ldrb	r2,[r1,#Proc_GoalLetter]
mov		r1,#Experience
bl		RankValueGetter
mov		r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4}
pop		{r0}
bx		r0		

Augury_ExpDiff:
push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
add		r5,#Proc_InitialOffset
ldrb	r0,[r5,#Proc_DisplayChapter]
ldrb	r2,[r5,#Proc_GoalLetter]
mov		r1,#Experience
bl		RankValueGetter
ldr		r2,[r5,#Proc_TotalExp]
sub		r2,r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4-r5}
pop		{r0}
bx		r0	




Augury_PowerRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_PowerRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0

Augury_PowerTotal:
push	{r14}
add		r1,#Proc_InitialOffset
ldrh	r2,[r1,#Proc_TotalLevels]
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0

Augury_PowerGoal:
push	{r4,r14}
mov		r4,r0
add		r1,#Proc_InitialOffset
ldrb	r0,[r1,#Proc_DisplayChapter]
ldrb	r2,[r1,#Proc_GoalLetter]
mov		r1,#Power
bl		RankValueGetter
mov		r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4}
pop		{r0}
bx		r0		

Augury_PowerDiff:
push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
add		r5,#Proc_InitialOffset
ldrb	r0,[r5,#Proc_DisplayChapter]
ldrb	r2,[r5,#Proc_GoalLetter]
mov		r1,#Power
bl		RankValueGetter
ldrh	r2,[r5,#Proc_TotalLevels]
sub		r2,r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4-r5}
pop		{r0}
bx		r0	





Augury_FundsRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_FundsRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0

Augury_FundsTotal:
push	{r14}
add		r1,#Proc_InitialOffset
ldr		r2,[r1,#Proc_TotalFunds]
mov		r1,#0
bl		Augury_DrawNonCombatNumber
pop		{r0}
bx		r0

Augury_FundsGoal:
push	{r4,r14}
mov		r4,r0
add		r1,#Proc_InitialOffset
ldrb	r0,[r1,#Proc_DisplayChapter]
ldrb	r2,[r1,#Proc_GoalLetter]
mov		r1,#Funds
bl		RankValueGetter
mov		r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4}
pop		{r0}
bx		r0		

Augury_FundsDiff:
push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
add		r5,#Proc_InitialOffset
ldrb	r0,[r5,#Proc_DisplayChapter]
ldrb	r2,[r5,#Proc_GoalLetter]
mov		r1,#Funds
bl		RankValueGetter
ldr		r2,[r5,#Proc_TotalFunds]
sub		r2,r2,r0
mov		r1,#0
mov		r0,r4
bl		Augury_DrawNonCombatNumber
pop		{r4-r5}
pop		{r0}
bx		r0	



Augury_OverallRank:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_OverallRank]
mov		r1,#0
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0


Augury_GoalLetter:
push	{r14}
add		r1,#Proc_InitialOffset
ldrb	r2,[r1,#Proc_GoalLetter]
mov		r1,#2
bl		Augury_DrawRankLetter
pop		{r0}
bx		r0


Augury_ChapterText:
push	{r4-r7,r14}
mov		r4,r0
mov		r6,r1
	@ clear the next 3 tiles of the background
add		r0,#0x40
mov		r3,#0
strh	r3,[r0]
strh	r3,[r0,#2]
strh	r3,[r0,#2]
strh	r3,[r4]
strh	r3,[r4,#2]
strh	r3,[r4,#4]
add		r1,#Proc_InitialOffset
ldrb	r0,[r1,#Proc_DisplayChapter]
_blh	GetChapterData
add		r0,#0x3E			@ chaper name * 2, bottom bit set for 'x' (eg 12x)
ldrb	r5,[r0]
lsr		r0,r5,#1
bl		CountDigitsInNumber
mov		r7,r0				@ figure out where to draw right arrow
lsl		r0,#1
add		r4,r0
mov		r0,r4
mov		r1,#2
lsr		r2,r5,#1
_blh	DrawUiNumber
mov		r0,#1
tst		r0,r5
beq		End_Augury_ChapterText	@ if not set, don't draw the x
ldr		r0,=xTextStruct
add		r1,r4,#2
_blh	TextDraw
add		r7,#1
End_Augury_ChapterText:
ldr		r6,[r6,#0x18]		@ child proc, which is the sprites display
add		r6,#Proc_InitialOffset
lsl		r7,#3
strh	r7,[r6,#Proc_ArrowOffset]
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg


Augury_DrawCombatNumber:
@ r0 = bg buffer offset, r1 = palette id, r2 = number
push	{r4-r7,r14}
mov		r4,r0	@ bg buffer offset
mov		r5,r1	@ palette id
mov		r6,r2	@ number
cmp		r6,#0
bge		Augury_DrawCombatNumber_Label1
@ draw minus sign
ldr		r0,=MinusTextStruct
sub		r1,r4,#2
_blh	TextDraw
neg		r6,r6
Augury_DrawCombatNumber_Label1:
mov		r0,r6
bl		CountDigitsInNumber
lsl		r0,#1
add		r4,r0
mov		r0,r4
mov		r1,r5
mov		r2,r6
_blh	DrawUiNumber
ldr		r0,=PercentTextStruct
add		r1,r4,#2
_blh	TextDraw
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg


Augury_DrawNonCombatNumber:
@ r0 = bg buffer offset, r1 = palette id, r2 = number
push	{r4-r7,r14}
mov		r4,r0	@ bg buffer offset
mov		r5,r1	@ palette id
mov		r6,r2	@ number
cmp		r6,#0
bge		Augury_DrawNonCombatNumber_Label1
@ draw minus sign
ldr		r0,=MinusTextStruct
sub		r1,r4,#2
_blh	TextDraw
neg		r6,r6
Augury_DrawNonCombatNumber_Label1:
mov		r0,r6
bl		CountDigitsInNumber
lsl		r0,#1
add		r4,r0
mov		r0,r4
mov		r1,r5
mov		r2,r6
_blh	DrawUiNumber
pop		{r4-r7}
pop		{r0}
bx		r0
.ltorg


Augury_DrawRankLetter:
@ r0 = bg buffer offset, r1 = palette id, r2 = number (0=A, 1=B, 2=C, 3=D, 4=E, 5=S)
push	{r14}
adr		r3,Aug_RankLetterTable
ldrb	r2,[r3,r2]
_blh	DrawSpecialUiChar
pop		{r0}
bx		r0
.ltorg
Aug_RankLetterTable:
.byte 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x18, 0, 0


RankValueGetter:
@ r0=chapter id, r1=rank id, r2=letter
push    {r4,r14}
cmp     r0,#max_chapter_id
bgt     RankValueGetter_RetFalse
mov     r4,#96
mul     r0,r4
ldr     r4,=RankingTable
add     r4,r0               @beginning of chapter's entry in r4
ldr     r3,=gChapterData
ldrb    r3,[r3,#0x14]
mov     r0,#0x40            @hard mode bit
and     r3,r0
cmp     r3,#0
beq     hardPass
mov     r3,#1
hardPass:
cmp     r1, #Tactics
beq     RVG_tactics  
cmp     r1, #Experience
beq     RVG_experience
cmp     r1, #Power
beq     RVG_power 
cmp     r1, #Funds
beq     RVG_funds
RankValueGetter_RetFalse:
mov     r0,#0
b       RVG_GoBack
RVG_tactics: 
@tactics offset is 0, no need to change r4
lsl     r3,#3               @putting hard mode offset for tactics rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#1               @each tactics entry has 2 bytes, so lshift by 1 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldrh    r0,[r4]             @each tactics entry is a short. Moving its value from the offset in r4 to r0
b       RVG_GoBack
RVG_power: 
add     r4,#16              @power entries start at 16
lsl     r3,#3               @putting hard mode offset for power rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#1               @each power entry has 2 bytes, so lshift by 1 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldrh    r0,[r4]             @each power entry is a short. Moving its value from the offset in r4 to r0
b       RVG_GoBack
RVG_experience: 
add     r4,#32              @experience entries start at 32
lsl     r3,#4               @putting hard mode offset for experience rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#2               @each experience entry has 4 bytes, so lshift by 2 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldr     r0,[r4]             @each experience entry is a word. Moving its value from the offset in r4 to r0
b       RVG_GoBack
RVG_funds: 
add     r4,#64              @funds entries start at 64
lsl     r3,#4               @putting hard mode offset for funds rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#2               @each funds entry has 4 bytes, so lshift by 2 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldr     r0,[r4]             @each funds entry is a word. Moving its value from the offset in r4 to r0
RVG_GoBack:
pop     {r4}
pop     {r1}
bx      r1
.ltorg



CountDigitsInNumber:
mov		r3,r0
mov		r0,#0
adr		r1,DigitsTable
DigitsLoop:
ldr		r2,[r1]
cmp		r2,#0
beq		End_DigitsLoop
cmp		r3,r2
bls		End_DigitsLoop
add		r0,#1
add		r1,#4
b		DigitsLoop
End_DigitsLoop:
bx		r14
.align
DigitsTable:
.long 9, 99, 999, 9999, 99999, 999999


GetNextNonBaseMap:
@ r0 = chapter id, r1 = number of chapters to scroll
push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
cmp		r5,#1
blt		GetNextNonBaseMap_Left
@ GetNextNonBaseMap_Right
cmp		r4,#max_chapter_id
blt		GetNextNonBaseMap_Loop1
mov		r4,#1
b		End_GetNextNonBaseMap		@ loop around to first chapter and end
GetNextNonBaseMap_Loop1:
add		r4,#1
cmp		r4,#max_chapter_id
beq		End_GetNextNonBaseMap
mov		r0,r4
_blh	Is_Base_Map
cmp		r0,#0
bne		GetNextNonBaseMap_Loop1
sub		r5,#1
cmp		r5,#0
bgt		GetNextNonBaseMap_Loop1
b		End_GetNextNonBaseMap
GetNextNonBaseMap_Left:
cmp		r4,#1
bgt		GetNextNonBaseMap_Loop2
mov		r4,#max_chapter_id
b		End_GetNextNonBaseMap		@ loop around to last chapter and end
GetNextNonBaseMap_Loop2:
sub		r4,#1
cmp		r4,#1
beq		End_GetNextNonBaseMap
mov		r0,r4
_blh	Is_Base_Map
cmp		r0,#0
bne		GetNextNonBaseMap_Loop2
add		r5,#1
cmp		r5,#0
blt		GetNextNonBaseMap_Loop2
End_GetNextNonBaseMap:
mov		r0,r4
pop		{r4-r5}
pop		{r1}
bx		r1
.ltorg
