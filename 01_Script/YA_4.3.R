

# ================================================
# YA 4.3 Tasa de mortalidad por Infección Respiratoria Aguda (IRA) en menores de 5 años
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)



# Cargamos Nuestra Base YA_4.2

YA_4.2 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_4.2.xlsx")

# Borramos la Variable Total General

YA_4.2 <- YA_4.2[ , -22]

# Separamos el CODMPIO del Nombre del Municipio

YA_4.2$codmpio <- str_replace(YA_4.2$codmpio, " - .*", "")

# Organizamos la Base de Datos, estos están en Wide, de manera que
# los vamos a convertir a Longer.

YA_4.2 <- YA_4.2 %>%
  pivot_longer(
    cols = starts_with("20"), # Seleccionamos las columnas que empiezan con "20" (años desde 2000)
    names_to = "anno", # Nuevo nombre de columna para los nombres de las columnas originales
    values_to = "IRA" # Nuevo nombre de columna para los valores
  )

# Podemos validar el formato Long

head(YA_4.2)

# ====================================================
# Sección: Merge Data  
# ====================================================

# Verificamos la Estructura de los Datos, por ejemplo

class(YA_4.2$codmpio)
class(YA_4.2$anno)
class(YA_4.2$IRA) # Podemos hacerlo paara cada una de las variables
class(menores_5_años$codmpio)
class(menores_5_años$anno)
class(menores_5_años$total_menores_5)

# Cambiamos de String a Numeric

YA_4.2 <- YA_4.2 %>%
  mutate(codmpio = as.numeric(codmpio))

YA_4.2 <- YA_4.2 %>%
  mutate(anno = as.numeric(anno))

# Realizamos el Inner Join

YA_4.2_VF <- inner_join(menores_5_años, YA_4.2, by = c("codmpio","anno"))

# Creamos la Tasa de mortalidad por Infección Respiratoria Aguda (IRA) en menores de 5 años

YA_4.2_VF <- YA_4.2_VF %>% 
  mutate(tasa_IRA = (IRA / total_menores_5) * 100000)


# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_4.2_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/VF_YA_4.2.xlsx", col_names = TRUE)

# Fin del Código


