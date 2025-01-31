# ============================================================
# YA 1.9 Tasa de Mortalidad por Desnutrición en menores 5 años
# ============================================================

# Librerías necesarias
install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))

library(dplyr)
library(openxlsx)
library(readxl)
library(tidyr)
library(stringr)

# Cargar bases de datos
YA_1.9 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/desnutricion_menores_5.xlsx")
total_menores_5 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/menores_5_años.xlsx")

# Limpieza del numerador
YA_1.9 <- YA_1.9 %>%
  mutate(codmpio = str_replace(codmpio, " - .*", "")) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "mortalidad_desnutricion_5") %>%
  mutate(codmpio = as.numeric(codmpio), anno = as.numeric(anno))

total_menores_5 <- total_menores_5 %>%
  mutate(codmpio = as.numeric(codmpio), anno = as.numeric(anno))

# Merge de datos
YA_1.9 <- inner_join(total_menores_5, YA_1.9, by = c("codmpio", "anno")) %>%
  mutate(tasa_mortalidad_desnutricion_5_años = ifelse(
    total_menores_5 > 0 & mortalidad_desnutricion_5 <= total_menores_5,
    (mortalidad_desnutricion_5 / total_menores_5) * 100000,
    NA
  )) %>%
  rename(numerador = mortalidad_desnutricion_5, denominador = total_menores_5) %>%
  select(codmpio, anno, denominador, numerador, tasa_mortalidad_desnutricion_5_años)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "tasa_mortalidad_desnutricion_5_años"),
  Descripción = c("Código del municipio", "Año", "Denominador", "Numerador", "Valor calculado"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep("…", 5)
)

# Crear y guardar workbook con dos hojas
wb <- createWorkbook()
addWorksheet(wb, "YA_1.9")
addWorksheet(wb, "metadatados")
write.xlsx(list(YA_1.9 = YA_1.9, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.9_metadatados.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del código
