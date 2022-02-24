# Will the small Young Authors data can show you any predictibal value

      > library(dplyr)
      > # Data is 2016_YA_books.csv
      > data <- read.csv(file.choose(), header = T)

      > data %>% summary
              Book.title        Author.name         Star.rating    Number.of.reviews     Length     
       Length:100         Length:100         Min.   :3.000   Min.   :   1.0    Min.   : 52.0  
       Class :character   Class :character   1st Qu.:4.000   1st Qu.:  28.0    1st Qu.:242.0  
       Mode  :character   Mode  :character   Median :4.500   Median :  74.5    Median :323.0  
                                             Mean   :4.315   Mean   : 164.6    Mean   :327.4  
                                             3rd Qu.:4.500   3rd Qu.: 179.0    3rd Qu.:400.0  
                                             Max.   :5.000   Max.   :1591.0    Max.   :793.0  
       Publisher        
      Length:100        
      Class :character  
      Mode  :character  
                   
                   
                   
     > data %>%  str
     'data.frame':	100 obs. of  6 variables:
      $ Book.title       : chr  "Mistrust" "Girl in Pieces" "Just Juliet" "Dork in Love ~ Tales of My Dorky Love Life: Teen Romance" ...
      $ Author.name      : chr  "Margaret McHeyzer" "Kathleen Glasgow" "Charlotte Reagan" "Ann Writes" ...
      $ Star.rating      : num  4.5 4.5 4.5 4.5 5 4.5 4.5 4.5 4.5 4.5 ...
      $ Number.of.reviews: int  64 139 369 9 1 11 25 218 235 57 ...
      $ Length           : int  333 418 224 122 52 231 256 338 384 496 ...
      $ Publisher        : chr  "Amazon " "Delacorte" "Inkitt" "Amazon " ...
     > pairs.panels(data)
  ![Screen Shot 2021-05-31 at 11 36 31 PM](https://user-images.githubusercontent.com/16123495/120277629-256a2500-c269-11eb-9636-2aae6be7edfb.png)   
     
     > hist(data$Star.rating)
  ![H_raiting](https://user-images.githubusercontent.com/16123495/120145791-f3898d80-c198-11eb-8c75-72a288e31660.png)
  
     > hist(data$Number.of.reviews)
  ![H_nReviews](https://user-images.githubusercontent.com/16123495/120145883-161ba680-c199-11eb-9678-f574c6260f31.png)
  
     > hist(data$Length)
  ![H_Length](https://user-images.githubusercontent.com/16123495/120145962-33507500-c199-11eb-9f7b-a2f8965a4769.png)
  
     > hist(as.numeric(as.factor(data$Publisher)))
  ![H-Publisher](https://user-images.githubusercontent.com/16123495/120146023-4e22e980-c199-11eb-8dc9-e7d722d8d9f8.png)   
     
    	 data %>%
 		 ggplot(aes(x=as.factor(Star.rating), y=Number.of.reviews, fill = as.factor(Star.rating))) +
 		 geom_boxplot() +
 		 ggtitle("Box Plot")
		 
![Screen Shot 2021-06-01 at 12 17 05 AM](https://user-images.githubusercontent.com/16123495/120282193-b68fca80-c26e-11eb-8cae-f1a7a7d08aca.png)

	data %>% ggplot(aes(x=as.factor(Star.rating), fill = as.factor(Star.rating))) +
 		 geom_density(alpha=0.8, color= 'black') +
  		ggtitle("Density Plot")
		
![Screen Shot 2021-06-01 at 12 18 14 AM](https://user-images.githubusercontent.com/16123495/120282367-dde69780-c26e-11eb-8b07-96e67d66af9b.png)		

     > # I will take subset of only successful authors
     > data1 <-  data %>%  filter(data$Star.rating >= '4.5' & data$Number.of.reviews >=100)
     > data1 %>% head(10)
                                                             Book.title      Author.name Star.rating
     1                                                   Girl in Pieces Kathleen Glasgow         4.5
     2                                                      Just Juliet Charlotte Reagan         4.5
     3                                             Tell Me Three Things    Julie Buxbaum         4.5
     4                                        The Fever Code: Book Five    James Dashner         4.5
     5  Saven Deception: Sci-Fi Alien Romance (The Saven Series Book 1)   Kelly Hartigan         4.5
     6                      Paper Princess: A Novel (The Royals Book 1)        Erin Watt         4.5
     7                                           The Sun Is Also a Star      Nicola Yoon         4.5
     8                                                  Salt to the Sea     Ruta Sepetys         4.5
     9                       Broken Prince: A Novel (The Royals Book 2)        Erin Watt         4.5
     10            The Tales of Beedle the Bard (Hogwarts Library Book)     J.K. Rowling         4.5
        Number.of.reviews Length      Publisher
     1                139    418      Delacorte
     2                369    224         Inkitt
     3                218    338      Delacorte
     4                235    384      Delacorte
     5                203    437  Siobhan Davis
     6                871    370        Amazon 
     7                241    386      Delacorte
     8                681    402 Philomel Books
     9                554    350        Timeout
     10              1591    128     Pottermore
     > data1 %>% summary
       Book.title        Author.name         Star.rating    Number.of.reviews     Length     
      Length:27          Length:27          Min.   :4.500   Min.   : 106.0    Min.   :128.0  
      Class :character   Class :character   1st Qu.:4.500   1st Qu.: 157.0    1st Qu.:305.0  
      Mode  :character   Mode  :character   Median :4.500   Median : 235.0    Median :365.0  
                                            Mean   :4.519   Mean   : 397.3    Mean   :358.6  
                                            3rd Qu.:4.500   3rd Qu.: 515.0    3rd Qu.:401.0  
                                            Max.   :5.000   Max.   :1591.0    Max.   :695.0  
       Publisher        
      Length:27         
      Class :character  
      Mode  :character  
                   
                   
                   
     > pairs.panels(data1)
   ![Screen Shot 2021-05-31 at 11 39 21 PM](https://user-images.githubusercontent.com/16123495/120277967-93165100-c269-11eb-9a75-4b1b48944360.png)
   
     > hist(data1$Star.rating)
     > hist(data1$Number.of.reviews)
     > hist(data1$Length)
     > hist(as.numeric(as.factor(data1$Publisher)))
   Correlation is actually the best to begin with any valiable selection. Correlation on full dataset did not appoint any strong correlation with Star.Rating.
   I would determine strong is more then 50%. The signal unfortunately very week.
   
     > cor.mat <- data.matrix(data)
     > dd.cor <-  cor(cor.mat)
     > dd.cor
     
![dd cor](https://user-images.githubusercontent.com/16123495/120144687-3e0a0a80-c197-11eb-9916-ebd732e2952c.png)

   Examining only successful authors I can see nice signal of Book.title and also from Length
   Number of review not indicate any strong correlation, but slightly with Author.name and Length
   
    > cor.mat1 <- data.matrix(data1)
    > dd.cor1 <-  cor(cor.mat1)
    > dd.cor1
![dd cor1](https://user-images.githubusercontent.com/16123495/120144694-419d9180-c197-11eb-88a7-ace1afd82e5e.png)

    > library(corrplot)
    > corrplot(dd.cor)
    > corrplot(dd.cor1)
    
  ![Cor M1](https://user-images.githubusercontent.com/16123495/120144586-07cc8b00-c197-11eb-84c3-2c8777976b39.png)
  ![Cor M2](https://user-images.githubusercontent.com/16123495/120144680-39dded00-c197-11eb-884f-073f8fd3b402.png)
  
  To confirm my outcome I will leverage Analsysis of variance
   
    > #anova on all data clearly indicate correlation with Number of review and author.name
    > lmod <- lm(data$Star.rating~ data$Number.of.reviews+data$Author.name+ data$Length + data$Author.name , data)
    > anova(lmod)
    Analysis of Variance Table

     Response: data$Star.rating
                             Df Sum Sq Mean Sq    F value Pr(>F)    
     data$Number.of.reviews  1  0.138 0.13804 1.7909e+30 <2e-16 ***
     data$Author.name       95 15.690 0.16515 2.1426e+30 <2e-16 ***
     data$Length             1  0.000 0.00000 2.4000e+00 0.2615    
     Residuals               2  0.000 0.00000                      
     ---
     Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
     Warning message:
     In anova.lm(lmod) :
       ANOVA F-tests on an essentially perfect fit are unreliable
     > # anova on the high rating just proving significance of Author.name and nothing with Length
     > # It's mean when authors already popular the book size do not have a big matter
     > lmod1 <- lm(data1$Star.rating~ data1$Author.name+ data1$Length , data1)
     > lmod1 %>% anova()
     Analysis of Variance Table

     Response: data1$Star.rating
                  Df  Sum Sq  Mean Sq    F value Pr(>F)    
     data1$Author.name 24 0.24074 0.010031 3.4926e+31 <2e-16 ***
     data1$Length       1 0.00000 0.000000 4.1620e-01 0.6352    
     Residuals          1 0.00000 0.000000                      
     ---
     Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
     Warning message:
     In anova.lm(.) : ANOVA F-tests on an essentially perfect fit are unreliable
     > plot(lmod1$residuals)  # plot of residuals mostly ZERO except of few data points
     > #anova on number of review have not significant evidence with any column
     > lmod2 <- lm(data1$Number.of.reviews~ data1$Star.rating+ data1$Author.name+ data1$Length, data1)
     > lmod2 %>% anova()
     Analysis of Variance Table

     Response: data1$Number.of.reviews
                       Df  Sum Sq Mean Sq F value Pr(>F)
     data1$Star.rating  1   60947   60947  2.2604 0.3737
     data1$Author.name 23 3627201  157704  5.8489 0.3169
     data1$Length       1   25266   25266  0.9371 0.5103
     Residuals          1   26963   26963               
     > #anova with successful autors submitting some evidence of Length column where p=0.01
     > #lmod3 <- lm( data1$Star.rating~data1$Author.name  , data1)
     > plot(lmod$residuals)  # plot of residuals mostly ZERO except of few data points
     > #T-test is statistically usually mostly clear as alternative parametric test I can rely for pairwise dependency
     > t.test(data$Star.rating, data$Length, var.equal = T)  #p-value < 2.2e-16,Length is significant for the rating

          	Two Sample t-test

     data:  data$Star.rating and data$Length
     t = -27.832, df = 198, p-value < 2.2e-16
     alternative hypothesis: true difference in means is not equal to 0
     95 percent confidence interval:
      -346.0194 -300.2306
     sample estimates:
     mean of x mean of y 
         4.315   327.440 

     > t.test(data$Number.of.reviews, data$Length, var.equal = T)  #p-value < 2.2e-16, Length is significant also for the

	     Two Sample t-test

     data:  data$Number.of.reviews and data$Length
     t = -5.6909, df = 198, p-value = 4.501e-08
     alternative hypothesis: true difference in means is not equal to 0
     95 percent confidence interval:
      -219.3346 -106.4454
     sample estimates:
     mean of x mean of y 
        164.55    327.44 

     > t.test(data$Star.rating, data$Number.of.reviews, var.equal = T)  # p  4.809e-09

        	Two Sample t-test

     data:  data$Star.rating and data$Number.of.reviews
     t = -6.1246, df = 198, p-value = 4.809e-09
       alternative hypothesis: true difference in means is not equal to 0
     95 percent confidence interval:
      -211.8282 -108.6418
     sample estimates:
     mean of x mean of y 
         4.315   164.550 

	> # Kruskal Wallis is non parametric rank test and outcome usually weaker then t-test
	> # but I try to check it out to compare P value, where Length is smallest but still did not significant.
	> kruskal.test(data$Star.rating~ data$Length, data =data)

		Kruskal-Wallis rank sum test

	data:  data$Star.rating by data$Length
	Kruskal-Wallis chi-squared = 85.153, df = 78, p-value = 0.2712

	> kruskal.test(data$Star.rating~ data$Book.title, data =data)

		Kruskal-Wallis rank sum test

	data:  data$Star.rating by data$Book.title
	Kruskal-Wallis chi-squared = 99, df = 99, p-value = 0.4811

	> kruskal.test(data$Star.rating~ data$Author.name, data =data)

		Kruskal-Wallis rank sum test

	data:  data$Star.rating by data$Author.name
	Kruskal-Wallis chi-squared = 99, df = 95, p-value = 0.369

	> kruskal.test(data$Star.rating~ data$Publisher, data =data)

		Kruskal-Wallis rank sum test

	data:  data$Star.rating by data$Publisher
	Kruskal-Wallis chi-squared = 55.948, df = 55, p-value = 0.439

	> #Let's see the Wicoxson result
	> wilcox.test(data$Star.rating, data$Length)

		Wilcoxon rank sum test with continuity correction

	data:  data$Star.rating and data$Length
	W = 0, p-value < 2.2e-16
	alternative hypothesis: true location shift is not equal to 0

	> wilcox.test(data$Star.rating, as.numeric(as.factor(data$Author.name)))

		Wilcoxon rank sum test with continuity correction

	data:  data$Star.rating and as.numeric(as.factor(data$Author.name))
	W = 460, p-value < 2.2e-16
	alternative hypothesis: true location shift is not equal to 0

	> wilcox.test(data$Star.rating, as.numeric(as.factor(data$Publisher)))

		Wilcoxon rank sum test with continuity correction

	data:  data$Star.rating and as.numeric(as.factor(data$Publisher))
	W = 1886, p-value = 1.343e-14
	alternative hypothesis: true location shift is not equal to 0


	> # Wilcoxon test also confirming significance of  Length column
	> # confirming significant level of Author name and some effect of Publisher, but this is Nonparametric test and I would not rely on it without the other testing.

# Examining Publishers for impact of success:

     data1 %>% group_by(data1$Publisher) %>% count()
     # A tibble: 19 x 2
	# Groups:   data1$Publisher [19]
	   `data1$Publisher`                   n
	   <chr>                           <int>
	 1 "Amazon "                           2
	 2 "Atheneum/Caitlyn Dlouhy Books"     1
	 3 "Bloomsbury USA Childrens"          1
	 4 "Delacorte"                         5
	 5 "Disney Hyperion"                   1
 	 6 "Disney Lucasfilm Press"            1
 	 7 "Dreamscape Publishing"             2
 	 8 "Entangled: Teen"                   1
 	 9 "Flatiron Books"                    1
	10 "Greenwillow Books"                 1
	11 "Harlequin Teen"                    1
	12 "HarperCollins Publishers"          2
	13 "Inkitt"                            1
	14 "Philomel Books"                    2
	15 "Pottermore"                        1
	16 "Simon and Schuster"                1
	17 "Siobhan Davis"                     1
	18 "Skyscrape"                         1
	19 "Timeout"

     ggplot(data1)+ geom_bar(aes(data1$Publisher))
     
   ![Screen Shot 2021-05-31 at 4 47 34 PM](https://user-images.githubusercontent.com/16123495/120249484-e9ff3480-c22f-11eb-9217-88118b30b052.png)  
 
 The top 5 of Publishers for successful authors are 
 "Delacorte",  "HarperCollins Publishers", "Amazon ", "Dreamscape Publishing" and "Philomel Books",
 and there is some influence to get better rating but to work with Publisher have still very low hypothesis of success.
 
	 # the  publisher density visualisation
	data1 %>% ggplot(aes(x=as.factor(Star.rating), fill = as.factor(Publisher))) +
  		geom_density(alpha=0.8, color= 'black') +
 		 ggtitle("Density Plot")
		 
![Screen Shot 2021-06-01 at 12 20 06 AM](https://user-images.githubusercontent.com/16123495/120282768-58171c00-c26f-11eb-971e-f5120bfa4b1e.png)
		 
