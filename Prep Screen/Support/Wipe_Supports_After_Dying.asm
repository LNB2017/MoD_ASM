.thumb
.include "_Support_Defs.asm"

@r5=unit data of dead person, r6=index of partner of dead person, r4=unit data of partner, r0=index of dead person in partner's supports

push	{r14}
mov		r1,r0
mov		r0,r4
mov		r2,#0
ldr		r3,Set_Support_By_Index
_blr	r3
mov		r0,r5
mov		r1,r6
mov		r2,#0
ldr		r3,Set_Support_By_Index
_blr	r3
pop		{r0}
bx		r0

.align
Set_Support_By_Index:
@
