.thumb

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _blr reg
	mov lr, \reg
	.short 0xF800
.endm

.equ GoToProcLabel, 				0x8003F6C
.equ EndProc, 						0x8003C28
.equ DeleteEachProc, 				0x8004248
.equ StartProc, 					0x8003A04
.equ StartBlockingProc, 			0x8003AD8
.equ FindProc,						0x8003E7C
.equ PlaySound, 					0x809C860
.equ FillBgMap, 					0x8001550
.equ EnableBGSyncByMask, 			0x8000FD4
.equ ClearLayer0And1, 				0x8041678
.equ ClearLayer,					0x8001550
.equ GetMenuGraphicsAndPalette, 	0x80417D4
.equ Decompress, 					0x8013CA4
.equ CopyToPaletteBuffer, 			0x800105C
.equ RegisterObject, 				0x8007DE0
.equ RegisterObjectSafe, 			0x8007D3C
.equ Font_InitDefault, 				0x800563C
.equ SetFont,						0x8005768
.equ SetFontGlyphSet,				0x8005704
.equ TextInit, 						0x800579C
.equ GetStringFromIndex, 			0x8013AD0
.equ Text_AppendString, 			0x8005DA4
.equ TextDraw, 						0x8005AB4
.equ TextDrawWithParameters,		0x8006454
.equ NumberDrawWithParameters,		0x8006484
.equ TextClear, 					0x80058EC
.equ Text_SetColorId,				0x8005A38
.equ NewGreenTextColorManager,		0x8006C9C
.equ DrawIcon,						0x8004CF8
.equ SetEventID, 					0x806BA48
.equ CheckEventID, 					0x806BA5C
.equ UnsetEventID,					0x806BA74
.equ GetUnitByCharID, 				0x8017ABC
.equ DivMod, 						0x809DFE4
.equ UpdateHandCursor, 				0x80415CC
.equ ShowScrollingArrows, 			0x80977C0
.equ CopyScrollingArrowTiles, 		0x809777C
.equ SlotNumberAfterArrowKeyPress, 	0x80978AC
.equ CallEventEngineWithProc, 		0x800D9B8
.equ ClearAllAndLoadMapGraphics,	0x80292DC
.equ PutCameraCoordsOnLord,			0x802B234
.equ FirstCopyMapGraphicsToBG3, 	0x8018D90
.equ GetUnitData,					0x801860C
.equ GetNumberOfSupports,			0x8022A84
.equ GetCharIdBySupportIndex,		0x8022A94
.equ GetSupportLevelByIndex,		0x8022AF0
.equ CanUnitSupportByIndex,			0x8022BA4
.equ GetSupportBonusesEntry,		0x8022DB4
.equ GetCharacterData,				0x801863C
.equ GetAffinityIcon,				0x8022F58
.equ DrawSpecialUiChar,				0x8006E74
.equ GetGameClock,					0x8000EEC
.equ Create_SMS,					0x8022774	@standing map sprite
.equ SMS_SyncDirect,				0x8021F80
.equ DisplaySupportIncreasedPopup,	0x80121D0
.equ Func_70AFC,					0x8070AFC	@stores bubble hand coordinates into the newly created proc
.equ Func_70B20,					0x8070B20	@stores more info into proc (see ^)
.equ Func_70A70, 					0x8070A70	@figures out where the box is supposed to go
.equ Func_71514,					0x8071514	@sets up the text structs for the bubble and deletes any existing bubble display procs
.equ Func_70E70, 					0x8070E70	@initializes palette and vram space for the bubble...I think
.equ CloseRBubble,					0x807089C
.equ GetChapterEvents, 				0x802BBA0

.equ PaletteBuffer, 0x2021708
.equ gChapterData, 0x202AA48
.equ Option2Byte, 0x1D
.set BGLayer0, 0x2021B08
.set BGLayer1, 0x2022308
.set BGLayer2, 0x2022B08
.set BGLayer3, 0x2023308
.set gpKeyStatus, 0x858E578
.set HandOAMBasePointer, 0x85CB3E4
.set gLCDControlBuffer, 0x30026B0
.set R_Bubble_Proc, 0x8677720
.set DISPCNT, 0x00	@display control
.set BG2CNT, 0x14	@bg2 control
.set BG0HOFS, 0x1C	@bg0 horizontal offset
.set BG0VOFS, 0x1E	@bg0 vertical offset
.set BG1HOFS, 0x20	@bg1 horizontal offset
.set BG1VOFS, 0x22	@bg1 vertical offset
.set WIN0H, 0x2C	@window 0 length
.set WIN0V, 0x30	@window 0 width
.set WIN1H, 0x2E	@window 1 length
.set WIN1V, 0x32	@window 1 width
.set WININ, 0x34	@window in
.set WINOUT, 0x36	@window out
.set BLDCNT, 0x3C	@color/special effects selection
.set BLDALPHA, 0x44	@alpha blending coefficients

.equ MenuSelectNoise, 0x6A
.equ MenuBackingOutNoise, 0x6B
.equ MenuChangingUnitsNoise, 0x66
.equ MenuInvalidOptionNoise, 0x6C

.equ WhiteText, 0
.equ GreyText, 1
.equ GreenText, 4

