.thumb
.include "_Support_Defs.asm"

push	{r4-r5,r14}
ldr		r5,UnlockCharactersSupports
mov		r4,#1
UnitLoop:
mov		r0,r4
_blh	GetUnitData
cmp		r0,#0
beq		NextUnit
ldr		r1,[r0]
cmp		r1,#0
beq		NextUnit
ldrh	r1,[r0,#0xC]
mov		r2,#4
tst		r1,r2
bne		NextUnit
_blr	r5
NextUnit:
add		r4,#1
cmp		r4,#0x40
blt		UnitLoop
pop		{r4-r5}
pop		{r0}
bx		r0

.ltorg
UnlockCharactersSupports:
@
