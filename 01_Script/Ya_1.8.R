# ============================================================
# YA 1.8 Tasa de Mortalidad en Menores de 1 Año
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
YA_1.8 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/menores_1_año.xlsx")
nacidos <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/nacidos_vivos.xlsx")

# Eliminar la columna 'Total General' (suponiendo que es la columna 21)
YA_1.8 <- YA_1.8[, -21]
nacidos <- nacidos[, -21]

# Limpieza de datos
YA_1.8 <- YA_1.8 %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "anno", 
    values_to = "mortalidad_menores_1_año"
  ) %>%
  filter(codmpio != "Total general") %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

nacidos <- nacidos %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "anno", 
    values_to = "nacidos"
  ) %>%
  filter(codmpio != "Total general") %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

# Unir bases de datos
YA_1.8 <- inner_join(nacidos, YA_1.8, by = c("codmpio", "anno"))

# Calcular la tasa de mortalidad en menores de 1 año
YA_1.8 <- YA_1.8 %>%
  mutate(
    tasa_mortalidad_menores_1_año = ifelse(
      nacidos > 0 & mortalidad_menores_1_año <= nacidos,  
      (mortalidad_menores_1_año / nacidos) * 1000,        
      NA_real_  
    )
  ) %>%
  rename(numerador = mortalidad_menores_1_año, denominador = nacidos) %>%
  select(codmpio, anno, denominador, numerador, tasa_mortalidad_menores_1_año)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "tasa_mortalidad_menores_1_año"),
  Descripción = c("Código del municipio", "Año", "Nacimientos", "Muertes en menores de 1 año", 
                  "Tasa de mortalidad en menores de 1 año por 1,000 nacidos vivos"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.8, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.8.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
