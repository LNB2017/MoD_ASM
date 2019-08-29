.thumb
.include "_Augury_Defs.asm"

.equ Augury_Palette, Augury_Graphics+4
.equ Is_Base_Map, Augury_Palette+4

@r0=proc pointer
push    {r4-r7,r14}
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset

@clear all 
mov     r0,#0
_blh    #0x80026BC

@red background graphics
ldr     r0,=#0x8336D5C       
ldr     r1,=#0x6008000       
_blh    Decompress

@red background palette
ldr     r0,=#0x833C01C      
mov     r1,#(Augury_BG_Layer_Palette<<5) @*0x20  
mov     r2,#0x20
_blh    CopyToPaletteBuffer

@red background construction
ldr     r0,=BGLayer3
mov     r1,#(Augury_BG_Layer_Palette<<4) @*0x10
lsl     r1,#8
_blh    #0x8090854      @function that draws the augury background on given layer r0 with palette r1

@load arrow graphics (and other status screen stuff)
ldr     r0,=#0x083080D0
ldr     r1,=#0x06014800
_blh    Decompress

@load arrow palette 
ldr     r0,=#0x080FED80
mov     r1,#0x80
mov     r2,#0x20
_blh    CopyToPaletteBuffer

@Initialize augury graphics
ldr     r0,Augury_Graphics
ldr     r1,=#(0x6010000+0x20*Augury_Graphics_Tile_Number)
_blh    Decompress
ldr     r0,Augury_Palette
mov     r1,#(Augury_Graphics_Palette_Bank+0x10)
lsl     r1,#5
mov     r2,#0x20    @length
_blh    CopyToPaletteBuffer

@TODO: Set up black box object transparency

@initialization
mov     r0,#0
strb    r0,[r4,#Proc_RowNumber]    @current row for bottow text
mov     r0,#(8*(RowHeader_X+2+1))
strb    r0,[r4,#Proc_HandY]    @current y pixel position for the hand
_blh    0x808F470 @function that gets the win ratio for combat rank
strb    r0,[r4,#Proc_CombatRatio]
_blh    0x808F4F0 @function that gets the number of killed units for survival rank
strb    r0,[r4,#Proc_Losses]
_blh    0x808F30C @function that gets the current turncount for tactics rank
strh    r0,[r4,#Proc_TurnCount]
_blh    0x808F648 @function that gets the sum of levels in the whole army for power rank
strh    r0,[r4,#Proc_TotalLevels]
_blh    0x8084D34 @function that gets the sum of experience in the whole army for Exp rank
str     r0,[r4,#Proc_TotalExp]
_blh    0x8017104 @function that gets the total funds (gold + sale worth of all items) for funds rank 
str     r0,[r4,#Proc_TotalFunds]
ldr     r5,=gChapterData
ldrb    r5,[r5,#0xE] @loading current chapter  
chapterLoop:
sub     r5, #1
mov     r0, r5
ldr     r3,Is_Base_Map
_blr    r3   @returns 0 if not a base, 1 if is a base
cmp     r0, #0
beq     chapterLoopEnd @not a base, so we'll store this chapter
cmp     r5, #0 @we want to avoid an underflow here
bgt     chapterLoop
chapterLoopEnd:
strb    r5,[r4,#Proc_LatestChapter]
strb    r5,[r4,#Proc_DisplayChapter]

@initialize font
mov        r0,#0
_blh    Font_InitDefault

@TODO: Load custom text palette

pop     {r4-r7}
pop     {r1}
bx      r1
.ltorg
Augury_Graphics:
