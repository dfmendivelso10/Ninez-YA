

# ================================================
# YA 8.3 Tasa de violencia intrafamiliar en niños y niñas de 0 a 5 años
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table"))


library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)

# ================================================
# Cargar datos
# ================================================

# Definir la lista de años
years <- 2015:2023

# Leer los archivos de Excel en un solo paso usando lapply
procu_list <- lapply(years, function(year) {
  read_excel(paste0("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_", year, ".xlsx"), 
             sheet = "Ind. Violencia Intrafamiliar", 
             na = "N/A")
})

# ================================================
# Estandarizar nombres y unir data frames
# ================================================

# Estandarizar nombre de la columna 'Periodo del indicador' y unir los data frames
procuraduria <- rbindlist(lapply(procu_list, function(df) {
  setnames(df, old = "Periodo del indicador", new = "Periodo del Indicador", skip_absent = TRUE)
  return(df)
}), fill = TRUE)

# Liberar memoria
rm(procu_list)

# ================================================
# Filtrar columnas necesarias y renombrar variables
# ================================================

# Seleccionar solo las columnas necesarias
procuraduria <- procuraduria[, .(codmpio = `Código Municipio`, 
                                 anno = `Periodo del Indicador`, 
                                 `Nombre del indicador`, 
                                 `Rangos de edad o edades simples`, 
                                 casos = `Numerador (casos)`, 
                                 denominador = `Denominador (Población)`, 
                                 intrafamiliar = `Resultado (Tasa)`)]

# Extraer los primeros 4 dígitos del año en la columna "anno"
procuraduria$anno <- str_sub(procuraduria$anno, 1, 4)

# ================================================
# Filtrar datos por el indicador y unificar rangos de edad
# ================================================

intrafamiliar <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de Violencia Intrafamiliar en niños, niñas y adolescentes",
         `Rangos de edad o edades simples` %in% c("(01 a 05)", "Menores de un año"))

# ================================================
# Agrupar, sumar y recalcular la tasa unificando rangos de edad
# ================================================

intrafamiliar_sumado <- intrafamiliar %>%
  group_by(codmpio, anno, `Nombre del indicador`) %>%
  summarise(casos = sum(casos, na.rm = TRUE),          
            denominador = sum(denominador, na.rm = TRUE)) %>%
  mutate(intrafamiliar = (casos / denominador) * 100000,  # Recalcular la tasa
         `Rangos de edad o edades simples` = "(0 a 5)") %>%
  ungroup()

# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(intrafamiliar_sumado, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_10.3.xlsx", colNames = TRUE)

# Fin del Código
