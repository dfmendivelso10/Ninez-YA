# ================================================
# YA 3 Saber 11
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)

# Cargar los Datos

X2016 <- read_delim("Downloads/Raw_DATA/2016.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2017 <- read_delim("Downloads/Raw_DATA/2017.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2018 <- read_delim("Downloads/Raw_DATA/2018.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2019 <- read_delim("Downloads/Raw_DATA/2019.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2020 <- read_delim("Downloads/Raw_DATA/2020.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)

X2021 <- read_delim("Downloads/Raw_DATA/2021.txt", delim = "/", escape_double = FALSE, trim_ws = TRUE)


# Limpiamos las Bases  de Datos

X2016 <- X2016[ , -c(2:10)]
X2017 <- X2017[ , -c(2:10)]
X2018 <- X2018[ , -c(2:10)]
X2019 <- X2019[ , -c(2:10)]
X2020 <- X2020[ , -c(2:10)]
X2021 <- X2021[ , -c(2:10)]




