# ============================================================
# YA 1.4 Proporción de nacidos vivos con 4 o más controles prenatales
# ============================================================

# Librerías necesarias
install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))

library(dplyr)
library(openxlsx)
library(readxl)
library(tidyr)
library(stringr)

# Cargar bases de datos

YA_1.4 <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/YA_1.4.xlsx")
nacidos_vivos <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/nacidos_vivos.xlsx")

# Limpieza de datos
YA_1.4 <- YA_1.4[, -21] %>%
  mutate(codmpio = str_replace(codmpio, " - .*", "")) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "controles_prenatales") %>%
  mutate(codmpio = as.numeric(codmpio), anno = as.numeric(anno))

# Merge de datos
YA_1.4 <- inner_join(nacidos_vivos, YA_1.4, by = c("codmpio", "anno")) %>%
  mutate(proporcion_controles_prenatales = (controles_prenatales / nacimientos) * 100) %>%
  rename(numerador = controles_prenatales, denominador = nacimientos) %>%
  select(codmpio, anno, denominador, numerador, proporcion_controles_prenatales)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "proporcion_controles_prenatales"),
  Descripción = c("Código del municipio", "Año", "Denominador", "Numerador", "Proporción calculada"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep("…", 5)
)

# Crear y guardar workbook con dos hojas
wb <- createWorkbook()
addWorksheet(wb, "YA_1.4")
addWorksheet(wb, "metadatados")
write.xlsx(list(YA_1.4 = YA_1.4, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.4_metadatados.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Exportamos la Versión Final de Nuestro Indicador
write.xlsx(YA_1.4, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.4.xlsx", col_names = TRUE)

# Fin del código

