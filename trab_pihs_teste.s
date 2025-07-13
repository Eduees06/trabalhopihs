#
# Sistema de Controle de Estoque de Supermercado
# Linguagem: Gnu Assembly (GAS) para plataforma 32-bits
#
# Compilação:
# as --32 -o estoque.o estoque.s
# gcc -m32 -o estoque estoque.o
#
# Execução:
# ./estoque
#

# --- Definição da Estrutura do Produto ---
.equ STRUC_NEXT_OFFSET, 0      # Ponteiro para o próximo nó (4 bytes)
.equ STRUC_NAME_OFFSET, 4      # Nome do produto (50 bytes)
.equ STRUC_LOT_OFFSET, 54      # Lote do produto (20 bytes)
.equ STRUC_VALIDITY_OFFSET, 74 # Data de validade DD/MM/AAAA (11 bytes)
.equ STRUC_SUPPLIER_OFFSET, 85 # Fornecedor (50 bytes)
.equ STRUC_QUANTITY_OFFSET, 135# Quantidade no estoque (4 bytes)
.equ STRUC_PURCHASE_OFFSET, 139# Valor de compra (4 bytes - float)
.equ STRUC_SALE_OFFSET, 143    # Valor de venda (4 bytes - float)
.equ PRODUCT_STRUCT_SIZE, 147  # Tamanho total da estrutura

.section .data
    # --- Strings do Menu e Interface ---
    abertura:       .asciz  "\n=== Sistema de Controle de Estoque para Supermercado ===\n"
    menuOpcao:      .asciz  "\nMenu Principal:\n<1> Inserir Produto\n<2> Remover Produto\n<3> Atualizar Produto\n<4> Consultar Produto\n<5> Consulta Financeira\n<6> Gravar Dados em Disco\n<7> Carregar Dados do Disco\n<8> Relatorio de Produtos\n<0> Sair\n"
    pedeOpcao:      .asciz  "Escolha uma opcao: "

    abertInsercao:          .asciz  "\n--- Insercao de Produto ---\n"
    abertRemocao:           .asciz  "\n--- Remocao de Produtos ---\n"
    abertAtualizacao:       .asciz  "\n--- Atualizacao de Produto ---\n"
    abertConsultaProd:      .asciz  "\n--- Consulta de Produto ---\n"
    abertConsultaFinanceira:.asciz  "\n--- Consulta Financeira ---\n"
    abertGravacao:          .asciz  "\n--- Gravacao de Registros ---\n"
    abertCarregamento:      .asciz  "\n--- Carregamento de Registros ---\n"
    abertRelatorio:         .asciz  "\n--- Relatorio de Registros ---\n"

    # --- Strings para leitura e impressão de dados ---
    pedeNome:           .asciz "Nome do produto: "
    pedeLote:           .asciz "Lote: "
    pedeValidade:       .asciz "Data de Validade (DD/MM/AAAA): "
    pedeFornecedor:     .asciz "Fornecedor: "
    pedeQtd:            .asciz "Quantidade em estoque: "
    pedePrecoCompra:    .asciz "Valor de compra (ex: 10.50): "
    pedePrecoVenda:     .asciz "Valor de venda (ex: 15.75): "

    pedeNomeBusca:      .asciz "Digite o nome do produto para buscar: "
    pedeLoteBusca:      .asciz "Digite o lote do produto: "
    pedeNovaQtd:        .asciz "Digite a nova quantidade: "
    pedeNovoPreco:      .asciz "Digite o novo valor de venda: "

    # --- Formatos para printf/scanf ---
    fmtInt:         .asciz "%d"
    fmtString:      .asciz "%s"
    fmtFloat:       .asciz "%f"
    fmtNL:          .asciz "\n" # Newline

    # --- Relatórios e Consultas ---
    relatorioHeader:    .asciz "-----------------------------------------------------------------\n"
    relatorioProduto:   .asciz "Nome: %s | Lote: %s | Val: %s | Forn: %s | Qtd: %d | Compra: %.2f | Venda: %.2f\n"
    consultaTotalCompra: .asciz "Valor total de compra do estoque: R$ %.2f\n"
    consultaTotalVenda:  .asciz "Valor total de venda do estoque: R$ %.2f\n"
    consultaLucroTotal:  .asciz "Lucro total estimado: R$ %.2f\n"
    produtoNaoEncontrado: .asciz "Produto/Lote nao encontrado.\n"
    produtoAtualizado:  .asciz "Produto atualizado com sucesso.\n"
    produtoRemovido:    .asciz "Produto removido com sucesso.\n"
    listaVazia:         .asciz "Nenhum produto cadastrado.\n"

    # --- Operações de Arquivo ---
    arquivoNome:    .asciz "produtos.txt"
    modoEscrita:    .asciz "w"
    modoLeitura:    .asciz "r"
    formatoGravacao:.asciz "%s;%s;%s;%s;%d;%f;%f\n"
    formatoLeitura: .asciz "%49[^;];%19[^;];%10[^;];%49[^;];%d;%f;%f\n"
    msgGravado:     .asciz "Dados gravados com sucesso em 'produtos.txt'.\n"
    msgCarregado:   .asciz "Dados carregados com sucesso de 'produtos.txt'.\n"
    msgErroArquivo: .asciz "Erro ao abrir o arquivo.\n"
    msgErroMalloc:  .asciz "Erro: Falha ao alocar memoria.\n"


.section .bss
    .lcomm head, 4          # Ponteiro para o início da lista encadeada
    .lcomm opcao, 4         # Opção do menu lida do usuário
    .lcomm buffer, 256      # Buffer genérico para leitura de strings

.section .text
.globl main

main:
    # Loop principal do programa
menu_loop:
    pushl $abertura
    call printf
    pushl $menuOpcao
    call printf
    pushl $pedeOpcao
    call printf
    addl $12, %esp

    pushl $opcao
    pushl $fmtInt
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
    je _carReg
    cmpl $8, %eax
    je _relatorio
    jmp menu_loop

_fim:
    # Libera a lista antes de sair para não haver memory leak
    call liberar_lista
    movl $0, %eax
    ret

#======================================================================
# FUNCIONALIDADE 1: INSERÇÃO
#======================================================================
_insProd:
    pushl $abertInsercao
    call printf
    addl $4, %esp

    pushl $PRODUCT_STRUCT_SIZE
    call malloc
    addl $4, %esp
    testl %eax, %eax
    jz _erro_malloc
    movl %eax, %edi

    pushl $pedeNome; call printf; addl $4, %esp
    pushl $buffer; pushl $fmtString; call scanf; addl $8, %esp
    pushl $buffer; pushl STRUC_NAME_OFFSET(%edi); call strcpy; addl $8, %esp

    pushl $pedeLote; call printf; addl $4, %esp
    pushl $buffer; pushl $fmtString; call scanf; addl $8, %esp
    pushl $buffer; pushl STRUC_LOT_OFFSET(%edi); call strcpy; addl $8, %esp

    pushl $pedeValidade; call printf; addl $4, %esp
    pushl $buffer; pushl $fmtString; call scanf; addl $8, %esp
    pushl $buffer; pushl STRUC_VALIDITY_OFFSET(%edi); call strcpy; addl $8, %esp

    pushl $pedeFornecedor; call printf; addl $4, %esp
    pushl $buffer; pushl $fmtString; call scanf; addl $8, %esp
    pushl $buffer; pushl STRUC_SUPPLIER_OFFSET(%edi); call strcpy; addl $8, %esp

    pushl $pedeQtd; call printf; addl $4, %esp
    pushl STRUC_QUANTITY_OFFSET(%edi); pushl $fmtInt; call scanf; addl $8, %esp

    pushl $pedePrecoCompra; call printf; addl $4, %esp
    pushl STRUC_PURCHASE_OFFSET(%edi); pushl $fmtFloat; call scanf; addl $8, %esp

    pushl $pedePrecoVenda; call printf; addl $4, %esp
    pushl STRUC_SALE_OFFSET(%edi); pushl $fmtFloat; call scanf; addl $8, %esp

    pushl %edi
    call inserir_ordenado
    addl $4, %esp

    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 2: REMOÇÃO
#======================================================================
_removProd:
    pushl $abertRemocao; call printf; addl $4, %esp

    subl $70, %esp # Aloca espaço para nome (50) e lote (20)
    movl %esp, %esi # ESI aponta para o buffer do nome
    leal 50(%esp), %ebp # EBP aponta para o buffer do lote

    pushl $pedeNomeBusca; call printf; addl $4, %esp
    pushl %esi; pushl $fmtString; call scanf; addl $8, %esp

    pushl $pedeLoteBusca; call printf; addl $4, %esp
    pushl %ebp; pushl $fmtString; call scanf; addl $8, %esp

    movl head, %eax
    movl $0, %edx

.Lremocao_loop:
    cmpl $0, %eax
    je .Lremocao_nao_encontrado

    pushl STRUC_NAME_OFFSET(%eax)
    pushl %esi
    call strcmp
    addl $8, %esp
    testl %eax, %eax
    jne .Lremocao_proximo

    pushl STRUC_LOT_OFFSET(%eax)
    pushl %ebp
    call strcmp
    addl $8, %esp
    testl %eax, %eax
    je .Lremocao_encontrado

.Lremocao_proximo:
    movl %eax, %edx
    movl STRUC_NEXT_OFFSET(%eax), %eax
    jmp .Lremocao_loop

.Lremocao_encontrado:
    cmpl $0, %edx
    jne .Lremocao_meio
    movl STRUC_NEXT_OFFSET(%eax), %ecx
    movl %ecx, head
    jmp .Lremocao_liberar

.Lremocao_meio:
    movl STRUC_NEXT_OFFSET(%eax), %ecx
    movl %ecx, STRUC_NEXT_OFFSET(%edx)

.Lremocao_liberar:
    pushl %eax; call free; addl $4, %esp
    pushl $produtoRemovido; call printf; addl $4, %esp
    jmp .Lremocao_fim

.Lremocao_nao_encontrado:
    pushl $produtoNaoEncontrado; call printf; addl $4, %esp

.Lremocao_fim:
    addl $70, %esp # Limpa os buffers
    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 3: ATUALIZAÇÃO
#======================================================================
_attProd:
    pushl $abertAtualizacao; call printf; addl $4, %esp

    pushl $pedeNomeBusca; call printf; addl $4, %esp
    pushl $buffer; pushl $fmtString; call scanf; addl $8, %esp
    
    pushl $buffer
    call buscar_produto
    addl $4, %esp

    testl %eax, %eax
    jz .Latt_nao_encontrado

    movl %eax, %edi
    pushl $pedeNovaQtd; call printf; addl $4, %esp
    pushl STRUC_QUANTITY_OFFSET(%edi); pushl $fmtInt; call scanf; addl $8, %esp
    pushl $pedeNovoPreco; call printf; addl $4, %esp
    pushl STRUC_SALE_OFFSET(%edi); pushl $fmtFloat; call scanf; addl $8, %esp
    pushl $produtoAtualizado; call printf; addl $4, %esp
    jmp menu_loop

.Latt_nao_encontrado:
    pushl $produtoNaoEncontrado; call printf; addl $4, %esp
    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 4: CONSULTA
#======================================================================
_consProd:
    pushl $abertConsultaProd; call printf; addl $4, %esp

    pushl $pedeNomeBusca; call printf; addl $4, %esp
    pushl $buffer; pushl $fmtString; call scanf; addl $8, %esp

    movl head, %eax
    movl $0, %ecx

.Lcons_loop:
    cmpl $0, %eax
    je .Lcons_fim

    pushl STRUC_NAME_OFFSET(%eax)
    pushl $buffer
    call strcmp
    addl $8, %esp
    testl %eax, %eax
    jne .Lcons_proximo

    movl $1, %ecx
    pushl %eax; call imprimir_produto; addl $4, %esp

.Lcons_proximo:
    movl STRUC_NEXT_OFFSET(%eax), %eax
    jmp .Lcons_loop

.Lcons_fim:
    cmpl $0, %ecx
    jne menu_loop
    pushl $produtoNaoEncontrado; call printf; addl $4, %esp
    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 5: FINANCEIRO
#======================================================================
_consFin:
    pushl $abertConsultaFinanceira; call printf; addl $4, %esp
    finit
    movl head, %eax

.Lfin_loop:
    cmpl $0, %eax
    je .Lfin_calcula

    fildl STRUC_QUANTITY_OFFSET(%eax)
    flds STRUC_PURCHASE_OFFSET(%eax)
    fmulp %st, %st(1)
    faddp %st, %st(1)

    fildl STRUC_QUANTITY_OFFSET(%eax)
    flds STRUC_SALE_OFFSET(%eax)
    fmulp %st, %st(1)
    faddp %st, %st(1)

    movl STRUC_NEXT_OFFSET(%eax), %eax
    jmp .Lfin_loop

.Lfin_calcula:
    subl $8, %esp
    fstpl (%esp)
    fstpl 4(%esp)

    pushl 4(%esp); pushl $consultaTotalCompra; call printf; addl $8, %esp
    pushl (%esp); pushl $consultaTotalVenda; call printf; addl $8, %esp

    flds (%esp)
    fsubs 4(%esp)
    subl $4, %esp
    fstps (%esp)
    pushl (%esp); pushl $consultaLucroTotal; call printf; addl $8, %esp
    addl $12, %esp
    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 6: GRAVAÇÃO
#======================================================================
_grava:
    pushl $abertGravacao; call printf; addl $4, %esp

    pushl $modoEscrita; pushl $arquivoNome; call fopen; addl $8, %esp
    testl %eax, %eax
    jz _erro_arquivo
    movl %eax, %ebx

    movl head, %eax
.Lgrava_loop:
    cmpl $0, %eax
    je .Lgrava_fim

    subl $8, %esp; flds STRUC_SALE_OFFSET(%eax); fstpl (%esp)
    subl $8, %esp; flds STRUC_PURCHASE_OFFSET(%eax); fstpl (%esp)
    pushl STRUC_QUANTITY_OFFSET(%eax)
    pushl STRUC_SUPPLIER_OFFSET(%eax)
    pushl STRUC_VALIDITY_OFFSET(%eax)
    pushl STRUC_LOT_OFFSET(%eax)
    pushl STRUC_NAME_OFFSET(%eax)
    pushl $formatoGravacao
    pushl %ebx
    call fprintf
    addl $44, %esp

    movl STRUC_NEXT_OFFSET(%eax), %eax
    jmp .Lgrava_loop

.Lgrava_fim:
    pushl %ebx; call fclose; addl $4, %esp
    pushl $msgGravado; call printf; addl $4, %esp
    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 7: CARREGAMENTO (ROTINA CORRIGIDA)
#======================================================================
_carReg:
    # --- Prólogo da Função ---
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx  # Salva registradores que serão modificados
    pushl %esi
    pushl %edi
    subl $8, %esp  # Aloca 8 bytes na pilha para duas variáveis float locais

    # Locais:
    # -4(%ebp) -> ponteiro FILE* salvo
    # -8(%ebp) -> ponteiro para novo nó (EDI salvo)
    # -12(%ebp) -> ponteiro para nó atual (ESI salvo)
    # -16(%ebp) -> float temporario compra
    # -20(%ebp) -> float temporario venda

    pushl $abertCarregamento; call printf; addl $4, %esp
    call liberar_lista

    pushl $modoLeitura; pushl $arquivoNome; call fopen; addl $8, %esp
    movl %eax, -4(%ebp) # Salva FILE* na variável local
    testl %eax, %eax
    jz .Lcarrega_erro_abertura

.Lcarrega_loop:
    pushl $PRODUCT_STRUCT_SIZE; call malloc; addl $4, %esp
    movl %eax, %edi # EDI = ponteiro para novo nó
    testl %eax, %eax
    jz .Lcarrega_fim_loop

    # Prepara argumentos para fscanf
    leal -20(%ebp), %eax; pushl %eax  # Endereço de &preco_venda
    leal -16(%ebp), %eax; pushl %eax  # Endereço de &preco_compra
    pushl STRUC_QUANTITY_OFFSET(%edi)
    pushl STRUC_SUPPLIER_OFFSET(%edi)
    pushl STRUC_VALIDITY_OFFSET(%edi)
    pushl STRUC_LOT_OFFSET(%edi)
    pushl STRUC_NAME_OFFSET(%edi)
    pushl $formatoLeitura
    pushl -4(%ebp) # Passa o FILE* salvo
    call fscanf
    addl $36, %esp

    cmpl $7, %eax # fscanf deve retornar 7 (número de campos lidos)
    jne .Lcarrega_fim_leitura_ok

    # Copia os floats lidos para a struct
    flds -16(%ebp); fstps STRUC_PURCHASE_OFFSET(%edi)
    flds -20(%ebp); fstps STRUC_SALE_OFFSET(%edi)

    pushl %edi; call inserir_ordenado; addl $4, %esp
    jmp .Lcarrega_loop

.Lcarrega_fim_leitura_ok:
    pushl %edi; call free; addl $4, %esp # Libera o nó não usado

.Lcarrega_fim_loop:
    pushl -4(%ebp); call fclose; addl $4, %esp
    pushl $msgCarregado; call printf; addl $4, %esp
    jmp .Lcarrega_epilogo

.Lcarrega_erro_abertura:
    pushl $msgErroArquivo; call printf; addl $4, %esp

.Lcarrega_epilogo:
    # --- Epílogo da Função ---
    addl $8, %esp # Libera espaço dos floats locais
    popl %edi
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    jmp menu_loop

#======================================================================
# FUNCIONALIDADE 8: RELATÓRIO
#======================================================================
_relatorio:
    pushl $abertRelatorio; call printf; addl $4, %esp
    cmpl $0, head
    je .Lrelatorio_vazio

    pushl $relatorioHeader; call printf; addl $4, %esp
    movl head, %eax
.Lrelatorio_loop:
    cmpl $0, %eax
    je .Lrelatorio_fim

    pushl %eax; call imprimir_produto; addl $4, %esp
    movl STRUC_NEXT_OFFSET(%eax), %eax
    jmp .Lrelatorio_loop

.Lrelatorio_fim:
    pushl $relatorioHeader; call printf; addl $4, %esp
    jmp menu_loop
.Lrelatorio_vazio:
    pushl $listaVazia; call printf; addl $4, %esp
    jmp menu_loop

#======================================================================
# ROTINAS AUXILIARES
#======================================================================
inserir_ordenado:
    pushl %ebp; movl %esp, %ebp; pushl %edi; pushl %esi; pushl %ebx
    movl 8(%ebp), %edi
    movl head, %ebx
    movl $0, %esi
.Lio_loop:
    cmpl $0, %ebx
    je .Lio_insere
    pushl STRUC_NAME_OFFSET(%ebx); pushl STRUC_NAME_OFFSET(%edi); call strcmp; addl $8, %esp
    testl %eax, %eax
    jle .Lio_insere
    movl %ebx, %esi; movl STRUC_NEXT_OFFSET(%ebx), %ebx; jmp .Lio_loop
.Lio_insere:
    movl %ebx, STRUC_NEXT_OFFSET(%edi)
    cmpl $0, %esi
    je .Lio_insere_head
    movl %edi, STRUC_NEXT_OFFSET(%esi)
    jmp .Lio_fim
.Lio_insere_head:
    movl %edi, head
.Lio_fim:
    popl %ebx; popl %esi; popl %edi; movl %ebp, %esp; popl %ebp; ret

buscar_produto:
    pushl %ebp; movl %esp, %ebp; movl head, %eax
.Lbusca_loop:
    cmpl $0, %eax
    je .Lbusca_fim_nao_achou
    pushl STRUC_NAME_OFFSET(%eax); pushl 8(%ebp); call strcmp; addl $8, %esp
    testl %eax, %eax
    je .Lbusca_fim_achou
    movl STRUC_NEXT_OFFSET(%eax), %eax; jmp .Lbusca_loop
.Lbusca_fim_achou:
    jmp .Lbusca_fim
.Lbusca_fim_nao_achou:
    movl $0, %eax
.Lbusca_fim:
    movl %ebp, %esp; popl %ebp; ret

imprimir_produto:
    pushl %ebp; movl %esp, %ebp; movl 8(%ebp), %eax
    subl $8, %esp; flds STRUC_SALE_OFFSET(%eax); fstpl (%esp)
    subl $8, %esp; flds STRUC_PURCHASE_OFFSET(%eax); fstpl (%esp)
    pushl STRUC_QUANTITY_OFFSET(%eax)
    pushl STRUC_SUPPLIER_OFFSET(%eax)
    pushl STRUC_VALIDITY_OFFSET(%eax)
    pushl STRUC_LOT_OFFSET(%eax)
    pushl STRUC_NAME_OFFSET(%eax)
    pushl $relatorioProduto
    call printf
    addl $36, %esp
    movl %ebp, %esp; popl %ebp; ret

liberar_lista:
    pushl %ebp; movl %esp, %ebp; movl head, %eax
.Lliberar_loop:
    cmpl $0, %eax
    je .Lliberar_fim
    movl STRUC_NEXT_OFFSET(%eax), %ebx
    pushl %eax; call free; addl $4, %esp
    movl %ebx, %eax; jmp .Lliberar_loop
.Lliberar_fim:
    movl $0, head; movl %ebp, %esp; popl %ebp; ret

#======================================================================
# ROTINAS DE ERRO
#======================================================================
_erro_arquivo:
    pushl $msgErroArquivo; call printf; addl $4, %esp; jmp menu_loop
_erro_malloc:
    pushl $msgErroMalloc; call printf; addl $4, %esp; jmp _fim