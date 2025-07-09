.section .data

    pedeOpcao:  .asciz  "\nDigite uma opção: "
    opcao:      .long   0

    abertura:   .asciz  "\nSistema de Controle de Estoque para Supermercado\n\n"
    abertInsercao:   .asciz  "\nInserção de Produto\n"
    abertRemocao:   .asciz  "\nRemoção de Produtos\n"
    abertAtualização:  .asciz  "\nAtualização de Produto\n"
    abertConsultaProd:  .asciz  "\nConsulta de Produto\n"
    abertConsultaFinanceira:  .asciz  "\nConsulta Financeira\n"
    abertGravacao:  .asciz  "\nGravação de Registro\n"
    abertCarregamento:  .asciz  "\nCarregamento/Recuperação de Registros\n"
    abertRelatorio:  .asciz  "\nRelatório de Registros\n"

    menuIns: .asciz "\nInsira novo registro do Produto:\n"
    menuOpcaoRemocao:	.asciz	"\nMenu de Opcao:\n<1> Remoção por nome\n<2> Remoção por validade\n<3> Sair\n"
    menuOpcaoConsultaFinanceira:	.asciz	"\nMenu de Opcao:\n<1> Total de compra\n<2> Total de venda\n<3> Lucro Total\n<4> Capital Perdido\n<5> Sair\n"
    menuOpcaoRelatorioRegistros:    .asciz  "\nMenu de Opcao:\n<1> Ordenar por Nome\n<2> Ordenar por data de validade\n<3> Ordenar por quantidade\n<4> Sair\n"

    menuOpcao:  .asciz  "\nMenu de Opcao:\n<1> Inserção de Produto\n<2> Remoção de Produtos\n<3> Atualização de Produto\n<4> Consulta de Produto\n<5> Consulta Financeira\n<6> Gravação de Registro\n<7> Carregamento/Recuperação de Registros\n<8> Relatório de Registros\n<0> Sair\n"

    tipoDado:   .asciz  "%d"

    estoqueAtualMsg: .asciz "\nEstoque Atual:\n"
    # --- Novas strings e buffers para carregamento
    arquivoNome:       .asciz  "produtos.txt"
    modoLeitura:       .asciz  "r"
    bufferTamanho:     .long   256
    linhaBuffer:       .space  256           # buffer temporário para ler linha do arquivo
    fmtString:         .asciz  "Linha carregada: %s\n"

    msgErroArquivo:    .asciz  "Erro ao abrir arquivo produtos.txt\n"
    msgErroLeitura:    .asciz  "Erro ao ler linha do arquivo\n"
    msgErroMalloc:     .asciz  "Erro ao alocar memoria\n"

.section .text
.globl _start

_start:
menu_loop:

    pushl   $abertura
    call    printf

    pushl   $menuOpcao
    call    printf

    pushl   $pedeOpcao
    call    printf
    pushl   $opcao
    pushl   $tipoDado
    call    scanf

    movl    opcao, %eax
    cmpl    $0, %eax
    je      _fim
    cmpl    $1, %eax
    je      _insProd
    cmpl    $2, %eax
    je      _removProd
    cmpl    $3, %eax
    je      _attProd
    cmpl    $4, %eax
    je      _consProd
    cmpl    $5, %eax
    je      _consFin
    cmpl    $6, %eax
    je      _grava
    cmpl    $7, %eax
    je      _carReg
    cmpl    $8, %eax
    je      _relatorio
    addl    $20, %esp
    jmp     menu_loop

_insProd:
    pushl   $abertInsercao
    call    printf
    jmp     _menuins

_removProd:
    pushl   $abertRemocao
    call    printf
    jmp     _menuremove

_attProd:
    pushl   $abertAtualização
    call    printf
    jmp     _menuatt

_consProd:
    pushl   $abertConsultaProd
    call    printf
    jmp     _menuconsprod

_consFin:
    pushl   $abertConsultaFinanceira
    call    printf
    jmp     _menuconsfin

_grava:
    pushl   $abertGravacao
    call    printf
    jmp     _menugrava

_carReg:
    pushl   $abertCarregamento
    call    printf

    # imprime mensagem antes do loop
    pushl   $estoqueAtualMsg
    call    printf

    # fopen("produtos.txt", "r")
    pushl   $modoLeitura
    pushl   $arquivoNome
    call    fopen
    addl    $8, %esp
    test    %eax, %eax
    je      _erro_arquivo

    movl    %eax, %ebx        # salva FILE* em %ebx

.ler_linha:
    # fgets(linhaBuffer, 256, FILE*)
    pushl   %ebx
    pushl   $256
    pushl   $linhaBuffer
    call    fgets
    addl    $12, %esp

    test    %eax, %eax
    je      .fim_leitura

    # Verifica se a linha é vazia
    movb    linhaBuffer, %al
    cmpb    $10, %al         # '\n'
    je      .ler_linha
    cmpb    $0, %al          # '\0'
    je      .ler_linha

    # imprime a linha lida (apenas a linha, sem prefixo)
    pushl   $linhaBuffer
    call    printf
    addl    $4, %esp

    jmp     .ler_linha

.fim_leitura:
    # fecha o arquivo
    pushl   %ebx
    call    fclose
    addl    $4, %esp

    jmp     _start

_erro_arquivo:
    pushl   $msgErroArquivo
    call    printf
    addl    $4, %esp
    jmp     _start

_erro_leitura:
    pushl   $msgErroLeitura
    call    printf
    addl    $4, %esp
    jmp     _start

_erro_malloc:
    pushl   $msgErroMalloc
    call    printf
    addl    $4, %esp
    jmp     _start

_relatorio:
    pushl   $abertRelatorio
    call    printf
    jmp     _menurelatorio

_menuins:

    pushl   $menuIns
    call    printf

_menuremove:

    pushl   $menuOpcaoRemocao
    call    printf
    pushl	$pedeOpcao
	call	printf
	pushl	$opcao
	pushl	$tipoDado
	call	scanf

    movl	opcao, %eax
	cmpl	$1, %eax
	je	_removeNome
	cmpl	$2, %eax
	je	_removeValidade
	cmpl	$3, %eax
	je	_start

	addl	$20, %esp
	jmp	_start

_menuatt:

_menuconsprod:

_menuconsfin:

    pushl   $menuOpcaoConsultaFinanceira
    call    printf
    pushl	$pedeOpcao
	call	printf
	pushl	$opcao
	pushl	$tipoDado
	call	scanf

    movl	opcao, %eax
	cmpl	$1, %eax
	je	_totalCompra
	cmpl	$2, %eax
	je	_totalVenda
	cmpl	$3, %eax
	je	_lucroTotal
  	cmpl	$4, %eax
	je	_capitalPerdido
    cmpl	$5, %eax
	je	_start

	addl	$20, %esp
	jmp	_start

_menugrava:

_menucareg:

_menurelatorio:

    pushl   $menuOpcaoRelatorioRegistros
    call    printf
    pushl	$pedeOpcao
	call	printf
	pushl	$opcao
	pushl	$tipoDado
	call	scanf

    movl	opcao, %eax
	cmpl	$1, %eax
	je	_ordenaNome
	cmpl	$2, %eax
	je	_ordenaValidade
	cmpl	$3, %eax
	je	_ordenaQuantidade
  	cmpl	$4, %eax
	je	_start

	addl	$20, %esp
	jmp	_start

_removeNome:

_removeValidade:

_totalCompra:

_totalVenda:

_lucroTotal:

_capitalPerdido:

_ordenaNome:

_ordenaValidade:

_ordenaQuantidade:

_fim:
    addl    $56, %esp
    pushl   $0
    call    exit
