# ============================================================
# YA 2 Nuevos Indicadores Educación Inicial 
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
# YA 2.5 - Porcentaje de niños y niñas en servicios de educación inicial con 6 o más atenciones
# ====================================================================================================

YA_2.5 <- educ_inicial %>%
  select(anno, codmpio, INDICADOR.4..CONCURRENCIA.DE.ATENCIONES) %>%
  rename(porcentaje_marco_integral = INDICADOR.4..CONCURRENCIA.DE.ATENCIONES)

# Convertir porcentaje de texto a numérico eliminando el símbolo "%"
YA_2.5 <- YA_2.5 %>%
  mutate(porcentaje_marco_integral = as.numeric(str_replace(porcentaje_marco_integral, "%", "")))

# Crear metadatos
metadatos_2.5 <- data.frame(
  Variables = c("anno", "codmpio", "porcentaje_marco_integral"),
  Descripción = c("Año", "Código del municipio", "Porcentaje de niños con 6 o más atenciones priorizadas"),
  Fuente = rep("…", 3),
  Fecha_de_extracción = rep(Sys.Date(), 3)
)

# Exportar datos con metadatos
write.xlsx(list(YA_2.5 = YA_2.5, metadatos = metadatos_2.5),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_2.5.xlsx",
           colNames = TRUE, overwrite = TRUE)

# Fin del Código
