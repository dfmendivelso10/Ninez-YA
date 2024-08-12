

# ================================================
# YA 3 Educación Inicial 
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

educ_inicial <-  read.csv("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/Educacion_Inicial.csv")

# Limpiamos la Base de Datos

educ_inicial <- educ_inicial %>%
  mutate(FECHA = dmy(FECHA),   # Convertir la fecha de texto a formato Date
         Año = year(FECHA))     # Extraemos el año y ya no tenemos día ni mes

# Eliminamos Variables que no Necesitamos

educ_inicial <- educ_inicial %>%
  select(-1:-5,-7) # Acá Eliminamos las Primeras 5 columnas y la columna número 7

# Renombramos algunas variables

educ_inicial  <- educ_inicial  %>%
  rename(anno = Año)

educ_inicial  <- educ_inicial  %>%
  rename(codmpio = COD_DANE_MUNICIPIO)

# ================================================
# Creación de Sub - Data Sets
# ================================================

# Primero renombramos las variables

educ_inicial <- educ_inicial %>% rename(educ_inicial_icbf = INDICADOR.1..EDUCACIÓN.INICIAL.ICBF..Incluye.Mujeres.Gestantes.)

educ_inicial <- educ_inicial %>% rename(educ_inicial_marco_integral = INDICADOR.2..NIÑOS.Y.NIÑAS.EN.PREESCOLAR.CON.EDUCACIÓN.INICIAL)

educ_inicial <- educ_inicial %>% rename(porcentaje_marco_integral = INDICADOR.4..CONCURRENCIA.DE.ATENCIONES)

# Definimos los Datasets

educ_inicial_ICBF <- subset(educ_inicial, selec = c(codmpio, anno, educ_inicial_icbf))

educ_inicial_marco_integral <- subset(educ_inicial, selec = c(codmpio, anno, educ_inicial_marco_integral))

porcentaje_marco_integral <- subset(educ_inicial, selec = c(codmpio, anno, porcentaje_marco_integral))

# Exportamos los Datasets

write.xlsx(educ_inicial_ICBF, file = "~/GitHub/Ninez-YA/03_Process/educ_inicial_ICBF.xlsx", col_names = TRUE)

write.xlsx(educ_inicial_marco_integral, file = "~/GitHub/Ninez-YA/03_Process/educ_inicial_marco_integral.xlsx", col_names = TRUE)

write.xlsx(porcentaje_marco_integral, file = "~/GitHub/Ninez-YA/03_Process/porcentaje_marco_integral.xlsx", col_names = TRUE)


