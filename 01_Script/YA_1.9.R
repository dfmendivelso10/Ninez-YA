# ============================================================
# YA 1.9 Tasa de Mortalidad por Desnutrición en Menores de 5 Años
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
YA_1.9 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/mortalidad_desnutricion_menores_5.xlsx")
total_menores_5 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/menores_5_años.xlsx")

# Limpieza de datos
YA_1.9 <- YA_1.9 %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "mortalidad_desnutricion_5") %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

total_menores_5 <- total_menores_5 %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno),
    total_menores_5 = limpiar_numeros(total_menores_5)  # Limpieza de valores numéricos
  )

# Unir bases de datos y calcular la tasa
YA_1.9 <- inner_join(total_menores_5, YA_1.9, by = c("codmpio", "anno")) %>%
  mutate(
    tasa_mortalidad_desnutricion_5 = ifelse(
      total_menores_5 > 0 & mortalidad_desnutricion_5 <= total_menores_5,
      (mortalidad_desnutricion_5 / total_menores_5) * 100000,
      NA_real_
    )
  ) %>%
  rename(numerador = mortalidad_desnutricion_5, denominador = total_menores_5) %>%
  select(codmpio, anno, denominador, numerador, tasa_mortalidad_desnutricion_5)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "tasa_mortalidad_desnutricion_5"),
  Descripción = c("Código del municipio", "Año", "Total menores de 5 años", 
                  "Muertes por desnutrición", "Tasa de mortalidad por desnutrición en menores de 5 años"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.9, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.9.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
