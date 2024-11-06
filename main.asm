section .data
  a db 'Test',0  ;Print out Test string
  len equ $ - a

section .text
  global _start

_start:

  mov eax,4
  mov ebx,1
  mov ecx,a
  mov edx,len
  int 0x80

  mov eax,1
  xor ebx,ebx
  int 0x80
