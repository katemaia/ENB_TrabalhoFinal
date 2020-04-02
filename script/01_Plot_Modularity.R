
##### Codigo que plota a modularidade da rede rodoviaria de MG  ##### 
# Objetivo: Codigo que plota a modularidade da rede de rotas rodoviarias, e os valores de among-module connectivity (c) e within-module degree z dos nos (microrreigoes) dessa rede.
# Autora: Kate Pereira Maia
# Data: 02/04/2020



coords <- read.table("./data/microreg_coords_MG.csv", header = TRUE, sep = ",", check.names = FALSE)




# Plot rede rodoviaria de Minas Gerais -------------------------------------------

nmod <- max(M$membership)

display.brewer.pal(nmod, "Dark2")
colors.pal <- brewer.pal(nmod, "Dark2")

posit <- match(row.names(network), coords[,1]) # position os microreg in coords
layout <- as.matrix(coords[posit, c(3,4)])

E(graph)$arrow.size <- 0.2
V(graph)$color <- colors.pal[M$membership]
graph <- simplify(graph, remove.multiple = F, remove.loops = T) # no self loop  

V(graph)$name <- as.character(coords[match(V(graph)$name, coords$microreg), "code"])

# pdf("./figure/MG_Road_Network.pdf")
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
# dev.off

# Plot c & z microrregioes ------------------------------------------------------

mreg_data$code <- coords$code[match(mreg_data$mreg, coords$microreg)]

# Exploring C&Z
hist(mreg_data$c)
hist(mreg_data$z)

mreg_data_complete <- mreg_data
mreg_data <- mreg_data[-which(mreg_data$c <= 0.25 & mreg_data$z <= 0),]

range_c <- range(mreg_data$c)
range_z <- range(mreg_data$z)

par(mfrow = c(1,1), mar = c(4,4,2,2))
plot(z ~ c, data = mreg_data, 
     xlim = c(range_c[1] - 0.1, range_c[2] + 0.1), 
     ylim = c(range_z[1] - 0.1, range_z[2] + 0.1), 
     xlab = "Conectividade inter-módulos", 
     ylab = "Conectividade intra-módulo", 
     type = "n", bty = "l", cex.lab = 1.2)
text(y = mreg_data$z, x = mreg_data$c, label = mreg_data$code, cex = 0.8)
text(y = c(-1.5,-1.5,1.6,1.6), x = c(0.03,0.9,0.03,0.9), font = 2,
     labels = c("perifericos", "conectores", "hubs locais", "hubs regionais"), 
     col = c("gold","green4","steelblue","tomato"), xpd = T)
