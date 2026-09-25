# Niñez YA: procesamiento de indicadores

![Tamaño](https://img.shields.io/github/repo-size/dfmendivelso10/Ninez-YA?color=%235757f7&label=Tama%C3%B1o%20repo&logo=open-access&logoColor=white)
![Último commit](https://img.shields.io/github/last-commit/dfmendivelso10/Ninez-YA?label=%C3%9Altimo%20commit)
![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)

El **SIYA (Sistema de Indicadores de los YA)** es el tablero de seguimiento de la [coalición NiñezYA](https://ninezya.org/siya/). Su objetivo es entregar indicadores relevantes, actualizados y de calidad sobre niñas, niños y adolescentes en Colombia a sociedad civil, funcionarios públicos, candidatos, mandatarios y legisladores.

Este repositorio contiene el código y los datos fuente con los que se construyen esos indicadores, a partir de registros administrativos y encuestas públicas. El sitio del tablero vive en un repositorio aparte: [enflujo/imagina-ninezya](https://github.com/enflujo/imagina-ninezya).

Trabajo en equipo del Centro de Investigación IMAGINA, Universidad de los Andes.

## Estructura

| Carpeta | Contenido |
|---|---|
| `01_Script/` | Scripts en R y Python. Cada uno lleva el nombre del indicador que produce (`YA_x.y`). |
| `02_RAW-Data/` | Datos fuente sin modificar: proyecciones de población DANE, ICBF, MEN, Procuraduría, Encuesta de Calidad de Vida, estadísticas vitales, verdata. |
| `03_Process/` | Tablas intermedias y por indicador (`YA_x.y.xlsx`), más los denominadores de población por grupo de edad. |

Las tablas finales del tablero no se guardan en el repositorio; se escriben en una carpeta local `04_Outputs/`.

## Indicadores

Los scripts siguen la numeración de los YA del tablero. Salvo que se indique lo contrario, la desagregación es municipal (`codmpio`) y anual (`anno`).

| YA | Indicador | Script |
|---|---|---|
| 1.1 – 1.2 | Cobertura de acueducto<br>Cobertura de alcantarillado<br>*(reporte SUI, sin procesamiento en código)* | `YA_1.1.R`, `YA_1.2.R` |
| 1.3 | Tasa de mortalidad en niños menores de 5 años (cualquier condición) | `YA_1.3.R` |
| 1.4 | Proporción de nacidos vivos con 4 o más controles prenatales | `YA_1.4.R` |
| 1.5 | Prevalencia de desnutrición aguda en niños menores de cinco años | `YA_1.5.R` |
| 1.6 | Proporción de nacidos vivos con bajo peso al nacer | `YA_1.6.R` |
| 1.7 | Tasa de mortalidad neonatal | `YA_1.7.R` |
| 1.8 | Tasa de mortalidad menores de 1 año | `Ya_1.8.R` |
| 1.9 | Tasa de mortalidad por desnutrición en menores de 5 años | `YA_1.9.R` |
| 1.10 | Porcentaje de partos atendidos por personal calificado | `YA_1.10.R` |
| 2.1 – 2.4 | Cobertura neta de transición<br>Reprobación transición<br>Repitencia transición<br>Deserción transición | `YA_2.R` |
| 2.5 | Porcentaje de niños y niñas en servicios de educación inicial en el marco de la atención integral que cuentan con 6 o más atenciones priorizadas | `YA_2.5.R` |
| 2.6 | Niñas y niños con educación inicial en el marco de la atención integral | `YA_2.6.R` |
| 2.7 | Número de estudiantes matriculados, según el tipo de institución | `YA_2.7.py` |
| 3.1 – 3.4 | Puntaje Saber 11 - Matemáticas<br>Puntaje Saber 11 - Lectura Crítica<br>Puntaje Saber 11 - Ciencias Sociales<br>Puntaje Saber 11 - Global | `YA_3_Saber_11.R`, `Saber_11_Corregido.R` |
| 3.5 – 3.12 | Cobertura neta primaria<br>Cobertura neta media<br>Reprobación primaria<br>Reprobación media<br>Repitencia primaria<br>Repitencia media<br>Deserción primaria intra-anual<br>Deserción media intra-anual | `YA_3.R` |
| 4.1 | Tasa de mortalidad por Enfermedad Diarreica Aguda (EDA) en menores de 5 años | `YA_4.1.R` |
| 4.2 | Tasa de mortalidad por Infección Respiratoria Aguda (IRA) en menores de 5 años | `YA_4.2.R` |
| 4.3 | Cobertura de acueducto *(mismo indicador que 1.1)* | `YA_1.1.R` |
| 4.4 | Calidad del aire | `YA_4.4.R` |
| 5.1 | Niños y niñas menores de 5 años por sitio o persona con quien permanecen la mayor parte del tiempo entre semana (%) | `YA_5.1.R`, `Juego_2023.R` |
| 7.1 | Coeficiente de Gini (Desigualdad) | `YA_7.py` |
| 7.2 | Pobreza Monetaria | `YA_7.py` |
| 8.1 | Tasa de Homicidios en niñas, niños y adolescentes | `YA_8.1.R` |
| 8.2 | Tasa de exámenes médico legales por presunto delito sexual contra niños, niñas y adolescentes | `YA_8.2.R` |
| 8.3 | Tasa de Violencia Intrafamiliar en niños, niñas y adolescentes | `YA_8.3.R` |
| 8.4 | Tasa de violencia interpersonal contra niños, niñas y adolescentes | `YA_8.4.R` |
| 9.1 | Porcentaje de Adolescentes entre 14 y 17 años en el Sistema de Responsabilidad Penal Adolescente que ingresan al ICBF para los cuales se determina una medida privativa de la libertad | `YA_9.1.R` |
| 9.2 | Porcentaje de Adolescentes entre 14 y 17 años en el Sistema de Responsabilidad Penal Adolescente que ingresan al ICBF para los cuales se determina una medida no privativa de la libertad | `YA_9.2.R` |
| 9.3 | Porcentaje de niñas, niños y adolescentes (5-17 años) que ingresaron a Proceso de Restablecimiento de Derechos por Trabajo Infantil | `YA_9.3.R`, `YA_9.ipynb` |
| 9.4 | Porcentaje de niñas, niños y adolescentes (5-17 años) que ingresaron a Proceso de Restablecimiento de Derechos por Explotación Sexual Comercial | `YA_9.4.R` |

Los nombres corresponden a los indicadores publicados en el tablero. Tres scripts producen tablas que no aparecen en él: `YA_3.12.R` (establecimientos educativos por sector), `YA_5.2.R` (juego, pregunta P779S5 de la ECV) y `YA_10.R` (desaparición, réplicas de verdata).

**Scripts auxiliares**

- `Denominador.R`: poblaciones por grupo de edad a partir de las proyecciones del censo (2005–2030).
- `nacidos_vivos.R`: denominador de nacidos vivos por municipio.
- `ICBF_Denominador_Sexual_Trabajo.py`: denominadores departamentales para los indicadores 9.3 y 9.4.
- `Script_Base_MEN.R`: base de indicadores de primera infancia (MinSalud).

## Uso

### Requisitos

- [R](https://cran.r-project.org/) con los paquetes:

```r
install.packages(c("dplyr", "tidyr", "stringr", "readxl", "openxlsx",
                   "data.table", "readr", "lubridate", "haven", "fuzzyjoin"))
```

- [Python 3](https://www.python.org/downloads/) con `pandas` (para `YA_2.7.py`, `YA_7.py` y el script de denominadores ICBF).

### Rutas

Los scripts usan rutas absolutas con la forma `/Users/daniel/Documents/GitHub/Ninez-YA/...`. Antes de correrlos, reemplace ese prefijo por la ruta de su copia local del repositorio.

### Orden de ejecución

1. `Denominador.R` y `nacidos_vivos.R` generan los denominadores en `03_Process/`.
2. Cada script `YA_x.y` lee sus fuentes de `02_RAW-Data/` y esos denominadores, y escribe su tabla en `03_Process/`.

Los scripts de cada indicador son independientes entre sí; puede correr solo los que necesite.

> El repositorio pesa alrededor de 450 MB por los datos fuente (en particular la Encuesta de Calidad de Vida y las réplicas de verdata).
