.thumb

@r0=unit ptr, r1=index

push	{r14}
ldr		r3,Get_Support_By_Index
bl		bx_r3
lsr		r0,#1		@gives rank
pop		{r1}
bx		r1

bx_r3:
bx		r3

.align
Get_Support_By_Index:
@
