%include "in-out.asm"

;syscall


    sys_getdents  equ 78
    sys_chdir  equ  80

    sys_getdents64 equ  217



;access mode

    O_directory equ  0q0200000



;user define constant
    NewLine    equ  0xA
    bufferLen  equ  256

createFile:                  ;rdi = file name, rsi = file permission
    mov  rax, sys_create
    mov  rsi, sys_IRUSR|sys_IWUSR
    syscall
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

openFile:                  ;rdi = file name, rsi = file access mode
    mov  rax, sys_open
    mov  rsi, O_RDWR
    syscall
    
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

appendFile:
    mov  rax, sys_open
    mov  rsi, O_RDWR | O_APPEND
    syscall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

writeFile:                  ;rdi = file descriptor, rsi = buffer, rdx = length
    mov  rax, sys_write
    syscall
    cmp rax,-1
    jle err
    mov rsi,suces_write
    call printString
    call newLine
    ret
err:
    mov rsi,error_write
    call printString
    call newLine
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

readFile:                  ;rdi = file descriptor, rsi = buffer, rdx = length
    mov  rax, sys_read
    syscall
    mov byte[rsi+rax],0
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

closeFile:                  ;rdi = file descriptor
    mov  rax, sys_close

    syscall
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

seekFile:                  ;rdi = file descriptor, rsi = offset, rdx = whence
    mov  rax, sys_lseek
    syscall
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


changedir:
    mov  rax, sys_chdir
    syscall
    cmp rax,-1
    jle err1
    mov rsi,suces_chdir
    call printString
    call newLine
    ret
err1:
    mov rsi,error_chdir
    call printString
    call newLine
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data

	error_open     db "ridi",NewLine,0
	suces_open     dq "naridi",NewLine,0
	fileNameSrc    db  "LAND.BMP",0
	FDsrc          dq  0;file description


	directory3     db  "/home/alireza/Desktop/project/diss",0
	FDdes          dq  0;file description



	suces_get      dq  "get :)",NewLine,0
	error_get      dq  "error",NewLine,0

	suces_write    dq  "written to file",NewLine,0
	error_write    dq  "error",NewLine,0


	suces_chdir    dq  "chnge to file",NewLine,0
	error_chdir    dq  "error",NewLine,0
	number dq 3
	
	opcodes0  dq  "f9","stc","f8","clc","fd","std","fc","cld","0f05","syscall","c3","ret"

	chap      dq "              "
	input     dq "input_asm.txt",0
	output    dq "610396130.txt",0
	counter   dq 0
	tof1 dq   0xA


section .bss
 
        buffer      resb  bufferLen
	dastor	    resq  1000
	chap1	    resq  1000
	khoroji	    resb  bufferLen
	
        
section .text
	global _start


_start:	


;openfile
        mov   rdi,directory3
        call  changedir
	mov   rdi, input
	call  openFile
	mov   [FDsrc],rax


;read from source file

	mov   rdi, [FDsrc]
	mov   rsi,buffer
	mov   rdx,bufferLen
	call  readFile




	mov rsi,buffer	
	mov r15,[buffer]
	mov rdi,buffer
	call GetStrlen
	mov r11,rdx
	mov r10,0

	
	mov rax,0
	mov rbx,0
	mov r13,0
	dec r11
	dec r11
dov:	
	mov al,[buffer+r11]
	cmp al,0xA
	je con1
	shl rax,8
	or rbx,rax
	dec r11
	cmp r11,-1
	jne dov
	je con2


con1:

	shr rax,8
	mov [dastor+r13*8],rax
	inc r13
	dec r11
	mov rax,0
	mov rbx,0
	jmp dov
	


con2:
	
	or rbx,rax
	shr rax,8
	mov [dastor+r13*8],rax
	
	
hal1:

	mov r15,[dastor+r13*8]
	call find_z
	dec r13
	cmp r13,-1
	jne hal1


	mov rdi,[FDsrc]
	call closeFile


        mov   rdi,directory3
        call  changedir
	mov   rdi, output
	call  createFile
	mov   [FDsrc],rax

	mov r11,0	
doend:
	mov rax,[chap1+r11*8]
	inc r11
	push r11
	mov [khoroji],rax
	mov rdi,khoroji
	call GetStrlen

	mov rdi,[FDsrc]
	mov rsi,khoroji
	mov rdx,rdx
	call writeFile

	mov rdi,[FDsrc]
	mov rsi,tof1
	mov rdx,1
	call writeFile

	pop r11
	cmp r11,[counter]
	jne doend
	
	



	mov rdi,[FDsrc]
	call closeFile
	
	

	
exit: 
	call newLine
	mov rax,1
	mov rbx,0
	int 80h


find_z:
	mov r14,opcodes0
	mov rcx,0


do:
	cmp r15,[r14+rcx*8]
	je zo
	inc rcx
	cmp rcx,12
	jne do

	push r8
	mov r8,[counter]
	mov Qword[chap1+r8*8],"#"
	inc r8
	mov [counter],r8	
	pop r8
	
	ret
	
zo:
	inc rcx
	mov rax,[r14+rcx*8]
	push r8
	mov r8,[counter]
	mov [chap1+r8*8],rax

	inc r8
	mov [counter],r8
	
	pop r8
	
	
	ret


	
