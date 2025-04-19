section .data
    L1:
        db "HTTP/1.1 200 OK",0x0A,0x0D
        db "Content-Type : text/html",0x0A,0x0D
        db "Content-Length : 32",0x0A,0x0D
        db "Connection : close",0x0A,0x0D
        db 0x0A,0x0D
        db "<h1>Hello world</h1>"

    length equ $ - L1

section .text
    global _start

_start:
    
    sub rsp,16

    mov word [rsp],2
    mov word [rsp + 2],0x901F
    mov dword [rsp + 8],0
    mov qword [rsp + 16],0

    mov r12,rsp
    
    xor rbp,rbp
    and rsp,-16
    push rbp
    mov rbp,rsp
    sub rsp,1024
    
    mov rax,41
    mov rdi,2
    mov rsi,1
    xor rdx,rdx
    syscall

    mov [rbp - 8],rax
    mov dword [rbp - 16],1

    mov rax,54
    mov rdi,[rbp - 8]
    mov rsi,1
    mov rdx,2
    lea r10,[rbp - 16]
    mov r8,4
    syscall

    mov rax,49
    mov rdi,[rbp - 8]
    mov rsi,r12
    mov rdx,16
    syscall

    mov rax,50
    mov rdi,[rbp - 8]
    mov rsi,1
    syscall

    mov qword [rbp - 32],16
    
    mov rax,43
    mov rdi,[rbp - 8]
    mov rsi,r12
    lea rdx,[rbp - 32]
    syscall
    
    mov [rbp - 64],rax
    
    mov rax,9
    xor rdi,rdi
    mov rsi,1024
    mov rdx,0x02
    mov r10,0x22
    mov r8,-1
    mov r9,0
    syscall
    
    mov [rbp - 128],rax

    mov rax,44
    mov rdi,[rbp - 64]
    lea rsi,[rel L1]
    mov rdx,length
    mov r10,0
    mov r8,0
    mov r9,0
    syscall

    mov rax,45
    mov rdi,[rbp - 64]
    mov rsi,[rbp - 128]
    mov rdx,1024
    mov r10,0
    mov r8,0
    mov r9,0
    syscall

    mov [rbp - 256],rax
    
    mov rax,1
    mov rdi,1
    mov rsi,[rbp - 128]
    mov rdx,[rbp - 256]
    syscall

    mov rax,11
    mov rdi,[rbp - 128]
    mov rsi,1024
    syscall
    
    mov rax,3
    mov rdi,[rbp - 8]
    syscall

    mov rax,3
    mov rdi,[rbp - 64]
    syscall

    leave
    
    mov rax,60
    xor rdi,rdi
    syscall

    int 3
