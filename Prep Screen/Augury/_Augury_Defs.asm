.thumb
.include "../_Prep_Screen_Defs.asm"

.equ InitialTextStruct, 0x200E864	@used by the "main" prep screen

.equ Proc_InitialOffset, 0x2C		@all the rest of this stuff begins here

.equ max_chapter_id, 89
@ bytes - 8 bits
.equ Proc_RowNumber, 0x00
.equ Proc_HandY, 0x01
.equ Proc_CombatRatio, 0x02
.equ Proc_Losses, 0x03
.equ Proc_LatestChapter, 0x04
.equ Proc_DisplayChapter, 0x05

@ shorts - 16 bits
.equ Proc_TurnCount, 0x0C
.equ Proc_TotalLevels, 0x0E

@ words - 32 bits
.equ Proc_TotalExp, 0x18
.equ Proc_TotalFunds, 0x1C

.equ Tactics, 0
.equ Combat, 1
.equ Survival, 2
.equ Experience, 3
.equ Power, 4
.equ Funds, 5
