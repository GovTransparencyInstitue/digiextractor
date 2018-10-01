#Chile

#set new directory for selected files to merge
setwd("C:/Users/Bertold/Downloads/2018-09-20-chile")
getwd()

#setting a bigger memory
memory.limit(30000)

install.packages('readr')
library(readr)

df_chile <- read_csv('2018-09-20-chile.csv')


#check missings
sapply(df_chile, function(df_chile) sum(is.na(df_chile)))
#most of the variables are irrelevant and are completely miising, remove them

#remove columns with no or almost 0 values (missing rate is 80% or higher) 
df_chile <- df_chile[, colSums(is.na(df_chile)) != nrow(df_chile)]
df_chile <- df_chile[colSums(is.na(df_chile))/nrow(df_chile) < .8]
names(df_chile)

#remove additional unnecessary variables
df_chile <- df_chile[,-c(4,29,30,35,36,37,38,39,40,41,42)]


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

#check missing values
sapply(df_chile2018, function(df_chile2018) sum(is.na(df_chile2018)))

mean(is.na(df_chile2018$tender_proceduretype))
#0.4%
mean(is.na(df_chile2018$tender_estimatedprice))
#17%
mean(is.na(df_chile2018$bid_price))
#77%
mean(is.na(df_chile2018$bidder_id))
#4.3%
mean(is.na(df_chile2018$bid_iswinning))
#4.3%
mean(is.na(df_chile2018$tender_publications_firstdcontractawarddate))
#3.4%
mean(is.na(df_chile2018$tender_id))
#0%
mean(is.na(df_chile2018$buyer_id))
#0.4%
mean(is.na(df_chile2018$bidder_name))
#4.3%
mean(is.na(df_chile2018$buyer_name))
#0.4%
mean(is.na(df_chile2018$tender_finalprice))
#17%


#winners
table(df_chile2018$bid_iswinning)
#bid_iswinning supposed to show the winner tenders but it is unreliable in this case, it is not filled correctly
#use bid_price instead that is the final value amount of the awarded contracts
#although it has a high missing rate, it is still the best alternative to define winners

df_chile2018$winner <- ifelse(!is.na(df_chile2018$bid_price), "winner", NA)
sum(is.na(df_chile2018$winner))
#only 23% are winners

#tenders
length(unique(df_chile2018$tender_id))
#16197 unique tenders
length(unique(df_chile2018$bidder_id))
#only 9695 unique bidders

#unique variable
length(unique(df_chile2018$ca_id))
#unique

#generate unique id for contracts
df_chile2018$ID <- rownames(df_chile2018)
df_chile2018$tender_id1 <- df_chile2018$tender_id

df_chile2018$ca_id <- make.unique(as.character(df_chile2018$tender_id1), sep = "_")
length(unique(df_chile2018$ca_id))

df_chile2018$tender_id1 <- NULL
df_chile2018$tender_documents_count <- NULL

#remove outliers from bid price
df_chile2018$tender_finalprice[df_chile2018$tender_finalprice < 237836] <- NA
df_chile2018$tender_finalprice[df_chile2018$tender_finalprice > 7923065708812] <- NA
sum(is.na(df_chile2018$tender_finalprice))
#40466
mean(is.na(df_chile2018$tender_finalprice))
#22%

#tender_proceduretype
table(df_chile2018$tender_proceduretype)
#mostly open

#save file
write.csv(df_chile2018, file = "df_chile2018.csv")
