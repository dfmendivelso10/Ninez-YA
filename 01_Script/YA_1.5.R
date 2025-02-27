# ================================================
# YA 1.5 Prevalencia de desnutrición aguda en niños menores de cinco años 
# ================================================

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
YA_1.5 <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/YA_1.5.xlsx")
menores_5_años <- read_excel("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/menores_5_años.xlsx")

# Limpieza de datos
YA_1.5 <- YA_1.5 %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "anno", 
    values_to = "desnutricion_menores_5"
  ) %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

menores_5_años <- menores_5_años %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno),
    total_menores_5 = limpiar_numeros(total_menores_5)  # Limpieza de valores numéricos
  )

# Unir bases de datos y calcular la proporción con condicional
YA_1.5_VF <- inner_join(menores_5_años, YA_1.5, by = c("codmpio", "anno")) %>%
  mutate(
    proporcion_desnutricion_menores_5 = ifelse(
      desnutricion_menores_5 > total_menores_5, 
      NA,  # Si el numerador es mayor que el denominador, asigna NA
      (desnutricion_menores_5 / total_menores_5) * 100
    )
  ) %>%
  rename(numerador = desnutricion_menores_5, denominador = total_menores_5) %>%
  select(codmpio, anno, denominador, numerador, proporcion_desnutricion_menores_5)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "proporcion_desnutricion_menores_5"),
  Descripción = c("Código del municipio", "Año", "Total menores de 5 años", 
                  "Muertes por desnutrición aguda", "proporcion de mortalidad por desnutrición"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.5_VF, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.5.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
