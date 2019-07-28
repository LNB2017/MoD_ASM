.thumb
.include "_Support_Defs.asm"

.equ Inheritance_Skill_Getter, Get_Supporter_Data+4
.equ Eliwood, 0x43
.equ Hector, 0xCF
.equ Lyn, 0x0C

@r0=unit data, r1=index

push	{r4-r5,r14}
mov		r4,r0
mov		r5,r1
ldr		r3,Get_Supporter_Data
_blr	r3
ldrb	r0,[r0,#2]
cmp		r0,#2
ble		GoBack		@0=none, 1=A+, 2=S, 3= it's complicated
ldr		r0,[r4]
ldrb	r0,[r0,#4]
cmp		r0,#Eliwood
beq		EliwoodLynCheck
cmp		r0,#Hector
beq		HectorLynCheck
cmp		r0,#Lyn
beq		LynCheck
b		RetZero

LynCheck:			@gotta figure out which character we're looking at here
mov		r0,r4
mov		r1,r5
_blh	GetCharIdBySupportIndex
cmp		r0,#Eliwood
beq		EliwoodLynCheck
cmp		r0,#Hector
beq		HectorLynCheck
b		RetZero

EliwoodLynCheck:	@Lyn/Farina
ldr		r3,Inheritance_Skill_Getter
_blr	r3
cmp		r0,#1
bne		RetZero
mov		r0,#2
b		GoBack

HectorLynCheck:		@Fiora/Lyn
ldr		r3,Inheritance_Skill_Getter
_blr	r3
cmp		r0,#2
bne		RetZero
mov		r0,#2
b		GoBack

RetZero:
mov		r0,#0
GoBack:
pop		{r4-r5}
pop		{r1}
bx		r1

.ltorg
Get_Supporter_Data:
@
