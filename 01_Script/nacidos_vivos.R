

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



# Cargamos Nuestra Base nacidos_vivos

nacidos_vivos <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/nacidos_vivos.xlsx")

# Borramos la Variable Total General

nacidos_vivos <- nacidos_vivos[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

nacidos_vivos$codmpio <- str_replace(nacidos_vivos$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

nacidos_vivos <- nacidos_vivos %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "nacidos_vivos" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(nacidos_vivos)

# ====================================================
# Sección: Limpieza y Adecuación 
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(nacidos_vivos$codmpio)
class(nacidos_vivos$anno)
class(nacidos_vivos$mortalidad_menores_5) # Podemos hacerlo paara cada una de las variables
class(menores_5_años$codmpio)
class(menores_5_años$anno)
class(menores_5_años$total_menores_5)

# Cambiamos de String a Numeric

nacidos_vivos <- nacidos_vivos %>%
  mutate(codmpio = as.numeric(codmpio))

nacidos_vivos <- nacidos_vivos %>%
  mutate(anno = as.numeric(anno))
         
# Exportamos la Versión Final de Nuestro Indicador de Nacidos Vivos
         
write.xlsx(nacidos_vivos, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/VF_nacidos_vivos.xlsx", col_names = TRUE)

# Fin del Código
         
         
         