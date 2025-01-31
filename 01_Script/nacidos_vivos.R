
## Librerías 

# ================================================
# Nacidos Vivos
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Cargamos el Data-Set

nacidos_vivos <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/nacidos_vivos.xlsx")

# Borramos la Variable Total General

nacidos_vivos <- nacidos_vivos[ , -22]

# Separamos el CODMPIO del Nombre del Municipio

nacidos_vivos$codmpio <- str_replace(nacidos_vivos$codmpio, " - .*", "")


# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

nacidos_vivos <- nacidos_vivos %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "nacimientos" # Nuevo nombre de columna para los valores
  )

# Verificamos la Estructura de los Datos

class(nacidos_vivos$codmpio)
class(nacidos_vivos$anno)
class(nacidos_vivos$nacimientos) # Podemos hacerlo paara cada una de las variables

# Cambiamos de String a Numeric

nacidos_vivos <- nacidos_vivos %>%
  mutate(codmpio = as.numeric(codmpio))

nacidos_vivos <- nacidos_vivos %>%
  mutate(anno = as.numeric(anno))


# Exportamos la Versión Final de Nuestro Denominador Nacimientos

write.xlsx(nacidos_vivos, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/nacidos_vivos.xlsx", col_names = TRUE)


