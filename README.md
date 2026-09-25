# Niñez YA: indicator pipeline

Code and data used to build the childhood and adolescence indicators behind **SIYA (Sistema de Indicadores de los YA)**, the monitoring dashboard of the [NiñezYA coalition](https://ninezya.org/siya/) in Colombia. Developed as a team effort at the IMAGINA Research Center, Universidad de los Andes.

## Structure

| Folder | Contents |
|---|---|
| `01_Script/` | R and Python scripts. Scripts are named after the dashboard indicator they cover (`YA_x.y`). |
| `02_RAW-Data/` | Source data from public administrative records and surveys (census projections, ICBF, MEN, Procuraduría, ECV, vital statistics). |
| `03_Process/` | Intermediate datasets, such as population denominators by age group. |

Final indicator tables are not stored in this repository; the scripts write them to a local `04_Outputs/` folder.

## Running the code

Scripts are written in R (`dplyr`, `readxl`, `openxlsx`) and Python. Some scripts still use absolute file paths; set them to your local copy of this repository before running.
