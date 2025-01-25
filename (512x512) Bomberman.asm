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
			# Baixo
			sw $9, 57856($8)
			
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
	jal copiaCenario  # Chamada da função que cria uma copia do cenário fora do display visivel
	
	jal iniciarVariaveisDosPersonagens
	
	### Personagem Jogavel - Azul
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	lw $10, 16($8) # Direção 
	lw $9, 12($8)  # Cor
	lw $8, 4($8)   # Posição
	jal criarPersonagem
	
	### Bot 1 - Vermelho
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	lw $10, 36($8) # Direção
	lw $9, 32($8)  # Cor
	lw $8, 24($8)  # Posição
	jal criarPersonagem
	
	### Bot 2 - Amarelo
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	lw $10, 56($8) # Direção
	lw $9, 52($8)  # Cor
	lw $8, 44($8)  # Posição
	jal criarPersonagem
	
	### Bot 3 - Rosa
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	lw $10, 76($8) # Direção
	lw $9, 72($8)  # Cor
	lw $8, 64($8)  # Posição
	jal criarPersonagem
	
	lui $21, 0xffff   # não sei o que é, não sei para que serve, so sei que não sei assembly, e so funciona com isso.
	
loopPrincipal:
	### Personagem Jogavel - Azul
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis

	lw $22, 0($21)             # Lê o valor da tecla pressionada em $22 (endereço de teclas).
	beq $22, $0, loopPrincipal # Se nenhuma tecla foi pressionada, pula para o próximo ciclo do loop.
	
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
	
	j loopPrincipal            # Volta ao início do loop

	cima:
		lw $10, 16($8) # Direção 
		lw $9, 12($8)  # Cor
		lw $8, 4($8)   # Posição
		
		addi $11, $0, 1   # Direção Norte (Cima)
		jal verificarImpactoComOsObstaculos
		
		beq $12, $0, loopPrincipal   # Devera ser substituido pelo movimento dos Bots
		
		jal criarPersonagem
		jal AtualizarMovimentoDoPlayer
		
		j loopPrincipal   # Devera ser substituido pelo movimento dos Bots
	baixo:
		lw $10, 16($8) # Direção 
		lw $9, 12($8)  # Cor
		lw $8, 4($8)   # Posição
		
		addi $11, $0, 3
		jal verificarImpactoComOsObstaculos
		
		beq $12, $0, loopPrincipal   # Devera ser substituido pelo movimento dos Bots
		
		jal criarPersonagem
		jal AtualizarMovimentoDoPlayer
		
		j loopPrincipal
	esquerda:
		addi $25, $0, 1
		sw $25, 16($8) # Atualizar direção
		lw $10, 16($8) # Direção 
		lw $9, 12($8)  # Cor
		lw $8, 4($8)   # Posição
		
		addi $11, $0, 4
		jal verificarImpactoComOsObstaculos
		
		beq $12, $0, loopPrincipal   # Devera ser substituido pelo movimento dos Bots
		
		jal criarPersonagem
		jal AtualizarMovimentoDoPlayer
		
		j loopPrincipal
	direita:
		addi $25, $0, 0
		sw $25, 16($8) # Atualizar direção
		lw $10, 16($8) # Direção 
		lw $9, 12($8)  # Cor
		lw $8, 4($8)   # Posição
		
		addi $11, $0, 2
		jal verificarImpactoComOsObstaculos
		
		beq $12, $0, loopPrincipal   # Devera ser substituido pelo movimento dos Bots
		
		jal criarPersonagem
		jal AtualizarMovimentoDoPlayer
		
		j loopPrincipal
	
	
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

criarPersonagem:
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
# Função Inicia as variáveis dos personagens em uma região não visicel do mapa
# Sujos: $8, $9
# Saida: ---

iniciarVariaveisDosPersonagens:
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	
	# Vida 
	addi $9, $0, 1  # Vivo
	sw $9, 0($8)
	sw $9, 20($8)
	sw $9, 40($8)
	sw $9, 60($8)
	
	# Posiçôes
	# Personagem 1 - Azul
	lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $8
	ori $9, $9, 0x1020   # Adiciona 0x1020 aos 16 bits inferiores de $8
	sw $9, 4($8)
	# Personagem 2 - Vermelho
	lui $9, 0x1001       # Carrega os 16 bits superiores: 0x10010000
	ori $9, $9, 0x11C0   # Adiciona os 16 bits inferiores: 0x11C0
	sw $9, 24($8)
	# Personagem 3 - Amarelo
	lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $9
	ori $9, $9, 0xE1C0   # Adiciona 0xE1C0 aos 16 bits inferiores de $9
	sw $9, 44($8)
	# Personagem 4 - Rosa
	lui $9, 0x1001       # Carrega 0x1001 nos 16 bits superiores de $9
	ori $9, $9, 0xE020   # Adiciona 0xE020 aos 16 bits inferiores de $9
	sw $9, 64($8)
	
	# Bombas
	addi $9, $0, 0  # Bombas inativa
	sw $9, 8($8)
	sw $9, 28($8)
	sw $9, 48($8)
	sw $9, 68($8)
	
	# Cores
	# Azul
	lui $9, 0x0048
	ori $9, $9, 0xB0F2
	sw $9, 12($8)
	# Vermelho
	lui $9, 0x00F8
	ori $9, $9, 0x282A
	sw $9, 32($8)
	# Amarelo
	lui $9, 0x00F9
	ori $9, $9, 0xFF1C
	sw $9, 52($8)
	# Rosa
	lui $9, 0x00FF
	ori $9, $9, 0x3CEC
	sw $9, 72($8)
	
	# Direção
	# Direita (Azul e Rosa)
	addi $9, $0, 0
	sw $9, 16($8)
	sw $9, 76($8)
	# Esquerda (Vermelho e Amarelo)
	addi $9, $0, 1
	sw $9, 36($8)
	sw $9, 52($8)
	
	jr $31
	

#####################################################################################
# Função que atualiza a posição do personagem principal no "array"
# Sujos: $8, $9
# Saida: ---
AtualizarMovimentoDoPlayer:
	# Atualizar movimento do personagem do player (Azul)
	move $25, $8    # Criar cópia da posição atual
	lui $8, 0x1002   # Primeira posição do "array" para as variaveis
	sw $25, 4($8)
	
	jr $31

#####################################################################################
# Função que verifica se o movimento é valido
# Sujos: $8, $9, $10, $11, $12
# Saida: $12
# Registrador $8: Armazena a posição dos personagens,e é usado como ponteiro para o array de variaveis dos personagens
# Registrador: Armazena a cor (Normalmente), mas serve como registrador temporario

verificarImpactoComOsObstaculos:
	addi $12, $0, 0    # Contador de movimento
	move $24, $9       # Cria uma copia da cor

	# Esquerda
	addi $25, $0, 4
	beq $11, $25, VerificarEsquerda
	# Direita
	addi $25, $0, 2
	beq $11, $25, VerificarDireita
	# Cima
	addi $25, $0, 1
	beq $11, $25, VerificarCima
	# Baixo
	addi $25, $0, 3
	beq $11, $25, VerificarBaixo
	
	VerificarEsquerda:
		lw $25, -4($8)
		
		# Verificar se é preto
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		beq $25, $9, pararMovimento # Se for preto
		
		# Else: Verificar se é cinza
		lui $9, 0x0031
		ori $9, $9, 0x3031   # Iniciando com a cor Cinza Escuro
		beq $25, $9, pararMovimento # Se for cinza
		
		# Não vai bater, então da uma passinho para a esquerda
		addi $8, $8, -32
		addi $12, $0, 1    # Incrementa contador de movimento
		
		j pararMovimento
	
	VerificarDireita:
		lw $25, 32($8)
		
		# Verificar se é preto
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		beq $25, $9, pararMovimento # Se for preto
		
		# Else: Verificar se é cinza
		lui $9, 0x0031
		ori $9, $9, 0x3031   # Iniciando com a cor Cinza Escuro
		beq $25, $9, pararMovimento # Se for cinza
		
		# Não vai bater, então da uma passinho para a esquerda
		addi $8, $8, 32
		addi $12, $0, 1    # Incrementa contador de movimento
		
		j pararMovimento
		
	VerificarCima:
		lw $25, -512($8)
		
		# Verificar se é preto
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		beq $25, $9, pararMovimento # Se for preto
		
		# Else: Verificar se é cinza
		lui $9, 0x0031
		ori $9, $9, 0x3031   # Iniciando com a cor Cinza Escuro
		beq $25, $9, pararMovimento # Se for cinza
		
		# Não vai bater, então da uma passinho para a cima
		addi $8, $8, -4096
		addi $12, $0, 1    # Incrementa contador de movimento
		
		j pararMovimento
	
	VerificarBaixo:
		lw $25, 4096($8)
		
		# Verificar se é preto
		lui $9, 0x0000
		ori $9, $9, 0x0000   # Iniciando com a cor Preta
		beq $25, $9, pararMovimento # Se for preto
		
		# Else: Verificar se é cinza
		lui $9, 0x0031
		ori $9, $9, 0x3031   # Iniciando com a cor Cinza Escuro
		beq $25, $9, pararMovimento # Se for cinza
		
		# Não vai bater, então da uma passinho para a cima
		addi $8, $8, 4096
		addi $12, $0, 1    # Incrementa contador de movimento
		
		j pararMovimento
	
	pararMovimento:
		move $9, $24       # Recupera a cor
		jr $31
