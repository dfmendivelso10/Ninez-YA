

# ================================================
# YA 1.5 Tasa de Mortalidad por Desnutricion Aguda en Menores 5 años
# ================================================
# Librerías y Paquetes

install.packages(c("dplyr", "openxlsx", "readxl", "tidyr", "stringr"))


library(tidyr)
library(dplyr)
library(openxlsx)
library(readxl)
library(stringr)


# Cargar los datos
YA_1.5 <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_1.5.xlsx")

menores_5_años <- read_excel("/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/menores_5_años.xlsx")

# Eliminar la columna 'Total General' (suponiendo que es la columna 21)
YA_1.5 <- YA_1.5[, -21]

# Separar el 'codmpio' del nombre del municipio
YA_1.5$codmpio <- str_replace(YA_1.5$codmpio, " - .*", "")

# Convertir la base de datos de formato ancho a formato largo
YA_1.5 <- YA_1.5 %>%
  pivot_longer(
    cols = starts_with("20"), # Selecciona las columnas que empiezan con "20" (años)
    names_to = "anno", # Nombre de la nueva columna para los años
    values_to = "desnutricion_menores_5" # Nombre de la nueva columna para los valores
  )

# Validar el formato largo
head(YA_1.5)

# ====================================================
# Sección: Unir Datos  
# ====================================================

# Verificar la estructura de los datos para asegurar compatibilidad en la unión
str(YA_1.5)
str(menores_5_años)

# Convertir 'codmpio' y 'anno' a tipo numérico para asegurar que coincidan en ambas bases
YA_1.5 <- YA_1.5 %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

menores_5_años <- menores_5_años %>%
  mutate(
    codmpio = as.numeric(codmpio),
    anno = as.numeric(anno)
  )

# Realizar el inner join para unir las bases de datos
YA_1.5_VF <- inner_join(menores_5_años, YA_1.5, by = c("codmpio", "anno"))

# Crear la tasa de mortalidad por desnutrición aguda en menores de 5 años
YA_1.5_VF <- YA_1.5_VF %>% 
  mutate(tasa_desnutricion_menores_5 = (desnutricion_menores_5 / total_menores_5) * 100000)

# Mostrar los primeros registros para validar
head(YA_1.5_VF)

# Exportamos la Versión Final de Nuestro Indicador

write.xlsx(YA_1.5_VF, "/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_1.5.xlsx", col_names = TRUE)

# Fin del Código


