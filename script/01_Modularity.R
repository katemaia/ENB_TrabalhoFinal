
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

# write.table(mreg_data, "./output/01_Microreg_C&Z.txt", row.names = FALSE)

# Plot rede rodoviaria de Minas Gerais -------------------------------------------

nmod <- max(M$membership)

display.brewer.pal(nmod, "Dark2")
display.brewer.pal(nmod, "Set3")
colors.pal <- brewer.pal(nmod, "Dark2")

posit <- match(row.names(network), coords[,1]) # position os microreg in coords
layout <- as.matrix(coords[posit, c(3,4)])

E(graph)$arrow.size <- 0.2
V(graph)$name <- as.character(coords[match(V(graph)$name, coords$microreg), "code"])
V(graph)$color <- colors.pal[M$membership]

graph <- simplify(graph, remove.multiple = F, remove.loops = T) # no self loop  

#pdf("./figure/MG_Road_Network.pdf")
par(mfrow = c(1,1), mar = c(1,1,1,1))
plot.igraph(graph, layout = layout, asp = 0,
     vertex.size = log(colSums(network) + rowSums(network)), 
     vertex.color = V(graph)$color,
     edge.width = log(E(graph)$weight, 20), arrow.mode = 0)
#dev.off

# Plot c & z microrregioes ------------------------------------------------------