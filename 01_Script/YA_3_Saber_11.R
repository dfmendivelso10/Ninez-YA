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


# Cargamos los Datos

X2016 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2016.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2017 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2017.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2018 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2018.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2019 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2019.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2020 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2020.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2021 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2021.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

# Del 2022 en adelante el separador cambia ¬

X20221 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2022.1.txt", delim = "¬", escape_double = FALSE, trim_ws = TRUE)

X20222 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2022.2.txt", delim = "¬", escape_double = FALSE, trim_ws = TRUE)

X20231 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2023.1.txt", delim = "¬", escape_double = FALSE, trim_ws = TRUE)

X20232 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2023.2.txt", delim = "¬", escape_double = FALSE, trim_ws = TRUE)

## Convertimos los Datos a data.table * Es más eficiente con el uso de la memoria

X2016 <- as.data.table(X2016)
X2017 <- as.data.table(X2017)
X2018 <- as.data.table(X2018)
X2019 <- as.data.table(X2019)
X2020 <- as.data.table(X2020)
X2021 <- as.data.table(X2021)
X20221 <- as.data.table(X20221)
X20222 <- as.data.table(X20222)
X20231 <- as.data.table(X20231)
X20232 <- as.data.table(X20232)

#======= Limpieza de Datos desde 2016 - 2021

# Usar rbindlist para concatenar todas las bases de datos
saber_11 <- rbindlist(list(X2016, X2017, X2018, X2019, X2020, X2021), fill = TRUE)

# Liberamos Memoria

rm(X2016, X2017, X2018, X2019, X2020, X2021)

saber_11 <- as.data.table(saber_11)

# Limpiamos las Bases  de Datos
saber_11 <- saber_11[ , -c(2:3, 5:13, 15:27)]

# Rename de Variables

saber_11 <- rename(saber_11, codmpio = codigodane_municipio, anno = periodo)

# Conservar solo los primeros 4 dígitos de la variable año * Esto es una pequeña correción

saber_11$anno <- substr(saber_11$anno, 1, 4)


# ================================================
# Calculamos el Promedio de la Prueba 2016-2021
# ================================================

promedios_por_municipio <- saber_11 %>%
  filter(!is.na(promedio_prueba), !is.na(codmpio)) %>% 
  group_by(anno, codmpio, nombre_prueba) %>%
  summarize(
    promedio_ponderado = sum(promedio_prueba * n_evaluados, na.rm = TRUE) / sum(n_evaluados, na.rm = TRUE)
  ) %>%
  ungroup()

# Ahora cambiamos de Long a Wide

datos_wide <- promedios_por_municipio %>%
  pivot_wider(names_from = nombre_prueba, values_from = promedio_ponderado)

# Creamos la variable total sumando los promedios

datos_wide <- datos_wide %>%
  mutate(total = ((3 * `LECTURA CRÍTICA` + 3 * `MATEMÁTICAS` + 3 * `SOCIALES Y CIUDADANAS` + 3 * `CIENCIAS NATURALES` + `INGLÉS`) / 13) * 5)


# Renombramos las Variables


datos_wide_2016_2021 <- datos_wide %>%
  rename(
    promedio_lectura_critica = `LECTURA CRÍTICA`,
    promedio_matematicas = `MATEMÁTICAS`,
    promedio_sociales_ciudadanas = `SOCIALES Y CIUDADANAS`,
    promedio_global = total
  )

# Filtramos solo los datos que nos interesan

datos_wide_2016_2021 <- datos_wide_2016_2021 %>% select(, c(1:2,5:8))

# ================================================
# Limpieza de Datos desde 2022 en adelante
# ================================================


# Primero Unimos las Bases de Datos 20221 : 20232

saber_11_2021_2023 <- rbindlist(list(X20221, X20222, X20231, X20232), fill = TRUE)

# Limpiamos las Bases  de Datos
saber_11_2021_2023  <- saber_11_2021_2023 [, c(5, 56, 60, 63, 69, 75)]

# Rename de Variables

saber_11_2021_2023  <- rename(saber_11_2021_2023 , codmpio = ESTU_COD_MCPIO_PRESENTACION, anno = PERIODO)

# Conservar solo los primeros 4 dígitos de la variable año * Esto es una pequeña correción

saber_11_2021_2023 $anno <- substr(saber_11_2021_2023 $anno, 1, 4)


# La variable codmpio en esta base de datos no es float, así que ajustaremos eso

saber_11_2021_2023$codmpio <- as.numeric(saber_11_2021_2023$codmpio)


# ====================================================
# Calculamos el Promedio de la Prueba 2022 en adelante
# ====================================================

datos_wide_2021_2023 <- saber_11_2021_2023 %>%
  filter(!is.na(codmpio)) %>%
  group_by(codmpio, anno) %>%
  summarise(
    promedio_lectura_critica = mean(PUNT_LECTURA_CRITICA, na.rm = TRUE),
    promedio_matematicas = mean(PUNT_MATEMATICAS, na.rm = TRUE),
    promedio_sociales_ciudadanas = mean(PUNT_SOCIALES_CIUDADANAS, na.rm = TRUE),
    promedio_global = mean(PUNT_GLOBAL, na.rm = TRUE)
  )

# Ajustamos el Orden de las variables

datos_wide_2021_2023 <- datos_wide_2021_2023 %>% select(, c(2,1,3,4,5,6))

# ====================================================
# Unificamos las Bases de Datos 
# ====================================================

resultados_saber_11 <- rbindlist(list(datos_wide_2016_2021 , datos_wide_2021_2023), fill = TRUE)


resultados_saber_11 <- resultados_saber_11 %>% rename(lectura = promedio_lectura_critica, matematicas = promedio_matematicas, global = promedio_global, sociales = promedio_sociales_ciudadanas)
###########################################################################################################################

## Ahora creamos los Distintos Ya 

español <- resultados_saber_11 %>%
  select(anno, codmpio, `lectura`)

matematicas <- resultados_saber_11 %>%
  select(anno, codmpio, `matematicas`)

sociales <- resultados_saber_11 %>%
  select(anno, codmpio, `sociales`)

global <- resultados_saber_11 %>%
  select(anno, codmpio, `global`)

## Exportamos los Datos

write.xlsx(matematicas, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.1.xlsx", col_names = TRUE)

write.xlsx(español, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.2.xlsx", col_names = TRUE)

write.xlsx(sociales, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.3.xlsx", col_names = TRUE)

write.xlsx(global, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.4.xlsx", col_names = TRUE)


