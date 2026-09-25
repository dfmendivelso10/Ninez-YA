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
| 1.1 – 1.2 | Cobertura de acueducto y alcantarillado (reporte SUI, sin procesamiento en código) | `YA_1.1.R`, `YA_1.2.R` |
| 1.3 | Mortalidad en menores de 5 años | `YA_1.3.R` |
| 1.4 | Nacidos vivos con 4 o más controles prenatales | `YA_1.4.R` |
| 1.5 | Prevalencia de desnutrición aguda en menores de 5 años | `YA_1.5.R` |
| 1.6 | Nacidos vivos con bajo peso al nacer | `YA_1.6.R` |
| 1.7 | Mortalidad neonatal | `YA_1.7.R` |
| 1.8 | Mortalidad en menores de 1 año | `Ya_1.8.R` |
| 1.9 | Mortalidad por desnutrición en menores de 5 años | `YA_1.9.R` |
| 1.10 | Partos atendidos por personal calificado | `YA_1.10.R` |
| 2.1 – 2.4 | Transición: cobertura neta, reprobación, repitencia y deserción | `YA_2.R` |
| 2.5 | Niñas y niños en educación inicial con 6 o más atenciones | `YA_2.5.R` |
| 2.6 | Educación inicial en el marco de la atención integral | `YA_2.6.R` |
| 2.7 | Sector (oficial / no oficial) de la institución educativa | `YA_2.7.py` |
| 3.x | Primaria y media: cobertura neta, reprobación, repitencia y deserción | `YA_3.R` |
| 3.x | Resultados de la prueba Saber 11 | `YA_3_Saber_11.R`, `Saber_11_Corregido.R` |
| 3.12 | Estudiantes por tipo de institución | `YA_3.12.R` |
| 4.1 | Mortalidad por enfermedad diarreica aguda (EDA) en menores de 5 años | `YA_4.1.R` |
| 4.2 | Mortalidad por infección respiratoria aguda (IRA) en menores de 5 años | `YA_4.2.R` |
| 4.4 | Calidad del aire por estación de monitoreo | `YA_4.4.R` |
| 5.1 – 5.2 | Juego (ECV, departamental) | `YA_5.1.R`, `YA_5.2.R`, `Juego_2023.R` |
| 7.1 – 7.2 | Pobreza monetaria y desigualdad (DANE, departamental) | `YA_7.py` |
| 8.1 | Homicidios | `YA_8.1.R` |
| 8.2 | Delito sexual | `YA_8.2.R` |
| 8.3 | Violencia intrafamiliar en niñas y niños de 0 a 5 años | `YA_8.3.R` |
| 8.4 | Violencia interpersonal contra niñas, niños y adolescentes | `YA_8.4.R` |
| 9.1 – 9.2 | Adolescentes en el Sistema de Responsabilidad Penal Adolescente (ICBF) | `YA_9.1.R`, `YA_9.2.R` |
| 9.3 | Ingresos al ICBF por trabajo infantil | `YA_9.3.R`, `YA_9.ipynb` |
| 9.4 | Ingresos al ICBF por explotación sexual | `YA_9.4.R` |
| 10 | Desaparición (réplicas de verdata) | `YA_10.R` |

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
