

# ================================================
# YA 10.3
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)
library(data.table)
library(readr)

#

# Cargamos los datos ajustados con la hoja "Ind. Patología"

procu_2015 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2015.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2016 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2016.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2017 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2017.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2018 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2018.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2019 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2019.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2020 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2020.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2021 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2021.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2022 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2022.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

procu_2023 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2023.xlsx", 
                         sheet = "Ind. Patología", na = "N/A")

# ====================================================
# Sección: Merge Data  
# ====================================================


# Crear una lista con todos los data frames

procu_list <- list(procu_2015, procu_2016, procu_2017, procu_2018, procu_2019, procu_2020, procu_2021, procu_2022, procu_2023)

# Encontrar las columnas comunes

columnas_comunes <- Reduce(intersect, lapply(procu_list, names))

# Aplicar rbindlist directamente sobre la lista de data frames filtrados por columnas comunes

procuraduria <- rbindlist(lapply(procu_list, function(x) x[, columnas_comunes, with = FALSE]))

# Limpiamos Memoria
rm(procu_2015, procu_2016, procu_2017, procu_2018, procu_2019, procu_2020, procu_2021, procu_2022, procu_2023)



# Dejamos solo las variables necesarias

procuraduria <- procuraduria[, c(2, 4, 6, 7, 8, 9, 10)]


# Rename de Variables

procuraduria   <- rename(procuraduria , codmpio = `Código Municipio`, anno = `Periodo del Indicador`)


# ====================================================
# Sección: Filtrar 
# ====================================================

intrafamiliar <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de Violencia Intrafamiliar en niños, niñas y adolescentes",
         `Rangos de edad o edades simples` == "(01 a 05)")

intrafamiliar  <- intrafamiliar [, c(1,3,5,6,7)]


intrafamiliar<- rename(intrafamiliar, casos = `Numerador (casos)`, denominador = `Denominador (Población)`, intrafamiliar = `Resultado (Tasa)` )

# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(intrafamiliar, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_10.3.xlsx", col_names = TRUE)

# Fin del Código


