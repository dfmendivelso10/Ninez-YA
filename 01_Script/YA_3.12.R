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

tipo_institucion <-  read.csv("~/Downloads/MEN_ESTABLECIMIENTOS_EDUCATIVOS_PREESCOLAR_B_SICA_Y_MEDIA_20241018.csv")

# Limpiamos la Base de Datos


# Primero eliminamos las variables que No Necesitamos

tipo_institucion  <- tipo_institucion  %>%
  select(1,6,11) # Acá Eliminamos las observaciones que no se necesitan

# Renombrammos algunas variables

tipo_institucion <- tipo_institucion %>% rename(anno = AÑO)

tipo_institucion <- tipo_institucion %>% rename(codmpio = COD_DANE_MUNICIPIO)

tipo_institucion <- tipo_institucion %>% rename(sector = SECTOR)


# Calculamos la Cobertura


YA_3.12 <- tipo_institucion %>%
  group_by(anno, codmpio, sector) %>%
  summarise(conteo = n(), .groups = "drop") %>%
  group_by(anno, codmpio) %>%
  mutate(porcentaje = (conteo / sum(conteo)) * 100) %>%
  rename(tipo = porcentaje)


# Exportamos

write.xlsx(YA_3.12, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_3.12.xlsx", col_names = TRUE)



