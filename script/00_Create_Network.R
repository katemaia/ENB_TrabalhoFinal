
##### Criando rede de rotas rodoviarias para o estado de Minas Gerais ##### 
# Objetivo: Codigo que le dados de rotas rodoviarias e territorios brasileiros disponiveis no site do IBGE, e cria rede de rotas rodoviarias para as microrregioes do estado de MG.
# Autora: Kate Pereira Maia
# Data: 26/03/2020

library(igraph)
dir("./data")

# Leitura e organizacao dos dados ---------------------------------------------

# Dados de rotas rodoviarias
road_data <- read.table("../data/IBGE_ligacoes_rodoviarias_e_hidroviarias_2016.txt", header = TRUE, sep = "\t", quote = "")[, c(3,5,7,9,15)]
head(road_data)
colnames(road_data)[5] <- "fluxo"

# Dados de territorios brasileiros
territ <- read.table("../data/divisao_territorial_brasil.csv", header = TRUE, sep = ";", quote = "")
head(territ)

# Selecionando apenas rotas internas de Minas Gerais
road_data <- road_data[road_data$UF_A == "MG" & road_data$UF_B == "MG",]
dim(road_data)

road_data$NOMEMUN_A <- factor(road_data$NOMEMUN_A)
road_data$NOMEMUN_B <- factor(road_data$NOMEMUN_B)

# Selecionando apenas informacoes territoriais de Minas Gerais
territ <- territ[territ$uf == "Minas Gerais",]

territ$municip <- factor(territ$municip)
territ$microrreg <- factor(territ$microrreg)

# Adicionando microrregioes ao road_data 
road_data$microrreg_A <- territ[match(road_data$NOMEMUN_A, territ$municip), "microrreg"]
road_data$microrreg_B <- territ[match(road_data$NOMEMUN_B, territ$municip), "microrreg"]

# Checando e corrigindo possiveis municipios sem microrregiao - problema com o municipio Pingo D'Agua por causa da grafia
road_data[which(is.na(road_data$microrreg_A)),] 
road_data[which(is.na(road_data$microrreg_B)),]
territ[592,]

road_data[which(is.na(road_data$microrreg_A)), "microrreg_A"] <- "Caratinga"
road_data[which(is.na(road_data$microrreg_B)), "microrreg_B"] <- "Caratinga"

road_data[road_data$NOMEMUN_A == "Pingo-d'Água" | road_data$NOMEMUN_B == "Pingo-d'Água",]

# Construcao da rede ----------------------------------------------------------

# Criando arquivo no formato edge-list para uso pelo igraph
edge_list <- data.frame(from = road_data$microrreg_A, to = road_data$microrreg_B, weight = road_data$fluxo)
edge_list <- aggregate(weight ~ from + to, edge_list, sum)

# Cria grafo com base no edge_list
graph <- graph.data.frame(edge_list, directed = TRUE)
g.nd <- simplify(g.nd, remove.loops  =  FALSE, edge.attr.comb = "sum") #

# Cria matriz de adjacencia com base no grafo
adj_matrix <- get.adjacency(graph, attr = "weight", sparse = FALSE)
dim(adj_matrix)
all(rownames(adj_matrix) == colnames(adj_matrix))

# write.table(adj_matrix, "./data/network_MG.txt", sep = "\t")
