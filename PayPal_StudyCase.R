> # This script PayPal study case, using two data sets provided pp_cust_data.csv and subscriber_data_sample.csv
> # Author Irina Max. Principal Data Scientist
> library(dplyr)
> library(corrplot)
> library(ggplot2)
> setwd('/Users/irinamax/Documents/R/Experiments/vendor_case_study_updated/')
> #-------------------------Part 1.Uploading data and explore --------------------
> pp <- read.csv('/Users/irinamax/Documents/R/Experiments/vendor_case_study_updated/pp_cust_data.csv')
> pp %>% head
            email_address active_send active_receive
1 UQZXVWHPAR@GSLJXDZV.com           1              0
2  RLKSLDNYTDW@SIDPRQ.com           1              0
3 ONVGUCDMEACP@HMXNGE.com           1              1
4      DSMIX686@gmail.com           1              0
5    QHVKQNOGRG@DHQWP.com           1              1
6         FGA@hotmail.com           0              0
> pp %>% dim       # Data has 2172 rows and 3 col
[1] 2172    3
> pp %>% str       # active_send and active_receive has binary structure
'data.frame':	2172 obs. of  3 variables:
 $ email_address : chr  "UQZXVWHPAR@GSLJXDZV.com" "RLKSLDNYTDW@SIDPRQ.com" "ONVGUCDMEACP@HMXNGE.com" "DSMIX686@gmail.com" ...
 $ active_send   : int  1 1 1 1 1 0 1 1 1 1 ...
 $ active_receive: int  0 0 1 0 1 0 0 0 1 1 ...
> pp %>% summary   # but different mean, where we can see senders more active
 email_address       active_send     active_receive  
 Length:2172        Min.   :0.0000   Min.   :0.0000  
 Class :character   1st Qu.:1.0000   1st Qu.:0.0000  
 Mode  :character   Median :1.0000   Median :0.0000  
                    Mean   :0.7813   Mean   :0.4848  
                    3rd Qu.:1.0000   3rd Qu.:1.0000  
                    Max.   :1.0000   Max.   :1.0000  
> sum(is.na(pp))   # not missing value
[1] 0
> 
> #How many active users in PP list who buying and selling
> pp_a<- pp %>%  filter((active_send %in% 1), (active_receive %in% 1))
> pp_a %>% head(10)
             email_address active_send active_receive
1  ONVGUCDMEACP@HMXNGE.com           1              1
2     QHVKQNOGRG@DHQWP.com           1              1
3   MEAVGBKPVB@GYAEKFE.com           1              1
4  URHEUJIWCRCI@LZKSZZ.com           1              1
5  TODRSMYDRZFY@UPRWCL.com           1              1
6    ZQVCDHAZPD@GCPJBA.com           1              1
7  ZKWYJEDSDX@QBJAROOY.com           1              1
8  WMLMCJWWMRBK@EFHITG.com           1              1
9    JZTNIAMISZ@NXXLFW.com           1              1
10  ZRDIQGIEEZNT@FEKKT.com           1              1
> pp_a %>% dim  ##  here is 832  active used in the PP list
[1] 832   3
> 
> # How many not active?
> pp_ch<- pp %>%  filter((active_send %in% 0), (active_receive %in% 0))
> pp_ch %>% head(10)
                  email_address active_send active_receive
1               FGA@hotmail.com           0              0
2           UHSUDS380@gmail.com           0              0
3       SJYBRYLMKF@NTYDLZQV.com           0              0
4  outdoorlivingGLUBC@gmail.com           0              0
5               LSQII@gmail.com           0              0
6        XAFWRZEDUMJ@DSHTPY.com           0              0
7         PYVPSNVECUM@CJGHL.com           0              0
8      RFTCLEKUEDXI@RZVROQO.com           0              0
9           MBXA.MBXA@gmail.com           0              0
10    FDDCEANLVZHJ@HKFKIJUO.com           0              0
> pp_ch %>% dim   # 254 unactive users, or I would call them churned
[1] 254   3
> 
> # ratio in PP list is 254/832 = 0.3052885
> paste("Ratio of Churn users in pp table during last year: ", length( pp_ch[,1])/length(pp_a[,1]))
[1] "Ratio of Churn users in pp table during last year:  0.305288461538462"
> 
> # In histogram of PP list I can see magority are sending users active and there churn is not big
> qplot(x =pp$active_send, fill=..count.., geom="histogram",main = 'Distribution of active senders in PP' )
`stat_bin()` using `bins = 30`. Pick better value with
`binwidth`.
> qplot(x =pp$active_receive, fill=..count.., geom="histogram", main = 'Distribution of active receivers in PP')
`stat_bin()` using `bins = 30`. Pick better value with
`binwidth`.
> # Most of the people churning are user who making receiving transection
> 
> #Uploading and explore sc Vendor list
> sc <- read.csv('/Users/irinamax/Documents/R/Experiments/vendor_case_study_updated/subscriber_data_sample.csv')
> sc %>% head
                              email_address
1                            POYZ@yahoo.com
2                       VGID.VGID@yahoo.com
3                KTCGW@homeandgardenXYT.com
4 YOQUFSG.YOQUFSG@EVTlandscapearchitect.biz
5              SOSNEJAL.SOSNEJAL@DXKDhg.net
6             GGYDNEE3@homeandgardenBAHG.co
             industry relationship_length site_visits
1              garden                   2          86
2  landscape engineer                  30        2019
3     home and garden                  30         225
4 landscape architect                   4          80
5                                       4          20
6                                      12          48
> sc %>% summary
 email_address        industry         relationship_length
 Length:679         Length:679         Min.   : 1.000     
 Class :character   Class :character   1st Qu.: 2.000     
 Mode  :character   Mode  :character   Median : 5.000     
                                       Mean   : 8.931     
                                       3rd Qu.:13.000     
                                       Max.   :30.000     
  site_visits     
 Min.   :    0.0  
 1st Qu.:   28.0  
 Median :   97.0  
 Mean   :  434.2  
 3rd Qu.:  301.0  
 Max.   :16551.0  
> #We have 679 users in Vendor list, but we dont know who of them had PayPal transections.
> 
> #How much subcsrubers in every industry on the Vendor list
> sc_count <- sc %>% group_by(sc$industry ) %>% count 
> sc_count   # The list of the 20 industries and numbers of users in every one
# A tibble: 20 x 2
# Groups:   sc$industry [20]
   `sc$industry`             n
   <chr>                 <int>
 1 ""                      103
 2 "architect"              27
 3 "designer"               28
 4 "garden"                 34
 5 "gardening"              31
 6 "grower"                 29
 7 "hg"                     27
 8 "home and garden"        44
 9 "landscape architect"    29
10 "landscape designer"     28
11 "landscape engineer"     39
12 "landscaper"             15
13 "landscaping"            17
14 "nursery"                39
15 "orchard"                22
16 "outdoor"                44
17 "outdoor living"         38
18 "plants"                 25
19 "supply"                 36
20 "vineyard"               24
> 
> ggplot(sc, aes(sc$industry,  fill= factor(industry))) +geom_bar(stat = "count")+coord_flip()+
+   ggtitle("Number of customers by industry in Vendor list")
Warning message:
Use of `sc$industry` is discouraged. Use `industry` instead. 
> 
> #On the Boxplot we can see the mean of site visits by industry on the Vendor list
> ggplot(sc, aes(x = industry, y = site_visits, fill =as.factor(industry))) +
+   geom_boxplot() +scale_y_log10()+
+   ggtitle("Vendor customers site visits by industry")
Warning messages:
1: Transformation introduced infinite values in continuous y-axis 
2: Removed 23 rows containing non-finite values (stat_boxplot). 
> 
> # We have list of 20 idustries include one '' empty or Unknown spot, but this spot is not NA
> sum(is.na(sc))  # we have not any missing value
[1] 0
> 
> # -----------------------Part 2. Analysis of merged table-------------------------------------
> # I want to know how many subscribers are in the Vendor list using PayPal.
> # For this purpose I will merge tables by emails, and R going to catch it automatically
> df <- merge(sc, pp)
> df %>% dim  
[1] 135   6
> # only 135 subscribes from Vendor list using PayPal with 6 columns
> # I can verify outcome with another possible way just for to check out dimentions
> df_check <- sc %>% inner_join(pp, by ='email_address')   
> df_check %>% dim
[1] 135   6
> # the same result 135 with 6 columns
> 
> # Total, max and min site visits of Active senders using PP payment by industry, sorted descending order
> df %>%group_by(df$industry, active_send=1 ) %>% summarise(total_visit = sum(site_visits )) %>% arrange(-total_visit)
`summarise()` has grouped output by 'df$industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   df$industry [20]
   `df$industry`         active_send total_visit
   <chr>                       <dbl>       <int>
 1 "outdoor"                       1       19385
 2 "gardening"                     1       18367
 3 "landscape architect"           1       14050
 4 "landscape engineer"            1        8724
 5 "designer"                      1        8336
 6 "nursery"                       1        6084
 7 ""                              1        4673
 8 "garden"                        1        4052
 9 "outdoor living"                1        3573
10 "landscape designer"            1        2894
11 "plants"                        1        2346
12 "grower"                        1        2223
13 "landscaping"                   1        1804
14 "home and garden"               1        1761
15 "supply"                        1        1302
16 "architect"                     1        1224
17 "orchard"                       1        1209
18 "vineyard"                      1         902
19 "landscaper"                    1         195
20 "hg"                            1         134
> df %>% group_by(industry, active_send=1) %>% summarise(max = max(site_visits )) %>% arrange(-max)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_send   max
   <chr>                       <dbl> <int>
 1 "outdoor"                       1 16551
 2 "gardening"                     1 15437
 3 "landscape architect"           1 11610
 4 "designer"                      1  7924
 5 "nursery"                       1  4569
 6 "landscape engineer"            1  4350
 7 ""                              1  2106
 8 "garden"                        1  1571
 9 "outdoor living"                1  1517
10 "grower"                        1  1384
11 "landscape designer"            1  1374
12 "plants"                        1  1003
13 "landscaping"                   1   939
14 "home and garden"               1   922
15 "orchard"                       1   806
16 "supply"                        1   543
17 "architect"                     1   496
18 "vineyard"                      1   477
19 "landscaper"                    1   171
20 "hg"                            1   114
> df %>% group_by(industry, active_send=1) %>% summarise(min = min(site_visits )) %>% arrange(-min)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_send   min
   <chr>                       <dbl> <int>
 1 "landscape engineer"            1   105
 2 "designer"                      1    55
 3 "architect"                     1    47
 4 "landscaping"                   1    34
 5 "supply"                        1    25
 6 "landscaper"                    1    24
 7 "outdoor living"                1    24
 8 "nursery"                       1    21
 9 "hg"                            1    20
10 "gardening"                     1    15
11 "grower"                        1    14
12 "vineyard"                      1    11
13 "outdoor"                       1     9
14 "orchard"                       1     8
15 "landscape designer"            1     5
16 ""                              1     0
17 "garden"                        1     0
18 "home and garden"               1     0
19 "landscape architect"           1     0
20 "plants"                        1     0
> # Total,max and min site visits of Not active senders PP payment by industry, sorted descending order
> df %>%group_by(df$industry, active_send=0 ) %>% summarise(total_visit = sum(site_visits )) %>% arrange(-total_visit)
`summarise()` has grouped output by 'df$industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   df$industry [20]
   `df$industry`         active_send total_visit
   <chr>                       <dbl>       <int>
 1 "outdoor"                       0       19385
 2 "gardening"                     0       18367
 3 "landscape architect"           0       14050
 4 "landscape engineer"            0        8724
 5 "designer"                      0        8336
 6 "nursery"                       0        6084
 7 ""                              0        4673
 8 "garden"                        0        4052
 9 "outdoor living"                0        3573
10 "landscape designer"            0        2894
11 "plants"                        0        2346
12 "grower"                        0        2223
13 "landscaping"                   0        1804
14 "home and garden"               0        1761
15 "supply"                        0        1302
16 "architect"                     0        1224
17 "orchard"                       0        1209
18 "vineyard"                      0         902
19 "landscaper"                    0         195
20 "hg"                            0         134
> df %>% group_by(industry, active_send=0) %>% summarise(max = max(site_visits )) %>% arrange(-max)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_send   max
   <chr>                       <dbl> <int>
 1 "outdoor"                       0 16551
 2 "gardening"                     0 15437
 3 "landscape architect"           0 11610
 4 "designer"                      0  7924
 5 "nursery"                       0  4569
 6 "landscape engineer"            0  4350
 7 ""                              0  2106
 8 "garden"                        0  1571
 9 "outdoor living"                0  1517
10 "grower"                        0  1384
11 "landscape designer"            0  1374
12 "plants"                        0  1003
13 "landscaping"                   0   939
14 "home and garden"               0   922
15 "orchard"                       0   806
16 "supply"                        0   543
17 "architect"                     0   496
18 "vineyard"                      0   477
19 "landscaper"                    0   171
20 "hg"                            0   114
> df %>% group_by(industry, active_send=0) %>% summarise(min = min(site_visits )) %>% arrange(-min)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_send   min
   <chr>                       <dbl> <int>
 1 "landscape engineer"            0   105
 2 "designer"                      0    55
 3 "architect"                     0    47
 4 "landscaping"                   0    34
 5 "supply"                        0    25
 6 "landscaper"                    0    24
 7 "outdoor living"                0    24
 8 "nursery"                       0    21
 9 "hg"                            0    20
10 "gardening"                     0    15
11 "grower"                        0    14
12 "vineyard"                      0    11
13 "outdoor"                       0     9
14 "orchard"                       0     8
15 "landscape designer"            0     5
16 ""                              0     0
17 "garden"                        0     0
18 "home and garden"               0     0
19 "landscape architect"           0     0
20 "plants"                        0     0
> 
> # Active receivers paiment total, max and min
> df %>% group_by(industry, active_receive=1) %>% summarise(total = sum(site_visits , na.rm = T)) %>% arrange(-total)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_receive total
   <chr>                          <dbl> <int>
 1 "outdoor"                          1 19385
 2 "gardening"                        1 18367
 3 "landscape architect"              1 14050
 4 "landscape engineer"               1  8724
 5 "designer"                         1  8336
 6 "nursery"                          1  6084
 7 ""                                 1  4673
 8 "garden"                           1  4052
 9 "outdoor living"                   1  3573
10 "landscape designer"               1  2894
11 "plants"                           1  2346
12 "grower"                           1  2223
13 "landscaping"                      1  1804
14 "home and garden"                  1  1761
15 "supply"                           1  1302
16 "architect"                        1  1224
17 "orchard"                          1  1209
18 "vineyard"                         1   902
19 "landscaper"                       1   195
20 "hg"                               1   134
> df %>%  group_by(industry, active_receive=1) %>% summarise(max = max(site_visits , na.rm = T)) %>% arrange(-max)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_receive   max
   <chr>                          <dbl> <int>
 1 "outdoor"                          1 16551
 2 "gardening"                        1 15437
 3 "landscape architect"              1 11610
 4 "designer"                         1  7924
 5 "nursery"                          1  4569
 6 "landscape engineer"               1  4350
 7 ""                                 1  2106
 8 "garden"                           1  1571
 9 "outdoor living"                   1  1517
10 "grower"                           1  1384
11 "landscape designer"               1  1374
12 "plants"                           1  1003
13 "landscaping"                      1   939
14 "home and garden"                  1   922
15 "orchard"                          1   806
16 "supply"                           1   543
17 "architect"                        1   496
18 "vineyard"                         1   477
19 "landscaper"                       1   171
20 "hg"                               1   114
> df %>%  group_by(industry, active_receive=1) %>% summarise(min = min(site_visits , na.rm = T)) %>% arrange(-min)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_receive   min
   <chr>                          <dbl> <int>
 1 "landscape engineer"               1   105
 2 "designer"                         1    55
 3 "architect"                        1    47
 4 "landscaping"                      1    34
 5 "supply"                           1    25
 6 "landscaper"                       1    24
 7 "outdoor living"                   1    24
 8 "nursery"                          1    21
 9 "hg"                               1    20
10 "gardening"                        1    15
11 "grower"                           1    14
12 "vineyard"                         1    11
13 "outdoor"                          1     9
14 "orchard"                          1     8
15 "landscape designer"               1     5
16 ""                                 1     0
17 "garden"                           1     0
18 "home and garden"                  1     0
19 "landscape architect"              1     0
20 "plants"                           1     0
> # Not active receivers paiment total, max and min
> df %>% group_by(industry, active_receive=0) %>% summarise(total = sum(site_visits , na.rm = T)) %>% arrange(-total)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_receive total
   <chr>                          <dbl> <int>
 1 "outdoor"                          0 19385
 2 "gardening"                        0 18367
 3 "landscape architect"              0 14050
 4 "landscape engineer"               0  8724
 5 "designer"                         0  8336
 6 "nursery"                          0  6084
 7 ""                                 0  4673
 8 "garden"                           0  4052
 9 "outdoor living"                   0  3573
10 "landscape designer"               0  2894
11 "plants"                           0  2346
12 "grower"                           0  2223
13 "landscaping"                      0  1804
14 "home and garden"                  0  1761
15 "supply"                           0  1302
16 "architect"                        0  1224
17 "orchard"                          0  1209
18 "vineyard"                         0   902
19 "landscaper"                       0   195
20 "hg"                               0   134
> df %>%  group_by(industry, active_receive=0) %>% summarise(max = max(site_visits , na.rm = T)) %>% arrange(-max)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_receive   max
   <chr>                          <dbl> <int>
 1 "outdoor"                          0 16551
 2 "gardening"                        0 15437
 3 "landscape architect"              0 11610
 4 "designer"                         0  7924
 5 "nursery"                          0  4569
 6 "landscape engineer"               0  4350
 7 ""                                 0  2106
 8 "garden"                           0  1571
 9 "outdoor living"                   0  1517
10 "grower"                           0  1384
11 "landscape designer"               0  1374
12 "plants"                           0  1003
13 "landscaping"                      0   939
14 "home and garden"                  0   922
15 "orchard"                          0   806
16 "supply"                           0   543
17 "architect"                        0   496
18 "vineyard"                         0   477
19 "landscaper"                       0   171
20 "hg"                               0   114
> df %>%  group_by(industry, active_receive=0) %>% summarise(min = min(site_visits , na.rm = T)) %>% arrange(-min)
`summarise()` has grouped output by 'industry'. You can override using the `.groups` argument.
# A tibble: 20 x 3
# Groups:   industry [20]
   industry              active_receive   min
   <chr>                          <dbl> <int>
 1 "landscape engineer"               0   105
 2 "designer"                         0    55
 3 "architect"                        0    47
 4 "landscaping"                      0    34
 5 "supply"                           0    25
 6 "landscaper"                       0    24
 7 "outdoor living"                   0    24
 8 "nursery"                          0    21
 9 "hg"                               0    20
10 "gardening"                        0    15
11 "grower"                           0    14
12 "vineyard"                         0    11
13 "outdoor"                          0     9
14 "orchard"                          0     8
15 "landscape designer"               0     5
16 ""                                 0     0
17 "garden"                           0     0
18 "home and garden"                  0     0
19 "landscape architect"              0     0
20 "plants"                           0     0
> 
> 
> # What industry mostly loosing PayPal subscrubers from Vendor list, Visualisation of churm PayPal users in Vendor by industry
> ggplot(df) +geom_bar(aes(x = df$industry, fill = active_send, position = "dodge")) + coord_flip()+  # senders
+   ggtitle("Churn PayPal senders  during last yearby industry")
Warning messages:
1: Ignoring unknown aesthetics: position 
2: Use of `df$industry` is discouraged. Use `industry` instead. 
> ggplot(df) +geom_bar(aes(x = df$industry, fill = active_receive, position = "dodge"))+ coord_flip() + # receivers
+   ggtitle("Churn PayPal receivers during last yearby industry")
Warning messages:
1: Ignoring unknown aesthetics: position 
2: Use of `df$industry` is discouraged. Use `industry` instead. 
> 
> 
> #------------------------Part 3. Merhing separately active and not active users-----------------
> # Find all submitters in Vendor list who not active in PayPal during last year and churned
> # create list of Active senders and receivers inPP list
> pp_ch<- pp %>%  filter((active_send %in% 0), (active_receive %in% 0)) 
> # Merge with Vendor list
> df_ppch <-  merge(sc, pp_ch)
> df_ppch %>% dim       # There are 55 submitters from Vendor list  who used to use PayPal but not use it anymore
[1] 55  6
> df_ppch %>%  summary  # We can see in summary some of them have long relationship with PayPay but churned for some reason
 email_address        industry         relationship_length
 Length:55          Length:55          Min.   : 1.000     
 Class :character   Class :character   1st Qu.: 2.000     
 Mode  :character   Mode  :character   Median : 5.000     
                                       Mean   : 9.345     
                                       3rd Qu.:15.000     
                                       Max.   :30.000     
  site_visits       active_send active_receive
 Min.   :    0.0   Min.   :0    Min.   :0     
 1st Qu.:   43.5   1st Qu.:0    1st Qu.:0     
 Median :  121.0   Median :0    Median :0     
 Mean   :  969.6   Mean   :0    Mean   :0     
 3rd Qu.:  790.0   3rd Qu.:0    3rd Qu.:0     
 Max.   :15437.0   Max.   :0    Max.   :0     
> df_ppch$site_visits %>% sum  
[1] 53326
> # That's mean PayPal missing 53326 site visits, because this transectionsnot did not us PayPal last year
> 
> # 1. I would recomeded to send them some News letter or promotion to return them to business
> # 2. Investgate: why long time submitters like more then 5 years churned last year and May be 
> # PayPal need to use agressive marketing tools or direct contact, or call to return them back 
> # 3. Optional: investigate the reason why they moved or using the other website for transactions.
> 
> # Churned PayPal cusomers during last year by industry from Vendor list in table and Visualization
> df_ppch %>%  group_by(industry) %>% count 
# A tibble: 19 x 2
# Groups:   industry [19]
   industry                  n
   <chr>                 <int>
 1 ""                        9
 2 "architect"               1
 3 "designer"                2
 4 "garden"                  4
 5 "gardening"               3
 6 "grower"                  2
 7 "hg"                      1
 8 "home and garden"         1
 9 "landscape architect"     2
10 "landscape designer"      1
11 "landscape engineer"      3
12 "landscaping"             3
13 "nursery"                 3
14 "orchard"                 3
15 "outdoor"                 5
16 "outdoor living"          6
17 "plants"                  2
18 "supply"                  2
19 "vineyard"                2
> ggplot(df_ppch) +geom_bar(aes(x = industry, fill = "count", position = "dodge"))+coord_flip()+
+   ggtitle("Churn PayPal customers during last yearby industry")
Warning message:
Ignoring unknown aesthetics: position 
> 
> #---------------------------------Active Senders and Receivers-------------
> # Fild submiters in Vendor list, who are activly sending and receiving using PayPal
> pp_a<- pp %>%  filter((active_send %in% 1), (active_receive %in% 1))
> df_ppa <- merge(sc, pp_a)   # all submitters using PayPal in the vendor list
> 
> df_ppa %>% dim  #  only 8 submitters still using PayPal
[1] 8 6
> ggplot(df_ppa) +geom_bar(aes(x = industry, fill = active_receive, position = "dodge"))+coord_flip()+
+   ggtitle("Barplot who actively Sending and receiving")
Warning message:
Ignoring unknown aesthetics: position 
> # PayPal must be happy to keep them and better stimulate/appreciate these users with loyalry rewards and etc.
> 
> #-----------------------------  only PP Senders------------------------------
> pp_s<- pp %>%  filter((active_send %in% 1), (active_receive %in% 0))
> pp_s %>% dim  # 865 only senders using PP for sending payment though PP but not resiving 
[1] 865   3
> 
> df_pps <- merge(sc, pp_s)
> df_pps %>% dim   # we have 39 submitters from Vendor list sender on the vendor list who no recived anything in last year
[1] 39  6
> df_pps %>% head 
              email_address           industry
1     ACFRXBMV928@yahoo.com             grower
2     AHXEWFME354@yahoo.com landscape engineer
3 AZFAMOK.AZFAMOK@yahoo.com    home and garden
4            BRRK@gmail.com            outdoor
5          BTBKXQ@yahoo.com          gardening
6         DGF.DGF@gmail.com             plants
  relationship_length site_visits active_send active_receive
1                   8        1384           1              0
2                  12        4350           1              0
3                  15         763           1              0
4                  19       16551           1              0
5                   3          65           1              0
6                  30         817           1              0
> #We can sum out all sending transections using PayPal in Vendor list
> df_pps$site_visits %>% sum  # 33136
[1] 33136
> #Visualisation
> ggplot(df_pps) +geom_bar(aes(x = industry, fill = active_send, position = "dodge"))+coord_flip() +
+   ggtitle("Barplot PayPal Active Senders on Vendor list ")
Warning message:
Ignoring unknown aesthetics: position 
> #-------------------------------only PP Receivers--------------------------
> pp_r<- pp %>%  filter((active_send %in% 0), (active_receive %in% 1))  # filter only recivers fro PP
> pp_r %>% dim  # we have 221 in the Vendor list 
[1] 221   3
> 
> df_ppr <-  merge(sc,pp_r)
> df_ppr %>% dim # 33 subscriber from the vendor list only reciving payment using PP
[1] 33  6
> #We can sum out all receiving transections using PayPal in Vendor list
> df_ppr$site_visits %>% sum  #  10677
[1] 10677
> #Visualisation
> ggplot(df_ppr) +geom_bar(aes(x = industry, fill = active_receive, position = "dodge"))+coord_flip()+ 
+   ggtitle("Barplot Active Receivers by industry on Vendor list")
Warning message:
Ignoring unknown aesthetics: position 
> #----------------------   --Calculate Attrition Rate----------------------------------------------------
> 
> # I can Calculate Attrition rate base of the data I explored
> 55/135
[1] 0.4074074
> #[1] 0.4074074   # 40% is very high Attrition rate
> paste("Churn Rate or Attrittion Rate of PayPal users in Vendor list during last year: ", length( df_ppch[,1])/length(df[,1]))
[1] "Churn Rate or Attrittion Rate of PayPal users in Vendor list during last year:  0.407407407407407"
> #"Ratio of Churn PayPal users in Vendor list during last year:  0.407407407407407"
> # This number can be improved by Churn prevention with counting Prabability to Churn, but here is not enouch information.
> 
> 
> # -------------------------Part 4. Creating columns with Churn and Model Churn prediction---------------       
> #
> # Creating churn column where not active subscribers are "0"
> df$churn <- ifelse(df$active_send == 0 & df$active_receive==0, 0, 1)
> df %>% head
               email_address           industry
1      ACFRXBMV928@yahoo.com             grower
2      AHXEWFME354@yahoo.com landscape engineer
3       ALCNGHDT@hotmail.com landscape designer
4 architectBPNFEBC@yahoo.com          architect
5 architectYCUDSQT@yahoo.com          architect
6            AUBXC@yahoo.com           vineyard
  relationship_length site_visits active_send active_receive
1                   8        1384           1              0
2                  12        4350           1              0
3                   2           5           1              1
4                   6          47           0              0
5                   8         339           0              1
6                   7         269           0              0
  churn
1     1
2     1
3     1
4     0
5     1
6     0
> 
> df %>%  group_by(churn) %>% count
# A tibble: 2 x 2
# Groups:   churn [2]
  churn     n
  <dbl> <int>
1     0    55
2     1    80
> ggplot(df) + geom_bar(aes(x = churn)) +ggtitle("Churn subscribers")  #We can see how big actual churn PayPal users according Vendor information
> 
> 
> library(corrplot)
> df$industry %>% str
 chr [1:135] "grower" "landscape engineer" ...
> #df %>% select_if((is.numeric)) %>%  cor %>% corrplot::corrplot()
> # try spearman
> cor.m <-  data.matrix(df)
> df.cor <-  cor(cor.m, use = "pairwise.complete.obs", method= "spearman")            
> df.cor %>% corrplot::corrplot()
> # Corralation shows how Churn column depended from Senders and receivers
> 
> # Creating Logistic Regression model for predict Churn in Vendor list
> #install.packages('rms')
> library (rms)
> 
> set.seed(55)
> ind <- sample(2, nrow(df), replace = T, prob = c(0.8, 0.2))
> train <- df[ind == 1,]
> test <- df[ind == 2,]
> logModel <- glm(churn ~ site_visits  +relationship_length +active_send+active_receive, family = binomial, train)
Warning messages:
1: glm.fit: algorithm did not converge 
2: glm.fit: fitted probabilities numerically 0 or 1 occurred 
> logModel        

Call:  glm(formula = churn ~ site_visits + relationship_length + active_send + 
    active_receive, family = binomial, data = train)

Coefficients:
        (Intercept)          site_visits  relationship_length  
         -2.621e+01           -1.941e-05            7.672e-03  
        active_send       active_receive  
          5.213e+01            5.196e+01  

Degrees of Freedom: 98 Total (i.e. Null);  94 Residual
Null Deviance:	    135.5 
Residual Deviance: 9.292e-10 	AIC: 10
> 
> #Prediction on 20% test
> pred <- predict(logModel,type = "response", test, na.action =na.exclude )
> head(pred)
          11           18           22           28 
1.000000e+00 1.000000e+00 1.000000e+00 4.650429e-12 
          33           35 
5.118100e-12 1.000000e+00 
> pred <- round(pred)
> (tab1 <-  table(test$churn,  pred))
   pred
     0  1
  0 12  0
  1  0 24
> 1 - sum(diag(tab1/sum(tab1)))  # missclassification error is "0", accuracy 100%
[1] 0
> 
> # Also can calculate accuracy by recall and F1 value, which just confirm the model is good.
> retrieved <- sum(pred)
> precision <- sum(pred & test$churn) / retrieved
> recall <- sum(pred & test$churn) / sum(test$churn)
> F1 <- 2 * precision * recall / (precision + recall)
> F1
[1] 1
> recall
[1] 1
> # Model is very accurately predicting Churn on test data but in reality with bigger data set 
> # Missclassification error can be slightly different
> #----------------------------------------------------------------------------------
> 
> #----------------------------------Part 5.Visualization-----------------------------
> # Boxplot by site visiting separating by Churn factor
> ggplot(df, aes(x = industry, y = site_visits, fill =as.factor(churn))) +
+   geom_boxplot() +coord_flip() +scale_y_log10()+facet_grid(.~churn) +
+   ggtitle("Boxplot of Churn by industry, number of site visits")
Warning messages:
1: Transformation introduced infinite values in continuous y-axis 
2: Removed 6 rows containing non-finite values (stat_boxplot). 
> 
> #The same with barplot, picture shows alert of churn visually in red color
> ggplot(df, aes(x = industry, y = site_visits, fill =as.factor(churn))) +
+   geom_bar(stat="identity")+coord_flip() +ggtitle("Barplot Churn by industry, number of site visits")
> 
> # Subscribers by industry base on long time of relationship
> ggplot(df, aes(x = industry, y =relationship_length , fill = as.factor(churn))) +
+   geom_boxplot()+coord_flip() +ggtitle("Churn subscribers by industry base on long time of relationship")
> 
> #  ---------------------------Part 6. Using churn factor as class---------------------------------
> # Based on the Part 3, where I merged all users separately I got idea to make another column
> # So I add another column "churn_s" where we can see not only churn as 1/0 but separated by class 
> #  0 = Not active or churned
> #  1 = only sender active
> #  2 = only receiver active
> #  3 = sender and receiver active
> # within(df, df$churn_s <- ifelse((df$active_send == 0 & df$active_receive==0), 0,
> #                                 ifelse((df$active_send == 1 & df$active_receive==0), 1,
> #                                        ifelse((df$active_send == 0 & df$active_receive==1), 2, 3))) )
> 
> df1 <- df  # I will create new data frame for this purpose
> df1$churn_s <- ifelse((df$active_send == 0 & df$active_receive==0), 0,
+                       ifelse((df$active_send == 1 & df$active_receive==0), 1,
+                              ifelse((df$active_send == 0 & df$active_receive==1), 2, 3)))
> 
> df1 %>% head
               email_address           industry
1      ACFRXBMV928@yahoo.com             grower
2      AHXEWFME354@yahoo.com landscape engineer
3       ALCNGHDT@hotmail.com landscape designer
4 architectBPNFEBC@yahoo.com          architect
5 architectYCUDSQT@yahoo.com          architect
6            AUBXC@yahoo.com           vineyard
  relationship_length site_visits active_send active_receive
1                   8        1384           1              0
2                  12        4350           1              0
3                   2           5           1              1
4                   6          47           0              0
5                   8         339           0              1
6                   7         269           0              0
  churn churn_s
1     1       1
2     1       1
3     1       3
4     0       0
5     1       2
6     0       0
> ##  Now we can see all of them by facet
> # churn=0 with senders=1,  receivers=2 ,  active  senders and receivers=3
> # by relationship
> ggplot(df1, aes(x = industry, y =relationship_length , color = as.factor(churn_s))) +
+   geom_boxplot()+facet_grid(.~churn_s)+coord_flip() +
+   ggtitle("Boxplot Relationship years. Facet: churn=0, senders=1, receivers=2, senders and receivers=3")
> # by site visits
> ggplot(df1, aes(x = industry, y = site_visits, fill =as.factor(churn_s))) +
+   geom_boxplot() +coord_flip() +scale_y_log10()+facet_grid(.~churn_s)+
+   ggtitle("Boxplot Site Visitors: churn=0, senders=1, receivers=2, senders and receivers=3")
Warning messages:
1: Transformation introduced infinite values in continuous y-axis 
2: Removed 6 rows containing non-finite values (stat_boxplot). 
> #Barplot by site visits
> ggplot(df1, aes(x = industry, y = site_visits, fill =as.factor(df1$churn_s))) +
+   geom_bar(stat="identity")+coord_flip()+
+   ggtitle("Site Visitors: churn=0, senders=1, receivers=2, senders and receivers=3")
Warning message:
Use of `df1$churn_s` is discouraged. Use `churn_s` instead. 
> #Barplot by site visit separated by facet
> ggplot(df1, aes(x = industry, y = site_visits, fill =as.factor(df1$churn_s))) +
+   geom_bar(stat="identity")+coord_flip() +facet_grid(.~churn_s)+
+   ggtitle("Site Visitors: churn=0, senders=1, receivers=2, senders and receivers=3")
Warning message:
Use of `df1$churn_s` is discouraged. Use `churn_s` instead. 
> 
> #-------------------Part 7. Invistigation of new possible subscribers in Vendor list-----------
> 
> # Part of the Vendor data with subscrubers who never used PayPal must have big interest for PayPal manager.
> # Users in this list can be potential PayPal customers.
> # Now I anti join this tables
> df_rest <- sc %>% anti_join(pp, by ='email_address')   
> df_rest %>% dim   # there is 544 potental new customers for PayPal!!!
[1] 544   4
> 
> # We can see how potential customers distributes across of industries
> df_rest %>%  group_by(industry) %>% count 
# A tibble: 20 x 2
# Groups:   industry [20]
   industry                  n
   <chr>                 <int>
 1 ""                       84
 2 "architect"              23
 3 "designer"               25
 4 "garden"                 22
 5 "gardening"              24
 6 "grower"                 22
 7 "hg"                     25
 8 "home and garden"        39
 9 "landscape architect"    23
10 "landscape designer"     20
11 "landscape engineer"     31
12 "landscaper"             13
13 "landscaping"            13
14 "nursery"                32
15 "orchard"                17
16 "outdoor"                33
17 "outdoor living"         31
18 "plants"                 18
19 "supply"                 29
20 "vineyard"               20
> qplot(x =df_rest$relationship_length, fill=..count.., geom="histogram")+ggtitle("Potential customers by industry in Vendor list, X = time of relationship in years")
`stat_bin()` using `bins = 30`. Pick better value with
`binwidth`.
> 
> # How much potectial transection PayPal can have form this new customers
> df_rest %>% group_by(industry) %>% summarise(total = sum(site_visits , na.rm = T)) %>% arrange(-total)
# A tibble: 20 x 2
   industry              total
   <chr>                 <int>
 1 ""                    25776
 2 "landscape designer"  24729
 3 "landscaping"         22179
 4 "landscape architect" 19567
 5 "home and garden"     13614
 6 "designer"            12026
 7 "nursery"             10510
 8 "supply"               8823
 9 "outdoor living"       8620
10 "outdoor"              8212
11 "architect"            6066
12 "landscape engineer"   5213
13 "hg"                   5024
14 "grower"               4555
15 "garden"               4349
16 "gardening"            4095
17 "orchard"              2856
18 "vineyard"             2441
19 "plants"               1798
20 "landscaper"           1113
> # I sorted the rest of the vendor data by activity visiting site and pretty sure the first hundred or may be even more 
> # will be interesting for PayPal Managment to recruit them with sending some AD letter or promotion letters to invite to PayPal
> df_rest[ order(-df_rest$site_visits),] %>% head
                              email_address
28               landscapingCKBNQ@yahoo.com
350       landscapedesignerSWKPTS@yahoo.com
289      RNYZOEZN@landscapearchitectSGT.net
408                   nurseryTQVU@gmail.com
88  WAHWMBQC.WAHWMBQC@JOCBhomeandgarden.com
369                           JAL@gmail.com
               industry relationship_length site_visits
28          landscaping                  30       16227
350  landscape designer                  30       14585
289 landscape architect                  30       14041
408             nursery                  30        5862
88      home and garden                  30        3789
369                                      30        3750
> potential_200 <- df_rest[ order(-df_rest$site_visits),] %>% head(100)
> potential_200 %>% head(20)
                              email_address
28               landscapingCKBNQ@yahoo.com
350       landscapedesignerSWKPTS@yahoo.com
289      RNYZOEZN@landscapearchitectSGT.net
408                   nurseryTQVU@gmail.com
88  WAHWMBQC.WAHWMBQC@JOCBhomeandgarden.com
369                           JAL@gmail.com
462         EHQKF@HMFUlandscapedesigner.net
216             HOOQ1@LXGKoutdoorliving.com
297                  outdoorBFVIM@gmail.com
366                  UJE@QSXlandscaping.biz
110                  designerTUBU@gmail.com
136                  designerMGDU@gmail.com
479                   JFK.JFK@supplyUIHY.co
536               VJXVKHarchitect@gmail.com
17           GNTlandscapedesigner@gmail.com
207         KQKHlandscapedesigner@yahoo.com
309                 TCIQarchitect@yahoo.com
258         DTQXlandscapedesigner@yahoo.com
7       UXHPKDAlandscapearchitect@yahoo.com
111     DAHPAM.DAHPAM@NJSVhomeandgarden.biz
               industry relationship_length site_visits
28          landscaping                  30       16227
350  landscape designer                  30       14585
289 landscape architect                  30       14041
408             nursery                  30        5862
88      home and garden                  30        3789
369                                      30        3750
462  landscape designer                  30        3587
216      outdoor living                  30        3476
297             outdoor                  30        3072
366         landscaping                  30        2858
110            designer                  24        2849
136            designer                  21        2787
479              supply                  19        2680
536           architect                  30        1739
17                                       11        1709
207  landscape designer                   4        1657
309           architect                  30        1623
258  landscape designer                  23        1564
7   landscape architect                  24        1516
111     home and garden                  20        1504
> 
> # -----------------------Thank you for reading.------------------------------
