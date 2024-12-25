section .data
  nama_file db 'file_kalian.txt',0

  L1 db 0x1B,'[32m[+] File telah di temukan',0x1B,'[0m',0
  E1 equ $ - L1

  L2 db 0x1B,'[31m[!] File tidak ditemukan!',0x1B,'[0m',0
  E2 equ $ - L2

section .bss
  B1 resd 1024

section .text
  global _start

_start:

  mov eax,5
  mov ebx,nama_file
  xor ecx,ecx
  xor edx,edx
  int 0x80

  mov ebx,eax
  cmp eax,0
  js F1

  mov eax,3
  mov ecx,B1
  mov edx,1024
  int 0x80

  mov eax,4
  mov ebx,1
  mov ecx,B1
  mov edx,1024
  int 0x80

  mov eax,4
  mov ebx,1
  mov ecx,L1
  mov edx,E1
  int 0x80

  jmp exit

F1:

  mov eax,4
  mov ebx,1
  mov ecx,L2
  mov edx,E2
  int 0x80

  jmp exit

exit:

  mov eax,6
  xor ebx,ebx
  int 0x80

  mov eax,1
  xor ebx,ebx
  int 0x80
