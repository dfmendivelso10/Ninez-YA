

# ================================================
# YA 1.6 Proporción de nacidos vivos con Bajo Peso al Nacer
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)



# Cargamos Nuestra Base YA_1.6

YA_1.6 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_1.6.xlsx")

# Borramos la Variable Total General

YA_1.6 <- YA_1.6[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

YA_1.6$codmpio <- str_replace(YA_1.6$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_1.6 <- YA_1.6 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "bajo_peso_nacer" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_1.6)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_1.6$codmpio)
class(YA_1.6$anno)
class(YA_1.6$controles_prenatales) # Podemos hacerlo paara cada una de las variables
class(VF_nacidos_vivos$codmpio)
class(VF_nacidos_vivos$anno)
class(VF_nacidos_vivos$nacidos_vivos)

# Cambiamos de String a Numeric

YA_1.6 <- YA_1.6 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_1.6 <- YA_1.6 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join * Cargamos el DataSet nacidos_vivos

YA_1.6_VF <- inner_join(VF_nacidos_vivos, YA_1.6, by = c("codmpio","anno"))

# Creamos la Tasa de mortalidad por Infección Respmortalidad_menores_5toria Aguda (mortalidad_menores_5) en menores de 5 años

YA_1.6_VF <- YA_1.6_VF %>% 
  mutate(bajo_peso_nacer = ( bajo_peso_nacer / nacidos_vivos)*100) 


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.6_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/VF_YA_1.6.xlsx", col_names = TRUE)

# Fin del Código


