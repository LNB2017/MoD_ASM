.thumb
.include "_Augury_Defs.asm"

.equ DescriptionX, 4
.equ DescriptionY, 18
.equ DescriptionTileSpace, 16
@r0=proc pointer
push    {r4-r7,r14}
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset
ldr     r5,=DescTextStruct
ldr     r6,Rank_Description_Table

@clearing layer 2
ldr     r0,=BGLayer2
mov     r1,#0
_blh    ClearLayer

@call TextInit with r0=DescTextStruct, r1=however many tiles you want to reserve for the text (looks like 16?)
mov     r0,r5
mov     r1,#DescriptionTileSpace
_blh    TextInit

@call TextAppend with r0=text struct, r1=pointer to text
mov     r0,r5
ldrb    r1,[r4,#Proc_RowNumber]
lsl     r1,#2 @each entry of the table is 4 bytes
ldr     r1,[r6,r1]
_blh    Text_AppendString

@Call TextDraw with r0=text struct, r1=bg2 + x<<1 + y<<6*/
mov     r0,r5
ldr     r1,=(BGLayer2 + 0x40*DescriptionX + 2*DescriptionY)
_blh    TextDraw

@Updating BGLayer2 on vblank
mov     r0,#4
_blh    EnableBGSyncByMask

pop     {r4-r7}
pop     {r0}
bx      r0

.ltorg
Rank_Description_Table:
