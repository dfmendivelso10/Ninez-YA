


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)


library(dplyr)

# Cargamos Nuestra Base YA_1.4

YA_1.4 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_1.4.xlsx")

# Borramos la Variable Total General

YA_1.4 <- YA_1.4[ , -21]

ls()

View(YA_1.4)


library(vscDebugger)
nano ~/.Rprofile
