## Spss a R, y R a xlsx
En este repositorio puede encontrar un script en lenguaje R, el cual permitirá importar datos desde un archivo SPSS (.sav) hasta RStudio, y posteriormente exportar los resultados a una planilla de cálculo Excel (.xlsx) para su publicación, debido a que este último formato presenta mayor utilización por parte de los grupos de interés de esta información procesada. No se realizará ningún tipo de análisis de los resultados, ya que escapa del objetivo de este post.

![spss](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/icono/sav.png)    **->** ![r](https://github.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/blob/master/icono/r.png)    **->** ![xlsx](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/icono/xls.png)

## Análisis trimestre móvil OND2019 ENE
>Al analizar los datos se debe poner atención en aplicar factor de expansión a la muestra, y tener especial cuidado en que NO todos los resultados son consistentes estadísticamente, debido a que presentan altos coeficientes de variación.
Brevemente y según lo señalado en el manual metodológico de la encuesta, solo aquellos valores con cv <= 0,15 son aceptables, mientras que aquellos con cv mayores están sujetos a alta variabilidad muestral y error de estimación, por lo cual deberían agruparse para mejorar este valor.

La encuesta caracteriza la población dentro y fuera del mercado del trabajo, para este ejercicio se tomó como referencia la décima región de Los Lagos, en específico al trimestre móvil octubre-diciembre 2019. De esta manera primero se presenta un organigrama con los principales resultados:

![fig1](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/docs/fig1.png)

Luego, desde la planilla de cálculo se extrajo una serie de tablas:

#### Principales indicadores económicos:

![Tabla1-2](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/docs/tabla1-2.png)

#### Principales resultados de actividad económica:

![caenes](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/docs/caenes.png)

![tabla4-5](https://raw.githubusercontent.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/master/docs/tabla4-5.png)

Por último el script utilizado esta disponible en mi repositorio [Script_ene_ond2019.R](https://github.com/luis-fernandezt/Encuesta-Nacional-de-Empleo-OND-2019-SPSS-a-RStudio/blob/master/Script_ene_ond2019.R).

Suerte!
