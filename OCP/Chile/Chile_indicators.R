###CHILE INDICATORS

memory.limit(50000000000)
library(dplyr)
library(ggplot2)
library(data.table)

#import data file
df_chile <- read.csv("C:/Users/info/Desktop/Nora/0612/2019-06-11-dfid-cl.csv", header = TRUE, sep = ",") 
df_title <- fread("C:/Users/info/Desktop/Nora/0612/2019-06-11-dfid-cl.csv", select = c("tender_id", "tender_title"))


#select only relevant variables, remove others so that it is easier to handle  
df_chile <- df_chile[, c("tender_id", "tender_biddeadline", "currency", "bid_iswinning", "tender_finalprice", "tender_awarddecisiondate", "tender_publications_firstdcontractawarddate","source", "tender_year", "tender_proceduretype", "tender_nationalproceduretype", "buyer_masterid", "lot_row_nr", "tender_cpvs", "bid_price", "tender_corrections_count", "buyer_name","bidder_masterid", "bidder_name", "bidder_id", "tender_recordedbidscount")]


#take empty cells as missings
df_chile[df_chile == ""] <- NA

table(df_chile$tender_year)
#observations before 2014 are outliers, remove them
df_chile <- subset(df_chile, df_chile$tender_year > 2013)


#check overall missing rates
sapply(df_chile, function(df_chile) mean(is.na(df_chile)))


#check class type of each variable
sapply(df_chile, class)

cols <- c(1,2,3,4,6,7,8,10,11,12,14,17,18,19,20)
df_chile[,cols] = lapply(df_chile[,cols], as.character)

df_chile$tender_publications_firstdcontractawarddate_orig <- df_chile$tender_publications_firstdcontractawarddate
df_chile$tender_biddeadline_orig <- df_chile$tender_biddeadline

df_chile$tender_biddeadline <- as.Date(df_chile$tender_biddeadline)
df_chile$tender_publications_firstdcontractawarddate <- as.Date(df_chile$tender_publications_firstdcontractawarddate)

#check outliers in dates
length(which(df_chile$tender_biddeadline > df_chile$tender_publications_firstdcontractawarddate))
#0

#check price variables
table(df_chile$currency)
df_chile$currency_orig <- df_chile$currency

df_chile$tender_finalprice_2 <- df_chile$tender_finalprice
df_chile$tender_finalprice_2 <- ifelse(df_chile$currency=="EUR", df_chile$tender_finalprice_2*758.585, df_chile$tender_finalprice_2)
df_chile$currency <- ifelse(df_chile$currency=="EUR", "CLP", df_chile$currency)
#only 45 obs in total, mostly from 2017: 737.863 and 2016: 746, 2018:758.585 use this average; using average FX rate from 2018

df_chile$tender_finalprice_2 <- ifelse(df_chile$currency=="USD", df_chile$tender_finalprice_2*648, df_chile$tender_finalprice_2)
df_chile$currency <- ifelse(df_chile$currency=="USD", "CLP", df_chile$currency)
#2018:648, 2017:644, 2016:673, 2015:660, 2014:573, using average FX rate from 2018

df_chile$tender_finalprice_2 <- ifelse(df_chile$currency=="USD", df_chile$tender_finalprice_2*28728, df_chile$tender_finalprice_2)
df_chile$currency <- ifelse(df_chile$currency=="CLF", "CLP", df_chile$currency)


#remove outliers from tender_finalprice (<300EUR, >10000000000EUR) 2018:758.585
#FX rate valid on 07/06/2019
length(which(df_chile$tender_finalprice_2 < 227575))
#918K obs
length(which(df_chile$tender_finalprice_2 > 7585850000000))
#119

df_chile$tender_finalprice_2 <- ifelse(df_chile$tender_finalprice_2 < 227575, NA, df_chile$tender_finalprice_2)
df_chile$tender_finalprice_2 <- ifelse(df_chile$tender_finalprice_2 > 7585850000000, NA, df_chile$tender_finalprice_2)
mean(is.na(df_chile$tender_finalprice_2))
#0.003% --> 10.6%


###generate buyer_type from buyer_name
df_chile$buyer_name <- sapply(df_chile$buyer_name, tolower)
df_chile$buyer_name <- gsub("ã³", "o", df_chile$buyer_name)
df_chile$buyer_name <- gsub("ã“", "o", df_chile$buyer_name)
df_chile$buyer_name <- gsub("ã", "i", df_chile$buyer_name)
df_chile$buyer_name <- gsub("ãº", "u", df_chile$buyer_name)

length(unique(df_chile$buyer_name))
#1642


df_chile$buyer_type <- NA

length(which(grepl("carabineros de chile", df_chile$buyer_name)))
#53K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("carabineros de chile", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("defensa civil de chile", df_chile$buyer_name)))
#36
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("defensa civil de chile", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("ministe", df_chile$buyer_name)))
#18K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("ministe", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("nacional", df_chile$buyer_name)))
#230K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("nacional", df_chile$buyer_name) & !grepl("internacional", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("secret", df_chile$buyer_name)))
#58K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("secret", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("presid", df_chile$buyer_name)))
#280
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("presid", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("comand", df_chile$buyer_name)))
#14K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("comand", df_chile$buyer_name), "national", df_chile$buyer_type)


length(which(grepl("municipal", df_chile$buyer_name)))
#4.74M
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("municipal", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("region", df_chile$buyer_name)))
#142K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("region", df_chile$buyer_name), "subnational", df_chile$buyer_type)


length(which(grepl("hospital", df_chile$buyer_name)))
#2.1M
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("hospital", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("universidad", df_chile$buyer_name)))
#161K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("universidad", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("juzgado", df_chile$buyer_name)))
#5K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("juzgado", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("provincial", df_chile$buyer_name)))
#43K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("provincial", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("tribunal", df_chile$buyer_name)))
#2K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("tribunal", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("direccion", df_chile$buyer_name)))
#352K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("direccion", df_chile$buyer_name), "national", df_chile$buyer_type)


length(which(grepl("servicio de salud", df_chile$buyer_name)))
#1.1M
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("servicio de salud", df_chile$buyer_name), "subnational", df_chile$buyer_type)
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("servicio salud", df_chile$buyer_name), "subnational", df_chile$buyer_type)


length(which(grepl("servicio", df_chile$buyer_name)))
#1.3M
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("servicio", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("instituto", df_chile$buyer_name)))
#102K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("instituto", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("gobernacion", df_chile$buyer_name)))
#13K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) &grepl("gobernacion", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("consultorio", df_chile$buyer_name)))
#23K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("consultorio", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("departamento", df_chile$buyer_name)))
#76K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("departamento", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("general de la republica", df_chile$buyer_name)))
#2K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("general de la republica", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("fuerza", df_chile$buyer_name)))
#16K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("fuerza", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("jefatura", df_chile$buyer_name)))
#7K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("jefatura", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("centro de abastecimiento", df_chile$buyer_name)))
#7K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("centro de abastecimiento", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("armada", df_chile$buyer_name)))
#11K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("armada", df_chile$buyer_name), "national", df_chile$buyer_type)

length(which(grepl("depto", df_chile$buyer_name)))
#191K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("depto", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("administracion", df_chile$buyer_name)))
#4.7K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("administracion", df_chile$buyer_name), "subnational", df_chile$buyer_type)

length(which(grepl("superintendencia", df_chile$buyer_name)))
#2K
df_chile$buyer_type <- ifelse(is.na(df_chile$buyer_type) & grepl("superintendencia", df_chile$buyer_name), "national", df_chile$buyer_type)



###generate high level product categories (G/W/S) from tender_cpvs
#using SIMAP latest list of cpv codes

#extract first 2 digits from tender_cpvs
df_chile$cl_code_l2 <- substr(df_chile$tender_cpvs, start = 1, stop = 2)
df_chile$cl_code_l2 <- as.integer(df_chile$cl_code_l2)
summary(df_chile$cl_code_l2)

df_chile$proc_category <- NA   
df_chile$proc_category <- ifelse(is.na(df_chile$proc_category) & df_chile$cl_code_l2 < 64, "goods", df_chile$proc_category)
df_chile$proc_category <- ifelse(is.na(df_chile$proc_category) & df_chile$cl_code_l2 > 60 | is.na(df_chile$proc_category) & df_chile$cl_code_l2 < 95, "services", df_chile$proc_category)
table(df_chile$proc_category)

#RENAME VARIABLES TO OCDS TERMS
library(data.table)
setnames(df_chile, old = c("tender_id", "tender_biddeadline", "currency", "bid_iswinning", "tender_finalprice", "tender_awarddecisiondate", "tender_publications_firstdcontractawarddate", "source", "tender_year", "tender_proceduretype", "tender_nationalproceduretype", "buyer_masterid", "lot_row_nr", "tender_cpvs", "bid_price", "tender_corrections_count", "buyer_name","bidder_masterid", "bidder_name", "bidder_id", "tender_recordedbidscount", "tender_publications_firstdcontractawarddate_orig", "tender_biddeadline_orig", "currency_orig", "tender_finalprice_2", "buyer_type", "cl_code_l2", "proc_category"), new = c('ten_id', 'ten_endDate','ca_curr','bid_iswinning','ca_vamount','aw_date','aw_date2','ten_url', 'ten_year', 'ten_procMethod', 'ten_procMethod_nat', 'buyer_id', 'lot_row_nr', "tender_cpvs", 'bid_price', 'ten_am_nr', 'buyer_name', 'aw_sup_id', 'aw_sup_name', 'aw_sup_id2', 'ten_nrofTenderers', 'aw_date_orig', 'ten_endDate_orig', 'ca_curr_orig', 'ca_vamount2', 'buyer_type', 'cl_code_l2', 'proc_cat'))


write.csv(df_chile, file = "C:/Users/info/Desktop/Nora/0612/chile190607.csv", row.names = FALSE)

df_chile <- read.csv("C:/Users/info/Desktop/Nora/0612/chile_winning.csv", header = TRUE, sep = ",") 
#write.csv(df_chile, file = "C:/Users/Felhasználó/Desktop/GTI/chile190607.csv", row.names = FALSE)


df_chile_all <- df_chile
df_chile <- subset(df_chile, df_chile$bid_iswinning=="t")
write.csv(df_chile, file = "C:/Users/info/Desktop/Nora/0612/chile_winning.csv", row.names = FALSE)

##################INDICATORS#####################

########### INTERNAL EFFICIENCY ########### 
#1.1 Percent of contracts which are canceled
#contract id, contract status


#there were only 285 cancelled tenders between 2014/01/01-2018/12/31 out of the 396303 published tenders on Mercado Público
#the main dataset contains awarded tenders, excludes cancelled ones, merging the two files would lead to mistakes


########### MARKET OPPORTUNITY ###########

#2.1 Mean number of tenders per supplier
#tender/id, awards/suppliers/identifier/id

ten_count <- df_chile %>%
  group_by(aw_sup_id) %>%
  summarise(t_count = uniqueN(ten_id))

hist(ten_count$t_count)
length(which(ten_count$t_count > 1500))
#56

ten_count$t_count[ten_count$t_count > 1500] <- NA
summary(ten_count$t_count)
#8.607

mean(is.na(ten_count$t_count))
#0.09%

#procurement category
t_count <- df_chile %>%
  filter(is.na(ten_id)==FALSE, is.na(aw_sup_id)==FALSE, is.na(proc_cat)==FALSE) %>%
  group_by(aw_sup_id, ten_year, proc_cat) %>%
  summarise(t_count = uniqueN(ten_id))

t_count_m <- t_count %>%
  group_by(ten_year, proc_cat) %>%
  summarise(t_mcount = mean(t_count))

ggplot(t_count_m, aes(x = ten_year, y = t_mcount, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("mean number of tenders") +
  theme(panel.grid.minor = element_blank())


#buyer_type
ten_count_bt <- df_chile %>%
  filter(is.na(ten_id)==FALSE, is.na(aw_sup_id)==FALSE, is.na(ten_year)==FALSE, is.na(buyer_type)==FALSE) %>%
  group_by(aw_sup_id, ten_year, buyer_type) %>%
  summarise(t_count_bt = uniqueN(ten_id))

ten_count_btm <- ten_count_bt %>%
  group_by(ten_year, buyer_type) %>%
  summarise(t_mcount_bt = mean(t_count_bt))


ggplot(ten_count_btm, aes(x = ten_year, y = t_mcount_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("mean number of tenders") +
  theme(panel.grid.minor = element_blank())



#buyer ID
ten_buyid <- df_chile %>% 
  filter(is.na(ten_id)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(buyer_id, aw_sup_id) %>%
  summarise(t_count_buyid = uniqueN(ten_id))

ten_buyid_btm <- ten_buyid %>%
  group_by(buyer_id) %>%
  summarise(t_mcount_b = mean(t_count_buyid))

ten_buyid_btm$t_mcount_br <- round(ten_buyid_btm$t_mcount_b, digits = 2)

ten_buyid_btm$t_mcount_br[ten_buyid_btm$t_mcount_br > 10] <- NA


awbuyid <- ten_buyid_btm %>% 
  filter(is.na(t_mcount_br)==FALSE) %>%
  group_by(t_mcount_br) %>%
  summarise(awbuyid = uniqueN(buyer_id))


ggplot(awbuyid, aes(x=t_mcount_br, y=awbuyid)) + 
  geom_bar(stat="identity", width=.01, fill="tomato3") + 
  scale_y_continuous(limits = c(0,25)) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("mean number of tenders") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


summary(ten_buyid_btm$t_mcount_br)
#1.754 ten/supp/buyer


###########################
#2.2 Mean number of supplier per buyer

#tender/procuringEntity/identifier/id OR tender/procuringEntity/name, awards/suppliers/identifier/id OR awards/suppliers/name

sup_buyer <- df_chile %>%
  group_by(buyer_id) %>%
  summarise(sup_count = uniqueN(aw_sup_id))

summary(sup_buyer$sup_count)
#141.6

mean(is.na(sup_buyer$sup_count))
#0%

sup_buyer$sup_count[sup_buyer$sup_count > 1000] <- NA


sup_buyer$sup_count <- round(sup_buyer$sup_count)

sup_buyid <- sup_buyer %>% 
  filter(is.na(sup_count)==FALSE) %>%
  group_by(sup_count) %>%
  summarise(sup_buyid = uniqueN(buyer_id))


ggplot(sup_buyid, aes(x=sup_count, y=sup_buyid)) + 
  geom_bar(stat="identity", width=.25, fill="tomato3") + 
  scale_y_continuous(limits = c(0,15)) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("mean number of suppliers") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


#procurement category
s_count_pc <- df_chile %>%
  filter(is.na(aw_sup_id)==FALSE, is.na(proc_cat)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(buyer_id, ten_year, proc_cat) %>%
  summarise(s_count = uniqueN(aw_sup_id))

scount_mpc <- s_count_pc %>%
  group_by(ten_year, proc_cat) %>%
  summarise(s_mcount = mean(s_count))

ggplot(scount_mpc, aes(x = ten_year, y = s_mcount, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("mean number of suppliers") +
  theme(panel.grid.minor = element_blank())


#buyer_type
scount_bt <- df_chile %>%
  filter(is.na(aw_sup_id)==FALSE, is.na(buyer_type)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(buyer_id, ten_year, buyer_type) %>%
  summarise(s_count_bt = uniqueN(aw_sup_id))

scount_btm <- scount_bt %>%
  group_by(ten_year, buyer_type) %>%
  summarise(smcount_bt = mean(s_count_bt))

ggplot(scount_btm, aes(x = ten_year, y = smcount_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  xlab("year") +
  ylab("mean number of suppliers") +
  theme(panel.grid.minor = element_blank())



###########################
#2.3 Percent of tenders awarded by means of competitive procedures

#tender/id, tender/procurementMethod, awards/status

comp_ten <- (length(which(df_chile$ten_procMethod == "OPEN")) / length(df_chile$ten_id))*100
#99.63%
length(which(df_chile$ten_procMethod == "OPEN"))
#1843760

df_chile$comp_procMethod <- ifelse(df_chile$ten_procMethod == "OPEN" & (!is.na(df_chile$ten_procMethod)), "competitive", "non-comp")
length(which(df_chile$comp_procMethod == "competitive"))
#1843760
mean(is.na(df_chile$comp_procMethod))
#0
comp <- (length(which(df_chile$comp_procMethod == "competitive")) / sum(!is.na(df_chile$comp_procMethod)))*100 
#99.62%


###procurement category
aw_com <- df_chile %>% 
  filter(is.na(ten_id)==FALSE, is.na(ten_year)==FALSE, is.na(comp_procMethod)==FALSE) %>%
  group_by(comp_procMethod, ten_year, proc_cat) %>%
  summarise(aw_com = uniqueN(ten_id))

p_aw_com <- aw_com %>% 
  group_by(ten_year, proc_cat) %>%
  mutate(p_aw_com = (aw_com/sum(aw_com))*100)%>%
  filter(comp_procMethod == "competitive")


ggplot(p_aw_com, aes(x = ten_year, y = p_aw_com, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())



###buyer type
aw_com_bt <- df_chile %>% 
  filter(is.na(ten_id)==FALSE, is.na(ten_year)==FALSE, is.na(buyer_type)==FALSE) %>%
  group_by(comp_procMethod, ten_year, buyer_type) %>%
  summarise(aw_com_bt = uniqueN(ten_id))

p_aw_com_bt <- aw_com_bt %>% 
  group_by(ten_year, buyer_type) %>%
  mutate(p_aw_com_bt = (aw_com_bt/sum(aw_com_bt))*100) %>%
  filter(comp_procMethod == "competitive")

ggplot(p_aw_com_bt, aes(x = ten_year, y = p_aw_com_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())


###buyer id
aw_com_buyerid <- df_chile %>% 
  filter(is.na(ten_id)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(comp_procMethod, buyer_id) %>%
  summarise(aw_com_buyerid = uniqueN(ten_id))

p_aw_com_buyerid <- aw_com_buyerid %>% 
  group_by(buyer_id) %>%
  mutate(p_aw_com_buyerid = (aw_com_buyerid/sum(aw_com_buyerid))*100) %>%
  filter(comp_procMethod == "competitive")

p_aw_com_buyerid$p_aw_com_buyerid <- round(p_aw_com_buyerid$p_aw_com_buyerid)

paw_avbuyid <- p_aw_com_buyerid %>% 
  filter(is.na(p_aw_com_buyerid)==FALSE) %>%
  group_by(p_aw_com_buyerid) %>%
  summarise(paw_avbuyid = uniqueN(buyer_id))


ggplot(paw_avbuyid, aes(x=p_aw_com_buyerid, y=paw_avbuyid)) + 
  geom_bar(stat="identity", width=.3, fill="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,60)) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("percent of tenders") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


summary(p_aw_com_buyerid$p_aw_com_buyerid)
#98.81% mean




###########################
#2.4 Total awarded value of tenders awarded by means of competitive procedures


#tender/id, tender/value/amount, tender/procurementMethod, awards/status

tot_aw <- df_chile %>%
  group_by(comp_procMethod, ten_id) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw = sum(ca_vamount2)) 

mean(is.na(tot_aw$tot_aw))
#15.25%
summary(tot_aw$tot_aw)
#####2.381e+08 CLP


###procurement category
tot_aw_val <- df_chile %>% 
  filter(is.na(ca_vamount2)==FALSE, is.na(comp_procMethod)==FALSE, is.na(ten_year)==FALSE, is.na(proc_cat)==FALSE) %>%
  group_by(comp_procMethod, ten_year, proc_cat) %>%
  summarise(tot_aw_val = (sum(ca_vamount2)/1000000000)) %>%
   filter(comp_procMethod == "competitive") 

ggplot(tot_aw_val, aes(x = ten_year, y = tot_aw_val, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("total awarded value of tenders (billion)") +
  theme(panel.grid.minor = element_blank())


#buyer type
tot_aw_val_bt <- df_chile %>% 
  filter(is.na(ca_vamount2)==FALSE, is.na(comp_procMethod)==FALSE, is.na(ten_year)==FALSE, is.na(buyer_type)==FALSE) %>%
  group_by(comp_procMethod, ten_year, buyer_type) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val_bt = (sum(ca_vamount2)/1000000000))

ggplot(tot_aw_val_bt, aes(x = ten_year, y = tot_aw_val_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  scale_color_manual(name="",
                     values = c("#00AFBB", "#E7B800")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("total awarded value of tenders (billion)") +
  theme(panel.grid.minor = element_blank())


#buyer ID
tot_aw_val_buyerid <- df_chile %>% 
  filter(is.na(ca_vamount2)==FALSE, is.na(comp_procMethod)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(comp_procMethod, buyer_id) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val_byid = (sum(ca_vamount2)/1000000000))

summary(tot_aw_val_buyerid$tot_aw_val_byid)
length(which(tot_aw_val_buyerid$tot_aw_val_byid > 1000))
hist(tot_aw_val_buyerid$tot_aw_val_byid)

tot_aw_val_buyerid$tot_aw_val_byid[tot_aw_val_buyerid$tot_aw_val_byid > 1000] <- NA

#split total value amounts into 10 groups
tot_aw_val_buyerid$groups <- cut(tot_aw_val_buyerid$tot_aw_val_byid, breaks=c(100,200,400,600,800,1000,Inf))


totawv_avbuyid2 <- tot_aw_val_buyerid %>% 
  filter(is.na(groups)==FALSE) %>%
  group_by(groups) %>%
  summarise(totawv_avbuyid = uniqueN(buyer_id))

ggplot(totawv_avbuyid2, aes(x=groups, y=totawv_avbuyid)) + 
  geom_bar(stat="identity", width=.3, colour="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,40)) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("total value amount (billion)") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


#df_chile <- left_join(df_chile, tot_aw_val_buyerid, by = "buyer_id")

summary(tot_aw_val_buyerid$tot_aw_val_byid)
#15.8456 billion CLP



###########################
#2.5 Percent of tenders with at least three participants

#tender/id, tender/numberOfTenderers OR tender/tenderers/identifier/id OR tender/tenderers/name, bids/validBids (Bid Extension)
#these information is only available in OCDS, data filtered from 2017

length(which(df_chile$ten_nrofTenderers >= 3))
#1148857

df_chile$bid3 <- ifelse(df_chile$ten_nrofTenderers >= 3, T, F)
length(which(df_chile$bid3 == T))
#1148857 obs
length(which(df_chile$bid3 == F))
#701776 obs

df_ten <- df_chile
df_ten <- df_ten[!duplicated(df_ten$ten_id), ]
length(which(df_ten$bid3 == T)) / uniqueN(df_ten$ten_id)
#0.5070905

mean(is.na(df_ten$bid3))
mean(is.na(df_chile$bid3))



###procurement categories
bidder3 <- setDT(df_chile)[, .(bidder_count = length(which(bid3 == T))), by = list(ten_year, proc_cat)]

p_bidder3 <- bidder3 %>% group_by(proc_cat, ten_year) %>% filter(is.na(ten_year)==FALSE) %>% mutate(p_bidder3 = (bidder_count/length(df_chile$ten_id)*100))

ggplot(p_bidder3, aes(x = ten_year, y = p_bidder3, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) +  
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())


###buyer type
bidder3_bt <- setDT(df_chile)[, .(bidder_count_bt = length(which(bid3 == T))), by = list(ten_year, buyer_type)]

p_bidder3_bt <- group_by(bidder3_bt) %>% filter(is.na(ten_year)==FALSE, is.na(buyer_type)==FALSE) %>% mutate(p_bidder3_bt = (bidder_count_bt/length(df_chile$ten_id))*100)

ggplot(p_bidder3_bt, aes(x = ten_year, y = p_bidder3_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())


##########buyer id
bidder3_buyerid <- setDT(df_chile)[, .(bidder_count_buyerid = length(which(bid3 == T))), by = c('buyer_id', 'ten_year')]
p_bidder3_buyerid <- group_by(bidder3_buyerid) %>% filter(is.na(ten_year)==FALSE) %>% mutate(p_bidder3_buyerid = (bidder_count_buyerid/length(df_chile$ten_id))*100)

mean(is.na(p_bidder3_buyerid$p_bidder3_buyerid))
length(which(p_bidder3_buyerid$p_bidder3_buyerid == 0))
p_bidder3_buyerid$p_bidder3_buyerid[p_bidder3_buyerid$p_bidder3_buyerid == 0] <- NA
p_bidder3_buyerid$bidder_count_buyerid[p_bidder3_buyerid$bidder_count_buyerid == 0] <- NA



summary(p_bidder3_buyerid$p_bidder3_buyerid)
#non-sensical values


###########################
#2.6 Percent of contracts awarded to top 10 suppliers with largest contracted totals
#awards/suppliers/identifier OR awards/suppliers/name, contracts/id, contracts/awardID, awards/value/amount OR contracts/value/amount

df_chile$ca_id <- paste(df_chile$ten_id, "_", df_chile$lot_row_nr)
length(unique(df_chile$ca_id))
#1.82M

tbl_proa_sup <- df_chile %>% 
  filter(is.na(ten_year)==FALSE, is.na(ca_vamount2)==FALSE) %>%
  group_by(aw_sup_id, ca_id, ten_year) %>%
  summarise(tbl_proa_sup = sum(ca_vamount2))

tbl_proa_sup <- setDT(tbl_proa_sup)[, .(top10 = ((sum(head(sort(tbl_proa_sup,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup))*100), , by = list(ten_year)]

mean(is.na(tbl_proa_sup$top10))
#0%

summary(tbl_proa_sup$top10)
#58.43%


###procurement category
tbl_proa_sup_pc <- df_chile %>% 
  filter(is.na(aw_sup_id)==FALSE, is.na(ca_vamount2)==FALSE, is.na(ten_year)==FALSE, bid_iswinning=="t") %>%
  group_by(aw_sup_id, ten_year, proc_cat) %>%
  summarise(tbl_proa_sup_pc = sum(ca_vamount2))


library(data.table)
tbl_proa_sup_pc <- setDT(tbl_proa_sup_pc)[, .(top10p = ((sum(head(sort(tbl_proa_sup_pc,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup_pc))*100), by = list(ten_year, proc_cat)]


ggplot(tbl_proa_sup_pc, aes(x = ten_year, y = top10p, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())


###buyer type
tbl_proa_sup_bt <- df_chile %>% 
  filter(is.na(aw_sup_id)==FALSE, is.na(buyer_type)==FALSE, is.na(ca_vamount2)==FALSE, is.na(ten_year)==FALSE, bid_iswinning=="t") %>%
  group_by(aw_sup_id, ten_year, buyer_type) %>%
  summarise(tbl_proa_sup_bt = sum(ca_vamount2))

tbl_proa_sup_bt2 <- setDT(tbl_proa_sup_bt)[, .(top10p_bt = ((sum(head(sort(tbl_proa_sup_bt,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup_bt))*100), by = list(ten_year, buyer_type)]
#df_chile <- left_join(df_chile, tbl_proa_sup_bt2)

ggplot(tbl_proa_sup_bt2, aes(x = ten_year, y = top10p_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())



###buyer id
tbl_proa_sup_buyerid <- df_chile %>% 
  filter(is.na(aw_sup_id)==FALSE, is.na(ca_vamount2)==FALSE, is.na(buyer_id)==FALSE, bid_iswinning=="t") %>%
  group_by(aw_sup_id, buyer_id) %>%
  summarise(tbl_proa_sup_buyerid = sum(ca_vamount2))

tbl_proa_supy_buyerid <- setDT(tbl_proa_sup_buyerid)[, .(top10p_buyerid = ((sum(head(sort(tbl_proa_sup_buyerid,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup_buyerid))*100), by = list(buyer_id)]
#df_chile <- left_join(df_chile, tbl_proa_supy_buyerid, by = "buyer_id")

summary(tbl_proa_supy_buyerid$top10p_buyerid)
#77.27%
mean(is.na(tbl_proa_supy_buyerid$top10p_buyerid))
#0

tbl_proa_supy_buyerid$top10p_buyerid_round <- round(tbl_proa_supy_buyerid$top10p_buyerid)

tbl_proa_supy_buyerid2 <- tbl_proa_supy_buyerid %>% 
  filter(is.na(top10p_buyerid_round)==FALSE) %>%
  group_by(top10p_buyerid_round) %>%
  summarise(top10p_buyerid_p2 = uniqueN(buyer_id))


ggplot(tbl_proa_supy_buyerid2, aes(x=top10p_buyerid_round, y=top10p_buyerid_p2)) + 
  geom_bar(stat="identity", width=.3, fill="tomato3", na.rm = T) +
  scale_y_continuous(limits = c(0,60)) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("percent of tenders") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))




########################### PUBLIC INTEGRITY ###########################
#3.1 Percent of contracts that do not have amendments
#NA - not in source

#3.2 Mean number of contract amendments per buyer
#NA - not in source


########################### QUALITY AND COMPLETENESS OF INFORMATION ###########################
#4.1 Mean number of days between tender period end date and award date


#Mean number of days between award date and date of publication of award information on portal
#awards/id, awards/date, awards/suppliers/identifier/id OR awards/suppliers/name
#tender_publications_firstdcontractawarddate,  alternative: 

#define award decision period
df_chile$aw_period <- difftime(df_chile$aw_date, df_chile$ten_endDate, units = c("days"))
df_chile$aw_period <- as.numeric(df_chile$aw_period)
summary(df_chile$aw_period)
hist(df_chile$aw_period)
#mainly <100days, remove obs over 1 year
df_chile$aw_period <- ifelse(df_chile$aw_period > 365, NA, df_chile$aw_period)


mean(is.na(df_chile$aw_period))
#0.047% 

awp <- df_chile %>% 
  group_by(ten_id) %>%
  summarise(mean_aw_period = mean(aw_period, na.rm=TRUE))

#df_chile <- cbind(df_chile, awp[match(df_chile$ten_id, awp$ten_id), 2])

mean(is.na(awp$mean_aw_period))
#0.105

summary(awp$mean_aw_period)
#20.08 days
#0.84% have the 0 days


###procurement category 
awmppc <- df_chile %>% 
  filter(is.na(ten_year)==FALSE, is.na(aw_period)==FALSE) %>%
  group_by(ten_year, proc_cat) %>%
  summarise(awmppc = mean(aw_period))


ggplot(awmppc, aes(x = ten_year, y = awmppc, group=proc_cat)) + 
  geom_line(aes(color = proc_cat), size = 2) +
  scale_color_manual(name="", 
                     values = c("red", "green4")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("award decision period (days)") +
  theme(panel.grid.minor = element_blank())



###buyer type
awmp_bt <- df_chile %>% 
  filter(is.na(ten_year)==FALSE, is.na(aw_period)==FALSE, is.na(buyer_type)==FALSE) %>%
  group_by(ten_year, buyer_type) %>%
  summarise(awmp_bt = mean(aw_period, na.rm=TRUE))


ggplot(awmp_bt, aes(x = ten_year, y = awmp_bt, group=buyer_type)) + 
  geom_line(aes(color = buyer_type), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("year") +
  ylab("award decision period (days)") +
  theme(panel.grid.minor = element_blank())



###new buyer id
awmp_buyid <- df_chile %>% 
  filter(is.na(aw_period)==FALSE) %>%
  group_by(buyer_id) %>%
  summarise(awmp_buyid = mean(aw_period, na.rm=TRUE))

awmp_buyid$awmp_buyid <- round(awmp_buyid$awmp_buyid)
hist(awmp_buyid$awmp_buyid)
awmp_buyid$awmp_buyid[awmp_buyid$awmp_buyid > 110] <- NA


awmp_avbuyid <- awmp_buyid %>% 
  filter(is.na(awmp_buyid)==FALSE) %>%
  group_by(awmp_buyid) %>%
  summarise(awbuyid = uniqueN(buyer_id))


ggplot(awmp_avbuyid, aes(x=awmp_buyid, y=awbuyid)) + 
  geom_bar(stat="identity", width=.25, fill="tomato3") + 
  scale_y_continuous(limits = c(0,40)) +
  theme(axis.title.x = element_text(size = 17, margin = margin(13,0,0,0))) +
  theme(axis.title.y = element_text(size = 17)) +
  theme(axis.text=element_text(size=15)) +
  theme(legend.text=element_text(size=17)) +
  xlab("award decision period (days)") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


############################################################################################


########################### VALUE FOR MONEY ###########################
#5.1 Percent of contracts completed by contract end date
#NA - not in source

#5.2 Percent of contracts whose milestones are completed on time
#NA - not in source
###########################################################################################


write.csv(df_chile, file = "C:/Users/info/Desktop/Nora/0612/chile190607.csv", row.names = FALSE)

