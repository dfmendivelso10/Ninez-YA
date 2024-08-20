

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

write.xlsx(YA_3.4_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.4_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.5_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.5_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.6_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.6_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.7_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.7_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.8_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.8_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.9_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.9_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.10_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.10_VF.xlsx", col_names = TRUE)

write.xlsx(YA_3.11_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.11_VF.xlsx", col_names = TRUE)

# ================================================
# Datos Icfes
# ================================================

# Cargamos los datos manualmente

setwd("D:/Users/enflujo/Documents/GitHub/OneDrive - Universidad de los andes/Data_NIÑEZ_YA/Raw_DATA")


icfes_2016 <- read_delim("2016.txt", delim = "/", escape_double = FALSE, locale = locale(), trim_ws = TRUE)

icfes_x2017 <- read_delim("2017.txt", delim = "/", escape_double = FALSE, locale = locale(), trim_ws = TRUE)

icfes_x2018 <- read_delim("2018.txt", delim = "/", escape_double = FALSE, locale = locale(), trim_ws = TRUE)

icfes_x2019 <- read_delim("2019.txt", delim = "/", escape_double = FALSE, locale = locale(), trim_ws = TRUE)

icfes_x2020 <- read_delim("2020.txt", delim = "/", escape_double = FALSE, locale = locale(), trim_ws = TRUE)

# Vamos a Uniformizar los Datos

icfes_2016$nivel1 <- as.character(icfes_2016$nivel1)
icfes_x2017$nivel1 <- as.character(icfes_x2017$nivel1)
icfes_x2018$nivel1 <- as.character(icfes_x2018$nivel1)
icfes_x2019$nivel1 <- as.character(icfes_x2019$nivel1)
icfes_x2020$nivel1 <- as.character(icfes_x2020$nivel1)


## Combinamos los Archivos

combined_data <- bind_rows(icfes_2016, icfes_x2017, icfes_x2018, icfes_x2019, icfes_x2020)



