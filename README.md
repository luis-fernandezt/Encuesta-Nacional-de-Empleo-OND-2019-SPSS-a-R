## **Spss a R, y R a xlsx**
En este repositorio puede encontrar un [Script](https://github.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/blob/master/Script_ene_ond2019.R) en lenguaje **R**, el cual permitirá importar datos desde un archivo SPSS (.sav) hasta RStudio, y posteriormente exportar los resultados a una planilla de cálculo Excel (.xlsx) para su publicación, debido a que este último formato presenta mayor utilización por parte de los grupos de interés de esta información procesada. No se realizará ningún tipo de análisis de los resultados, ya que escapa del objetivo de este post.

### **Análisis trimestre móvil OND2019 ENE**

>Al analizar los datos se debe poner atención en aplicar factor de expansión a la muestra, y tener especial cuidado en que NO todos los resultados son consistentes estadísticamente, debido a que presentan altos coeficientes de variación.
Brevemente y según lo señalado en el manual metodológico de la encuesta, solo aquellos valores con cv <= 0,15 son aceptables, mientras que aquellos con cv mayores están sujetos a alta variabilidad muestral y error de estimación, por lo cual deberían agruparse para mejorar este valor.

La encuesta caracteriza la población dentro y fuera del mercado del trabajo, para este ejercicio se tomó como referencia la décima región de Los Lagos, en específico al trimestre móvil octubre-diciembre 2019. De esta manera primero se presenta un organigrama con los principales resultados:

#### • **Figura 1. Clasificación de la población dentro y fuera de la fuerza de trabajo en la ENE.**

![fig1](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/docs/fig1.png)
Fuente: Elaboración propia.

Luego, desde la planilla de cálculo se extrajo una serie de tablas:

### **Principales indicadores económicos:**

#### • **Tabla 1: Los Lagos, situación de empleo de la población según sexo.**

|             OND2019             | Ambos sexos | Hombres |  Mujeres  |
|---------------------------------|:-----------:|:-------:|:-------:|
|                                 |   (miles)   | (miles) | (miles) |
| Población   total               |    969,99   |  496,29 |  473,70 |
| Menores de 15   años            |    183,35   |  93,24  |  90,11  |
| Población en   edad de trabajar |    786,64   |  403,05 |  383,59 |
| Fuerza de   trabajo             |    460,11   |  279,09 |  181,02 |
| Ocupados                        |    444,29   |  271,38 |  172,91 |
| Desocupados                     |    15,82    |   7,72  |   8,11  |
| Inactivos                       |    326,53   |  123,96 |  202,57 |

Fuente: Elaboración propia.

#### • **Tabla 2.  Los Lagos, principales tasas**

| OND2019                 | Ambos sexos | Hombres | Mujeres  |
|-------------------------|:-----------:|:-------:|:------:|
| Tasa de   desocupación  | 3,4%        | 2,8%    | 4,5%   |
| Tasa de   ocupacion     | 56,5%       | 67,3%   | 45,1%  |
| Tasa de   participación | 58,5%       | 69,2%   | 47,2%  |

Fuente: Elaboración propia.

### Principales resultados de actividad económica:

#### • **Tabla 3.  Los Lagos, clasificador de Actividades Económicas Nacional para Encuestas Sociodemográficas (CAENES)**

|                               OND2019                               | Ambos sexos |   cv   | Hombres |  cv  |  Mujeres  |  cv  |
|---------------------------------------------------------------------|:-----------:|:------:|:-------:|:----:|:-------:|:----:|
|                                                                     |   (miles)   |        | (miles) |      | (miles) |      |
| Agricultura,   ganadería, silvicultura y pesca                      |    74,63    |  0,06  |  64,90  | 0,06 |   9,73  | 0,12 |
| Industrias   manufactureras                                         |    55,66    |  0,08  |  33,60  | 0,09 |  22,07  | 0,10 |
| Suministro de   electricidad, gas, vapor y aire acondicionado       |     3,04    |  0,37  |   2,88  | 0,39 |   0,16  | 0,57 |
| Suministro de   agua                                                |     0,95    |  0,33  |   0,81  | 0,35 |   0,14  | 0,72 |
| Construcción                                                        |    36,11    |  0,12  |  33,51  | 0,12 |   2,60  | 0,28 |
| Comercio al   por mayor y al por menor                              |    85,79    |  0,07  |  45,99  | 0,07 |  39,80  | 0,11 |
| Transporte y   almacenamiento                                       |    30,81    |  0,11  |  26,61  | 0,11 |   4,20  | 0,25 |
| Actividades   de alojamiento y de servicio de comidas               |    15,57    |  0,16  |   4,94  | 0,23 |  10,63  | 0,21 |
| Información y   comunicaciones                                      |     2,21    |  0,34  |   1,21  | 0,40 |   1,00  | 0,57 |
| Actividades   financieras y de seguros                              |     3,38    |  0,26  |   1,44  | 0,38 |   1,94  | 0,29 |
| Actividades   inmobiliarias                                         |     1,73    |  0,28  |   1,39  | 0,32 |   0,34  | 0,55 |
| Actividades   profesionales, científicas y técnicas                 |     8,55    |  0,21  |   4,97  | 0,27 |   3,58  | 0,27 |
| Actividades   de servicios administrativos y de apoyo               |    10,39    |  0,17  |   6,29  | 0,20 |   4,10  | 0,28 |
| Administración   pública y defensa                                  |    32,29    |  0,11  |  20,18  | 0,12 |  12,11  | 0,15 |
| Enseñanza                                                           |    36,94    |  0,09  |   9,09  | 0,20 |  27,85  | 0,09 |
| Actividades   de atención de la salud humana y de asistencia social |    21,50    |  0,09  |   7,24  | 0,18 |  14,26  | 0,11 |
| Actividades   artísticas, de entretenimiento y recreativas          |     0,77    |  0,39  |   0,21  | 0,51 |   0,56  | 0,50 |
| Otras   actividades de servicios                                    |     8,73    |  0,19  |   5,33  | 0,26 |   3,40  | 0,22 |
| Actividades   de los hogares como empleadores                       |    15,14    |  0,11  |   0,79  | 0,41 |  14,35  | 0,11 |
| Actividades   de organizaciones y órganos extraterritoriales        |     0,08    |  1,00  |   0,00  | 1,00 |   0,08  | 1,00 |

Fuente: Elaboración propia.

#### • **Tabla 4.  Los Lagos, Clasificación Internacional de la Situación en el Empleo (CISE) 1993**

|                      OND2019                     | Ambos sexos |  cv  | Hombres |  cv  |  Mujeres  |  cv  |
|--------------------------------------------------|:-----------:|:----:|:-------:|:----:|:-------:|:----:|
|                                                  |   (miles)   |      | (miles) |      | (miles) |      |
| Empleador                                        |    21,36    | 0,12 |  13,26  | 0,14 |   8,09  | 0,19 |
| Cuenta propia                                    |    124,40   | 0,06 |  85,32  | 0,07 |  39,09  | 0,09 |
| Asalariado   sector privado                      |    217,86   | 0,04 |  140,95 | 0,04 |  76,91  | 0,07 |
| Asalariado   sector público                      |    64,69    | 0,07 |  30,60  | 0,10 |  34,08  | 0,09 |
| Personal de   servicio doméstico puertas afuera  |    12,96    | 0,12 |   0,22  | 0,67 |  12,74  | 0,12 |
| Personal de   servicio doméstico puertas adentro |     1,21    | 0,53 |   0,00  | 1,00 |   1,21  | 0,53 |
| Familiar o   personal no remunerado              |     1,81    | 0,33 |   1,02  | 0,50 |   0,79  | 0,43 |

Fuente: Elaboración propia.

#### • **Tabla 5.  Los Lagos, Clasificación Internacional Uniforme de Ocupaciones CIUO -08**

|                                     OND2019                                     | Ambos sexos |  cv  | Hombres |  cv  |  Mujeres  |  cv  |
|---------------------------------------------------------------------------------|:-----------:|:----:|:-------:|:----:|:-------:|:----:|
|                                                                                 |   (miles)   |      | (miles) |      | (miles) |      |
| Directores,   gerentes y administradores                                        |     8,95    | 0,21 |   6,85  | 0,22 |   2,10  | 0,29 |
| Profesionales,   científicos e intelectuales                                    |     8,95    | 0,11 |  20,56  | 0,14 |  22,37  | 0,12 |
| Técnicos y   profesionales de nivel medio                                       |     8,95    | 0,08 |  19,05  | 0,11 |  21,35  | 0,11 |
| Personal de   apoyo administrativo                                              |     8,95    | 0,10 |  10,23  | 0,15 |  14,04  | 0,13 |
| Trabajadores   de los servicios y vendedores de comercios y mercados            |     8,95    | 0,06 |  38,09  | 0,08 |  52,41  | 0,07 |
| Agricultores   y trabajadores calificados agropecuarios, forestales y pesqueros |     8,95    | 0,08 |  30,45  | 0,09 |   5,63  | 0,14 |
| Artesanos y   operarios de oficios                                              |     8,95    | 0,09 |  49,67  | 0,10 |  12,28  | 0,12 |
| Operadores de   instalaciones, maquinas y ensambladores                         |     8,95    | 0,10 |  33,74  | 0,10 |   0,45  | 0,45 |
| Ocupaciones   elementales                                                       |     8,95    | 0,06 |  60,97  | 0,07 |  42,13  | 0,08 |
| Otros no   identificados                                                        |     8,95    | 0,44 |   1,77  | 0,44 |   0,15  | 0,79 |

Fuente: Elaboración propia.

#### **Versión de Rstudio:**
"R version 3.6.3 (2020-02-29)"
