# ================================================
# YA 10.2 Delito Sexual
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
# Estandarizar nombres y unir data frames
# ================================================

# Estandarizar nombre de la columna 'Periodo del indicador'
procu_list <- lapply(procu_list, function(df) {
  setnames(df, old = "Periodo del indicador", new = "Periodo del Indicador", skip_absent = TRUE)
  return(df)
})

# Unir los data frames
procuraduria <- rbindlist(procu_list, fill = TRUE)

# Liberar memoria eliminando objetos innecesarios
rm(procu_list)

# ================================================
# Filtrar columnas y renombrar variables
# ================================================

# Seleccionar columnas necesarias y renombrar
procuraduria <- procuraduria[, .(codmpio = `Código Municipio`, 
                                 anno = `Periodo del Indicador`, 
                                 `Nombre del indicador`, 
                                 `Rangos de edad o edades simples`, 
                                 casos = `Numerador (casos)`, 
                                 denominador = `Denominador (Población)`, 
                                 sexual = `Resultado (Tasa)`)]

# Extraer solo los primeros 4 dígitos del año
procuraduria$anno <- str_sub(procuraduria$anno, 1, 4)

# ================================================
# Filtrar por el indicador de violencia sexual y los rangos de edad, incluyendo menores de un año
# ================================================

delito_sexual <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de exámenes médico legales por presunto delito sexual contra niños, niñas y adolescentes",
         `Rangos de edad o edades simples` %in% c("(01 a 05)", "Menores de un año"))

# ================================================
# Agrupar, sumar y recalcular la tasa unificando rangos de edad
# ================================================

delito_sexual_sumado <- delito_sexual %>%
  group_by(codmpio, anno, `Nombre del indicador`) %>%
  summarise(casos = sum(casos, na.rm = TRUE),          
            denominador = sum(denominador, na.rm = TRUE)) %>%
  mutate(sexual = (casos / denominador) * 100000,  # Recalcular la tasa
         `Rangos de edad o edades simples` = "(0 a 5)") %>%
  ungroup()

# ================================================
# Exportar resultado a Excel
# ================================================

write.xlsx(delito_sexual_sumado, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_10.2.xlsx", colNames = TRUE)

# Fin del Código
