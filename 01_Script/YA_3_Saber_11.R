# ================================================
# YA 3 Saber 11
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


# Cargar los Datos

X2016 <- read_delim("Downloads/Raw_DATA/2016.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2017 <- read_delim("Downloads/Raw_DATA/2017.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2018 <- read_delim("Downloads/Raw_DATA/2018.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2019 <- read_delim("Downloads/Raw_DATA/2019.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2020 <- read_delim("Downloads/Raw_DATA/2020.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2021 <- read_delim("Downloads/Raw_DATA/2021.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)



# Limpiamos las Bases  de Datos

X2016 <- X2016[ , -c(2:3,5:13,15:27)]
X2017 <- X2017[ , -c(2:3,5:13,15:27)]
X2018 <- X2018[ , -c(2:3,5:13,15:27)]
X2019 <- X2019[ , -c(2:3,5:13,15:27)]
X2020 <- X2020[ , -c(2:3,5:13,15:27)]
X2021 <- X2021[ , -c(2:3,5:13,15:27)]

# Rename de Variables

X2016 <- rename(X2016, codmpio = codigodane_municipio, anno = periodo)
X2017 <- rename(X2017, codmpio = codigodane_municipio, anno = periodo)
X2018 <- rename(X2018, codmpio = codigodane_municipio, anno = periodo)
X2019 <- rename(X2019, codmpio = codigodane_municipio, anno = periodo)
X2020 <- rename(X2020, codmpio = codigodane_municipio, anno = periodo)
X2021 <- rename(X2021, codmpio = codigodane_municipio, anno = periodo)

# Colapsa la Memoria, vamos a manejarlo como data.table

install.packages("data.table")
library(data.table)


# Merge de Bases


# Definir las columnas clave para hacer el merge
columnas_clave <- c("anno", "codmpio", "nombre_prueba")

# Usar Reduce para combinar las bases de datos de X2016 a X2021 usando las columnas clave
saber_11 <- Reduce(function(x, y) merge(x, y, by = columnas_clave, all = TRUE), list(X2016, X2017, X2018, X2019, X2020, X2021))


# Calcular el promedio ponderado por codigodane_municipio y nombre_prueba

promedios_por_municipio <- X2016 %>%
  filter(!is.na(promedio_prueba)) %>%  # Filtrar datos con promedio_prueba no NA
  group_by(codigodane_municipio, nombre_prueba) %>%
  summarize(
    promedio_ponderado = sum(promedio_prueba * n_evaluados, na.rm = TRUE) / sum(n_evaluados, na.rm = TRUE)
  ) %>%
  ungroup()

# Ver el resultado
print(promedios_por_municipio)

