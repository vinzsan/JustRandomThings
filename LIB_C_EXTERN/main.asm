%include 'header.inc' ;filenya saya include dari sini

;untuk extern bisa saja disini tidak usah menggunakan .inc
;seperti
;extern printf
;dan lainnya

section .data
  L1 db 'Print out menggunakan lib.c %s',10,0

section .bss
  B1 resd 1

section .text
  global main ;Disini tidak bisa menggunakan entry _start

main:
    
    mov eax,B1
    push eax
    push L1
    call printf

    mov eax,1
    xor ebx,ebx
    int 0x80
