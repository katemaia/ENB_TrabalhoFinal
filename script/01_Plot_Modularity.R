
############### Script que plota a modularidade da rede rodoviaria de MG  ############### 
# Objetivo: Plota os resultados de modularidade da rede de rotas rodoviarias: mapa com modulos e os valores de among-module connectivity (c) e within-module degree z das microrreigoes dessa rede.
# Autora: Kate Pereira Maia
# Data: 02/04/2020

library(igraph)
library(RColorBrewer)
library(brazilmaps)
library(ggplot2)
library(ggspatial)
library(ggthemes)

# Leitura dos dados ---------------------------------------------

dir("./data")
dir("./output")

network <- read.table("./data/network_MG.txt", header = TRUE, sep = "\t", check.names = FALSE)
coords <- read.table("./data/microreg_coords_MG.csv", header = TRUE, sep = ",", check.names = FALSE)
CZ <- read.table("./output/01_Microreg_C&Z.txt", header = TRUE)

# Checking for name consistency -----------------------------------

coords <- coords[match(rownames(network), coords$microreg),]

all(rownames(network) == colnames(network))
all(rownames(network) == coords$microreg)
all(rownames(network) == CZ$mreg)

# Plot modularidade no mapa de Minas Gerais -----------------------------------

nmod <- max(CZ$module)
display.brewer.pal(nmod, "Dark2")
colors.pal <- brewer.pal(nmod, "Dark2")

# Pegando o arquivo do mapa
micro.map <- get_brmap(geo = "MicroRegion")
micro.state <- micro.map[which(micro.map$State == 31),] # 31 code for MG 

rown_data <- toupper(rownames(network))
micro.state$colour <- colors.pal[CZ$module[match(micro.state$nome, rown_data)]]

# png("./figures/01_Modularity_Map.png", bg = "transparent")
ggplot(data = micro.state) + 
        geom_sf(aes(fill = nome), fill = micro.state$colour, alpha = 0.8) +
        annotation_scale(location = "bl", width_hint = 0.4) + theme_map() +
        annotation_north_arrow(location = "bl", which_north = "true",
                               pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                               style = north_arrow_fancy_orienteering) + 
        xlab("") + 
        ylab("") +
        theme(panel.border = element_blank(), legend.position = "none")
# dev.off()

# Plot c & z microrregioes ------------------------------------------------------

range_c <- range(CZ$c)
range_z <- range(CZ$z)

CZ$color <- colors.pal[CZ$module]
CZ$code <- coords$code

# png("./figures/01_Modularity_C&Z.png", bg = "transparent")
par(mfrow = c(1,1), mar = c(4,4,2,2))
plot(z ~ c, data = CZ, 
     xlim = c(range_c[1] - 0.1, range_c[2] + 0.1), 
     ylim = c(range_z[1] - 0.1, range_z[2] + 0.1), 
     xlab = "Conectividade inter módulos", 
     ylab = "Conectividade intra-módulo", 
     pch = 19, col = color, bty = "l", cex.lab = 1.2)

# Naming poits representing high c | z microrregions
highCZ <- CZ[CZ$z >= 1.3 | CZ$c >= 0.68,]
highCZ$c <- ifelse(highCZ$c >= 0.4, highCZ$c + 0.06, highCZ$c)
highCZ$z <- ifelse(highCZ$c >= 0.4 & highCZ$c <= 0.55, highCZ$z - 0.08, highCZ$z)
highCZ$c <- ifelse(highCZ$c >= 0.32 & highCZ$c <= 0.4, highCZ$c + 0.04, highCZ$c)
highCZ$c <- ifelse(highCZ$c <= 0.32, highCZ$c - 0.02, highCZ$c)
highCZ$z <- ifelse(highCZ$c <= 0.4 & highCZ$z <= 1.62, highCZ$z - 0.1, highCZ$z)
highCZ$z <- ifelse(highCZ$c <= 0.4 & highCZ$z >= 1.62, highCZ$z + 0.12, highCZ$z)
text(y = highCZ$z, x = highCZ$c, label = highCZ$code, cex = 0.7)

text(y = c(-1.5,-1.5,2.5,2.5), x = c(0,0.75,0,0.75), font = 2, cex = 0.8,
     labels = c("perifericos", "conectores", "hubs locais", "hubs regionais"), 
     col = "gray30", xpd = T)
# dev.off()
