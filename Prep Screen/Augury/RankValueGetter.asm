.thumb
.include "_Augury_Defs.asm"

@r0=chapter id, r1=rank id, r2=letter

push    {r4,r14}
cmp     r0,#max_chapter_id
bgt     RetFalse
mov     r4,#96
mul     r0,r4
ldr     r4,RankingTable
add     r4,r0               @beginning of chapter's entry in r4
ldr     r3,=gChapterData
ldrb    r3,[r3,#0x14]
mov     r0,#0x40            @hard mode bit
and     r3,r0
cmp     r3,#0
beq     hardPass
mov     r3,#1
hardPass:
cmp     r1, #Tactics
beq     tactics  
cmp     r1, #Experience
beq     experience
cmp     r1, #Power
beq     power 
cmp     r1, #Funds
beq     funds
RetFalse:
mov     r0,#0
b       GoBack

tactics: 
@tactics offset is 0, no need to change r4
lsl     r3,#3               @putting hard mode offset for tactics rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#1               @each tactics entry has 2 bytes, so lshift by 1 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldrh    r0,[r4]             @each tactics entry is a short. Moving its value from the offset in r4 to r0
b       GoBack

power: 
add     r4,#16              @power entries start at 16
lsl     r3,#3               @putting hard mode offset for power rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#1               @each power entry has 2 bytes, so lshift by 1 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldrh    r0,[r4]             @each power entry is a short. Moving its value from the offset in r4 to r0
b       GoBack

experience: 
add     r4,#32              @experience entries start at 32
lsl     r3,#4               @putting hard mode offset for experience rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#2               @each experience entry has 4 bytes, so lshift by 2 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldr     r0,[r4]             @each experience entry is a word. Moving its value from the offset in r4 to r0
b       GoBack

funds: 
add     r4,#64              @funds entries start at 64
lsl     r3,#4               @putting hard mode offset for funds rank on r3
add     r4,r3               @adding hard mode offset to r4
lsl     r2,#2               @each funds entry has 4 bytes, so lshift by 2 on letter (0-A, D-3) gives its offset
add     r4,r2               @adding letter offset to r4
ldr     r0,[r4]             @each funds entry is a word. Moving its value from the offset in r4 to r0

GoBack:
pop     {r4}
pop     {r1}
bx      r1

.ltorg
RankingTable:
@
