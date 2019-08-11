.thumb
.include "_Augury_Defs.asm"

.equ Augury_Palette, Augury_Graphics+4

@r0=proc pointer
push    {r4-r7,r14}
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset

@clearing bglayer3
ldr     r0,=BGLayer3
mov     r1,#0
_blh    ClearLayer

@red background graphics
ldr     r0,=#0x8336D5C       
ldr     r1,=#0x6008000       
_blh    Decompress

@red background palette
ldr     r0,=#0x833C01C      
mov     r1,#0x80    
mov     r2,#0x20
_blh    CopyToPaletteBuffer

@red background construction
ldr     r0,=BGLayer3
mov     r1,#0x40
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

@red background enable
mov     r0,#8
_blh    EnableBGSyncByMask

pop     {r4-r7}
pop     {r1}
bx      r1
.ltorg
Augury_Graphics:
