section .data
  L1 db 'Test',0
  E1 equ $ - L1

  L4 db 'Test',0

  L2 db 'Sama',0
  E2 equ $ - L2

  L3 db 'Tidak sama',0
  E3 equ $ - L3

section .bss
  B1 resb 32
  B2 resb 32

section .text
  global _start

_start:
  
  mov esi,L1
  mov edi,L4
  call P1
  cmp eax,0
  je equal
  jnz not_equal

equal:

  push L2
  push E2
  call P3

  jmp exit

not_equal:
  
  push L3
  push E3
  call P3

  jmp exit

exit:

  mov eax,1
  xor ebx,ebx
  int 0x80

P1:

  xor eax,eax

P2:

  mov al,[esi]
  mov bl,[edi]
  cmp al,bl
  jne end
  cmp al,0
  je end
  inc esi
  inc edi
  jmp P2

end:

  sub eax,ebx
  ret

P3:
  
  mov eax,4
  mov ebx,1
  mov ecx,[esp + 8]
  mov edx,[esp + 4]
  int 0x80
  retn 8
