

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

denominador_ICBF <- read.csv("~/Documents/GitHub/Ninez-YA/03_Process/ICBF_denominador_General.csv")


# ================================================
# Ajustamos el Nombre de las Variable 
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

# Nos Aseguramos que SRPA_4 no sea un string

SRPA_4 <- SRPA_4 %>%
  mutate(SRPA_4 = as.numeric(SRPA_4))

# Agrupamos SRPA_4 por codmpio y anno.

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

# Calcular la tasa o porcentaje SRPA_1 / procesos

SRPA_4 <- merged_data %>%
  mutate(tasa = (SRPA_4 / procesos) * 100)%>%
  rename(coddepto = codmpio )


# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_4, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_9.4.xlsx", colNames = TRUE)

# Fin del Código
