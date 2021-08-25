

%include   "in-out.asm"
;syscall

    sys_getdents  equ 78
    sys_chdir  equ  80

    sys_getdents64 equ  217



;access mode

    O_directory equ  0q0200000



;user define constant
    NewLine    equ  0xA
    bufferLen  equ  536870912

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

getdirectory:
    mov rax,sys_getdents
    syscall
    jle err2
    mov rsi,suces_get
    call printString
    call newLine
    ret
err2:
    mov rsi,error_get
    call printString
    call newLine
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getname:
    ;r8
    mov rdi,directory1
    mov rax,sys_open
    mov rsi,O_RDONLY|O_directory
    syscall
    mov [FD],rax





    mov rax,sys_getdents64
    mov rdi,[FD]
    mov rsi,m
    mov rdx,1000
    syscall
    
    mov r13,m
    
    mov rdx,0
dom:
    
    
    inc rdx

    do:

        
        inc r13
        mov al,[r13]
        cmp al,8
        jne do
        
            
    
        
        add r13,1
    

        xor r11,r11


        mov r9,r13
    
        dec r9
        dec r9
        dec r9
        mov bl,0
    
        cbw
        cwde
        cdqe
        mov r12,rax
        xor rax,rax
        mov r10,0
                
    cmp rdx,r8
    jne dom
        
    
        
    doa:
        add r11,4
        
        mov al,[r13+r10]
        mov byte[buffer1+r10],al
        inc r10
        cmp al,bl
        jne doa
        
        mov rax,1
    mov rdi,1
    mov rsi,buffer1
    mov rdx,50
    syscall

    

    
        ;push r13
        
        
        ;call solve
    

        
        ;pop r13
        

    
    

    ;cmp rbx,r8
    ;jne dom


    mov rax,1
    mov rdi,1
    mov rsi,buffer1
    mov rdx,50
    syscall

    
    ret





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;









solve:


        mov r8,0
doo:
              mov   rdi,directory3
          call  changedir
    inc r8
    call getname
          mov   rdi,directory
          call  changedir


              mov   rdi, buffer1
              call  openFile
              mov   [FDsrc],rax


          mov   rdi,directory2
          call  changedir

              mov   rdi, buffer1
              call  createFile
              mov   [FDdes],rax

    xor rsi,rsi

             mov   rdi, [FDsrc+16]
             mov   rsi,size
             mov   rdx,2 ;read lenght
             call  readFile
             mov qword[size],rsi



;read from source file

                mov   rdi, [FDsrc]
                mov   rsi,mm
                mov   rdx,[size]
                call  readFile
    
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






    mov rcx,128
    mov r14,mm
    mov rdi,[size]
    
    mov eax,[n]  ;meghdare n
kos:
    movd xmm1,eax
        shufps xmm1, xmm1,0h
    
    
    



    
    
    
again:
    
    pxor xmm0,xmm0
    movdqa xmm0,[r14+rcx]
    ;movq xmm0,rdi

    


    paddd  xmm0,xmm1
    
    ;movq   rdi,xmm0
    movdqa    [r14+rcx],xmm0
    add    rcx,16
    cmp    rcx,rdi
    jl     again
    



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;write to destination fileNameDes
              mov   rdi,[FDdes]
              mov   rsi,mm
              mov   rdx,[size]
        ;mov rdx,123
              call  writeFile


;closeFile
              mov   rdi, [FDsrc]
              call  closeFile

              mov   rdi, [FDdes]
              call  closeFile
    cmp r8,3
    jne doo
    ret


section .data

      directory   db   "/home/alireza/Desktop/image",0
    directory1   db   "image",0

      FD          dq   0

          fileNameSrc    db  "LAND.BMP",0
          FDsrc             dq  0;file description


          directory2     db  "/home/alireza/Desktop/folder",0
      directory3     db  "/home/alireza/Desktop/",0
          FDdes              dq  0;file description

      
n     dq 0
      suces_get   dq  "get :)",NewLine,0
      error_get   dq  "error",NewLine,0

      suces_write   dq  "written to file",NewLine,0
      error_write   dq  "error",NewLine,0

        
      suces_chdir   dq  "chnge to file",NewLine,0
      error_chdir   dq  "error",NewLine,0
        number dq 3
      size          dq  0
      m        dq  0
      align        16
      mm        dq  0
      




section .bss
          buffer      resb  bufferLen
      buffer1     resb  bufferLen

section .code
      global _start

_start:

       call readNum
    mov [n],eax

    xor rax,rax

         ; call getname
         call solve

              mov rax,sys_exit
              xor rdi,rdi
              syscall
