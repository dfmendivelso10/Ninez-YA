# ============================================================
# YA 1.7 Tasa de Mortalidad Neonatal
# ============================================================

# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "lubridate"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Vamos a Cargar las Bases de Datos

YA_1.7 <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/neonatal.xlsx" )

nacidos_vivos <- read.xlsx("/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/nacidos_vivos.xlsx")


# Vamos a limpiar el numerador 

# Borramos la Variable Total General

YA_1.7 <- YA_1.7[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

YA_1.7$codmpio <- str_replace(YA_1.7$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.7 <- YA_1.7 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "mortalidad_neonatal" # Nuevo nombre de columna para los valores
  )


# Borramos Total General de YA_1.7

YA_1.7 <- YA_1.7 %>%
  filter(codmpio != "Total general")


#------------------------------------------
# Vamos a limpiar el denominador
#------------------------------------------


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

class(YA_1.7$codmpio)
class(YA_1.7$anno)
class(YA_1.7$mortalidad_menores_1_año) # Podemos hacerlo paara cada una de las variables

# Cambiamos de String a Numeric

YA_1.7 <- YA_1.7 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.7 <- YA_1.7 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.7 <- inner_join(nacidos, YA_1.7, by = c("codmpio","anno"))

# Creamos la Tasa de Mortalidad por Desnutricion Aguda en Menores

# Crear una nueva variable 'tasa_mortalidad_neonatal_corregida' sin alterar las variables originales
YA_1.7 <- YA_1.7 %>%
  mutate(
    # Calcular la tasa de mortalidad neonatal corregida
    tasa_mortalidad_neonatal= ifelse(
      nacimientos > 0 & mortalidad_neonatal <= nacimientos,  # Calcular tasa solo si nacidos > 0 y mortalidad_neonatal <= nacidos
      (mortalidad_neonatal / nacimientos) * 1000,        # Fórmula de la tasa por cada 1000 nacidos
      NA                                            # Asignar NA si no se cumple la condición
    )
  )


write.xlsx(YA_1.7, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.7.xlsx", col_names = TRUE)

# Fin del Código
