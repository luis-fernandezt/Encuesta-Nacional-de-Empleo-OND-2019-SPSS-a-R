# Librerias ####
library(haven) 
library(tidyverse)
library(car)
library(survey)
library(srvyr)
library("xlsx")  

#BD ####
#LIBRO DE CÓDIGOS BASE DE DATOS ENCUESTA NACIONAL DE EMPLEO (ENE) - Versión Febrero 2023
download.file("https://www.ine.gob.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/libro-de-codigos/codigos-ene-2021.pdf?sfvrsn=54753851_38", 
              "libro-de-codigos-base-ene-2021.pdf", mode="wb")

#BD ENE 2022 12 NDE.SAV, 31.73 MB
download.file("https://www.ine.gob.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2022/spss/ene-2022-12-nde.sav?sfvrsn=69196e29_4&download=true", 
              "ene-2022-12-nde.sav", mode="wb")

#cargar BD
NDE2022 <- read_sav(".//ene-2022-12-nde.sav")
names(NDE2022)

#Filtramos por región de Los Lagos y población en edad de trabajar edad >= 15
nde2022_r10 <- filter(NDE2022, region == 10, edad >= 15)

#Principales indicadores ####

# *Variable Binaria de Personas en Edad de Trabajar, mayores de 15 años (pet)*.
nde2022_r10 <- mutate(nde2022_r10, pet = car::recode(nde2022_r10$edad, "0:14= NA; else = 1"))

# *Variable Binaria de Ocupados (o)*.
nde2022_r10 <- mutate(nde2022_r10, o = car::recode(nde2022_r10$cae_especifico, "1:7=1; else = NA"))

# *Variable Binaria de Desocupados (d)*.
nde2022_r10 <- mutate(nde2022_r10, d = car::recode(nde2022_r10$cae_especifico, "8:9=1; else = NA"))

# *Variable Binaria de Fuerza de Trabajo (fdt)*.
nde2022_r10 <- mutate(nde2022_r10, fdt = car::recode(nde2022_r10$cae_especifico, "1:9=1; else = NA"))

# *Variable Binaria inactivos*.
nde2022_r10 <- mutate(nde2022_r10, inactivos = car::recode(nde2022_r10$cae_especifico, "10:28=1; else = NA"))

#Recodificamos etiquetas de sexo
nde2022_r10 <- within(nde2022_r10, {sexo <- Recode(sexo, '1="hombres"; 2="mujeres"', as.factor=TRUE)})

#nde2022_r10$sexo <- as.factor(nde2022_r10$sexo) #Usar si Error ! Can't convert `value` <character> to <double>.

#Factor de expansión trimestral calibrado ####
svydsgn <- nde2022_r10 %>% as_survey_design(weights = fact_cal,
                                            strata = estrato,
                                            ids = conglomerado)


#Principales Indicadores ####
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


#Principales Indicadores Actividad Económica ####

#Clasificador de Actividades Económicas Nacional para Encuestas Sociodemográficas (CAENES)
caenes <- svyby(~o+sexo, ~b14_rev4cl_caenes,svydsgn, svytotal, na.rm = TRUE, vartype="cv")

#Clasificación Internacional de la Situación en el Empleo (CISE) 1993
cise <- svyby(~o+sexo, ~categoria_ocupacion,svydsgn, svytotal, na.rm = TRUE, vartype="cv")

#Clasificación Internacional Uniforme de Ocupaciones CIUO -08
ciuo <- svyby(~o+sexo, ~b1, svydsgn, svytotal, na.rm = TRUE, vartype="cv")

# CV ####
o
cv(o)
os
cv(os)

# Opcionalmente se pueden exportar todos los resultados a un único archivo *.xlsx
# *archivo de salida básico sin ajustes de estilo*
write.xlsx(pet, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "pet", 
           append = F)

write.xlsx(pet_s, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "pet_sexo", 
           append = T)

write.xlsx(fdt, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "fdt", 
           append = T)

write.xlsx(fdt_s, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "fdt_sexo", 
           append = T)

write.xlsx(o, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "o", 
           append = T)

write.xlsx(os, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "o_sexo", 
           append = T)

write.xlsx(d, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "d", 
           append = T)

write.xlsx(ds, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "d_sexo", 
           append = T)

write.xlsx(inactivos, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "inactivos", 
           append = T)

write.xlsx(inactivos_s, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "inactivos_sexo", 
           append = T)

write.xlsx(td, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "td", 
           append = T)

write.xlsx(to, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "to", 
           append = T)

write.xlsx(tp, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "tp", 
           append = T)

write.xlsx(caenes, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "caenes", 
           append = T)

write.xlsx(cise, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "cise-93", 
           append = T)

write.xlsx(ciuo, 
           file = "Principales_Indicadores_NDE2022.xlsx", 
           sheetName = "ciuo-08", 
           append = T)
