

# ================================================
# YA 4 Cultura Paz, Reconsiliación y Convivencia  
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr", "data.table"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)
library(data.table)
library(readr)



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

# ====================================================
# Sección: Merge Data  
# ====================================================

procuraduria <- rbindlist(list(procu_2015, procu_2016, procu_2017, procu_2018, procu_2019, procu_2020, procu_2021, procu_2022, procu_2023), fill = TRUE)

# Limpiamos Memoria

rm(procu_2015, procu_2016, procu_2017, procu_2018, procu_2018, procu_2019, procu_2020, procu_2020, procu_2021, procu_2022, procu_2023)


# Filtramos los Datos

procuraduria <- procuraduria[, c(2, 4, 6, 7, 8, 9, 10)]


# Rename de Variables

procuraduria   <- rename(procuraduria , codmpio = `Código Municipio`, anno = `Periodo del Indicador`)

# Pasamos de Long a Wide


  pivot_wider(names_from = nombre_prueba, values_from = promedio_ponderado)

# Separamos el CODMPIO del Nombre del Municipio

YA_1.3$codmpio <- str_replace(YA_1.3$codmpio, " - .*", "")

# ====================================================
# Sección: Filtrar 
# ====================================================

procuraduria_0a5 <- procuraduria %>%
  filter(`Rangos de edad o edades simples` == "(01 a 05)")

procuraduria_0a5  <-procuraduria_0a5  %>%
  select(-`Rangos de edad o edades simples`)


procuraduria_0a5 <- procuraduria %>%
  pivot_wider(
    names_from = `Nombre del indicador`,
    values_from = c(`Numerador (casos)`, `Denominador (Población)`, `Resultado (Tasa)`),
    values_fn = list(`Numerador (casos)` = sum, `Denominador (Población)` = sum, `Resultado (Tasa)` = mean)
  )



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


