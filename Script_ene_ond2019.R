#Instalaci�n de paquetes necesarios (opcional)
#install.packages("haven", "tidyverse", "survey", "srvyr", "dplyr", "car","xlsx")

library(haven) #Cargamos las librerias

library(tidyverse)
library(car)

library(survey)
library(srvyr)

library("xlsx")  



# Es recomendable tener a la vista el "Libro de codigos base de la ENE a�o 2019" 
# En "Metodolog�as" desde la p�gina web https://www.ine.cl/estadisticas/sociales/mercado-laboral/ocupacion-y-desocupacion
# P�gina 19, Construcci�n de principales indicadores

# Descargamos en la carpeta de trabajo con el siguiente c�digo (1.4 MB)
download.file("http://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/metodologia/espanol/libro-de-c%C3%B3digos-base-ene-2019.pdf?sfvrsn=aeb43f99_3", "libro-de-c�digos-base-ene-2019.pdf", mode="wb")

# Cargamos la base de datos Encuesta Nacional de Empleo (ENE), trimestre m�vil OND2019
# Se puede encontrar "Bases de datos" de otros periodos en estad�sticas del Mercado Laboral en la misma web
# En este ejercicio se analizar� solo un trimestre m�vil Octubre-Diciembre 2019

# se puede descargar (124.9 MB)
download.file("http://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2019/formato-spss/ene-2019-11.sav?sfvrsn=38b27080_6&download=true", "ond2019.sav", mode="wb")

# o cargar directamente desde el repositorio de la web INE
ond2019 <- read_sav("http://www.ine.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2019/formato-spss/ene-2019-11.sav?sfvrsn=38b27080_6&download=true")
View(ond2019) #vista previa de la base de datos

# Filtramos por regi�n de Los Lagos y poblaci�n en edad de trabajar edad >= 15
ond2019_r10 <- filter(ond2019, region == 10, edad >= 15)
names(ond2019_r10) #vista previa de los nombres de cada columna

## construcci�n de principales indicadores y los guardamos como una nueva variable en la bd
# *Variable Binaria de Personas en Edad de Trabajar, mayores de 15 a�os (pet)*.
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
  sexo <- Recode(sexo, '1="hombres"; 2="mujeres"', as.factor=TRUE)})

names(ond2019_r10)

# Aplicamos el factor de expansi�n a la muestra
# *Los nombres de los factores, as� como estrato e id pueden haber cambiado en versiones posteriores de la ENE
svydsgn <- ond2019_r10 %>% as_survey_design(weights = fact,
                                            strata = estrato,
                                            ids = id_directorio)

# Principales Indicadores
# Respecto al coeficiente de variaci�n, si CV <= 0,15 aceptable; si 0,15 < CV <= 0,30 poco fiable
# CV mayores a 0.30 estan sujetos a alta variabilidad muestral y error de estimaci�n
# M�s informaci�n acerca de los cv, ver Manual Metodologico ENE

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

svyratio(~d, ~fdt, design=svydsgn, na.rm=T, covmat=T, dstrat)
svyratio.survey.design2(~d, ~fdt, design=svydsgn)

# Principales Indicadores Actividad Econ�mica 
# Respecto al coeficiente de variaci�n, si CV <= 0,15 aceptable; si 0,15 < CV <= 0,30 poco fiable
# CV mayores a 0.30 estan sujetos a alta variabilidad muestral y error de estimaci�n
# M�s informaci�n acerca de los cv, ver Manual Metodologico ENE

#Clasificador de Actividades Econ�micas Nacional para Encuestas Sociodemogr�ficas (CAENES)
caenes <- svyby(~o+sexo, ~b14_rev4cl_caenes,svydsgn, svytotal, na.rm = TRUE, vartype="cv")

#Clasificaci�n Internacional de la Situaci�n en el Empleo (CISE) 1993
cise <- svyby(~o+sexo, ~categoria_ocupacion,svydsgn, svytotal, na.rm = TRUE, vartype="cv")

#Clasificaci�n Internacional Uniforme de Ocupaciones CIUO -08
ciuo <- svyby(~o+sexo, ~b1, svydsgn, svytotal, na.rm = TRUE, vartype="cv")

ond2019_r10$b14_rev4cl_caenes
ond2019_r10$categoria_ocupacion
ond2019_r10$b1
cv(fdt_s)

# Opcionalmente se pueden exportar todos los resultados a un �nico archivo *.xlsx
# *archivo de salida b�sico sin ajustes de estilo*
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

#######################################
#vista regional macro - poblacion total
pobl <- filter(ond2019, region == 10)
pobl <- mutate(pobl, poblacion = car::recode(pobl$cae_especifico, "0:28=1; else = NA"))
pobl <- mutate(pobl, menor15 = car::recode(pobl$cae_especifico, "0=1; else = NA"))
pobl <- mutate(pobl, pet = car::recode(pobl$cae_especifico, "1:28=1; else = NA"))
pobl <- within(pobl, {sexo <- Recode(sexo, '1="hombres"; 2="mujeres"', as.factor=TRUE)})                                                               
svydsgn_pobl <- pobl %>% as_survey_design(weights = fact, strata = estrato, ids = id_directorio)

 # poblacion total
pob_tot <- svytotal(~poblacion, svydsgn_pobl,na.rm = TRUE)
pob_tot_s <- svyby(~poblacion, ~sexo, svydsgn_pobl, svytotal, na.rm = TRUE, vartype="cv")

 # menores de 15 a�os
menor15 <- svytotal(~menor15, svydsgn_pobl,na.rm = TRUE)
menor15_s <- svyby(~menor15, ~sexo, svydsgn_pobl, svytotal, na.rm = TRUE, vartype="cv")

 # pet - para control, ya calculado*.
svytotal(~pet, svydsgn_pobl,na.rm = TRUE)
svyby(~pet, ~sexo, svydsgn_pobl, svytotal, na.rm = TRUE, vartype="cv")

# guardamos como nuevas pesta�as en planilla excel 
write.xlsx(pob_tot, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "pob_tot",  
           append = T)

write.xlsx(pob_tot_s, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "pob_tot_s", 
           append = T)

write.xlsx(menor15, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "menor15", 
           append = T)

write.xlsx(menor15_s, 
           file = "Principales_Indicadores_OND_2019.xlsx", 
           sheetName = "menor15_s", 
           append = T)

