# ============================================================
# YA 1.6 - Proporción de nacidos vivos con Bajo Peso al Nacer
# ============================================================

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

# Definir rutas de archivos
ruta_base <- "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA"
ruta_raw <- file.path(ruta_base, "02_RAW-Data", "YA_1.6.xlsx")
ruta_proc <- file.path(ruta_base, "03_Process")

# Cargar bases de datos
YA_1.6 <- read_excel(ruta_raw)
nacidos_vivos <- read_excel(file.path(ruta_proc, "nacidos_vivos.xlsx"))

# Limpieza de datos
YA_1.6 <- YA_1.6[, -22] %>%  # Eliminar columna 22 innecesaria porque es el Total
  mutate(
    codmpio = str_replace(as.character(codmpio), " - .*", ""),  # Limpiar códigos municipales
    across(starts_with("20"), limpiar_numeros)  # Aplicar limpieza a columnas numéricas
  ) %>%
  pivot_longer(cols = starts_with("20"), names_to = "anno", values_to = "bajo_peso_nacer") %>%
  mutate(codmpio = as.numeric(codmpio), anno = as.numeric(anno))

nacidos_vivos <- nacidos_vivos %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno),
    nacimientos = limpiar_numeros(nacimientos)  # Limpieza de valores numéricos
  )

# Merge de datos con condicional
YA_1.6 <- inner_join(nacidos_vivos, YA_1.6, by = c("codmpio", "anno")) %>%
  mutate(
    proporcion_bajo_peso_nacer = ifelse(bajo_peso_nacer > nacimientos, NA, (bajo_peso_nacer / nacimientos) * 100),
    numerador = bajo_peso_nacer,
    denominador = nacimientos
  ) %>%
  select(codmpio, anno, denominador, numerador, proporcion_bajo_peso_nacer)

# Crear metadatos
metadatados <- data.frame(
  Variables = c("codmpio", "anno", "denominador", "numerador", "proporcion_bajo_peso_nacer"),
  Descripción = c("Código del municipio", "Año", "Cantidad de nacimientos", "Nacidos con bajo peso", "Proporción de bajo peso al nacer"),
  Fuente = rep("Fuente de datos", 5),
  Fecha_de_extracción = rep(Sys.Date(), 5)
)

# Guardar resultados en un archivo Excel
ruta_output <- file.path(ruta_proc, "YA_1.6.xlsx")
write.xlsx(list(datos = YA_1.6, metadatados = metadatados), 
           file = ruta_output, colNames = TRUE, overwrite = TRUE)

# Fin del código
