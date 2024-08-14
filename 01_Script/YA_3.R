

# ================================================
# YA 3 Educación Básica y Media
# ================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Cargamos Nuestra Base 

educ_inicial <-  read.csv("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/preescolar_basica.csv")

# Limpiamos la Base de Datos

# Primero eliminamos las variables que No Necesitamos

educ_inicial <- educ_inicial %>%
  select(-3:-8) # Acá Eliminamos las Primeras 6 columnas y la columna número 8

# Renombrammos algunas variables

educ_inicial <- educ_inicial %>% rename(anno = AÑO)

educ_inicial <- educ_inicial %>% rename(codmpio = CÓDIGO_MUNICIPIO)

# Cobertura Neta

educ_inicial <- educ_inicial %>% rename(neta_primaria = COBERTURA_NETA_PRIMARIA)

educ_inicial <- educ_inicial %>% rename(neta_media = COBERTURA_NETA_MEDIA)

# Reprobación

educ_inicial <- educ_inicial %>% rename(reprobacion_primaria = REPROBACIÓN_PRIMARIA)

educ_inicial <- educ_inicial %>% rename(reprobacion_media = REPROBACIÓN_MEDIA)

# Repitencia

educ_inicial <- educ_inicial %>% rename(repitencia_primaria = REPITENCIA_PRIMARIA)

educ_inicial <- educ_inicial %>% rename(repitencia_media = REPITENCIA_MEDIA)

# Deserción

educ_inicial <- educ_inicial %>% rename(desercion_primaria= DESERCIÓN_PRIMARIA)

educ_inicial <- educ_inicial %>% rename(desercion_media= DESERCIÓN_MEDIA)


# ================================================
# Creación de Sub - Data Sets
# ================================================

# YA 2.1 Cobertura Neta Transición

YA_3.4_VF <- subset(educ_inicial, select = c("anno", "codmpio","neta_primaria"))

YA_3.4_VF <- subset(educ_inicial, select = c("anno", "codmpio","neta_media"))








YA_2.2_VF  <- subset(educ_inicial, select = c("anno", "codmpio","reprobacion_transicion"))

YA_2.3_VF  <- subset(educ_inicial, select = c("anno", "codmpio","repitencia_transicion"))

YA_2.4_VF <- subset(educ_inicial, select = c("anno", "codmpio","desercion_transicion"))

# ================================================
# Exportamos Data Sets
# ================================================

write.xlsx(YA_2.1_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.1_VF.xlsx", col_names = TRUE)

write.xlsx(YA_2.2_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.2_VF.xlsx", col_names = TRUE)

write.xlsx(YA_2.3_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.3_VF.xlsx", col_names = TRUE)

write.xlsx(YA_2.4_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.4_VF.xlsx", col_names = TRUE)






