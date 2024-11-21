

# ================================================
# YA 1.4 Proporción de nacidos vivos con 4 o más controles prenatales
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)


# Cargamos Nuestras Bases de Datos

YA_1.4 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_1.4.xlsx")

nacidos_vivos <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/nacidos_vivos.xlsx")

# Borramos la Variable Total General

YA_1.4 <- YA_1.4[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

YA_1.4$codmpio <- str_replace(YA_1.4$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.4 <- YA_1.4 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "controles_prenatales" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_1.4)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos

class(YA_1.4$codmpio)
class(YA_1.4$anno)
class(YA_1.4$controles_prenatales) # Podemos hacerlo paara cada una de las variables

# Cambiamos de String a Numeric

YA_1.4 <- YA_1.4 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.4 <- YA_1.4 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.4 <- inner_join(nacidos_vivos, YA_1.4, by = c("codmpio","anno"))

# Creamos la Tasa de mortalidad por Infección Respmortalidad_menores_5toria Aguda (mortalidad_menores_5) en menores de 5 años

YA_1.4 <- YA_1.4 %>% 
  mutate(proporcion_controles_prenatales = ( controles_prenatales / nacimientos)*100) 

# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.4, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.4.xlsx", col_names = TRUE)

# Fin del Código


