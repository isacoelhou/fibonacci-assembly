; nasm -f elf64 fib.asm; ld fib.o -o fib.x

section .data
    fib: dq 0 ; quando fib = 1 ou 0
    msg_erro:   db "Erro", 10, 0 ;para quando fib > 93
    nome_arquivo: db "fib(", 0
    nome_arquivo2: db ").bin", 0
section .bss
    fib_desejado: resb 3 ;digitado pelo usuario
    lixo: resb 1 ;quando ocorre erro
    fib_n: resq 1 ;em inteiro
    nome_arquivo_final: resb 30 ; junção dos nomes dos arquivos para gerar o final
    result_fib: resq 1 ;resultado
    
section .text 
    global _start ;sem inicialização de variavies

_start:

    mov rax, 0 ;ler do terminal
    mov rdi, 0
    lea rsi, [fib_desejado] ;conteudo de 
    mov rdx, 3 
    syscall

    cmp byte[fib_desejado], 10 ;quebra de linha
    je erro
    
    cmp byte[fib_desejado + 1], 10 
    je um_numero

    cmp byte[fib_desejado + 2], 10
    je dois_numero
    jne corrige

    um_numero:
        mov al,[fib_desejado] 
        mov rbx, [nome_arquivo] 
        mov [nome_arquivo_final], rbx ;fib(
        mov [nome_arquivo_final+4], al ;fib(x
        mov rbx, [nome_arquivo2] 
        mov [nome_arquivo_final+5],rbx ;fib(x).bin
        mov bl, [nome_arquivo2+4]
        mov [nome_arquivo_final+9], bl
        sub al, 48 ;transforma em valor inteiro
        mov [fib_n], al ;armazena o valor final

        cmp al, 0 
        je arquivo 
        cmp al, 1
        je fib_1
        mov r15, 1
        mov r14, 0
        jmp fibonacci
    
    dois_numero:
        mov cl, [fib_desejado+1]
        mov al,[fib_desejado]
        mov rbx, [nome_arquivo]
        mov [nome_arquivo_final], rbx
        mov [nome_arquivo_final+4], al
        mov [nome_arquivo_final+5], cl
        mov rbx, [nome_arquivo2]
        mov [nome_arquivo_final+6],rbx
        mov bl, [nome_arquivo2+4]
        mov [nome_arquivo_final+10], bl
        sub al, 48
        sub cl, 48
        imul ax, 10
        add al, cl
        mov [fib_n], al
        cmp al, 94
        jge erro
        mov r15, 1
        
    
    fibonacci:
        mov r13, r15
        add r15, r14
        mov [fib], r15
        mov r14, r13
        dec qword[fib_n]
        cmp qword[fib_n], 1
        jne fibonacci

        jmp arquivo

fib_1:
    mov qword[fib], 1
arquivo:
    mov rax, 2 ;dois 
    lea rdi, [nome_arquivo_final] ;manda pra rdi o nome do arquivo ja completo
    mov edx, 664o ;-rx-r–r
    mov esi, 102o ;O RDWR
    syscall

    mov r9, rax ;passa o valor lido 
    mov rax, 1 ;passa 1 byte
    mov rdi, r9 ; passa o valor de rax
    mov rsi, fib ;valor de 
    mov rdx, 8 ; 8 its
    syscall

    mov rax, 3
    mov rdi, r9
    syscall
    jmp end

corrige:
    mov rax, 0
    mov rdi, 0
    lea rsi, [lixo]
    mov rdx, 1
    syscall

    cmp byte[lixo], 10
    jne corrige

erro:
    mov rax, 1
    mov rdi, 1
    lea rsi, [msg_erro]
    mov rdx, 5
    syscall
    

end:
    mov rax, 60
    mov rdi, 0
    syscall