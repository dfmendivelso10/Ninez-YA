# ============================================================
# YA 1.6 - Proporción de nacidos vivos con Bajo Peso al Nacer
# ============================================================

# Cargar librerías necesarias
library(dplyr)
library(openxlsx)
library(readxl)
library(tidyr)
library(stringr)

# Definir rutas de archivos
ruta_base <- "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA"
ruta_raw <- file.path(ruta_base, "02_RAW-Data", "YA_1.6.xlsx")
ruta_proc <- file.path(ruta_base, "03_Process")

# Cargar bases de datos
YA_1.6 <- read_excel(ruta_raw) %>%
  select(-21) %>%  # Eliminar columna 21 innecesaria
  mutate(
    codmpio = str_replace(codmpio, " - .*", ""),  # Limpiar códigos municipales
    codmpio = as.character(codmpio)  # Asegurar que sea de tipo character
  ) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "bajo_peso_nacer") %>%
  mutate(anno = as.character(anno))  # Asegurar que 'anno' sea de tipo character

nacidos_vivos <- read_excel(file.path(ruta_proc, "nacidos_vivos.xlsx")) %>%
  mutate(
    codmpio = as.character(codmpio),  # Convertir a character para compatibilidad
    anno = as.character(anno)  # Convertir a character para compatibilidad
  )

# Fusionar bases de datos y calcular proporción
YA_1.6 <- inner_join(nacidos_vivos, YA_1.6, by = c("codmpio", "anno")) %>%
  mutate(proporcion_bajo_peso_nacer = (bajo_peso_nacer / nacimientos) * 100) %>%
  rename(numerador = bajo_peso_nacer, denominador = nacimientos) %>%
  select(codmpio, anno, denominador, numerador, proporcion_bajo_peso_nacer)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "proporcion_bajo_peso_nacer"),
  Descripción = c("Código del municipio", "Año", "Cantidad de nacimientos", 
                  "Nacidos con bajo peso", "Proporción de bajo peso al nacer"),
  Fuente = rep("Fuente de datos", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar resultados en un archivo Excel
ruta_output <- file.path(ruta_proc, "YA_1.6.xlsx")
write.xlsx(list(datos = YA_1.6, metadatados = metadatados), 
           file = ruta_output, colNames = TRUE, overwrite = TRUE)

# Fin del código
