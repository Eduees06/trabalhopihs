# DEFINIÇÃO DA ESTRUTURA DO PRODUTO: (mesmo que antes)
# Offset 0:   nome[64]         - 64 bytes (string do produto)
# Offset 64:  codigo[4]        - 4 bytes (código do produto) 
# Offset 68:  tipo[20]         - 20 bytes (tipo do produto)
# Offset 88:  validadeDia      - 4 bytes (int - dia da validade)
# Offset 92:  validadeMes      - 4 bytes (int - mês da validade) 
# Offset 96:  validadeAno      - 4 bytes (int - ano da validade)
# Offset 100: fornecedor[20]   - 20 bytes (nome do fornecedor)
# Offset 120: quantidade       - 4 bytes (int - quantidade em estoque)
# Offset 124: precoCompra      - 4 bytes (float - preço de compra)
# Offset 128: precoVenda       - 4 bytes (float - preço de venda)
# Offset 132: proximoProduto   - 4 bytes (ponteiro para próximo produto)
# TOTAL: 136 bytes por produto

.section .data
    abertura:   .asciz  "\nSistema de Controle de Estoque para Supermercado\n\n"
    menuOpcao:  .asciz  "\nMenu de Opcao:\n<1> Inserção de Produto\n<2> Remoção de Produtos\n<3> Atualização de Produto\n<4> Consulta de Produto\n<5> Consulta Financeira\n<6> Gravação de Registro\n<7> Carregamento/Recuperação de Registros\n<8> Relatório de Registros\n<0> Sair"
    pedeOpcao:  .asciz  "\nDigite uma opção: "
    tipoDado:   .asciz  "%d"
    tipoString: .asciz  "%s"
    tipoFloat:  .asciz  "%f"

    opcao: .int 0
    cabeca: .int 0            # ponteiro para primeiro produto
    bufferProduto: .space 140  # buffer temporário para leitura
    totalProdutos: .int 0
    lista_temp: .int 0
    # Data atual para verificação de validade
    dataAtualDia: .int 15
    dataAtualMes: .int 7
    dataAtualAno: .int 2025

    # Mensagens das opções
    abertInsercao:   .asciz  "\nInserção de Produto\n"
    abertRemocao:   .asciz  "\nRemoção de Produtos\n"
    abertAtualizacao:  .asciz  "\nAtualização de Produto\n"
    abertConsultaProd:  .asciz  "\nConsulta de Produto\n"
    abertConsultaFinanceira:  .asciz  "\nConsulta Financeira\n"
    abertGravacao:  .asciz  "\nGravação de Registro\n"
    abertCarregamento:  .asciz  "\nCarregamento/Recuperação de Registros\n"
    abertRelatorio:  .asciz  "\nRelatório de Registros\n"

    # NOVO: Menu do relatório
    menuRelatorio: .asciz "Escolha o tipo de ordenação:\n<1> Por nome (alfabética)\n<2> Por data de validade\n<3> Por quantidade em estoque\nEscolha: "
    msgDebugIniciandoOrdenacao: .asciz "-> Iniciando ordenação\n"
    msgDebugListaCriada: .asciz "-> Lista temporária criada\n"
    msgDebugImprimindo: .asciz "-> Iniciando impressão\n"
    msgDebugLiberando: .asciz "-> Liberando lista temporária\n"
    msgDebugFinalizado: .asciz "-> Ordenação finalizada\n"
    # Formato para impressão com floats
    fmtProduto: .asciz "\nNome: %s | Codigo: %s | Tipo: %s | Validade: %02d/%02d/%04d | Fornecedor: %s | Quantidade: %d | Compra: %.2f | Venda: %.2f\n"

    # Arquivo binário
    arquivoBinNome: .asciz "produtos.bin"
    modoLeituraBin: .asciz "rb"
    modoEscritaBin: .asciz "wb"

    # Mensagens de debug/info
    msgDepInicio:    .asciz "-> Iniciando carregamento\n"
    msgDepFimLeitura:.asciz "-> Fim da leitura do arquivo\n"
    msgTotalProdutos:.asciz "Total de produtos carregados: %d\n"
    msgDepCabecaNull:.asciz "-> Lista vazia, cabeca=NULL\n"
    msgErroArquivo: .asciz "Erro ao abrir arquivo!\n"
    msgErroMalloc: .asciz "Erro de alocação de memória!\n"
    msgArquivoSalvo: .asciz "Arquivo salvo com sucesso!\n"
    msgDepAbriuArquivo: .asciz "-> Arquivo aberto com sucesso\n"
    msgDebugValidadeVencida: .asciz "-> Produto vencido encontrado: %s\n"
    msgDebugValidadeOk: .asciz "-> Produto dentro da validade: %s\n"
    
    # Mensagens para inserção
    msgNomeProduto: .asciz "Digite o nome do produto: "
    msgCodigoProduto: .asciz "Digite o código do produto: "
    msgTipoProduto: .asciz "Digite o tipo do produto: "
    msgValidadeDia: .asciz "Digite o dia da validade: "
    msgValidadeMes: .asciz "Digite o mês da validade: "
    msgValidadeAno: .asciz "Digite o ano da validade: "
    msgFornecedor: .asciz "Digite o fornecedor: "
    msgQuantidade: .asciz "Digite a quantidade: "
    msgPrecoCompra: .asciz "Digite o preço de compra: "
    msgPrecoVenda: .asciz "Digite o preço de venda: "
    msgProdutoInserido: .asciz "Produto inserido com sucesso!\n"

    # Buffers para entrada
    bufferNome: .space 65
    bufferCodigo: .space 5
    bufferTipo: .space 21
    bufferFornecedor: .space 21
    tempInt: .int 0
    tempFloat: .float 0.0

    # Mensagens para consulta
    msgBuscarNome: .asciz "Digite o nome do produto a buscar: "
    msgProdutoNaoEncontrado: .asciz "Produto não encontrado!\n"
    msgProdutoEncontrado: .asciz "Produto encontrado:\n"

    # Mensagens para remoção
    msgTipoRemocao: .asciz "Tipo de remoção:\n<1> Por nome\n<2> Por validade vencida\nEscolha: "
    msgProdutoRemovido: .asciz "Produto removido com sucesso!\n"
    msgNenhumProdutoRemovido: .asciz "Nenhum produto foi removido!\n"
    msgProdutosVencidosRemovidos: .asciz "%d produtos vencidos foram removidos!\n"

    # Mensagens para atualização
    msgNovaQuantidade: .asciz "Digite a nova quantidade: "
    msgNovoPrecoVenda: .asciz "Digite o novo preço de venda: "
    msgProdutoAtualizado: .asciz "Produto atualizado com sucesso!\n"

    # Mensagens para consulta financeira (CORRIGIDAS)
    msgConsultaFinanceiraMenu: .asciz "Consulta Financeira:\n<1> Total de compra\n<2> Total de venda\n<3> Lucro total\n<4> Capital perdido\nEscolha: "
    msgTotalCompra: .asciz "Total de compra: %.2f\n"
    msgTotalVenda: .asciz "Total de venda: %.2f\n"
    msgLucroTotal: .asciz "Lucro total: %.2f\n"
    msgCapitalPerdido: .asciz "Capital perdido: %.2f\n"

    # Constantes para chamadas do sistema
    SYS_OPEN: .int 5
    SYS_READ: .int 3
    SYS_WRITE: .int 4
    SYS_CLOSE: .int 6
    O_RDONLY: .int 0
    O_WRONLY: .int 1
    O_CREAT: .int 64
    O_TRUNC: .int 512
    FILE_MODE: .int 0644

.section .text
    .extern printf, scanf, malloc, free, exit, strcmp, strcpy, fgets, stdin, getchar
    .globl _start

_start:
menu_loop:
    pushl $abertura
    call printf
    addl $4, %esp

    pushl $menuOpcao
    call printf
    addl $4, %esp

    pushl $pedeOpcao
    call printf
    addl $4, %esp

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

# FUNÇÃO DE RELATÓRIO
relatorio:
    pushl $abertRelatorio
    call printf
    addl $4, %esp

    # Verifica se lista está vazia
    movl cabeca, %ebx
    cmpl $0, %ebx
    je .lista_vazia_relatorio

    # Mostra menu de ordenação
    pushl $menuRelatorio
    call printf
    addl $4, %esp

    pushl $opcao
    pushl $tipoDado
    call scanf
    addl $8, %esp

    movl opcao, %eax
    cmpl $1, %eax
    je .relatorio_por_nome
    cmpl $2, %eax
    je .relatorio_por_validade
    cmpl $3, %eax
    je .relatorio_por_quantidade
    
    # Opção inválida, volta ao menu
    jmp menu_loop

.relatorio_por_nome:
    pushl $msgDebugIniciandoOrdenacao
    call printf
    addl $4, %esp
    
    # A lista já está ordenada por nome alfabeticamente
    call imprimir_lista_atual
    
    pushl $msgDebugFinalizado
    call printf
    addl $4, %esp
    jmp menu_loop

.relatorio_por_validade:
    pushl $msgDebugIniciandoOrdenacao
    call printf
    addl $4, %esp
    
    # Cria lista temporária ordenada por validade
    call criar_lista_ordenada_validade
    
    pushl $msgDebugListaCriada
    call printf
    addl $4, %esp
    
    pushl $msgDebugImprimindo  
    call printf
    addl $4, %esp
    
    call imprimir_lista_temporaria
    
    pushl $msgDebugLiberando
    call printf
    addl $4, %esp
    
    call liberar_lista_temporaria
    
    pushl $msgDebugFinalizado
    call printf
    addl $4, %esp
    jmp menu_loop

.relatorio_por_quantidade:
    pushl $msgDebugIniciandoOrdenacao
    call printf
    addl $4, %esp
    
    # Cria lista temporária ordenada por quantidade
    call criar_lista_ordenada_quantidade
    
    pushl $msgDebugListaCriada
    call printf
    addl $4, %esp
    
    # Verifica se lista temporária foi criada
    movl lista_temp, %eax
    cmpl $0, %eax
    je .erro_lista_quantidade
    
    pushl $msgDebugImprimindo
    call printf
    addl $4, %esp
    
    call imprimir_lista_temporaria
    
    pushl $msgDebugLiberando
    call printf
    addl $4, %esp
    
    call liberar_lista_temporaria
    
    pushl $msgDebugFinalizado
    call printf
    addl $4, %esp
    jmp menu_loop

.erro_lista_quantidade:
    pushl $msgErroMalloc
    call printf
    addl $4, %esp
    jmp menu_loop

.lista_vazia_relatorio:
    pushl $msgDepCabecaNull
    call printf
    addl $4, %esp
    jmp menu_loop

# FUNÇÃO PARA IMPRIMIR A LISTA ATUAL (ordenada por nome) - CORRIGIDA
imprimir_lista_atual:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    pushl totalProdutos
    pushl $msgTotalProdutos
    call printf
    addl $8, %esp

    movl cabeca, %ebx

.loop_imprimir_atual:
    cmpl $0, %ebx
    je .fim_imprimir_atual

    # Imprime produto (com floats) - ORDEM CORRETA DOS PARÂMETROS
    subl $8, %esp           # espaço para preço venda
    flds 128(%ebx)          # preço venda (offset 128)
    fstpl (%esp)
    subl $8, %esp           # espaço para preço compra
    flds 124(%ebx)          # preço compra (offset 124)
    fstpl (%esp)
    pushl 120(%ebx)         # quantidade (offset 120)
    movl %ebx, %eax
    addl $100, %eax         # fornecedor (offset 100)
    pushl %eax
    pushl 96(%ebx)          # ano (offset 96)
    pushl 92(%ebx)          # mês (offset 92)
    pushl 88(%ebx)          # dia (offset 88)
    movl %ebx, %eax
    addl $68, %eax          # tipo (offset 68)
    pushl %eax
    movl %ebx, %eax
    addl $64, %eax          # código (offset 64)
    pushl %eax
    pushl %ebx              # nome (offset 0)
    pushl $fmtProduto
    call printf
    addl $60, %esp          # 44 + 16 (2 doubles)

    movl 132(%ebx), %ebx    # próximo (offset 132)
    jmp .loop_imprimir_atual

.fim_imprimir_atual:
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA CRIAR LISTA ORDENADA POR VALIDADE - CORRIGIDA
criar_lista_ordenada_validade:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    # Limpa lista temporária
    movl $0, lista_temp
    
    # Percorre lista original
    movl cabeca, %ebx

.loop_criar_validade:
    cmpl $0, %ebx
    je .fim_criar_validade

    # Aloca novo nó para lista temporária
    pushl $136
    call malloc
    addl $4, %esp
    
    # Verifica se malloc foi bem-sucedido
    cmpl $0, %eax
    je .erro_malloc_validade
    
    movl %eax, %esi

    # Copia dados do produto original usando loop manual
    pushl %ebx
    pushl %esi
    call copiar_produto_manual
    addl $8, %esp

    # Inicializa ponteiro próximo
    movl $0, 132(%esi)

    # Insere ordenado por validade na lista temporária
    call inserir_ordenado_validade

    movl 132(%ebx), %ebx    # próximo da lista original
    jmp .loop_criar_validade

.fim_criar_validade:
    popl %edi
    popl %esi
    popl %ebx
    popl %ebp
    ret

.erro_malloc_validade:
    pushl $msgErroMalloc
    call printf
    addl $4, %esp
    popl %edi
    popl %esi
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA COPIAR PRODUTO MANUALMENTE
copiar_produto_manual:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ecx
    pushl %eax

    movl 8(%ebp), %edi      # destino
    movl 12(%ebp), %esi     # origem
    movl $132, %ecx         # quantidade de bytes para copiar

.loop_copia:
    cmpl $0, %ecx
    je .fim_copia
    
    movb (%esi), %al        # lê byte da origem
    movb %al, (%edi)        # escreve byte no destino
    incl %esi               # próximo byte origem
    incl %edi               # próximo byte destino
    decl %ecx               # decrementa contador
    jmp .loop_copia

.fim_copia:
    popl %eax
    popl %ecx
    popl %edi
    popl %esi
    popl %ebp
    ret

# FUNÇÃO PARA INSERIR ORDENADO POR VALIDADE - CORRIGIDA
inserir_ordenado_validade:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    # Se lista temporária vazia
    movl lista_temp, %eax
    cmpl $0, %eax
    je .inserir_inicio_val

    # Comparar datas com primeiro elemento
    pushl %esi              # novo produto
    pushl %eax              # primeiro da lista
    call comparar_datas_dois_produtos
    addl $8, %esp
    cmpl $0, %eax
    jl .inserir_inicio_val  # novo produto tem data anterior

    # Procurar posição correta
    movl lista_temp, %ebx   # atual
    movl $0, %ecx           # anterior

.buscar_posicao_val:
    movl 132(%ebx), %edx    # próximo
    cmpl $0, %edx
    je .inserir_final_val   # inserir no final

    # Compara data do novo com próximo
    pushl %esi
    pushl %edx
    call comparar_datas_dois_produtos
    addl $8, %esp
    cmpl $0, %eax
    jl .inserir_meio_val    # inserir entre atual e próximo

    movl %ebx, %ecx         # anterior = atual
    movl %edx, %ebx         # atual = próximo
    jmp .buscar_posicao_val

.inserir_inicio_val:
    movl lista_temp, %eax
    movl %eax, 132(%esi)
    movl %esi, lista_temp
    jmp .fim_inserir_val

.inserir_meio_val:
    movl 132(%ebx), %eax
    movl %eax, 132(%esi)
    movl %esi, 132(%ebx)
    jmp .fim_inserir_val

.inserir_final_val:
    movl $0, 132(%esi)
    movl %esi, 132(%ebx)

.fim_inserir_val:
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA COMPARAR DATAS DE DOIS PRODUTOS - CORRIGIDA
comparar_datas_dois_produtos:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl 8(%ebp), %ebx      # produto1
    movl 12(%ebp), %ecx     # produto2

    # Compara anos
    movl 96(%ebx), %eax     # ano produto1
    movl 96(%ecx), %edx     # ano produto2
    cmpl %edx, %eax
    jl .produto1_menor
    jg .produto1_maior

    # Anos iguais, compara meses
    movl 92(%ebx), %eax     # mês produto1
    movl 92(%ecx), %edx     # mês produto2
    cmpl %edx, %eax
    jl .produto1_menor
    jg .produto1_maior

    # Meses iguais, compara dias
    movl 88(%ebx), %eax     # dia produto1
    movl 88(%ecx), %edx     # dia produto2
    cmpl %edx, %eax
    jl .produto1_menor
    jg .produto1_maior
    
    # Datas iguais
    movl $0, %eax
    jmp .fim_comparar_datas

.produto1_menor:
    movl $-1, %eax
    jmp .fim_comparar_datas

.produto1_maior:
    movl $1, %eax

.fim_comparar_datas:
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA CRIAR LISTA ORDENADA POR QUANTIDADE - CORRIGIDA
criar_lista_ordenada_quantidade:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi

    # Limpa lista temporária
    movl $0, lista_temp
    
    # Percorre lista original
    movl cabeca, %ebx

.loop_criar_quantidade:
    cmpl $0, %ebx
    je .fim_criar_quantidade

    # Aloca novo nó para lista temporária
    pushl $136
    call malloc
    addl $4, %esp
    
    # Verifica se malloc foi bem-sucedido
    cmpl $0, %eax
    je .erro_malloc_quantidade
    
    movl %eax, %esi

    # Copia dados do produto original
    pushl %ebx
    pushl %esi
    call copiar_produto_manual
    addl $8, %esp

    # Inicializa ponteiro próximo
    movl $0, 132(%esi)

    # Insere ordenado por quantidade na lista temporária
    call inserir_ordenado_quantidade

    movl 132(%ebx), %ebx    # próximo da lista original
    jmp .loop_criar_quantidade

.fim_criar_quantidade:
    popl %esi
    popl %ebx
    popl %ebp
    ret

.erro_malloc_quantidade:
    pushl $msgErroMalloc
    call printf
    addl $4, %esp
    popl %esi
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA INSERIR ORDENADO POR QUANTIDADE - CORRIGIDA
inserir_ordenado_quantidade:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    # Se lista temporária vazia
    movl lista_temp, %eax
    cmpl $0, %eax
    je .inserir_inicio_qtd

    # Comparar quantidade com primeiro elemento
    movl 120(%esi), %eax    # quantidade do novo produto
    cmpl 120(%eax), %eax    # BUG CORRIGIDO: usar registro correto
    movl lista_temp, %ebx   # carrega primeiro elemento
    movl 120(%esi), %eax    # quantidade do novo
    cmpl 120(%ebx), %eax    # compara com quantidade do primeiro
    jl .inserir_inicio_qtd  # novo produto tem menor quantidade

    # Procurar posição correta
    movl lista_temp, %ebx   # atual
    movl $0, %ecx           # anterior

.buscar_posicao_qtd:
    movl 132(%ebx), %edx    # próximo
    cmpl $0, %edx
    je .inserir_final_qtd   # inserir no final

    # Compara quantidade do novo com próximo
    movl 120(%esi), %eax    # quantidade do novo
    cmpl 120(%edx), %eax    # compara com quantidade do próximo
    jl .inserir_meio_qtd    # inserir entre atual e próximo

    movl %ebx, %ecx         # anterior = atual
    movl %edx, %ebx         # atual = próximo
    jmp .buscar_posicao_qtd

.inserir_inicio_qtd:
    movl lista_temp, %eax
    movl %eax, 132(%esi)
    movl %esi, lista_temp
    jmp .fim_inserir_qtd

.inserir_meio_qtd:
    movl 132(%ebx), %eax
    movl %eax, 132(%esi)
    movl %esi, 132(%ebx)
    jmp .fim_inserir_qtd

.inserir_final_qtd:
    movl $0, 132(%esi)
    movl %esi, 132(%ebx)

.fim_inserir_qtd:
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA IMPRIMIR LISTA TEMPORÁRIA - CORRIGIDA
imprimir_lista_temporaria:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    pushl totalProdutos
    pushl $msgTotalProdutos
    call printf
    addl $8, %esp

    movl lista_temp, %ebx

.loop_imprimir_temp:
    cmpl $0, %ebx
    je .fim_imprimir_temp

    # Imprime produto (mesmo formato)
    subl $8, %esp
    flds 128(%ebx)
    fstpl (%esp)
    subl $8, %esp
    flds 124(%ebx)
    fstpl (%esp)
    pushl 120(%ebx)
    movl %ebx, %eax
    addl $100, %eax
    pushl %eax
    pushl 96(%ebx)
    pushl 92(%ebx)
    pushl 88(%ebx)
    movl %ebx, %eax
    addl $68, %eax
    pushl %eax
    movl %ebx, %eax
    addl $64, %eax
    pushl %eax
    pushl %ebx
    pushl $fmtProduto
    call printf
    addl $60, %esp

    movl 132(%ebx), %ebx
    jmp .loop_imprimir_temp

.fim_imprimir_temp:
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO PARA LIBERAR LISTA TEMPORÁRIA - CORRIGIDA
liberar_lista_temporaria:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi

    movl lista_temp, %ebx

.loop_liberar_temp:
    cmpl $0, %ebx
    je .fim_liberar_temp

    movl 132(%ebx), %esi    # salva próximo ANTES de liberar
    pushl %ebx
    call free
    addl $4, %esp
    movl %esi, %ebx         # vai para o próximo
    jmp .loop_liberar_temp

.fim_liberar_temp:
    movl $0, lista_temp     # limpa ponteiro
    popl %esi
    popl %ebx
    popl %ebp
    ret

# FUNÇÃO DE CARREGAMENTO
carregar:
    pushl $abertCarregamento
    call printf
    addl $4, %esp

    pushl $msgDepInicio
    call printf
    addl $4, %esp

    # Abre arquivo para leitura usando syscall
    movl $5, %eax              # SYS_OPEN
    movl $arquivoBinNome, %ebx
    movl $0, %ecx              # O_RDONLY
    movl $0, %edx
    int $0x80

    cmpl $0, %eax
    jl .erro_abrir_arquivo_carrega

    movl %eax, %edi          

    pushl $msgDepAbriuArquivo
    call printf
    addl $4, %esp

.loop_carrega:
    # Lê um produto do arquivo usando syscall
    movl $3, %eax              # SYS_READ
    movl %edi, %ebx
    movl $bufferProduto, %ecx
    movl $132, %edx            # lê apenas os dados do produto
    int $0x80

    # Verifica se leu algum byte
    cmpl $0, %eax
    je .fim_carrega
    
    # Verifica se leu o tamanho completo
    cmpl $132, %eax
    jne .fim_carrega

    # Verifica se o produto é válido (nome não vazio)
    movb bufferProduto, %al
    cmpb $0, %al
    je .proximo_carrega

    # Aloca memória para novo produto
    pushl $136                 # 136 bytes total
    call malloc
    addl $4, %esp

    cmpl $0, %eax
    je .erro_malloc_carrega

    movl %eax, %esi            # novo produto

    # Copia TODOS os 132 bytes do buffer diretamente para o produto
    pushl %edi
    pushl %ecx
    pushl %eax
    
    movl $bufferProduto, %edi  # fonte
    movl %esi, %eax            # destino
    movl $132, %ecx            # quantidade de bytes
    
.copia_byte_loop:
    cmpl $0, %ecx
    je .fim_copia_bytes
    
    movb (%edi), %dl           # lê byte da fonte
    movb %dl, (%eax)           # escreve byte no destino
    incl %edi                  # próximo byte fonte
    incl %eax                  # próximo byte destino
    decl %ecx                  # decrementa contador
    jmp .copia_byte_loop
    
.fim_copia_bytes:
    popl %eax
    popl %ecx
    popl %edi

    # Inicializa ponteiro próximo
    movl $0, 132(%esi)         # offset 132

    # Insere na lista ordenada
    call inserir_ordenado

    incl totalProdutos

.proximo_carrega:
    jmp .loop_carrega

.fim_carrega:
    # Fecha arquivo usando syscall
    movl $6, %eax              # SYS_CLOSE
    movl %edi, %ebx
    int $0x80

    pushl $msgDepFimLeitura
    call printf
    addl $4, %esp

    pushl totalProdutos
    pushl $msgTotalProdutos
    call printf
    addl $8, %esp

    jmp menu_loop

.erro_abrir_arquivo_carrega:
    pushl $msgErroArquivo
    call printf
    addl $4, %esp
    jmp menu_loop

.erro_malloc_carrega:
    pushl $msgErroMalloc
    call printf
    addl $4, %esp
    movl $6, %eax              # SYS_CLOSE
    movl %edi, %ebx
    int $0x80
    jmp menu_loop

# CONSULTA FINANCEIRA
_consFin:
    pushl $abertConsultaFinanceira
    call printf
    addl $4, %esp

    pushl $msgConsultaFinanceiraMenu
    call printf
    addl $4, %esp

    pushl $opcao
    pushl $tipoDado
    call scanf
    addl $8, %esp

    movl opcao, %eax
    cmpl $1, %eax
    je .calcular_total_compra
    cmpl $2, %eax
    je .calcular_total_venda
    cmpl $3, %eax
    je .calcular_lucro
    cmpl $4, %eax
    je .calcular_capital_perdido

    jmp menu_loop

.calcular_total_compra:
    call calcular_total_compra_func
    subl $8, %esp
    fstpl (%esp)
    pushl $msgTotalCompra
    call printf
    addl $12, %esp
    jmp menu_loop

.calcular_total_venda:
    call calcular_total_venda_func
    subl $8, %esp
    fstpl (%esp)
    pushl $msgTotalVenda
    call printf
    addl $12, %esp
    jmp menu_loop

.calcular_lucro:
    call calcular_total_venda_func
    fstps tempFloat          # salva total venda
    call calcular_total_compra_func
    flds tempFloat           # carrega total venda
    fsubp %st, %st(1)        # CORRIGIDO: venda - compra
    subl $8, %esp
    fstpl (%esp)
    pushl $msgLucroTotal
    call printf
    addl $12, %esp
    jmp menu_loop

.calcular_capital_perdido:
    call calcular_capital_perdido_func
    subl $8, %esp
    fstpl (%esp)
    pushl $msgCapitalPerdido
    call printf
    addl $12, %esp
    jmp menu_loop

# FUNÇÕES DE CÁLCULO CORRIGIDAS
calcular_total_compra_func:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    fldz                    # inicializa total = 0.0
    movl cabeca, %ebx

.loop_compra:
    cmpl $0, %ebx
    je .fim_compra

    # Carrega quantidade e converte para float
    movl 120(%ebx), %ecx    # carrega quantidade em %ecx
    pushl %ecx
    fildl (%esp)            # converte int para float
    addl $4, %esp

    # Carrega preço de compra
    flds 124(%ebx)          # carrega preço_compra (offset 124)
    
    fmulp %st, %st(1)       # quantidade * preço_compra
    faddp %st, %st(1)       # adiciona ao total

    movl 132(%ebx), %ebx    # próximo (offset 132)
    jmp .loop_compra

.fim_compra:
    # resultado já está em st(0)
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função para calcular total de venda (com floats)
calcular_total_venda_func:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    fldz                    # inicializa total = 0.0
    movl cabeca, %ebx

.loop_venda:
    cmpl $0, %ebx
    je .fim_venda

    # Carrega quantidade e converte para float
    movl 120(%ebx), %ecx    # carrega quantidade em %ecx
    pushl %ecx
    fildl (%esp)            # converte int para float
    addl $4, %esp

    # Carrega preço de venda
    flds 128(%ebx)          # carrega preço_venda (offset 128)
    
    fmulp %st, %st(1)       # quantidade * preço_venda
    faddp %st, %st(1)       # adiciona ao total

    movl 132(%ebx), %ebx    # próximo (offset 132)
    jmp .loop_venda

.fim_venda:
    # resultado já está em st(0)
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função para calcular capital perdido (com floats)
calcular_capital_perdido_func:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    fldz                    # inicializa total perdido = 0.0
    movl cabeca, %ebx

.loop_perdido:
    cmpl $0, %ebx
    je .fim_perdido

    # Verifica se produto está vencido
    pushl %ebx
    call produto_vencido
    addl $4, %esp
    
    cmpl $1, %eax           # se produto vencido
    jne .proximo_perdido

    # Calcula valor perdido (quantidade * preço_compra)
    movl 120(%ebx), %ecx    # carrega quantidade
    pushl %ecx
    fildl (%esp)            # converte quantidade para float
    addl $4, %esp
    flds 124(%ebx)          # carrega preço_compra (offset 124)
    fmulp %st, %st(1)       # quantidade * preço_compra
    faddp %st, %st(1)       # adiciona ao total

.proximo_perdido:
    movl 132(%ebx), %ebx    # próximo (offset 132)
    jmp .loop_perdido

.fim_perdido:
    # resultado já está em st(0)
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função para verificar se produto está vencido
# Parâmetro: produto na stack
# Retorna: %eax = 1 se vencido, 0 se não vencido
produto_vencido:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl 8(%ebp), %ebx  # produto

    # Carrega data do produto
    movl 96(%ebx), %eax   # ano do produto (offset 96)
    movl 92(%ebx), %ecx   # mês do produto (offset 92)
    movl 88(%ebx), %edx   # dia do produto (offset 88)

    # Compara anos
    cmpl dataAtualAno, %eax
    jl .produto_vencido      # ano produto < ano atual
    jg .produto_nao_vencido  # ano produto > ano atual

    # Anos iguais, compara meses
    cmpl dataAtualMes, %ecx
    jl .produto_vencido      # mês produto < mês atual
    jg .produto_nao_vencido  # mês produto > mês atual

    # Anos e meses iguais, compara dias
    cmpl dataAtualDia, %edx
    jl .produto_vencido      # dia produto < dia atual

.produto_nao_vencido:
    movl $0, %eax
    jmp .fim_verificar_vencido

.produto_vencido:
    movl $1, %eax

.fim_verificar_vencido:
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# RESTANTE DAS FUNÇÕES (inserção, remoção, atualização, consulta, gravação)
# Função para inserção de produto (ordenado alfabeticamente)
_insProd:
    pushl $abertInsercao
    call printf
    addl $4, %esp

    # Aloca espaço para novo produto (136 bytes)
    pushl $136
    call malloc
    addl $4, %esp
    # Verifica se malloc foi bem-sucedido
    cmpl $0, %eax
    je _erro_malloc_insert
    movl %eax, %esi  # novo produto em %esi

    # Lê nome do produto
    pushl $msgNomeProduto
    call printf
    addl $4, %esp
    pushl $bufferNome
    pushl $tipoString
    call scanf
    addl $8, %esp

    # Copia nome para o produto (offset 0)
    pushl $bufferNome
    pushl %esi
    call strcpy
    addl $8, %esp

    # Lê código do produto
    pushl $msgCodigoProduto
    call printf
    addl $4, %esp
    pushl $bufferCodigo
    pushl $tipoString
    call scanf
    addl $8, %esp

    # Copia código para o produto (offset 64)
    pushl $bufferCodigo
    movl %esi, %eax
    addl $64, %eax
    pushl %eax
    call strcpy
    addl $8, %esp

    # Lê tipo do produto
    pushl $msgTipoProduto
    call printf
    addl $4, %esp
    pushl $bufferTipo
    pushl $tipoString
    call scanf
    addl $8, %esp

    # Copia tipo para o produto (offset 68)
    pushl $bufferTipo
    movl %esi, %eax
    addl $68, %eax
    pushl %eax
    call strcpy
    addl $8, %esp

    # Lê dia da validade
    pushl $msgValidadeDia
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 88(%esi)  # offset 88

    # Lê mês da validade
    pushl $msgValidadeMes
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 92(%esi)  # offset 92

    # Lê ano da validade
    pushl $msgValidadeAno
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 96(%esi)  # offset 96

    # Lê fornecedor
    pushl $msgFornecedor
    call printf
    addl $4, %esp
    pushl $bufferFornecedor
    pushl $tipoString
    call scanf
    addl $8, %esp

    # Copia fornecedor para o produto (offset 100)
    pushl $bufferFornecedor
    movl %esi, %eax
    addl $100, %eax
    pushl %eax
    call strcpy
    addl $8, %esp

    # Lê quantidade
    pushl $msgQuantidade
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 120(%esi)  # offset 120

    # Lê preço de compra (float)
    pushl $msgPrecoCompra
    call printf
    addl $4, %esp
    pushl $tempFloat
    pushl $tipoFloat
    call scanf
    addl $8, %esp
    flds tempFloat
    fstps 124(%esi)  # offset 124

    # Lê preço de venda (float)
    pushl $msgPrecoVenda
    call printf
    addl $4, %esp
    pushl $tempFloat
    pushl $tipoFloat
    call scanf
    addl $8, %esp
    flds tempFloat
    fstps 128(%esi)  # offset 128

    # Inserção ordenada na lista
    call inserir_ordenado
    
    pushl $msgProdutoInserido
    call printf
    addl $4, %esp

    # Incrementa contador
    incl totalProdutos

    jmp menu_loop

# Função para inserir produto ordenado alfabeticamente
# %esi = novo produto
inserir_ordenado:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    # Inicializa o ponteiro próximo como NULL (offset 132)
    movl $0, 132(%esi)

    # Se lista vazia, inserir no início
    movl cabeca, %eax
    cmpl $0, %eax
    je .inserir_inicio

    # Comparar com primeiro elemento
    pushl %esi          # nome do novo produto
    pushl %eax          # nome do primeiro produto
    call strcmp
    addl $8, %esp
    cmpl $0, %eax
    jl .inserir_inicio  # novo produto vem antes do primeiro

    # Procurar posição correta
    movl cabeca, %ebx   # atual
    movl $0, %ecx       # anterior

.buscar_posicao:
    movl 132(%ebx), %edx  # próximo (offset 132)
    cmpl $0, %edx
    je .inserir_final     # inserir no final

    pushl %esi          # nome do novo produto
    pushl %edx          # nome do próximo produto
    call strcmp
    addl $8, %esp
    cmpl $0, %eax
    jl .inserir_meio    # inserir entre atual e próximo

    movl %ebx, %ecx     # anterior = atual
    movl %edx, %ebx     # atual = próximo
    jmp .buscar_posicao

.inserir_inicio:
    movl cabeca, %eax
    movl %eax, 132(%esi)  # novo->próximo = cabeca (offset 132)
    movl %esi, cabeca     # cabeca = novo
    jmp .fim_inserir

.inserir_meio:
    movl 132(%ebx), %eax  # próximo do atual (offset 132)
    movl %eax, 132(%esi)  # novo->próximo = próximo do atual (offset 132)
    movl %esi, 132(%ebx)  # atual->próximo = novo (offset 132)
    jmp .fim_inserir

.inserir_final:
    movl $0, 132(%esi)    # novo->próximo = NULL (offset 132)
    movl %esi, 132(%ebx)  # atual->próximo = novo (offset 132)

.fim_inserir:
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

_erro_malloc_insert:
    pushl $msgErroMalloc
    call printf
    addl $4, %esp
    jmp menu_loop

# Função de remoção
_removProd:
    pushl $abertRemocao
    call printf
    addl $4, %esp

    pushl $msgTipoRemocao
    call printf
    addl $4, %esp

    pushl $opcao
    pushl $tipoDado
    call scanf
    addl $8, %esp

    # Limpa buffer do stdin após scanf
    call limpar_buffer_stdin

    movl opcao, %eax
    cmpl $1, %eax
    je .remover_por_nome
    cmpl $2, %eax
    je .remover_por_validade

    jmp menu_loop

.remover_por_nome:
    pushl $msgBuscarNome
    call printf
    addl $4, %esp
    
    # Usar fgets para ler nome completo
    pushl stdin
    pushl $64
    pushl $bufferNome
    call fgets
    addl $12, %esp
    
    # Remove quebra de linha se existir
    call remover_quebra_linha
    
    call remover_produto_por_nome
    jmp menu_loop

.remover_por_validade:
    call remover_produtos_vencidos
    jmp menu_loop

# Função para limpar buffer do stdin
limpar_buffer_stdin:
    pushl %ebp
    movl %esp, %ebp
    pushl %eax

.loop_limpar:
    call getchar
    cmpl $10, %eax      # '\n'
    je .fim_limpar
    cmpl $-1, %eax      # EOF
    je .fim_limpar
    jmp .loop_limpar

.fim_limpar:
    popl %eax
    popl %ebp
    ret

# Função para remover quebra de linha do buffer
remover_quebra_linha:
    pushl %ebp
    movl %esp, %ebp
    pushl %eax
    pushl %ebx

    movl $bufferNome, %ebx
    movl $0, %eax

.loop_quebra:
    movb (%ebx,%eax), %cl
    cmpb $0, %cl
    je .fim_quebra
    cmpb $10, %cl       # '\n'
    je .substituir_quebra
    incl %eax
    jmp .loop_quebra

.substituir_quebra:
    movb $0, (%ebx,%eax)  # substitui '\n' por '\0'

.fim_quebra:
    popl %ebx
    popl %eax
    popl %ebp
    ret

# Função para remover produto por nome
remover_produto_por_nome:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl cabeca, %ebx
    movl $0, %ecx       # anterior

.buscar_remover:
    cmpl $0, %ebx       # verifica se atual é NULL
    je .nao_encontrado_remover

    # Salva %ecx antes da chamada a strcmp
    pushl %ecx          

    # Compara o nome atual com o nome buscado
    pushl $bufferNome
    pushl %ebx      
    call strcmp
    addl $8, %esp

    # Restaura %ecx após a chamada a strcmp
    popl %ecx           

    cmpl $0, %eax
    je .remover_produto  # se encontrou, remove

    movl %ebx, %ecx     # anterior = atual
    movl 132(%ebx), %ebx # atual = próximo (offset 132)
    jmp .buscar_remover

.remover_produto:
    # Se é o primeiro da lista
    cmpl $0, %ecx
    je .remover_primeiro

    # Remove do meio/final
    movl 132(%ebx), %eax  # próximo do atual (offset 132)
    movl %eax, 132(%ecx)  # anterior->próximo = próximo do atual (offset 132)
    jmp .liberar_memoria

.remover_primeiro:
    movl 132(%ebx), %eax  # próximo do atual (offset 132)
    movl %eax, cabeca     # cabeca = próximo

.liberar_memoria:
    pushl %ebx
    call free
    addl $4, %esp
    
    decl totalProdutos
    
    pushl $msgProdutoRemovido
    call printf
    addl $4, %esp
    jmp .fim_remover

.nao_encontrado_remover:
    pushl $msgProdutoNaoEncontrado
    call printf
    addl $4, %esp

.fim_remover:
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função para remover produtos vencidos
remover_produtos_vencidos:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi

    movl $0, %edx       # contador de removidos

.reiniciar_busca_vencidos:
    movl cabeca, %ebx   # atual
    movl $0, %ecx       # anterior

.loop_vencidos:
    cmpl $0, %ebx       # verifica se atual é NULL
    je .fim_remover_vencidos

    # Verifica se produto está vencido
    pushl %ebx
    call produto_vencido
    addl $4, %esp
    
    cmpl $1, %eax       # se produto vencido
    je .remover_vencido_atual

    # Produto não vencido, avança
    movl %ebx, %ecx     # anterior = atual
    movl 132(%ebx), %ebx # atual = próximo (offset 132)
    jmp .loop_vencidos

.remover_vencido_atual:
    # Debug: mostra produto vencido
    pushl %ebx
    pushl $msgDebugValidadeVencida
    call printf
    addl $8, %esp

    movl 132(%ebx), %esi  # salva próximo antes de remover (offset 132)

    # Se é o primeiro da lista
    cmpl $0, %ecx
    je .remover_vencido_primeiro

    # Remove do meio/final
    movl %esi, 132(%ecx)  # anterior->próximo = próximo do atual (offset 132)
    jmp .liberar_vencido

.remover_vencido_primeiro:
    movl %esi, cabeca     # cabeca = próximo

.liberar_vencido:
    pushl %ebx
    call free
    addl $4, %esp
    
    decl totalProdutos
    incl %edx           # incrementa contador de removidos
    
    # Reinicia a busca do início para evitar problemas
    jmp .reiniciar_busca_vencidos

.fim_remover_vencidos:
    # Mostra quantos produtos foram removidos
    pushl %edx
    pushl $msgProdutosVencidosRemovidos
    call printf
    addl $8, %esp

    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função de atualização
_attProd:
    pushl $abertAtualizacao
    call printf
    addl $4, %esp

    pushl $msgBuscarNome
    call printf
    addl $4, %esp
    
    # Limpa buffer antes de ler
    call limpar_buffer_stdin
    
    # USA fgets AO INVÉS DE scanf PARA LER NOME COMPLETO
    pushl stdin
    pushl $64
    pushl $bufferNome
    call fgets
    addl $12, %esp
    
    # Remove quebra de linha
    call remover_quebra_linha

    call buscar_produto_por_nome
    cmpl $0, %eax
    je .produto_nao_encontrado_att

    movl %eax, %esi  # produto encontrado

    pushl $msgNovaQuantidade
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 120(%esi)  # offset 120

    pushl $msgNovoPrecoVenda
    call printf
    addl $4, %esp
    pushl $tempFloat
    pushl $tipoFloat
    call scanf
    addl $8, %esp
    flds tempFloat
    fstps 128(%esi)  # offset 128

    pushl $msgProdutoAtualizado
    call printf
    addl $4, %esp
    jmp menu_loop

.produto_nao_encontrado_att:
    pushl $msgProdutoNaoEncontrado
    call printf
    addl $4, %esp
    jmp menu_loop

# Função para buscar produto por nome
buscar_produto_por_nome:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    movl cabeca, %ebx

.buscar_loop:
    cmpl $0, %ebx
    je .nao_encontrado_buscar

    # Compara strings
    pushl $bufferNome
    pushl %ebx
    call strcmp
    addl $8, %esp
    cmpl $0, %eax
    je .encontrado_buscar

    movl 132(%ebx), %ebx   # próximo (offset 132)
    jmp .buscar_loop

.encontrado_buscar:
    movl %ebx, %eax
    jmp .fim_buscar

.nao_encontrado_buscar:
    movl $0, %eax

.fim_buscar:
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função de consulta
_consProd:
    pushl $abertConsultaProd
    call printf
    addl $4, %esp

    pushl $msgBuscarNome
    call printf
    addl $4, %esp
    
    # Limpa buffer antes de ler
    call limpar_buffer_stdin
    
    # USA fgets AO INVÉS DE scanf PARA LER NOME COMPLETO
    pushl stdin
    pushl $64
    pushl $bufferNome
    call fgets
    addl $12, %esp
    
    # Remove quebra de linha
    call remover_quebra_linha

    call buscar_produto_por_nome
    cmpl $0, %eax
    je .produto_nao_encontrado_cons

    movl %eax, %edi
    pushl $msgProdutoEncontrado
    call printf
    addl $4, %esp

    # Imprime produto encontrado (com floats)
    subl $8, %esp           # aloca espaço na stack para doubles
    flds 128(%edi)          # carrega preço venda (offset 128)
    fstpl (%esp)            # converte para double e armazena
    subl $8, %esp
    flds 124(%edi)          # carrega preço compra (offset 124)
    fstpl (%esp)
    pushl 120(%edi)         # quantidade (offset 120)
    movl %edi, %eax
    addl $100, %eax         # fornecedor (offset 100)
    pushl %eax
    pushl 96(%edi)          # ano (offset 96)
    pushl 92(%edi)          # mês (offset 92)
    pushl 88(%edi)          # dia (offset 88)
    movl %edi, %eax
    addl $68, %eax          # tipo (offset 68)
    pushl %eax
    movl %edi, %eax
    addl $64, %eax          # código (offset 64)
    pushl %eax
    pushl %edi              # nome (offset 0)
    pushl $fmtProduto
    call printf
    addl $60, %esp          # 44 + 16 (2 doubles)

    jmp menu_loop

.produto_nao_encontrado_cons:
    pushl $msgProdutoNaoEncontrado
    call printf
    addl $4, %esp
    jmp menu_loop

# Função de gravação usando chamadas do sistema
_grava:
    pushl $abertGravacao
    call printf
    addl $4, %esp

    # Abre arquivo para escrita usando syscall
    movl $5, %eax              # SYS_OPEN
    movl $arquivoBinNome, %ebx
    movl $577, %ecx            # O_WRONLY | O_CREAT | O_TRUNC (1 | 64 | 512)
    movl $0644, %edx           # permissões
    int $0x80

    cmpl $0, %eax
    jl .erro_abrir_arquivo_grava

    movl %eax, %edi            # file descriptor

    # Percorre lista e grava cada produto
    movl cabeca, %esi          # produto atual

.loop_grava:
    cmpl $0, %esi
    je .fim_grava

    # Escreve produto diretamente no arquivo (já com floats corretos)
    movl $4, %eax              # SYS_WRITE
    movl %edi, %ebx            # file descriptor
    movl %esi, %ecx            # dados do produto atual
    movl $132, %edx            # tamanho dos dados (sem o ponteiro próximo)
    int $0x80
    
    movl 132(%esi), %esi       # próximo produto (offset 132)
    jmp .loop_grava

.fim_grava:
    # Fecha arquivo usando syscall
    movl $6, %eax              # SYS_CLOSE
    movl %edi, %ebx
    int $0x80

    pushl $msgArquivoSalvo
    call printf
    addl $4, %esp
    jmp menu_loop

.erro_abrir_arquivo_grava:
    pushl $msgErroArquivo
    call printf
    addl $4, %esp
    jmp menu_loop

# Função auxiliar comparar_datas_produtos (para inserir_ordenado_validade)
comparar_datas_produtos:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    movl %esi, %ebx            # novo produto
    movl lista_temp, %ecx      # primeiro da lista temp

    # Compara anos
    movl 96(%ebx), %eax        # ano do novo
    cmpl 96(%ecx), %eax        # compara com ano do primeiro
    jne .fim_comparar_datas_produtos

    # Anos iguais, compara meses
    movl 92(%ebx), %eax        # mês do novo
    cmpl 92(%ecx), %eax        # compara com mês do primeiro
    jne .fim_comparar_datas_produtos

    # Meses iguais, compara dias
    movl 88(%ebx), %eax        # dia do novo
    subl 88(%ecx), %eax        # subtrai dia do primeiro

.fim_comparar_datas_produtos:
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função memcpy (copia memória)
memcpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ecx

    movl 8(%ebp), %edi      # destino
    movl 12(%ebp), %esi     # origem
    movl 16(%ebp), %ecx     # tamanho

    cld
    rep movsb

    popl %ecx
    popl %edi
    popl %esi
    popl %ebp
    ret

# Função de saída
_fim:
    # Libera memória de todos os produtos
    movl cabeca, %ebx

.loop_liberar:
    cmpl $0, %ebx
    je .fim_liberar

    movl 132(%ebx), %esi    # salva próximo (offset 132)
    pushl %ebx
    call free
    addl $4, %esp
    movl %esi, %ebx
    jmp .loop_liberar

.fim_liberar:
    pushl $0
    call exit