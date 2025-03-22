section .data
  header:
    db "HTTP/1.1 200 OK", 0x0D,0x0A
    db "Content-Type: text/html", 0x0D,0x0A
    db "Content-Length: 364", 0x0D,0x0A
    db "Connection: close", 0x0D,0x0A
    db 0x0D,0x0A
    incbin "main.html"
    db 0

  header_length equ $ - header
  
section .text
      global _start

_start:

  sub rsp,16
  
  mov word [rsp],2
  mov word [rsp + 2],0x901F
  mov qword [rsp + 4],0
  mov qword [rsp + 8],0

  mov r9,rsp

  push rbp
  mov rbp,rsp
  sub rsp,1024
  
  mov rax,41
  mov rdi,2
  mov rsi,1
  xor rdx,rdx
  syscall

  mov [rbp - 16],rax

  mov qword [rbp - 32],1
  
  mov rax,54
  mov rdi,[rbp - 16]
  mov rsi,1
  mov rdx,2
  lea r10,[rbp - 32]
  mov r8,4
  syscall
  
  mov rax,49
  mov rdi,[rbp - 16]
  mov rsi,r9
  mov rdx,16
  syscall

  mov rax,50
  mov rdi,[rbp - 16]
  mov rsi,5
  syscall

  mov qword [rbp - 64],16

  mov rax,43
  mov rdi,[rbp - 16]
  mov rsi,r9
  lea rdx,[rbp - 64]
  syscall

  mov [rbp - 84],rax

  mov rax,1
  mov rdi,[rbp - 84]
  mov rsi,header
  mov rdx,header_length
  syscall
  
  mov rax,48
  mov rdi,[rbp - 84]
  mov rsi,1
  syscall
  
  mov rax,3
  mov rdi,[rbp - 16]
  syscall

  mov rax,3
  mov rdi,[rbp - 84]
  syscall

  mov rsp,rbp
  pop rbp

  mov rax,60
  xor rdi,rdi
  syscall
