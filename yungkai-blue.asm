section .data
  L1 db 'Your morning Eyes',0

  L2 db 0x0A,'I Could stare like watching stars',0

  L3 db 0x0A,'I Could walk you by',0

  L4 db 0x0A,'And i tell without the thought...',0

  time1 dd 0,100000000
  time2 dd 1,100001000

section .text
  global _start

_start:
    
    push L1
    call printf

    push time2
    call timespec

    push L2
    call printf

    push time2
    call timespec

    push L3
    call printf

    push time2
    call timespec

    push L4
    call printf

    mov eax,1
    xor ebx,ebx
    int 0x80

printf:

    push ebp
    mov ebp,esp

    mov esi,[ebp + 8]

.printf@plt:

    mov al,[esi]
    test al,al
    jz done

    mov eax,4
    mov ebx,1
    lea ecx,[esi]
    mov edx,1
    int 0x80

    mov eax,162
    lea ebx,[time1]
    xor edx,edx
    int 0x80

    inc esi
    jmp .printf@plt

timespec:

    push ebp
    mov ebp,esp

    xor esi,esi
    mov dword esi,[ebp + 8]

    mov eax,162
    lea ebx,[esi]
    xor edx,edx
    int 0x80

    jmp done

done:
    
    mov esp,ebp
    pop ebp

    ret
