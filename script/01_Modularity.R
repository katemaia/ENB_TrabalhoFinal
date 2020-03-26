
##### Codigo que calcula e plota a modularidade da rede rodoviaria de MG  ##### 
# Objetivo: Codigo que calcula a modularidade da rede de rotas rodoviarias, e os valores de among-module connectivity (c) e within-module degree z dos nos (microrreigoes) dessa rede. Tambem plota a rede, e os papeia topologicos c e z.
# Autora: Kate Pereira Maia
# Data: 26/03/2020

library(igraph)
library(RColorBrewer)

dir("./data")

# Leitura da rede ---------------------------------------------
network <- read.table("./data/network_MG.txt", header = TRUE, sep = "\t", check.names = FALSE)
class(network)
dim(network)
all(rownames(network) == colnames(network))

