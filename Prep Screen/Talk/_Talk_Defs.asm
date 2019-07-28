.thumb
.include "../_Prep_Screen_Defs.asm"

.equ Default_Scrolling_BG, 0		@change this to not 1 if we're not using the dragon/sword thing (reassemble Set_Up_Talk and Keypress_Check, too)
.equ Star_Justifying, 0				@0=left justified, 1=right justified

.equ TalkBG_X, 2				@tiles
.equ TalkBG_Y, 4				@tiles
@.equ BannerBG_X, 0				@pixels; commented out because it's not necessary
.equ BannerBG_Y, 4				@pixels
.equ BannerText_X,48			@pixels
.equ BannerText_Y, BannerBG_Y+4	@pixels
.equ Banner_Palette_Bank, 2		@foreground palette id
.equ Banner_Tile_Number, 0x260	@in object tile memory
.equ Star_Tile_Number, 0x1C		@in tile ram1
.equ Star_Palette_Bank, 2		@background palette id
.equ LHelp_X, 160
.equ LHelp_Y, 150
.equ BHelp_X, 8
.equ BHelp_Y, 150

.equ InitialTextStruct, 0x200E864	@used by the "main" prep screen
.equ NumberOfEntriesAtOnce, 6
.equ SpaceForText, 21			@tiles
.equ LengthOfTalkEntry, 20		@bytes

.equ Proc_DoNotResetParametersBool, 0x34	@34 - 0 when starting out, 1 if doing a talk
.equ Proc_CurrentSlot, 0x36			@36 - current slot number
.equ Proc_TopSlot, 0x38				@38 - slot number at top of screen
.equ Proc_CurrentBGPos, 0x3A		@3A - current shift of bg0
.equ Proc_NewBGPos, 0x3C			@3C - new shift to bg0 layer for scrolling
.equ Proc_NumberOfEntries, 0x3E		@3E - total number of entries
.equ Proc_TalkEntryPointer, 0x40	@40 - pointer to this chapter's talk entries
.equ Proc_ListOfTalks, 0x44			@44 - list of talks available at this time (gets remade after viewing a talk or returning to prep screen) (max of 40)

