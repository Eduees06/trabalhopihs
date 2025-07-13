import struct

def escrever_registro_binario(arquivo_saida, campos):
    """
    campos = [
        nome, codigo, tipo, dia, mes, ano, fornecedor, quantidade, precoCompra, precoVenda
    ]
    """
    nome, codigo, tipo, validade, fornecedor, quantidade, preco_compra, preco_venda = campos

    # Parse data de validade: "dd/mm/yyyy"
    dia, mes, ano = map(int, validade.strip().split('/'))

    # Prepara as strings: encode UTF-8 e completa com zeros até o tamanho fixo
    nome_bytes = nome.encode('utf-8')[:64].ljust(64, b'\0')
    codigo_bytes = codigo.encode('utf-8')[:4].ljust(4, b'\0')
    tipo_bytes = tipo.encode('utf-8')[:20].ljust(20, b'\0')
    fornecedor_bytes = fornecedor.encode('utf-8')[:20].ljust(20, b'\0')

    # Converte inteiros
    quantidade = int(quantidade.strip())
    preco_compra = int(preco_compra.strip())
    preco_venda = int(preco_venda.strip())

    # Monta struct: strings fixas + 6 inteiros
    packed = struct.pack(
        '64s4s20siii20siii',
        nome_bytes,
        codigo_bytes,
        tipo_bytes,
        dia, mes, ano,
        fornecedor_bytes,
        quantidade,
        preco_compra,
        preco_venda
    )

    # Escreve no arquivo
    arquivo_saida.write(packed)

def main():
    with open("produtos.txt", encoding='utf-8') as f_in, \
         open("produtos.bin", "wb") as f_out:

        for linha in f_in:
            # Ignora linhas vazias
            if not linha.strip():
                continue

            campos = linha.strip().split(';')
            if len(campos) != 8:
                print("Linha ignorada (campos insuficientes):", linha)
                continue

            escrever_registro_binario(f_out, campos)

    print("Arquivo produtos.bin gerado com sucesso!")

if __name__ == "__main__":
    main()
