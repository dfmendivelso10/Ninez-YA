

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

educ_inicial <-  read.csv("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/MEN_ESTADISTICAS.csv")

# Limpiamos la Base de Datos

# Primero eliminamos las variables que No Necesitamos

educ_inicial <- educ_inicial %>%
  select(-3:-8) # Acá Eliminamos las Primeras 6 columnas y la columna número 8

# Renombramos algunas variables

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

# YA 3.1 Cobertura Neta 

YA_3.4_VF <- subset(educ_inicial, select = c("anno", "codmpio","neta_primaria"))

YA_3.5_VF <- subset(educ_inicial, select = c("anno", "codmpio","neta_media"))

# YA 3.6-7 Reprobación Neta 

YA_3.6_VF <- subset(educ_inicial, select = c("anno", "codmpio","reprobacion_primaria"))

YA_3.7_VF <- subset(educ_inicial, select = c("anno", "codmpio","reprobacion_media"))

# YA 3.8-9 Repitencia Neta 

YA_3.8_VF <- subset(educ_inicial, select = c("anno", "codmpio","repitencia_primaria"))

YA_3.9_VF <- subset(educ_inicial, select = c("anno", "codmpio","repitencia_media"))

# YA 3.10-11 Deserción Neta 

YA_3.10_VF <- subset(educ_inicial, select = c("anno", "codmpio","desercion_primaria"))

YA_3.11_VF <- subset(educ_inicial, select = c("anno", "codmpio","desercion_media"))




# ================================================
# Exportamos Data Sets
# ================================================

write.xlsx(YA_3.4_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.4.xlsx", col_names = TRUE)

write.xlsx(YA_3.5_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.5.xlsx", col_names = TRUE)

write.xlsx(YA_3.6_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.6.xlsx", col_names = TRUE)

write.xlsx(YA_3.7_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.7.xlsx", col_names = TRUE)

write.xlsx(YA_3.8_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.8.xlsx", col_names = TRUE)

write.xlsx(YA_3.9_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.9.xlsx", col_names = TRUE)

write.xlsx(YA_3.10_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.10.xlsx", col_names = TRUE)

write.xlsx(YA_3.11_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.11.xlsx", col_names = TRUE)




