

# ================================================
# YA 9.1 ICBF 	Adolescentes entre 14 y 17 años en el Sistema de Responsabilidad Penal Adolescente que ingresan al ICBF para los cuales se determina una medida no privativa de la libertad.
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table"))


library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)
library(tidyr)


# =========  SRPA_1

# ================================================
# Cargar datos
# ================================================

SRPA_1 <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/SRPA_1.csv")

denominador_ICBF <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/icbf_14_17.csv")


### Ajustamos el Denominador 

denominador_ICBF <- denominador_ICBF %>%
  rename(anno = VIGENCIA,
         ingresos_totales = BENEFICIARIOS)


# ================================================
# Ajustamos el Nombre de las Variables
# ================================================

SRPA_1  <- SRPA_1  %>%
  rename(
    SRPA_1 = `BENEFICIARIOS`,  
    anno = VIGENCIA )

# Filtramos las Variables

SRPA_1 <- SRPA_1 %>%
  select(codmpio, anno, SRPA_1)

# Nos Aseguramos que SRPA_1 no sea un string

SRPA_1 <- SRPA_1 %>%
  mutate(SRPA_1 = as.numeric(SRPA_1))

# Agrupamos SRPA_1 por codmpio y anno.

SRPA_1 <- SRPA_1 %>%
  group_by(codmpio, anno) %>%
  summarise(SRPA_1 = sum(SRPA_1, na.rm = TRUE))

###############################################################################

## Vamos a construir el Porcentaje


# Convertir 'anno' en ambas bases de datos a integer
denominador_ICBF <- denominador_ICBF %>%
  mutate(anno = as.integer(anno))

SRPA_1 <- SRPA_1 %>%
  mutate(anno = as.integer(anno))

# Hacer un join entre ambas bases de datos por 'codmpio' y 'anno'
merged_data <- denominador_ICBF %>%
  left_join(SRPA_1, by = c("codmpio", "anno"))

# Calcular la tasa o porcentaje SRPA_1 / ingresos_totales

SRPA_1 <- merged_data %>%
  mutate(tasa = (SRPA_1 / ingresos_totales) * 100)


# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_1, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_9.1.xlsx", colNames = TRUE)

# Fin del Código



