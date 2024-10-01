
# ================================================
# YA 9.2 ICBF
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table"))


library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)
library(tidyr)

# ================================================
# SRPA_2
# ================================================

SRPA_2 <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/SRPA_2.csv")

denominador_ICBF <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/denominador_ICBF.csv")


### Ajustamos el Denominador 


# Convertir de formato wide a long para las columnas X2015 a X2023
denominador_ICBF <- denominador_ICBF%>%
  pivot_longer(cols = X2015:X2023,  # Especificar las columnas que quieres convertir
               names_to = "anno",    # El nombre de la columna que contendrá los nombres de las columnas originales
               values_to = "ingresos_totales") # El nombre de la columna que contendrá los valores de las columnas originales


# Eliminar la "X" en la columna 'anno' y convertir a número
denominador_ICBF$anno <- gsub("X", "", denominador_ICBF$anno)


# ================================================
# Ajustamos el Nombre de las Variables
# ================================================

SRPA_2  <- SRPA_2  %>%
  rename(
    SRPA_2 = `Beneficiarios`,  
    anno = Vigencia )

# Filtramos las Variables

SRPA_2 <- SRPA_2 %>%
  select(codmpio, anno, SRPA_2)

# Nos Aseguramos que SRPA_2 no sea un string

SRPA_2 <- SRPA_2 %>%
  mutate(SRPA_2 = as.numeric(SRPA_2))

# Agrupamos SRPA_2 por codmpio y anno.

SRPA_2 <- SRPA_2 %>%
  group_by(codmpio, anno) %>%
  summarise(SRPA_2 = sum(SRPA_2, na.rm = TRUE))

###############################################################################

## Vamos a construir el Porcentaje


# Convertir 'anno' en ambas bases de datos a integer
denominador_ICBF <- denominador_ICBF %>%
  mutate(anno = as.integer(anno))

SRPA_2 <- SRPA_2 %>%
  mutate(anno = as.integer(anno))

# Hacer un join entre ambas bases de datos por 'codmpio' y 'anno'
merged_data <- denominador_ICBF %>%
  left_join(SRPA_2, by = c("codmpio", "anno"))

# Calcular la tasa o porcentaje SRPA_1 / ingresos_totales

SRPA_2 <- merged_data %>%
  mutate(tasa = (SRPA_2 / ingresos_totales) * 100) %>%
rename(coddepto = codmpio )

# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_2, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_9.2.xlsx", colNames = TRUE)

# Fin del Código
