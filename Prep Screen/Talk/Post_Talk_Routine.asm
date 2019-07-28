.thumb
.include "_Talk_Defs.asm"

push	{r4,r14}
mov		r4,r0
mov		r0,#1
neg		r0,r0
ldr		r3,Count_Talks_And_Make_List
_blr	r3
cmp		r0,#0
beq		GoBack
mov		r0,#0
strh	r0,[r4,#Proc_DoNotResetParametersBool]
mov		r0,r4
mov		r1,#0		@remakes the talk screen
_blh	GoToProcLabel
GoBack:
pop		{r4}
pop		{r0}
bx		r0

.ltorg
Count_Talks_And_Make_List:
@
