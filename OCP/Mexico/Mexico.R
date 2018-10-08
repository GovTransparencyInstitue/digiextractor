#clean all Contratos files

#set directory
setwd("C:/Users/Bertold/Downloads/mexico_contratos/")
getwd()

#checking current memory limit
memory.limit()
#setting a bigger one
memory.limit(30000)


#contratos2018

#Contratos2018
df_contr18 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2018_csv.csv", header = TRUE, sep = ";")

#alternatively with Latin-1 encoding
df_contr18 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2018_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr18 <- df_contr18[myvars]

#rename variables equivalent to OCDS
names(df_contr18)[names(df_contr18) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr18)[names(df_contr18) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr18)[names(df_contr18) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr18)[names(df_contr18) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr18)[names(df_contr18) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr18)[names(df_contr18) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr18)[names(df_contr18) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr18)[names(df_contr18) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr18)[names(df_contr18) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr18)[names(df_contr18) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr18)[names(df_contr18) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr18)[names(df_contr18) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr18)[names(df_contr18) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr18)[names(df_contr18) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr18)[names(df_contr18) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr18)[names(df_contr18) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr18)[names(df_contr18) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr18)[names(df_contr18) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr18)[names(df_contr18) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr18)[names(df_contr18) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr18)[names(df_contr18) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'


#check and set type of variables
str(df_contr18)
df_contr18$rec_com_ten_startDate <- as.Date(df_contr18$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr18$rec_com_ten_endDate <- as.Date(df_contr18$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
#all types look fine

df_contr18$rec_com_ca_doc_url[df_contr18$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr18, function(df_contr18) sum(is.na(df_contr18)))
mean(is.na(df_contr18$rec_com_ten_startDate))
#65%
mean(is.na(df_contr18$rec_com_ten_endDate))
#64%
mean(is.na(df_contr18$rec_com_plan_bBd_bCl_meas_vamount))
#99%
#drop this variable
df_contr18$rec_com_plan_bbBd_bCl_meas_vamount <- NULL

mean(is.na(df_contr18$rec_com_ca_dateSigned))
#65%
mean(is.na(df_contr18$rec_com_aw_sup_id))
#65%

write.csv(df_contr18, file = "Contratos2018_csv_new.csv")

##########################

#Contratos2017
df_contr17 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2017_csv.csv", header = TRUE, sep = ";")

#alternatively with Latin-1 encoding
df_contr17 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2017_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr17 <- df_contr17[myvars]

#rename variables equivalent to OCDS
names(df_contr17)[names(df_contr17) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr17)[names(df_contr17) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr17)[names(df_contr17) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr17)[names(df_contr17) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr17)[names(df_contr17) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr17)[names(df_contr17) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr17)[names(df_contr17) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr17)[names(df_contr17) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr17)[names(df_contr17) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr17)[names(df_contr17) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr17)[names(df_contr17) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr17)[names(df_contr17) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr17)[names(df_contr17) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr17)[names(df_contr17) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr17)[names(df_contr17) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr17)[names(df_contr17) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr17)[names(df_contr17) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr17)[names(df_contr17) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr17)[names(df_contr17) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr17)[names(df_contr17) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr17)[names(df_contr17) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'

#check and set type of variables
str(df_contr17)
df_contr17$rec_com_ten_startDate <- as.Date(df_contr17$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr17$rec_com_ten_endDate <- as.Date(df_contr17$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
#all types look fine

df_contr17$rec_com_ca_doc_url[df_contr17$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr17, function(df_contr17) sum(is.na(df_contr17)))
mean(is.na(df_contr17$rec_com_plan_bBd_bCl_meas_vamount))
#95%
#drop this variable
df_contr17$rec_com_plan_bbBd_bCl_meas_vamount <- NULL

mean(is.na(df_contr17$rec_com_ca_dateSigned))
#63%
mean(is.na(df_contr17$rec_com_aw_sup_id))
#65%

write.csv(df_contr17, file = "Contratos2017_csv_new.csv")

#########################

#Contratos2016
df_contr16 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2016_csv.csv", header = TRUE, sep = ";")

#alternatively with Latin-1 encoding
df_contr16 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2016_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr16 <- Contratos2016_csv[myvars]

#rename variables equivalent to OCDS
names(df_contr16)[names(df_contr16) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr16)[names(df_contr16) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr16)[names(df_contr16) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr16)[names(df_contr16) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr16)[names(df_contr16) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr16)[names(df_contr16) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr16)[names(df_contr16) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr16)[names(df_contr16) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr16)[names(df_contr16) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr16)[names(df_contr16) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr16)[names(df_contr16) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr16)[names(df_contr16) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr16)[names(df_contr16) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr16)[names(df_contr16) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr16)[names(df_contr16) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr16)[names(df_contr16) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr16)[names(df_contr16) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr16)[names(df_contr16) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr16)[names(df_contr16) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr16)[names(df_contr16) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr16)[names(df_contr16) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'

#check and set type of variables
str(df_contr16)
df_contr16$rec_com_ten_startDate <- as.Date(df_contr16$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr16$rec_com_ten_endDate <- as.Date(df_contr16$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
#all types look fine

df_contr16$rec_com_ca_doc_url[df_contr16$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr16, function(df_contr16) sum(is.na(df_contr16)))
mean(is.na(df_contr16$rec_com_plan_bBd_bCl_meas_vamount))
#95%
#drop this variable
df_contr16$rec_com_plan_bbBd_bCl_meas_vamount <- NULL

mean(is.na(df_contr16$rec_com_ca_dateSigned))
#53%
mean(is.na(df_contr16$rec_com_aw_sup_id))
#68%

write.csv(df_contr16, file = "Contratos2016_csv_new.csv")


##########################################
install.packages('readr')
library(readr)

#Contratos2015
df_contr15 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2015_csv.csv", header = TRUE, sep = ";")

#alternatively with Latin-1 encoding
df_contr15 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2015_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr15 <- df_contr15[myvars]

#rename variables equivalent to OCDS
names(df_contr15)[names(df_contr15) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr15)[names(df_contr15) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr15)[names(df_contr15) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr15)[names(df_contr15) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr15)[names(df_contr15) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr15)[names(df_contr15) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr15)[names(df_contr15) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr15)[names(df_contr15) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr15)[names(df_contr15) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr15)[names(df_contr15) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr15)[names(df_contr15) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr15)[names(df_contr15) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr15)[names(df_contr15) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr15)[names(df_contr15) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr15)[names(df_contr15) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr15)[names(df_contr15) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr15)[names(df_contr15) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr15)[names(df_contr15) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr15)[names(df_contr15) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr15)[names(df_contr15) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr15)[names(df_contr15) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'


names(df_contr15)

#check and set type of variables
str(df_contr15)
df_contr15$rec_com_ten_startDate <- as.Date(df_contr15$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr15$rec_com_ten_endDate <- as.Date(df_contr15$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
#all types look fine

df_contr15$rec_com_ca_doc_url[df_contr15$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr15, function(df_contr15) sum(is.na(df_contr15)))
mean(is.na(df_contr15$rec_com_ten_startDate))
#57%
mean(is.na(df_contr15$rec_com_ten_endDate))
#47%
mean(is.na(df_contr15$rec_com_plan_bBd_bCl_meas_vamount))
#95%
mean(is.na(df_contr15$rec_com_ca_dateSigned))
#53%
mean(is.na(df_contr15$rec_com_aw_sup_id))
#70%

#drop unnecessary variables: rec_com_plan_bBd_bCl_meas_vamount, rec_com_ten_url
df_contr15$rec_com_plan_bBd_bCl_meas_vamount <- NULL
df_contr15$rec_com_ten_doc_url <- NULL
df_contr15$rec_com_buyer_conpoi_name <- NULL

#check unique ids
length(unique(df_contr15$rec_com_ca_id))
#ok, unique

#contract value amount, outliers
summary(df_contr15$rec_com_ca_vamount)
df_contr15$rec_com_ca_vamount[df_contr15$rec_com_ca_vamount < 6700] <- NA
df_contr15$rec_com_ca_vamount[df_contr15$rec_com_ca_vamount > 222600000000] <- NA
sum(is.na(df_contr15$rec_com_ca_vamount))
#14866
mean(is.na(df_contr15$rec_com_ca_vamount))
#6.8%

#date outliers (if contract start date is later than end date)
df_contr15$rec_com_ca_startDate[df_contr15$rec_com_ca_startDate > df_contr15$rec_com_ca_endDate] <- NA
sum(is.na(df_contr15$rec_com_ca_startDate))
mean(is.na(df_contr15$rec_com_ca_startDate))
#no such cases

write.csv(df_contr15, file = "Contratos2015_csv_new.csv")

#############################
#Contratos2014
df_contr14 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2014_csv.csv", header = TRUE, sep = ";")
View(df_contr14)

#alternatively with Latin-1 encoding
df_contr14 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2014_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr14 <- df_contr14[myvars]

#rename variables equivalent to OCDS
names(df_contr14)[names(df_contr14) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr14)[names(df_contr14) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr14)[names(df_contr14) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr14)[names(df_contr14) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr14)[names(df_contr14) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr14)[names(df_contr14) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr14)[names(df_contr14) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr14)[names(df_contr14) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr14)[names(df_contr14) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr14)[names(df_contr14) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr14)[names(df_contr14) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr14)[names(df_contr14) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr14)[names(df_contr14) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr14)[names(df_contr14) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr14)[names(df_contr14) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr14)[names(df_contr14) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr14)[names(df_contr14) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr14)[names(df_contr14) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr14)[names(df_contr14) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr14)[names(df_contr14) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr14)[names(df_contr14) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'


names(df_contr14)

#check and set type of variables
str(df_contr14)
df_contr14$rec_com_ten_startDate <- as.Date(df_contr14$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr14$rec_com_ten_endDate <- as.Date(df_contr14$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
df_contr14$rec_com_ca_startDate <- as.Date(df_contr14$rec_com_ca_startDate)
df_contr14$rec_com_ca_endDate <- as.Date(df_contr14$rec_com_ca_endDate)
#other types look fine

df_contr14$rec_com_ca_doc_url[df_contr14$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr14, function(df_contr14) sum(is.na(df_contr14)))
mean(is.na(df_contr14$rec_com_plan_bBd_bCl_meas_vamount))
#95%
mean(is.na(df_contr14$rec_com_aw_sup_id))
#75%
#no or very few missing values in other variables

#drop unnecessary variable: rec_com_plan_bBd_bCl_meas_vamount
df_contr14$rec_com_plan_bBd_bCl_meas_vamount <- NULL

#check unique ids
length(unique(df_contr14$rec_com_ca_id))
#ok, unique

#contract value amount, outliers
summary(df_contr14$rec_com_ca_vamount)
df_contr14$rec_com_ca_vamount[df_contr14$rec_com_ca_vamount < 6700] <- NA
df_contr14$rec_com_ca_vamount[df_contr14$rec_com_ca_vamount > 222600000000] <- NA
sum(is.na(df_contr14$rec_com_ca_vamount))
#8626
mean(is.na(df_contr14$rec_com_ca_vamount))
#4.9%

#date outliers (if contract start date is later than end date)
df_contr14$rec_com_ca_startDate[df_contr14$rec_com_ca_startDate > df_contr14$rec_com_ca_endDate] <- NA
sum(is.na(df_contr14$rec_com_ca_startDate))
mean(is.na(df_contr14$rec_com_ca_startDate))
#no such cases

write.csv(df_contr14, file = "Contratos2014_csv_new.csv")
##########################################################

#Contratos2013 - excel files were converted to csvs, so delimiter should be ";" instead of ","
df_contr13 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2013_csv.csv", header = TRUE, sep = ";")
View(df_contr13)

#alternatively with Latin-1 encoding
df_contr13 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2013_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr13 <- df_contr13[myvars]

#rename variables equivalent to OCDS
names(df_contr13)[names(df_contr13) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr13)[names(df_contr13) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr13)[names(df_contr13) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr13)[names(df_contr13) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr13)[names(df_contr13) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr13)[names(df_contr13) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr13)[names(df_contr13) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr13)[names(df_contr13) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr13)[names(df_contr13) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr13)[names(df_contr13) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr13)[names(df_contr13) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr13)[names(df_contr13) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr13)[names(df_contr13) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr13)[names(df_contr13) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr13)[names(df_contr13) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr13)[names(df_contr13) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr13)[names(df_contr13) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr13)[names(df_contr13) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr13)[names(df_contr13) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr13)[names(df_contr13) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr13)[names(df_contr13) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'


names(df_contr13)

#check and set type of variables
str(df_contr13)
#R imported data as factor, modify varriable types
#change dates
df_contr13$rec_com_ten_startDate <- as.Date(df_contr13$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr13$rec_com_ten_endDate <- as.Date(df_contr13$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
df_contr13$rec_com_ca_startDate <- as.Date(df_contr13$rec_com_ca_startDate)
df_contr13$rec_com_ca_endDate <- as.Date(df_contr13$rec_com_ca_endDate)
df_contr13$rec_com_ca_dateSigned <- as.Date(df_contr13$rec_com_ca_dateSigned)

#ids to integer
df_contr13$rec_com_ca_buyer_id <- as.integer(df_contr13$rec_com_ca_buyer_id)
df_contr13$rec_com_id <- as.integer(df_contr13$rec_com_id)

#names, titles to character
df_contr13$rec_com_ca_buyer_name <- as.character(df_contr13$rec_com_ca_buyer_name)
df_contr13$rec_com_ten_title <- as.character(df_contr13$rec_com_ten_title)
df_contr13$rec_com_ten_procMethod <- as.character(df_contr13$rec_com_ten_procMethod)
df_contr13$rec_com_ten_procCat <- as.character(df_contr13$rec_com_ten_procCat)
df_contr13$rec_com_ca_title <- as.character(df_contr13$rec_com_ca_title)
df_contr13$rec_com_ca_vcurr <- as.character(df_contr13$rec_com_ca_vcurr)
df_contr13$rec_com_ca_status <- as.character(df_contr13$rec_com_ca_status)
df_contr13$rec_com_aw_sup_name <- as.character(df_contr13$rec_com_aw_sup_name)

sapply(df_contr13, class)

df_contr13$rec_com_ca_doc_url[df_contr13$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr13, function(df_contr13) sum(is.na(df_contr13)))
mean(is.na(df_contr13$rec_com_ten_startDate))
#37%
mean(is.na(df_contr13$rec_com_ten_endDate))
#26%
mean(is.na(df_contr13$rec_com_plan_bBd_bCl_meas_vamount))
#95%
mean(is.na(df_contr13$rec_com_ca_dateSigned))
#54%
mean(is.na(df_contr13$rec_com_aw_sup_id))
#74%
#no missing values in other variables

#drop unnecessary variable: rec_com_plan_bBd_bCl_meas_vamount
df_contr13$rec_com_plan_bBd_bCl_meas_vamount <- NULL

#check unique ids
length(unique(df_contr13$rec_com_ca_id))
#ok, unique

#contract value amount, outliers
summary(df_contr13$rec_com_ca_vamount)
df_contr13$rec_com_ca_vamount[df_contr13$rec_com_ca_vamount < 6700] <- NA
df_contr13$rec_com_ca_vamount[df_contr13$rec_com_ca_vamount > 222600000000] <- NA
sum(is.na(df_contr13$rec_com_ca_vamount))
#6733
mean(is.na(df_contr13$rec_com_ca_vamount))
#4.3%

#date outliers (if contract start date is later than end date)
df_contr13$rec_com_ca_startDate[df_contr13$rec_com_ca_startDate > df_contr13$rec_com_ca_endDate] <- NA
sum(is.na(df_contr13$rec_com_ca_startDate))
mean(is.na(df_contr13$rec_com_ca_startDate))
#no such cases

write.csv(df_contr13, file = "Contratos2013_csv_new.csv")

######################################################################
#Contratos2010-2012

df_contr10_12 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2010_2012_csv.csv", header = TRUE, sep = ";")
View(df_contr10_12)

#alternatively with Latin-1 encoding
df_contr10_12 <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/Contratos2010_2012_csv.csv", header = TRUE, sep = ";", encoding = "Latin-1")


#keeping the ones we need
myvars <- c('DEPENDENCIA', 'CLAVEUC','CODIGO_EXPEDIENTE','TITULO_EXPEDIENTE','PLANTILLA_EXPEDIENTE','NUMERO_PROCEDIMIENTO','PROC_F_PUBLICACION','FECHA_APERTURA_PROPOSICIONES', 'TIPO_CONTRATACION', 'CODIGO_CONTRATO', 'TITULO_CONTRATO', 'FECHA_INICIO', 'FECHA_FIN', 'IMPORTE_CONTRATO', 'MONEDA', 'ESTATUS_CONTRATO', 'APORTACION_FEDERAL', 'FECHA_CELEBRACION', 'FOLIO_RUPC', 'PROVEEDOR_CONTRATISTA', 'ANUNCIO')
df_contr10_12 <- df_contr10_12[myvars]

#rename variables equivalent to OCDS
names(df_contr10_12)[names(df_contr10_12) == 'DEPENDENCIA'] <- 'rec_com_ca_buyer_name'
names(df_contr10_12)[names(df_contr10_12) == 'CLAVEUC'] <- 'rec_com_ca_buyer_id'
names(df_contr10_12)[names(df_contr10_12) == 'CODIGO_EXPEDIENTE'] <- 'rec_com_ten_id'
names(df_contr10_12)[names(df_contr10_12) == 'TITULO_EXPEDIENTE'] <- 'rec_com_ten_title'
names(df_contr10_12)[names(df_contr10_12) == 'PLANTILLA_EXPEDIENTE'] <- 'rec_com_ten_procMethod'
names(df_contr10_12)[names(df_contr10_12) == 'NUMERO_PROCEDIMIENTO'] <- 'rec_com_id'
names(df_contr10_12)[names(df_contr10_12) == 'PROC_F_PUBLICACION'] <- 'rec_com_ten_startDate'
names(df_contr10_12)[names(df_contr10_12) == 'FECHA_APERTURA_PROPOSICIONES'] <- 'rec_com_ten_endDate'
names(df_contr10_12)[names(df_contr10_12) == 'TIPO_CONTRATACION'] <- 'rec_com_ten_procCat'
names(df_contr10_12)[names(df_contr10_12) == 'CODIGO_CONTRATO'] <- 'rec_com_ca_id'
names(df_contr10_12)[names(df_contr10_12) == 'TITULO_CONTRATO'] <- 'rec_com_ca_title'
names(df_contr10_12)[names(df_contr10_12) == 'FECHA_INICIO'] <- 'rec_com_ca_startDate'
names(df_contr10_12)[names(df_contr10_12) == 'FECHA_FIN'] <- 'rec_com_ca_endDate'
names(df_contr10_12)[names(df_contr10_12) == 'IMPORTE_CONTRATO'] <- 'rec_com_ca_vamount'
names(df_contr10_12)[names(df_contr10_12) == 'MONEDA'] <- 'rec_com_ca_vcurr'
names(df_contr10_12)[names(df_contr10_12) == 'ESTATUS_CONTRATO'] <- 'rec_com_ca_status'
names(df_contr10_12)[names(df_contr10_12) == 'APORTACION_FEDERAL'] <- 'rec_com_plan_bBd_bCl_meas_vamount'
names(df_contr10_12)[names(df_contr10_12) == 'FECHA_CELEBRACION'] <- 'rec_com_ca_dateSigned'
names(df_contr10_12)[names(df_contr10_12) == 'FOLIO_RUPC'] <- 'rec_com_aw_sup_id'
names(df_contr10_12)[names(df_contr10_12) == 'PROVEEDOR_CONTRATISTA'] <- 'rec_com_aw_sup_name'
names(df_contr10_12)[names(df_contr10_12) == 'ANUNCIO'] <- 'rec_com_ca_doc_url'


names(df_contr10_12)

#check and set type of variables
str(df_contr10_12)
#R imported data as factor, modify varriable types
#change dates
df_contr10_12$rec_com_ten_startDate <- as.Date(df_contr10_12$rec_com_ten_startDate, tz = "UTC","%Y-%m-%d")
df_contr10_12$rec_com_ten_endDate <- as.Date(df_contr10_12$rec_com_ten_endDate, tz = "UTC", "%Y-%m-%d")
df_contr10_12$rec_com_ca_startDate <- as.Date(df_contr10_12$rec_com_ca_startDate)
df_contr10_12$rec_com_ca_endDate <- as.Date(df_contr10_12$rec_com_ca_endDate)
df_contr10_12$rec_com_ca_dateSigned <- as.Date(df_contr10_12$rec_com_ca_dateSigned, tz = "UTC", "%Y-%m-%d")

#ids to integer
df_contr10_12$rec_com_ca_buyer_id <- as.integer(df_contr10_12$rec_com_ca_buyer_id)
df_contr10_12$rec_com_id <- as.integer(df_contr10_12$rec_com_id)

#names, titles to character
df_contr10_12$rec_com_ca_buyer_name <- as.character(df_contr10_12$rec_com_ca_buyer_name)
df_contr10_12$rec_com_ten_title <- as.character(df_contr10_12$rec_com_ten_title)
df_contr10_12$rec_com_ten_procMethod <- as.character(df_contr10_12$rec_com_ten_procMethod)
df_contr10_12$rec_com_ten_procCat <- as.character(df_contr10_12$rec_com_ten_procCat)
df_contr10_12$rec_com_ca_title <- as.character(df_contr10_12$rec_com_ca_title)
df_contr10_12$rec_com_ca_vcurr <- as.character(df_contr10_12$rec_com_ca_vcurr)
df_contr10_12$rec_com_ca_status <- as.character(df_contr10_12$rec_com_ca_status)
df_contr10_12$rec_com_aw_sup_name <- as.character(df_contr10_12$rec_com_aw_sup_name)

sapply(df_contr10_12, class)

df_contr10_12$rec_com_ca_doc_url[df_contr10_10$rec_com_ca_doc_url==""] <- NA

#missing values
sapply(df_contr10_12, function(df_contr10_12) sum(is.na(df_contr10_12)))
mean(is.na(df_contr10_12$rec_com_ten_startDate))
#36%
mean(is.na(df_contr10_12$rec_com_ten_endDate))
#23%
mean(is.na(df_contr10_12$rec_com_plan_bBd_bCl_meas_vamount))
#96%
mean(is.na(df_contr10_12$rec_com_ca_dateSigned))
#55%
mean(is.na(df_contr10_12$rec_com_aw_sup_id))
#74%
#no missing values in other variables

#drop unnecessary variable: rec_com_plan_bBd_bCl_meas_vamount
df_contr10_12$rec_com_plan_bBd_bCl_meas_vamount <- NULL

df_contr10_12$rec_com_ca_id <- as.numeric(df_contr10_12$rec_com_ca_id)
#check unique ids
length(unique(df_contr10_12$rec_com_ca_id))
#very few duplicates, check

n_occur <- data.frame(table(df_contr10_12$rec_com_ca_id))
n_occur[n_occur$Freq > 1,]

#check duplicated rows
df_contr10_12[duplicated(df_contr10_12$rec_com_ca_id) | duplicated(df_contr10_12$rec_com_ca_id, fromLast = TRUE), ]
#remove completely duplicated rows
df_contr10_12 <- df_contr10_12[!duplicated(df_contr10_12),]

#check unique ids
length(unique(df_contr10_12$rec_com_ca_id))
#now it's good

#contract value amount, outliers
summary(df_contr10_12$rec_com_ca_vamount)
df_contr10_12$rec_com_ca_vamount[df_contr10_12$rec_com_ca_vamount < 6700] <- NA
df_contr10_12$rec_com_ca_vamount[df_contr10_12$rec_com_ca_vamount > 222600000000] <- NA
sum(is.na(df_contr10_12$rec_com_ca_vamount))
#9003
mean(is.na(df_contr10_12$rec_com_ca_vamount))
#3.6%

#date outliers (if contract start date is later than end date)
df_contr10_12$rec_com_ca_startDate[df_contr10_12$rec_com_ca_startDate > df_contr10_12$rec_com_ca_endDate] <- NA
sum(is.na(df_contr10_12$rec_com_ca_startDate))
mean(is.na(df_contr10_12$rec_com_ca_startDate))
#no such cases

write.csv(df_contr10_12, file = "Contratos2010_12_csv_new.csv")

###########################MERGE CONTRATOS files###################

#combine all Contratos file from different years
#the structure (number of columns, names) are identical, rbind paste rows under each other
#import all files

#set new directory for selected files to merge
setwd("C:/Users/Bertold/Downloads/mexico_contratos/combine contratos")
getwd()

install.packages("plyr")
library(plyr)

install.packages("data.table")
library(data.table)

files <- list.files("C:/Users/Bertold/Downloads/mexico_contratos/combine contratos", full.names = TRUE)
import.list <- llply(files, read.csv)

df_contr_all <- rbindlist(lapply(files, function(x){read.csv(x, stringsAsFactors = F, sep = ',')}))  
View(df_contr_all)

#remove unnecessary column
df_contr_all$X <- NULL

#rearrange columns to fit ocds data order
names(df_contr_all)

#reorder columns to be aligned with ocds contract file
df_contr_all <- df_contr_all[,c(6,10,11,14,15,12,13,16,1,2,3,4,5,7,8,9,17,18,19)]
#check variable types
sapply(df_contr_all, class)

#change variable types
df_contr_all$rec_com_ca_id <- as.character(df_contr_all$rec_com_ca_id)

df_contr_all$rec_com_ten_startDate1 <- df_contr_all$rec_com_ten_startDate
df_contr_all$rec_com_ten_startDate1 <- as.Date(df_contr_all$rec_com_ten_startDate1, format = "%Y-%m-%d")
df_contr_all$rec_com_ten_startDate <- df_contr_all$rec_com_ten_startDate1
df_contr_all$rec_com_ten_startDate1 <- NULL

df_contr_all$rec_com_ten_endDate1 <- df_contr_all$rec_com_ten_endDate
df_contr_all$rec_com_ten_endDate1 <- as.Date(df_contr_all$rec_com_ten_endDate1, format = "%Y-%m-%d")
df_contr_all$rec_com_ten_endDate <- df_contr_all$rec_com_ten_endDate1
df_contr_all$rec_com_ten_endDate1 <- NULL

df_contr_all$rec_com_ca_startDate1 <- df_contr_all$rec_com_ca_startDate
df_contr_all$rec_com_ca_startDate1 <- as.Date(df_contr_all$rec_com_ca_startDate1, format = "%Y-%m-%d")
df_contr_all$rec_com_ca_startDate <- df_contr_all$rec_com_ca_startDate1
df_contr_all$rec_com_ca_startDate1 <- NULL

df_contr_all$rec_com_ca_endDate1 <- df_contr_all$rec_com_ca_endDate
df_contr_all$rec_com_ca_endDate1 <- as.Date(df_contr_all$rec_com_ca_endDate1, format = "%Y-%m-%d")
df_contr_all$rec_com_ca_endDate <- df_contr_all$rec_com_ca_endDate1
df_contr_all$rec_com_ca_endDate1 <- NULL

df_contr_all$rec_com_ca_dateSigned1 <- df_contr_all$rec_com_ca_dateSigned
df_contr_all$rec_com_ca_dateSigned1 <- as.Date(df_contr_all$rec_com_ca_dateSigned1, format = "%Y-%m-%d")
df_contr_all$rec_com_ca_dateSigned <- df_contr_all$rec_com_ca_dateSigned1
df_contr_all$rec_com_ca_dateSigned1 <- NULL


#missing values
sapply(df_contr_all, function(df_contr_all) sum(is.na(df_contr_all)))

mean(is.na(df_contr_all$rec_com_ca_vamount))
#5.8%
mean(is.na(df_contr_all$rec_com_ten_startDate))
#31.4%
mean(is.na(df_contr_all$rec_com_ten_endDate))
#24.8%
mean(is.na(df_contr_all$rec_com_ca_dateSigned))
#56%
mean(is.na(df_contr_all$rec_com_aw_sup_id))
#70.1%
#aligned with the annual datasets

#contract and tender start dates
identical(df_contr_all[['df_contr_all$rec_com_ca_startDate']],df_contr_all[['df_contr_all$rec_com_ten_startDate']])
#TRUE

#recode status
table(df_contr_all$rec_com_ca_status)
df_contr_all$rec_com_ca_status[df_contr_all$rec_com_ca_status=="Activo"] <- "active"
df_contr_all$rec_com_ca_status[df_contr_all$rec_com_ca_status=="Expirado"] <- "terminated"
df_contr_all$rec_com_ca_status[df_contr_all$rec_com_ca_status=="Terminado"] <- "terminated"
df_contr_all$rec_com_ca_status1 <- df_contr_all$rec_com_ca_status
df_contr_all$rec_com_ca_status1 <- ifelse(df_contr_all$rec_com_ca_status1 != "active" & df_contr_all$rec_com_ca_status1 != "terminated", NA, df_contr_all$rec_com_ca_status1) 

table(df_contr_all$rec_com_ca_status1)
df_contr_all$rec_com_ca_status <- df_contr_all$rec_com_ca_status1
df_contr_all$rec_com_ca_status1 <- NULL

#recode procurement categories
table(df_contr_all$rec_com_ten_procCat)
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Adquisiciones"] <- "goods"
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Arrendamientos"] <- "services"
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Internacional"] <- NA
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Nacional"] <- NA
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Obra P<fa>blica"] <- "work"
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Obra Pública"] <- "work"
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Servicios"] <- "services"
df_contr_all$rec_com_ten_procCat[df_contr_all$rec_com_ten_procCat=="Servicios Relacionados con la OP"] <- "PW related services"
table(df_contr_all$rec_com_ten_procCat)

#recode tender procurement method
table(df_contr_all$rec_com_ten_procMethod)

df_contr_all$rec_com_ten_procMethod1 <- df_contr_all$rec_com_ten_procMethod
df_contr_all$rec_com_ten_procMethod1[grepl("*Directa*", df_contr_all$rec_com_ten_procMethod1)] <- "direct"
df_contr_all$rec_com_ten_procMethod1[grepl("*Invitac*", df_contr_all$rec_com_ten_procMethod1)] <- "selective"
df_contr_all$rec_com_ten_procMethod1[grepl("*Publica*", df_contr_all$rec_com_ten_procMethod1)] <- "open"
df_contr_all$rec_com_ten_procMethod1[grepl("*Licitaci*", df_contr_all$rec_com_ten_procMethod1)] <- "open"
df_contr_all$rec_com_ten_procMethod1[grepl("*Privada*", df_contr_all$rec_com_ten_procMethod1)] <- "direct"
df_contr_all$rec_com_ten_procMethod1[grepl("*externo*", df_contr_all$rec_com_ten_procMethod1)] <- "limited"

df_contr_all$rec_com_ten_procMethod1 <- ifelse(df_contr_all$rec_com_ten_procMethod1 != "direct" & df_contr_all$rec_com_ten_procMethod1 != "open" & df_contr_all$rec_com_ten_procMethod1 != "selective" & df_contr_all$rec_com_ten_procMethod1 != "limited", NA, df_contr_all$rec_com_ten_procMethod1) 

table(df_contr_all$rec_com_ten_procMethod1)
sum(is.na(df_contr_all$rec_com_ten_procMethod1))

df_contr_all$rec_com_ten_procMethod <- df_contr_all$rec_com_ten_procMethod1

df_contr_all$rec_com_ten_procMethod1 <- NULL


#remove duplicated rows by contract id
df_contr_all <- df_contr_all[!duplicated(df_contr_all$rec_com_ca_id), ]
#1400154 -> 1400069, very few rows


write.csv(df_contr_all, file = "df_contr_all_0922.csv")

write.csv(df_contr_all, file = "df_contr_all0922.csv")

########################################################################OCDS
#clean OCDS subfiles

#set directory
setwd("C:/Users/Bertold/Downloads/only-raw-flattened/result")
getwd()

#checking current memory limit
memory.limit()
#setting a bigger one
memory.limit(20000)

install.packages('readr')
library(readr)

#newly_generated_mexico_flat

#rec_com_awa_items.csv
df1 <- read_csv('rec_com_awa_items.csv')

#basic information on the database 
class(df1)
dim(df1)
str(df1)

#rename variables
names(df1) <- gsub(x = names(df1), pattern = "records/0/compiledRelease/awards/0/items/0/", replacement = "rec_com_aw_item_")

names(df1)[names(df1) == 'records/0/compiledRelease/id'] <- 'rec_com_id'
names(df1)[names(df1) == 'records/0/compiledRelease/awards/0/id'] <- 'rec_com_aw_id'
names(df1)[names(df1) == 'rec_com_aw_item_unit/name'] <- 'rec_com_aw_item_unit_name'
names(df1)[names(df1) == 'rec_com_aw_item_unit/value/amount'] <- 'rec_com_aw_item_unit_vamount'
names(df1)[names(df1) == 'rec_com_aw_item_unit/value/currency'] <- 'rec_com_aw_item_unit_vcurr'
names(df1)[names(df1) == 'rec_com_aw_item_description'] <- 'rec_com_aw_item_descr'
names(df1)[names(df1) == 'rec_com_aw_item_classification/id'] <- 'rec_com_aw_item_class_id'
names(df1)[names(df1) == 'rec_com_aw_item_classification/uri'] <- 'rec_com_aw_item_class_uri'
names(df1)[names(df1) == 'rec_com_aw_item_classification/scheme'] <- 'rec_com_aw_item_class_scheme'
names(df1)[names(df1) == 'rec_com_aw_item_classification/description'] <- 'rec_com_aw_item_class_descr'

names(df1)

#drop unnecessary variables
df1$rec_com_aw_item_class_uri <- NULL
df1$rec_com_aw_item_class_scheme <- NULL

#check missing values
sapply(df1, function(df1) sum(is.na(df1)))
#no missing values

#check if there is a unique id
length(unique(df1$rec_com_aw_item_id))
#unique, but not included in other file, cannot be used for merging

length(unique(df1$rec_com_aw_id))
#many duplicates

length(unique(df1$rec_com_id))
#many duplicates

write.csv(df1, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_awa_items_raw.csv", row.names = FALSE)

#######################################

#rec_com_awa_suppliers.csv
df3 <- read_csv('rec_com_awa_suppliers.csv')

#basic information on the database
class(df3)
dim(df3)
str(df3)

#rename variables
names(df3) <- gsub(x = names(df3), pattern = "records/0/compiledRelease/awards/0/", replacement = "rec_com_aw_")
names(df3) <- gsub(x = names(df3), pattern = "suppliers/0/", replacement = "sup_")
names(df3) <- gsub(x = names(df3), pattern = "awards/0/", replacement = "aw_")
names(df3)[names(df3) == 'records/0/compiledRelease/id'] <- 'rec_com_id'
names(df3)

#check general structure, columns look as they should
head(df3, n=100)
tail(df3, n=100)
str(df3)

#missing values
sapply(df3, function(df3) sum(is.na(df3)))
#no missing values

#check types of variables
sapply(df3, class)
#looks good

#unique id
length(unique(df3$rec_com_aw_id))
#unique 

length(unique(df3$rec_com_id))
#15% duplicated 

length(unique(df3$rec_com_aw_sup_id))
#20% duplicated, normal

#save the file
write.csv(df3, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_awa_suppliers_raw.csv", row.names = FALSE)

#####################################

#rec_com_awards.csv
df4 <- read_csv('rec_com_awards.csv')
view(df4)

#basic information on the database
class(df4)
dim(df4)
str(df4)

#rename variables
names(df4) <- gsub(x = names(df4), pattern = "records/0/compiledRelease/awards/0/", replacement = "rec_com_aw_")

names(df4)[names(df4) == 'records/0/compiledRelease/id'] <- 'rec_com_id'
names(df4)[names(df4) == 'rec_com_aw_value/amount'] <- 'rec_com_aw_vamount'
names(df4)[names(df4) == 'rec_com_aw_value/currency'] <- 'rec_com_aw_vcurr'
names(df4)[names(df4) == 'rec_com_aw_contractPeriod/endDate'] <- 'rec_com_aw_ca_endDate'
names(df4)[names(df4) == 'rec_com_aw_contractPeriod/startDate'] <- 'rec_com_aw_ca_startDate'
names(df4)[names(df4) == 'rec_com_aw_description'] <- 'rec_com_aw_descr'

names(df4)

#some values are swapped in aw_description and start date
install.packages('dplyr')
library(dplyr)
#filter the problemtaic rows in a separate data frame
aw_descr <- filter(df4, grepl("*:00Z",df4$rec_com_aw_descr))
aw_descr$rec_com_aw_descr_copy <- aw_descr$rec_com_aw_descr

aw_descr$rec_com_aw_descr <- aw_descr$rec_com_aw_ca_startDate
aw_descr$rec_com_aw_ca_startDate <- aw_descr$rec_com_aw_descr_copy
aw_descr$rec_com_aw_descr_copy <- NULL

#replace the original file with the corrected data by rec_Com_aw_id
df4$rec_com_aw_descr[match(aw_descr$rec_com_aw_id, df4$rec_com_aw_id)] <- aw_descr$rec_com_aw_descr
df4$rec_com_aw_ca_startDate[match(aw_descr$rec_com_aw_id, df4$rec_com_aw_id)] <- aw_descr$rec_com_aw_ca_startDate
#looks fine

#check and set types of variables 
sapply(df4, class)

#convert to date type
df4$rec_com_aw_ca_startDate <- gsub(df4$rec_com_aw_ca_startDate, pattern = "T.*", replacement = "")
df4$rec_com_aw_ca_startDate <- as.Date(df4$rec_com_aw_ca_startDate)

df4$rec_com_aw_ca_endDate <- as.Date(df4$rec_com_aw_ca_endDate, tz = "UTC", "%Y-%m-%d")

#missing values
sapply(df4, function(df4) sum(is.na(df4)))
#only a few missing values in award description

mean(is.na(df4$rec_com_aw_descr))
#18.5%


#remove contract period start date if it is later than end date
df4$rec_com_aw_ca_startDate[df4$rec_com_aw_ca_startDate > df4$rec_com_aw_ca_endDate] <- NA
sum(is.na(df4$rec_com_aw_ca_startDate))
mean(is.na(df4$rec_com_aw_ca_startDate))
###too many outliers (2000), probably end and start date are also swapped

#remove outliers in awards amount
summary(df4$rec_com_aw_vamount)
df4$rec_com_aw_vamount[df4$rec_com_aw_vamount < 6700] <- NA
df4$rec_com_aw_vamount[df4$rec_com_aw_vamount > 222600000000] <- NA
sum(is.na(df4$rec_com_aw_vamount))
#106 values
mean(is.na(df4$rec_com_aw_vamount))
#3.4%

#unique variables
length(unique(df4$rec_com_id))
#15% duplicates

length(unique(df4$rec_com_aw_id))
#unique

#save file
write.csv(df4, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_awards_raw.csv", row.names = FALSE)

######################################

#rec_com_con_amendments.csv

#this file contains a column with big numbers (rec_com_ca_id), to read it correctly, colClass should be defined as char 
df5 <- read.csv("C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_amendments.csv", header = TRUE, sep=",", colClasses = 'character')

#basic information on the database
class(df5)
dim(df5)

#rename variables
names(df5) <- gsub(x = names(df5), pattern = "records.0.compiledRelease.contracts.0.", replacement = "rec_com_ca_")
names(df5) <- gsub(x = names(df5), pattern = "records.0.compiledRelease.", replacement = "rec_com_")
names(df5) <- gsub(x = names(df5), pattern = "amendments.0.", replacement = "am_")
names(df5)

#set type of var 
df5$rec_com_ca_am_date <- gsub(df5$rec_com_ca_am_date, pattern = "T.*", replacement = "")
df5$rec_com_ca_am_date <- as.Date(df5$rec_com_ca_am_date)

#missing values (id, ca_id, ca_id, ca_am_id, ca_am_date)
sapply(df5, function(df5) sum(is.na(df5)))
#no missing values

#unique ids
length(unique(df5$rec_com_id))
#50% duplicates

length(unique(df5$rec_com_ca_id))
#unique

#save file
write.csv(df5, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_amendments_raw.csv", row.names = FALSE)

######################################

#rec_com_con_buyers.csv
df6 <- read.csv("C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_buyers.csv", header = TRUE, sep=",", colClasses = 'character')

#basic information on the database
class(df6)
dim(df6)

#rename variables
names(df6) <- gsub(x = names(df6), pattern = "records.0.compiledRelease.contracts.0.", replacement = "rec_com_ca_")
names(df6) <- gsub(x = names(df6), pattern = "records.0.compiledRelease.", replacement = "rec_com_")
names(df6) <- gsub(x = names(df6), pattern = "buyers.0.", replacement = "buyer_")
names(df6)

#missing values (all)
sapply(df6, function(df6) sum(is.na(df6)))
#no missing values

#unique id
length(unique(df6$rec_com_id))
#57% duplicates

length(unique(df6$rec_com_ca_id))
#15% duplicates

df6[!duplicated(df6), ]

#save file
write.csv(df6, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_buyers_raw.csv", row.names = FALSE)
#########################

#rec_com_con_suppliers.csv
df7 <- read.csv("C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_suppliers.csv", header = TRUE, sep=",", colClasses = 'character')

#basic information on the database
class(df7)
dim(df7)

#rename variables
names(df7) <- gsub(x = names(df7), pattern = "records.0.compiledRelease.contracts.0.", replacement = "rec_com_ca_")
names(df7) <- gsub(x = names(df7), pattern = "records.0.compiledRelease.", replacement = "rec_com_")
names(df7) <- gsub(x = names(df7), pattern = "suppliers.0.", replacement = "sup_")
names(df7)


#missing values
sapply(df7, function(df7) sum(is.na(df7)))
#no missing values

#unique ids
length(unique(df7$rec_com_id))
#50% duplicates

length(unique(df7$rec_com_ca_id))
#unique

#save file
write.csv(df7, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_suppliers_raw.csv", row.names = FALSE)

###########################

#rec_com_contracts.csv
df8 <- read_csv('rec_com_contracts.csv')
view(df8)

#basic information on the database 
class(df8)
dim(df8)
str(df8)

#rename variables
names(df8) <- gsub(x = names(df8), pattern = "records/0/compiledRelease/contracts/0/", replacement = "rec_com_ca_")
names(df8) <- gsub(x = names(df8), pattern = "/", replacement = "_")
names(df8) <- gsub(x = names(df8), pattern = "value_", replacement = "v")
names(df8) <- gsub(x = names(df8), pattern = "period_", replacement = "")
names(df8) <- gsub(x = names(df8), pattern = "awardID", replacement = "aw_id")
names(df8) <- gsub(x = names(df8), pattern = "durationInDays", replacement = "durInDays")
names(df8) <- gsub(x = names(df8), pattern = "contractDetails_", replacement = "")
names(df8) <- gsub(x = names(df8), pattern = "suppliers", replacement = "sup")
names(df8) <- gsub(x = names(df8), pattern = "currency", replacement = "curr")
names(df8) <- gsub(x = names(df8), pattern = "description", replacement = "descr")
names(df8) <- gsub(x = names(df8), pattern = "contractType", replacement = "caType")

names(df8)[names(df8) == 'records_0_compiledRelease_id'] <- 'rec_com_id'
names(df8)

#drop unnecessary variables
df8$rec_com_ca_multiyear <- NULL                               
df8$rec_com_ca_priceScheme <- NULL
df8$rec_com_ca_originalCurrencyv_amount_$numberLong <- NULL 
#if this does not work:
df8 <- df8[,-c(20)]
df8$rec_com_ca_numberOfMonths <- NULL                          
df8$rec_com_ca_fiscalYearValue_amount <- NULL                  
df8$rec_com_ca_fiscalYearvcurr <- NULL
df8$rec_com_ca_fiscalYearValue_curr <- NULL

#check type of variables
sapply(df8, class)

#change variable types
df8$rec_com_ca_id <- as.character(df8$rec_com_ca_id)
df8$rec_com_ca_startDate <- as.Date(df8$rec_com_ca_startDate, tz = "UTC","%Y-%m-%d")
df8$rec_com_ca_endDate <- as.Date(df8$rec_com_ca_endDate, tz = "UTC", "%Y-%m-%d")
df8$rec_com_ca_dateSigned <- as.Date(df8$rec_com_ca_dateSigned, tz = "UTC", "%Y-%m-%d")
df8$rec_com_ca_vamount <- as.numeric(df8$rec_com_ca_vamount)
#check missing values
sapply(df8, function(df8) sum(is.na(df8)))

#fill up contract value amounts
identical(df8[['df8$rec_com_ca_vamount']],df8[['df8$rec_com_ca_minvamount']])
identical(df8[['df8$rec_com_ca_vamount']],df8[['df8$rec_com_ca_maxvamount']])
#fill up contract value from min or max values as they are identical
df8$rec_com_ca_vamount1 <- df8$rec_com_ca_vamount

df8$rec_com_ca_vamount1[is.na(df8$rec_com_ca_vamount1)] <- df8$rec_com_ca_maxValue_amount[is.na(df8$rec_com_ca_vamount1)]
check_amount <- data.frame("var1" = df8$rec_com_ca_maxValue_amount, "var2" = df8$rec_com_ca_vamount1)
sum(is.na(df8$rec_com_ca_vamount1))
#bit better

df8$rec_com_ca_vamount <- df8$rec_com_ca_vamount1
df8$rec_com_ca_vamount1 <- NULL

#check missing values after cleaning
sapply(df8, function(df8) sum(is.na(df8)))


mean(is.na(df8$rec_com_ca_vamount))
#26%
mean(is.na(df8$rec_com_ca_startDate))
#42%
mean(is.na(df8$rec_com_ca_endDate))
#42%
mean(is.na(df8$rec_com_ca_status))
#89% -> drop
mean(is.na(df8$rec_com_ca_aw_id))
#42%
mean(is.na(df8$rec_com_ca_dateSigned))
#48.6%
mean(is.na(df8$rec_com_ca_durInDays))
#52.4%
mean(is.na(df8$rec_com_ca_caType))
#36.7% 
mean(is.na(df8$rec_com_ca_sup))
#84.2% - drop

df8$rec_com_ca_valueWithTax_amount <- NULL
df8$rec_com_ca_maxvamount <- NULL
df8$rec_com_ca_minvamount <- NULL
df8$rec_com_ca_originalCurrencyvexchangeRate <- NULL
df8$rec_com_ca_valueWithTax_curr <- NULL
df8$rec_com_ca_maxvcurr <- NULL
df8$rec_com_ca_minvcurr <- NULL
df8$rec_com_ca_originalCurrencyvamount <- NULL
df8$rec_com_ca_sup <- NULL


#remove contract period start date if it is later than end date
df8$rec_com_ca_startDate[df8$rec_com_ca_startDate > df8$rec_com_ca_endDate] <- NA
sum(is.na(df8$rec_com_ca_startDate))
mean(is.na(df8$rec_com_ca_startDate))
#42%

#remove outliers in contract value amount
df8$rec_com_ca_vamount[df8$rec_com_ca_vamount < 6700] <- NA
df8$rec_com_ca_vamount[df8$rec_com_ca_vamount > 222600000000] <- NA
sum(is.na(df8$rec_com_ca_vamount))
#4652
mean(is.na(df8$rec_com_ca_vamount))
#55.5% -> double

#unique ids
length(unique(df8$rec_com_id))
#20% duplicates

length(unique(df8$rec_com_ca_id))
#unique

#save file
write.csv(df8, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_contract_raw.csv", row.names = FALSE)

#########################

#rec_com_ten_tenderers.csv
df9 <- read_csv('rec_com_ten_tenderers.csv')

#basic information on the database
class(df9)
dim(df9)
str(df9)

#rename variables
names(df9) <- gsub(x = names(df9), pattern = "records/0/compiledRelease/tender/tenderers/0/", replacement = "rec_com_ten_tenderers_")
names(df9) <- gsub(x = names(df9), pattern = "records/0/compiledRelease/tender/", replacement = "rec_com_ten_")

names(df9)[names(df9) == 'records/0/compiledRelease/id'] <- 'rec_com_id'
names(df9)

#missing values
sapply(df9, function(df9) sum(is.na(df9)))
#no missing values

#check type of variables
sapply(df9, class)

#unique ids
length(unique(df9$rec_com_id))
#not unique
length(unique(df9$rec_com_ten_id))
#not unique
length(unique(df9$rec_com_ten_tenderers_id))
#not unique

#save csv file
write.csv(df9, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_ten_tenderers_raw.csv", row.names = FALSE)

##########################################
#rec_com_con_imp_bud_bud_measure.csv

df10 <- read_csv('rec_com_con_imp_bud_bud_measure.csv')

#basic information on the database
class(df10)
dim(df10)
str(df10)

#rename variables
names(df10) <- gsub(x = names(df10), pattern = "records/0/compiledRelease/contracts/0/", replacement = "rec_com_ca_")
names(df10) <- gsub(x = names(df10), pattern = "implementation/budgetBreakdown/0/", replacement = "imp_")
names(df10) <- gsub(x = names(df10), pattern = "budgetClassification/0/", replacement = "bclass_")
names(df10) <- gsub(x = names(df10), pattern = "measures/0/", replacement = "m")
names(df10) <- gsub(x = names(df10), pattern = "value/", replacement = "v")
names(df10) <- gsub(x = names(df10), pattern = "currency", replacement = "curr")

names(df10)[names(df10) == 'records/0/compiledRelease/id'] <- 'rec_com_id'
names(df10)

#missing values
sapply(df10, function(df10) sum(is.na(df10)))
#no missing values

length(which(df10$rec_com_ca_imp_bclass_mvamount == 0))
#5828

#check variable types
sapply(df10, class)

df10$rec_com_ca_id <- as.character(df10$rec_com_ca_id)

#remove outliers in contract value amount
df10$rec_com_ca_imp_bclass_mvamount[df10$rec_com_ca_imp_bclass_mvamount < 6700] <- NA
df10$rec_com_ca_imp_bclass_mvamount[df10$rec_com_ca_imp_bclass_mvamount > 222600000000] <- NA
sum(is.na(df10$rec_com_ca_imp_bclass_mvamount))
#23096
mean(is.na(df10$rec_com_ca_imp_bclass_mvamount))
#31%

#unique ids
length(unique(df10$rec_com_id))
#not unique
length(unique(df10$rec_com_ca_id))
#not unique

#remove completely duplicated rows
df10 <- df10[!duplicated(df10),]
####many rows are almost completely duplicated, only implementation measure id is different


#save csv file
write.csv(df10, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_con_imp_bud_bud_measure_raw.csv", row.names = FALSE)
#############################
#rec_com_pla_bud_bud_bud_Measure.csv

df11 <- read_csv('rec_com_pla_bud_bud_bud_Measure.csv')

#basic information on the database
class(df11)
dim(df11)
str(df11)

#rename variables
names(df11) <- gsub(x = names(df11), pattern = "records/0/compiledRelease/planning/", replacement = "rec_com_plan_")
names(df11) <- gsub(x = names(df11), pattern = "budget/budgetBreakdown/0/", replacement = "budg_")
names(df11) <- gsub(x = names(df11), pattern = "budgetclassifications/0/", replacement = "bclass_")
names(df11) <- gsub(x = names(df11), pattern = "Measures/0/", replacement = "m")
names(df11) <- gsub(x = names(df11), pattern = "value/", replacement = "v")
names(df11) <- gsub(x = names(df11), pattern = "currency", replacement = "curr")

names(df11)[names(df11) == 'records/0/compiledRelease/id'] <- 'rec_com_id'
names(df11)

#missing values
sapply(df11, function(df11) sum(is.na(df11)))
#no missing values

length(which(df11$rec_com_plan_budg_bclass_mvamount == 0))
#7373

#check variable types
sapply(df11, class)

df11$rec_com_plan_budg_bclass_mvamount <- as.numeric(df11$rec_com_plan_budg_bclass_mvamount)

#remove outliers in contract value amount
df11$rec_com_plan_budg_bclass_mvamount[df11$rec_com_plan_budg_bclass_mvamount < 6700] <- NA
df11$rec_com_plan_budg_bclass_mvamount[df11$rec_com_plan_budg_bclass_mvamount > 222600000000] <- NA
sum(is.na(df11$rec_com_plan_budg_bclass_mvamount))
#7443 (mostly 0)
mean(is.na(df11$rec_com_plan_budg_bclass_mvamount))
#74%

#unique ids
length(unique(df11$rec_com_id))
#not unique
length(unique(df11$rec_com_plan_budg_bclass_id))
#no unique id found

#remove completely duplicated rows
df11 <- df11[!duplicated(df11),]
####many rows are almost completely duplicated, only planning classification id is different


#save csv file
write.csv(df11, file = "C:/Users/Bertold/Downloads/only-raw-flattened/result/rec_com_pla_bud_bud_bud_Measure_raw.csv", row.names = FALSE)



###########################MERGE OCDS files###################

#set directory
setwd("C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/")
getwd()

#checking current memory limit
memory.limit()
#setting a bigger one
memory.limit(20000)

install.packages('readr')
library(readr)

#rec_com_awa_suppliers
df1 <- read_csv('rec_com_awa_suppliers_raw.csv')
#rec_com_awards_raw
df2 <- read_csv('rec_com_awards_raw.csv')

df_ocds_aw <- merge(df1, df2, by = c("rec_com_aw_id", "rec_com_id"), all = TRUE)


#save csv file
write.csv(df_ocds_aw, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/df_ocds_aw.csv", row.names = FALSE)

##########################

#merge contract related subfiles (rec_com_con_amendment, rec_com_con_suppliers, rec_com_contracts)

#rec_com_con_amendments_raw
df3 <- read_csv('rec_com_con_amendments_raw.csv')
#rec_com_con_suppliers_raw
df4 <- read_csv('rec_com_con_suppliers_raw.csv')
#rec_com_contract_raw
df5 <- read_csv('rec_com_contract_raw.csv')

view(df3)
View(df4)
View(df5)

#check type of variables
sapply(df5, class)
sapply(df4, class)
sapply(df3, class)

#change id types
df5$rec_com_ca_id <- as.character(df5$rec_com_ca_id)
df4$rec_com_ca_id <- as.character(df4$rec_com_ca_id)
df3$rec_com_ca_id <- as.character(df3$rec_com_ca_id)

sapply(df3, function(df3) sum(is.na(df3)))
sapply(df4, function(df4) sum(is.na(df4)))
sapply(df5, function(df5) sum(is.na(df5)))


#drop unnecessary variables
df5$rec_com_ca_maxValue_amount <- NULL
df5$rec_com_ca_minValue_amount <- NULL

#remove special characters from df4
sum(is.na(df4$rec_com_ca_sup_name))
#it says 0 but there are cells with only '---'
df4$rec_com_ca_sup_name1 <- df4$rec_com_ca_sup_name
df4$rec_com_ca_sup_name1 <- gsub('[[:punct:]]', "", df4$rec_com_ca_sup_name1)
length(which(df4$rec_com_ca_sup_name1==""))
#10
df4$rec_com_ca_sup_name1 <- ifelse(df4$rec_com_ca_sup_name1=="", NA, df4$rec_com_ca_sup_name1) 
sum(is.na(df4$rec_com_ca_sup_name1))
#10
df4$rec_com_ca_sup_name <- df4$rec_com_ca_sup_name1

df4$rec_com_ca_sup_name1 <- NULL



#some values are swapped in df5
table(df5$rec_com_ca_vcurr)
#vcurr and ca_status contain date values as well, it is inconsistent, cannot be selected to start and end date
#ignore them, change it NA

length(which(df5$rec_com_ca_status == "active"))   #38845
length(which(df5$rec_com_ca_status == "terminated"))  #208678

length(which(df5$rec_com_ca_vcurr == "MXN")) #245081

df5$rec_com_ca_vcurr1 <- df5$rec_com_ca_vcurr
df5$rec_com_ca_vcurr1[grepl("*:00Z*", df5$rec_com_ca_vcurr1)] <- NA
df5$rec_com_ca_vcurr <- df5$rec_com_ca_vcurr1
table(df5$rec_com_ca_vcurr)
sum(is.na(df5$rec_com_ca_vcurr1))
df5$rec_com_ca_vcurr1 <- NULL

df5$rec_com_ca_status1 <- df5$rec_com_ca_status
df5$rec_com_ca_status1[grepl("*:00Z*", df5$rec_com_ca_status1)] <- NA
df5$rec_com_ca_status <- df5$rec_com_ca_status1
table(df5$rec_com_ca_status)
sum(is.na(df5$rec_com_ca_status))
df5$rec_com_ca_status1 <- NULL
#around 14822 problematic rows

table(df5$rec_com_ca_caType)
#contains amount values

install.packages('dplyr')
library(dplyr)

#Values cannot be swapped, change those values to NA
length(which(df5$rec_com_ca_caType == "Abierto"))  #11552
length(which(df5$rec_com_ca_caType == "Cerrado"))  #33775
df5$rec_com_ca_caType[df5$rec_com_ca_caType == "Abierto"] <- "open"
df5$rec_com_ca_caType[df5$rec_com_ca_caType == "Cerrado"] <- "closed"

df5$rec_com_ca_caType[df5$rec_com_ca_caType == "No aplica"] <- NA

df5$rec_com_ca_caType <- ifelse(df5$rec_com_ca_caType != "open" & df5$rec_com_ca_caType != "closed", NA, df5$rec_com_ca_caType) 

sum(is.na(df5$rec_com_ca_caType)) #217018
mean(is.na(df5$rec_com_ca_caType))  #83%


#check for outliers
df5$rec_com_ca_vamount[df5$rec_com_ca_vamount < 6700] <- NA
df5$rec_com_ca_vamount[df5$rec_com_ca_vamount > 222600000000] <- NA
sum(is.na(df5$rec_com_ca_vamount))
#34581
mean(is.na(df5$rec_com_ca_vamount))
#13%

write.csv(df3, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/rec_com_con_amendments_raw.csv", row.names = FALSE)
write.csv(df4, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/rec_com_con_suppliers_raw.csv", row.names = FALSE)
write.csv(df5, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/rec_com_contract_raw.csv", row.names = FALSE)


#merge files by rec_com_ca_id and rec_com_id

df34 <- merge(df3, df4, by = c("rec_com_ca_id", "rec_com_id") , all = TRUE)
df345 <- merge(df34, df5, by = c("rec_com_ca_id", "rec_com_id"), all = TRUE)


View(df345)

#check structure
str(df345)

#check if all variables are there
names(df345)
sapply(df345, function(df345) sum(is.na(df345)))
#missings are aligned with the subfiles missing rates and that the subfiles do not contain the same variables

#save csv file
write.csv(df345, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/df_ocds_ca.csv", row.names = FALSE)
write.csv(df345, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/df_ocds_ca345.csv", row.names = FALSE)

####################

#merge df_ocds_aw and df_ocds_ca

#set directory
setwd("C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/")
getwd()

#check if it is possible to merge ocds contract and awards file 
df_ocds_aw <- read_csv('df_ocds_aw.csv')
df_ocds_ca <- read_csv('df_ocds_ca345.csv', col_types = cols(rec_com_ca_id = col_character()))
view(df_ocds_aw)


#before merging, check if the aw_id variables have matches
df_ocds_aw$rec_com_aw_id %in% df_ocds_ca$rec_com_ca_aw_id
#yes, there are some overlaps 

sapply(df_ocds_ca, function(df_ocds_ca) sum(is.na(df_ocds_ca)))
sapply(df_ocds_aw, function(df_ocds_aw) sum(is.na(df_ocds_aw)))

#check if aw_id is unique
length(unique(df_ocds_ca$rec_com_ca_id))
#unique
length(unique(df_ocds_ca$rec_com_ca_aw_id))
#unique
length(unique(df_ocds_aw$rec_com_aw_id))
#unique

#rename aw_id variable so the two dataframes have the same column name
df_ocds_ca$rec_com_aw_id <- df_ocds_ca$rec_com_ca_aw_id
df_ocds_ca$rec_com_ca_aw_id <- NULL

#merge files by aw_id and rec_com_id
df_ocds_awca <- merge(df_ocds_ca, df_ocds_aw, by = c("rec_com_aw_id", "rec_com_id"), all = TRUE)

sapply(df_ocds_awca, function(df_ocds_awca) sum(is.na(df_ocds_awca)))


#R filled up missing rec_com_aw_id with row order numbers
identical(df_ocds_awca[['df_ocds_awca$rec_com_aw_id']],df_ocds_aw[['df_ocds_aw$rec_com_aw_id']])

df_ocds_awca$rec_com_aw_id_copy <- df_ocds_awca$rec_com_aw_id
df_ocds_aw$rec_com_aw_id_length <- nchar(df_ocds_aw$rec_com_aw_id)

df5$rec_com_ca_vcurr1[grepl("*:00Z*", df5$rec_com_ca_vcurr1)] <- NA
df4$rec_com_ca_sup_name1 <- ifelse(df4$rec_com_ca_sup_name1=="", NA, df4$rec_com_ca_sup_name1) 


df_ocds_awca$rec_com_aw_id_copy_length <- nchar(df_ocds_awca$rec_com_aw_id)
table(df_ocds_aw$rec_com_aw_id_length)
df_ocds_awca$rec_com_aw_id_copy[df_ocds_awca$rec_com_aw_id_copy_length != 7 & df_ocds_awca$rec_com_aw_id_copy_length != 6] <- NA

sum(is.na(df_ocds_awca$rec_com_aw_id))
df_ocds_awca$rec_com_aw_id_copy <- as.numeric(df_ocds_awca$rec_com_aw_id_copy)
df_ocds_awca$rec_com_aw_id_copy[df_ocds_awca$rec_com_aw_id_copy < 0] <- NA 
df_ocds_awca$rec_com_aw_id_copy <- as.character(df_ocds_awca$rec_com_aw_id_copy)
df_ocds_awca$rec_com_aw_id <- df_ocds_awca$rec_com_aw_id_copy
df_ocds_awca$rec_com_aw_id_copy <- NULL

sapply(df_ocds_awca, class)
df_ocds_awca$rec_com_aw_id <- as.character(df_ocds_awca$rec_com_aw_id)

sapply(df_ocds_awca, function(df_ocds_awca) sum(is.na(df_ocds_awca)))

mean(is.na(df_ocds_awca$rec_com_aw_id))
#25%
mean(is.na(df_ocds_awca$rec_com_id))
#0
mean(is.na(df_ocds_awca$rec_com_ca_id))
#0.7%
mean(is.na(df_ocds_awca$rec_com_ca_am_id))
#98%
mean(is.na(df_ocds_awca$rec_com_ca_am_date))
#98%
mean(is.na(df_ocds_awca$rec_com_ca_sup_id))
#75%
mean(is.na(df_ocds_awca$rec_com_ca_sup_name))
#76%
mean(is.na(df_ocds_awca$rec_com_ca_title))
#28%
mean(is.na(df_ocds_awca$rec_com_ca_vamount))
#38%
mean(is.na(df_ocds_awca$rec_com_ca_vcurr))
#32%
mean(is.na(df_ocds_awca$rec_com_ca_startDate))
#29%
mean(is.na(df_ocds_awca$rec_com_ca_endDate))
#29%
mean(is.na(df_ocds_awca$rec_com_ca_status))
#32%
mean(is.na(df_ocds_awca$rec_com_ca_caType))
#88%
mean(is.na(df_ocds_awca$rec_com_aw_sup_id))
#29%
mean(is.na(df_ocds_awca$rec_com_aw_sup_name))
#29%
mean(is.na(df_ocds_awca$rec_com_aw_title))
#29%
mean(is.na(df_ocds_awca$rec_com_aw_vamount))
#35%
mean(is.na(df_ocds_awca$rec_com_aw_vcurr))
#29%
mean(is.na(df_ocds_awca$rec_com_aw_ca_endDate))
#29%
mean(is.na(df_ocds_awca$rec_com_aw_ca_startDate))
#40%

write.csv(df_ocds_awca, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/df_ocds_awca.csv", row.names = FALSE)


####################################MERGE ALL FILES TOGETHER FROM OCDS AND CONTRATOS##############
#merge contratos and ocds

df_contr_all <- read_csv('df_contr_all0922.csv', col_types = cols(rec_com_id = col_character()))
df_ocds_awca <- read_csv('df_ocds_awca.csv', col_types = cols(rec_com_aw_id = col_character()))

#check variable types
sapply(df_ocds_awca, class)
df_ocds_awca$rec_com_aw_ca_startDate <- as.Date(df_ocds_awca$rec_com_aw_ca_startDate)
df_ocds_awca$rec_com_aw_ca_endDate <- as.Date(df_ocds_awca$rec_com_aw_ca_endDate)

sapply(df_contr_all, class)
df_contr_all$rec_com_ten_id <- as.character(df_contr_all$rec_com_ten_id)
df_contr_all$rec_com_ca_id <- as.character(df_contr_all$rec_com_ca_id)

df_contr_all$X1 <- NULL

#check missings
sapply(df_contr_all, function(df_contr_all) sum(is.na(df_contr_all)))

sapply(df_ocds_awca, function(df_ocds_awca) sum(is.na(df_ocds_awca)))

length(unique(df_contr_all$rec_com_ca_id))
length(unique(df_ocds_awca$rec_com_ca_id))

#adding to contratos only non-overlapping variables from ocds

#keep only non-overlapping variables
df_ocds_sel <- df_ocds[c("rec_com_ca_id", "rec_com_aw_id", "rec_com_ca_caType", "rec_com_aw_vamount", "rec_com_aw_vcurr")]

#merge with Contratos
df_contr_ocds_sel <- merge(df_contr, df_ocds_sel, by = c("rec_com_ca_id"), all.x = TRUE)

sapply(df_contr_ocds_sel, function(df_contr_ocds_sel) sum(is.na(df_contr_ocds_sel)))
mean(is.na(df_contr_ocds_sel$rec_com_ten_id))
#0%
mean(is.na(df_contr_ocds_sel$rec_com_ten_startDate))
#32.7%
mean(is.na(df_contr_ocds_sel$rec_com_ten_endDate))
#24.3%
mean(is.na(df_contr_ocds_sel$rec_com_aw_sup_id))
#70.6%
mean(is.na(df_contr_ocds_sel$rec_com_aw_sup_name))
#almost 0%
mean(is.na(df_contr_ocds_sel$rec_com_ca_id))
#1.8%
mean(is.na(df_contr_ocds_sel$rec_com_aw_id))
#81%
mean(is.na(df_contr_ocds_sel$rec_com_ca_status))
#1.85%
mean(is.na(df_contr_ocds_sel$rec_com_ca_endDate))
#1.85%
mean(is.na(df_contr_ocds_sel$rec_com_ca_caType))
#97%
mean(is.na(df_contr_ocds_sel$rec_com_aw_vamount))
#83.3%
mean(is.na(df_contr_ocds_sel$rec_com_ca_vamount))
#4.6%
mean(is.na(df_contr_ocds_sel$rec_com_ten_procMethod))
#1.8%


mean(is.na(df_contr_ocds_sel$rec_com_ca_buyer_id))
mean(is.na(df_contr_ocds_sel$rec_com_ca_buyer_name))
mean(is.na(df_contr_ocds_sel$rec_com_ten_procCat))
mean(is.na(df_contr_ocds_sel$rec_com_id))
mean(is.na(df_contr_ocds_sel$rec_com_ca_startDate))
mean(is.na(df_contr_ocds_sel$rec_com_ca_dateSigned))


#check if values are correct
table(df_contr_ocds_sel$rec_com_ca_vcurr)
df_contr_ocds_sel$rec_com_ca_vcurr_length <- nchar(df_contr_ocds$rec_com_ca_vcurr)

df_contr_ocds_sel$rec_com_ca_vcurr[df_contr_ocds_sel$rec_com_ca_vcurr_length > 3 ] <- NA
mean(is.na(df_contr_ocds_sel$rec_com_ca_vcurr))
#6.7%

table(df_contr_ocds_sel$rec_com_ca_status)
#ok
table(df_contr_ocds_sel$rec_com_ca_caType)
#ok
table(df_contr_ocds_sel$rec_com_ten_procMethod)
#ok
table(df_contr_ocds_sel$rec_com_ten_procCat)
#ok


summary(df_contr_ocds_sel$rec_com_aw_vamount)
#ok

#save file
write.csv(df_contr_ocds_sel, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/df_contr_ocds_sel.csv", row.names = FALSE)


###############################

#adding number of tenderers

library(dplyr)
tend_count <- rec_com_ten_tenderers %>%
  group_by(rec_com_ten_id) %>%
  mutate(count = n_distinct(rec_com_ten_tenderers_id))

write.csv(tend_count, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/tend_count.csv", row.names = FALSE)

tend_count1 <- tend_count
tend_count1 <- tend_count[c("rec_com_ten_id", "count")]
tend_count1 <- tend_count1[!duplicated(tend_count1),]

#add this information to the combined file
df_contr_ocds_ten <- merge(df_contr_ocds_sel, tend_count1, by = "rec_com_ten_id", all.x = T)
length(which(!is.na(df_contr_ocds_ten$count)))
summary(df_contr_ocds_ten$count)

df_contr_ocds_ten$rec_com_ten_nrOfTenderers <- df_contr_ocds_ten$count
df_contr_ocds_ten$count <- NULL

#save file
write.csv(df_contr_ocds_ten, file = "C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/df_contr_ocds_ten.csv", row.names = FALSE)
