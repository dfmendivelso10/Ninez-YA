

# ================================================
# YA 4.4 Calidad del Aire
# ================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate", "fuzzyjoin"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)
library(fuzzyjoin)

# Importamos los Datos


id_aire <- read_excel("Documents/GitHub/Ninez-YA/03_Process/id_aire.xlsx")

aire <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/aire.csv")

# Limpiamos las Bases de Datos

aire <- aire[, c(1,2,3)]

# Eliminamos los espacios en blanco

aire$Estacion <- tolower(trimws(aire$Estacion))
id_aire$Estacion <- tolower(trimws(id_aire$Estacion))

# Realizar la coincidencia aproximada (fuzzy join) entre 'final' e 'ID' basado en los nombres de estaciones
aire <- stringdist_inner_join(aire, id_aire[, c("Estacion", "codmpio")], by = "Estacion", method = "jw", max_dist = 0.2, distance_col = "distancia")



# Importamos los Datos

write.xlsx(aire, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_4.2.xlsx", col_names = TRUE)