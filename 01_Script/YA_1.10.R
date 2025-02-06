# ============================================================
# YA 1.10 Partos Atendidos por Personal Calificado
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
YA_1.10 <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/tipo_nacimiento.xlsx")
nacidos_vivos <- read.xlsx("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/VF_nacidos_vivos.xlsx")

# Limpieza de datos
YA_1.10 <- YA_1.10 %>%
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),
    across(starts_with("20"), limpiar_numeros)  # Aplica limpieza a columnas numéricas
  ) %>%
  pivot_longer(
    cols = starts_with("20"), 
    names_to = "anno", 
    values_to = "partos_atendidos_calificado"
  ) %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

nacidos_vivos <- nacidos_vivos %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno),
    nacidos_vivos = limpiar_numeros(nacidos_vivos)  # Limpieza de valores numéricos
  )

# Unir bases de datos
YA_1.10 <- inner_join(nacidos_vivos, YA_1.10, by = c("codmpio", "anno"))

# Calcular el porcentaje de partos atendidos por personal calificado
YA_1.10 <- YA_1.10 %>% 
  mutate(
    porcentaje_nacidos_vivos_personal_calificado = ifelse(
      nacidos_vivos > 0 & partos_atendidos_calificado <= nacidos_vivos,
      (partos_atendidos_calificado / nacidos_vivos) * 100,
      NA_real_
    )
  ) %>%
  rename(numerador = partos_atendidos_calificado, denominador = nacidos_vivos) %>%
  select(codmpio, anno, denominador, numerador, porcentaje_nacidos_vivos_personal_calificado)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "porcentaje_nacidos_vivos_personal_calificado"),
  Descripción = c("Código del municipio", "Año", "Total nacidos vivos", 
                  "Partos atendidos por personal calificado", 
                  "Porcentaje de nacidos vivos atendidos por personal calificado"),
  Fuente = rep("…", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar datos en Excel sin necesidad de createWorkbook()
write.xlsx(list(datos = YA_1.10, metadatados = metadatados),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_1.10.xlsx", 
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
