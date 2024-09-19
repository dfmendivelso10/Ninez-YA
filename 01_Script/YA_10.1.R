

# ================================================
# YA 10.1 Homicidios  
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

# ================================================
# Cargar datos
# ================================================

# Definir los años y cargar los datos de cada uno
years <- 2015:2023
procu_list <- lapply(years, function(year) {
  read_excel(paste0("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_", year, ".xlsx"), 
             sheet = "Ind. Patología", 
             na = "N/A")
})

# ================================================
# Unir data frames y estandarizar columnas
# ================================================

# Encontrar las columnas comunes
columnas_comunes <- Reduce(intersect, lapply(procu_list, names))

# Unir los data frames usando las columnas comunes
procuraduria <- rbindlist(lapply(procu_list, function(x) x[, columnas_comunes, with = FALSE]))

# Liberar memoria eliminando objetos innecesarios
rm(procu_list)

# ================================================
# Filtrar y renombrar columnas
# ================================================

# Seleccionar columnas necesarias y renombrar
procuraduria <- procuraduria %>%
  select(codmpio = `Código Municipio`, 
         anno = `Periodo del Indicador`, 
         `Nombre del indicador`, 
         `Rangos de edad o edades simples`, 
         casos = `Numerador (casos)`, 
         denominador = `Denominador (Población)`, 
         homicidios = `Resultado (Tasa)`)

# Limitar la columna de año a los primeros 4 dígitos
procuraduria$anno <- str_sub(procuraduria$anno, 1, 4)

# ================================================
# Filtrar por el indicador de homicidios
# ================================================

homicidios <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de Homicidios en niños, niñas y adolescentes",
         `Rangos de edad o edades simples` == "(01 a 05)") %>%
  select(codmpio, anno, casos, denominador, homicidios)

# ================================================
# Exportar a Excel
# ================================================

write.xlsx(homicidios, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_10.1.xlsx", colNames = TRUE)

# Fin del Código

