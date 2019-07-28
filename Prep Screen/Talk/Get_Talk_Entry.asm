.thumb
.include "_Talk_Defs.asm"

@r0=beginning of chapter talk entries, r1=number of entry we want
@return pointer to that entry

mov		r2,#LengthOfTalkEntry
mul		r1,r2
add		r0,r1
bx		lr
