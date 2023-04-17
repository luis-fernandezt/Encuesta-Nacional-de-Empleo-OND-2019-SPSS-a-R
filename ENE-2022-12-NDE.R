#Cargamos las librerias
library(haven) 
library(tidyverse)
library(car)
library(survey)
library(srvyr)
library("xlsx")  

#LIBRO DE CÓDIGOS BASE DE DATOS ENCUESTA NACIONAL DE EMPLEO (ENE) - Versión Febrero 2023
download.file("https://www.ine.gob.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/libro-de-codigos/codigos-ene-2021.pdf?sfvrsn=54753851_38", 
              "libro-de-codigos-base-ene-2021.pdf", mode="wb")

#BD ENE 2022 12 NDE.SAV, 31.73 MB
download.file("https://www.ine.gob.cl/docs/default-source/ocupacion-y-desocupacion/bbdd/2022/spss/ene-2022-12-nde.sav?sfvrsn=69196e29_4&download=true", 
              "ene-2022-12-nde.sav", mode="wb")

#cargar BD
NDE2022 <- read_sav(".//ene-2022-12-nde.sav")

names(NDE2022)

