%include   "in-out.asm"
section .data
        operation     dq    '+-*/'
        input         dq    142
        leninput      equ   ($-input)

;input         dq    '2+6/5-41+12*32/5-7+1',0xA
;12+5/3*6-12+73/4+123


section .text
        global _start



ifa:
    push rsi
    jmp calc

lentgh:                           ;baraye mohasebe  tedade char string
    dec rdi
loop:
    xor bl,bl
    inc rdi
    mov al,[input+rdi]
     cmp bl,al
      jne loop

endlenght:
    
    ret
    
    

input1:                ;gerftane vorodi
    
    
  mov rax,0
  mov rdi,0
  mov rsi,input
  mov rdx,1024
  syscall




tavan:                ;mohasebe tavan
    
    push dx
    

    mov r14,1
do2:
    cmp dx,0
    je endtavan
    mov r13,r14
    mov r15,10
    call mul
    dec dx
    jmp do2
endtavan:
    pop dx
    mov r15,r14
    ret



    
check1:
    pop rcx
    pop rdx
    push rdx
    push rcx
        cmp rdx,-5  ;+
    je endo
        cmp rdx,-3  ;-
    je endo
    cmp rdx,'###'
    jne calc
    jmp endo

div:
    mov r15,0
    mov r14,-1
    
    do1:
        add r15,r10
        inc r14
        cmp r15,r8
        jbe do1

    push r14

    jmp check




mul:                  ;zarb r14*r15 ba in tafavot ke r13 ham migirad va dar an baayad haman meghdar r14 bashad
    cmp r15,1
    je endmul

    cmp r15,0
    je end1mul

    add r14,r13
    dec r15
    cmp r15,1
    jne mul
endmul:
    ret

end1mul:
    mov r14,0
    ret
    



mult:                    ;baraye tamizi ba dadane paramter ha baraye anjame zarb
    mov r13,r8
    mov r14,r8
    mov r15,r10
    call mul
    push r14
    jmp check



add:
    add r8,r10
    push r8
    jmp check

sub:
    sub r8,r10
    push r8
    jmp check


olaviat:        ;check kardan olaviat ba moghyese amal vande ghbli va dar sorate ke lazem bashad olaviat haye bishtar ra hesab konad
    pop r12

    cmp bx,1
    je endo

    mov r11,1
    jmp calc
    


endo :
    mov r11,0
    push r12
    ret
    

oa:
    call olaviat

    mov dx,0
    mov bx,1
    push -5
    jmp con

os:
    call olaviat
    mov dx,0
    mov bx,1
    push -3
    jmp con


    
om:
    mov dx,0
    mov bx,2
    push -6
    jmp con

od:
    mov dx,0
    mov bx,2
    push -1
    jmp con
         
    
    



_start:
    
    xor rdi,rdi
    xor rax,rax
    xor rsi,rsi
    xor rdx,rdx
    xor rbx,rbx
    xor rcx,rcx             ;baaraye sefr kardan moteghaie haye estefade shode baraye gereftane dobare vorodi
    mov r11,1024
erasem:                    ; pak kardan hafeze
    cmp r11,-1
    je start
    mov dword [input+r11],0
    dec r11
    jmp erasem


start:
    call input1
    
    mov r11,0xa646E65  ;baraye tamam kardan kalame 'end' ra vered konid

ani:
    mov rax,[input]
ana:
    cmp r11,rax
    
    je exit


    mov r11,0
        call lentgh
        mov dx,0
    mov bx,1
    dec rdi

    pop rsi
    push '###'

    



again:
    dec rdi
        mov al,[input+rdi]

    sub al,48


an1:
        cmp al,-5  ;+        ;peida kardan olabiat morede nazar va ba tavajo be olaviat push kardan dar sack
    je oa
    cmp al,-3  ;-
        je os            ;manande bala
    cmp al,-6  ;*
    je om            ;mananade bala
    cmp al,-1  ;/
        je od            ;manande bala

    cbw
    cwde
    cdqe
    ;mov rax,al

    cmp dx,0
    je tak        ; chon be sorate charecter adado migirim bayaad check kard charackter ghbli adad bode ya kheir




    
    call tavan

    mov r13,rax
    mov r14,rax
    pop rax
    
    call mul
    


    add rax,r14        ; baraye mohase adade morede nazar 123=100*1+10*2+3

tak:
    push rax
    inc dx
    
con:
        
        cmp rdi,0
        ja again

    mov al,[input]
    
    cmp al,48
    jb ifa

calc:                ;mohasebat dakhele stack be in sorat 3 ta pop karde va hasel ra push mikond
    pop r8
    pop r9
    pop r10
ane:
        cmp r9,-5  ;+
    je add
        cmp r9,-3  ;-
    je sub
        cmp r9,-6  ;*
    je mult
    cmp r9,-1 ;/
    je div
check:

    cmp r11,1        ;baraye inke agar be oliaviat kamtar khordim va dakhele stack mohasebat ra anjam dadim bfhmim ke hanoz bayad edame dad
    je check1
tof:
    pop rcx
    pop rdx
    cmp rdx,'###'
    push rdx
    push rcx
    jne calc
    

    mov rax,rcx
    call writeNum
    call newLine
    jmp _start

;aalgoritm in barname algoritm mohasebe ba stack ast va hamchenib baraye rahati adad ra az samte rast mikhanim hamchenin baraye vorodi hich space nabayad gozasht va hamchenin baraye khoroj kalame bit ra benevisid



exit:
    mov rax,60
    mov rdi,0
    syscall

