

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


# Función ajustada para manejar diferentes nombres de la columna
read_and_prepare <- function(file, sheet, year) {
  data <- read_excel(file, sheet = sheet, col_names = TRUE) %>%
    select(-starts_with("...")) %>%  # Eliminar columnas sin nombre
    
    # Manejar diferencias en el nombre de la columna `Periodo del Indicador`
    mutate(`Periodo del Indicador` = if ("Periodo del Indicador" %in% colnames(.)) {
      as.character(`Periodo del Indicador`)
    } else if ("Periodo del indicador" %in% colnames(.)) {
      as.character(`Periodo del indicador`)
    } else {
      NA  # Si no existe, crear la columna con NA
    },
    ano = year)  # Agregar la columna del año
  
  return(data)
}

# Cargamos los datos ajustados con la hoja "Ind. Patología"
procu_2015 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2015.xlsx", "Ind. Patología", 2015)
procu_2016 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2016.xlsx", "Ind. Patología", 2016)
procu_2017 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2017.xlsx", "Ind. Patología", 2017)
procu_2018 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2018.xlsx", "Ind. Patología", 2018)
procu_2019 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2019.xlsx", "Ind. Patología", 2019)
procu_2020 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2020.xlsx", "Ind. Patología", 2020)
procu_2021 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2021.xlsx", "Ind. Patología", 2021)
procu_2022 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2022.xlsx", "Ind. Patología", 2022)
procu_2023 <- read_and_prepare("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2023.xlsx", "Ind. Patología", 2023)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Usamos rbindlist para combinar los dataframes y permitir columnas faltantes
procuraduria <- rbindlist(list(procu_2015, procu_2016, procu_2017, procu_2018, procu_2019, procu_2020, procu_2021, procu_2022, procu_2023), fill = TRUE)

# Limpiamos Memoria
rm(procu_2015, procu_2016, procu_2017, procu_2018, procu_2019, procu_2020, procu_2021, procu_2022, procu_2023)


# Dejamos solo las variables necesarias

procuraduria <- procuraduria[, c(2, 4, 6, 7, 8, 9, 10)]


# Rename de Variables

procuraduria   <- rename(procuraduria , codmpio = `Código Municipio`, anno = `Periodo del Indicador`)


# ====================================================
# Sección: Filtrar 
# ====================================================


homicidios <- procuraduria %>%
  filter(str_trim(`Nombre del indicador`) == "Tasa de Homicidios en niños, niñas y adolescentes",
         `Rangos de edad o edades simples` == "(01 a 05)")



homicidios$`Rangos de edad o edades simples`
homicidios <- homicidios[, c(1,3,5,6,7)]


homicidios <- rename(homicidios , casos = `Numerador (casos)`, denominador = `Denominador (Población)`, homicidios = `Resultado (Tasa)` )

# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(homicidios, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_10.1.xlsx", col_names = TRUE)

# Fin del Código


