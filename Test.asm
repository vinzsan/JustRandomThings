[BITS 16]
[org 7C00h]

section .text
  global _start

_start:
  
  mov ah,0x0E
  mov si,str

printf:
  
  mov al,[si]
  cmp al,0
  je halt
  int 0x10
  inc si
  jmp printf

halt:
  
  hlt 

  str db 'Aku Hitam',0

times 