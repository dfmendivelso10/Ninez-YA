# Niñez YA: indicator pipeline for SIYA

Code and data used to build the indicators of **[SIYA (Sistema de Indicadores de los YA)](https://ninezya.org/siya/)**, the monitoring system of the **NiñezYA coalition**, a network of more than 200 civil society organizations working for the rights of children and adolescents in Colombia.

SIYA compiles official indicators from different national sources, cleans and harmonizes them, and makes them available to civil society, public officials, candidates, and legislators. This repository contains the processing behind those indicators. It was developed at the **IMAGINA Research Center, Universidad de los Andes**, as part of the technical team that built SIYA (see the [credits](https://enflujo.github.io/imagina-ninezya/creditos/)).

- **Dashboard:** [ninezya.org/siya](https://ninezya.org/siya/)
- **Data downloads and technical sheets:** [SIYA data page](https://enflujo.github.io/imagina-ninezya/datos/)
- **Dashboard front-end:** built by Laboratorio EnFlujo ([imagina-ninezya](https://github.com/enflujo/imagina-ninezya))

## The 10 YA

SIYA is organized around ten urgent issues ("YA") for children and adolescents. Scripts in `01_Script/` are named after the issue and indicator they build (`YA_x.y` = issue *x*, indicator *y*).

| YA | Issue | Scripts |
|---|---|---|
| 1 | Health and nutrition | `YA_1.*` |
| 2 | Early childhood education | `YA_2*` |
| 3 | Primary and secondary education | `YA_3*`, `Saber_11_Corregido.R`, `Script_Base_MEN.R` |
| 4 | Healthy environment | `YA_4.*` |
| 5 | Play | `YA_5.*`, `Juego_2023.R` |
| 6 | Participation | — |
| 7 | Families able to care for and protect children | `YA_7.py` |
| 8 | Protection from all forms of violence | `YA_8.*` |
| 9 | Adolescents in the juvenile justice system (SRPA) | `YA_9*` |
| 10 | Culture of peace, reconciliation, and coexistence | `YA_10.R` |

Helper scripts build shared inputs: population denominators by age (`Denominador.R`, `ICBF_Denominador_Sexual_Trabajo.py`) and live births (`nacidos_vivos.R`).

## Structure

| Folder | Contents |
|---|---|
| `01_Script/` | R and Python scripts, one per indicator plus helper scripts. |
| `02_RAW-Data/` | Source data from public administrative records and surveys (census projections, ICBF, MEN, Procuraduría, ECV, vital statistics). |
| `03_Process/` | Intermediate datasets, such as population denominators by age group. |

Final indicator tables are not stored in this repository; the scripts write them to a local `04_Outputs/` folder. The published tables can be downloaded from the [SIYA data page](https://enflujo.github.io/imagina-ninezya/datos/).

## Running the code

Scripts are written in R (`dplyr`, `readxl`, `openxlsx`, `tidyr`) and Python. Some scripts still use absolute file paths; set them to your local copy of this repository before running. Indicator definitions follow the technical sheets published on the SIYA data page.
