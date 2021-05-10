.thumb
.include "../_Prep_Screen_Defs.asm"

.equ InitialTextStruct, 	0x200E864	@used by the "main" prep screen
.equ UnchangingTextStruct, InitialTextStruct+(4*4)
.equ DescTextStruct, InitialTextStruct+(4*5)

.equ Proc_InitialOffset, 	0x2C		@all the rest of this stuff begins here
@ bytes - 8 bits
.equ Proc_RowNumber, 		0x00
.equ Proc_HandY, 			0x01
.equ Proc_CombatRatio, 		0x02
.equ Proc_Losses, 			0x03
.equ Proc_LatestChapter, 	0x04
.equ Proc_DisplayChapter, 	0x05
@ shorts - 16 bits
.equ Proc_TurnCount, 		0x0C
.equ Proc_TotalLevels, 		0x0E
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

