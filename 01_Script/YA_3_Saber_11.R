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

## Convertimos los Datos a data.table * Es más eficiente con el uso de la memoria

X2016 <- as.data.table(X2016)
X2017 <- as.data.table(X2017)
X2018 <- as.data.table(X2018)
X2019 <- as.data.table(X2019)
X2020 <- as.data.table(X2020)
X2021 <- as.data.table(X2021)

# Usar rbindlist para concatenar todas las bases de datos
saber_11 <- rbindlist(list(X2016, X2017, X2018, X2019, X2020, X2021), fill = TRUE)


# Limpiamos las Bases  de Datos
saber_11 <- saber_11[ , -c(2:3, 5:13, 15:27)]


# Rename de Variables

saber_11 <- rename(saber_11, codmpio = codigodane_municipio, anno = periodo)

# Conservar solo los primeros 4 dígitos de la variable año * Esto es una pequeña correción

saber_11$anno <- substr(saber_11$anno, 1, 4)



promedios_por_municipio <- saber_11 %>%
  filter(!is.na(promedio_prueba)) %>%  # Filtrar datos con promedio_prueba no NA
  group_by(anno, codmpio, nombre_prueba) %>%
  summarize(
    promedio_ponderado = sum(promedio_prueba * n_evaluados, na.rm = TRUE) / sum(n_evaluados, na.rm = TRUE)
  ) %>%
  ungroup()

# Ver el resultado
print(promedios_por_municipio)

