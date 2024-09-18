

# ================================================
# YA 4 Cultura Paz, Reconsiliación y Convivencia  
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)



# Cargamos los Chunks de las Bases de Datos

procu_2015 <- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2015.xlsx", sheet = "Ind. Patología")
procu_2016<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2016.xlsx", sheet = "Ind. Patología")
procu_2017<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2017.xlsx", sheet = "Ind. Patología")
procu_2018<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2018.xlsx", sheet = "Ind. Patología")
procu_2019<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2019.xlsx", sheet = "Ind. Patología")
procu_2020<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2020.xlsx", sheet = "Ind. Patología")
procu_2021<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2021.xlsx", sheet = "Ind. Patología")
procu_2022<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2022.xlsx", sheet = "Ind. Patología")
procu_2023<- read_excel("Documents/GitHub/Ninez-YA/02_RAW-Data/Procuraduria/Procuraduría_2023.xlsx", sheet = "Ind. Patología")






# Filtramos los Datos

procu_2015 <- procu_2015[, c(2, 4, 6, 7, 8, 9, 10)]


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

write.xlsx(YA_1.3_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/VF_YA_1.3.xlsx", col_names = TRUE)

# Fin del Código


