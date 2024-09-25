# ================================================
# YA 8.4
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

# Definir la lista de años
years <- 2015:2023

# Leer los archivos en un solo paso usando lapply
procu_list <- lapply(years, function(year) {
  read_excel(paste0("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_", year, ".xlsx"), 
             sheet = "Ind. Violencia Interpersonal", 
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

# ================================================
# Filtrar columnas y renombrar variables
# ================================================

# Seleccionar columnas necesarias
procuraduria <- procuraduria[, .(codmpio = `Código Municipio`, 
                                 anno = `Periodo del Indicador`, 
                                 `Nombre del indicador`, 
                                 `Rangos de edad o edades simples`, 
                                 casos = `Numerador (casos)`, 
                                 denominador = `Denominador (Población)`, 
                                 interpersonal = `Resultado (Tasa)`)]

# Extraer solo los primeros 4 dígitos del año
procuraduria$anno <- str_sub(procuraduria$anno, 1, 4)

# ================================================
# Filtrar por el indicador y los rangos de edad, incluyendo menores de un año
# ================================================

interpersonal <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de violencia interpersonal contra niños, niñas y adolescentes")

# ================================================
# Agrupar, sumar y recalcular la tasa unificando rangos de edad
# ================================================

interpersonal_sumado <- interpersonal %>%
  group_by(codmpio, anno, `Nombre del indicador`) %>%  # Agrupamos por municipio y año
  summarise(casos = sum(casos, na.rm = TRUE),          # Sumamos los casos
            denominador = sum(denominador, na.rm = TRUE)) %>%  # Sumamos el denominador
  mutate(interpersonal = (casos / denominador) * 100000)  # Recalculamos la tasa

# Ajuste final Nombre Variables

intrapersonal_sumado <- intrafamiliar_sumado %>%
  rename(numerador = casos)

# ================================================
# Exportar resultado a Excel
# ================================================

write.xlsx(interpersonal_sumado, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_8.4.xlsx", colNames = TRUE)

# Fin del Código
