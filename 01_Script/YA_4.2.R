## Librerías 

# Revisar las librerias.

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)



# Cargamos Nuestra Base YA_4.2

YA_4.2 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_4.2.xlsx")

# Borramos la Variable Total General

YA_4.2 <- YA_4.2[ , -22]

# Separamos el CODMPIO del Nombre del Municipio

YA_4.2$codmpio <- str_replace(YA_4.2$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_4.2 <- YA_4.2 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "IRA" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_4.2)

#---- Ahora vamos a Realizar el Match con los Datos del Denominador.

