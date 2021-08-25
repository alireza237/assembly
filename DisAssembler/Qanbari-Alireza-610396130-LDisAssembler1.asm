%include "in-out.asm"

section .data
	opcodes    dq 0x0FBC,"bsf",0xFBD,"bsr",0x3F0,"xadd",0x21,"xchg",0x3D,"not", 0x3D,"neg", 0x3F,"inc",0x3F,"dec"

	itr dq "not", "neg", "inc", "dec"
	
	opcodes0  dq  "F9","stc","F8","clc","FD","std","FC","cld","0F05","syscall","C3","ret"


	reg_8 dq "al" , "cl" , "dl" , "bl" , "ah" , "ch" , "dh" , "bh" , "r8b" , "r9b" , "r10b" , "r11b" , "r12b" , "r13b" , "r14b" , "r15b"

reg_16 dq "ax" , "cx" , "dx" , "bx" , "sp" , "bp" , "si" , "di" , "r8w" , "r9w" , "r10w" , "r11w" , "r12w" , "r13w" , "r14w" , "r15w"

reg_32 dq "eax" , "ecx" , "edx" , "ebx" , "esp" , "ebp" , "esi" , "edi" , "r8d" , "r9d" , "r10d" , "r11d" , "r12d" , "r13d" , "r14d" , "r15d"

reg_64 dq "rax" , "rcx" , "rdx" , "rbx" , "rsp" , "rbp" , "rsi" , "rdi" , "r8" , "r9" , "r10" , "r11" , "r12" , "r13" , "r14" , "r15"
sss dq "00", "1", "01", "2", "10", "4", "11", "8"

	tof dq "            "
	xh dq "xchg "
	opcode dq "       "
	r_w dq 0
	r_r dq 0
	r_x dq 0
	r_b dq 0
	ss1 dq "  "
	iinx dq "   "
	bas dq "  "
	disp dq "                          "
	w dq "  "
	d dq "  "
	p1 dq "  "
	p2 dq "  "
	p3 dq "  "
	prefix1 dq "  "
	prefix2 dq "  "
	p1_out dq "    "
	p2_out dq "    "
	p3_out dq "    "
	Wor dq "    "
	memory dq "False"
	chap dq "       "
	vorodi dq "4A0FBC048512131415"
	mod dq "      "
	reg dq "      "
	r_m dq "      "

section .text
	global _start

_start:	

	mov r15,[vorodi]
	mov rdi,vorodi
	call GetStrlen
	mov r11,rdx
	mov r10,0

	mov r14,opcodes0
	

	mov rcx,0
do:
	cmp r15,[r14+rcx*8]
	je zo
	inc rcx
	cmp rcx,12
	jne do

	
	
	mov ax,[vorodi+r10]

	cmp ax,"67"
	jne pc1
	mov Word [prefix1],"67"
	inc r10
	inc r10
pc1:

	mov ax,[vorodi+r10]
	cmp ax,"66"
	jne pc2
	mov Word [prefix2],"66"
	inc r10
	inc r10
	
	
pc2:
	
	mov al,[vorodi+r10]
	cmp al,"4"
	jne rxc
	call Rex
	inc r10
	inc r10
rxc:	
	push r11
	sub r11,r10

	cmp r11,2
	jne xec

	inc r10
	
	mov rax,0
	mov al,[vorodi+r10]

	and al,0xF
	mov rdx,[r_b]
	shl rdx,3
	or rdx,rax
	mov [p1],rdx

	mov rax,[r_r]
	shl rax,3
	mov [p2],rax
	
	mov Qword[w],1

	call p_out
	mov rsi,xh
	call printString

	mov rsi,p1_out
	call printString
	
	mov rax,","
	call putc

	mov rsi,p2_out
	call printString

	jmp exit

	pop r11
		

xec:	
	add r11,r10
	mov rbx,0
	mov rax,0
	mov al,[vorodi+r10]
	call htd
	mov bl,al
	inc r10
an:
	mov al,[vorodi+r10]
	call htd
	shl rbx,4
	or rbx,rax
	inc r10

	mov al,[vorodi+r10]
	call htd
	shl rbx,4
	or rbx,rax
	inc r10

	mov al,[vorodi+r10]
	call htd
	shl rbx,4
	or rbx,rax
	sub r10,3

	
	mov r13,4
	mov r14,-1
doo1:
	inc r14
	cmp rbx,[opcodes+r14*8]
	je coc		
	cmp r14,15
	jne doo1
	mov Byte[tof],1
	mov r13,3
	mov r14,-1
;;;;;;;;;;;;;;;;;;;;
	shr rbx,2
	
	
doo2:	
	inc r14
	cmp rbx,[opcodes+r14*8]
	je coc
	cmp r14,15
	jne doo2
;;;;;;;;;;;;;;;;;;;;;;;;;;
	shr rbx,6
	mov r13,1
	
	mov r14,-1
doo3:
	inc r14
	cmp rbx,[opcodes+r14*8]
	je coc		
	cmp r14,15
	jne doo3

	

coc:
	add r10,r13
	inc r14
	mov rbx,[opcodes+r14*8]
	mov [opcode],rbx


	cmp qword[tof],1
	jne edame1
	mov rax,0

	inc r10
	mov al,[vorodi+r10]
	call htd
	shl al,6
	shr al,6
	mov [d],al
	shl al,7
	shr al,7
	mov [w],al
	jmp edame2

edame1:
	mov Byte[w],1 
edame2:
	
	
	
	mov al,[vorodi+r10]
	call htd
	mov bl,al
	shr bl,2
	mov [mod],bl
b1:
	mov bl,al
	shl bl,6
	shr bl,6
	mov [reg],bl

	inc r10
	mov al,[vorodi+r10]
	call htd
	
	mov bl,al
	shr bl,3
	
	mov cl,[reg]
	shl cl,1
	or bl,cl
	mov [reg],bl

	mov bl,al
	shl bl,5
	shr bl,5
	mov [r_m],bl

	inc r10
	cmp Byte[r_m],4
	jne edame3
	call sib

edame3:
	mov rcx,0
	
halghe1:

	cmp r10,r11
	je cdis
	
	
	mov rbx,0
	mov bx,[vorodi+r10]
	
	
	shl rcx,16
	or rcx,rbx
	
	inc r10
	inc r10
	jmp halghe1
cdis:		
	mov [disp],rcx
edame4:
	mov Byte[tof],1
	cmp Byte[r_m],4
	jne edame5
	
	mov r9,0
	mov r8,[r_r]
	mov r9b,[reg]
	shl r8,3
	or r8,r9
	mov [p1],r8
b11:
	mov r8,[r_b]
	mov r9b,[bas]
	shl r8,3
	or r8,r9
	mov [p2],r8
b22:
	mov r8,[r_x]
	mov r9b,[iinx]
	shl r8,3
	or r8,r9
	mov [p3],r8


edame5:	
	


	
exit: 
	call newLine
	mov rax,1
	mov rbx,0
	int 80h
zo:
	inc rcx
	mov rax,[r14+rcx*8]
	mov [chap],rax
	mov rsi,chap
	call printString
	call newLine
	jmp exit

Rex:
	inc r10
	mov al,[vorodi+r10]

	call htd

	mov bl,al
	and bl,0x1
	mov [r_b],bl

	mov bl,al
	and bl,0x2
	shr bl,1
	mov [r_x],bl

	mov bl,al
	and bl,0x4
	shr bl,2
	mov [r_r],bl

	mov bl,al
	and bl,0x8
	shr bl,3
	mov [r_w],bl
	
	
	dec r10
	ret
	
p_out:
	
	push r11
	
	cmp Qword[prefix2],"66"
	jne c1
	mov r11,[p1]
	mov r12,[p2]
	mov rax,[reg_16+r11*8]
	mov rdx,[reg_16+r12*8]
	mov [p1_out],rax
	mov [p2_out],rdx
	pop r11
	ret
	
c1:
	cmp qword[r_w],1
	jne c2
	mov r11,[p1]
	mov r12,[p2]
	mov rax,[reg_64+r11*8]
	mov rdx,[reg_64+r12*8]
	mov [p1_out],rax
	mov [p2_out],rdx
pop r11
	ret
c2:
	cmp qword[w],1
	jne c3
	mov r11,[p1]
	mov r12,[p2]
	mov rax,[reg_32+r11*8]
	mov rdx,[reg_32+r12*8]

	mov [p1_out],rax
	mov [p2_out],rdx
pop r11
	ret
	
c3:
	
	mov r11,[p1]
	mov r12,[p2]
	mov rax,[reg_8+r11*8]
	mov rdx,[reg_8+r12*8]
	mov [p1_out],rax
	mov [p2_out],rdx
pop r11

	ret
	
	
		


get:
	mov rax,-1

do1:
	inc rax
	mov rbx,[r13]
	mov rdx,[r12+rax]
	cmp rbx,rdx
	jne do1
	inc rax
	mov rcx,[r12+rax]
	ret

htd:
	sub al,0x30
	cmp al,10
	jb ccc1
	
	sub al,7
ccc1:
	ret

sib:
	
	mov al,[vorodi+r10]
	call htd
	
	mov bl,al
	shr bl,2
	
	mov [ss1],bl
	mov bl,al
	shl bl,6
	shr bl,6
	mov [iinx],bl

	inc r10
	mov al,[vorodi+r10]
	call htd
	
	mov bl,al
	shr bl,3
	
	mov cl,[iinx]
	shl cl,1
	or bl,cl
	mov [iinx],bl
	mov bl,al
	shl bl,5
	shr bl,5
	mov [bas],bl
	inc r10
	
ret
	

	
