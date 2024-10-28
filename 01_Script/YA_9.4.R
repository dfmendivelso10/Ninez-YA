

# ================================================
# YA 9.3 % Jóvenes que Ingresan al ICBF por explotacion sexual
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
# SRPA_3 
# ================================================

SRPA_4 <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/SRPA_4.csv")

denominador_ICBF <- read.csv("/Documents/GitHub/Ninez-YA/03_Process/ICBF_denominador_General.csv")


### Ajustamos el Denominador 


# Convertir de formato wide a long para las columnas X2015 a X2023

denominador_ICBF <- denominador_ICBF%>%
  pivot_longer(cols = X2015:X2023,  # Especificar las columnas que quieres convertir
               names_to = "anno",    # El nombre de la columna que contendrá los nombres de las columnas originales
               values_to = "ingresos_totales") # El nombre de la columna que contendrá los valores de las columnas originales


# Eliminar la "X" en la columna 'anno' y convertir a número
denominador_ICBF$anno <- gsub("X", "", denominador_ICBF$anno)


# ================================================
# Ajustamos el Nombre de las Variable de kla Base SRPA_3
# ================================================

# Debemos Cambiar la estructura de wide a long 

# Convertir a data.table *Melt solo funciona con Data.Table

setDT(SRPA_4)

# Aplicamos el melt

SRPA_4 <- melt(SRPA_4, id.vars = c("codmpio", "Departamento"), variable.name = "anno", value.name = "valor")

# Quitamos la "X" en la columna 'anno'

SRPA_4[, anno := gsub("^X", "", anno)]


# Renombramos Variables

SRPA_4  <- SRPA_4  %>%
  rename(
    SRPA_4 = valor)

# Filtramos las Variables

SRPA_4 <- SRPA_4 %>%
  select(codmpio, anno, SRPA_4)

# Nos Aseguramos que SRPA_3 no sea un string

SRPA_4 <- SRPA_4 %>%
  mutate(SRPA_4 = as.numeric(SRPA_4))

# Agrupamos SRPA_2 por codmpio y anno.

SRPA_4 <- SRPA_4 %>%
  group_by(codmpio, anno) %>%
  summarise(SRPA_4 = sum(SRPA_4, na.rm = TRUE))

###############################################################################

# Convertir 'anno' en ambas bases de datos a integer
denominador_ICBF <- denominador_ICBF %>%
  mutate(anno = as.integer(anno))

SRPA_4 <- SRPA_4 %>%
  mutate(anno = as.integer(anno))

# Hacer un join entre ambas bases de datos por 'codmpio' y 'anno'
merged_data <- denominador_ICBF %>%
  left_join(SRPA_4, by = c("codmpio", "anno"))

# Calcular la tasa o porcentaje SRPA_1 / ingresos_totales

SRPA_4 <- merged_data %>%
  mutate(tasa = (SRPA_4 / ingresos_totales) * 100)%>%
  rename(coddepto = codmpio )


# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_4, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_9.4.xlsx", colNames = TRUE)

# Fin del Código
