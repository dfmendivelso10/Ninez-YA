

#%%
# Importar librerias
import pandas as pd


#%%
# Loaded variable 'df' from URI: /Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ICBF_Denominadores.xlsx

df = pd.read_excel(r'/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/ICBF_Denominadores.xlsx')


# %% Vamos a filtrar la Base de Datos, años 2015 a 2023

df.filtered = df[(df['anno'] >= 2015) & (df['anno'] <= 2023)]


# %% Vamos a pegar la base de datos coddepto, esta base continie el código del departamento.

# Cargamos la base de datos coddepto
coddepto = pd.read_excel(r'/Users/daniel/Documents/GitHub/Ninez-YA/02_RAW-Data/coddepto.xlsx')

# %% Realizamos el join basado en la columna 'depto' en df y 'Departamento' en coddepto

ICBF_Denominador_General = pd.merge(df, coddepto, left_on='depto', right_on='Departamento', how='left')


# %% Limpiamos el Espacio

del(coddepto, df)
# %% Vamos a filtrar las columnas de nuestra base de datos

print(ICBF_Denominador_General.columns)

# %% Seleccionamos las columnas que nos interesan

columnas_seleccionadas = ['anno', 'motivo_ingreso', 'rango_edad', 'procesos', 'Departamento', 'codmpio']

ICBF_Denominador_General = ICBF_Denominador_General.loc[:, columnas_seleccionadas]


# %% Creamos el primer denominador: Ingresos totales por coddepto y año

denominador_General = ICBF_Denominador_General.groupby(['anno', 'codmpio'])['procesos'].sum().reset_index()

# Exportamos manualmente con Data.Wrangler

# %% Ahora vamos a crear el denominador para los 
# Adolescentes entre 14 y 17 años en el Sistema de Responsabilidad 
# Penal Adolescente que ingresan al ICBF para los cuales se 
# determina una medida no privativa de la libertad.


