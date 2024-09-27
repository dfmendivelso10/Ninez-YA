# Librerías y Paquetes

import pandas as pd

# Importamos los Datos

ICBF = pd.read_excel(
    "/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ICBF_SRPA.xlsx",
    sheet_name="SRPA_1",
)

codmpio = pd.read_excel(
    "/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/codmpio.xlsx"
)

#  Vamos a Crear el Denominador para menores de edad --- 14 a 17 por region con y sin medida privativa de libertad

# Normalizar y reemplazar nombres de Departamento en las bases de datos ICBF y codmpio

# Para ICBF
ICBF["Departamento"] = (
    ICBF["Departamento"]
    .str.strip()
    .str.upper()
    .replace({"VALLE DEL CAUCA": "VALLE", "LA GUAJIRA": "GUAJIRA"})
)

# Para codmpio
codmpio["Departamento"] = (
    codmpio["Departamento"]
    .str.strip()
    .str.upper()
    .replace({"VALLE DEL CAUCA": "VALLE", "LA GUAJIRA": "GUAJIRA"})
)
