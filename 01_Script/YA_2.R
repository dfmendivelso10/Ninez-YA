

# ================================================
# YA 3 Educación Inicial 
# ================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)
library(lubridate) # Nos permite manejar fechas.

# Cargamos Nuestra Base 

educ_inicial <-  read.csv("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/Educacion_Inicial.csv")

# Limpiamos la Base de Datos

educ_inicial <- educ_inicial %>%
  mutate(FECHA = dmy(Fecha),   # Convertir la fecha de texto a formato Date
         Año = year(Fecha))     # Extraer el año