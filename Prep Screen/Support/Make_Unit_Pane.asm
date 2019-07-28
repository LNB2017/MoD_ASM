.thumb
.include "_Support_Defs.asm"

push	{r4-r7,r14}
add		sp,#-4
str		r0,[sp]
mov		r4,r0
add		r4,#Proc_InitialOffset

@clear layer 0
ldr		r0,=BGLayer0
mov		r1,#0
_blh	ClearLayer

@draw text
ldrb	r5,[r4,#Proc_UnitTopRow]
mov		r6,r5
add		r6,#(NumberOfUnitRows-1)
ldrb	r0,[r4,#Proc_UnitLastRow]
cmp		r0,r6
bge		DrawUnitLoop
mov		r6,r0
DrawUnitLoop:
ldr		r0,[sp]
mov		r1,r5
ldr		r3,Draw_Unit_Name
_blr	r3
add		r5,#1
cmp		r5,r6
ble		DrawUnitLoop

mov		r0,#1
_blh	EnableBGSyncByMask

add		sp,#4
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Draw_Unit_Name:
@
