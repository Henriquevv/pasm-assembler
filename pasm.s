// Segmento de codigo
.text
    // Tabela de vetor de interrupcao
    init:
        bun main
        .align 5
    // Procedimento de impressao
    printf:
        push r2 , r3
        // R1 = endereco do terminal
        l32 r1, [terminal_out]
        // Leitura de byte da mensagem
        l8 r3, [r2]
        // Comparando com '\0'
        cmpi r3, 0
        // Finalizando se for caractere nulo
        beq 3
        // Escreve no terminal
        s8 [r1], r3
        // Incrementa o ponteiro da mensagem
        addi r2, r2, 1
        // Repete a iteracao
        bun -6
        pop r3, r2  
        // Retorno da funcao
        ret
    print_digito:
        push sr, r6, r5, r4, r3
        // r5 digito atual
        // r3 valor não convertido 
        // conversão para decimal 
        mov r4, 10
        div r5, r3, r3, r4
        // cmp digitos esquerda
        cmp r3, r0            
        beq 1
        call print_digito
        // continua se nao        
        bgt 2            
        cmp r5, r0       
        beq 2
        // converter o digito atual para ascii
        addi r5, r5, 48
        // imprimir
        s8 [r1], r5
        pop r3, r4, r5, r6, sr
        ret

    print_number:      
        // r1 - ponteiro terminal
        // r2 - posição atual
        push r3, r5
        // R1 = Endereco do terminal
        l32 r1, [terminal_out]
        l32 r3, [r2]
        // exibir
        call print_digito       
        pop r5, r3
        ret
    exibir_vetor:
        push r4, r3, r2
        // ponteiro do vetor
        mov r4, V1
        divi r4, r4, 4
        // contador
        mov r3, 0       
        cmp r3, r5
        beq 7      
        mov r2, r4
        // printf
        call print_number
        // string
        mov r2, space_message
        // printf
        call printf
        // Incremento contador
        addi r3, r3, 1
        // Incremento ponteiro
        addi r4, r4, 1
        // reiniciar loop
        bun -9
        // string
        mov r2, broke_line_message
        // printf
        call printf      
        pop r2, r3, r4
        // Retorno da funcao
        ret       
    insertion:
        mov r4, V1
        divi r4, r4, 4
        ret

    substitui:
        push r1, r2, r3, r4, r5
        push r6, r7, r8, r9     
        call insertion      
            add r7, r4, r3
            l32 r6, [r7]
        subi r2, r3, 1
        cmpi r2, -1      
        beq 8
            add r7, r4, r2
            addi r9, r7, 1
            l32 r8, [r7]
        cmp r8, r6       
        bbe 3
        s32 [r9], r8       
        subi r2, r2, 1
        bun -10
            add r7, r4, r2
            addi r9, r7, 1
            s32 [r9], r6
        pop r9, r8, r7, r6
        pop r5, r4, r3, r2, r1
        ret
    ordena:        
        push r3       
        mov r3, 1        
        cmp r3, r5        
        bgt 3       
        call substitui       
        addi r3, r3, 1       
        bun -5       
        pop r3
        ret
    ler_entrada:        
        push r1, r2, r3, r4, r5        
        l32 r2, [terminal_in]        
        mov r1, V1        
        muli r5, r5, 4        
        mov r4, 0        
        cmp r4, r5       
        beq 5        
        l8 r3, [r2]        
        s8 [r1], r3       
        addi r1, r1, 1        
        addi r4, r4, 1       
        bun -7       
        pop r5, r4, r3, r2, r1       
        ret
    // Funcao principal
    main:
        // SP = 32 KiB
        mov sp, 0x7FFC
        // r5 - tamanho do vetor
        mov r5, 100
        // R2 = ponteiro da string
        mov r2, input_message
        call printf
        call ler_entrada
        call exibir_vetor
        mov r2, sorted_message
        call printf
        call ordena
        call exibir_vetor
        int 0
// Segmento de dados
.data
    // Mensagens de texto
    input_message:
        .asciz "Input numbers:\n"
    sorted_message:
        .asciz "Sorted numbers:\n"
    space_message:
        .asciz " "
    broke_line_message:
        .asciz "\n"
    //array
    V1:
        .fill 100, 4, 0
    // Endereco do dispositivo (OUT)
    terminal_in:
        .4byte 0x8888888A
    terminal_out:
        .4byte 0x8888888B