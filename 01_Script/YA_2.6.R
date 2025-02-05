# ============================================================
# YA 2  2.6 - Niñas y niños con educación inicial en el marco de la atención integral
# ============================================================

# Instalar y cargar librerías necesarias
if (!requireNamespace("openxlsx", quietly = TRUE)) install.packages("openxlsx")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("readxl", quietly = TRUE)) install.packages("readxl")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("lubridate", quietly = TRUE)) install.packages("lubridate")

library(dplyr)
library(openxlsx)
library(readxl)
library(tidyr)
library(stringr)
library(lubridate)

# Cargar la base de datos
educ_inicial <- read.csv("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/Educacion_Inicial.csv")

# Limpieza de datos
educ_inicial <- educ_inicial %>%
  mutate(FECHA = dmy(FECHA),   # Convertir la fecha a formato Date
         anno = year(FECHA)) %>%  # Extraer el año
  select(-1:-5, -7) %>%  # Eliminar columnas innecesarias
  rename(codmpio = COD_DANE_MUNICIPIO)

# ====================================================================================================
# YA 2.6 - Niñas y niños con educación inicial en el marco de la atención integral
# ====================================================================================================

YA_2.6 <- educ_inicial %>%
  select(anno, codmpio, INDICADOR.3..TOTAL.EDUCACIÓN.INICIAL.ICBF...MEN) %>%
  rename(ninos_educacion_inicial_integral = INDICADOR.3..TOTAL.EDUCACIÓN.INICIAL.ICBF...MEN)

# Convertir valores a numérico asegurando limpieza de caracteres no deseados
YA_2.6 <- YA_2.6 %>%
  mutate(ninos_educacion_inicial_integral = as.numeric(str_replace_all(ninos_educacion_inicial_integral, "[,.]", "")))

# Crear metadatos para YA 2.6
metadatos_2.6 <- data.frame(
  Variables = c("anno", "codmpio", "ninos_educacion_inicial_integral"),
  Descripción = c("Año", "Código del municipio", "Total de niñas y niños con educación inicial en el marco de la atención integral"),
  Fuente = rep("…", 3),
  Fecha_de_extracción = rep(Sys.Date(), 3)
)

# ====================================================================================================
# Exportar datos con metadatos
# ====================================================================================================

write.xlsx(list(YA_2.6 = YA_2.6, metadatos = metadatos_2.6),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_2.6.xlsx",
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
