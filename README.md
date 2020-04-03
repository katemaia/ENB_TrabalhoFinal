
##----- Escola Nacional de Botanica ------
###--- Disciplina: Projetos de análise de dados usando R - 2020 ---

--- Trabalho Final - Kate Pereira Maia ---

Objetivo: Estudar a estrutura da rede de transporte rodoviario do estado de Minas Gerais. 

O projeto esta estruturado em 5 pastas:

#### Data:
IBGE-ligacoes_rodoviarias_e_hidroviarias_2016: Dados de pesquisa do IBGE (2016) sobre as rotas rodoviarias e hidroviarias entre municipios brasileiros. Os dados foram obtidos no site do IBGE e usados para construir a rede de rotas rodioviarias mineira (ver scripts). As colunas de interesse informam a origem e destino das rotas (UF_A, NOMEMUN_A, UF_B, NOMEMUN_B), e o fluxo entre municipios (VAR06).

divisao_territorial_brasil: Dados do IBGE com 4 colunas: UF (estado), mesorregiao, microrregiao e municipio. 

microreg_coords_MG: Dados do IBGE obtidos com o pacote brazilmaps. Tem 4 colunas: microrregiao, code, latitude e longitude. A coluna code ja havia sido criada a mao para facilitar a leitura no plot, e nao corresponde aos codigos usados pelo IBGE.

network_MG: Matriz (rede) quadrada, quantitativa e nao-direcionada de rotas rodoviarias entre as microrregioes do estado de Minas Gerais, criada com o script 00 a partir dos dados do IBGE citados acima. Cada linha (e coluna) representa uma microrregiao, e as celulas sao preenchidas pelo numero de rotas ligando os municipio entre microrregioes ou dentro de microrregioes.

#### Script:
00_Create_Network: Script que cria a rede network_MG, com base nos dados de rotas rodoviarias e hidroviarias do IBGE, para ser usada na analise de modularidade.

01_Modularity: Script que calcula a modularidade quantitativa da rede network_MG e, com o auxilio de duas funcoes (ver abaixo), calcula duas metricas que descrevem o papel topologico das microrregioes: c e z. Printa dataframe C&Z para ser usado por 01_Plot_Modularity (ver Output).

aux_func_C&Z.R: Duas funcoes auxiliares que calculam as versoes quantitativas das metricas among-module connectivity (c) e within-module degree (z) para cada microrregiao da rede.

01_Plot_Modularity: Script que plota os resultados da analise de modularidade da rede network_MG. No nivel da rede, usa a informacao de module membership (a qual modulo pertence cada microrregiao da rede) para plotar um mapa do estado de MG. No nivel das microrregioes (nos da rede) plota os valores de c e z.

#### Output:
01_Microreg_C&Z: Dataframe produzido pelo script 01_Modularity, com 4 colunas: mreg (microrregiao), module (modulo ao qual pertence cada microrregiao), c e z.

#### Figures:
01_Modularity_Map: Mapa do estado de Minas Gerais colorido de acordo com a afiliacao das microrregioes aos modulos da rede de rotas rodoviarias. As fronteiras pontilhadas definem as 66 microrregioes.

01_Modularity_C&Z: Plot dos valores de c e z, no qual cada ponto representa uma microrregiao e esta colorido de acordo com a afiliacao da microrregiao aos modulos da rede de rotas rodoviarias. 

#### Docs:
Report: Relatorio da analise de modularidade da rede rotas rodoviarias de MG.