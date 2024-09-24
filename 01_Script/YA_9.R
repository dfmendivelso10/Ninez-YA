

# ================================================
# YA 9. ICBF
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table"))


library(readxl)
library(data.table)
library(dplyr)
library(openxlsx)
library(stringr)



# ================================================
# SRPA_1
# ================================================


# ================================================
# Cargar datos
# ================================================

SRPA_1 <- read.csv("~/Documents/GitHub/Ninez-YA/03_Process/SRPA_1.csv")

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
  summarise(Suma_SRPA_1 = sum(SRPA_1, na.rm = TRUE))

# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_1, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_8.1.xlsx", colNames = TRUE)

# Fin del Código


# ================================================
# SRPA_2
# ================================================


# ================================================
# Cargar datos
# ================================================

SRPA_2 <- read.csv("~/Documents/GitHub/Ninez-YA/03_Process/SRPA_2.csv")

# ================================================
# Ajustamos el Nombre de las Variables
# ================================================

SRPA_2  <- SRPA_2  %>%
  rename(
    SRPA_2 = `BENEFICIARIOS`,  
    anno = VIGENCIA )

# Filtramos las Variables

SRPA_2 <- SRPA_2 %>%
  select(codmpio, anno, SRPA_2)

# Nos Aseguramos que SRPA_1 no sea un string

SRPA_2 <- SRPA_2 %>%
  mutate(SRPA_2 = as.numeric(SRPA_2))

# Agrupamos SRPA_1 por codmpio y anno.

SRPA_2 <- SRPA_2 %>%
  group_by(codmpio, anno) %>%
  summarise(Suma_SRPA_2 = sum(SRPA_2, na.rm = TRUE))

# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_2, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_8.2.xlsx", colNames = TRUE)





# ================================================
# SRPA_ Punto 1
# ================================================


# ================================================
# Cargar datos
# ================================================

SRPA_Punto_1 <- read.csv("~/Documents/GitHub/Ninez-YA/03_Process/SRPA_Punto_1.csv")

# ================================================
# Ajustamos el Nombre de las Variables
# ================================================

SRPA_Punto_1  <- SRPA_Punto_1  %>%
  rename(
    SRPA_Punto_1 = `BENEFICIARIOS`,  
    anno = VIGENCIA )

# Filtramos las Variables

SRPA_2 <- SRPA_2 %>%
  select(codmpio, anno, SRPA_2)

# Nos Aseguramos que SRPA_1 no sea un string

SRPA_2 <- SRPA_2 %>%
  mutate(SRPA_2 = as.numeric(SRPA_2))

# Agrupamos SRPA_1 por codmpio y anno.

SRPA_2 <- SRPA_2 %>%
  group_by(codmpio, anno) %>%
  summarise(Suma_SRPA_2 = sum(SRPA_2, na.rm = TRUE))

# ================================================
# Exportar el resultado a un archivo Excel
# ================================================

write.xlsx(SRPA_2, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_8.2.xlsx", colNames = TRUE)

