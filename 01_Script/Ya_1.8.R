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

YA_1.8 <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/menores_1_año.xlsx" )

nacidos <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/nacidos_vivos.xlsx")


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


# Borramos Total General de YA_1.8

YA_1.8 <- YA_1.8 %>%
  filter(codmpio != "Total general")


#------------------------------------------
# Vamos a limpiar el denominador
#------------------------------------------

nacidos <- nacidos[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

nacidos$codmpio <- str_replace(nacidos$codmpio, " - .*", "")


# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

nacidos <- nacidos %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "nacidos" # Nuevo nombre de columna para los valores
  )

# Borramos Total General de Codmpio

nacidos <- nacidos %>%
  filter(codmpio != "Total general")


# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_1.8$codmpio)
class(YA_1.8$anno)
class(YA_1.8$mortalidad_menores_1_año) # Podemos hacerlo paara cada una de las variables
class(nacidos$codmpio)
class(nacidos$anno)
class(nacidos$nacidos)

# Cambiamos de String a Numeric

YA_1.8 <- YA_1.8 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.8 <- YA_1.8 %>%
  mutate(anno = as.numeric(anno))

nacidos <- nacidos %>%
  mutate(codmpio = as.numeric(codmpio))

nacidos <- nacidos %>%
  mutate(anno = as.numeric(anno))


# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.8 <- inner_join(nacidos, YA_1.8, by = c("codmpio","anno"))

# Creamos la Tasa de Mortalidad por Desnutricion Aguda en Menores

YA_1.8 <- YA_1.8 %>% 
  mutate(tasa_mortalidad_menores_1_año = (mortalidad_menores_1_año / nacidos)* 1000) # Esto es una tasa x 1000 nacidos vivos


YA_1.8 <- YA_1.8 %>%
  mutate(
    # Calcular la tasa de mortalidad neonatal corregida
    tasa_mortalidad_menores_1_año= ifelse(
      nacidos > 0 & mortalidad_menores_1_año <= nacidos,  # Calcular tasa solo si nacidos > 0 y mortalidad_neonatal <= nacidos
      (mortalidad_menores_1_año / nacidos) * 1000,        # Fórmula de la tasa por cada 1000 nacidos
      NA                                            # Asignar NA si no se cumple la condición
    )
  )


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.8, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.8.xlsx", col_names = TRUE)

# Fin del Código
