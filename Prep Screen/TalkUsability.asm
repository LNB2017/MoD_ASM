.thumb
.include "_Prep_Screen_Defs.asm"

.equ Is_Base_Map, Count_Talks_And_Make_List+4

push	{r14}
ldr		r3,Is_Base_Map
_blr	r3
cmp		r0,#0
beq		RetMinusOne

mov		r0,#1
neg		r0,r0
ldr		r3,Count_Talks_And_Make_List
_blr	r3
cmp		r0,#0
beq		RetMinusOne
mov		r0,#0
b		GoBack
RetMinusOne:
mov		r0,#1
neg		r0,r0
GoBack:
pop		{r1}
bx		r1

.align
Count_Talks_And_Make_List:
@
