

# ================================================
# YA 1.3 Mortalidad en niños menores de 5 años 
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)



# Cargamos Nuestra Base YA_1.3

YA_1.3 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_1.3.xlsx")

# Borramos la Variable Total General

YA_1.3 <- YA_1.3[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

YA_1.3$codmpio <- str_replace(YA_1.3$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.3 <- YA_1.3 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "mortalidad_menores_5" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_1.3)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_1.3$codmpio)
class(YA_1.3$anno)
class(YA_1.3$mortalidad_menores_5) # Podemos hacerlo paara cada una de las variables
class(menores_5_años$codmpio)
class(menores_5_años$anno)
class(menores_5_años$total_menores_5)

# Cambiamos de String a Numeric

YA_1.3 <- YA_1.3 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.3 <- YA_1.3 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join * Cargamos el DataSet menores_5_años

YA_1.3_VF <- inner_join(menores_5_años, YA_1.3, by = c("codmpio","anno"))

# Creamos la Tasa de mortalidad por cualquier condición

YA_1.3_VF <- YA_1.3_VF %>% 
  mutate(tasa_mortalidad_menores_5 = (mortalidad_menores_5 / total_menores_5) * 1000)


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.3_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.3.xlsx", col_names = TRUE)

# Fin del Código


