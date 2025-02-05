# ============================================================
# YA 1.3 Mortalidad en niños menores de 5 años
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
YA_1.3 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/YA_1.3.xlsx")
total_menores_5 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/menores_5_años.xlsx")

# Limpieza de datos
YA_1.3 <- YA_1.3 %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "mortalidad_menores_5") %>%
  mutate(codmpio = as.character(codmpio), anno = as.numeric(anno))

total_menores_5 <- total_menores_5 %>%
  mutate(
    codmpio = as.character(codmpio),
    anno = as.numeric(anno),
    total_menores_5 = limpiar_numeros(total_menores_5)  # Limpieza de valores numéricos
  )

# Merge de datos
YA_1.3_VF <- inner_join(total_menores_5, YA_1.3, by = c("codmpio", "anno")) %>%
  mutate(tasa_mortalidad_menores_5 = ifelse(
    total_menores_5 > 0 & mortalidad_menores_5 <= total_menores_5,
    (mortalidad_menores_5 / total_menores_5) * 1000,
    NA
  )) %>%
  rename(numerador = mortalidad_menores_5, denominador = total_menores_5) %>%
  select(codmpio, anno, denominador, numerador, tasa_mortalidad_menores_5)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "tasa_mortalidad_menores_5"),
  Descripción = c("Código del municipio", "Año", "Denominador", "Numerador", "Valor calculado"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.3_VF, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.3.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del código

