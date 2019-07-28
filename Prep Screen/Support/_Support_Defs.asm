.thumb
.include "../_Prep_Screen_Defs.asm"

.equ SupportBG_X, 0				@tiles
.equ SupportBG_Y, 4				@tiles
@.equ BannerBG_X, 0				@pixels; commented out because it's not necessary
.equ BannerBG_Y, 4				@pixels
.equ BannerText_X,60			@pixels
.equ BannerText_Y, BannerBG_Y+4	@pixels
.equ LHelp_X, 88
.equ LHelp_Y, 150
.equ RHelp_X, 200
.equ RHelp_Y, 150
.equ BHelp_X, 8
.equ BHelp_Y, 150
.equ Banner_Palette_Bank, 2		@foreground palette id
.equ Banner_Tile_Number, 0x260	@in object tile memory
.equ UnitText_X, SupportBG_X+3	@+1 for bg, +2 for map sprite
.equ UnitText_Y, SupportBG_Y+1
.equ SupportEntry_X, SupportBG_X+1+2*(UnitTextLength+2)+1+1		@this is where affinity goes, text is +2
.equ SupportEntry_Y, SupportBG_Y+1

.equ UnitListLocation, 0x200E6D4
.equ UnitCountLocation, 0x200E7D4
.equ UnitTextStruct, 0x200E7E4
.equ SupportTextStruct, UnitTextStruct+(8*(NumberOfUnitColumns*(NumberOfUnitRows+1)))		@+2 is because of the transition buffer when scrolling

.equ NumberOfUnitRows, 7
.equ NumberOfUnitColumns, 2
.equ NumberOfSupports, 7
.equ UnitTextLength, 5
.equ SupportEntryLength, 2+UnitTextLength+1+4+1		@affinity icon + name + space + support letters + 1 to avoid having the window effect cut off the + of A+
.equ APlus1, 0x2B									@where the glyph is inserted in that weird font table thing, part 1
.equ APlus2, 0x2C

.equ Proc_InitialOffset, 0x2C		@all the rest of this stuff begins here
.equ Proc_PaneNumber, 0x00			@bit 0x1: 0=unit pane, 1=support pane; bit 0x2 is set for r bubble
.equ Proc_UnitCurrentChar, 0x01		@what the hand points to
.equ Proc_UnitLastCharSlot, 0x02	@total number of units - 1
.equ Proc_UnitTopRow, 0x03
.equ Proc_UnitLastRow, 0x04
.equ Proc_UnitCurrentRow, 0x05
.equ Proc_UnitCurrentColumn, 0x06
.equ Proc_UnitHandX, 0x07
.equ Proc_UnitHandY, 0x08
.equ Proc_SupportTopRow, 0x09
.equ Proc_SupportLastRow, 0x0A		@number of supports - 1
.equ Proc_SupportCurrentRow, 0x0B
.equ Proc_SupportCurrentColumn, 0x0C
.equ Proc_SupportHandX, 0x0D
.equ Proc_SupportHandY, 0x0E
.equ Proc_CursorTimer, 0x0F
.equ Proc_NumberOfSupports, 0x11
.equ Proc_IsNewSupport, 0x12
.equ Proc_ResetParameters, 0x13
.equ Proc_CurrentLayer0, 0x20
.equ Proc_NewLayer0, 0x22
.equ Proc_CurrentLayer1, 0x24
.equ Proc_NewLayer1, 0x26

@bubble things
.equ RBubbleStruct, 0x203D3E0		@the thing in the stat screen that's 0x1C bytes, consisting of POIN Up Down Left Right; BYTE x, y; SHORT text_id; POIN alternate_box alternate_text
.equ RBubbleFontStruct, 0x203D40C	
.equ RBubbleHandCoords, 0x203D400	@I don't think I actually need this
.equ RBubblePointerToStruct, 0x203D3FC
.equ RBubbleTextStruct1, 0x203D424
.equ Affinity_R_Bubble_Length, 0xC0
.equ Affinity_R_Bubble_Height, 0x30
.equ Affinity_Column1, 0x00			@Affinity, Atk, Def labels
.equ Affinity_Column2, 0x20			@Atk and Def numbers, assuming 2 digits
.equ Affinity_Column3, 0x38			@Rank, Hit, Avoid labels
.equ Affinity_Column4, 0x5C			@Rank, Hit, Avoid numbers
.equ Affinity_Column5, 0x74			@Rng, Crit, Dodg labels
.equ Affinity_Column6, 0x98			@^ numbers
