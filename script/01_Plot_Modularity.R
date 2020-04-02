
##### Codigo que plota a modularidade da rede rodoviaria de MG  ##### 
# Objetivo: Codigo que plota a modularidade da rede de rotas rodoviarias, e os valores de among-module connectivity (c) e within-module degree z dos nos (microrreigoes) dessa rede.
# Autora: Kate Pereira Maia
# Data: 02/04/2020

library(igraph)
library(RColorBrewer)

# Leitura dos dados ---------------------------------------------
dir("./data")
dir("./output")

network <- read.table("./data/network_MG.txt", header = TRUE, sep = "\t", check.names = FALSE)

coords <- read.table("./data/microreg_coords_MG.csv", header = TRUE, sep = ",", check.names = FALSE)

CZ <- read.table("./output/01_Microreg_C&Z.txt", header = TRUE)

# CKecking for name consistency -----------------------------------

all(rownames(network) == colnames(network))

coords <- coords[match(rownames(network), coords$microreg),]

all(rownames(network) == coords$microreg)

all(rownames(network) == CZ$mreg)

# Plot rede rodoviaria de Minas Gerais -------------------------------------------

graph <- graph_from_adjacency_matrix(as.matrix(network), weighted = T, mode = "undirected")
all(V(graph)$name == rownames(network)) # vertex of graph in the same order as matrix row/col

nmod <- max(CZ$module)

display.brewer.pal(nmod, "Dark2")
colors.pal <- brewer.pal(nmod, "Dark2")

posit <- match(row.names(network), coords[,1]) # position os microreg in coords
layout <- as.matrix(coords[posit, c(3,4)])

E(graph)$arrow.size <- 0.2
V(graph)$color <- colors.pal[CZ$module]
graph <- simplify(graph, remove.multiple = F, remove.loops = T) # no self loop  

V(graph)$name <- as.character(coords[match(V(graph)$name, coords$microreg), "code"])

# png("./figures/MG_Road_Network.png", bg = "transparent")
par(mfrow = c(1,1), mar = c(1,1,1,1))
plot.igraph(graph, layout = layout, asp = 0,
            vertex.size = log(colSums(network)), 
            vertex.color = V(graph)$color,
            vertex.frame.color = NA,
            vertex.label.family	  = "sans",
            vertex.label.color = "black",
            vertex.label.cex = 0.7,
            vertex.label.font = 2,
            edge.width = log(E(graph)$weight, 20),
            edge.curved = 0.1)
# dev.off()

# Plot c & z microrregioes ------------------------------------------------------

range_c <- range(CZ$c)
range_z <- range(CZ$z)

CZ$color <- colors.pal[CZ$module]
CZ$code <- coords$code

highCZ <- CZ[CZ$z >= 1.3 | CZ$c >= 0.7,]

par(mfrow = c(1,1), mar = c(4,4,2,2))
plot(z ~ c, data = CZ, 
     xlim = c(range_c[1] - 0.1, range_c[2] + 0.1), 
     ylim = c(range_z[1] - 0.1, range_z[2] + 0.1), 
     xlab = "Conectividade inter-módulos", 
     ylab = "Conectividade intra-módulo", 
     pch = 19, col = color, bty = "l", cex.lab = 1.2)

#ifelse
highCZ$c <- ifelse(highCZ$c >= 0.4, highCZ$c + 0.06, highCZ$c)
highCZ$z <- ifelse(highCZ$c >= 0.4 & highCZ$c <= 0.55, highCZ$z - 0.08, highCZ$z)

highCZ$c <- ifelse(highCZ$c >= 0.32 & highCZ$c <= 0.4, highCZ$c + 0.04, highCZ$c)
highCZ$c <- ifelse(highCZ$c <= 0.32, highCZ$c - 0.02, highCZ$c)

highCZ$z <- ifelse(highCZ$c <= 0.4 & highCZ$z <= 1.62, highCZ$z - 0.09, highCZ$z)

highCZ$z <- ifelse(highCZ$c <= 0.4 & highCZ$z >= 1.62, highCZ$z + 0.1, highCZ$z)

text(y = highCZ$z, x = highCZ$c, label = highCZ$code, cex = 0.7)


text(y = c(-1.5,-1.5,1.6,1.6), x = c(0.03,0.9,0.03,0.9), font = 2,
     labels = c("perifericos", "conectores", "hubs locais", "hubs regionais"), 
     col = c("gold","green4","steelblue","tomato"), xpd = T)


#===== Plotando mapa do estado - cor/modulo igual rede ==============

#Pegando o arquivo do mapa
micro.map <- get_brmap(geo = "MicroRegion") # dataframe com os dados prontos para plotar os mapas na escala desejada

#Filtrando so o mapa de um determinado estado, MG = 31, SP = 35
micro.state <- micro.map[which(micro.map$State == 33), ] 

rown_data <- toupper(rownames(data))
micro.state$colour <- colors.pal[M$membership[match(micro.state$nome, rown_data)]]

ggplot(data = micro.state) + 
        geom_sf(aes(fill = nome), fill = micro.state$colour, alpha = 0.8) +
        annotation_scale(location = "bl", width_hint = 0.4) + theme_map() +
        annotation_north_arrow(location = "bl", which_north = "true",
                               pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                               style = north_arrow_fancy_orienteering) + 
        xlab("") + 
        ylab("") +
        theme(panel.background = element_rect(fill = "white"), legend.position = "none")
