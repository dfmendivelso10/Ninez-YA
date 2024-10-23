## Librerías 

# Revisar las librerias.

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)


# Cargamos Base menores 5 años

# Cargamos Nuestra Base YA_4.1

YA_4.1 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_4.1.xlsx")

# Cargamos la Base Menores de 5 años

menores_5_años <- read_excel("~/Documents/GitHub/Ninez-YA/03_Process/menores_5_años.xlsx")

# Borramos la Variable Total General

YA_4.1 <- YA_4.1[ , -21]

# Separamos el CODMPIO del Nombre del Municipio

YA_4.1$codmpio <- str_replace(YA_4.1$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_4.1 <- YA_4.1 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "EDA" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_4.1)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_4.1$codmpio)
class(YA_4.1$anno)
class(YA_4.1$EDA) # Podemos hacerlo paara cada una de las variables
class(menores_5_años$codmpio)
class(menores_5_años$anno)
class(menores_5_años$total_menores_5)

# Cambiamos de String a Numeric

YA_4.1 <- YA_4.1 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_4.1 <- YA_4.1 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join

# Asegurarse de que el formato de codmpio sea consistente en ambas bases

menores_5_años$codmpio <- sprintf("%05d", as.numeric(menores_5_años$codmpio))
YA_4.1$codmpio <- sprintf("%05d", as.numeric(YA_4.1$codmpio))

# Realizar el inner_join
YA_4.1_VF <- inner_join(menores_5_años, YA_4.1, by = c("codmpio", "anno"))

# Creamos la Tasa de mortalidad por Infección RespEDAtoria Aguda (EDA) en menores de 5 años

YA_4.1_VF <- YA_4.1_VF %>% 
  mutate(tasa_EDA = (EDA / total_menores_5) * 100000)


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_4.1_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_4.1.xlsx", col_names = TRUE)


### Dejarlo hasta el 2023




