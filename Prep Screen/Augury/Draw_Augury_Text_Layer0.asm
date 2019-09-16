.thumb
.include "_Augury_Defs.asm"

.equ Draw_Augury_Text_Layer2, Augury_Attributes_Table+4
/*
Text Struct (size 0x08):
    00 | short | start tile index (relative to Font root)
    02 | byte  | current local x cursor (in pixels)
    03 | byte  | current text color id
    04 | byte  | Text tile width (usually only half the actual used tile amount!)
    05 | byte  | (bool) Uses Double Buffer
    06 | byte  | current buffer id (0 or 1)
    07 | byte  | idk (maybe unused? initialized to 0)
*/
@r0=proc pointer
push    {r4-r7,r14}
mov     r4,r0
mov     r7,r4
add     r4,#Proc_InitialOffset
ldr     r5,=UnchangingTextStruct
ldr     r6,Augury_Attributes_Table

begin_loop:
@check if there's an entry
ldr     r0,[r6]
cmp     r0,#0
beq     end_loop
@Augury_Attributes_Table_Entry(x_coord, y_coord, text_color, number_of_tiles, text_pointer)
@call TextInit with r0=text struct, r1=number of tiles to reserve (obtained from table)
mov     r0,r5
ldrb    r1,[r6,#3]
_blh    TextInit
@call Text_SetColorId with r0=text struct, r1=color id (obtained from table)
mov     r0,r5
ldrb    r1,[r6,#2]
_blh    Text_SetColorId
@call Text_AppendString with r0=text struct, r1=pointer to text (obtained from table)
mov     r0,r5
ldr     r1,[r6,#4]
_blh    Text_AppendString
@call TextDraw with r0=text struct, r1=bg offset to draw to (get x and y from table)
@layer + y<<6 + x<<1
mov     r0,r5
ldrb    r2,[r6]
ldrb    r3,[r6,#1]
lsl     r2,#1
lsl     r3,#6
ldr     r1,=BGLayer0
add     r1,r2
add     r1,r3
_blh    TextDraw
@add 8 to text struct
add     r5,#8
@add X to table (where X is the length of an entry in the table)
add     r6,#8
b       begin_loop

@not returning anything, pop and bx r0
end_loop:
@bottom text
mov r0,r7
ldr r3,Draw_Augury_Text_Layer2
_blr r3

pop     {r4-r7}
pop     {r0}
bx      r0

.ltorg
Augury_Attributes_Table:
Draw_Augury_Text_Layer2:
