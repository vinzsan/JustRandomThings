section .data
  L1 db 'True',0
  E1 equ $ - L1

  L2 db 'False',0
  E2 equ $ - L2

section .text
  global _start

_start:
    
    push 11
    push 11
    call F1

    add esp,8


F2:

    mov eax,4
    mov ebx,1
    mov ecx,L1
    mov edx,E1
    int 0x80

    jmp exit

F3:

    mov eax,4
    mov ebx,1
    mov ecx,L2
    mov edx,E2
    int 0x80

    jmp exit

exit:

    mov eax,1
    xor ebx,ebx
    int 0x80

F1:

    enter 8,0

    mov esi,[ebp + 8]
    mov edi,[ebp + 12]

    mov dword [ebp - 4],esi
    mov dword [ebp - 8],edi

    mov eax,[ebp - 4]
    mov ebx,[ebp - 8]
    sub eax,ebx
    cmp eax,0
    je F2
    jnz F3

    leave

    ret