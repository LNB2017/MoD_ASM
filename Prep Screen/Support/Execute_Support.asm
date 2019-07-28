.thumb
.include "_Support_Defs.asm"

.equ Set_Support_By_Index, Get_Support_By_Index+4
.set UnlockCharactersSupports, Set_Support_By_Index+4
.equ Get_Supporter_Data,  UnlockCharactersSupports+4
.equ SupportViewedEventID, Get_Supporter_Data+4

push	{r4-r7,r14}
add		sp,#-8
str		r0,[sp]
mov		r4,r0
add		r4,#Proc_InitialOffset

ldrb	r0,[r4,#Proc_UnitCurrentChar]
lsl		r0,#2
ldr		r1,=UnitListLocation
ldr		r5,[r1,r0]
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
ldr		r3,Get_Support_By_Index
_blr	r3
@if we got here, it's already assumed that a valid option was chosen
ldrb	r1,[r4,#Proc_SupportCurrentColumn]		@this is actually the conversation we'll be reviewing
lsl		r1,#1
sub		r1,#1
cmp		r0,r1
beq		SupportNotPreviouslyViewed
@Old support
ldrb	r6,[r4,#Proc_SupportCurrentColumn]
lsl		r6,#1		@because I messed up in PlayEvent, I have to set r6 to this
mov		r1,#0
strb	r1,[r4,#Proc_IsNewSupport]
ldr		r0,SupportViewedEventID
_blh	SetEventID
b		PlayEvent

SupportNotPreviouslyViewed:
@Things to do: Set support for current char. Set support for partner. Check if this unlocks other talks, and set accordingly. If S/A+ support was selected, remove any other potential S/A+ talks
mov		r1,#1
strb	r1,[r4,#Proc_IsNewSupport]
add		r6,r0,#1
ldrb	r1,[r4,#Proc_SupportCurrentRow]
mov		r2,r6
mov		r0,r5
ldr		r3,Set_Support_By_Index
_blr	r3
cmp		r6,#8
blt		Label1
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
bl		UnsetOtherPairedSupports
Label1:
mov		r0,r5
ldr		r3,UnlockCharactersSupports
_blr	r3
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
_blh	GetCharIdBySupportIndex
_blh	GetUnitByCharID
cmp		r0,#0
beq		PlayEvent		@shouldn't happen
mov		r7,r0
ldr		r1,[r5]
ldrb	r1,[r1,#4]
bl		FindIndexGivenCharID
cmp		r0,#0
blt		PlayEvent		@also shouldn't happen
str		r0,[sp,#4]
mov		r2,r6
mov		r1,r0
mov		r0,r7
ldr		r3,Set_Support_By_Index
_blr	r3
cmp		r6,#8
blt		Label2
mov		r0,r7
ldr		r1,[sp,#4]
bl		UnsetOtherPairedSupports
Label2:
mov		r0,r7
ldr		r3,UnlockCharactersSupports
_blr	r3

PlayEvent:
@ldr		r0,=BGLayer2
@mov		r1,#0
@_blh	FillBgMap
@mov		r0,#4
@_blh	EnableBGSyncByMask
mov		r0,r5
ldrb	r1,[r4,#Proc_SupportCurrentRow]
ldr		r3,Get_Supporter_Data
_blr	r3
add		r0,#8
sub		r6,#2
lsl		r6,#1
ldr		r0,[r0,r6]
cmp		r0,#0
beq		GoBack
ldr		r1,[sp]
_blh	CallEventEngineWithProc
GoBack:
add		sp,#8
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg


FindIndexGivenCharID:
@r0=char data pointer, r1=char id to find index of
push	{r4,r14}
ldr		r0,[r0]
ldr		r4,[r0,#44]
ldrb	r3,[r4]		@number of supports
mov		r0,#0
add		r4,#4
IndexLoop:
cmp		r0,r3
beq		RetMinusOne
ldrb	r2,[r4]
cmp		r1,r2
beq		ReturnIndex
add		r0,#1
add		r4,#0x18
b		IndexLoop
RetMinusOne:
mov		r0,#1
neg		r0,r0
ReturnIndex:
pop		{r4}
pop		{r1}
bx		r1


UnsetOtherPairedSupports:
@r0=unit data, r1=index

push	{r4-r7,r14}
mov		r4,r0
mov		r5,r1
_blh	GetNumberOfSupports
mov		r7,r0
mov		r6,#0
PairedSupportCheckLoop:
cmp		r6,r7
beq		EndPairedSupports
cmp		r6,r5
beq		NextPairedSupport
mov		r0,r4
mov		r1,r6
ldr		r3,Get_Support_By_Index
_blr	r3
cmp		r0,#6
ble		NextPairedSupport
mov		r0,r4
mov		r1,r6
mov		r2,#6
ldr		r3,Set_Support_By_Index
_blr	r3
NextPairedSupport:
add		r6,#1
b		PairedSupportCheckLoop
EndPairedSupports:
pop		{r4-r7}
pop		{r0}
bx		r0

.ltorg
Get_Support_By_Index:
@

