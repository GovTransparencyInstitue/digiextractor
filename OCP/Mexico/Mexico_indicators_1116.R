#set directory
setwd("C:/Users/Bertold/Downloads/mexico_contratos/flattened-raw/raw_merge/")
getwd()

#checking current memory limit
memory.limit()
#setting a bigger one
memory.limit(30000)

df_cot <- read.csv("C:/Users/Bertold/Downloads/mexico_contratos/df_cot1107.csv", header = TRUE, sep = ",")


#check and set types of variables 
sapply(df_cot, class)


#correct variable types
cols <- c(4,6,7,8,9,11,12,13,14,15,16,19,21,27,34,40,42)
df_cot[,cols] = lapply(df_cot[,cols], as.character)

cols <- c(23,28,29,34,36,37,38)
df_cot[,cols] = lapply(df_cot[,cols], as.numeric)

cols <- c(7,8,13,14,16)
df_cot[,cols] = lapply(df_cot[,cols], as.Date)

cols <- c(10,17,41)
df_cot[,cols] = lapply(df_cot[,cols], as.integer)

#create indicator - tender period
df_cot$ten_period1 <- difftime(df_cot$rec_com_ten_endDate, df_cot$rec_com_ten_startDate, units = c("days"))
head(df_cot$ten_period1, n = 100)

#change variable type for calculations
df_cot$ten_period1 <- as.numeric(df_cot$ten_period1)

#create a variable for contract year
df_cot$ca_year <- format(as.Date(df_cot$rec_com_ca_startDate, format="%Y-%m-%d"),"%Y")
df_cot$ca_year <- as.numeric(df_cot$ca_year)

#remove outliers from ca_year
df_cot$ca_year[df_cot$ca_year < 2010] <- NA

#check missings
sapply(df_cot, function(df_cot) sum(is.na(df_cot)))


#buyer type: APF: Administración Pública Federal. GE: Gobierno Estatal. GM: Gobierno Municipal.
df_cot$buyer_type_bi <- ifelse(df_cot$buyer_type == "APF" & (!is.na(df_cot$buyer_type)), "National", "Subnational")
table(df_cot$buyer_type_bi)

df_cot$buyer_type_bi <- as.factor(df_cot$buyer_type_bi)


#rename public work related services to services
df_cot$rec_com_ten_procCat1 <- df_cot$rec_com_ten_procCat 
df_cot$rec_com_ten_procCat1 <- ifelse(df_cot$rec_com_ten_procCat1 == "PW related services" & (!is.na(df_cot$rec_com_ten_procCat1)), "services", df_cot$rec_com_ten_procCat1)
table(df_cot$rec_com_ten_procCat1)
df_cot$rec_com_ten_procCat <- df_cot$rec_com_ten_procCat1
df_cot$rec_com_ten_procCat1 <- NULL

#generate new buyer id by buyer names
df_cot$rec_com_ca_buyer_name1 <- df_cot$rec_com_ca_buyer_name
df_cot$rec_com_ca_buyer_name1 <- tolower(df_cot$rec_com_ca_buyer_name1)
df_cot$rec_com_ca_buyer_name1 <- gsub('[[:punct:]]', "", df_cot$rec_com_ca_buyer_name1)

df_cot$new_buyer_id <- as.numeric(as.factor(with(df_cot, paste(rec_com_ca_buyer_name1, sep="_"))))
length(unique(df_cot$new_buyer_id))
#344
mean(is.na(df_cot$new_buyer_id))
#0

df_cot$rec_com_ca_buyer_name <- NULL
df_cot$rec_com_ca_buyer_name <- df_cot$rec_com_ca_buyer_name1
df_cot$rec_com_ca_buyer_name1 <- NULL
  
  
#generate new supplier id by supplier names
df_cot$rec_com_aw_sup_name1 <- df_cot$rec_com_aw_sup_name
df_cot$rec_com_aw_sup_name1 <- tolower(df_cot$rec_com_aw_sup_name1)
df_cot$rec_com_aw_sup_name1 <- gsub('[[:punct:]]', "", df_cot$rec_com_aw_sup_name1)

df_cot$new_sup_id <- as.numeric(as.factor(with(df_cot, paste(rec_com_aw_sup_name1, sep="_"))))
length(unique(df_cot$new_sup_id))
#209336
mean(is.na(df_cot$new_sup_id))
#0


df_cot$rec_com_aw_sup_name <- NULL
df_cot$rec_com_aw_sup_name <- df_cot$rec_com_aw_sup_name1
df_cot$rec_com_aw_sup_name1 <- NULL


##########################################################################

###########INDICATORS##############

#####INTERNAL EFFICIENCY

#Mean length of tender period (days)
#tender/id, tender/tenderPeriod/startDate, tender/tenderPeriod/endDate

#overall mean length of period
summary(df_cot$ten_period1)
df_cot$ten_period1[df_cot$ten_period1 < 0 | df_cot$ten_period1 >= 10600] <- NA
#the tender with more than 1000 days is a mulityear project


submp <- df_cot %>% 
  filter(ca_year > 2011) %>%
  group_by(rec_com_ten_id) %>%
  summarise(submp = mean(ten_period1, na.rm=TRUE))

mean(is.na(submp$submp))
#58%

summary(submp$submp)
#9 days


###procurement category
library(dplyr)

submp2 <- df_cot %>% 
  filter(is.na(ca_year)==FALSE, is.na(ten_period1)==FALSE, ca_year > 2011) %>%
  group_by(ca_year, rec_com_ten_procCat) %>%
  summarise(submp_pc = mean(ten_period1))


library(ggplot2)

ggplot(submp2, aes(x = ca_year, y = submp_pc, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())



###buyer type
submp_bt <- df_cot %>% 
  filter(is.na(ca_year)==FALSE, is.na(ten_period1)==FALSE, ca_year > 2011) %>%
  group_by(ca_year, buyer_type_bi) %>%
  summarise(submp_bt = mean(ten_period1, na.rm=TRUE))


ggplot(submp_bt, aes(x = ca_year, y = submp_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())



###new buyer id
submp_buyid <- df_cot %>% 
  filter(is.na(ten_period1)==FALSE) %>%
  group_by(new_buyer_id) %>%
  summarise(submp_buyid = mean(ten_period1, na.rm=TRUE))


submp_buyid$submp_buyid[submp_buyid$submp_buyid > 20] <- NA

ggplot(submp_buyid, aes(x=submp_buyid, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.05, fill="tomato3") + 
  scale_y_continuous(limits = c(0,300)) +
       theme(axis.text.x = element_text(angle=65, vjust=0.6))

summary(submp_buyid$submp_buyid)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#1.348   7.857  11.155  11.757  13.700 211.000

length(which(submp_buyid$submp_buyid > 20))



df_cot <- left_join(df_cot, submp_buyid, by = "new_buyer_id")
class(df_cot$submp_buyid)

summary(df_cot$submp_buyid)
#11 days

#####################################################

####MARKET OPPORTUNITY

#Percent of contracts awarded to top 10 suppliers with largest contracted totals
#awards/suppliers/identifier OR awards/suppliers/name, contracts/id, contracts/awardID, awards/value/amount OR contracts/value/amount


tbl_proa_sup <- df_cot %>% 
  filter(ca_year > 2011) %>%
  group_by(new_sup_id, rec_com_ca_id, ca_year) %>%
  summarise(tbl_proa_sup = sum(rec_com_ca_vamount))

tbl_proa_sup <- setDT(tbl_proa_sup)[, .(top10 = ((sum(head(sort(tbl_proa_sup,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup))*100), , by = list(ca_year)]

mean(is.na(tbl_proa_sup$top10))
#57%

summary(tbl_proa_sup$top10)
#18.5%


###procurement category
tbl_proa_sup_pc <- df_cot %>% 
  filter(is.na(new_sup_id)==FALSE, is.na(rec_com_ca_vamount)==FALSE, is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(new_sup_id, ca_year, rec_com_ten_procCat) %>%
  summarise(tbl_proa_sup_pc = sum(rec_com_ca_vamount))


library(data.table)

tbl_proa_sup_pc <- setDT(tbl_proa_sup_pc)[, .(top10p = ((sum(head(sort(tbl_proa_sup_pc,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup_pc))*100), by = list(ca_year, rec_com_ten_procCat)]
df_cot <- left_join(df_cot, tbl_proa_sup_pc)


ggplot(tbl_proa_sup_pc, aes(x = ca_year, y = top10p, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())


###buyer type
tbl_proa_sup_bt <- df_cot %>% 
  filter(is.na(new_sup_id)==FALSE, is.na(rec_com_ca_vamount)==FALSE, is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(new_sup_id, ca_year, buyer_type_bi) %>%
  summarise(tbl_proa_sup_bt = sum(rec_com_ca_vamount))

tbl_proa_sup_bt2 <- setDT(tbl_proa_sup_bt)[, .(top10p_bt = ((sum(head(sort(tbl_proa_sup_bt,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup_bt))*100), by = list(ca_year, buyer_type_bi)]
df_cot <- left_join(df_cot, tbl_proa_sup_bt2)

ggplot(tbl_proa_sup_bt2, aes(x = ca_year, y = top10p_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())



###new buyer id
tbl_proa_sup_buyerid <- df_cot %>% 
  filter(is.na(new_sup_id)==FALSE, is.na(rec_com_ca_vamount)==FALSE, ca_year > 2011) %>%
  group_by(new_sup_id, new_buyer_id) %>%
  summarise(tbl_proa_sup_buyerid = sum(rec_com_ca_vamount))

tbl_proa_supy_buyerid <- setDT(tbl_proa_sup_buyerid)[, .(top10p_buyerid = ((sum(head(sort(tbl_proa_sup_buyerid,decreasing=TRUE), n = 10)))/sum(tbl_proa_sup_buyerid))*100), by = list(new_buyer_id)]
df_cot <- left_join(df_cot, tbl_proa_supy_buyerid, by = "new_buyer_id")

summary(df_cot$top10p_buyerid)
#47.1%

summary(tbl_proa_supy_buyerid$top10p_buyerid)
mean(is.na(tbl_proa_supy_buyerid$top10p_buyerid))
#0

ggplot(tbl_proa_supy_buyerid, aes(x=top10p_buyerid, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.3, fill="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))



##############################################


#Percent of tenders awarded by means of competitive procedures
#tender/id, tender/procurementMethod, awards/status
#there is no awards status

comp_ten <- (length(which(df_cot$rec_com_ten_procMethod == "open")) / length(df_cot$rec_com_ten_id))*100
#15.56%
length(which(df_cot$rec_com_ten_procMethod == "open"))
#222007

df_cot$comp_procMethod <- ifelse(df_cot$rec_com_ten_procMethod == "open" & (!is.na(df_cot$rec_com_ten_procMethod)), "competitive", "non-comp")
length(which(df_cot$comp_procMethod == "competitive"))

mean(is.na(df_cot$comp_procMethod))
#0
comp <- (length(which(df_cot$comp_procMethod == "competitive" & df_cot$ca_year > 2011)) / sum(!is.na(df_cot$comp_procMethod)))*100 
#14.17%


###procurement category
aw_com <- df_cot %>% 
  filter(is.na(rec_com_ten_id)==FALSE, is.na(ca_year)==FALSE, is.na(comp_procMethod)==FALSE, ca_year > 2011) %>%
  group_by(comp_procMethod, ca_year, rec_com_ten_procCat) %>%
  summarise(aw_com = uniqueN(rec_com_ten_id))

p_aw_com <- aw_com %>% 
  group_by(ca_year, rec_com_ten_procCat) %>%
  mutate(p_aw_com = (aw_com/sum(aw_com))*100)%>%
  filter(comp_procMethod == "competitive")


ggplot(p_aw_com, aes(x = ca_year, y = p_aw_com, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())



###buyer type
aw_com_bt <- df_cot %>% 
  filter(is.na(rec_com_ten_id)==FALSE, is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(comp_procMethod, ca_year, buyer_type_bi) %>%
  summarise(aw_com_bt = uniqueN(rec_com_ten_id))

p_aw_com_bt <- aw_com_bt %>% 
    group_by(ca_year, buyer_type_bi) %>%
  mutate(p_aw_com_bt = (aw_com_bt/sum(aw_com_bt))*100) %>%
filter(comp_procMethod == "competitive")

ggplot(p_aw_com_bt, aes(x = ca_year, y = p_aw_com_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())


###new buyer id
aw_com_buyerid <- df_cot %>% 
  filter(is.na(rec_com_ten_id)==FALSE, is.na(new_buyer_id)==FALSE, ca_year > 2011) %>%
  group_by(comp_procMethod, new_buyer_id) %>%
  summarise(aw_com_buyerid = uniqueN(rec_com_ten_id))

p_aw_com_buyerid <- aw_com_buyerid %>% 
  group_by(new_buyer_id) %>%
  mutate(p_aw_com_buyerid = (aw_com_buyerid/sum(aw_com_buyerid))*100) %>%
  filter(comp_procMethod == "competitive")

ggplot(p_aw_com_buyerid, aes(x=p_aw_com_buyerid, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.4, fill="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


df_cot <- left_join(df_cot, p_aw_com_buyerid, by = "new_buyer_id")
class(df_cot$p_aw_com_buyerid)

summary(df_cot$p_aw_com_buyerid)
#11.2%

##############################################

#Total awarded value of tenders awarded by means of competitive procedures
#tender/id, tender/value/amount, tender/procurementMethod, awards/status
#83% missing in award value, used contract value instead

tot_aw <- df_cot %>%
  filter(ca_year > 2011) %>%
  group_by(comp_procMethod, rec_com_ten_id) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw = sum(rec_com_ca_vamount)) 

mean(is.na(tot_aw$tot_aw))
#1.6%
summary(tot_aw$tot_aw)
#17,110,000 MXN

###procurement category
tot_aw_val <- df_cot %>% 
  filter(is.na(rec_com_ca_vamount)==FALSE, is.na(comp_procMethod)==FALSE, is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(comp_procMethod, ca_year, rec_com_ten_procCat) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val = sum(rec_com_ca_vamount))


ggplot(tot_aw_val, aes(x = ca_year, y = tot_aw_val, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())


tot_aw_val_bt <- df_cot %>% 
  filter(is.na(rec_com_ca_vamount)==FALSE, is.na(comp_procMethod)==FALSE, is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(comp_procMethod, ca_year, buyer_type_bi) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val_bt = sum(rec_com_ca_vamount))

ggplot(tot_aw_val_bt, aes(x = ca_year, y = tot_aw_val_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="",
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())


tot_aw_val_buyerid <- df_cot %>% 
  filter(is.na(rec_com_ca_vamount)==FALSE, is.na(comp_procMethod)==FALSE, is.na(new_buyer_id)==FALSE, ca_year > 2011) %>%
  group_by(comp_procMethod, new_buyer_id) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val_byid = sum(rec_com_ca_vamount))

summary(tot_aw_val_buyerid$tot_aw_val_byid)
length(which(tot_aw_val_buyerid$tot_aw_val_byid > 2000000000))

tot_aw_val_buyerid$tot_aw_val_byid1 <- tot_aw_val_buyerid$tot_aw_val_byid
tot_aw_val_buyerid$tot_aw_val_byid1[tot_aw_val_buyerid$tot_aw_val_byid1 > 2000000000] <- NA

ggplot(tot_aw_val_buyerid, aes(x=tot_aw_val_byid1, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=1, colour="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x = element_text(angle=30, hjust=1))


df_cot <- left_join(df_cot, tot_aw_val_buyerid, by = "new_buyer_id")

summary(df_cot$tot_aw_val_buyerid)
#81230000000 MXN


######################################################

#Percent of tenders with at least three participants deemed qualified
#tender/id, tender/numberOfTenderers OR tender/tenderers/identifier/id OR tender/tenderers/name, bids/validBids (Bid Extension)
#these information is only available in OCDS, data filtered from 2017


df_cot$bid3 <- ifelse(df_cot$rec_com_ten_nrOfTenderers >= 3, T, F)
length(which(df_cot$bid3 == T))
#56774 obs
length(which(df_cot$bid3 == F))
#23681 obs

length(which(df_cot$bid3 == T)) / uniqueN(df_cot$rec_com_ten_id[df_cot$ca_year > 2016])
#19%

sum(!is.na(df_cot$bid3))/uniqueN(df_cot$rec_com_ten_id[df_cot$ca_year > 2016])
#73% missing


###procurement categories
bidder3 <- setDT(df_cot)[, .(bidder_count = length(which(bid3 == T))), by = list(ca_year, rec_com_ten_procCat)]

p_bidder3 <- group_by(bidder3) %>% filter(is.na(ca_year)==FALSE & ca_year > 2016) %>% mutate(p_bidder3 = (bidder_count/uniqueN(df_cot$rec_com_ten_id[df_cot$ca_year > 2016]))*100)

ggplot(p_bidder3, aes(x = ca_year, y = p_bidder3, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())


###buyer type
bidder3_bt <- setDT(df_cot)[, .(bidder_count_bt = length(which(bid3 == T))), by = list(ca_year, buyer_type_bi)]

p_bidder3_bt <- group_by(bidder3_bt) %>% filter(is.na(ca_year)==FALSE & ca_year > 2016) %>% mutate(p_bidder3_bt = (bidder_count_bt/uniqueN(df_cot$rec_com_ten_id[df_cot$ca_year > 2016]))*100)

ggplot(p_bidder3_bt, aes(x = ca_year, y = p_bidder3_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())


###new buyer id
bidder3_buyerid <- setDT(df_cot)[, .(bidder_count_buyerid = length(which(bid3 == T))), by = c('new_buyer_id', 'ca_year')]
p_bidder3_buyerid <- group_by(bidder3_buyerid) %>% filter(is.na(ca_year)==FALSE & ca_year > 2016) %>% mutate(p_bidder3_buyerid = (bidder_count_buyerid/uniqueN(df_cot$rec_com_ten_id[df_cot$ca_year > 2016]))*100)

mean(is.na(p_bidder3_buyerid$p_bidder3_buyerid))
length(which(p_bidder3_buyerid$p_bidder3_buyerid == 0))
p_bidder3_buyerid$p_bidder3_buyerid[p_bidder3_buyerid$p_bidder3_buyerid == 0] <- NA
p_bidder3_buyerid$bidder_count_buyerid[p_bidder3_buyerid$bidder_count_buyerid == 0] <- NA



summary(p_bidder3_buyerid$p_bidder3_buyerid)
#0.416%

# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#0.00033 0.00133 0.00400 0.04164 0.01225 6.81162     197

mean(is.na(p_bidder3_buyerid$p_bidder3_buyerid))
#30% 



######################################################

#Percent of awards awarded to new suppliers
#awards/id, awards/suppliers/identifier/id OR awards/suppliers/name, awards/date
#use contract start date instead of awards date
#81% of award id is missing, use contract id instead

#define winners by completed contract id, contract status and contract value amount  
df_cot$winner <- ifelse(!is.na(df_cot$rec_com_ca_id) & !is.na(df_cot$rec_com_ca_status) & !is.na(df_cot$rec_com_ca_vamount), "W", "L") 

length(which(df_cot$winner == "W"))
#1360697 obs, mostly contains winners
length(which(df_cot$winner == "L"))
#65687 obs


#calculate the year when a supplier won a tender for the first time 
first_win <- df_cot %>% 
  filter(is.na(new_sup_id)==FALSE, is.na(ca_year)==FALSE, winner == "W", ca_year > 2011) %>%
  group_by(new_sup_id) %>%
  summarise(first_win = min(ca_year))

df_cot <- left_join(df_cot, first_win, by = "new_sup_id")

mean(is.na(df_cot$first_win))
#3%

df_cot$new_winner <- ifelse(df_cot$ca_year == df_cot$first_win, "New", "Old")
df_cot2 <- df_cot[ which(!is.na(df_cot$first_win)  & df_cot$ca_year > 2011) ,]
df_cot2$new_winner <- ifelse(df_cot2$ca_year == df_cot2$first_win, "New", "Old")

  
length(which(df_cot2$new_winner == "New"))
#378541
length(which(df_cot2$new_winner == "Old"))
#918910


length(which(df_cot2$new_winner == "New"))/length(df_cot2$new_winner)
#29%

###procurement category
new_winner_pc <- df_cot2 %>% 
  filter(is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(ca_year, rec_com_ten_procCat, new_winner) %>%
  summarise(new_winner_pc = uniqueN(new_sup_id))


p_new_winner_pc <- new_winner_pc %>%
  group_by(ca_year, rec_com_ten_procCat) %>%
  mutate(p_new_winner_pc = (new_winner_pc/sum(new_winner_pc))*100) %>%
  filter(new_winner == "New")


ggplot(p_new_winner_pc, aes(x = ca_year, y = p_new_winner_pc, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())


###buyer type
new_winner_bt <- df_cot2 %>% 
  filter(is.na(ca_year)==FALSE, ca_year > 2011) %>%
  group_by(ca_year, buyer_type_bi, new_winner) %>%
  summarise(new_winner_bt = uniqueN(new_sup_id))


p_new_winner_bt <- new_winner_bt %>% 
  group_by(ca_year, buyer_type_bi) %>%
  mutate(p_new_winner_bt = (new_winner_bt/sum(new_winner_bt))*100) %>%
  filter(new_winner == "New")


ggplot(p_new_winner_bt, aes(x = ca_year, y = p_new_winner_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())


###new buyer id
new_winner_byid <- df_cot2 %>% 
  filter(is.na(new_buyer_id)==FALSE) %>%
  group_by(new_buyer_id, new_winner) %>%
  summarise(new_winner_byid = uniqueN(new_sup_id))


p_new_winner_byid <- new_winner_byid %>% 
  group_by(new_buyer_id) %>%
  mutate(p_new_winner_byid = (new_winner_byid/sum(new_winner_byid))*100) %>%
  filter(new_winner == "New")

ggplot(p_new_winner_byid, aes(x=p_new_winner_byid, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.3, fill="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


summary(p_new_winner_byid$p_new_winner_byid)
#48%

###################################################


#Public Integrity

#Percent of tenders which have been closed for more than 30 days, but whose basic awards information is not published
#tender/id, tender/tenderPeriod/endDate, awards/id, awards/date, awards/value/amount, awards/suppliers/identifier/id OR awards/suppliers/name
#awards information only available in OCDS, data filtered for period 2017-2018

df_cot$ten_closed <- difftime(df_cot$rec_com_ca_startDate, df_cot$rec_com_ten_endDate, units = c("days")) 
df_cot$ten_closed <- as.integer(df_cot$ten_closed)
length(which(df_cot$ten_closed < 0))
###37937 obs
summary(df_cot$ten_closed)

df_cot$ten_closed[df_cot$ten_closed < 0] <- NA
length(which(df_cot$ten_closed >= 30))
#118234 obs


df_cot$aw_missing <- ifelse(df_cot$ten_closed >= 30 & (is.na(df_cot$rec_com_aw_id) & is.na(df_cot$rec_com_aw_vamount) & is.na(df_cot$rec_com_aw_sup_id)), T, F)


df_cot1718 <- df_cot[ which(df_cot$ca_year > 2016) ,]
mean(is.na(df_cot1718$aw_missing))
#11%

length(which(df_cot1718$aw_missing == T))
#6376 obs

length(which(df_cot1718$aw_missing == T)) / length(which(df_cot1718$ten_closed >= 30))
#27%



###procurement category
aw_missing <- df_cot %>% 
  filter(is.na(ten_closed)==FALSE, is.na(ca_year)==FALSE, ca_year > 2016) %>%
  group_by(ca_year, rec_com_ten_procCat) %>%
  summarize(aw_missing_p = sum(which(aw_missing == T)) / sum(which(ten_closed >= 30))*100)


ggplot(aw_missing, aes(x = ca_year, y = aw_missing_p, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())


###buyer type
aw_missing_bt <- df_cot %>% 
  filter(is.na(ten_closed)==FALSE, is.na(ca_year)==FALSE, ca_year > 2016) %>%
  group_by(ca_year, buyer_type_bi) %>%
  summarize(aw_missing_bt = sum(which(aw_missing == T)) / sum(which(ten_closed >= 30))*100)


ggplot(aw_missing_bt, aes(x = ca_year, y = aw_missing_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())


###new buyer id
aw_missing_byid <- df_cot %>% 
  filter(is.na(ten_closed)==FALSE, is.na(new_buyer_id)==FALSE, ca_year > 2016) %>%
  group_by(new_buyer_id) %>%
  summarize(aw_missing_byid = sum(which(aw_missing == T)) / sum(which(ten_closed >= 30))*100)

ggplot(aw_missing_byid, aes(x=aw_missing_byid, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.5, fill="tomato3", na.rm = TRUE) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


summary(aw_missing_byid$aw_missing_byid)
#49.8%

################################################################

#Percent of awards which are older than 30 days, but whose contract is not published
#awards/id, awards/date, contracts/id, contracts/documents/documentType (=contractNotice), meta-data/date

###there is no information on contract notice, only contract document type available is feasibility study


################################################################


#Percent of tenders with linked procurement plans
#tender/id, tender/documents/documentType (=procurementPlan)

#could not calculate this indicator due to lack of adequate information on procurement plans 

########################################################

#Quality and Completeness of Information

#Mean number of days between award date and date of publication of award information on portal
#awards/id, awards/date, awards/value/amount, awards/suppliers/identifier/id OR awards/suppliers/name, meta-data/date
###award date and award publication date are not available, use variable'ten_closed' instead, which is the period between tender/end/date and contract/start/date
##use df_cot2, years 2010 and 2011 excluded

df_cot2$ten_closed <- as.numeric(df_cot2$ten_closed)

summary(df_cot2$ten_closed)
#17 days

mean(is.na(df_cot2$ten_closed))
#27%


###procurement category
tencl_mean <- df_cot %>% 
  filter(is.na(ca_year)==FALSE, is.na(ten_closed)==FALSE, ca_year > 2011) %>%
  group_by(ca_year, rec_com_ten_procCat) %>%
  summarise(tencl_mean = mean(ten_closed))

ggplot(tencl_mean, aes(x = ca_year, y = tencl_mean, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())



###buyer type
tencl_mean_bt <- df_cot %>% 
  filter(is.na(ca_year)==FALSE, is.na(ten_closed)==FALSE, ca_year > 2011) %>%
  group_by(ca_year, buyer_type_bi) %>%
  summarise(tencl_mean_bt = mean(ten_closed))


ggplot(tencl_mean_bt, aes(x = ca_year, y = tencl_mean_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())


tencl_mean_byid <- df_cot %>% 
  filter(is.na(new_buyer_id)==FALSE, is.na(ten_closed)==FALSE, ca_year > 2011) %>%
  group_by(new_buyer_id) %>%
  summarise(tencl_mean_byid = mean(ten_closed))

summary(tencl_mean_byid$tencl_mean_byid)
#14.8 days

length(which(tencl_mean_byid$tencl_mean_byid > 20))
tencl_mean_byid$tencl_mean_byid1 <- tencl_mean_byid$tencl_mean_byid
tencl_mean_byid$tencl_mean_byid1[tencl_mean_byid$tencl_mean_byid1 > 20] <- NA

ggplot(tencl_mean_byid, aes(x=tencl_mean_byid1, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.03, fill="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x = element_text(angle=65, vjust=0.5))




##########################################################
#Value for Money

#Mean percent overrun of contracts that exceed budget
#planning/budget/amount/amount OR tender/value/amount OR awards/value/amount, contracts/implementation/transactions/amount
#OCDS data, filter for 2017-2018

df_cot1718$cost_overrun <- df_cot1718$rec_com_ca_vamount - df_cot1718$rec_com_aw_vamount
summary(df_cot1718$cost_overrun)
length(which(df_cot1718$cost_overrun < 0))
length(which(df_cot1718$cost_overrun > 0))
#very few cases

df_cot1718$cost_overrun_ptg <- (df_cot1718$cost_overrun/df_cot1718$rec_com_ca_vamount)*100
length(which(df_cot1718$cost_overrun_ptg < 0))

df_cot1718$cost_overrun_ptg[df_cot1718$cost_overrun_ptg < 0] <- NA

mean(is.na(df_cot1718$cost_overrun_ptg))
summary(df_cot1718$cost_overrun_ptg)


###procurement category
cost_overrun <- df_cot %>% 
  filter(is.na(ca_year)==FALSE, is.na(cost_overrun_ptg)==FALSE, cost_overrun_ptg > 0, ca_year > 2016) %>%
  group_by(ca_year, rec_com_ten_procCat) %>%
  summarise(cost_overrun = mean(cost_overrun_ptg))


ggplot(cost_overrun, aes(x = ca_year, y = cost_overrun, group=rec_com_ten_procCat)) + 
  geom_line(aes(color = rec_com_ten_procCat), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +  
  theme(panel.grid.minor = element_blank())


###buyer type
cost_overrun_bt <- df_cot %>% 
  filter(is.na(ca_year)==FALSE, is.na(cost_overrun_ptg)==FALSE, cost_overrun_ptg > 0, ca_year > 2016) %>%
  group_by(ca_year, buyer_type_bi) %>%
  summarise(cost_overrun_bt = mean(cost_overrun_ptg))

ggplot(cost_overrun_bt, aes(x = ca_year, y = cost_overrun_bt, group=buyer_type_bi)) + 
  geom_line(aes(color = buyer_type_bi), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  theme(panel.grid.minor = element_blank())

###new buyer id
cost_overrun_byid <- df_cot %>% 
  filter(is.na(new_buyer_id)==FALSE, is.na(cost_overrun_ptg)==FALSE, cost_overrun_ptg > 0, ca_year > 2016) %>%
  group_by(new_buyer_id) %>%
  summarise(cost_overrun_byid = mean(cost_overrun_ptg))

summary(cost_overrun_byid$cost_overrun_byid)
length(which(cost_overrun_byid$cost_overrun_byid > 30))
cost_overrun_byid$cost_overrun_byid1 <- cost_overrun_byid$cost_overrun_byid

cost_overrun_byid$cost_overrun_byid1[cost_overrun_byid$cost_overrun_byid1 > 30] <- NA


ggplot(cost_overrun_byid, aes(x=cost_overrun_byid1, y=new_buyer_id)) + 
  geom_bar(stat="identity", width=.2, fill="tomato3", na.rm = TRUE) + 
  scale_y_continuous(limits = c(0,300)) +
  theme(axis.text.x=element_text(angle=65, vjust=0.6))


summary(cost_overrun_byid$cost_overrun_byid)
#21.1%

length(which(cost_overrun_byid$cost_overrun_byid > 30))
#22

######################################

#Percent of contracts completed by contract end date
#contracts/id, contracts/period/endDate, contracts/status, meta-data/date

table(df_cot$rec_com_ca_status) 
summary(df_cot$rec_com_ca_endDate)


#####no info on implementation date, difference of the two deadlines cannot be calculated

length(which(df_cot$rec_com_ca_status == "active" & df_cot$rec_com_ca_endDate1 < "2018-10-31"))
#10298 obs, the other active contracts' expected completion date did not expire yet 


