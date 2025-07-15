.section .data
    abertura:   .asciz  "\nSistema de Controle de Estoque para Supermercado\n\n"
    menuOpcao:  .asciz  "\nMenu de Opcao:\n<1> Inserção de Produto\n<2> Remoção de Produtos\n<3> Atualização de Produto\n<4> Consulta de Produto\n<5> Consulta Financeira\n<6> Gravação de Registro\n<7> Carregamento/Recuperação de Registros\n<8> Relatório de Registros\n<0> Sair"
    pedeOpcao:  .asciz  "\nDigite uma opção: "
    tipoDado:   .asciz  "%d"
    tipoString: .asciz  "%s"

    opcao: .int 0
    cabeca: .int 0            # ponteiro para primeiro produto
    bufferProduto: .space 132  # buffer temporário para fread
    totalProdutos: .int 0

    # Data atual para verificação de validade (pode ser modificada)
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

    # Formato para impressão
    fmtProduto: .asciz "\nNome: %s | Codigo: %s | Tipo: %s | Validade: %02d/%02d/%04d | Fornecedor: %s | Quantidade: %d | Compra: %d | Venda: %d\n"

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
    # Mensagens de depuração adicionais
    msgDepAbriuArquivo: .asciz "-> Arquivo aberto com sucesso\n"
    msgDepLendoRegistro: .asciz "-> Lendo registro %d\n"
    msgDepBytesLidos: .asciz "-> Bytes lidos: %d\n"
    msgDepAlocandoMemoria: .asciz "-> Alocando memória para produto\n"
    msgDepCopiandoDados: .asciz "-> Copiando dados para produto\n"
    msgDepInserindoOrdenado: .asciz "-> Inserindo produto ordenado\n"
    msgDepProdutoInserido: .asciz "-> Produto inserido: %s\n"
    msgDepTamanhoArquivo: .asciz "-> Tentando ler %d bytes\n"
    msgDepPosicaoArquivo: .asciz "-> Posição no arquivo antes da leitura\n"
    contador_registro: .int 0
    msgDebugTamanhoArquivo: .asciz "Tamanho do arquivo: %d bytes\n"
    msgDebugPrimeirosBytesArquivo: .asciz "Primeiros bytes do arquivo: %02x %02x %02x %02x\n"
    msgDebugConteudoBuffer: .asciz "Conteúdo do buffer após leitura: [%s]\n"
    msgDebugNomeLido: .asciz "-> Nome lido: [%s]\n"
    msgDebugCodigoLido: .asciz "-> Código lido: [%s]\n"
    msgDebugProdutoValido: .asciz "-> Produto válido detectado\n"
    msgDebugProdutoInvalido: .asciz "-> Produto inválido (nome vazio)\n"
    msgDebugFeof: .asciz "-> feof() retornou: %d\n"
    msgDebugFerror: .asciz "-> ferror() retornou: %d\n"
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

    # Mensagens para consulta financeira
    msgConsultaFinanceiraMenu: .asciz "Consulta Financeira:\n<1> Total de compra\n<2> Total de venda\n<3> Lucro total\n<4> Capital perdido\nEscolha: "
    msgTotalCompra: .asciz "Total de compra: %d\n"
    msgTotalVenda: .asciz "Total de venda: %d\n"
    msgLucroTotal: .asciz "Lucro total: %d\n"
    msgCapitalPerdido: .asciz "Capital perdido: %d\n"

.section .text
    .extern printf, scanf, fopen, fread, fwrite, fclose, malloc, free, exit, strcmp, strcpy, fgets, stdin, feof, ferror, fseek, ftell
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

# Função para inserção de produto (ordenado alfabeticamente)
_insProd:
    pushl $abertInsercao
    call printf
    addl $4, %esp

    # Aloca espaço para novo produto
    pushl $136  # 132 dados + 4 para ponteiro próximo
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

    # Copia nome para o produto
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

    # Copia código para o produto
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

    # Copia tipo para o produto
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
    movl %eax, 88(%esi)

    # Lê mês da validade
    pushl $msgValidadeMes
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 92(%esi)

    # Lê ano da validade
    pushl $msgValidadeAno
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 96(%esi)

    # Lê fornecedor
    pushl $msgFornecedor
    call printf
    addl $4, %esp
    pushl $bufferFornecedor
    pushl $tipoString
    call scanf
    addl $8, %esp

    # Copia fornecedor para o produto
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
    movl %eax, 120(%esi)

    # Lê preço de compra
    pushl $msgPrecoCompra
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 124(%esi)

    # Lê preço de venda
    pushl $msgPrecoVenda
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 128(%esi)

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

    # Inicializa o ponteiro próximo como NULL
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
    movl 132(%ebx), %edx  # próximo
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
    movl %eax, 132(%esi)  # novo->próximo = cabeca
    movl %esi, cabeca     # cabeca = novo
    jmp .fim_inserir

.inserir_meio:
    movl 132(%ebx), %eax  # próximo do atual
    movl %eax, 132(%esi)  # novo->próximo = próximo do atual
    movl %esi, 132(%ebx)  # atual->próximo = novo
    jmp .fim_inserir

.inserir_final:
    movl $0, 132(%esi)    # novo->próximo = NULL
    movl %esi, 132(%ebx)  # atual->próximo = novo

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

    # Debug: mostra o nome que está sendo buscado
    pushl $bufferNome
    pushl $msgDebugNomeLido
    call printf
    addl $8, %esp


    movl cabeca, %ebx
    movl $0, %ecx       # anterior

.buscar_remover:
    cmpl $0, %ebx       # verifica se atual é NULL
    je .nao_encontrado_remover

    # Salva %ecx antes da chamada a strcmp (redundante devido ao prólogo/epílogo, mas atende ao seu pedido)
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
    movl 132(%ebx), %ebx # atual = próximo
    jmp .buscar_remover
.remover_produto:
    # Debug: produto encontrado
    #pushl %ebx
    #pushl $msgDebugProdutoValido
    #call printf
    #addl $8, %esp

    # Se é o primeiro da lista
    cmpl $0, %ecx
    je .remover_primeiro

    # Remove do meio/final
    movl 132(%ebx), %eax  # próximo do atual
    movl %eax, 132(%ecx)  # anterior->próximo = próximo do atual
    jmp .liberar_memoria

.remover_primeiro:
    movl 132(%ebx), %eax  # próximo do atual
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

# Função para remover produtos vencidos CORRIGIDA
remover_produtos_vencidos:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi

    movl cabeca, %ebx   # atual
    movl $0, %ecx       # anterior
    movl $0, %edx       # contador de removidos

.loop_vencidos:
    cmpl $0, %ebx
    je .fim_remover_vencidos

    # Verifica se produto está vencido
    pushl %ebx
    call produto_vencido
    addl $4, %esp
    
    cmpl $1, %eax       # se produto vencido
    je .remover_vencido

    # Produto não vencido, continua
    movl %ebx, %ecx     # anterior = atual
    movl 132(%ebx), %ebx # atual = próximo
    jmp .loop_vencidos

.remover_vencido:
    # Debug: mostra produto vencido
    pushl %ebx
    pushl $msgDebugValidadeVencida
    call printf
    addl $8, %esp

    movl 132(%ebx), %esi  # salva próximo antes de remover

    # Se é o primeiro da lista
    cmpl $0, %ecx
    je .remover_vencido_primeiro

    # Remove do meio/final
    movl %esi, 132(%ecx)  # anterior->próximo = próximo do atual
    jmp .liberar_vencido

.remover_vencido_primeiro:
    movl %esi, cabeca     # cabeca = próximo

.liberar_vencido:
    pushl %ebx
    call free
    addl $4, %esp
    
    decl totalProdutos
    incl %edx           # incrementa contador de removidos
    
    movl %esi, %ebx     # atual = próximo salvo
    # Não atualiza anterior porque removeu o atual
    jmp .loop_vencidos

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

# Função para verificar se produto está vencido
# Parâmetro: %ebx = ponteiro para produto
# Retorna: %eax = 1 se vencido, 0 se não vencido
produto_vencido:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl 8(%ebp), %ebx  # produto

    # Carrega data do produto
    movl 96(%ebx), %eax   # ano do produto
    movl 92(%ebx), %ecx   # mês do produto
    movl 88(%ebx), %edx   # dia do produto

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
    movl %eax, 120(%esi)

    pushl $msgNovoPrecoVenda
    call printf
    addl $4, %esp
    pushl $tempInt
    pushl $tipoDado
    call scanf
    addl $8, %esp
    movl tempInt, %eax
    movl %eax, 128(%esi)

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

    movl 132(%ebx), %ebx
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

    # Imprime produto encontrado
    pushl 128(%edi)
    pushl 124(%edi)
    pushl 120(%edi)
    movl %edi, %eax
    addl $100, %eax
    pushl %eax
    movl 96(%edi), %eax
    pushl %eax
    movl 92(%edi), %eax
    pushl %eax
    movl 88(%edi), %eax
    pushl %eax
    movl %edi, %eax
    addl $68, %eax
    pushl %eax
    movl %edi, %eax
    addl $64, %eax
    pushl %eax
    movl %edi, %eax
    addl $0, %eax
    pushl %eax
    pushl $fmtProduto
    call printf
    addl $44, %esp

    jmp menu_loop

.produto_nao_encontrado_cons:
    pushl $msgProdutoNaoEncontrado
    call printf
    addl $4, %esp
    jmp menu_loop

# Função de consulta financeira
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
    pushl %eax
    pushl $msgTotalCompra
    call printf
    addl $8, %esp
    jmp menu_loop

.calcular_total_venda:
    call calcular_total_venda_func
    pushl %eax
    pushl $msgTotalVenda
    call printf
    addl $8, %esp
    jmp menu_loop

.calcular_lucro:
    call calcular_total_venda_func
    pushl %eax
    call calcular_total_compra_func
    popl %ebx
    subl %eax, %ebx
    pushl %ebx
    pushl $msgLucroTotal
    call printf
    addl $8, %esp
    jmp menu_loop

.calcular_capital_perdido:
    call calcular_capital_perdido_func
    pushl %eax
    pushl $msgCapitalPerdido
    call printf
    addl $8, %esp
    jmp menu_loop

# Função para calcular total de compra
calcular_capital_perdido_func:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx
    pushl %edx  # Adicionado para salvar %edx

    movl $0, %edx       # total perdido (mudado para %edx)
    movl cabeca, %ebx

.loop_perdido:
    cmpl $0, %ebx
    je .fim_perdido

    # Verifica se produto está vencido
    pushl %ebx
    call produto_vencido
    addl $4, %esp
    
    cmpl $1, %eax       # se produto vencido
    jne .proximo_perdido

    # Calcula valor perdido
    movl 120(%ebx), %ecx  # quantidade
    imull 124(%ebx), %ecx # quantidade * preço_compra
    addl %ecx, %edx       # total_perdido += quantidade * preço_compra

.proximo_perdido:
    movl 132(%ebx), %ebx  # próximo
    jmp .loop_perdido

.fim_perdido:
    movl %edx, %eax       # retorna total perdido em %eax
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

calcular_total_compra_func:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    movl $0, %eax       # total
    movl cabeca, %ebx

.loop_compra:
    cmpl $0, %ebx
    je .fim_compra

    movl 120(%ebx), %ecx  # quantidade
    imull 124(%ebx), %ecx # quantidade * preço_compra
    addl %ecx, %eax       # total += quantidade * preço_compra

    movl 132(%ebx), %ebx  # próximo
    jmp .loop_compra

.fim_compra:
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função para calcular total de venda
calcular_total_venda_func:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %ecx

    movl $0, %eax       # total
    movl cabeca, %ebx

# Continuação da função calcular_total_venda_func
.loop_venda:
    cmpl $0, %ebx
    je .fim_venda

    movl 120(%ebx), %ecx  # quantidade
    imull 128(%ebx), %ecx # quantidade * preço_venda
    addl %ecx, %eax       # total += quantidade * preço_venda

    movl 132(%ebx), %ebx  # próximo
    jmp .loop_venda

.fim_venda:
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# Função de gravação de arquivos
_grava:
    pushl $abertGravacao
    call printf
    addl $4, %esp

    # Abre arquivo para escrita
    pushl $modoEscritaBin
    pushl $arquivoBinNome
    call fopen
    addl $8, %esp

    cmpl $0, %eax
    je .erro_abrir_arquivo_grava

    movl %eax, %edi  # file pointer

    # Percorre lista e grava cada produto
    movl cabeca, %ebx

.loop_grava:
    cmpl $0, %ebx
    je .fim_grava

    # Escreve produto no arquivo
    pushl %edi
    pushl $1
    pushl $132
    pushl %ebx
    call fwrite
    addl $16, %esp

    movl 132(%ebx), %ebx  # próximo
    jmp .loop_grava

.fim_grava:
    # Fecha arquivo
    pushl %edi
    call fclose
    addl $4, %esp

    pushl $msgArquivoSalvo
    call printf
    addl $4, %esp
    jmp menu_loop

.erro_abrir_arquivo_grava:
    pushl $msgErroArquivo
    call printf
    addl $4, %esp
    jmp menu_loop

# Função de carregamento de arquivos
carregar:
    pushl $abertCarregamento
    call printf
    addl $4, %esp

    pushl $msgDepInicio
    call printf
    addl $4, %esp

    # Abre arquivo para leitura
    pushl $modoLeituraBin
    pushl $arquivoBinNome
    call fopen
    addl $8, %esp

    cmpl $0, %eax
    je .erro_abrir_arquivo_carrega

    movl %eax, %edi  # file pointer
    movl $0, contador_registro

    pushl $msgDepAbriuArquivo
    call printf
    addl $4, %esp

.loop_carrega:
    # Lê um produto do arquivo
    pushl %edi
    pushl $1
    pushl $132
    pushl $bufferProduto
    call fread
    addl $16, %esp

    # Verifica se leu algum byte
    cmpl $0, %eax
    je .fim_carrega

    # Verifica se o produto é válido (nome não vazio)
    movb bufferProduto, %al
    cmpb $0, %al
    je .proximo_carrega

    # Aloca memória para novo produto
    pushl $136
    call malloc
    addl $4, %esp

    cmpl $0, %eax
    je .erro_malloc_carrega

    movl %eax, %esi  # novo produto

    # Copia dados do buffer para o produto
    pushl $132
    pushl $bufferProduto
    pushl %esi
    call memcpy
    addl $12, %esp

    # Inicializa ponteiro próximo
    movl $0, 132(%esi)

    # Insere na lista ordenada
    call inserir_ordenado

    incl totalProdutos
    incl contador_registro

.proximo_carrega:
    jmp .loop_carrega

.fim_carrega:
    # Fecha arquivo
    pushl %edi
    call fclose
    addl $4, %esp

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
    pushl %edi
    call fclose
    addl $4, %esp
    jmp menu_loop

# Função de relatório
relatorio:
    pushl $abertRelatorio
    call printf
    addl $4, %esp

    # Verifica se lista está vazia
    movl cabeca, %ebx
    cmpl $0, %ebx
    je .lista_vazia_relatorio

    pushl totalProdutos
    pushl $msgTotalProdutos
    call printf
    addl $8, %esp

.loop_relatorio:
    cmpl $0, %ebx
    je .fim_relatorio

    # Imprime produto
    pushl 128(%ebx)  # preço venda
    pushl 124(%ebx)  # preço compra
    pushl 120(%ebx)  # quantidade
    movl %ebx, %eax
    addl $100, %eax  # fornecedor
    pushl %eax
    pushl 96(%ebx)   # ano
    pushl 92(%ebx)   # mês
    pushl 88(%ebx)   # dia
    movl %ebx, %eax
    addl $68, %eax   # tipo
    pushl %eax
    movl %ebx, %eax
    addl $64, %eax   # código
    pushl %eax
    pushl %ebx       # nome
    pushl $fmtProduto
    call printf
    addl $44, %esp

    movl 132(%ebx), %ebx  # próximo
    jmp .loop_relatorio

.lista_vazia_relatorio:
    pushl $msgDepCabecaNull
    call printf
    addl $4, %esp

.fim_relatorio:
    jmp menu_loop

# Função memcpy (copia memória)
memcpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ecx

    movl 8(%ebp), %edi   # destino
    movl 12(%ebp), %esi  # origem
    movl 16(%ebp), %ecx  # tamanho

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

    movl 132(%ebx), %esi  # salva próximo
    pushl %ebx
    call free
    addl $4, %esp
    movl %esi, %ebx
    jmp .loop_liberar

.fim_liberar:
    pushl $0
    call exit