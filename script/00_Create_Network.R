
dir("./data")
road_data <- read.table("./data/IBGE_ligacoes_rodoviarias_e_hidroviarias_2016.txt", header = TRUE, sep = "\t", quote = "")
dim(road_data)

territ <- read.table("./data/divisao_territorial_brasil.csv", header = TRUE, sep = ";", quote = "")
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

road_data[which(is.na(road_data$microrreg_A)),c(5,9)] 
road_data[which(is.na(road_data$microrreg_B)),c(5,9)]
territ[592,]

road_data[which(is.na(road_data$microrreg_A)), "microrreg_A"] <- "Caratinga"
road_data[which(is.na(road_data$microrreg_B)), "microrreg_B"] <- "Caratinga"

road_data[road_data$NOMEMUN_A == "Pingo-d'Água" | road_data$NOMEMUN_B == "Pingo-d'Água", c("microrreg_A", "microrreg_B")]
