.thumb
.include "_Support_Defs.asm"

.equ Rank_Letter_Text, Affinity_Name_Text+4

.equ LabelColor, 8
.equ StatColor, 7

@r0=proc, +58 = affinity, +5C = rank

push	{r4-r7,r14}
mov		r7,r8
push	{r7}
mov		r4,r0
ldr		r0,=RBubbleFontStruct
_blh	SetFont
mov		r0,#0
_blh	SetFontGlyphSet
ldr		r5,=RBubbleTextStruct1
ldr		r6,=TextDrawWithParameters
ldr		r0,[r4,#0x58]
_blh	GetSupportBonusesEntry
mov		r7,r0
ldr		r0,[r4,#0x5C]
cmp		r0,#3
ble		Label100
mov		r0,#3
Label100:
mov		r8,r0				@number of times to multiply the stat boosts by

@Affinity name
ldr		r0,[r4,#0x58]
lsl		r0,#2
ldr		r3,Affinity_Name_Text
add		r3,r0
ldr		r3,[r3]
mov		r0,r5
mov		r1,#Affinity_Column1
mov		r2,#StatColor
_blr	r6

@Rank label
mov		r0,r5
mov		r1,#Affinity_Column3
mov		r2,#LabelColor
adr		r3,Rank_Text
_blr	r6

@Rank letter
mov		r1,#(Affinity_Column4)	@add 10 for right justifying
ldr		r0,[r4,#0x5C]
cmp		r0,#0
bne		Label5
add		r1,#4
Label5:
lsl		r0,#2
ldr		r3,Rank_Letter_Text
add		r3,r0
ldr		r3,[r3]
mov		r0,r5
mov		r2,#StatColor
_blr	r6

@Rng label
mov		r0,r5
mov		r1,#Affinity_Column5
mov		r2,#LabelColor
adr		r3,Rng_Text
_blr	r6

@Range number
ldr		r0,[r4,#0x5C]
cmp		r0,#0
beq		NoRangeNumber
mov		r3,#1
cmp		r0,#3
ble		Label1
mov		r3,#3		@for S/A+
Label1:
ldr		r0,=NumberDrawWithParameters
mov		r14,r0
mov		r0,r5
mov		r1,#Affinity_Column6
mov		r2,#StatColor
.short	0xF800
b		RangeNumberDone
NoRangeNumber:
mov		r0,r5
mov		r1,#(Affinity_Column6+4)
mov		r2,#StatColor
adr		r3,Dash_Text
_blr	r6
RangeNumberDone:
add		r5,#8

@Atk label
mov		r0,r5
mov		r1,#Affinity_Column1
mov		r2,#LabelColor
adr		r3,Atk_Text
_blr	r6

@Atk number
mov		r0,r5
mov		r1,#Affinity_Column2
ldrb	r2,[r7,#1]			@attack bonus
mov		r3,r8
mul		r2,r3
bl		WriteStatNumber

@Hit label
mov		r0,r5
mov		r1,#Affinity_Column3
mov		r2,#LabelColor
adr		r3,Hit_Text
_blr	r6

@Hit number
mov		r0,r5
mov		r1,#Affinity_Column4
ldrb	r2,[r7,#3]			@hit bonus
mov		r3,r8
mul		r2,r3
bl		WriteStatNumber

@Crit label
mov		r0,r5
mov		r1,#Affinity_Column5
mov		r2,#LabelColor
adr		r3,Crit_Text
_blr	r6

@Crit number
mov		r0,r5
mov		r1,#Affinity_Column6
ldrb	r2,[r7,#5]			@hit bonus
mov		r3,r8
mul		r2,r3
bl		WriteStatNumber
add		r5,#8

@Def label
mov		r0,r5
mov		r1,#Affinity_Column1
mov		r2,#LabelColor
adr		r3,Def_Text
_blr	r6

@Def number
mov		r0,r5
mov		r1,#Affinity_Column2
ldrb	r2,[r7,#2]			@def bonus
mov		r3,r8
mul		r2,r3
bl		WriteStatNumber

@Avd label
mov		r0,r5
mov		r1,#Affinity_Column3
mov		r2,#LabelColor
adr		r3,Avd_Text
_blr	r6

@Avd number
mov		r0,r5
mov		r1,#Affinity_Column4
ldrb	r2,[r7,#4]			@avd bonus
mov		r3,r8
mul		r2,r3
bl		WriteStatNumber

@Dodg label
mov		r0,r5
mov		r1,#Affinity_Column5
mov		r2,#LabelColor
adr		r3,Dodg_Text
_blr	r6

@Dodg number
mov		r0,r5
mov		r1,#Affinity_Column6
ldrb	r2,[r7,#6]			@dodg bonus
mov		r3,r8
mul		r2,r3
bl		WriteStatNumber

@restore font?
mov		r0,#0
_blh	SetFont

pop		{r7}
mov		r8,r7
pop		{r4-r7}
pop		{r0}
bx		r0

.align
Rank_Text:
.byte 0x82, 0xC2, 0x82, 0xD0, 0x82, 0xE8, 0x82, 0xE4, 0, 0
.align
Rng_Text:
.byte 0x82, 0xC2, 0x82, 0xE8, 0x82, 0xDE, 0, 0
.align
Dash_Text:
.byte 0x82, 0xCF, 0x82, 0xCF, 0, 0
.align
Atk_Text:
.byte 0x82, 0xA0, 0x82, 0xF1, 0x82, 0xE4, 0, 0
.align
Hit_Text:
.byte 0x82, 0xAD, 0x82, 0xE0, 0x82, 0xF1, 0, 0
.align
Crit_Text:
.byte 0x82, 0xA4, 0x82, 0xED, 0x82, 0xE0, 0x82, 0xF1, 0, 0
.align
Def_Text:
.byte 0x82, 0xA6, 0x82, 0xDC, 0x82, 0xDD, 0, 0
.align
Avd_Text:
.byte 0x82, 0xA0, 0x82, 0xAC, 0x82, 0xD9, 0, 0
.align
Dodg_Text: @Now Ddg
@.byte 0x82, 0xA6, 0x82, 0xE9, 0x82, 0xD9, 0x82, 0xDE, 0, 0
.byte 0x82, 0xA6, 0x82, 0xD9, 0x82, 0xDE, 0, 0
.ltorg

WriteStatNumber:
@r0=text struct, r1=x coordinate, r2=number
push	{r4-r7,r14}
add		sp,#-0xC
mov		r4,r0
mov		r5,r1
mov		r6,r2
mov		r0,#0
str		r0,[sp]
str		r0,[sp,#4]
str		r0,[sp,#8]
cmp		r6,#0
bne		NonZeroStat
mov		r0,sp
mov		r1,#0x82
strb	r1,[r0]
strb	r1,[r0,#2]
mov		r1,#0xCF
strb	r1,[r0,#1]
strb	r1,[r0,#3]
add		r5,#4
b		WriteNumber
NonZeroStat:
adr		r7,NumbersInGringeTable
mov		r2,sp
lsr		r3,r6,#1
cmp		r3,#10
blt		OnesDigit
@I'm not actually expecting any tens digits, but just in case...
sub		r5,#8			@move 1 tile back
mov		r1,#0
TensDigitLoop:
sub		r3,#10
add		r1,#1
cmp		r3,#10
bge		TensDigitLoop
ldrb	r1,[r7,r1]
strb	r1,[r2,#1]
mov		r0,#0x82
strb	r0,[r2]
add		r2,#2
OnesDigit:
ldrb	r1,[r7,r3]
strb	r1,[r2,#1]
mov		r0,#0x82
strb	r0,[r2]
strb	r0,[r2,#2]		@for the decimal point
strb	r0,[r2,#4]		@for the tenths place
mov		r0,#0xD2		@.
strb	r0,[r2,#3]
mov		r1,#1
and		r1,r6
cmp		r1,#0
beq		StoreDecimal
mov		r1,#5
StoreDecimal:
ldrb	r1,[r7,r1]
strb	r1,[r2,#5]
WriteNumber:
mov		r0,r4
mov		r1,r5
mov		r2,#StatColor
mov		r3,sp
_blh	TextDrawWithParameters,r4
add		sp,#0xC
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
NumbersInGringeTable:
.byte 0xD8, 0xDB, 0x9F, 0xA1, 0xA3, 0xA5, 0xA7, 0xC1, 0xE1, 0xE3

.align
Affinity_Name_Text:
@
