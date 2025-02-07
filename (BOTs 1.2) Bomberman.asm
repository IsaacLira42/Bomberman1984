.text
main:
	# Configuração inicial
	lui $8, 0x1001       # Endereço base do cenário (vetor gráfico)
    
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
	jal copiaCenario #Chamada da função que cria uma copia do cenário fora do display
	
	jal iniciarVariaveisDosPersonagens


	lui $21, 0xffff   # não sei o que é, não sei para que serve, so sei que não sei assembly, e so funciona com isso.
loopPrincipal:
	lui $8, 0x1002    # Primeira posição do "array" para as variaveis
	lw $25, 0($8)     # Pegar ainformação de se esta ou não vivo
	beq $25, $0, fim   # verificar se o player morreu
	# Else (Ta vivo):
	
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
	
	j fimAtualizarPosicaoDoPlayer            # Volta ao início do loop
	

	cima:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
		lw $25, -512($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		lw $25, -540($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, -512    # Movimentar para cima
		
		j fimAtualizarPosicaoDoPlayer
	baixo:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
		lw $25, 4096($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		lw $25, 4124($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, 4096    # Movimentar para baixo
		
		j fimAtualizarPosicaoDoPlayer
	esquerda:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
		lw $25, -4($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		lw $25, -4($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, -4    # Movimentar para a esquerda
		
		j fimAtualizarPosicaoDoPlayer
	direita:
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		lui $10, 0x0031
		ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
		lw $25, 4($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		lw $25, 4($8)
		beq $25, $9, fimAtualizarPosicaoDoPlayer
		beq $25, $10, fimAtualizarPosicaoDoPlayer
		
		# Else:
		addi $8, $8, 4    # Movimentar para a direita
		
		j fimAtualizarPosicaoDoPlayer
	
	
	fimAtualizarPosicaoDoPlayer:
		# Atualiza movimento do personagem do player (Azul)
		move $25, $8
		lui $8, 0x1002    # Primeira posição do "array" para as variaveis
		sw $25, 4($8)    # Atualiza a variavel da posição do player (AZUL)
		#move $8, $25   # Recupera a posição do personagem
		
	
	lui $8, 0x1002    # Primeira posição do "array" para as variaveis
	addi $8, $8, 4    # Coluna da posição
	
	
	########################## Movimentação dos BOTs #############################
	addi $24, $0, 3
	
	loopMovimentacaoBOTs: beq $24, $0, desenharTodosOsPersonagens
		addi $8, $8, 512    #Pular bot ou player
		addi $24, $24, -1
	
		# Verificar se esta vivo
		lw $25, -4($8)
		beq $25, $0, loopMovimentacaoBOTs   # O BOT esta MORTO
	
		lw $25, 12($8)           # Tempo Entre cada passo do personagem
		bne $25, $0, naoSeMexe
		# Else (Se o for a hora do personagem se mecher):
			addi $25, $0, 10
			sw $25, 12($8)   # Reinicia o tempo de cada passo
		
			lw $25, 16($8)   # Quantidade de passinhos que faltam para trocar de direção
			bne $25, $0, manterDirecao    # Ja foram dados 8 passinhos
			# Else
			addi $25, $0, 8
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
		
					lw $25, -512($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					lw $25, -540($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					# Else:
					addi $11, $11, -512    # Movimentar para cima
				
					j atualizarPosicaoDoBOT
				direitaBot:
					addi $25, $0, 2   # Verificar a direção direita (2)
					bne $9, $25, baixoBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
					lw $25, 32($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					lw $25, 3616($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					# Else:
					addi $11, $11, 4    # Movimentar para cima
				
					j atualizarPosicaoDoBOT
				baixoBot:
					addi $25, $0, 3   # Verificar a direção direita (2)
					bne $9, $25, esquerdaBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
					lw $25, 4096($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					lw $25, 4124($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					# Else:
					addi $11, $11, -4    # Movimentar para cima
				
					j atualizarPosicaoDoBOT
				esquerdaBot:
					#addi $25, $0, 4   # Verificar a direção esquerda (2)
					#bne $9, $25, baixoBot
				
					lui $9, 0x0000
					ori $9, $9, 0x0000   # Iniciando com a cor Preta
					lui $10, 0x0031
					ori $10, $10, 0x3031   # Iniciando com a cor Cinza Escuro
		
					lw $25, -4($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					lw $25, 3580($11)
					beq $25, $9, gerarValor
					beq $25, $10, gerarValor
		
					# Else:
					addi $11, $11, -4    # Movimentar para esquerda
			
				atualizarPosicaoDoBOT:		
					sw $11, 0($8)     # atualiza a posição do BOT
				
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
		
		lw $8, 0($8)
		lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $8
		ori $9, $9, 0x1020   # Adiciona 0x1020 aos 16 bits inferiores de $8
		
		jal desenharPersonagem
		
	desenharBotVermelho:
		lui $8, 0x1002    # Primeira posição do "array" para as variaveis
		addi $8, $8, 4    # Coluna da posição
		addi $8, $8, 512

		lw $8, 0($8)
		lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $8
		ori $9, $9, 0x11C0   # Adiciona 0x1020 aos 16 bits inferiores de $8
		
		jal desenharPersonagem
	
	desenharBotAmarelo:
		lui $8, 0x1002    # Primeira posição do "array" para as variaveis
		addi $8, $8, 4    # Coluna da posição
		addi $8, $8, 512
		addi $8, $8, 512

		lw $8, 0($8)
		lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $8
		ori $9, $9, 0xE1C0   # Adiciona 0x1020 aos 16 bits inferiores de $8
		
		jal desenharPersonagem
		
	desenharBotRosa:
		lui $8, 0x1002    # Primeira posição do "array" para as variaveis
		addi $8, $8, 4    # Coluna da posição
		addi $8, $8, 512
		addi $8, $8, 512
		addi $8, $8, 512

		lw $8, 0($8)
		lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $8
		ori $9, $9, 0xE020   # Adiciona 0x1020 aos 16 bits inferiores de $8
		
		jal desenharPersonagem
	
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
# Sujos: $8, $9, $24
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
	
	# Direita = 0
	
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
	
	# Cima \ Direita = 2 \ Baixo = 3 \ Esquerda = 4
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
	
	addi $25, $0, 10   # Tempo de movimentação
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	addi $8, $8, 4
	
	addi $25, $0, 8  # Limite de Passos
	sw $25, 0($8)
	sw $25, 512($8)
	sw $25, 1024($8)
	sw $25, 1536($8)
	
	jr $31
