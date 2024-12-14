P1:

  mov eax,4
  mov ebx,1
  mov ecx,[esp + 4]
  mov edx,[esp + 8]
  int 0x80

  ret 

section .data
  L1 db 'vinz',0

  L2 db 'Data Cocok',0
  E2 equ $ - L2

  L3 db 'Data tidak cocok',0
  E3 equ $ - L3

section .bss
  B1 resb 128

section .text
  global _start

_start:

  mov eax,3
  mov ebx,0
  mov ecx,B1
  mov edx,128
  int 0x80

  mov ebx,eax
  dec ebx

  cmp byte [ebx + B1],0x0D
  je F1

  cmp byte [ebx + B1],0x0A
  je F1

F1:

  mov byte [ebx + B1],0
  jmp F2

F2:

  mov esi,L1
  mov edi,B1
  jmp F3

F3:

  mov al,[esi]
  mov bl,[edi]
  cmp al,bl
  jne F5
  cmp al,0
  je F4
  inc esi
  inc edi
  jmp F3

F4:

  push E2
  push L2
  call P1

  add esp,8

  jmp exit

F5:

  push E3
  push L3
  call P1

  add esp,8

  jmp exit

exit:

  mov eax,1
  xor ebx,ebx
  int 0x80
