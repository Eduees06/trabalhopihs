.section .data
    abertura:   .asciz  "\nSistema de Controle de Estoque para Supermercado\n\n"
    menuOpcao:  .asciz  "\nMenu de Opcao:\n<1> Inserção de Produto\n<2> Remoção de Produtos\n<3> Atualização de Produto\n<4> Consulta de Produto\n<5> Consulta Financeira\n<6> Gravação de Registro\n<7> Carregamento/Recuperação de Registros\n<8> Relatório de Registros\n<0> Sair"
    pedeOpcao:  .asciz  "\nDigite uma opção: "
    tipoDado:   .asciz  "%d"

    opcao: .int 0
    cabeca: .int 0            # ponteiro para primeiro produto
    bufferProduto: .space 132  # buffer temporário para fread
    totalProdutos: .int 0

    abertInsercao:   .asciz  "\nInserção de Produto\n"
    abertRemocao:   .asciz  "\nRemoção de Produtos\n"
    abertAtualizacao:  .asciz  "\nAtualização de Produto\n"
    abertConsultaProd:  .asciz  "\nConsulta de Produto\n"
    abertConsultaFinanceira:  .asciz  "\nConsulta Financeira\n"
    abertGravacao:  .asciz  "\nGravação de Registro\n"
    abertCarregamento:  .asciz  "\nCarregamento/Recuperação de Registros\n"
    abertRelatorio:  .asciz  "\nRelatório de Registros\n"

    fmtProduto: .asciz "\nNome: %s | Codigo: %s | Tipo: %s | Validade: %02d/%02d/%04d | Fornecedor: %s | Quantidade: %d | Compra: %d | Venda: %d\n"

    arquivoBinNome: .asciz "produtos.bin"
    modoLeituraBin: .asciz "rb"

    msgDepInicio:    .asciz "-> Iniciando carregamento\n"
    msgDepFimLeitura:.asciz "-> Fim da leitura do arquivo\n"
    msgTotalProdutos:.asciz "Total de produtos carregados: %d\n"
    msgDepCabecaNull:.asciz "-> Lista vazia, cabeca=NULL\n"

.section .text
    .extern printf, scanf, fopen, fread, fclose, malloc, exit
    .globl _start

_start:
menu_loop:
    pushl $abertura
    call printf

    pushl $menuOpcao
    call printf

    pushl $pedeOpcao
    call printf

    pushl $opcao
    pushl $tipoDado
    call scanf
    addl $8, %esp

    movl opcao, %eax
    cmpl $0, %eax
    je _fim
    cmpl $1, %eax
    je _insProd
    cmpl $2, %eax
    je _removProd
    cmpl $3, %eax
    je _attProd
    cmpl $4, %eax
    je _consProd
    cmpl $5, %eax
    je _consFin
    cmpl $6, %eax
    je _grava
    cmpl $7, %eax
    je carregar
    cmpl $8, %eax
    je relatorio

    jmp menu_loop

_insProd:
    pushl $abertInsercao
    call printf
    jmp menu_loop

_removProd:
    pushl $abertRemocao
    call printf
    jmp menu_loop

_attProd:
    pushl $abertAtualizacao
    call printf
    jmp menu_loop

_consProd:
    pushl $abertConsultaProd
    call printf
    jmp menu_loop

_consFin:
    pushl $abertConsultaFinanceira
    call printf
    jmp menu_loop

_grava:
    pushl $abertGravacao
    call printf
    jmp menu_loop

carregar:
    pushl $abertCarregamento
    call printf

    pushl $msgDepInicio
    call printf

    pushl $modoLeituraBin
    pushl $arquivoBinNome
    call fopen
    addl $8, %esp
    test %eax, %eax
    je _erro_arquivo
    movl %eax, %ebx    # FILE*

    movl $0, cabeca
    movl $0, totalProdutos

.leitura_loop:
    pushl %ebx
    pushl $1
    pushl $132
    pushl $bufferProduto
    call fread
    addl $16, %esp

    cmpl $1, %eax
    jne .fim_leitura

    # Aloca novo produto
    pushl $136
    call malloc
    addl $4, %esp
    test %eax, %eax
    je _erro_malloc
    movl %eax, %esi

    # Copia bufferProduto para produto
    movl $0, %ecx
.copy_loop:
    cmp $132, %ecx
    jge .copy_done
    movb bufferProduto(%ecx), %al
    movb %al, (%esi,%ecx)
    incl %ecx
    jmp .copy_loop
.copy_done:

    # Zera terminadores de strings
    movb $0, 63(%esi)
    movb $0, 67(%esi)
    movb $0, 87(%esi)
    movb $0, 119(%esi)

    # Insere na lista
    movl cabeca, %eax
    movl %eax, 132(%esi)
    movl %esi, cabeca

    # Incrementa totalProdutos
    movl totalProdutos, %eax
    incl %eax
    movl %eax, totalProdutos

    jmp .leitura_loop

.fim_leitura:
    pushl $msgDepFimLeitura
    call printf

    # Mostra total de produtos carregados
    movl totalProdutos, %eax
    pushl %eax
    pushl $msgTotalProdutos
    call printf
    addl $8, %esp

    pushl %ebx
    call fclose
    addl $4, %esp

    jmp menu_loop

relatorio:
    pushl $abertRelatorio
    call printf

    movl cabeca, %edi
    test %edi, %edi
    je .lista_vazia

.print_loop:
    test %edi, %edi
    je .fim_print_loop

    pushl 128(%edi)
    pushl 124(%edi)
    pushl 120(%edi)
    leal 100(%edi), %eax
    pushl %eax
    movl 96(%edi), %eax
    pushl %eax
    movl 92(%edi), %eax
    pushl %eax
    movl 88(%edi), %eax
    pushl %eax
    leal 68(%edi), %eax
    pushl %eax
    leal 64(%edi), %eax
    pushl %eax
    leal 0(%edi), %eax
    pushl %eax
    pushl $fmtProduto
    call printf
    addl $44, %esp

    movl 132(%edi), %edi
    jmp .print_loop

.fim_print_loop:
    jmp menu_loop

.lista_vazia:
    pushl $msgDepCabecaNull
    call printf
    jmp menu_loop

_erro_arquivo:
    pushl $msgDepCabecaNull
    call printf
    jmp menu_loop

_erro_malloc:
    pushl $msgDepCabecaNull
    call printf
    jmp menu_loop

_fim:
    pushl $0
    call exit
