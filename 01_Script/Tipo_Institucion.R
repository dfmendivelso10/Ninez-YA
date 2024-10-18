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

# Cargamos Nuestra Base 

tipo_institutcion <-  read.csv("~/Downloads/MEN_ESTABLECIMIENTOS_EDUCATIVOS_PREESCOLAR_B_SICA_Y_MEDIA_20241018.csv")

# Limpiamos la Base de Datos


# Primero eliminamos las variables que No Necesitamos

educ_inicial <- educ_inicial %>%
  select(-3:-8) # Acá Eliminamos las Primeras 6 columnas y la columna número 8

# Renombrammos algunas variables

educ_inicial <- educ_inicial %>% rename(anno = AÑO)

educ_inicial <- educ_inicial %>% rename(codmpio = CÓDIGO_MUNICIPIO)

educ_inicial <- educ_inicial %>% rename(neta_transicion = COBERTURA_NETA_TRANSICIÓN)

educ_inicial <- educ_inicial %>% rename(reprobacion_transicion = REPROBACIÓN_TRANSICIÓN)

educ_inicial <- educ_inicial %>% rename(repitencia_transicion = REPITENCIA_TRANSICIÓN)

educ_inicial <- educ_inicial %>% rename(desercion_transicion = DESERCIÓN_TRANSICIÓN)

# ================================================
# Creación de Sub - Data Sets
# ================================================

# YA 2.1 Cobertura Neta Transición

YA_2.1_VF <- subset(educ_inicial, select = c("anno", "codmpio","neta_transicion"))

YA_2.2_VF  <- subset(educ_inicial, select = c("anno", "codmpio","reprobacion_transicion"))

YA_2.3_VF  <- subset(educ_inicial, select = c("anno", "codmpio","repitencia_transicion"))

YA_2.4_VF <- subset(educ_inicial, select = c("anno", "codmpio","desercion_transicion"))

# ================================================
# Exportamos Data Sets
# ================================================

write.xlsx(YA_2.1_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.1.xlsx", col_names = TRUE)

write.xlsx(YA_2.2_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.2.xlsx", col_names = TRUE)

write.xlsx(YA_2.3_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.3.xlsx", col_names = TRUE)

write.xlsx(YA_2.4_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.4.xlsx", col_names = TRUE)


