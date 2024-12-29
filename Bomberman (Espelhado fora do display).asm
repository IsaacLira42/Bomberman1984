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
	addi $16, $0, 1024   # Total de Unidades gráficas (1 Unidade grafica = 4x4 pixels) (128 * 64)

desenho:
	# Verificar fim do desenho
	beq $16, $0, limitesDoMapa
	
	# Escolher cor atual
    	beq $15, $0, useVerdeClaro
    	lui $9, 0x0000      # Verde escuro (parte alta)
    	ori $9, $9, 0x7B1A  # Verde escuro (completo)
    	
    	j pintar

useVerdeClaro:
	lui $9, 0x006C       # Verde claro (parte alta)
	ori $9, $9, 0xBF4C   # Verde claro (completo)
	
pintar:
	sw $9, 0($8)       # 1
	sw $9, 32768($8)   # 1 - Copia fora do display
	sw $9, 512($8)     # 2
	sw $9, 33280($8)   # 2 - Copia fora do display
	sw $9, 1024($8)    # 3
	sw $9, 33792($8)   # 3 - Copia fora do display
	sw $9, 1536($8)    # 4
	sw $9, 34304($8)   # 4 - Copia fora do display
	sw $9, 2048($8)    # 5
	sw $9, 34816($8)   # 5 - Copia fora do display
	sw $9, 2560($8)    # 6
	sw $9, 35328($8)   # 6 - Copia fora do display
	sw $9, 3072($8)    # 7
	sw $9, 35840($8)   # 7 - Copia fora do display
	sw $9, 3584($8)    # 8
	sw $9, 36352($8)   # 8 - Copia fora do display
	
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

limitesDoMapa:
	# Reiniciando Variáveis de controle
	lui $8, 0x1001    # Primeira posição do vetor
	addi $25, $0, 16  # Limite de blocos horizontais
	
blocosHorizontaisCima:
	beq $25, $0, blocosVerticais
	jal blocosCinzas  # Chamada da função
	addi $25, $25, -1
	j blocosHorizontaisCima
	
blocosVerticais:
	addi $25, $0, 16  # Reiniciando limite de blocos horizontais
	addi $24, $0, 6
	loopDesenharBlocosVerticais:
		beq $24, $0, blocosHorizontaisBaixo
		addi $8, $8, 3584
		jal blocosCinzas
		addi $8, $8, 448
		jal blocosCinzas
		addi $24, $24, -1
		j loopDesenharBlocosVerticais

blocosHorizontaisBaixo:
	addi $25, $0, 16  # Reiniciando limite de blocos horizontais
	addi $8, $8, 3584
	loop23132141:
		beq $25, $0, contornoPretoDosBlocosLimites
		jal blocosCinzas  # Chamada da função
		addi $25, $25, -1
		j loop23132141

contornoPretoDosBlocosLimites:
		lui $8, 0x1001       # Carrega os 16 bits superiores (0x1001) no registrador $8
		ori $8, $8, 0x0E20   # Combina os 16 bits inferiores (0x0E1C) com os já existentes em $8
		
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
	
		addi $10, $0, 0    # Contador de linhas
		addi $11, $0, 0    # Contador de colunas
		
		addi $25, $0, 112
		addi $24, $0, 50
		loopContornoHorizontal:
			beq $25, $0, loopContornoVertical
			addi $25, $25, -1
			sw $9, 0($8)
			sw $9, 32768($8) # Copia fora do display
			
			sw $9, 25088($8)
			sw $9, 57856($8) # Copia fora do display
			
			addi $8, $8, 4  # Proxima posição do vetor
			j loopContornoHorizontal
	
		loopContornoVertical:
			beq $24, $0, obstaculos
			addi $24, $24, -1
			
			sw $9, 0($8)
			sw $9, 32768($8) # Copia fora do display
			
			sw $9, -452($8)
			sw $9, 32316($8) # Copia fora do display
			
			addi $8, $8, 512
			j loopContornoVertical
####################################################################################	

obstaculos:
	lui $8, 0x1001
	ori $8, $8, 0x0040
	addi $8, $8, 28672
	
	addi $24, $0, 3  # quantidade de linhas
	
	loopzaoDesenharObstaculos:
		beq $24, $0, fim
		addi $24, $24, -1
		addi $8, $8, -8192
		addi $25, $0, 7  # Limite de obstaculos em uma linha
		
		loopzinhoDesenharObstaculos:
			beq $25, $0, correcao
			addi $25, $25, -1
			jal blocosCinzas
			addi $8, $8, 32
			j loopzinhoDesenharObstaculos
		correcao:
			addi $8, $8, -448
			j loopzaoDesenharObstaculos

fim:
	addi $2, $0, 10
	syscall
				
#####################################################################################
# Função que desenha um quadrado do limite do mapa
# Sujos: $8, $9, $10, $11
# Saida: ---
blocosCinzas:
	addi $10, $0, 0   # Contador de colunas
	addi $11, $0, 8   # Limite de Colunas

loopDesenharBlocosCinzas:
	beq $10, $11, fimBlocosCinzas

	lui $9, 0x0031
	ori $9, $9, 0x3031   # Iniciando com a cor Cinza Escuro
	
	# Todos são pintados com a cor cinza Escuro
	sw $9, 0($8)       # 1
	sw $9, 32768($8)   # 1 - Copia fora do display
	sw $9, 512($8)     # 2
	sw $9, 33280($8)   # 2 - Copia fora do display
	sw $9, 1024($8)    # 3
	sw $9, 33792($8)   # 3 - Copia fora do display
	sw $9, 1536($8)    # 4
	sw $9, 34304($8)   # 4 - Copia fora do display
	sw $9, 2048($8)    # 5
	sw $9, 34816($8)   # 5 - Copia fora do display
	sw $9, 2560($8)    # 6
	sw $9, 35328($8)   # 6 - Copia fora do display
	sw $9, 3072($8)    # 7
	sw $9, 35840($8)   # 7 - Copia fora do display
	sw $9, 3584($8)    # 8
	sw $9, 36352($8)   # 8 - Copia fora do display
	
	addi $10, $10, 1  # Incrementa contador de colunas
	addi $8, $8, 4    # Proxima posição do vetor
	
	j loopDesenharBlocosCinzas
	
fimBlocosCinzas:
	jr $31