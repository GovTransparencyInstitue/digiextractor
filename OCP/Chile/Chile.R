#Chile

#set new directory for selected files to merge
setwd("C:/Users/Bertold/Downloads/2018-09-20-chile")
getwd()

#setting a bigger memory
memory.limit(30000)

install.packages('readr')
library(readr)

df_chile <- read_csv('2018-09-20-chile.csv')

#alternatively with Latin-1 encoding
df_chile <- read.csv("C:/Users/Bertold/Downloads/2018-09-20-chile/2018-09-20-chile.csv", header = TRUE, sep = ",", encoding = "Latin-1")


#check missings
sapply(df_chile, function(df_chile) sum(is.na(df_chile)))
#most of the variables are irrelevant and are completely miising, remove them

#remove columns with no or almost 0 values (missing rate is 80% or higher) 
df_chile <- df_chile[, colSums(is.na(df_chile)) != nrow(df_chile)]
df_chile <- df_chile[colSums(is.na(df_chile))/nrow(df_chile) < .8]
names(df_chile)

#remove additional unnecessary variables
df_chile <- df_chile[,-c(4,29,30,35,36,37,38,39,40,41,42)]
df_chile2018$tender_documents_count <- NULL

#check missing values
sapply(df_chile, function(df_chile) sum(is.na(df_chile)))

#check years distribution
table(year)
#mainly from 2018

#subset a sample with tenders from 2018
install.packages('dplyr')
library(dplyr)

df_chile2018 <- filter(df_chile, df_chile$tender_year == "2018")
#185285 observations

#replace 0 values with NA
df_chile2018[df_chile2018 == 0] <- NA

#check types of variables
sapply(df_chile2018, class)
#mostly ok, change prices to numeric

df_chile2018$tender_estimatedprice <- as.numeric(df_chile2018$tender_estimatedprice)
df_chile2018$lot_estimatedprice <- as.numeric(df_chile2018$lot_estimatedprice)
df_chile2018$tender_finalprice <- as.numeric(df_chile2018$tender_finalprice)
df_chile2018$bid_price <- as.numeric(df_chile2018$bid_price)

#rename variables to OCDS
library(data.table)
setnames(df_chile2018, old = c('tender_id','tender_title', 'tender_proceduretype', 'tender_lotscount', 'tender_recordedbidscount', 'tender_cpvs', 'tender_maincpv', 'tender_awardcriteria_count','tender_estimatedprice','tender_finalprice','lot_estimatedprice','bid_price','tender_corrections_count','lot_title','buyer_id','buyer_masterid','buyer_name','buyer_email','buyer_contactname','buyer_city','bidder_id','bidder_masterid','bidder_name','bid_iswinning','award_count','notice_count','tender_publications_firstdcontractawarddate','tender_year','savings','tender_description_length','currency','ID','ca_id'), new = c('ten_id', 'ten_title','ten_procMethod','ten_item_quantity','ten_bids','ten_item_class_id','dropcpv','ten_aw_crit_count', 'ten_plan_vamount', 'ten_vamount', 'ten_item_plan_vamount', 'ten_item_unit_vamount', 'ten_am_count', 'ten_item_descr', 'buyer_id', 'buyer_addid', 'buyer_name', 'dropemail', 'dropconname', 'buyer_add_city', 'ten_tenderers_id', 'ten_tenderers_addid', 'ten_tenderers_name', 'aw_status', 'aw_count', 'notice_count', 'aw_date', 'ten_year', 'savings', 'ten_descr_length', 'ten_vcurr', 'ID', 'ca_id'))
names(df_chile2018)

#drop unnecessary variables
df_chile2018$dropcpv <- NULL
df_chile2018$dropemail <- NULL
df_chile2018$dropconname <- NULL


#check missing values
sapply(df_chile2018, function(df_chile2018) sum(is.na(df_chile2018)))

mean(is.na(df_chile2018$ten_procMethod))
#0.4%
mean(is.na(df_chile2018$ten_plan_vamount))
#17%
mean(is.na(df_chile2018$ten_item_unit_vamount))
#77%
mean(is.na(df_chile2018$ten_tenderers_id))
#4.3%
mean(is.na(df_chile2018$aw_status))
#4.3%
mean(is.na(df_chile2018$aw_date))
#3.4%
mean(is.na(df_chile2018$ten_id))
#0%
mean(is.na(df_chile2018$buyer_id))
#0.4%
mean(is.na(df_chile2018$ten_tenderers_name))
#4.3%
mean(is.na(df_chile2018$buyer_name))
#0.4%
mean(is.na(df_chile2018$ten_vamount))
#17%


#winners
table(df_chile2018$bid_iswinning)
#bid_iswinning supposed to show the winner tenders but it is unreliable in this case, it is not filled correctly
#use bid_price instead that is the final value amount of the awarded contracts
#although it has a high missing rate, it is still the best alternative to define winners

df_chile2018$winner <- ifelse(!is.na(df_chile2018$ten_item_unit_vamount), "winner", NA)
sum(is.na(df_chile2018$winner))
#only 23% are winners

#tenders
length(unique(df_chile2018$ten_id))
#16197 unique tenders
length(unique(df_chile2018$ten_tenderers_id))
#only 9695 unique bidders

#unique variable
length(unique(df_chile2018$ca_id))
#unique

#generate unique id for contracts
df_chile2018$ID <- rownames(df_chile2018)
df_chile2018$ten_id1 <- df_chile2018$ten_id

df_chile2018$ca_id <- make.unique(as.character(df_chile2018$ten_id1), sep = "_")
length(unique(df_chile2018$ca_id))

df_chile2018$ten_id1 <- NULL


#remove outliers from bid price
df_chile2018$ten_vamount[df_chile2018$ten_vamount < 237836] <- NA
df_chile2018$ten_vamount[df_chile2018$ten_vamount > 7923065708812] <- NA
sum(is.na(df_chile2018$ten_vamount))
#40466
mean(is.na(df_chile2018$ten_vamount))
#22%

#tender_proceduretype
table(df_chile2018$ten_procMethod)
#mostly open

#save file
write.csv(df_chile2018, file = "df_chile2018.csv")
