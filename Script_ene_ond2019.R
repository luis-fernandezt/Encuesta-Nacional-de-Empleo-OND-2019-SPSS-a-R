#Instalación de paquetes necesarios (opcional)
#install.packages("haven", "tidyverse", "survey", "srvyr", "dplyr", "car","xlsx")

library(haven) #Cargamos las librerias
library(tidyverse)
library(survey)
library(srvyr)
library(dplyr)
library(car)
library("xlsx")

# Es recomendable tener a la vista el "Libro de codigos base de la ENE año 2019" 
# En "Metodologías" desde la página web https://www.ine.cl/estadisticas/sociales/mercado-laboral/ocupacion-y-desocupacion
# Página 19, Construcción de principales indicadores
# Descargamos en la carpeta de trabajo con el siguiente código:

download.file(
  url = "http://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/metodologia/espanol/libro-de-c%C3%B3digos-base-ene-2019.pdf?sfvrsn=aeb43f99_3", 
  destfile = "libro-de-códigos-base-ene-2019.pdf"
)

# Cargamos la base de datos Encuesta Nacional de Empleo (ENE), trimestre móvil OND2019
# Se puede encontrar "Bases de datos" de otros periodos en estadísticas del Mercado Laboral en la misma web
# En este ejercicio se analizará solo un trimestre móvil Octubre-Diciembre 2019

ond2019 <- read_sav("http://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2019/formato-spss/ene-2019-11.sav?sfvrsn=38b27080_6&download=true")
View(ond2019) #vista previa de la base de datos

# Filtramos por región de Los Lagos y población en edad de trabajar edad >= 15
ond2019_r10 <- filter(ond2019, region == 10, edad >= 15)
names(ond2019_r10) #vista previa de los nombres de cada columna

## construcción de principales indicadores y los guardamos como una nueva variable en la bd
# *Variable Binaria de Personas en Edad de Trabajar, mayores de 15 años (pet)*.
ond2019_r10 <- mutate(ond2019_r10, pet = car::recode(ond2019_r10$edad, "0:14= NA; else = 1"))

# *Variable Binaria de Ocupados (o)*.
ond2019_r10 <- mutate(ond2019_r10, o = car::recode(ond2019_r10$cae_especifico, "1:7=1; else = NA"))

# *Variable Binaria de Desocupados (d)*.
ond2019_r10 <- mutate(ond2019_r10, d = car::recode(ond2019_r10$cae_especifico, "8:9=1; else = NA"))

# *Variable Binaria de Fuerza de Trabajo (fdt)*.
ond2019_r10 <- mutate(ond2019_r10, fdt = car::recode(ond2019_r10$cae_especifico, "1:9=1; else = NA"))

# *Variable Binaria inactivos*.
ond2019_r10 <- mutate(ond2019_r10, inactivos = car::recode(ond2019_r10$cae_especifico, "10:28=1; else = NA"))

ond2019_r10 <- within(ond2019_r10, { #Recodificamos etiquetas de sexo
  sexo <- Recode(sexo, '1="hombres"; 2="mujeres"', as.factor=TRUE)
})

names(ond2019_r10)
View(ond2019_r10)

# Aplicamos el factor de expansión a la muestra
# *Los nombres de los factores, así como estrato e id pueden haber cambiado en versiones posteriores de la ENE
svydsgn <- ond2019_r10 %>% as_survey_design(weights = fact,
                                            strata = estrato,
                                            ids = id_directorio)

# Principales Indicadores
# Respecto al coeficiente de variación, si CV <= 0,15 aceptable; si 0,15 < CV <= 0,30 poco fiable
# CV mayores a 0.30 estan sujetos a alta variabilidad muestral y error de estimación
# Más información acerca de los cv, ver Manual Metodologico ENE

pet <- svytotal(~pet, svydsgn,na.rm = TRUE) #poblacion edad de trabajar
pet_s <- svyby(~pet, ~sexo, svydsgn, svytotal, na.rm = TRUE, vartype="cv")

fdt <- svytotal(~fdt, svydsgn,na.rm = TRUE, vartype="cv") #fuerza de trabajo
fdt_s <- svyby(~fdt, ~sexo, svydsgn, svytotal, na.rm = TRUE, vartype="cv")

o <- svytotal(~o, svydsgn, na.rm = TRUE) #ocupados
os <- svyby(~o, ~sexo, svydsgn, svytotal, na.rm = TRUE, vartype="cv") 

d <- svytotal(~d, svydsgn, na.rm = TRUE) #desocupados
ds <- svyby(~d, ~sexo, svydsgn, svytotal, na.rm = TRUE, vartype="cv")

inactivos <- svytotal(~inactivos, svydsgn, na.rm = TRUE) #desocupados
inactivos_s <- svyby(~inactivos, ~sexo, svydsgn, svytotal, na.rm = TRUE, vartype="cv")

td <- svytotal(~d+sexo, svydsgn, na.rm = TRUE)/ #tasa desocupacion
  svytotal(~fdt+sexo, svydsgn,na.rm = TRUE)

to <- svytotal(~o+sexo, svydsgn, na.rm = TRUE)/ #tasa ocupacion
  svytotal(~pet+sexo, svydsgn,na.rm = TRUE)

tp <- svytotal(~fdt+sexo, svydsgn, na.rm = TRUE)/ #tasa participacion
  svytotal(~pet+sexo, svydsgn,na.rm = TRUE)

# Principales Indicadores Actividad Económica 
# Respecto al coeficiente de variación, si CV <= 0,15 aceptable; si 0,15 < CV <= 0,30 poco fiable
# CV mayores a 0.30 estan sujetos a alta variabilidad muestral y error de estimación
# Más información acerca de los cv, ver Manual Metodologico ENE

#Clasificador de Actividades Económicas Nacional para Encuestas Sociodemográficas (CAENES)
caenes <- svyby(~o+sexo, ~b14_rev4cl_caenes,svydsgn, svytotal, na.rm = TRUE, vartype="cv")

#Clasificación Internacional de la Situación en el Empleo (CISE) 1993
cise <- svyby(~o+sexo, ~categoria_ocupacion,svydsgn, svytotal, na.rm = TRUE, vartype="cv")

#Clasificación Internacional Uniforme de Ocupaciones CIUO -08
ciuo <- svyby(~o+sexo, ~b1, svydsgn, svytotal, na.rm = TRUE, vartype="cv")


# Opcionalmente se pueden exportar todos los resultados a un único archivo *.xlsx
# *archivo de salida básico sin ajustes de estilo*
write.xlsx(pet, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "pet", 
           append = F)

write.xlsx(pet_s, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "pet_sexo", 
           append = T)

write.xlsx(fdt, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "fdt", 
           append = T)

write.xlsx(fdt_s, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "fdt_sexo", 
           append = T)

write.xlsx(o, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "o", 
           append = T)

write.xlsx(os, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "o_sexo", 
           append = T)

write.xlsx(d, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "d", 
           append = T)

write.xlsx(ds, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "d_sexo", 
           append = T)

write.xlsx(inactivos, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "inactivos", 
           append = T)

write.xlsx(inactivos_s, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "inactivos_sexo", 
           append = T)

write.xlsx(td, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "td", 
           append = T)

write.xlsx(to, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "to", 
           append = T)

write.xlsx(tp, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "tp", 
           append = T)

write.xlsx(caenes, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "caenes", 
           append = T)

write.xlsx(cise, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "cise-93", 
           append = T)

write.xlsx(ciuo, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "ciuo-08", 
           append = T)

