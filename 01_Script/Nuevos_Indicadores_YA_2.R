

# ================================================
# YA 2 Nuevos Indicadores Educación Inicial 
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

# =======================================================================================================================================================
# YA 2.5 Porcentaje de niños y niñas en servicios de educación inicial en el marco de la atención integral que cuentan con 6 o más atenciones priorizadas.
# =======================================================================================================================================================

YA_2.5 <-select(educ_inicial, c(1,6,5)) %>%
  rename(porcentaje_marco_integral = INDICADOR.4..CONCURRENCIA.DE.ATENCIONES)



# Este indicador ya se encuentra calculado, tenemos un issue y es que trae un % incorporado, eso vamos a limpiarlo.


YA_2.5 <- YA_2.5 %>% mutate(porcentaje_marco_integral = as.numeric(sub("%", "", porcentaje_marco_integral)))


write.xlsx(YA_2.5, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.5.xlsx")






