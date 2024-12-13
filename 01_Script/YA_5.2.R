

# ============================================================
# YA 5. Juego
# ============================================================

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate","data.table"))

# Paquetes

library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)
library(tidyr)
library(haven)

#==========================
# Importamos la Data
#==========================

# 2019

main_2019 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/main_2019.dta")

integral_2019 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2019.dta")

# 2020

main_2020 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/main_2020.dta")

integral_2020 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2020.dta")

# 2021

main_2021 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/main_2021.dta")

integral_2021 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2021.dta")

# 2021

main_2022 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/main_2022.dta")

integral_2022 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2022.dta")

colnames(integral_2022)


#===============================================
# Vamos a hacer el Join entre main e integral
#==============================================

ecv_2019 <- integral_2019 %>%
  select(1:4, 'FEX_C', 'P779S5') %>%  # Selecciona las primeras 4 columnas de `integral_2019`
  left_join(
    main_2019 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )


ecv_2020 <- integral_2020 %>%
  select(1:5, 'P779S5') %>%  # Selecciona las primeras 5 columnas de `integral_2019`
  left_join(
    main_2020 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )

## No hice un loop porque el nombre de las variables en algunos casos cambia o también el orden de la variable
# en el dataset


ecv_2021 <- integral_2021 %>%
  select(1:5, 'p779s5') %>%  # Selecciona las primeras 5 columnas de `integral_2021`
  left_join(
    main_2021 %>% 
      select(directorio, p1_departamento),  # Selecciona `directorio` y `p1_departamento` de `main_2021`
    by = "directorio"  # Realiza la unión usando `directorio`
  ) %>%
  rename(DIRECTORIO = directorio, P1_DEPARTAMENTO = p1_departamento, FEX_C = fex_c, P779S5 = p779s5)  # Renombra las columnas después de la unión


ecv_2022 <- integral_2022 %>%
  select(1:5, 'P779S5') %>%  # Selecciona las primeras 5 columnas de `integral_2019`
  left_join(
    main_2022 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )


#===============================================================================
# Calcular el porcentaje ponderado de cada categoría de P51 para cada codmpio
#===============================================================================

ecv_2019 <- ecv_2019 %>%
  group_by(P1_DEPARTAMENTO, P779S5) %>%  # Agrupar por coddepto y categoría de P779S5S5
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100, # Calcular el porcentaje
         anno = 2019) %>%  
  ungroup() %>%
  mutate(P779S5 = replace_na(P779S5, 0))  # Reemplazar NA con 0


ecv_2020 <- ecv_2020 %>%
  group_by(P1_DEPARTAMENTO, P779S5) %>%  # Agrupar por coddepto y categoría de P779S5S5
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100, # Calcular el porcentaje
         anno = 2020) %>%  
  ungroup() %>%
  mutate(P779S5 = replace_na(P779S5, 0))  # Reemplazar NA con 0


ecv_2021 <- ecv_2021 %>%
  group_by(P1_DEPARTAMENTO, P779S5) %>%  # Agrupar por coddepto y categoría de P779S5S5
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100, # Calcular el porcentaje
         anno = 2021) %>%  
  ungroup() %>%
  mutate(P779S5 = replace_na(P779S5, 0))  # Reemplazar NA con 0


ecv_2022 <- ecv_2022 %>%
  group_by(P1_DEPARTAMENTO, P779S5) %>%  # Agrupar por coddepto y categoría de P779S5S5
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100, # Calcular el porcentaje
         anno = 2022) %>%  
  ungroup() %>%
  mutate(P779S5 = replace_na(P779S5, 0))  # Reemplazar NA con 0

# Vamos a agrupar estos años

# Primero vamos a eliminar los labels en caso de que haya un conflicto:
# Quitar labels de cada base de datos individualmente

ecv_2019 <- haven::zap_labels(ecv_2019)
ecv_2020 <- haven::zap_labels(ecv_2020)
ecv_2021 <- haven::zap_labels(ecv_2021)
ecv_2022 <- haven::zap_labels(ecv_2022)

# Hacemos el Append de las Bases de Datos

ecv_2019_2022 <- bind_rows(ecv_2019, ecv_2020, ecv_2021, ecv_2022)

# Ajustamos el nombre de la variable codmpio por coddepto, ya que esta base de datos
# tiene un nivel de desagregación departamental.

ecv_2019_2022 <- ecv_2019_2022 %>% rename(coddepto = P1_DEPARTAMENTO)

# Limpiamos un poco el envioronment

rm(ecv_2019, ecv_2020, ecv_2021, ecv_2022, integral_2019, integral_2020, integral_2021, integral_2022, main_2019,
   main_2020, main_2021, main_2022)

# ==================================
#  ECV - 2023 *Tiene Otra estructura
# ==================================


main_2023 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/muestral_2023.dta")

integral_2023 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2023.dta")


# En este paso vamos a delimitar la Base de Datos, además vamos a eliminar los duplicados, en este caso los duplicados  y hacer el join en una sola línea

ecv_2023 <- integral_2023 %>%
  select(1:5, 'P779S5') %>%  # Selecciona las primeras 5 columnas
  left_join(                                         
    main_2023 %>% distinct(DIRECTORIO, .keep_all = TRUE),  # Elimina duplicados en `main_2023`
    by = "DIRECTORIO"
  ) %>%
  mutate(codmpio = as.numeric(substr(MPIO, 1, ifelse(nchar(MPIO) >= 2, 2, 1))))  %>% # Crea codmpio tomando los primeros caracteres de MPIO
  select(5,'P779S5',17)


# Calcular el porcentaje ponderado de cada categoría de 'P779S5 para cada codmpio

ecv_2023 <- ecv_2023  %>%
  group_by(codmpio, 'P779S5') %>%  # Agrupar por codmpio y categoría de 'P779S5
  summarise(frecuencia_ponderada = sum(FEX_C.x, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100, # Calcular el porcentaje
         anno = 2023) %>%  
  ungroup()  # Desagrupar el resultado final

# Renombramos codmpio a coddepto,la razón, acá tenemos desagregación departamental no municipal.
ecv_2023 <- ecv_2023 %>%
  rename(coddepto = codmpio)                    

# Limpiamos el enviornment

rm(main_2023, integral_2023)

# ==============================================================================
# Hacemos el Append Final de las Bases de Datos
# ==============================================================================

# Convertir coddepto a character en ambas bases de datos

ecv_2019_2022$coddepto <- as.character(ecv_2019_2022$coddepto)
ecv_2023$coddepto <- as.character(ecv_2023$coddepto)

# Unir las bases de datos

ecv_P779S5 <- bind_rows(ecv_2019_2022, ecv_2023)

# Definimos la Base de datos

ecv_P779S5 <- ecv_P779S5 %>% select(c(1,5,2,4))


# Exportamos

write.xlsx(ecv_P779S5, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_5.2.xlsx", col_names = TRUE)

