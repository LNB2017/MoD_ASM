.thumb
.include "../_Prep_Screen_Defs.asm"

.equ InitialTextStruct, 	0x200E864	@used by the "main" prep screen
.equ PercentTextStruct, InitialTextStruct+8
.equ MinusTextStruct, PercentTextStruct+8
.equ xTextStruct, MinusTextStruct+8

.equ Proc_InitialOffset, 	0x2C		@all the rest of this stuff begins here
@ bytes - 8 bits
.equ Proc_RowNumber, 		0x00
.equ Proc_HandY, 			0x01
.equ Proc_CombatRatio, 		0x02
.equ Proc_Losses, 			0x03
.equ Proc_LatestChapter, 	0x04
.equ Proc_DisplayChapter, 	0x05
.equ Proc_GoalLetter,		0x06
.equ Proc_TacticsRank,		0x07
.equ Proc_CombatRank,		0x08
.equ Proc_SurvivalRank,		0x09
.equ Proc_ExpRank,			0x0A
.equ Proc_PowerRank,		0x0B
.equ Proc_FundsRank,		0x0C
.equ Proc_OverallRank,		0x0D
@ shorts - 16 bits
.equ Proc_TurnCount, 		0x0E
.equ Proc_TotalLevels, 		0x10
.equ Proc_SpriteTimer,		0x12	@ now a child proc so that sprites will display when r bubble is up
.equ Proc_ArrowOffset,		0x14	@ ^
@ words - 32 bits
.equ Proc_TotalExp, 		0x18
.equ Proc_TotalFunds, 		0x1C

.equ Tactics, 				0
.equ Combat, 				1
.equ Survival, 				2
.equ Experience, 			3
.equ Power, 				4
.equ Funds, 				5

.equ max_chapter_id, 		89

@graphics
.equ Augury_Graphics_Palette_Bank, 2        @foreground palette id
.equ Augury_Graphics_Tile_Number, 0x2E0    @in object tile memory
.equ Augury_BG_Layer_Palette, 3
.equ Rank_BG_x, 0
.equ Rank_BG_y, 4
.equ Rank_x, 88
.equ Rank_y, 8
.equ BBack_x, 0
.equ BBack_y, 144
.equ RHelp_x, 200
.equ RHelp_y, 144
.equ LeftArrow_x, (10*8) @(13*8)
.equ LeftArrow_y, 33 @17
.equ RightArrow_x, (16*8)+4 @(21*8)
.equ RightArrow_y, 33 @17
.equ UpArrow_x, (21*8) @(20*8)
.equ UpArrow_y, 32 @0
.equ DownArrow_x, (21*8) @(20*8)
.equ DownArrow_y, 40 @8


@text coordinates
.equ RankName_Y, 1
.equ Curr_Letter_Y, 8
.equ Curr_Total_Y, 12
.equ Goal_Total_Y, 18
.equ Diff_Total_Y, 24
.equ TopRow_X,  0
.equ RowHeader_X, 2
.equ GoalLetter_X, 0
.equ GoalLetter_Y, Goal_Total_Y+3

.equ DescriptionX, 4
.equ DescriptionY, 18
.equ DescriptionTileSpace, 26
