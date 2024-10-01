# ================================================
# YA 1.8 Tasa de Mortalidad Menores de 1 Año 
# ================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Vamos a Cargar las Bases de Datos

YA_1.8 <- read.xlsx("D:/Users/enflujo/Documents/GitHub/Ninez-YA/02_RAW-Data/menores_1_año.xlsx" )

menores_1_años <- read.xlsx("D:/Users/enflujo/Documents/GitHub/Ninez-YA/03_Process/menores_1_años.xlsx")


# Vamos a limpiar el numerador 

# Borramos la Variable Total General

YA_1.8 <- YA_1.8[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

YA_1.8$codmpio <- str_replace(YA_1.8$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.8 <- YA_1.8 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "mortalidad_menores_1_año" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_1.8)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_1.8$codmpio)
class(YA_1.8$anno)
class(YA_1.8$mortalidad_menores_1_año) # Podemos hacerlo paara cada una de las variables
class(menores_1_años$codmpio)
class(menores_1_años$anno)
class(menores_1_años$total_menores_1)

# Cambiamos de String a Numeric

YA_1.5 <- YA_1.5 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.5 <- YA_1.5 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.5_VF <- inner_join(menores_5_años, YA_1.5, by = c("codmpio","anno"))

# Creamos la Tasa de Mortalidad por Desnutricion Aguda en Menores

YA_1.5_VF <- YA_1.5_VF %>% 
  mutate(tasa_desnutricion_menores_5 = (desnutricion_menores_5 / total_menores_5)* 100000) 


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.5_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/VF_YA_1.5.xlsx", col_names = TRUE)

# Fin del Código
