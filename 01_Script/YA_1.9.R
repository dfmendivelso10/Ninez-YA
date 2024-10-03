# ============================================================
# YA 1.9 Tasa de Mortalidad por Desnutrición en menores 5 años
# ============================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Vamos a Cargar las Bases de Datos

YA_1.9 <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/desnutricion_menores_5.xlsx" )

total_menores_5 <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_5_años.xlsx")


# Vamos a limpiar el numerador 

# Separamos el CODMPIO del Nombre del Municipio

YA_1.9$codmpio <- str_replace(YA_1.9$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.9 <- YA_1.9 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "mortalidad_desnutricion_5" # Nuevo nombre de columna para los valores
  )

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_1.9$codmpio)
class(YA_1.9$anno)
class(YA_1.9$mortalidad_desnutricion_5) # Podemos hacerlo paara cada una de las variables
class(total_menores_5$codmpio)
class(total_menores_5$anno)
class(total_menores_5$total_menores_5)

# Cambiamos de String a Numeric

YA_1.9 <- YA_1.9 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.9 <- YA_1.9 %>%
  mutate(anno = as.numeric(anno))

total_menores_5 <- total_menores_5 %>%
  mutate(codmpio = as.numeric(codmpio))

total_menores_5 <- total_menores_5 %>%
  mutate(anno = as.numeric(anno))


# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.9 <- inner_join(total_menores_5, YA_1.9, by = c("codmpio","anno"))

# Creamos la Tasa de Mortalidad por Desnutricion Aguda en Menores

YA_1.9 <- YA_1.9 %>% 
  mutate(tasa_mortalidad_desnutricion_5_años = (mortalidad_desnutricion_5 / total_menores_5)* 1000) # Esto es una tasa x 1000 nacidos vivos


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.9, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.9.xlsx", col_names = TRUE)

# Fin del Código
