
#set directory
setwd("C:/Users/Bertold/Downloads/columbia-extra/merge/")
getwd()


#checking current memory limit
memory.limit()
#setting a bigger one
memory.limit(30000)

df_col <- read.csv("C:/Users/Felhasználó/Downloads/df_col_psrem.csv", header = TRUE, sep = ",")

#check and set types of variables 
sapply(df_col, class)

df_col[df_col == ""] <- NA


df_col$ca_startDate <- as.character(df_col$ca_startDate)
df_col$ca_startDate <- as.Date(df_col$ca_startDate, format = "%d/%m/%Y")
df_col$ca_endDate <- as.character(df_col$ca_endDate)
df_col$ca_endDate <- as.Date(df_col$ca_endDate, format = "%d/%m/%Y")
df_col$ten_endDate_x <- as.character(df_col$ten_endDate_x)
df_col$ten_endDate <- df_col$ten_endDate_x
df_col$ten_endDate <- as.Date(df_col$ten_endDate, format = "%Y-%m-%d")
df_col$ten_endDate_x <- NULL
df_col$aw_startDate <- df_col$aw_startDate_x
df_col$aw_startDate <- as.character(df_col$aw_startDate)
df_col$aw_startDate <- as.Date(df_col$aw_startDate, format = "%Y-%m-%d")
df_col$aw_startDate <- NULL


#buyer type
df_col$buyer_level1 <- df_col$buyer_level
df_col$buyer_level1 <- ifelse(grepl("TERRITORIAL", df_col$buyer_level), "Subnational", df_col$buyer_level)
df_col$buyer_level1 <- ifelse(grepl("NACIONAL", df_col$buyer_level), "National", df_col$buyer_level1)
df_col$buyer_level1 <- ifelse(df_col$buyer_level1==2, "National", df_col$buyer_level1)

table(df_col$buyer_level1)

df_col$ten_proc_method1 <- df_col$ten_proc_method
df_col$ten_proc_method1 <- ifelse(grepl("pÃºblica", df_col$ten_proc_method1), "open", df_col$ten_proc_method1)
df_col$ten_proc_method1 <- ifelse(grepl("convenios", df_col$ten_proc_method1), "limited", df_col$ten_proc_method1)
table(df_col$ten_proc_method1)

cols <- c(1,3,4,6,7,9,11,14,15,16,18,20,22,23,26)
df_col[,cols] = lapply(df_col[,cols], as.character)

cols <- c(15,16,20,22,23)
df_col[,cols] = lapply(df_col[,cols], as.Date)

cols <- c(2,5,13)
df_col[,cols] = lapply(df_col[,cols], as.integer)

#check missing rates
sapply(df_col, function(df_col) sum(is.na(df_col)))
sapply(df_col, function(df_col) mean(is.na(df_col)))

#create a variable for contract year
df_col$ca_year <- format(as.Date(df_col$ca_startDate_x, format="%Y-%m-%d"),"%Y")
df_col$ca_year <- as.numeric(df_col$ca_year)

df_col$ca_year[df_col$ca_year > 2018] <- NA
df_col$ca_startDate_x[df_col$ca_startDate_x > "2018-12-31"] <- NA


write.csv(df_col, file = "C:/Users/Bertold/Downloads/columbia-extra/df_col1129.csv", row.names = FALSE)


#Internal Efficiency

#Mean length of tender period (days)
#tender/id, tender/tenderPeriod/startDate, tender/tenderPeriod/endDate

#create indicator - tender period
df_col$ten_period <- difftime(df_col$ten_endDate, df_col$aw_startDate, units = c("days"))
df_col$ten_period <- as.numeric(df_col$ten_period)
summary(df_col$ten_period)

#91% missing in tender dates, 81656 obs available, tender period: 62% - 0, 16.5% - negative, 20.2% - positive v.
#####IT is not calculable with such high missing rates, formulas can be used once data quality improved


df_col$ten_period1[df_col$ten_period1 < 0] <- NA

install.packages("dplyr")
library(dplyr)
submp <- df_col %>% 
  group_by(ca_id) %>%
  summarise(submp = mean(ten_period1, na.rm=TRUE))

mean(is.na(submp$submp))


summary(submp$submp)



###procurement category
submp2 <- df_col %>% 
  filter(is.na(ca_year)==FALSE, is.na(ten_period1)==FALSE, is.na(ten_item_descr_l1)==FALSE) %>%
  group_by(ca_year, ten_item_descr_l1) %>%
  summarise(submp_pc = mean(ten_period1))

install.packages("ggplot2")
library(ggplot2)

ggplot(submp2, aes(x = ca_year, y = submp_pc, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) + 
  xlab("year") +
  ylab("submission period") +
  theme(panel.grid.minor = element_blank())


###buyer type
submp_bt <- df_col %>% 
  filter(is.na(ca_year)==FALSE, is.na(ten_period1)==FALSE, is.na(buyer_level1)==FALSE) %>%
  group_by(ca_year, buyer_level1) %>%
  summarise(submp_bt = mean(ten_period1, na.rm=TRUE))


ggplot(submp_bt, aes(x = ca_year, y = submp_bt, group=buyer_level1)) + 
  geom_line(aes(color = buyer_level1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  xlab("year") +
  ylab("submission period") +
  theme(panel.grid.minor = element_blank())



###new buyer id
submp_buyid <- df_col %>% 
  filter(is.na(ca_durInDays)==FALSE) %>%
  group_by(buyer_id) %>%
  summarise(submp_buyid = mean(ca_durInDays, na.rm=TRUE))

submp_buyid$submp_buyid <- round(submp_buyid$submp_buyid)

submp_buyid$submp_buyid[submp_buyid$submp_buyid > 300] <- NA

install.packages("data.table")
library(data.table)

smp_avbuyid <- submp_buyid %>% 
  filter(is.na(submp_buyid)==FALSE) %>%
  group_by(submp_buyid) %>%
  summarise(avbuyid = uniqueN(buyer_id))


ggplot(smp_avbuyid, aes(x=submp_buyid, y=avbuyid)) + 
  geom_bar(stat="identity", width=.25, fill="tomato3") + 
  scale_y_continuous(limits = c(0,100)) +
  xlab("submission period") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


###################################

#Market Opportunity

#Percent of contracts awarded to top 10 suppliers with largest contracted totals
#awards/suppliers/identifier OR awards/suppliers/name, contracts/id, contracts/awardID, awards/value/amount OR contracts/value/amount

library(data.table)

tbl_proa_sup <- df_col %>% 
  filter(is.na(aw_sup_ident_id1)==FALSE, is.na(ca_vamount)==FALSE) %>%
  group_by(aw_sup_ident_id1, ca_year) %>%
  summarise(tbl_proa_sup = sum(ca_vamount))


tbl_proa_supy <- setDT(tbl_proa_sup)[, .(top10 = ((sum(head(sort(tbl_proa_sup,decreasing=TRUE)), n = 10))/sum(tbl_proa_sup))*100), by = list(ca_year)]

mean(is.na(tbl_proa_supy$top10))
#17.4%

summary(tbl_proa_supy$top10)
#39.2%

###procurement category
tbl_proa_sup_pc <- df_col %>% 
  filter(is.na(aw_sup_ident_id1)==FALSE, is.na(ca_vamount)==FALSE, is.na(ca_year)==FALSE) %>%
  group_by(aw_sup_ident_id1, ca_year, ten_item_descr_l1) %>%
  summarise(tbl_proa_sup_pc = sum(ca_vamount))


tbl_proa_sup_pc <- setDT(tbl_proa_sup_pc)[, .(top10p = ((sum(head(sort(tbl_proa_sup_pc,decreasing=TRUE)), n = 10))/sum(tbl_proa_sup_pc))*100), by = list(ca_year, ten_item_descr_l1)]
#df_col <- left_join(df_col, tbl_proa_sup_pc)


ggplot(tbl_proa_sup_pc, aes(x = ca_year, y = top10p, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +
  xlab("year") +
  ylab("percent of contracts awarded to top 10 suppliers") +
  theme(panel.grid.minor = element_blank())



###buyer type
tbl_proa_sup_bt <- df_col %>% 
  filter(is.na(aw_sup_ident_id)==FALSE, is.na(ca_vamount)==FALSE, is.na(ca_year)==FALSE, is.na(buyer_level)==FALSE) %>%
  group_by(aw_sup_ident_id, ca_year, buyer_level) %>%
  summarise(tbl_proa_sup_bt = sum(ca_vamount))

tbl_proa_sup_bt2 <- setDT(tbl_proa_sup_bt)[, .(top10p_bt = ((sum(head(sort(tbl_proa_sup_bt,decreasing=TRUE)), n = 10))/sum(tbl_proa_sup_bt))*100), by = list(ca_year, buyer_level)]
#df_col <- left_join(df_col, tbl_proa_sup_bt2)


ggplot(tbl_proa_sup_bt2, aes(x = ca_year, y = top10p_bt, group=buyer_level)) + 
  geom_line(aes(color = buyer_level), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  xlab("year") +
  ylab("percent of contracts awarded to top 10 suppliers") +
  theme(panel.grid.minor = element_blank())


###new buyer id
tbl_proa_sup_buyerid <- df_col %>% 
  filter(is.na(aw_sup_ident_id1)==FALSE, is.na(ca_vamount)==FALSE) %>%
  group_by(aw_sup_ident_id1, buyer_id) %>%
  summarise(tbl_proa_sup_buyerid = sum(ca_vamount))

tbl_proa_supy_buyerid <- setDT(tbl_proa_sup_buyerid)[, .(top10p_buyerid = ((sum(head(sort(tbl_proa_sup_buyerid,decreasing=TRUE)), n = 10))/sum(tbl_proa_sup_buyerid))*100), by = list(buyer_id)]
#df_col <- left_join(df_col, tbl_proa_supy_buyerid, by = "new_buyer_id")


summary(tbl_proa_supy_buyerid$top10p_buyerid)
#75%

tbl_proa_supy_buyerid$top10p_buyerid[tbl_proa_supy_buyerid$top10p_buyerid > 100] <- NA
tbl_proa_supy_buyerid$top10p_buyerid <- round(tbl_proa_supy_buyerid$top10p_buyerid)

top_avbuyid <- tbl_proa_supy_buyerid %>% 
  filter(is.na(top10p_buyerid)==FALSE) %>%
  group_by(top10p_buyerid) %>%
  summarise(topbuyid = uniqueN(buyer_id))

ggplot(top_avbuyid, aes(x=top10p_buyerid, y=topbuyid)) + 
  geom_bar(stat="identity", width=.3, fill="tomato3", na.rm = T) + 
  scale_y_continuous(limits = c(0,100)) +
  xlab("percent of contracts awarded to top 10 suppliers") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))



#######################

#Mean number of tenders (awards) per supplier
#tender/id, awards/suppliers/identifier/id OR awards/suppliers/name
#used award_id as no tender_id was available

ten_count <- df_col %>%
  group_by(aw_sup_ident_id1) %>%
  summarise(t_count = uniqueN(ca_id))

ten_count$t_count[ten_count$t_count > 1000] <- NA
summary(ten_count$t_count)
#3.53
mean(is.na(ten_count$t_count))
#0.01%

#procurement category
t_count <- df_col %>%
  filter(is.na(ca_id)==FALSE, is.na(aw_sup_ident_id1)==FALSE, is.na(ten_item_descr_l1)==FALSE) %>%
  group_by(aw_sup_ident_id1, ca_year, ten_item_descr_l1) %>%
  summarise(t_count = uniqueN(ca_id))

t_count_m <- t_count %>%
  group_by(ca_year, ten_item_descr_l1) %>%
  summarise(t_mcount = mean(t_count))

ggplot(t_count_m, aes(x = ca_year, y = t_mcount, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) + 
  xlab("year") +
  ylab("mean number of tenders") +
  theme(panel.grid.minor = element_blank())


#buyer_level
ten_count_bt <- df_col %>%
  filter(is.na(ca_id)==FALSE, is.na(aw_sup_ident_id1)==FALSE, is.na(ca_year)==FALSE) %>%
  group_by(aw_sup_ident_id1, ca_year, buyer_level) %>%
  summarise(t_count_bt = uniqueN(ca_id))

ten_count_btm <- ten_count_bt %>%
  filter(is.na(buyer_level)==FALSE) %>%
  group_by(ca_year, buyer_level) %>%
  summarise(t_mcount_bt = mean(t_count_bt))

  
ggplot(ten_count_btm, aes(x = ca_year, y = t_mcount_bt, group=buyer_level)) + 
  geom_line(aes(color = buyer_level), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  xlab("year") +
  ylab("mean number of tenders") +
  theme(panel.grid.minor = element_blank())



#buyer ID
ten_buyid <- df_col %>% 
  filter(is.na(ca_id)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(buyer_id, aw_sup_ident_id1) %>%
  summarise(t_count_buyid = uniqueN(ca_id))

ten_buyid_btm <- ten_buyid %>%
  group_by(buyer_id) %>%
  summarise(t_mcount_b = mean(t_count_buyid))

ten_buyid_btm$t_mcount_br <- round(ten_buyid_btm$t_mcount_b, digits = 2)

ten_buyid_btm$t_mcount_br[ten_buyid_btm$t_mcount_br > 5] <- NA


awbuyid <- ten_buyid_btm %>% 
  filter(is.na(t_mcount_br)==FALSE) %>%
  group_by(t_mcount_br) %>%
  summarise(awbuyid = uniqueN(buyer_id))


ggplot(awbuyid, aes(x=t_mcount_br, y=awbuyid)) + 
  geom_bar(stat="identity", width=.01, fill="tomato3") + 
  scale_y_continuous(limits = c(0,100)) +
  xlab("mean number of tenders") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


summary(ten_buyid_btm$t_mcount_br)
#1.58 awards/supp/buyer


#######################

####Mean number of suppliers per buyer
#tender/procuringEntity/identifier/id OR tender/procuringEntity/name, awards/suppliers/identifier/id OR awards/suppliers/name

sup_buyer <- df_col %>%
  group_by(buyer_id) %>%
  summarise(sup_count = uniqueN(aw_sup_ident_id1))

sup_buyer$sup_count[sup_buyer$sup_count > 1000] <- NA
summary(sup_buyer$sup_count)
#54.49

mean(is.na(sup_buyer$sup_count))
#0.4%

sup_buyer$sup_count[sup_buyer$sup_count > 300] <- NA
sup_buyer$sup_count <- round(sup_buyer$sup_count)

sup_buyid <- sup_buyer %>% 
  filter(is.na(sup_count)==FALSE) %>%
  group_by(sup_count) %>%
  summarise(sup_buyid = uniqueN(buyer_id))


ggplot(sup_buyid, aes(x=sup_count, y=sup_buyid)) + 
  geom_bar(stat="identity", width=.25, fill="tomato3") + 
  scale_y_continuous(limits = c(0,100)) +
  xlab("mean number of suppliers") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


#procurement category
s_count_pc <- df_col %>%
  filter(is.na(aw_sup_ident_id1)==FALSE, is.na(ten_item_descr_l1)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(buyer_id, ca_year, ten_item_descr_l1) %>%
  summarise(s_count = uniqueN(aw_sup_ident_id1))

scount_mpc <- s_count_pc %>%
  group_by(ca_year, ten_item_descr_l1) %>%
  summarise(s_mcount = mean(s_count))

ggplot(scount_mpc, aes(x = ca_year, y = s_mcount, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) + 
  xlab("year") +
  ylab("mean number of suppliers") +
  theme(panel.grid.minor = element_blank())


#buyer_level
scount_bt <- df_col %>%
  filter(is.na(aw_sup_ident_id1)==FALSE, is.na(buyer_level)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(buyer_id, ca_year, buyer_level) %>%
  summarise(s_count_bt = uniqueN(aw_sup_ident_id1))

scount_btm <- scount_bt %>%
  group_by(ca_year, buyer_level) %>%
  summarise(smcount_bt = mean(s_count_bt))

ggplot(scount_btm, aes(x = ca_year, y = smcount_bt, group=buyer_level)) + 
  geom_line(aes(color = buyer_level), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) + 
  xlab("year") +
  ylab("mean number of suppliers") +
  theme(panel.grid.minor = element_blank())



#########################

#Median number of bidders per tender
#tender/id, tender/numberOfTenderers OR awards/suppliers/identifier/id OR awards/suppliers/name

df_col$nr_ofTenderers <- as.numeric(df_col$nr_ofTenderers)

bidders <- secopII %>%
    group_by(ca_id) %>%
    summarise(bidders = median(nr_ofTenderers))

summary(bidders$bidders)
#mean 2.2, median 1 for secopii  (med 1/mean 2.22) secopII
mean(is.na(bidders$bidders))
#73% secopii/0
#######cannot check with other distributions as secop ii do not have -> following formulas are only examples

#procurement category
bidders_pc <- secopII %>%
  filter(is.na(nr_ofTenderers)==FALSE, is.na(ten_item_descr_l1)==FALSE) %>%
  group_by(ca_year, ten_item_descr_l1) %>%
  summarise(bidders_pc = median(bidders_nr))


ggplot(bidders_pc, aes(x = ca_year, y = bidders_pc, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) + 
  xlab("year") +
  ylab("median number of tenderers") +
  theme(panel.grid.minor = element_blank())



#buyer level
bidders_bt <- df_col %>%
  filter(is.na(bidders_nr)==FALSE, is.na(buyer_level1)==FALSE) %>%
  group_by(ca_year, buyer_level1) %>%
  summarise(bidders_bt = median(bidders_nr))


ggplot(bidders_bt, aes(x = ca_year, y = bidders_bt, group=buyer_level1)) + 
  geom_line(aes(color = buyer_level1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) + 
  xlab("year") +
  ylab("median number of tenderers") +
  theme(panel.grid.minor = element_blank())

######no observation

#buyer ID
trs_buyer <- df_col %>%
  group_by(buyer_id) %>%
  summarise(trs_count = median(bidders_nr))

summary(trs_buyer$trs_count)
#58 med, 725 mean

trs_buyer$trs_count_br <- round(trs_buyer$trs_count)
trs_buyer$trs_count_br[trs_buyer$trs_count_br > 1500] <- NA

trs_buyid <- trs_buyer %>% 
  filter(is.na(trs_count_br)==FALSE) %>%
  group_by(trs_count_br) %>%
  summarise(trs_buyid = uniqueN(buyer_id))


ggplot(trs_buyid, aes(x=trs_count_br, y=trs_buyid)) + 
  geom_bar(stat="identity", width=.25, fill="tomato3") + 
  scale_y_continuous(limits = c(0,40)) +
  xlab("median number of tenderers") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))



########################

#Percent of tenders awarded by means of competitive procedures
#tender/id, tender/procurementMethod, awards/status
#ca_id


comp_ten <- (length(which(df_col$ten_proc_method == "open")) / length(df_col$ca_id))*100
#31%
length(which(df_col$ten_proc_method == "open"))
#363408

df_col$comp_procMethod <- ifelse(df_col$ten_proc_method == "open" & (!is.na(df_col$ten_proc_method)), "competitive", "non-comp")
length(which(df_col$comp_procMethod == "competitive"))
#363408
mean(is.na(df_col$comp_procMethod))
#0
comp <- (length(which(df_col$comp_procMethod == "competitive")) / sum(!is.na(df_col$comp_procMethod)))*100 
#31%


###procurement category
aw_com <- df_col %>% 
  filter(is.na(ca_id)==FALSE, is.na(ca_year)==FALSE, is.na(comp_procMethod)==FALSE) %>%
  group_by(comp_procMethod, ca_year, ten_item_descr_l1) %>%
  summarise(aw_com = uniqueN(ca_id))

p_aw_com <- aw_com %>% 
  group_by(ca_year, ten_item_descr_l1) %>%
  mutate(p_aw_com = (aw_com/sum(aw_com))*100)%>%
  filter(comp_procMethod == "competitive")


ggplot(p_aw_com, aes(x = ca_year, y = p_aw_com, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) + 
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())



###buyer type
aw_com_bt <- df_col %>% 
  filter(is.na(ca_id)==FALSE, is.na(ca_year)==FALSE, is.na(buyer_level)==FALSE) %>%
  group_by(comp_procMethod, ca_year, buyer_level) %>%
  summarise(aw_com_bt = uniqueN(ca_id))

p_aw_com_bt <- aw_com_bt %>% 
  group_by(ca_year, buyer_level) %>%
  mutate(p_aw_com_bt = (aw_com_bt/sum(aw_com_bt))*100) %>%
  filter(comp_procMethod == "competitive")

ggplot(p_aw_com_bt, aes(x = ca_year, y = p_aw_com_bt, group=buyer_level)) + 
  geom_line(aes(color = buyer_level), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800")) +  
  xlab("year") +
  ylab("percent of tenders") +
  theme(panel.grid.minor = element_blank())


###new buyer id
aw_com_buyerid <- df_col %>% 
  filter(is.na(ca_id)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(comp_procMethod, buyer_id) %>%
  summarise(aw_com_buyerid = uniqueN(ca_id))

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
  xlab("percent of tenders") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


summary(p_aw_com_buyerid$p_aw_com_buyerid)
#68%


###################

#Total awarded value of tenders awarded by means of competitive procedures
#tender/id, tender/value/amount, tender/procurementMethod, awards/status

tot_aw <- df_col %>%
  group_by(comp_procMethod, ca_id) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw = sum(ca_vamount)) 

mean(is.na(tot_aw$tot_aw))
#0.3%
summary(tot_aw$tot_aw)
#4.603e+08 COP


###procurement category
tot_aw_val <- df_col %>% 
  filter(is.na(ca_vamount)==FALSE, is.na(comp_procMethod)==FALSE, is.na(ca_year)==FALSE, is.na(ten_item_descr_l1)==FALSE) %>%
  group_by(comp_procMethod, ca_year, ten_item_descr_l1) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val = (sum(ca_vamount)/1000000000))


ggplot(tot_aw_val, aes(x = ca_year, y = tot_aw_val, group=ten_item_descr_l1)) + 
  geom_line(aes(color = ten_item_descr_l1), size = 2) +
  scale_color_manual(name="", 
                     values = c("#00AFBB", "#E7B800", "#D55E00")) +
  xlab("year") +
  ylab("total awarded value of tenders (billion)") +
  theme(panel.grid.minor = element_blank())


#buyer type
tot_aw_val_bt <- df_col %>% 
  filter(is.na(ca_vamount)==FALSE, is.na(comp_procMethod)==FALSE, is.na(ca_year)==FALSE, is.na(buyer_level)==FALSE) %>%
  group_by(comp_procMethod, ca_year, buyer_level) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val_bt = (sum(ca_vamount)/1000000000))

ggplot(tot_aw_val_bt, aes(x = ca_year, y = tot_aw_val_bt, group=buyer_level)) + 
  geom_line(aes(color = buyer_level), size = 2) +
  scale_color_manual(name="",
                     values = c("#00AFBB", "#E7B800")) + 
  xlab("year") +
  ylab("total awarded value of tenders (billion)") +
  theme(panel.grid.minor = element_blank())


#buyer ID
tot_aw_val_buyerid <- df_col %>% 
  filter(is.na(ca_vamount)==FALSE, is.na(comp_procMethod)==FALSE, is.na(buyer_id)==FALSE) %>%
  group_by(comp_procMethod, buyer_id) %>%
  filter(comp_procMethod == "competitive") %>%
  summarise(tot_aw_val_byid = (sum(ca_vamount)/1000000000))

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
  scale_y_continuous(limits = c(0,60)) +
  xlab("total value amount (billion)") +
  ylab("number of buyers") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6))


df_col <- left_join(df_col, tot_aw_val_buyerid, by = "buyer_id")

summary(tot_aw_val_buyerid$tot_aw_val_byid)
#14.8835 billion COP




################################
#Public Integrity

#Percent of contracts that do not have amendments
#tender/id, tender/procuringEntity/identifier/id, contracts/id, contracts/amendment/date

#there is no variable explicitly referring to amendments


######################

#Mean number of contract amendments per buyer
#tender/id, tender/procuringEntity/identifier/id OR tender/procuringEntity/name, contracts/id, contracts/amendment/date





