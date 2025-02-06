# ============================================================
# YA 1.4 Proporción de nacidos vivos con 4 o más controles prenatales
# ============================================================

# Instalar y cargar librerías necesarias
if (!requireNamespace("openxlsx", quietly = TRUE)) install.packages("openxlsx")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")

library(dplyr)
library(openxlsx)
library(readxl)
library(tidyr)
library(stringr)

# Función para limpiar valores numéricos eliminando "," y "."
limpiar_numeros <- function(x) {
  x <- gsub("[,.]", "", as.character(x))  # Remueve comas y puntos
  as.numeric(x)  # Convierte a numérico
}

# Cargar bases de datos
YA_1.4 <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/YA_1.4.xlsx")
nacidos_vivos <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/nacidos_vivos.xlsx")

# Limpieza de datos
YA_1.4 <- YA_1.4[, -22] %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "controles_prenatales") %>%
  mutate(codmpio = as.numeric(codmpio), anno = as.numeric(anno))

nacidos_vivos <- nacidos_vivos %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno),
    nacimientos = limpiar_numeros(nacimientos)  # Limpieza de valores numéricos
  )

# Merge de datos con condicional
YA_1.4 <- inner_join(nacidos_vivos, YA_1.4, by = c("codmpio", "anno")) %>%
  mutate(
    proporcion_controles_prenatales = ifelse(controles_prenatales > nacimientos, NA, (controles_prenatales / nacimientos) * 100),
    numerador = controles_prenatales,
    denominador = nacimientos
  ) %>%
  select(codmpio, anno, denominador, numerador, proporcion_controles_prenatales)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "proporcion_controles_prenatales"),
  Descripción = c("Código del municipio", "Año", "Denominador", "Numerador", "Proporción calculada"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.4, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.4.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del código
