
# ================================================
# YA 2 Educación Inicial 
# ================================================

# Librerías y Paquetes
install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))

library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)
library(lubridate) # Nos permite manejar fechas.
library(openxlsx)

# Función para generar metadatos según el indicador
crear_metadatos <- function(variables, descripciones) {
  data.frame(
    Variables = variables,
    Descripción = descripciones,
    Fuente = rep("…", length(variables)),
    Fecha_de_extracción = rep(Sys.Date(), length(variables))
  )
}


# Cargamos Nuestra Base 


educ_inicial <- read.csv("C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/02_RAW-Data/preescolar_basica.csv")

# Limpiamos la Base de Datos
educ_inicial <- educ_inicial %>%
  select(-3:-8) %>% # Eliminamos columnas innecesarias
  rename(
    anno = AÑO,
    codmpio = CÓDIGO_MUNICIPIO,
    neta_transicion = COBERTURA_NETA_TRANSICIÓN,
    reprobacion_transicion = REPROBACIÓN_TRANSICIÓN,
    repitencia_transicion = REPITENCIA_TRANSICIÓN,
    desercion_transicion = DESERCIÓN_TRANSICIÓN
  )

# ================================================
# Creación de Sub - Data Sets con Metadatos
# ================================================

# YA 2.1 Cobertura Neta Transición
YA_2.1_VF <- subset(educ_inicial, select = c("anno", "codmpio", "neta_transicion"))
metadatos_YA_2.1 <- crear_metadatos(
  variables = c("codmpio", "anno", "denominador", "numerador", "neta_transicion"),
  descripciones = c("Código del municipio", "Año", "Total niños en transición", 
                    "Niños inscritos en transición", "Cobertura neta en transición")
)

# YA 2.2 Reprobación en Transición
YA_2.2_VF <- subset(educ_inicial, select = c("anno", "codmpio", "reprobacion_transicion"))
metadatos_YA_2.2 <- crear_metadatos(
  variables = c("codmpio", "anno", "denominador", "numerador", "reprobacion_transicion"),
  descripciones = c("Código del municipio", "Año", "Total niños en transición", 
                    "Niños que reprobaron transición", "Tasa de reprobación en transición")
)

# YA 2.3 Repitencia en Transición
YA_2.3_VF <- subset(educ_inicial, select = c("anno", "codmpio", "repitencia_transicion"))
metadatos_YA_2.3 <- crear_metadatos(
  variables = c("codmpio", "anno", "denominador", "numerador", "repitencia_transicion"),
  descripciones = c("Código del municipio", "Año", "Total niños en transición", 
                    "Niños que repitieron transición", "Tasa de repitencia en transición")
)

# YA 2.4 Deserción en Transición
YA_2.4_VF <- subset(educ_inicial, select = c("anno", "codmpio", "desercion_transicion"))
metadatos_YA_2.4 <- crear_metadatos(
  variables = c("codmpio", "anno", "denominador", "numerador", "desercion_transicion"),
  descripciones = c("Código del municipio", "Año", "Total niños en transición", 
                    "Niños que desertaron de transición", "Tasa de deserción en transición")
)

# ================================================
# Exportamos Data Sets con Metadatos
# ================================================

write.xlsx(list("datos" = YA_2.1_VF, "metadatos" = metadatos_YA_2.1),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_2.1.xlsx", 
           colNames = TRUE, overwrite = TRUE)

write.xlsx(list("datos" = YA_2.2_VF, "metadatos" = metadatos_YA_2.2),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_2.2.xlsx", 
           colNames = TRUE, overwrite = TRUE)

write.xlsx(list("datos" = YA_2.3_VF, "metadatos" = metadatos_YA_2.3),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_2.3.xlsx", 
           colNames = TRUE, overwrite = TRUE)

write.xlsx(list("datos" = YA_2.4_VF, "metadatos" = metadatos_YA_2.4),
           file = "C:/Users/enflujo.ARTE-EUFRB00792/Documents/Ninez-YA/03_Process/YA_2.4.xlsx", 
           colNames = TRUE, overwrite = TRUE)