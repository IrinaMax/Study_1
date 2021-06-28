# This script PayPal study case, using two data sets provided pp_cust_data.csv and subscriber_data_sample.csv
# Author Irina Max. Principal Data Scientist
library(dplyr)
library(corrplot)
library(ggplot2)
setwd('/Users/irinamax/Documents/R/Experiments/vendor_case_study_updated/')
#-------------------------Part 1.Uploading data and explore --------------------
pp <- read.csv('/Users/irinamax/Documents/R/Experiments/vendor_case_study_updated/pp_cust_data.csv')
pp %>% head
pp %>% dim       # Data has 2172 rows and 3 col
pp %>% str       # active_send and active_receive has binary structure
pp %>% summary   # but different mean, where we can see senders more active
sum(is.na(pp))   # not missing value

#How many active users in PP list who buying and selling
pp_a<- pp %>%  filter((active_send %in% 1), (active_receive %in% 1))
pp_a %>% head(10)
pp_a %>% dim  ##  here is 832  active used in the PP list

# How many not active?
pp_ch<- pp %>%  filter((active_send %in% 0), (active_receive %in% 0))
pp_ch %>% head(10)
pp_ch %>% dim   # 254 unactive users, or I would call them churned

# ratio in PP list is 254/832 = 0.3052885
paste("Ratio of Churn users in pp table during last year: ", length( pp_ch[,1])/length(pp_a[,1]))

# In histogram of PP list I can see magority are sending users active and there churn is not big
qplot(x =pp$active_send, fill=..count.., geom="histogram",main = 'Distribution of active senders in PP' )
qplot(x =pp$active_receive, fill=..count.., geom="histogram", main = 'Distribution of active receivers in PP')
# Most of the people churning are user who making receiving transection

#Uploading and explore sc Vendor list
sc <- read.csv('/Users/irinamax/Documents/R/Experiments/vendor_case_study_updated/subscriber_data_sample.csv')
sc %>% head
sc %>% summary
#We have 679 users in Vendor list, but we dont know who of them had PayPal transections.

#How much subcsrubers in every industry on the Vendor list
sc_count <- sc %>% group_by(sc$industry ) %>% count 
sc_count   # The list of the 20 industries and numbers of users in every one

ggplot(sc, aes(sc$industry,  fill= factor(industry))) +geom_bar(stat = "count")+coord_flip()+
  ggtitle("Number of customers by industry in Vendor list")

#On the Boxplot we can see the mean of site visits by industry on the Vendor list
ggplot(sc, aes(x = industry, y = site_visits, fill =as.factor(industry))) +
  geom_boxplot() +scale_y_log10()+
  ggtitle("Vendor customers site visits by industry")

# We have list of 20 idustries include one '' empty or Unknown spot, but this spot is not NA
sum(is.na(sc))  # we have not any missing value

# -----------------------Part 2. Analysis of merged table-------------------------------------
# I want to know how many subscribers are in the Vendor list using PayPal.
# For this purpose I will merge tables by emails, and R going to catch it automatically
df <- merge(sc, pp)
df %>% dim  
# only 135 subscribes from Vendor list using PayPal with 6 columns
# I can verify outcome with another possible way just for to check out dimentions
df_check <- sc %>% inner_join(pp, by ='email_address')   
df_check %>% dim
# the same result 135 with 6 columns

# Total, max and min site visits of Active senders using PP payment by industry, sorted descending order
df %>%group_by(df$industry, active_send=1 ) %>% summarise(total_visit = sum(site_visits )) %>% arrange(-total_visit)
df %>% group_by(industry, active_send=1) %>% summarise(max = max(site_visits )) %>% arrange(-max)
df %>% group_by(industry, active_send=1) %>% summarise(min = min(site_visits )) %>% arrange(-min)
# Total,max and min site visits of Not active senders PP payment by industry, sorted descending order
df %>%group_by(df$industry, active_send=0 ) %>% summarise(total_visit = sum(site_visits )) %>% arrange(-total_visit)
df %>% group_by(industry, active_send=0) %>% summarise(max = max(site_visits )) %>% arrange(-max)
df %>% group_by(industry, active_send=0) %>% summarise(min = min(site_visits )) %>% arrange(-min)

# Active receivers paiment total, max and min
df %>% group_by(industry, active_receive=1) %>% summarise(total = sum(site_visits , na.rm = T)) %>% arrange(-total)
df %>%  group_by(industry, active_receive=1) %>% summarise(max = max(site_visits , na.rm = T)) %>% arrange(-max)
df %>%  group_by(industry, active_receive=1) %>% summarise(min = min(site_visits , na.rm = T)) %>% arrange(-min)
# Not active receivers paiment total, max and min
df %>% group_by(industry, active_receive=0) %>% summarise(total = sum(site_visits , na.rm = T)) %>% arrange(-total)
df %>%  group_by(industry, active_receive=0) %>% summarise(max = max(site_visits , na.rm = T)) %>% arrange(-max)
df %>%  group_by(industry, active_receive=0) %>% summarise(min = min(site_visits , na.rm = T)) %>% arrange(-min)


# What industry mostly loosing PayPal subscrubers from Vendor list, Visualisation of churm PayPal users in Vendor by industry
ggplot(df) +geom_bar(aes(x = df$industry, fill = active_send, position = "dodge")) + coord_flip()+  # senders
  ggtitle("Churn PayPal senders  during last yearby industry")
ggplot(df) +geom_bar(aes(x = df$industry, fill = active_receive, position = "dodge"))+ coord_flip() + # receivers
  ggtitle("Churn PayPal receivers during last yearby industry")


#------------------------Part 3. Merhing separately active and not active users-----------------
# Find all submitters in Vendor list who not active in PayPal during last year and churned
# create list of Active senders and receivers inPP list
pp_ch<- pp %>%  filter((active_send %in% 0), (active_receive %in% 0)) 
# Merge with Vendor list
df_ppch <-  merge(sc, pp_ch)
df_ppch %>% dim       # There are 55 submitters from Vendor list  who used to use PayPal but not use it anymore
df_ppch %>%  summary  # We can see in summary some of them have long relationship with PayPay but churned for some reason
df_ppch$site_visits %>% sum  
# That's mean PayPal missing 53326 site visits, because this transectionsnot did not us PayPal last year

# 1. I would recomeded to send them some News letter or promotion to return them to business
# 2. Investgate: why long time submitters like more then 5 years churned last year and May be 
# PayPal need to use agressive marketing tools or direct contact, or call to return them back 
# 3. Optional: investigate the reason why they moved or using the other website for transactions.

# Churned PayPal cusomers during last year by industry from Vendor list in table and Visualization
df_ppch %>%  group_by(industry) %>% count 
ggplot(df_ppch) +geom_bar(aes(x = industry, fill = "count", position = "dodge"))+coord_flip()+
  ggtitle("Churn PayPal customers during last yearby industry")

#---------------------------------Active Senders and Receivers-------------
# Fild submiters in Vendor list, who are activly sending and receiving using PayPal
pp_a<- pp %>%  filter((active_send %in% 1), (active_receive %in% 1))
df_ppa <- merge(sc, pp_a)   # all submitters using PayPal in the vendor list

df_ppa %>% dim  #  only 8 submitters still using PayPal
ggplot(df_ppa) +geom_bar(aes(x = industry, fill = active_receive, position = "dodge"))+coord_flip()+
  ggtitle("Barplot who actively Sending and receiving")
# PayPal must be happy to keep them and better stimulate/appreciate these users with loyalry rewards and etc.

#-----------------------------  only PP Senders------------------------------
pp_s<- pp %>%  filter((active_send %in% 1), (active_receive %in% 0))
pp_s %>% dim  # 865 only senders using PP for sending payment though PP but not resiving 

df_pps <- merge(sc, pp_s)
df_pps %>% dim   # we have 39 submitters from Vendor list sender on the vendor list who no recived anything in last year
df_pps %>% head 
#We can sum out all sending transections using PayPal in Vendor list
df_pps$site_visits %>% sum  # 33136
#Visualisation
ggplot(df_pps) +geom_bar(aes(x = industry, fill = active_send, position = "dodge"))+coord_flip() +
  ggtitle("Barplot PayPal Active Senders on Vendor list ")
#-------------------------------only PP Receivers--------------------------
pp_r<- pp %>%  filter((active_send %in% 0), (active_receive %in% 1))  # filter only recivers fro PP
pp_r %>% dim  # we have 221 in the Vendor list 

df_ppr <-  merge(sc,pp_r)
df_ppr %>% dim # 33 subscriber from the vendor list only reciving payment using PP
#We can sum out all receiving transections using PayPal in Vendor list
df_ppr$site_visits %>% sum  #  10677
#Visualisation
ggplot(df_ppr) +geom_bar(aes(x = industry, fill = active_receive, position = "dodge"))+coord_flip()+ 
  ggtitle("Barplot Active Receivers by industry on Vendor list")
#----------------------   --Calculate Attrition Rate----------------------------------------------------

# I can Calculate Attrition rate base of the data I explored
55/135
#[1] 0.4074074   # 40% is very high Attrition rate
paste("Churn Rate or Attrittion Rate of PayPal users in Vendor list during last year: ", length( df_ppch[,1])/length(df[,1]))
#"Ratio of Churn PayPal users in Vendor list during last year:  0.407407407407407"
# This number can be improved by Churn prevention with counting Prabability to Churn, but here is not enouch information.


# -------------------------Part 4. Creating columns with Churn and Model Churn prediction---------------       
#
# Creating churn column where not active subscribers are "0"
df$churn <- ifelse(df$active_send == 0 & df$active_receive==0, 0, 1)
df %>% head

df %>%  group_by(churn) %>% count
ggplot(df) + geom_bar(aes(x = churn)) +ggtitle("Churn subscribers")  #We can see how big actual churn PayPal users according Vendor information


library(corrplot)
df$industry %>% str
#df %>% select_if((is.numeric)) %>%  cor %>% corrplot::corrplot()
# try spearman
cor.m <-  data.matrix(df)
df.cor <-  cor(cor.m, use = "pairwise.complete.obs", method= "spearman")            
df.cor %>% corrplot::corrplot()
# Corralation shows how Churn column depended from Senders and receivers

# Creating Logistic Regression model for predict Churn in Vendor list
#install.packages('rms')
library (rms)

set.seed(55)
ind <- sample(2, nrow(df), replace = T, prob = c(0.8, 0.2))
train <- df[ind == 1,]
test <- df[ind == 2,]
logModel <- glm(churn ~ site_visits  +relationship_length +active_send+active_receive, family = binomial, train)
logModel        

#Prediction on 20% test
pred <- predict(logModel,type = "response", test, na.action =na.exclude )
head(pred)
pred <- round(pred)
(tab1 <-  table(test$churn,  pred))
1 - sum(diag(tab1/sum(tab1)))  # missclassification error is "0", accuracy 100%

# Also can calculate accuracy by recall and F1 value, which just confirm the model is good.
retrieved <- sum(pred)
precision <- sum(pred & test$churn) / retrieved
recall <- sum(pred & test$churn) / sum(test$churn)
F1 <- 2 * precision * recall / (precision + recall)
F1
recall
# Model is very accurately predicting Churn on test data but in reality with bigger data set 
# Missclassification error can be slightly different
#----------------------------------------------------------------------------------

#----------------------------------Part 5.Visualization-----------------------------
# Boxplot by site visiting separating by Churn factor
ggplot(df, aes(x = industry, y = site_visits, fill =as.factor(churn))) +
  geom_boxplot() +coord_flip() +scale_y_log10()+facet_grid(.~churn) +
  ggtitle("Boxplot of Churn by industry, number of site visits")

#The same with barplot, picture shows alert of churn visually in red color
ggplot(df, aes(x = industry, y = site_visits, fill =as.factor(churn))) +
  geom_bar(stat="identity")+coord_flip() +ggtitle("Barplot Churn by industry, number of site visits")

# Subscribers by industry base on long time of relationship
ggplot(df, aes(x = industry, y =relationship_length , fill = as.factor(churn))) +
  geom_boxplot()+coord_flip() +ggtitle("Churn subscribers by industry base on long time of relationship")

#  ---------------------------Part 6. Using churn factor as class---------------------------------
# Based on the Part 3, where I merged all users separately I got idea to make another column
# So I add another column "churn_s" where we can see not only churn as 1/0 but separated by class 
#  0 = Not active or churned
#  1 = only sender active
#  2 = only receiver active
#  3 = sender and receiver active
# within(df, df$churn_s <- ifelse((df$active_send == 0 & df$active_receive==0), 0,
#                                 ifelse((df$active_send == 1 & df$active_receive==0), 1,
#                                        ifelse((df$active_send == 0 & df$active_receive==1), 2, 3))) )

df1 <- df  # I will create new data frame for this purpose
df1$churn_s <- ifelse((df$active_send == 0 & df$active_receive==0), 0,
                      ifelse((df$active_send == 1 & df$active_receive==0), 1,
                             ifelse((df$active_send == 0 & df$active_receive==1), 2, 3)))

df1 %>% head
##  Now we can see all of them by facet
# churn=0 with senders=1,  receivers=2 ,  active  senders and receivers=3
# by relationship
ggplot(df1, aes(x = industry, y =relationship_length , color = as.factor(churn_s))) +
  geom_boxplot()+facet_grid(.~churn_s)+coord_flip() +
  ggtitle("Boxplot Relationship years. Facet: churn=0, senders=1, receivers=2, senders and receivers=3")
# by site visits
ggplot(df1, aes(x = industry, y = site_visits, fill =as.factor(churn_s))) +
  geom_boxplot() +coord_flip() +scale_y_log10()+facet_grid(.~churn_s)+
  ggtitle("Boxplot Site Visitors: churn=0, senders=1, receivers=2, senders and receivers=3")
#Barplot by site visits
ggplot(df1, aes(x = industry, y = site_visits, fill =as.factor(df1$churn_s))) +
  geom_bar(stat="identity")+coord_flip()+
  ggtitle("Site Visitors: churn=0, senders=1, receivers=2, senders and receivers=3")
#Barplot by site visit separated by facet
ggplot(df1, aes(x = industry, y = site_visits, fill =as.factor(df1$churn_s))) +
  geom_bar(stat="identity")+coord_flip() +facet_grid(.~churn_s)+
  ggtitle("Site Visitors: churn=0, senders=1, receivers=2, senders and receivers=3")

#-------------------Part 7. Invistigation of new possible subscribers in Vendor list-----------

# Part of the Vendor data with subscrubers who never used PayPal must have big interest for PayPal manager.
# Users in this list can be potential PayPal customers.
# Now I anti join this tables
df_rest <- sc %>% anti_join(pp, by ='email_address')   
df_rest %>% dim   # there is 544 potental new customers for PayPal!!!

# We can see how potential customers distributes across of industries
df_rest %>%  group_by(industry) %>% count 
qplot(x =df_rest$relationship_length, fill=..count.., geom="histogram")+ggtitle("Potential customers by industry in Vendor list, X = time of relationship in years")

# How much potectial transection PayPal can have form this new customers
df_rest %>% group_by(industry) %>% summarise(total = sum(site_visits , na.rm = T)) %>% arrange(-total)
# I sorted the rest of the vendor data by activity visiting site and pretty sure the first hundred or may be even more 
# will be interesting for PayPal Managment to recruit them with sending some AD letter or promotion letters to invite to PayPal
df_rest[ order(-df_rest$site_visits),] %>% head
potential_200 <- df_rest[ order(-df_rest$site_visits),] %>% head(100)
potential_200 %>% head(20)

# -----------------------Thank you for reading.------------------------------
