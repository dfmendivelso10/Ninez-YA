

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



main_2019 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/main_2019.dta")

integral_2019 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2019.dta")



# Vamos a hacer el join


# Realizar la selección de columnas y la unión dentro del mismo flujo `pipe`
ecv_2019 <- integral_2019 %>%
  select(1:5,55) %>%  # Selecciona las primeras 5 columnas de `integral_2019`
  left_join(
    main_2019 %>% select(DIRECTORIO, P1_DEPARTAMENTO),  # Selecciona `DIRECTORIO` y `P1_DEPARTAMENTO` de `main_2019`
    by = "DIRECTORIO"  # Realiza la unión usando `DIRECTORIO`
  )


# Calcular el porcentaje ponderado de cada categoría de P51 para cada codmpio

ecv_2019 <- ecv_2019 %>%
  group_by(P1_DEPARTAMENTO, P51) %>%  # Agrupar por coddepto y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()  # Desagrupar el resultado final


write.xlsx(porcentaje_ponderado, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/juego.xlsx", col_names = TRUE)