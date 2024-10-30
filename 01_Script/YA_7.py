# ============================================================
# YA 7. Fortalecimiento Familiar del Cuidado y la Crianza
# de la Niñez
# ============================================================

# Este Script contiene una limpieza básica de los YA 7.1 y YA 7.2.
# Los datos de estos YA se enuentran en  el apartado Pobreza monetaria y pobreza monetaria extrema - DANE
# Los datos > 2021 no son comparables con las series anteriores, esto por un cambio en la metodología.
# De momento el DANE sigue trabajando en el empalme de las series.

# ============================================================
# Importar Librerías

import pandas as pd


# ============================================================
# YA 7.1 GINI
# ============================================================

# Importarmos los datos

gini = pd.read_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_7.2.xlsx')

# ============================================================
# Vamos a imputar el coddepto para cada uno de los departamentos.

coddepto = pd.read_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/coddepto.xlsx')


# Paso 1.Vamos a hacer el join del 'codmpio'

# Ajusta los nombres de 'Departamento' en 'gini' para que coincidan con los de 'coddepto'

# Convertimos el texto en mayúsculas

gini['Departamento'] = gini['Departamento'].str.upper()

# Ajusatamos los nombres de los departamentos eliminando tildes

gini['Departamento'] = (
    gini['Departamento']
    .str.replace('á', 'a')
    .str.replace('é', 'e')
    .str.replace('í', 'i')
    .str.replace('ó', 'o')
    .str.replace('ú', 'u')
    .str.replace('Á', 'A')
    .str.replace('É', 'E')
    .str.replace('Í', 'I')
    .str.replace('Ó', 'O')
    .str.replace('Ú', 'U')
)

# Cambiar 'BOGOTA D.C.' a 'BOGOTA' en la columna 'Departamento'
gini['Departamento'] = gini['Departamento'].replace('BOGOTA D.C.', 'BOGOTA')

# Paso 2. Realizamos el merge para pegar la variable 'codmpio' de la base 'coddepto' a 'gini'

gini = gini.merge(coddepto[['Departamento', 'codmpio']],
                  on='Departamento', how='left')

# Borramos la columna 'Departamento', ya no la necesitamos

gini = gini.drop(columns=['Departamento'])

# Cambiamos el nombre de la variable codmpio a 'coddepto'

gini = gini.rename(columns={'codmpio': 'coddepto'})

# Paso 3. Cambiamos de wide a long

gini = pd.melt(gini, id_vars=['coddepto'], var_name='anno', value_name='gini')

# Paso 4. Cambiamos el orden de las columnas

gini = gini[['anno', 'coddepto', 'gini']]

# Paso 5. Exportamos la base

gini.to_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_7.1.xlsx', index=False)

# ============================================================
# YA 7.2 Incidencia de la Pobreza Monetaria
# ============================================================

# ============================================================
# Importarmos los datos

pobreza_monetaria = pd.read_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/YA_7.1.xlsx')

# ============================================================
# Vamos a imputar el coddepto para cada uno de los departamentos.

coddepto = pd.read_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/coddepto.xlsx')

# Paso 1.Vamos a hacer el join del 'codmpio'

# Ajusta los nombres de 'Departamento' en 'pobreza_monetaria' para que coincidan con los de 'coddepto'

# Convertimos el texto en mayúsculas

pobreza_monetaria['Departamento'] = pobreza_monetaria['Departamento'].str.upper()

# Ajusatamos los nombres de los departamentos eliminando tildes

pobreza_monetaria['Departamento'] = (
    pobreza_monetaria['Departamento']
    .str.replace('á', 'a')
    .str.replace('é', 'e')
    .str.replace('í', 'i')
    .str.replace('ó', 'o')
    .str.replace('ú', 'u')
    .str.replace('Á', 'A')
    .str.replace('É', 'E')
    .str.replace('Í', 'I')
    .str.replace('Ó', 'O')
    .str.replace('Ú', 'U')
)

# Cambiar 'BOGOTA D.C.' a 'BOGOTA' en la columna 'Departamento'
pobreza_monetaria['Departamento'] = pobreza_monetaria['Departamento'].replace(
    'BOGOTA D.C.', 'BOGOTA')

# Paso 2. Realizamos el merge para pegar la variable 'codmpio' de la base 'coddepto' a 'pobreza_monetaria'

pobreza_monetaria = pobreza_monetaria.merge(
    coddepto[['Departamento', 'codmpio']], on='Departamento', how='left')

# Borramos la columna 'Departamento', ya no la necesitamos

pobreza_monetaria = pobreza_monetaria.drop(columns=['Departamento'])

# Cambiamos el nombre de la variable codmpio a 'coddepto'

pobreza_monetaria = pobreza_monetaria.rename(
    columns={'codmpio': 'coddepto', 'pobreza_monetaria': 'Pobreza_Monetaria'})

# Paso 3. Cambiamos de wide a long

pobreza_monetaria = pd.melt(pobreza_monetaria, id_vars=[
                            'coddepto'], var_name='anno', value_name='pobreza_monetaria')

# Paso 4. Cambiamos el orden de las columnas

pobreza_monetaria = pobreza_monetaria[[
    'anno', 'coddepto', 'pobreza_monetaria']]

# Paso 5. Exportamos la base

pobreza_monetaria.to_excel(
    r'/Users/daniel/Documents/GitHub/Ninez-YA/03_Process/YA_7.2.xlsx', index=False)
