
library(dplyr)
library(openxlsx)
library(readxl)

## Importamos el Data Set del Censo. *Nota: Siempre ajustar el archivo .xlsx antes de importarlo
## y pegar los valores sin formato en otra hoja de cáculo. 

CENSO_2005_2019 <- read_excel("~/Downloads/CENSO_2005_2019.xlsx")

## Censo 2005 -2019 Con Proyecciones de Poblacion por Edad y Sexo, Tomamos el Total
## Urbano y Rural

## Ahora vamos a Construir el Denominador

## Filtramos la Poblacion Total elimando las observaciones que solo tienen rural o urbano

CENSO_2005_2019 <- CENSO_2005_2019  %>% 
  filter(area_geografica == "Total")

## Eliminamos las Variables que solo tienen información sobre la población de hombres y mujeres
## Recordemos que este DATA Set tiene un alto nivel de desagregación, nos quedamos con el valor total.

censo_filtrado <- CENSO_2005_2019  %>% 
  select(-(Hombres_0:`Mujeres_85 y más`))

## Borrams las variables total hombres, total mujeres, y total general porque solo nos interesa la población
## de 0 a 17 años.

censo_filtrado <- censo_filtrado   %>% 
  select(-(`Total Hombres`:`Total General`))

## Vamos a crear una Nueva Variable llamada Menores, esta variable suma la población de 0 a 17 años

censo_filtrado <- censo_filtrado   %>% 
  mutate(menores = rowSums(censo_filtrado[ , c(4:21)]))

## Obtenemos el Denomimandor base
poblacion_menores <-censo_filtrado %>% select(-(3:89))

## Exportamos

setwd("/Users/df.mendivelso10/Desktop/IMAGINA")
write.xlsx(poblacion_menores,"/Users/df.mendivelso10/Desktop/IMAGINA/censo_denominador.xlsx", col_names = TRUE)


##### Vamos a construir la siguiente serie del Censo 2020 en adelante.


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
  mutate(menores = rowSums(censo_filtrado_2020[ , c(4:21)]))

## Obtenemos el Denomimandor base
poblacion_menores_2020 <-censo_filtrado_2020 %>% select(-(3:89))

### Ahora vamos a hacer el append, primero fijamos las mismas variables

censo_filtrado <- censo_filtrado %>% select(-`area_geografica`)
censo_filtrado_2020 <- censo_filtrado_2020 %>% select(-`ÁREA GEOGRÁFICA`)


censo_completo <- rbind(censo_filtrado,censo_filtrado_2020)

## Filtramos los años que necesitamos solamente

censo_completo <- censo_completo %>% filter(anno >= 2005 & anno <= 2023)

## Filtramos las demás variables restantes.

censo_completo <- censo_completo  %>% select(`codmpio`, `anno`, `menores`)


write_xlsx(df,"/Users/df.mendivelso10/Desktop/IMAGINA/VF_YA8.8.4xlsx", col_names = TRUE)

getwd()

