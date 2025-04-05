section .data
	header:
		db "GET / HTTP/1.1", 0x0D, 0x0A
		db "Host: google.com", 0x0D, 0x0A
		db "Connection: close", 0x0D, 0x0A
		db 0x0D, 0x0A
	length equ $ - header
 ; My code is broken,so this is just simple version. Sorry :(

section .text
	global _start

_start:

	xor rbp,rbp
	and rsp,-16

.struct_sockaddr_in:

	sub rsp,16
	
	mov word [rsp],2
	mov word [rsp + 2],0x5000
	mov qword [rsp + 4],0xD15BDF58
	mov qword [rsp + 8],0

	mov r12,rsp
	
main:

	push rbp
	mov rbp,rsp
	sub rsp,1024

	mov rax,9
	xor rdi,rdi
	mov rsi,1024 * 4
	mov rdx,0x02
	mov r10,0x22
	mov r8,-1
	mov r9,0
	syscall

	mov r15,rax

	mov rax,41
	mov rdi,2
	mov rsi,1
	xor rdx,rdx
	syscall

	mov [rbp - 16],rax

	mov rax,42
	mov rdi,[rbp - 16]
	mov rsi,r12
	mov rdx,16
	syscall

	mov rax,44
	mov rdi,[rbp - 16]
	lea rsi,[header]
	mov rdx,length
	xor r10,r10
	mov r8,r12
	mov r9,16
	syscall

	mov rax,0
	mov rdi,[rbp - 16]
	lea rsi,[r15]
	mov rdx,1024 * 4
	syscall

	mov rax,1
	mov rdi,1
	lea rsi,[r15]
	mov rdx,1024 * 4
	syscall

	mov rax,11
	lea rdi,[r15]
	mov rsi,1024 * 4
	syscall

	mov rax,48
	mov rdi,[rbp - 16]
	xor rsi,rsi
	syscall

	mov rax,3
	mov rdi,[rbp - 16]
	syscall

	mov rsp,rbp
	pop rbp

	mov rax,60
	xor rdi,rdi
	syscall
