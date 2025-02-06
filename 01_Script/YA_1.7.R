# ============================================================
# YA 1.7 Tasa de Mortalidad Neonatal
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
YA_1.7 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/neonatal.xlsx")
nacidos_vivos <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/nacidos_vivos.xlsx")

# Eliminar la columna 'Total General' (suponiendo que es la columna 21)
YA_1.7 <- YA_1.7[, -21]

# Limpieza de datos
YA_1.7 <- YA_1.7 %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "anno", 
    values_to = "mortalidad_neonatal"
  ) %>%
  filter(codmpio != "Total general") %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

nacidos_vivos <- nacidos_vivos %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno),
    nacimientos = limpiar_numeros(nacimientos)  # Limpieza de valores numéricos
  )

# Unir bases de datos
YA_1.7 <- inner_join(nacidos_vivos, YA_1.7, by = c("codmpio", "anno"))

# Calcular la tasa de mortalidad neonatal corregida
YA_1.7 <- YA_1.7 %>%
  mutate(
    tasa_mortalidad_neonatal = ifelse(
      nacimientos > 0 & mortalidad_neonatal <= nacimientos,
      (mortalidad_neonatal / nacimientos) * 1000,
      NA_real_
    ),
    tasa_mortalidad_neonatal = ifelse(
      mortalidad_neonatal == nacimientos & nacimientos == 1,
      NA_real_,
      tasa_mortalidad_neonatal
    )
  ) %>%
  rename(numerador = mortalidad_neonatal, denominador = nacimientos) %>%
  select(codmpio, anno, denominador, numerador, tasa_mortalidad_neonatal)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "tasa_mortalidad_neonatal"),
  Descripción = c("Código del municipio", "Año", "Nacimientos", "Muertes neonatales", 
                  "Tasa de mortalidad neonatal por 1,000 nacidos vivos"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.7, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.7.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
