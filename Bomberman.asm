.text
main:
	li $8, 0x10030C00  # Posição da variavel do cenario
	sw $0, 0($8)  # Iniciando a variavel do cenario como 0 (Primeiro cenario)

cenariosDoJogo:
	# Posição da variavel do cenario 0x10020C00
	lw $8, 0($8)   # Pegando o valor do cenario
	
	bne $8, $0, SegundoCenario
	# Else: (Vai para o primeiro cenario)

	lui $8, 0x1001
	
	li $9, 0xFF6600FF

	lui $19, 0xAAAA       # 
	ori $19, $19, 0xFFFF  # Cor Azul Borda

	lui $11, 0xCCCC       # 
	ori $11, $11, 0xFFFF  # Cor Azul chao
	
	addi $12 $0 16 # Tamanho de quadrados da Linha
	addi $13 $0 16 # Tamanho de linhas
	addi $14 $0 15 # validador das bordas
	
	addi $15 $0 12 # saber se a linha ou coluna esta na 12
	add $16 $15 $0
	add $17 $15 $0
	addi $18 $0 8
	addi $8 $8 -3584 # Para começar na primeira linha
	
pintarTela:
	beq $13 $0 fimDoCenarioEstatico
	addi $13 $13 -1
	addi $12 $12 16
	addi $8 $8 3584
	j pintarLinha 

pintarLinha:	
	add $17 $15 $0
	beq $12 $0 pintarTela
	addi $10 $0 8
	addi $12 $12 -1
	j quadrado

quadrado:
	beq $10 $0 lateral
	beq $10 $18 primeiraColunaQuadrado
	sw $11, 0($8)       # 1
	sw $11, 512($8)     # 2
	sw $11, 1024($8)    # 3
	sw $11, 1536($8)    # 4
	sw $11, 2048($8)    # 5
	sw $11, 2560($8)    # 6
	sw $11, 3072($8)    # 7
	sw $19, 3584($8)    # 8
	addi $8 $8 4
	addi $10 $10 -1
	
	j quadrado

primeiraColunaQuadrado:
	sw $19, 0($8)       # 1
	sw $19, 512($8)     # 2
	sw $19, 1024($8)    # 3
	sw $19, 1536($8)    # 4
	sw $19, 2048($8)    # 5
	sw $19, 2560($8)    # 6
	sw $19, 3072($8)    # 7
	sw $19, 3584($8)    # 8
	addi $8 $8 4
	addi $10 $10 -1
	
	j quadrado

lateral:
	beq $13 $14 teste #Se for a primeira linha, pinta de cor diferente
	beq $13 $0 teste #Se for ultima linha, pinta de cor diferente
	beq $12 $14 teste # se for a primeira coluna, pinta de cor diferente
	beq $12 $0 teste
	addi $17 $0 12
	beq $13 $17 talvezObstaculo
	addi $17 $0 11
	beq $13 $17 talvezObstaculo
	addi $17 $0 8
	beq $13 $17 talvezObstaculo
	addi $17 $0 7
	beq $13 $17 talvezObstaculo
	addi $17 $0 4
	beq $13 $17 talvezObstaculo
	addi $17 $0 3
	beq $13 $17 talvezObstaculo
	j pintarLinha

talvezObstaculo:
	addi $16 $0 12
	beq $12 $15 teste
	addi $16 $0 11
	beq $12 $16 teste
	addi $16 $0 8
	beq $12 $16 teste
	addi $16 $0 7
	beq $12 $16 teste
	addi $16 $0 4
	beq $12 $16 teste
	addi $16 $0 3
	beq $12 $16 teste
	j pintarLinha

teste:
	addi $10 $10 8
	addi $8 $8 -32
	j lateral2
	
lateral2:

	beq $10 $0 pintarLinha
	sw $9, 0($8)       # 1
	sw $9, 512($8)     # 2
	sw $9, 1024($8)    # 3
	sw $9, 1536($8)    # 4
	sw $9, 2048($8)    # 5
	sw $9, 2560($8)    # 6
	sw $9, 3072($8)    # 7
	sw $9, 3584($8)    # 8
	addi $8 $8 4
	addi $10 $10 -1
	
	j lateral2
	
j fimDoCenarioEstatico

SegundoCenario:
	# Configuração inicial
	lui $8, 0x1001       # Endereço base do cenário (0x10010000)
    
	lui $9, 0x006C       # Verde claro (parte alta)
	ori $9, $9, 0xBF4C   # Verde claro (completo)
    
	addi $11, $0, 8      # Dimensão de um quadrado (8x8)
	addi $12, $0, 128    # Compimento da tela em pixels
	addi $13, $0, 0      # Contador de linhas
	addi $14, $0, 0      # Contador de colunas

	# Variáveis de controle
	addi $15, $0, 0      # Cor atual (0 para claro, 1 para escuro)
	addi $16, $0, 2048   # Total de Unidades gráficas (1 Unidade grafica = 4x4 pixels) (128 * 128)

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
	
pintar: # - OK
	sw $9, 0($8)       # 1
	sw $9, 512($8)     # 2
	sw $9, 1024($8)    # 3
	sw $9, 1536($8)    # 4
	sw $9, 2048($8)    # 5
	sw $9, 2560($8)    # 6
	sw $9, 3072($8)    # 7
	sw $9, 3584($8)    # 8
	
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
	addi $12, $0, 128    # Reinicia o comprimento da tela em unidaeds graficas
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
	addi $24, $0, 14   # Limites de blocos Verticais
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
###############################################################################################
contornoPretoDosBlocosLimites:
		lui $8, 0x1001       # Carrega os 16 bits superiores (0x1001) no registrador $8
		ori $8, $8, 0x0E20   # Combina os 16 bits inferiores (0x0E1C) com os já existentes em $8
		
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
	
		addi $10, $0, 0    # Contador de linhas
		addi $11, $0, 0    # Contador de colunas
		
		addi $25, $0, 112
		addi $24, $0, 114
		loopContornoHorizontal:
			beq $25, $0, loopContornoVertical
			addi $25, $25, -1
			# Cima
			sw $9, 0($8)
			#sw $9, 65536($8) # Copia fora do display
			# Baixo
			sw $9, 57856($8)
			#sw $9, 123392($8) # Copia fora do display
			
			addi $8, $8, 4  # Proxima posição do vetor
			j loopContornoHorizontal
	
		loopContornoVertical: # - OK
			beq $24, $0, obstaculos
			addi $24, $24, -1
			
			# Direita
			sw $9, 0($8)
			#sw $9, 65536($8) # Copia fora do display
			# Esquerda
			sw $9, -452($8)
			#sw $9, 65084($8) # Copia fora do display
			
			addi $8, $8, 512
			j loopContornoVertical
####################################################################################	

obstaculos:
	lui $8, 0x1001
	ori $8, $8, 0x0040
	addi $8, $8, 61472
	
	addi $12, $0, 0
	
	addi $24, $0, 3  # quantidade de linhas
	
	loopzaoDesenharObstaculos:
		beq $24, $0, fimDoCenarioEstatico
		
		addi $24, $24, -1
		addi $8, $8, -16384
		addi $25, $0, 3  # Limite de obstaculos em uma linha
		
		loopzinhoDesenharObstaculos:
			beq $25, $0, correcao
			addi $25, $25, -1
			jal blocosCinzas
			addi $8, $8, 64
			j loopzinhoDesenharObstaculos
		correcao:
			addi $8, $8, -384
			j loopzaoDesenharObstaculos
#####################################################################################
fimDoCenarioEstatico:
	jal copiaCenario # Chamada da função que cria uma copia do cenário fora do display

	jal iniciarVariaveisDosPersonagens

	lui $21, 0xffff   # não sei o que é, não sei para que serve, so sei que não sei assembly, e so funciona com isso.
loopPrincipal:
	lui $8, 0x1002    # Primeira posição do "array" para as variaveis
	lw $25, 0($8)     # Pegar ainformação de se esta ou não vivo
	beq $25, $0, telaGameOver   # verificar se o player morreu
	# Else (Player esta vivo):

	# Vereificar a vida dos Bots
	lw $24, 512($8)  # Bot Vermelho
	bne $24, $0, aindaNaoGanhou
	lw $24, 1024($8)  # Bot Amarelo
	bne $24, $0, aindaNaoGanhou
	lw $24, 1536($8)  # Bot Rosa
	bne $24, $0, aindaNaoGanhou

	# Else ganhou a fase
		li $8, 0x10030C00  # Posição da variavel do cenario
		lw $10, 0($8)  # Pegar a o valor do cenario
	
		beq $10, $0, proximaFase
	# Vc Ganhou !!!!!!!!!!!!!!!!
	jal telaYouWin
	
	proximaFase:
		addi $25, $0, 1
		sw $25, 0($8)  # Alterando a fase
		j cenariosDoJogo
	
aindaNaoGanhou:
	lw $8, 4($8)      # Conteudo do 4($8) (Posição)
	
	lw $22, 0($21)             # Lê o valor da tecla pressionada em $22 (endereço de teclas).
	beq $22, $0, fimAtualizarPosicaoDoPlayer # Se nenhuma tecla foi pressionada, pula para o próximo ciclo do loop.
	
	lw $23, 4($21)             # Lê o próximo valor, provavelmente para verificar se a tecla corresponde ao movimento.
	
	# Compara diretamente com os valores ASCII das teclas
	addi $24, $0, 'a'          # Carrega 'a' no $24
	beq $23, $24, esquerda
	addi $24, $0, 'd'          # Carrega 'd' no $24
	beq $23, $24, direita
	addi $24, $0, 's'          # Carrega 's' no $24
	beq $23, $24, baixo
	addi $24, $0, 'w'          # Carrega 'w' no $24
	beq $23, $24, cima
	addi $24, $0, ' '         # Carrega espaço (' ') no $24
 	beq $23, $24, salvarPosicaoBombaPlayer   # Verifica se a tecla espaço foi pressionada
	
	j fimAtualizarPosicaoDoPlayer            # Volta ao início do loop
	
	salvarPosicaoBombaPlayer:
		lui $9, 0x1002
		jal salvarPosicaoBomba
		
		j fimAtualizarPosicaoDoPlayer
	
	cima:
		lui $9, 0x0000
		ori $9, $9, 0x0000     # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		li $11, 0xFF6600FF     # Roxo
 
		
		lw $25, -512($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		lw $25, -480($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, -1024    # Movimentar para cima
		
		addi $9, $0, 1    # Nova Direção
		
		j fimAtualizarPosicaoDoPlayer
	baixo:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		li $11, 0xFF6600FF     # Roxo
		
		lw $25, 4096($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		lw $25, 4124($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, 1024    # Movimentar para baixo
		
		addi $9, $0, 3    # Nova Direção
		
		j fimAtualizarPosicaoDoPlayer
	esquerda:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		li $11, 0xFF6600FF     # Roxo
		
		lw $25, -4($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		lw $25, -4($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, -8    # Movimentar para a esquerda
		
		addi $9, $0, 4    # Nova Direção

		j fimAtualizarPosicaoDoPlayer
	direita:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		li $11, 0xFF6600FF     # Roxo
		
		lw $25, 32($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		lw $25, 3616($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		beq $25, $11, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, 8    # Movimentar para a direita
		
		addi $9, $0, 2    # Nova Direção

		j fimAtualizarPosicaoDoPlayer
	
	
	fimAtualizarPosicaoDoPlayer:
		# Atualiza movimento do personagem do player (Azul)
		move $25, $8
		lui $8, 0x1002    # Primeira posição do "array" para as variaveis
		sw $9, 8($8)     # atualizado a direção do BOT
		sw $25, 4($8)    # Atualiza a variavel da posição do player (AZUL)
		#move $8, $25   # Recupera a posição do personagem
		
	
	lui $8, 0x1002    # Primeira posição do "array" para as variaveis
	addi $8, $8, 4    # Ajustando para a coluna da posição
	
	
	########################## Movimentação dos BOTs #############################
	addi $24, $0, 3
	
	loopMovimentacaoBOTs: beq $24, $0, desenharTodosOsPersonagens
		addi $8, $8, 512    # Pular bot ou player
		addi $24, $24, -1   # Atualiza a quantidade de personagens que faltam se movimentar (VIVOS)
	
		# Verificar se esta vivo
		lw $25, -4($8)
		beq $25, $0, loopMovimentacaoBOTs   # O BOT esta MORTO
	
		lw $25, 12($8)           # Tempo Entre cada passo do personagem
		bne $25, $0, naoSeMexe
		# Else (Se o for a hora do personagem se mecher):
			addi $25, $0, 100
			sw $25, 12($8)   # Reinicia o tempo de cada passo
		
			lw $25, 16($8)   # Quantidade de passinhos que faltam para trocar de direção
			bne $25, $0, manterDirecao    # Ja foram dados 8 passinhos
			# Else
			addi $25, $0, 4
			sw $25, 16($8)   # Reinicia a quantidade de passinhos
		
			# 27% de chance de mudar a posição
			gerarValor:
				# Gerando numero aleatorio entre 1 e 11 (Inclusos)
				li $5, 9          # Definindo o limite superior (0 a 10)
				li $2, 42         # Syscall para gerar número aleatório
				syscall            # Executa o syscall, resultado em $a0 (0 a 3)
				addi $4, $4, 1   # Ajusta o intervalo para 1 a 11
			
				add $9, $0, $4  # Guardar direção gerada em $9
			
				lw $25, 4($8)
				beq $25, $9, manterDirecao
				
				addi $10, $0, 5
				slt $24, $9, $10  # Direção >= 5 = 0
				beq $24, $0, manterDirecao
				
				# Alterar direção
					sw $9, 4($8)
			
			manterDirecao:
				lw $11, 0($8)    # Conteudo do 0($8) (Posição do BOT)
				lw $9, 4($8)     # Pegando a direção atual
			
				# Verificar se direção é valida
				cimaBot:
					addi $25, $0, 1   # Verificar a direção Norte (1)
					bne $9, $25, direitaBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
					li $12, 0xFF6600FF     # Roxo
		
					lw $25, -512($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					lw $25, -480($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					# Else:
					addi $11, $11, -1024    # Movimentar para cima
					
					addi $9, $0, 1    # nova direção
				
					j atualizarPosicaoDoBOT
				direitaBot:
					addi $25, $0, 2   # Verificar a direção direita (2)
					bne $9, $25, baixoBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
					li $12, 0xFF6600FF     # Roxo
		
					lw $25, 32($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					lw $25, 3616($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					# Else:
					addi $11, $11, 8    # Movimentar para cima
					
					addi $9, $0, 2    # nova direção
				
					j atualizarPosicaoDoBOT
				baixoBot:
					addi $25, $0, 3   # Verificar a direção baixo
					bne $9, $25, esquerdaBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
					li $12, 0xFF6600FF     # Roxo
		
					lw $25, 4608($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					lw $25, 4636($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					# Else:
					addi $11, $11, 1024    # Movimentar para cima
					
					addi $9, $0, 3    # nova direção
				
					j atualizarPosicaoDoBOT
				esquerdaBot:
					#addi $25, $0, 4   # Verificar a direção esquerda (2)
					#bne $9, $25, baixoBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
					li $12, 0xFF6600FF     # Roxo
		
					lw $25, -4($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					lw $25, 3580($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
					beq $25, $12, gerarValor
		
					# Else:
					addi $11, $11, -8    # Movimentar para esquerda
					
					addi $9, $0, 4    # nova direção
			
				atualizarPosicaoDoBOT:		
					sw $11, 0($8)     # atualiza a posição do BOT
					sw $9, 8($8)     # atualizado a direção do BOT
				
					# Decrementar quantidade de passos faltantes
					lw $12, 16($8)
					addi $12, $12, -1
					sw $12, 16($8)
				
				j loopMovimentacaoBOTs
		naoSeMexe:
			addi $25, $25, -1
			sw $25, 12($8)   # atualiza o tempo de movimento
			j loopMovimentacaoBOTs


	desenharTodosOsPersonagens:
		desenharPlayer:
			lui $8, 0x1002    # Primeira posição do "array" para as variaveis
			addi $8, $8, 4    # Coluna da posição
			lw $10, -4($8)   # Vida
			lw $8, 0($8)
			lui $9, 0x0061       # Carrega 0x1001 nos 16 bits superiores de $8
			ori $9, $9, 0xB4EC   # Adiciona 0x1020 aos 16 bits inferiores de $8
			jal desenharPersonagem
			
			lui $8, 0x1002
			lw $9, 8($8)    # Direção
			lw $8, 4($8)    # Posiç~ao do personagem
			jal apagarRastros
		
		desenharBotVermelho:
			lui $8, 0x1002    # Primeira posição do "array" para as variaveis
			lw $25, 0($8)     # Verifica se esta vivo | VIVO = 1  | MORTO = 0
			beq $25, $0, desenharBotAmarelo
			addi $8, $8, 4    # Coluna da posição
			addi $8, $8, 512
			lw $10, -4($8)   # Vida
			lw $8, 0($8)
			lui $9, 0x00FA       # Carrega 0x1001 nos 16 bits superiores de $8
			ori $9, $9, 0x292A   # Adiciona 0x1020 aos 16 bits inferiores de $8
			jal desenharPersonagem
			
			lui $8, 0x1002
			addi $8, $8, 512
			lw $9, 8($8)    # Direção
			lw $8, 4($8)    # Posiç~ao do personagem
			jal apagarRastros
	
		desenharBotAmarelo:
			lui $8, 0x1002    # Primeira posição do "array" para as variaveis
			lw $25, 0($8)     # Verifica se esta vivo | VIVO = 1  | MORTO = 0
			beq $25, $0, desenharBotRosa
			addi $8, $8, 4    # Coluna da posição
			addi $8, $8, 512
			addi $8, $8, 512
			lw $10, -4($8)   # Vida
			lw $8, 0($8)
			lui $9, 0x00F9       # Carrega 0x1001 nos 16 bits superiores de $8
			ori $9, $9, 0xFE1D   # Adiciona 0x1020 aos 16 bits inferiores de $8
			jal desenharPersonagem
			
			lui $8, 0x1002
			addi $8, $8, 1024
			lw $9, 8($8)    # Direção
			lw $8, 4($8)    # Posiç~ao do personagem
			jal apagarRastros
		
		desenharBotRosa:
			lui $8, 0x1002    # Primeira posição do "array" para as variaveis
			lw $25, 0($8)     # Verifica se esta vivo | VIVO = 1  | MORTO = 0
			beq $25, $0, verificarInimigoSoltarBomba
			addi $8, $8, 4    # Coluna da posição
			addi $8, $8, 512
			addi $8, $8, 512
			addi $8, $8, 512
			lw $10, -4($8)   # Vida
			lw $8, 0($8)
			lui $9, 0x00F7       # Carrega 0x1001 nos 16 bits superiores de $8
			ori $9, $9, 0x72A5   # Adiciona 0x1020 aos 16 bits inferiores de $8
			jal desenharPersonagem
			
			lui $8, 0x1002
			addi $8, $8, 1536
			lw $9, 8($8)    # Direção
			lw $8, 4($8)    # Posiç~ao do personagem
			jal apagarRastros
	
	
	########################## Ataque dos bots (Bombas) #############################
	verificarInimigoSoltarBomba:
		addi $24, $0, 3   # Contador de inimigos
		
		lui $9, 0x1002   # Array
		addi $9, $9, 512   # Pular o player
		
		loopVerificarInimigoSoltarBomba: beq $24, $0, fimVerificarInimigoSoltarBomba
			add $23, $0, $9   # Copia do $9
			
			lw $25, 0($9)   # Vida do Persnagem
			beq $25, $0, reiniciarLoop
		
			lw $8, 4($9)   # Pegar a posição do boneco
			lw $9, 8($9)   # Pegar a direção
			
			addi $25, $0, 1
			beq $9, $25, verificarCima
			addi $25, $0, 2
			beq $9, $25, verificarDireita
			addi $25, $0, 3
			beq $9, $25, verificarBaixo
			addi $25, $0, 4
			beq $9, $25, verificarEsquerda
		
			
				verificarCima:  # OK
					lw $25, -3060($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, -1524($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, -2028($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					j reiniciarLoop
					
				verificarDireita:  # OK
					lw $25, 1076($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, 1064($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, 2092($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					j reiniciarLoop
					
				verificarBaixo:  # OK
					lw $25, 6668($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, 8204($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, 7700($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					j reiniciarLoop
					
				verificarEsquerda:  # OK
					lw $25, 1512($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, 1524($8)
					jal verificarProximidadeDeInimigos
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					lw $25, 3060($8)
					jal verificarProximidadeDeInimigos	
					addi $15, $0, 404
					beq $10, $15, detectado   # o $10 Retorno o 404, se o inimigo foi detectado
					
					j reiniciarLoop
				
			detectado:
				add $9, $0, $23  # ecuperando valor do $9
				jal salvarPosicaoBomba
					
			reiniciarLoop:
				add $9, $0, $23  # ecuperando valor do $9
				addi $9, $9, 512  # Proximo BOT
				addi $24, $24, -1
				j loopVerificarInimigoSoltarBomba
					
	
	
fimVerificarInimigoSoltarBomba:
	addi $15, $0, 4
	lui $11, 0x1002
	loopDesenharTodasAsBombas: beq $15, $0, fimDesenharBombas
		bomba1:
			lw $8, 24($11)  # posição da bomba
			lw $10, 28($11)  # timer da bomba 1
			beq $8, $0, bomba2   # Verificar se a bomba 1 exist
			
			jal desenharBomba
			
			addi $10, $10, -1
			sw $10, 28($11)    #  Atualiza o timer da bomba 1
			
			bne $10, $0, bomba2
			# Else: (Se o contador chegar a 0, reinicia variaveis da bomba 1)
				sw $0, 24($11)  # Limpa a posição da bomba
				addi $24, $0, 4500   # reinicia o timer da bomba 
				sw $24, 28($11)  # timer da bomba 1
		bomba2:
			lw $8, 32($11)  # posição da bomba
			lw $10, 36($11)  # timer da bomba 2
			beq $8, $0, atualizarVariaveis  # Verificar se a bomba 1 existe
			
			jal desenharBomba
			
			addi $10, $10, -1
			sw $10, 36($11)    #  Atualiza o timer da bomba 2
			
			bne $10, $0, atualizarVariaveis
			# Else: (Se o contador chegar a 0, reinicia variaveis da bomba 2)
				sw $0, 32($11)  # Limpa a posição da bomba
				addi $24, $0, 4500      # reinicia o timer da bomba 
				sw $24, 36($11)  # timer da bomba 1
		atualizarVariaveis:
			addi $11, $11, 512   # Pula para o proximo personagem
			addi $15, $15, -1    # Decrementa a qunatidade de personagens que faltam desenhar as bombas
			j loopDesenharTodasAsBombas
			
			
	
	fimDesenharBombas:
		addi $24, $0, 4
		lui $8, 0x1002
		addi $8, $8, 4   # Ajustar para a coluna da posição
		
		loopVerificarSePersonagemFoiAtingido: beq $24, $0, fimLoopVerificarSePersonagemFoiAtingido
			add $15, $0, $8 # Cria uma copia do endereço do personegem
			
			lw $8, 0($8)    # Coloca no registrador $8 a posição do personagem
			
			jal verificarSeFoiAtingidoPelaExplosao
			
			add $8, $0, $15   # Recupera endereço do personagem
			addi $8, $8, 512  # Proximo personagem
			addi $24, $24, -1  # Atualiza a quantidade de personagens que devem ser verificados
		
			j loopVerificarSePersonagemFoiAtingido
			
	fimLoopVerificarSePersonagemFoiAtingido:
	
	j loopPrincipal
	
fim:
	addi $2, $0, 10
	syscall

######################################################################################
################################## Area das Funções ##################################
######################################################################################

######################################################################################
# Função que desenha um quadrado do limite do mapa
# Sujos: $8, $9, $10, $11
# Saida: ---
blocosCinzas:
	addi $10, $0, 0   # Contador de colunas
	addi $11, $0, 8   # Limite de Colunas
	bne $12, $0, loopDesenharBlocosCinzas
	addi $11, $0, 16

loopDesenharBlocosCinzas:
	beq $10, $11, fimBlocosCinzas

	lui $9, 0x0031
	ori $9, $9, 0x3031   # Iniciando com a cor Cinza Escuro
	
	# Todos são pintados com a cor cinza Escuro
	sw $9, 0($8)       # 1
	sw $9, 512($8)     # 2
	sw $9, 1024($8)    # 3
	sw $9, 1536($8)    # 4
	sw $9, 2048($8)    # 5
	sw $9, 2560($8)    # 6
	sw $9, 3072($8)    # 7
	sw $9, 3584($8)    # 8
	
	bne $12, $0, pro8poo8
	
	sw $9, 4096($8)    # 1
	sw $9, 4608($8)    # 2
	sw $9, 5120($8)    # 3
	sw $9, 5632($8)    # 4
	sw $9, 6144($8)    # 5
	sw $9, 6656($8)    # 6
	sw $9, 7168($8)    # 7
	sw $9, 7680($8)    # 8
	
pro8poo8:
	addi $10, $10, 1  # Incrementa contador de colunas
	addi $8, $8, 4    # Proxima posição do vetor
	
	j loopDesenharBlocosCinzas
	
fimBlocosCinzas:
	jr $31

#####################################################################################
# Função armazena uma copia do cenário fora do display (Area visivel)
# Sujos: $8, $9, $10, $25
# Saida: ---

copiaCenario:
	# Reiniciando Variáveis de controle
	lui $8, 0x1001    # Primeira posição do vetor
	addi $10, $0, 16384
	loopCopiaCenario:
		beq $10, $0, fimCopiaCenario
		addi $10, $10, -1
		
		lw $25, 0($8)      # Copia a cor para o registrador $25
		sw $25, 65536($8)  # Cola no correspondente fora do display
		addi $8, $8, 4     # Proximo registrador
		j loopCopiaCenario
	fimCopiaCenario:
		jr $31

#####################################################################################
# Função que desenha o personagem
# Sujos: $8, $9
# Saida: ---

desenharPersonagem:
	###### Lembrete: Ajustar a posição no $8 antes de chamar a função
	###### Colocar a cor no $9 antes de chamar a função

	
	### Azul (Barriguinha e pezinhos)
	# Barriguinha
	sw $9, 2052($8)
	sw $9, 2564($8)
	sw $9, 2056($8)
	sw $9, 2568($8)
	sw $9, 2060($8)
	sw $9, 2572($8)
	sw $9, 2064($8)
	sw $9, 2576($8) 
	sw $9, 2068($8)
	sw $9, 2580($8)
	sw $9, 2072($8)
	sw $9, 2584($8)
	# Pezinhos
	sw $9, 3588($8)
	sw $9, 3592($8)
	sw $9, 3604($8)
	sw $9, 3608($8)
	
	### Preto (Cabelo e olhos)
	lui $9, 0x0000
	ori $9, $9, 0x0004
	sw $9, 8($8)
	sw $9, 12($8)
	sw $9, 16($8)
	sw $9, 20($8)
	sw $9, 520($8)
	sw $9, 1036($8)
	sw $9, 1044($8)
	
	### Cor de pele (Rosto e bracinhos)
	lui $9, 0x00F2
	ori $9, $9, 0xA862
	# Rosto
	sw $9, 516($8)
	sw $9, 524($8)
	sw $9, 528($8)
	sw $9, 532($8)
	sw $9, 1028($8)
	sw $9, 1032($8)
	sw $9, 1040($8)
	sw $9, 1544($8)
	sw $9, 1548($8)
	sw $9, 1552($8)
	sw $9, 1556($8)
	# Bracinho Esquerdo
	sw $9, 2048($8)
	sw $9, 2560($8)
	# Bracinho Direito
	sw $9, 2076($8)
	sw $9, 2588($8)
	
	### Branco (Meias)
	lui $9, 0x00FF
	ori $9, $9, 0xFFFF
	sw $9, 3080($8)
	sw $9, 3092($8)
	
	bne $10, $0, taVivo
	# Se tiver morto
	lui $9, 0x00FA
	ori $9, $9, 0x292A   # Vermelho do sangue
		# Buchinho
		sw $9, 2052($8)
		sw $9, 2564($8)
		sw $9, 2572($8)
		sw $9, 2064($8)
		sw $9, 2576($8) 
		sw $9, 2580($8)
		
		# Cabelo e olhos
		ori $9, $9, 0x0004
		sw $9, 8($8)
		sw $9, 12($8)
		sw $9, 20($8)
		sw $9, 520($8)
		
		# Bracinho Esquerdo
		sw $9, 2560($8)
		# Bracinho Direito
		sw $9, 2076($8)
		
		sw $9, 516($8)
		sw $9, 524($8)
		sw $9, 528($8)
		sw $9, 532($8)
		sw $9, 1040($8)
		sw $9, 1544($8)
		
	taVivo:
		jr $31
	

#####################################################################################
# Função que desenha o personagem
# Sujos: $8, $9,$25
# Saida: ---

iniciarVariaveisDosPersonagens:
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	
	addi $25, $0, 1  # Vida
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	addi $8, $8, 4    # Posição
	# Posição - AZUL (Player)
	lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $8
	ori $9, $9, 0x1020   # Adiciona 0x1020 aos 16 bits inferiores de $8
	sw $9, 0($8)   # Posição do player registrada
	# Posição - VERMELHO
	lui $9, 0x1001       # Carrega os 16 bits superiores: 0x10010000
	ori $9, $9, 0x11C0   # Adiciona os 16 bits inferiores: 0x11C0
	sw $9, 512($8)   # Posição do bot vermelho registrada
	# Posição - AMARELO
	lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $9
	ori $9, $9, 0xE1C0   # Adiciona 0xE1C0 aos 16 bits inferiores de $9
	sw $9, 1024($8)   # Posição do bot Amarelo registrada
	# Posição - ROSA
	lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $9
	ori $9, $9, 0xE020   # Adiciona 0xE020 aos 16 bits inferiores de $9
	sw $9, 1536($8)   # Posição do bot rosa registrada
		
	addi $8, $8, 4    # Direção
	# Cima = 1 \ Direita = 2 \ Baixo = 3 \ Esquerda = 4
	addi $25, $0, 2
	sw $25, 0($8)     # Azul
	sw $25, 1536($8)  # Rosa
	addi $25, $0, 4
	sw $25, 512($8)   # Vermelho
	sw $25, 1024($8)  # Amarlo
	
	addi $8, $8, 4    # Quantidade de bombas disponiveis (Começa com 2)
	addi $25, $0, 2  # Bombas
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	addi $8, $8, 4 
	# OBS: atualiar a linha 309 se modificar o tempo de movimentação
	addi $25, $0, 100   # Tempo de movimentação
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	addi $8, $8, 4
	addi $25, $0, 4  # Limite de Passos
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	# BOMBA 1
	addi $8, $8, 4   # Posição da bomba 1
	addi $25, $0, 0  # Posição inicial é 0
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	addi $8, $8, 4   # Timer da bomba 1
	addi $25, $0, 4500  # Tempo inicial é 1000 iteraç~oes
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	# BOMBA 2
	addi $8, $8, 4   # Posição da bomba 2
	addi $25, $0, 0  # Posição inicial é 0
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	addi $8, $8, 4   # Timer da bomba 2
	addi $25, $0, 4500  # Tempo inicial é 1000 iteraç~oes
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	jr $31

#####################################################################################
# Função que apaga os rastros dos personagens
# Sujos: $8, $9
# Saida: ---
# $8: Contem a osição do personagem
# $9: Tera a direção atual do personagem (1: Norte, 2: Leste, 3: sul, 4: Oeste)

apagarRastros:
	add $25, $0, $8    # Coia do registrador $8

	addi $25, $0, 1    # Cima
	beq $9, $25, apagarBaixo       # OK
	addi $25, $0, 2    # Direita
	beq $9, $25, apagarEsquerda    # OK
	addi $25, $0, 3    # Baixo
	beq $9, $25, apagarCima        # OK
	addi $25, $0, 4    # Esquerda
	beq $9, $25, apagarDireita     # OK
	
	apagarBaixo:
		addi $8, $8, 536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -12
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -12
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1028
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 16
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 516
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		j rastrosApagados	
	apagarEsquerda:
		addi $8, $8, 2040
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1028
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -508
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -3580
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1544
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		j rastrosApagados	
	apagarDireita:
		add $25, $0, $8   # gambiarra
		addi $8, $8, 2084
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel	
		addi $8, $8, -2052
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -3588
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -3588
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1528
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		add $8, $0, $25
		addi $8, $8, 536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		j rastrosApagados
	apagarCima:
		addi $8, $8, 1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 2064
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 4
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, -512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		j rastrosApagados
	rastrosApagados:
		add $8, $0, $25   # Recuperando posição
		jr $31

#####################################################################################
# Função que desenha a bomba de acordo com o seu estado
# Sujos: $8, $9, $10, $24, $25
# Saida: ---
# $8: ira conter a posição da bomba
# $9: Contera a cor
# $10: contem o timer da bomba
# $24: Armazena o resultado do slt

##### NÃO ALTERAR O VALOR DO $11

desenharBomba:	
	#### OBS: O timer da bomba no momento é de 4500 iterações
	
	# Estado 1: Bomba
	addi $25, $0, 500   # Se diminuir, aumenta o tempo da explosão
	slt $24, $10, $25  # timer >= 500 = 0
	beq $24, $0, desenharBombaInativa
	
	# Transição entre bomba inativa e explosão
	addi $25, $25, -1
	beq $10, $25, apagarBomba
	
	# Estado 2: Explosão
	addi $25, $0, 2
	slt $24, $10, $25  # timer >= 2 = 0
	beq $24, $0, desenharExplosao
	
	# Transição entre bomba inativa e explosão
	addi $25, $0, 1
	beq $10, $25, apagarExplosao
	
	
	desenharBombaInativa:
		# laranja pavil
		li $9 0xFFA500
		sw $9 16($8)
	
		#amarelo pavil
		li $9 0xFFFF00
		sw $9 524($8)
	
		# branco pavil
		li $9 0xffffff
		sw $9 1036($8)
	
		# Azul da  bomba
		lui $9, 0x001F       # Carrega 0x1001 nos 16 bits superiores de $8
		ori $9, $9, 0x3B58   # Adiciona 0x1020 aos 16 bits inferiores de $8
	
		sw $9 1032($8)
		sw $9 1040($8)
		sw $9 1032($8)
		sw $9 1540($8)
		sw $9 1544($8)
		sw $9 1548($8)
		sw $9 1552($8)
		sw $9 1556($8)
		sw $9 2052($8)
		sw $9 2056($8)
		sw $9 2060($8)
		sw $9 2064($8)
		sw $9 2068($8)
		sw $9 2564($8)
		sw $9 2568($8)
		sw $9 2572($8)
		sw $9 2576($8)
		sw $9 2580($8)
		sw $9 3080($8)
		sw $9 3084($8)
		sw $9 3088($8)
		
		j fimDesenharBomba
	
	apagarBomba:
		add $25, $0, $8   # Copia da posição da bomba
	
		addi $8, $8, 4 # Coluna 2
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		add $8, $0, $25
		addi $8, $8, 8 # Coluna 3
		addi $8, $8, 1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		add $8, $0, $25
		addi $8, $8, 12 # Coluna 4		
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		add $8, $0, $25
		addi $8, $8, 16 # Coluna 5
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 1024
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		
		add $8, $0, $25
		addi $8, $8, 20 # Coluna 7
		addi $8, $8, 1536
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
		addi $8, $8, 512
		lw $24, 65536($8)   # Pegar cor da copia não visivel
		sw $24, 0($8)       # Colar no cenario visivel
	
		j fimDesenharBomba
	
	desenharExplosao:
		add $25, $0, $8
		addi $24, $0, 24
		addi $8, $8, 1504   # Ajustando a posição
		lui $9, 0x00FD
		ori $9, $9, 0x471C 

		loopExplosaoHorizontal: beq $24, $0, atualizarVariaveisExplosao
			sw $9, 0($8)
			sw $9, 512($8)

			addi $8, $8, 4
			addi $24, $24, -1
			
			j loopExplosaoHorizontal
		
			atualizarVariaveisExplosao:
				add $8, $0, $25
				addi $24, $0, 24
				addi $8, $8, -4084   # Ajustando a posição
			
		loopExplosaoVertical: beq $24, $0, fimDesenharBomba
			sw $9, 0($8)
			sw $9, 4($8)
			
			addi $8, $8, 512
			addi $24, $24, -1
			
			j loopExplosaoVertical
		
		j fimDesenharBomba
		
	apagarExplosao:
		add $25, $0, $8
		addi $24, $0, 24
		addi $8, $8, 1504   # Ajustando a posição

		loopApagarExplosaoHorizontal: beq $24, $0, atualizarVariaveisApagarExplosao
			lw $9, 65536($8)   # Pegar cor da copia não visivel
			sw $9, 0($8)       # Colar no cenario visivel
			
			addi $8, $8, 512
			lw $9, 65536($8)   # Pegar cor da copia não visivel
			sw $9, 0($8)       # Colar no cenario visivel
			
			addi $8, $8, -512

			addi $8, $8, 4
			addi $24, $24, -1
			
			j loopApagarExplosaoHorizontal
		
			atualizarVariaveisApagarExplosao:
				add $8, $0, $25
				addi $24, $0, 24
				addi $8, $8, -4084   # Ajustando a posição
			
		loopApagarExplosaoVertical: beq $24, $0, fimDesenharBomba
			lw $9, 65536($8)   # Pegar cor da copia não visivel
			sw $9, 0($8)       # Colar no cenario visivel
			
			addi $8, $8, 4
			lw $9, 65536($8)   # Pegar cor da copia não visivel
			sw $9, 0($8)       # Colar no cenario visivel
			
			addi $8, $8, -4

			addi $8, $8, 512
			addi $24, $24, -1
			
			j loopApagarExplosaoVertical
		
		j fimDesenharBomba
		
	fimDesenharBomba:
		jr $31


#####################################################################################
# Função que coloca a posiç~o da bomba
# Sujos: $9, $25
# Saida: ---
# $9: Sera o ponteiro para o array 

salvarPosicaoBomba:
	posicaoBomba1:
		lw $25, 24($9)
		bne $25, $0, posicaoBomba2 # Verificar bomba 1, se ja tiver bomba ativa, verifica a segunda bomba
		# Else: (se não tiver a bomba 1, coloca uma bomba)
			lw $25, 4($9)   # Pega a posição do personagem
			sw $25, 24($9) # salvando a posição da bomba
				
			j fimSalvarPosicaoBomba
			
	posicaoBomba2:
		lw $25, 32($9)
		bne $25, $0, fimSalvarPosicaoBomba # Verificar bomba 2
		# Else: (se não tiver a bomba 2, coloca uma bomba)
			lw $25, 4($9)   # Pega a posição do personagem
			sw $25, 32($9) # salvando a posição da bomba
				
			j fimSalvarPosicaoBomba
		
	fimSalvarPosicaoBomba:
		jr $31    # encerra a função


#####################################################################################
# Função queverifica se tem algum personagem proximo
# Sujos: $9, $10, $25
# Saida: $10
# $9: Sera o ponteiro para o array 
# $25: Contem a cor da unidade grafica

verificarProximidadeDeInimigos:
	# Azul
	lui $9, 0x0061 
	ori $9, $9, 0xB4E	
	beq $25, $9, inimigoDetectado

	# Vermelho
	lui $9, 0x00FA 
	ori $9, $9, 0x292A	
	beq $25, $9, inimigoDetectado

	# Amarelo
	lui $9, 0x00F9 
	ori $9, $9, 0xFE1D	
	beq $25, $9, inimigoDetectado

	# Rosa
	lui $9, 0x00F7 
	ori $9, $9, 0x72A5	
	beq $25, $9, inimigoDetectado

	# Cor de pele
	lui $9, 0x00F2
	ori $9, $9, 0xA862	
	beq $25, $9, inimigoDetectado

	# Preto (Cabelo e olhos)
	lui $9, 0x0000
	ori $9, $9, 0x0004
	beq $25, $9, inimigoDetectado
	
	j semInimigo
	
	inimigoDetectado:
		addi $10, $0, 404   # Inimigo detectado
		jr $31
		
	semInimigo:
		addi $10, $0, 200   # Nenhum inimigo detectado
		jr $31

#####################################################################################
# Função que verifica se o personagem foi atingdo pela explosão da bomba
# Sujos: $8, $9, $10, $25
# Saida: ---
# $8: Posição dp Personagem
# $9, Cor da explosão
# $10: Cor da area que sera verificada

verificarSeFoiAtingidoPelaExplosao:
	# Laranja (Explosão)
	lui $9, 0x00FD
	ori $9, $9, 0x471C
	
	# Cabelo
	lw $25, 8($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 12($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 16($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 20($8)
	beq $9, $25, foiAtingidoDeveMorrer
	
	# Nuca
	lw $25, 516($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 1028($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 1544($8)
	beq $9, $25, foiAtingidoDeveMorrer

	# Rostinho
	lw $25, 532($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 1044($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 1556($8)
	beq $9, $25, foiAtingidoDeveMorrer
	
	# Bracinhos
	lw $25, 2048($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 2076($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 2560($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 2588($8)
	beq $9, $25, foiAtingidoDeveMorrer
	
	# Ovinhos
	lw $25, 2572($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 2576($8)
	beq $9, $25, foiAtingidoDeveMorrer
	
	# Peizinhos
	lw $25, 3588($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 3592($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 3604($8)
	beq $9, $25, foiAtingidoDeveMorrer
	lw $25, 3608($8)
	beq $9, $25, foiAtingidoDeveMorrer
	
	
	j olhaComoEleTaDeBoa
	
	foiAtingidoDeveMorrer:
		add $8, $0, $15  # recuperar posição do personagem
		addi $25, $0, 0
		sw $25, -4($8)   # Atualizando status de vida
	
	olhaComoEleTaDeBoa:
		jr $31
	
#####################################################################################
# Função que desenha game over na tela

telaGameOver:
	lui $8 0x1001
	li $9 0xFF5733
	
	addi $8 $8 20544
	
	lui $25 0x1002
	sw $8 0($25)
	
	addi $10 $0 15
	
	loopVerticalG:
	beq $10 $0 sairLoopVerticalG
	sw $9 0($8)
	addi $8 $8 512
	addi $10 $10 -1
	j loopVerticalG
	
	sairLoopVerticalG:
		addi $10 $0 15
		loopHorizontalGBaixo:
			beq $10 $0 sairLoopHorizontalGBaixo
			sw $9 0($8)
			addi $8 $8 4
			addi $10 $10 -1
			j loopHorizontalGBaixo
	
	sairLoopHorizontalGBaixo:
		
	 	addi $10 $0 6
		loopVerticalGBaixo:
			beq $10 $0 sairLoopVerticalGBaixo
			sw $9 0($8)
			addi $8 $8 -512
			addi $10 $10 -1
			j loopVerticalGBaixo
	
	
	sairLoopVerticalGBaixo:
	
	 	addi $10 $0 6
		loophorizontalGMeio:
			beq $10 $0 sairLoopHorizontalGMeio
			sw $9 0($8)
			addi $8 $8 -4
			addi $10 $10 -1
			j loophorizontalGMeio		
	
	
	sairLoopHorizontalGMeio:
		lui $8 0x1001
		addi $8 $8 20544
		addi $10 $0 15
		loopHorizontalGCima:
			beq $10 $0 sairLoopHorizontalGCima
			sw $9 0($8)
			addi $8 $8 4
			addi $10 $10 -1
			j loopHorizontalGCima
			
	sairLoopHorizontalGCima:
		lui $8 0x1001
		addi $8 $8 20640
		addi $10 $0 16
		loopVerticalA:
			beq $10 $0 sairLoopVerticalA
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalA
		
		
	sairLoopVerticalA:
		lui $8 0x1001
		addi $8 $8 20640
		addi $10 $0 15
		loopHorizontalACima:
			beq $10 $0 sairLoopHorizontalACima
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalACima
		
	sairLoopHorizontalACima:
		addi $11 $8 0
		addi $10 $0 16
		loopVerticalADireita:
			beq $10 $0 sairLoopVerticalADireita
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalADireita
	 		
	sairLoopVerticalADireita:
		
		lui $8 0x1001
		addi $8 $8 24736
		addi $10 $0 16
		loopHorizontalAmeio:
			beq $10 $0 sairLoopHorizontalAMeio
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalAmeio
	 		
	 sairLoopHorizontalAMeio:
	 	lui $8 0x1001
		addi $8 $11 32 
		addi $10 $0 16
		loopVerticalM:
			beq $10 $0 sairloopVerticalM
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalM
	 		
	 sairloopVerticalM:
	 	lui $8 0x1001
		addi $8 $11 32 
		addi $10 $0 16
		loopHorizontalM:
			beq $10 $0 sairloopHorizontalM
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalM
	 		
	 sairloopHorizontalM:
	 	addi $12 $8 0
		addi $10 $0 16
		loopVerticalMDireita:
			beq $10 $0 sairloopVerticalMDireita
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalMDireita
	 		
	 sairloopVerticalMDireita:
	 	
	 	lui $8 0x1001
		addi $8 $11 64 
		addi $10 $0 16
		loopVerticalMMeio:
			beq $10 $0 sairloopVerticalMMeio
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalMMeio
	 		
	 sairloopVerticalMMeio:
		addi $8 $12 32 
		addi $10 $0 16
		loopVerticalE:
			beq $10 $0 sairloopVerticalE
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalE
	 		
	 sairloopVerticalE:
	 	addi $13 $8 0
		addi $8 $12 32 
		addi $10 $0 16
		loopHorirzontalECima:
			beq $10 $0 sairloopHorirzontalECima
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorirzontalECima
	
	sairloopHorirzontalECima:
		addi $8 $12 4128
		addi $10 $0 16
		loopHorirzontalEMeio:
			beq $10 $0 sairloopHorirzontalEMeio
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorirzontalEMeio
	 		
	 sairloopHorirzontalEMeio:
		addi $8 $13 0
		addi $10 $0 16
		loopHorirzontalEBaixo:
			beq $10 $0 sairloopHorirzontalEBaixo
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorirzontalEBaixo
	 		
	 sairloopHorirzontalEBaixo:
	 
	# come� Over
		lw $8 0($25)
		addi $8 $8 12288
		sw $8 4($25)
		addi $10 $0 16
		loopVerticalOEsquerdo:
			beq $10 $0 sairloopVerticalOEsquerdo
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalOEsquerdo	
	 
	 sairloopVerticalOEsquerdo:
		addi $10 $0 16
		loopHorirzontalOCima:
			beq $10 $0 sairloopHorirzontalOCima
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorirzontalOCima		 
	 	
	 sairloopHorirzontalOCima:
		addi $10 $0 16
		loopHorirzontalOBaixo:
			beq $10 $0 sairloopHorirzontalOBaixo
	 		sw $9 0($8)
	 		addi $8 $8 -512
	 		addi $10 $10 -1
	 		j loopHorirzontalOBaixo		 
	 	
	 sairloopHorirzontalOBaixo:
		addi $10 $0 16
		loopHorizontalOCima:
			beq $10 $0 sairloopHorizontalOCima
	 		sw $9 0($8)
	 		addi $8 $8 -4
	 		addi $10 $10 -1
	 		j loopHorizontalOCima
	 		
	 sairloopHorizontalOCima:
	 	lw $8 4($25)
	 	addi $8 $8 96
		addi $10 $0 16
		loopVerticalVCima:
			beq $10 $0 sairloopVerticalVCima
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalVCima
	 		
	 sairloopVerticalVCima:
	 	 
		addi $10 $0 16
		loopVerticalVDireita:
			beq $10 $0 sairloopVerticalVDireita
	 		sw $9 0($8)
	 		addi $8 $8 -508
	 		addi $10 $10 -1
	 		j loopVerticalVDireita
	 		
	 sairloopVerticalVDireita:

	 	addi $8 $8 28
		addi $10 $0 16
		loopVerticalEOver:
			beq $10 $0 sairloopVerticalEOver
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalEOver
	 		
	 sairloopVerticalEOver:
	 	sw $8 8($25)
		addi $10 $0 16
		loopHorizontalEOverBaixo:
			beq $10 $0 sairloopHorizontalEOverBaixo
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalEOverBaixo
	 		
	 sairloopHorizontalEOverBaixo:
	 	lw $8 8($25)
	 	addi $8 $8 -4096
		addi $10 $0 16
		loopHorizontalEOverMeio:
			beq $10 $0 sairloopHorizontalEOverMeio
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalEOverMeio
	 		
	 sairloopHorizontalEOverMeio:
	 	lw $8 8($25)
	 	addi $8 $8 -8192
		addi $10 $0 16
		loopHorizontalEOverCima:
			beq $10 $0 sairloopHorizontalEOverCima
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalEOverCima
	 		
	 sairloopHorizontalEOverCima:
	 	
	 	addi $8 $8 32
		sw $8 12($25)
		addi $10 $0 18
		loopVerticalROver:
			beq $10 $0 sairloopVerticalROver
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalROver
	 		
	 sairloopVerticalROver:
	 	
		lw $8 12($25)
		addi $10 $0 10
		loopHorizontalROver:
			beq $10 $0 sairloopHorizontalROver
	 		sw $9 0($8)
	 		addi $8 $8 4
	 		addi $10 $10 -1
	 		j loopHorizontalROver
	 		
	 sairloopHorizontalROver:
		addi $10 $0 8
		loopVerticalROverDireita:
			beq $10 $0 sairloopVerticalROverDireita
	 		sw $9 0($8)
	 		addi $8 $8 512
	 		addi $10 $10 -1
	 		j loopVerticalROverDireita
	 		
	 sairloopVerticalROverDireita:
		addi $10 $0 10
		loopHorizontalROverVolta:
			beq $10 $0 sairloopHorizontalROverVolta
	 		sw $9 0($8)
	 		addi $8 $8 -4
	 		addi $10 $10 -1
	 		j loopHorizontalROverVolta
	 			 
	 sairloopHorizontalROverVolta:
		addi $10 $0 10
		loopTortoROver:
			beq $10 $0 sairloopTortoROver
	 		sw $9 0($8)
	 		addi $8 $8 516
	 		addi $10 $10 -1
	 		j loopTortoROver
	 		
	 sairloopTortoROver:
	 	addi $2, $0, 10
		syscall
	 	jr $31
	 	
	 	
#####################################################################################
# Função que desenha you win na tela
telaYouWin:
		lui $8 0x1001
	li $9 0x0000FF
	
	addi $8 $8 20608
	lui $25 0x1002
	sw $8 8($25)
	
	addi $10 $0 8
	
	loopVerticalYEsquerdo:
		beq $10 $0 sairloopVerticalYEsquerdo
		sw $9 0($8)
		addi $8 $8 516
		addi $10 $10 -1
		j loopVerticalYEsquerdo
		
	sairloopVerticalYEsquerdo:
		sw $8 0($25)
		addi $10 $0 8
		loopVerticalY:
		beq $10 $0 sairloopVerticalY
		sw $9 0($8)
		addi $8 $8 512
		addi $10 $10 -1
		j loopVerticalY
	
	sairloopVerticalY:
		lw $8 0($25)
		addi $10 $0 8
		loopVerticalYDireito:
		beq $10 $0 sairloopVerticalYDireito
		sw $9 0($8)
		addi $8 $8 -508
		addi $10 $10 -1
		j loopVerticalYDireito
		
	sairloopVerticalYDireito:
		
		addi $8 $8 32
		addi $10 $0 16
				loopVerticalOEsquerdo_2:
		beq $10 $0 sairloopVerticalOEsquerdo_2
		sw $9 0($8)
		addi $8 $8 512
		addi $10 $10 -1
		j loopVerticalOEsquerdo_2
	
	sairloopVerticalOEsquerdo_2:

		addi $10 $0 16	
		loopHorizontalOEsquerdo:
		beq $10 $0 sairloopHorizontalOEsquerdo
		sw $9 0($8)
		addi $8 $8 4
		addi $10 $10 -1
		j loopHorizontalOEsquerdo
	
	sairloopHorizontalOEsquerdo:
		addi $10 $0 16	
		
		loopVerticalODireito:
		beq $10 $0 sairloopVerticalODireito
		sw $9 0($8)
		addi $8 $8 -512
		addi $10 $10 -1
		j loopVerticalODireito
		
	sairloopVerticalODireito:
		sw $8 4($25)
		addi $10 $0 16	
		loopHorizontalOVolta:
		beq $10 $0 sairloopHorizontalOVolta
		sw $9 0($8)
		addi $8 $8 -4
		addi $10 $10 -1
		j loopHorizontalOVolta
		
	sairloopHorizontalOVolta:
		lw $8 4($25)
		addi $8 $8 32
		addi $10 $0 16
		loopVerticalUEsquerdo:
		beq $10 $0 sairloopVerticalUEsquerdo
		sw $9 0($8)
		addi $8 $8 512
		addi $10 $10 -1
		j loopVerticalUEsquerdo
		
	sairloopVerticalUEsquerdo:
		
		addi $10 $0 16
		loopHU:
		beq $10 $0 sairloopHU
		sw $9 0($8)
		addi $8 $8 4
		addi $10 $10 -1
		j loopHU
		
	sairloopHU:
		addi $10 $0 16
		loopVU:
		beq $10 $0 sairloopVU
		sw $9 0($8)
		addi $8 $8 -512
		addi $10 $10 -1
		j loopVU
		
	sairloopVU:
	# começo win
		lw $8 8($25)
		addi $8 $8 16384
		addi $10 $0 8
		loopEsqW:
		beq $10 $0 sairloopEsqW
		sw $9 0($8)
		addi $8 $8 516
		addi $10 $10 -1
		j loopEsqW
		
	sairloopEsqW:
		addi $10 $0 8
		loop2W:
		beq $10 $0 sairloop2W
		sw $9 0($8)
		addi $8 $8 -508
		addi $10 $10 -1
		j loop2W
		
	sairloop2W:
		addi $10 $0 9
		loop3W:
		beq $10 $0 sairloop3W
		sw $9 0($8)
		addi $8 $8 516
		addi $10 $10 -1
		j loop3W
		
	sairloop3W:
		addi $10 $0 8
		loop4W:
		beq $10 $0 sairloop4W
		sw $9 0($8)
		addi $8 $8 -508
		addi $10 $10 -1
		j loop4W
		
	sairloop4W:
		addi $8 $8 32
		addi $10 $0 16
		loopI:
		beq $10 $0 sairloopI
		sw $9 0($8)
		addi $8 $8 512
		addi $10 $10 -1
		j loopI
		
	sairloopI:
		addi $8 $8 32
		addi $10 $0 16
		loopVN1:
		beq $10 $0 sairloopVN1
		sw $9 0($8)
		addi $8 $8 -512
		addi $10 $10 -1
		j loopVN1
		
	sairloopVN1:
		addi $10 $0 16
		loopVN2:
		beq $10 $0 sairloopVN2
		sw $9 0($8)
		addi $8 $8 516
		addi $10 $10 -1
		j loopVN2
		
	sairloopVN2:
		addi $10 $0 16
		loopVN3:
		beq $10 $0 sairloopVN3
		sw $9 0($8)
		addi $8 $8 -512
		addi $10 $10 -1
		j loopVN3
	
	sairloopVN3:
		addi $2, $0, 10
		syscall
	 	jr $31
