.text
main:
	# Configuração inicial
	lui $8, 0x1001       # Endereço base do cenário (vetor gráfico)
    
	lui $9, 0x006C       # Verde claro (parte alta)
	ori $9, $9, 0xBF4C   # Verde claro (completo)
    
	lui $10, 0x0000      # Verde escuro (parte alta)
	ori $10, $10, 0x7B1A # Verde escuro (completo)
    
	addi $11, $0, 8      # Dimensão de um quadrado (8x8)
	addi $12, $0, 128    # Largura da tela em pixels
	addi $13, $0, 0      # Contador de linhas
	addi $14, $0, 0      # Contador de colunas

	# Variáveis de controle
	addi $15, $0, 0      # Cor atual (0 para claro, 1 para escuro)
	addi $16, $0, 1024   # Total de pixels (128 * 64, por exemplo)

desenho:
	# Verificar fim do desenho
	beq $16, $0, fim
	
	# Escolher cor atual
    	beq $15, $0, useVerdeClaro
    	lui $9, 0x0000      # Verde escuro (parte alta)
    	ori $9, $9, 0x7B1A  # Verde escuro (completo)
    	
    	j pintar

useVerdeClaro:
	lui $9, 0x006C       # Verde claro (parte alta)
	ori $9, $9, 0xBF4C   # Verde claro (completo)
	
pintar:
	sw $9, 0($8)         
	sw $9, 512($8)
	sw $9, 1024($8)
	sw $9, 1536($8)
	sw $9, 2048($8)
	sw $9, 2560($8)
	sw $9, 3072($8)
	sw $9, 3584($8)
	
	addi $8, $8, 4       # Proximo 
	addi $16, $16, -1    # Decrementa pixel restante
	addi $12, $12, -1    # Decrementa limite de colunas na linha
	
	# Contadores de posição
	addi $14, $14, 1     # Contador de Colunas
	bne $14, $11, desenho # Verifica se chegou ao final do quadrado na linha
	
	# Alternar cor após completar quadrado na linha
    	xor $15, $15, 1      # Troca entre 0 e 1 (claro/escuro)
    	addi $14, $0, 0      # Reinicia contador de colunas
    	
    	# Verifica se chegou no final da linha
    	bne $12, $0, desenho
	addi $12, $0, 128    # Reinicia a largura da tela em unidaeds graficas
	addi $8, $8, 3584
	xor $15, $15, 1      # Alterna cor
	
    	j desenho
fim:
	addi $2, $0, 10
	syscall
