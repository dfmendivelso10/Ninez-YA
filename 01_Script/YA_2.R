

# ================================================
# YA 2 Nuevos Indicadores Educación Inicial 
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
  mutate(FECHA = dmy(FECHA),   # Convertir la fecha de texto a formato Date
         Año = year(FECHA))     # Extraemos el año y ya no tenemos día ni mes

# Eliminamos Variables que no Necesitamos

educ_inicial <- educ_inicial %>%
  select(-1:-5,-7) # Acá Eliminamos las Primeras 5 columnas y la columna número 7

# Renombramos algunas variables

educ_inicial  <- educ_inicial  %>%
  rename(anno = Año)

educ_inicial  <- educ_inicial  %>%
  rename(codmpio = COD_DANE_MUNICIPIO)

# ================================================
# Creación de Sub - Data Sets
# ================================================




