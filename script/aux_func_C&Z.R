
# Funcoes auxiliares que usam os resultados de "module membership" para calcular c & z # 
# Objetivo: Funcoes auxiliares que calculam os valores de c (among-module connectivity) e z (within-module degree) para cada microrregiao da rede de rotas rodoviarias de MG.
# Autora: Kate Pereira Maia
# Data: 24/03/2020

# Input para as duas funcoes: 
# mreg_data dataframe: dataframe com duas colunas: i) nome da microrregiao; ii) module membership (numero do modulo ao qual pertence cada microrregiao)
# network matrix: matriz de fluxo entre microrregioes

#-------------------------------------z-------------------------------------

z_function <- function(mreg_data, network){
  z_vector <- c()
  
  for (i in 1:nrow(network)) {
    mreg <- mreg_data[i,]
    
    module_sp <- as.character(mreg_data[mreg_data$module == mreg$module, "mreg"])
    module_network <- network[rownames(network) %in% module_sp, colnames(network) %in% module_sp]
    if (length(module_sp) > 1) {
      diag(module_network) <- 0
      
      # kis is number of links of i to other microreg in its own module
      ks <- rowSums(module_network) + colSums(module_network)
      kis <- ks[names(ks) == mreg$mreg]
      
      # AVEks and SDks are average and st dev of within-module k of all microreg in module s
      AVEks <- mean(ks)
      SDks <- sd(ks)
      
      z <- (kis - AVEks)/SDks
    } else {
      z <- 0
    }
    z_vector <- c(z_vector, z)
  }
  z_vector <- round(as.numeric(z_vector), digits = 4)
  return(z_vector)
}

#-------------------------------------c-------------------------------------

c_function <- function(mreg_data, network){
  c_vector <- c()
  NM <- max(mreg_data$module)
  network <- as.matrix(network)
  diag(network) <- 0
  
  ki <- rowSums(network) + colSums(network)
  
  for (i in 1:nrow(network)) {
    mreg <- mreg_data[i,]
    second_term <- c()
    
    for (j in 1:NM) {
      module_sp <- as.character(mreg_data[mreg_data$module == j, "mreg"])
      
      if (mreg$mreg %in% module_sp) {
        module_network <- network[rownames(network) %in% module_sp, colnames(network) %in% module_sp]
      } else {
        module_sp <- c(as.character(mreg$mreg), module_sp)
        module_network <- network[rownames(network) %in% module_sp, colnames(network) %in% module_sp]
      }
      
      if (length(module_sp) > 1) {
        diag(module_network) <- 0
        
        kit <- rowSums(module_network) + colSums(module_network)
        second_term <- c(second_term, (kit[names(kit) == mreg$mreg]/ki[names(ki) == mreg$mreg])^2)} 
      
      else {
        second_term <- c(second_term, 0)
      }
    }
    
    c <- 1 - sum(second_term)
    c_vector <- c(c_vector, c)
  }
  c_vector <- round(as.numeric(c_vector), digits = 4)
  return(c_vector)
}

#----------------------------------------
