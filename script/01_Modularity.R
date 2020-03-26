
##### Codigo que calcula e plota a modularidade da rede rodoviaria de MG  ##### 
# Objetivo: Codigo que calcula a modularidade da rede de rotas rodoviarias, e os valores de among-module connectivity (c) e within-module degree z dos nos (microrreigoes) dessa rede. Tambem plota a rede, e os papeia topologicos c e z.
# Autora: Kate Pereira Maia
# Data: 26/03/2020

library(igraph)
library(RColorBrewer)

dir("./script")
source("./script/aux_func_C&Z.R")


# Leitura dos dados ---------------------------------------------
dir("./data")

network <- read.table("./data/network_MG.txt", header = TRUE, sep = "\t", check.names = FALSE)
class(network)
dim(network)
all(rownames(network) == colnames(network))

coords <- read.table("./data/microreg_coords_MG.csv", header = TRUE, sep = ",", check.names = FALSE)

# Analise de modularidade da rede ---------------------------------------------

graph <- graph_from_adjacency_matrix(as.matrix(network), weighted = T, mode = "directed")
all(V(graph)$name == rownames(network)) # vertex of graph in the same order as matrix row/col

M <- cluster_optimal(graph, weights = E(graph)$weight)

# Dataframe com resultados de membership
mreg_data <- data.frame(mreg = V(graph)$name, module = M$membership)

# Analise de c & z das microrregioes ---------------------------------------------

mreg_data$c <- c_function(mreg_data, network)

mreg_data$z <- z_function(mreg_data, network)

# Plot rede rodoviaria de Minas Gerais -------------------------------------------

display.brewer.pal(8, "Dark2")
display.brewer.pal(8, "Set3")

