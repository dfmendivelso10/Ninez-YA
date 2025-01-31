# ============================================================
# YA 1.6 Proporción de nacidos vivos con Bajo Peso al Nacer
# ============================================================

# Librerías necesarias
install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))

library(dplyr)
library(openxlsx)
library(readxl)
library(tidyr)
library(stringr)

# Cargar bases de datos
YA_1.6 <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/YA_1.6.xlsx")
nacidos_vivos <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/nacidos_vivos.xlsx")

# Limpieza de datos
YA_1.6 <- YA_1.6[, -21] %>%
  mutate(codmpio = str_replace(codmpio, " - .*", "")) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "bajo_peso_nacer") %>%
  mutate(codmpio = as.numeric(codmpio), anno = as.numeric(anno))

# Merge de datos
YA_1.6 <- inner_join(nacidos_vivos, YA_1.6, by = c("codmpio", "anno")) %>%
  mutate(proporcion_bajo_peso_nacer = (bajo_peso_nacer / nacimientos) * 100) %>%
  rename(numerador = bajo_peso_nacer, denominador = nacimientos) %>%
  select(codmpio, anno, denominador, numerador, proporcion_bajo_peso_nacer)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "proporcion_bajo_peso_nacer"),
  Descripción = c("Código del municipio", "Año", "Denominador", "Numerador", "Proporción calculada"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep("…", 5)
)

# Crear y guardar workbook con dos hojas
wb <- createWorkbook()
addWorksheet(wb, "YA_1.6")
addWorksheet(wb, "metadatados")
write.xlsx(list(YA_1.6 = YA_1.6, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.6_metadatados.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del código