
## Librerías 

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
# Aspectos Generales
# ================================================

## La base tiene proyecciones de poblacion por Edad y Sexo, Tomamos el Total que es la suma de Urbano y Rural

## Nota: Revisar el nombre de las variables, el DANE puede cambiarlos.

# Filtramos en la base la columna "Total"

CENSO_2005_2019 <- CENSO_2005_2019  %>% 
  filter(`ÁREA GEOGRÁFICA` == "Total")

CENSO_2020_2030 <- CENSO_2020_2030  %>% 
  filter(`ÁREA GEOGRÁFICA` == "Total")


# ================================================
# Sección: Menores de 18 años
# ================================================


# Eliminamos las Variables que solo tienen información de hombres y mujeres, dejamos solo "Total_#" que reune la población por edad
# de hombres y mujeres.

menores_18_2005_2019 <- CENSO_2005_2019  %>% 
  select(-(Hombres_0:`Mujeres_85 y más`))

menores_18_2020_2030 <- CENSO_2020_2030  %>% 
  select(-(Hombres_0:`Mujeres_85 y más`))

# Vamos a crear una Nueva Variable llamada total_menores_18, esta variable suma la población de 0 a 17 años-
# 7 y 24 son los números de las columnas que corresponden desde Total_0 ... Total_17. 

menores_18_2005_2019 <- menores_18_2005_2019  %>% 
  mutate(total_menores_18 = rowSums(menores_18_2005_2019[ , c(7:24)]))

menores_18_2020_2030 <- menores_18_2020_2030  %>% 
  mutate(total_menores_18 = rowSums(menores_18_2020_2030[ , c(7:24)]))

## Vamos a construir nuestra Base Final filtrando las variables que solo necesitamos, dada la base que tenemos:
# La Variable 4 = "MPIO" el identificador del Municipio
# La Variable 5 = "AÑO" el año
# La Variable 96 = "total_menores_18" la variable que creamos

menores_18_2005_2019 <- menores_18_2005_2019 %>% select(4,5,96)

menores_18_2020_2030 <- menores_18_2020_2030 %>% select(4,5,96)

## Exportamos


write.xlsx(poblacion_menores,"/Users/df.mendivelso10/Documents/GitHub/Ninez-YA/03_Process/poblacion_total_2005-2009.xlsx", col_names = TRUE)


##### Vamos a construir la serie del Censo 2020 en adelante.


## Filtramos la Poblacion Total elimando las observaciones que solo tienen rural o urbano

CENSO_2020_2030 <- CENSO_2020_2030  %>% 
  filter(`ÁREA GEOGRÁFICA` == "Total")


## Eliminamos las Variables que solo tienen información sobre la población de hombres y mujeres
## Recordemos que este DATA Set tiene un alto nivel de desagregación, nos quedamos con el valor total.

censo_filtrado_2020 <- CENSO_2020_2030  %>% 
  select(-(Hombres_0:`Mujeres_85 y más`))

## Borramos las variables total hombres, total mujeres, y total general porque solo nos interesa la población
## de 0 a 17 años.

censo_filtrado_2020 <- censo_filtrado_2020   %>% 
  select(-(`Total Hombres`:`Total`))

## Vamos a crear una Nueva Variable llamada Menores, esta variable suma la población de 0 a 17 años

censo_filtrado_2020 <- censo_filtrado_2020  %>% 
  mutate(menores = rowSums(censo_filtrado_2020[ , c(7:24)]))

## Obtenemos el Denomimandor base

poblacion_menores_2020 <-censo_filtrado_2020 %>% select(3,5,93)

### Ahora vamos a hacer el append, primero fijamos las mismas variables

censo_completo_menores <- rbind(poblacion_menores_2019,poblacion_menores_2020)

## Filtramos los años que necesitamos solamente

censo_completo <- censo_completo %>% filter(anno >= 2005 & anno <= 2023)

## Exportamos

write_xlsx(df,"/Users/df.mendivelso10/Desktop/IMAGINA/VF_YA8.8.4xlsx", col_names = TRUE)

getwd()


# ================================================
# Sección: Menores de 5 Años
# ================================================

