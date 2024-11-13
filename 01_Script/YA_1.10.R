# ============================================================
# YA 1.10 Partos Atendidos por Personal Calificado
# ============================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Vamos a Cargar las Bases de Datos

YA_1.10 <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/tipo_nacimiento.xlsx" )

nacidos_vivos <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/VF_nacidos_vivos.xlsx")


# Vamos a limpiar el numerador 

# Separamos el CODMPIO del Nombre del Municipio

YA_1.10$codmpio <- str_replace(YA_1.10$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.10 <- YA_1.10 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "partos_atendidos_calificado" # Nuevo nombre de columna para los valores
  )

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_1.10$codmpio)
class(YA_1.10$anno)
class(YA_1.10$partos_atendidos_calificado) # Podemos hacerlo paara cada una de las variables
class(nacidos_vivos$codmpio)
class(nacidos_vivos$anno)
class(nacidos_vivos$nacidos_vivos)

# Cambiamos de String a Numeric

YA_1.10 <- YA_1.10 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.10 <- YA_1.10 %>%
  mutate(anno = as.numeric(anno))

nacidos_vivos <- nacidos_vivos %>%
  mutate(codmpio = as.numeric(codmpio))

nacidos_vivos<- nacidos_vivos %>%
  mutate(anno = as.numeric(anno))


# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.10 <- inner_join(nacidos_vivos, YA_1.10, by = c("codmpio","anno"))

# Creamos el Porcentaje de Nacidos Vivos por Personal Calififado

YA_1.10 <- YA_1.10 %>% 
  mutate(porcentaje_nacidos_vivos_personal_calificado = (partos_atendidos_calificado /nacidos_vivos)* 100) # Esto es un porcentaje


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.10, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.10.xlsx", col_names = TRUE)

# Fin del Código
