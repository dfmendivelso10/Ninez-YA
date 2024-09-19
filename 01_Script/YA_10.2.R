

# ================================================
# YA 10.2 
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

# Definir la lista de años y cargar los datos
years <- 2015:2023
procu_list <- lapply(years, function(year) {
  read_excel(paste0("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_", year, ".xlsx"), 
             sheet = "Ind. Violencia Sexual", 
             na = "N/A")
})

# ================================================
# Unir data frames y estandarizar columnas
# ================================================

# Estandarizar el nombre de la columna y unir los data frames
procuraduria <- rbindlist(lapply(procu_list, function(df) {
  setnames(df, old = "Periodo del indicador", new = "Periodo del Indicador", skip_absent = TRUE)
  return(df)
}), fill = TRUE)

# Liberar memoria
rm(procu_list)

# ================================================
# Filtrar columnas necesarias y renombrar
# ================================================

# Seleccionar columnas necesarias
procuraduria <- procuraduria %>%
  select(codmpio = `Código Municipio`, 
         anno = `Periodo del Indicador`, 
         `Nombre del indicador`, 
         `Rangos de edad o edades simples`, 
         casos = `Numerador (casos)`, 
         denominador = `Denominador (Población)`, 
         sexual = `Resultado (Tasa)`)

# Extraer solo los primeros 4 dígitos del año
procuraduria$anno <- str_sub(procuraduria$anno, 1, 4)

# ================================================
# Filtrar datos por el indicador específico
# ================================================

delito_sexual <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de exámenes médico legales por presunto delito sexual contra niños, niñas y adolescentes",
         `Rangos de edad o edades simples` == "(01 a 05)") %>%
  select(codmpio, anno, casos, denominador, sexual)

# ================================================
# Exportar los resultados a Excel
# ================================================

write.xlsx(delito_sexual, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_10.2.xlsx", colNames = TRUE)

# Fin del Código
