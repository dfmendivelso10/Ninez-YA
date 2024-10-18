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


# Calculamos la Cobertura


resultado <- tipo_institutcion %>%
  group_by(anno, codmpio, sector) %>%
  summarise(conteo = n(), .groups = "drop") %>%
  group_by(anno, codmpio) %>%
  mutate(porcentaje = (conteo / sum(conteo)) * 100)


# Exportamos

write.xlsx(YA_2.1_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.1.xlsx", col_names = TRUE)



