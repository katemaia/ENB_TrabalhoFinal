
#------------------------- Escola Nacional de Botanica -------------------------
#----------- Disciplina: Projetos de análise de dados usando R - 2020 ----------

#---------------------- Trabalho Final - Kate Pereira Maia ---------------------

# Objetivo: Estudar a estrutura da rede de transporte rodoviario do estado de Minas Gerais. 

# O projeto esta estruturado em 5 pastas:

# Data:
# IBGE-ligacoes_rodoviarias_e_hidroviarias_2016: Dados de pesquisa do IBGE (2016) sobre as rotas rodoviarias e hidroviarias entre os municipio brasileiros. Esses dados foram obtidos no site do IBGE e usados para construir a rede de rotas rodioviarias mineira (ver scripts). As colunas de interesse informam a origem e destino das rotas rodoviarias (UF_A, NOMEMUN_A, UF_B, NOMEMUN_B), e o fluxo entre eles (VAR06).

# divisao_territorial_brasil: Dados do IBGE com 4 colunas: UF (estado), mesorregiao, microrregiao e municipio. 

# microreg_coords_MG: Dados do IBGE obtidos com o pacote de R brazilmaps, e tem 4 colunas: microrregiao, code, lat e lon. A coluna code ja havia - em outra oportunidade - sido criada a mao para facilitar a leitura no plot, e nao corresponde aos codigos usados pelo IBGE.

# network_MG: Matriz (rede) quadrada, quantitativa e nao-direcionada de rotas rodoviarias entre as microrregioes do estado de Minas Gerais, criada com o script 00 a partir dos dados do IBGE citados acima. 

# Script:
# 00_Create_Network: script que cria a rede network_MG para ser usada na analise de modularidade.

# 01_Modularity

