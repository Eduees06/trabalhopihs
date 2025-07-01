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
    menuOpcaoRemocao:	.asciz	"\nMenu de Opcao:\n<1> Remoção por nome\n<2> Remocao por validade\n<3> Sair"
    menuOpcaoConsultaFinanceira:	.asciz	"\nMenu de Opcao:\n<1> Total de compra\n<2> Total de venda\n<3> Lucro Total \n<4> Capital Perdido\n<5> Sair"
    menuOpcaoRelatorioRegistros:    .asciz  "\nMenu de Opcao:\n<1> Ordenar por Nome\n<2> Ordenar por data de validade\n<3> Ordenar por quantidade \n<4> Sair"

    menuOpcao:  .asciz  "\nMenu de Opcao:\n<1> Inserção de Produto\n<2> Remoção de Produtos\n<3> Atualização de Produto\n<4> Consulta de Produto\n<5> Consulta Financeira\n<6> Gravação de Registro\n<7> Carregamento/Recuperação de Registros\n<8> Relatório de Registros\n<0> Sair"

    tipoDado:   .asciz  "%d"

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
    jmp    _menuconsfin

_grava:
    pushl   $abertGravacao
    call    printf
    jmp     _menugrava

_carReg:
    pushl   $abertCarregamento
    call    printf
    jmp     _menucareg

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

