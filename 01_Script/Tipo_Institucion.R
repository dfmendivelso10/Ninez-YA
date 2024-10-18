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

tipo_institutcion  <- tipo_institutcion  %>%
  select(1,6,11) # Acá Eliminamos las observaciones que no se necesitan

# Renombrammos algunas variables

tipo_institutcion <- tipo_institutcion %>% rename(anno = AÑO)

tipo_institutcion <- tipo_institutcion %>% rename(codmpio = COD_DANE_MUNICIPIO)

tipo_institutcion <- tipo_institutcion %>% rename(sector = SECTOR)



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


