
# ================================================
# YA 9.3 % Niñas, Niños y Jóvenes que Ingresan al ICBF por trabajo infantil
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table", "data.table"))


library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)
library(tidyr)

# ================================================
# SRPA_3 
# ================================================

SRPA_3 <- read.csv("~/Documents/GitHub/Ninez-YA/02_RAW-Data/SRPA_3.csv")

denominador_ICBF <- read.csv("~/Documents/GitHub/Ninez-YA/03_Process/ICBF_denominador_General.csv")

# ================================================
# Ajustamos algunos nombres
# ================================================

# Debemos Cambiar la estructura de wide a long 

# Aplicamos el melt
setDT(SRPA_3)
SRPA_3 <- melt(SRPA_3, id.vars = c("codmpio", "Departamento"), variable.name = "anno", value.name = "valor")

# Quitamos la "X" en la columna 'anno'

SRPA_3[, anno := gsub("^X", "", anno)]


# Renombramos Variables

SRPA_3  <- SRPA_3  %>%
  rename(SRPA_3 = valor)

# Filtramos las Variables

SRPA_3 <- SRPA_3 %>%
  select(codmpio, anno, SRPA_3)

# Nos Aseguramos que SRPA_3 no sea un string

SRPA_3 <- SRPA_3 %>%
  mutate(SRPA_3 = as.numeric(SRPA_3))

# Agrupamos SRPA_2 por codmpio y anno.

SRPA_3 <- SRPA_3 %>%
  group_by(codmpio, anno) %>%
  summarise(SRPA_3 = sum(SRPA_3, na.rm = TRUE))

###############################################################################


# Convertir 'anno' en ambas bases de datos a integer
denominador_ICBF <- denominador_ICBF %>%
  mutate(anno = as.integer(anno))

SRPA_3 <- SRPA_3 %>%
  mutate(anno = as.integer(anno))

# Hacer un join entre ambas bases de datos por 'codmpio' y 'anno'
merged_data <- denominador_ICBF %>%
  left_join(SRPA_3, by = c("codmpio", "anno"))

# Calcular la tasa o porcentaje SRPA_1 / procesos

SRPA_3 <- merged_data %>%
  mutate(tasa = (SRPA_3 / procesos) * 100) %>%
  rename(coddepto = codmpio )


# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_3, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_9.3.xlsx", colNames = TRUE)

# Fin del Código
