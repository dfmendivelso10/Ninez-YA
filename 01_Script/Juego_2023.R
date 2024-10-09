

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



main_2023 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/muestral_2023.dta")

integral_2023 <- read_dta("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ECV/integral_2023.dta")



# En este paso vamos a delimitar la Base de Datos, además vamos a eliminar los duplicados, en este caso los duplicados  y hacer el join en una sola línea

ecv_2023 <- integral_2023 %>%
  select(1:6) %>%  # Selecciona las primeras 6 columnas
  left_join(                                         
    main_2023 %>% distinct(DIRECTORIO, .keep_all = TRUE),  # Elimina duplicados en `main_2023`
    by = "DIRECTORIO"
  ) %>%
  mutate(codmpio = as.numeric(substr(MPIO, 1, ifelse(nchar(MPIO) >= 2, 2, 1))))  %>% # Crea codmpio tomando los primeros caracteres de MPIO
  select(5,6,17)


# Calcular el porcentaje ponderado de cada categoría de P51 para cada codmpio

ecv_2023 <- ecv_2023  %>%
  group_by(codmpio, P51) %>%  # Agrupar por codmpio y categoría de P51
  summarise(frecuencia_ponderada = sum(FEX_C.x, na.rm = TRUE)) %>%  # Calcular la suma ponderada
  mutate(porcentaje = frecuencia_ponderada / sum(frecuencia_ponderada) * 100) %>%  # Calcular el porcentaje
  ungroup()  # Desagrupar el resultado final

# Renombramos codmpio a coddepto,la razón, acá tenemos desagregación departamental no municipal.
ecv_2023 <- ecv_2023 %>%
  rename(coddepto = codmpio)                    

write.xlsx(porcentaje_ponderado, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/juego.xlsx", col_names = TRUE)