
# ================================================
# YA 10
# ================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)


# Establecer la ruta de la carpeta donde están los archivos
carpeta <- "/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/Desaparicion.csv"

# Obtener la lista de archivos CSV en la carpeta

archivos <- list.files(path = carpeta, pattern = "verdata-desaparicion-R.*\\.csv", full.names = TRUE)

# Leer y combinar todos los archivos en un solo data frame

desaparicion <- archivos %>%
  lapply(read.csv) %>%   # Leer cada archivo CSV
  bind_rows()            # Combinar todos los data frames
