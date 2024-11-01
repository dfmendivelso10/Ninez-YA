# ==============================================================
# YA 2.7 Tipo de Sector de la Institución Educativa
# de la Niñez
# ==============================================================

# Este Script contiene el tipo de sector 'Oficial' o 'No Oficial'
# al que asistenten los estudiantes en Colombia.
# ==============================================================

# Importar librerías
import pandas as pd

# Cargamos los datos

sector = pd.read_csv(r'/Users/daniel/Desktop/MEN_MATRICULA_2024.csv')

# Limpiamos los datos

sector = sector[['ANNO_INF', 'COD_DANE_MUNICIPIO',
                 'SECTOR', 'TOTAL_MATRICULA']]

# Renombramos las variables

sector = sector.rename(columns={'ANNO_INF': 'anno', 'Año': 'anno',
                       'COD_DANE_MUNICIPIO': 'codmpio', 'SECTOR': 'sector', 'TOTAL_MATRICULA': '#_estudiantes'})

# Agrupamos los datos y sumamos el número de estudiantes
sector_resultado = sector.groupby(['anno', 'codmpio', 'sector'])[
    '#_estudiantes'].sum().reset_index()

# Exportamos los datos

sector_resultado.to_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_2.7.xlsx', index=False)
