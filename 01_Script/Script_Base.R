
####### Indicadores Primera Infancia MinSalud


### Librería 

install.packages("lubridate",dependencies = TRUE)
install.packages("dplyr")

library(readr)
library(lubridate)
library(dplyr)


help("lubridate-package")
##### Vamos a importar la Data 

MEN_primera_infancia <- read_csv("D:/enflujo/Downloads/MEN_INDICADORES_PRIMERA_INFANCIA_20240419.csv")


# Convertir la variable fecha al formato de fecha
MEN_primera_infancia$FECHA <- as.Date(MEN_primera_infancia$FECHA, format = "%d-%m-%Y")

# Extraer los días, meses y años

MEN_primera_infancia$dia <- day(MEN_primera_infancia$FECHA)
MEN_primera_infancia$mes <- month(MEN_primera_infancia$FECHA)
MEN_primera_infancia$año <- year(MEN_primera_infancia$FECHA)

MEN_primera_infancia$pedro <- NA
# Verificar los resultados
head(MEN_primera_infancia)

                                     


