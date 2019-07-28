.thumb
.include "_Support_Defs.asm"

@r0 = proc+0x2C

push	{r4,r14}
mov		r4,r0

mov		r0,#0
strb	r0,[r4,#Proc_SupportTopRow]
@SupportLastRow set up in Make_Support_Pane
strb	r0,[r4,#Proc_SupportCurrentRow]
strb	r0,[r4,#Proc_SupportCurrentColumn]
@NumberOfSupports set up in Make_Support_Pane
@Sprites
mov		r0,#(8*(SupportEntry_X)-4)
strb	r0,[r4,#Proc_SupportHandX]
mov		r0,#(8*SupportEntry_Y)
strb	r0,[r4,#Proc_SupportHandY]
@Layer stuff
ldr		r2,=gLCDControlBuffer
mov		r0,#(8*SupportEntry_X)
neg		r0,r0
strh	r0,[r2,#BG1HOFS]
mov		r0,#(8*SupportEntry_Y)
neg		r0,r0
strh	r0,[r2,#BG1VOFS]
strh	r0,[r4,#Proc_CurrentLayer1]
strh	r0,[r4,#Proc_NewLayer1]

pop		{r4}
pop		{r0}
bx		r0

.ltorg
