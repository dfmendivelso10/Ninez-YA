

# ============================================================
# YA 5. Juego
# ============================================================

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))

# Paquetes

library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)
library(tidyr)



main_2023 <- read_dta("Downloads/Variables diseno muestral/muestral_2023.DTA")

atencion_2023 <- read_dta("D:/enfluj.dta")



# En este paso vamos a delimitar la Base de Datos, además vamos a eliminar los duplicados, en este caso los duplicados  y hacer el join en una sola línea

ECV_2023 <- atencion_2023 %>%
  select(1:6) %>%  # Selecciona las primeras 6 columnas
  left_join(                                         
    main_2023 %>% distinct(DIRECTORIO, .keep_all = TRUE),  # Elimina duplicados en `main_2023`
    by = "DIRECTORIO"
  ) %>%
  mutate(codmpio = as.numeric(substr(MPIO, 1, ifelse(nchar(MPIO) >= 2, 2, 1))))  %>% # Crea codmpio tomando los primeros caracteres de MPIO
  select(5,6,17)


# Calcular el porcentaje ponderado de cada categoría de P51 para cada codmpio
porcentaje_ponderado <- ECV_2023 %>%
  group_by(codmpio, P51) %>%  # Agrupar por codmpio y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C.x, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()  # Desagrupar el resultado final


write.xlsx(porcentaje_ponderado, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/juego.xlsx", col_names = TRUE)