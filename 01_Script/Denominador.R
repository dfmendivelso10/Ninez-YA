
## Librerías 

# Revisar las librerias.

install.packages(c("dplyr", "openxlsx", "readxl"))

library(dplyr)
library(openxlsx)
library(readxl)

## Importamos el Data Set del Censo. *Nota: Siempre ajustar el archivo .xlsx antes de importarlo
## y pegar los valores sin formato en otra hoja de cáculo. 

## Pueden ajustar su working directory, por mi parte lo hago de esta manera para tener el REPO en GIT
## Importamos la Data

CENSO_2005_2019 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/CENSO_2005_2019.xlsx")

CENSO_2020_2030 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/CENSO_2020_2030.xlsx")

# ================================================
# Aspectos Generales y Limpieza Básica
# ================================================

## La base tiene proyecciones de poblacion por Edad y Sexo, Tomamos el Total que es la suma de Urbano y Rural

## Nota: Revisar el nombre de las variables, el DANE puede cambiarlos.

# Filtramos en la base la columna "Total"

CENSO_2005_2019 <- CENSO_2005_2019  %>% 
  filter(`ÁREA GEOGRÁFICA` == "Total")

CENSO_2020_2030 <- CENSO_2020_2030  %>% 
  filter(`ÁREA GEOGRÁFICA` == "Total")

# Eliminamos las Variables que solo tienen información de hombres y mujeres, dejamos solo "Total_#" que reune la población por edad
# de hombres y mujeres.

menores_2005_2019 <- CENSO_2005_2019  %>% 
  select(-(Hombres_0:`Mujeres_85 y más`))

menores_2020_2030 <- CENSO_2020_2030  %>% 
  select(-(Hombres_0:`Mujeres_85 y más`))

# ================================================
# Sección: Menores de 18 años
# ================================================

# Vamos a crear una Nueva Variable llamada total_menores_18, esta variable suma la población de 0 a 17 años-
# 7 y 24 son los números de las columnas que corresponden desde Total_0 ... Total_17. 

menores_18_2005_2019 <- menores_2005_2019  %>% 
  mutate(total_menores_18 = rowSums(menores_2005_2019[ , c(7:24)]))

menores_18_2020_2030 <- menores_2020_2030  %>% 
  mutate(total_menores_18 = rowSums(menores_2020_2030[ , c(7:24)]))

## Vamos a construir nuestra Base Final filtrando las variables que solo necesitamos, dada la base que tenemos:
# La Variable 4 = "MPIO" el identificador del Municipio pa la Base menores_18_2005_2019 
# La Variable 3 = "MPIO" el identificador del Municipio pa la Base menores_18_2020_2030
# La Variable 5 = "AÑO" el año
# La Variable 96 = "total_menores_18" la variable que creamos

menores_18_2005_2019 <- menores_18_2005_2019 %>% select(4,5,96)

menores_18_2020_2030 <- menores_18_2020_2030 %>% select(3,5,96)

## Exportamos los Archivos

write.xlsx(menores_18_2005_2019,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_18_2005-2009.xlsx", col_names = TRUE)

write.xlsx(menores_18_2020_2030,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_18_2020-2030.xlsx", col_names = TRUE)


# ================================================
# Sección: Menores de 5 Años
# ================================================

# Vamos a crear una Nueva Variable llamada total_menores_5, esta variable suma la población de 0 a 4 años-
# 7 y 11 son los números de las columnas que corresponden desde Total_0 ... Total_4. 

menores_5_2005_2019 <- menores_2005_2019  %>% 
  mutate(total_menores_5 = rowSums(menores_2005_2019[ , c(7:11)]))

menores_5_2020_2030 <- menores_2020_2030  %>% 
  mutate(total_menores_5 = rowSums(menores_2020_2030[ , c(7:11)]))

## Vamos a construir nuestra Base Final filtrando las variables que solo necesitamos, dada la base que tenemos:
# La Variable 4 = "MPIO" el identificador del Municipio para la Base menores_5_2005_2019
# La Variable 3 = "MPIO" el identificador del Municipio para la Base menores_5_2020_2030
# La Variable 5 = "AÑO" el año
# La Variable 96 = "total_menores_18" la variable que creamos

menores_5_2005_2019 <- menores_5_2005_2019 %>% select(4,5,96)

menores_5_2020_2030 <- menores_5_2020_2030 %>% select(3,5,96)

## Exportamos los Archivos

write.xlsx(menores_5_2005_2019,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_5_2005-2009.xlsx", col_names = TRUE)

write.xlsx(menores_5_2020_2030,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_5_2020-2030.xlsx", col_names = TRUE)


# ================================================
# Sección: Menores de 1 Año
# ================================================

# Vamos a crear una Nueva Variable llamada total_menores_5, esta variable suma la población de 0 a 4 años-
# 7 y 11 son los números de las columnas que corresponden desde Total_0 ... Total_4. 

menores_1_2005_2019 <- menores_2005_2019  %>% 
  mutate(total_menores_1 = rowSums(menores_2005_2019[ , c(7)]))

menores_1_2020_2030 <- menores_2020_2030  %>% 
  mutate(total_menores_1 = rowSums(menores_2020_2030[ , c(7)]))

## Vamos a construir nuestra Base Final filtrando las variables que solo necesitamos, dada la base que tenemos:
# La Variable 4 = "MPIO" el identificador del Municipio para la Base menores_5_2005_2019
# La Variable 3 = "MPIO" el identificador del Municipio para la Base menores_5_2020_2030
# La Variable 5 = "AÑO" el año
# La Variable 96 = "total_menores_18" la variable que creamos

menores_1_2005_2019 <- menores_1_2005_2019 %>% select(4,5,96)

menores_1_2020_2030 <- menores_1_2020_2030 %>% select(3,5,96)

## Exportamos los Archivos

write.xlsx(menores_1_2005_2019,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_1_2005-2009.xlsx", col_names = TRUE)

write.xlsx(menores_1_2020_2030,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_1_2020-2030.xlsx", col_names = TRUE)



# ================================================
# Sección: Append de las Bases de Datos
# ================================================


# Combinar los data frames usando dplyr

menores_1_años <- bind_rows(menores_1_2005_2019, menores_1_2020_2030)
menores_5_años <- bind_rows(menores_5_2005_2009, menores_5_2020_2030)
menores_18_años <- bind_rows(menores_18_2005_2009, menores_18_2020_2030)

## Exportamos los Archivos

write.xlsx(menores_1_años,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_1_años.xlsx", col_names = TRUE)

write.xlsx(menores_5_años,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_5_años.xlsx", col_names = TRUE)

write.xlsx(menores_18_años,"/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_18_años.xlsx", col_names = TRUE)



