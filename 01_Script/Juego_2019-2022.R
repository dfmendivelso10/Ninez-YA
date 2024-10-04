

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


#===============================================
# Vamos a hacer el Join entre main e integral
#==============================================

ecv_2019 <- integral_2019 %>%
  select(1:5,55) %>%  # Selecciona las primeras 5 columnas de `integral_2019`
  left_join(
    main_2019 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )


ecv_2020 <- integral_2020 %>%
  select(1:6) %>%  # Selecciona las primeras 5 columnas de `integral_2019`
  left_join(
    main_2020 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )

## No hice un loop porque el nombre de las variables en algunos casos cambia o también el orden de la variable
# en el dataset

ecv_2021 <- integral_2021 %>%
  select(1:6) %>%  # Selecciona las primeras 6 columnas de `integral_2021`
  left_join(
    main_2021 %>% 
      select(directorio, p1_departamento),  # Selecciona `directorio` y `p1_departamento` de `main_2021`
    by = "directorio"  # Realiza la unión usando `directorio`
  ) %>%
  rename(DIRECTORIO = directorio, P1_DEPARTAMENTO = p1_departamento, P51 = p51, FEX_C = fex_c)  # Renombra las columnas después de la unión


ecv_2022 <- integral_2022 %>%
  select(1:6) %>%  # Selecciona las primeras 5 columnas de `integral_2019`
  left_join(
    main_2022 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )


#===============================================================================
# Calcular el porcentaje ponderado de cada categoría de P51 para cada codmpio
#===============================================================================

ecv_2019 <- ecv_2019 %>%
  group_by(P1_DEPARTAMENTO, P51) %>%  # Agrupar por coddepto y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()

   select()# Desagrupar el resultado final

ecv_2020 <- ecv_2020 %>%
  group_by(P1_DEPARTAMENTO, P51) %>%  # Agrupar por coddepto y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()  # Desagrupar el resultado final

ecv_2021 <- ecv_2021 %>%
  group_by(P1_DEPARTAMENTO, P51) %>%  # Agrupar por coddepto y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()  # Desagrupar el resultado final

ecv_2022 <- ecv_2022 %>%
  group_by(P1_DEPARTAMENTO, P51) %>%  # Agrupar por coddepto y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()  # Desagrupar el resultado final


# Exportamos
write.xlsx(ecv_2019, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/juego.xlsx", col_names = TRUE)