
# ================================================
# YA 3 Saber 11
# ================================================
# Librerías y Paquetes

library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)
library(data.table)
library(readr)


# Lectura de los archivos de 2016 a 2023


X2016.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2016.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2016.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2016.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)


X2017.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2017.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2017.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2017.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2018.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2018.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2018.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2018.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2019.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2019.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2019.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2019.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2020.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2020.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2020.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2020.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2021.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2021.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2021.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2021.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2022.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2022.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2022.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2022.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2023.1 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2023.1.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

X2023.2 <- read_delim("/Users/daniel/Documents/Raw_ICFES/2023.2.txt", 
                      delim = "¬", escape_double = FALSE, 
                      trim_ws = TRUE)

# Juntar todas las bases de datos en un solo DataFrame
X_total <- rbindlist(list(X2016.1, X2016.2, X2017.1, X2017.2, 
                          X2018.1, X2018.2, X2019.1, X2019.2, 
                          X2020.1, X2020.2, X2021.1, X2021.2, 
                          X2022.1, X2022.2, X2023.1, X2023.2), fill = TRUE)

# Filtrar, renombrar, convertir codmpio a numérico y modificar anno
X_filtrada <- X_total %>%
  select(PERIODO, ESTU_COD_MCPIO_PRESENTACION, ESTU_CONSECUTIVO, 
         PUNT_LECTURA_CRITICA, PUNT_MATEMATICAS, PUNT_SOCIALES_CIUDADANAS, 
         PUNT_C_NATURALES, PUNT_INGLES, PUNT_GLOBAL) %>%
  rename(anno = PERIODO, codmpio = ESTU_COD_MCPIO_PRESENTACION) %>%
  mutate(codmpio = as.numeric(codmpio),
         anno = substr(anno, 1, 4))


# Eliminar todas las variables que comienzan con "X2016", "X2017", ..., "X2023"

rm(list = ls(pattern = "^X20[1-2][0-9]"))


promedio_puntaje_global <- X_filtrada %>%
  # Filtrar para eliminar filas donde anno o codmpio sean NA
  filter(!is.na(anno) & !is.na(codmpio)) %>%
  # Calcular el puntaje global para cada observación
  mutate(global = ((PUNT_LECTURA_CRITICA * 3) + 
                     (PUNT_MATEMATICAS * 3) + 
                     (PUNT_SOCIALES_CIUDADANAS * 3) + 
                     (PUNT_C_NATURALES * 3) + 
                     PUNT_INGLES) / 13 * 5) %>%
  # Agrupar por anno y codmpio
  group_by(anno, codmpio) %>%
  # Calcular el promedio del puntaje global
  summarise(promedio_puntaje_global = mean(global, na.rm = TRUE))

# ==============================================================================
# Cálculos Promedio Simple por Áreas
# ==============================================================================

# Calcular el promedio simple para la prueba de lectura utilizando el nombre correcto de la columna

espanol <- X_filtrada %>%
  group_by(anno, codmpio) %>%
  summarise(promedio_lectura = mean(PUNT_LECTURA_CRITICA, na.rm = TRUE))


# Calcular el promedio simple para la prueba de matemáticas
matematicas <- X_filtrada %>%
  group_by(anno, codmpio) %>%
  summarise(promedio_matematicas = mean(PUNT_MATEMATICAS, na.rm = TRUE))

# Calcular el promedio simple para la prueba de sociales
sociales <- X_filtrada %>%
  group_by(anno, codmpio) %>%
  summarise(promedio_sociales = mean(PUNT_SOCIALES_CIUDADANAS, na.rm = TRUE))

# Exportar los datos a archivos Excel
write.xlsx(matematicas, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.1.xlsx", colNames = TRUE)
write.xlsx(espanol, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.2.xlsx", colNames = TRUE)
write.xlsx(sociales, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.3.xlsx", colNames = TRUE)
write.xlsx(promedio_puntaje_global, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.4.xlsx", col_names = TRUE)



