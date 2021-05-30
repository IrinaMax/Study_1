# How we can highlight some words in the test using library highlightr
 
     #devtools::install_github("JBGruber/highlightr")
     library(highlightr)
     library(tidytext)
     library(syuzhet)
     library(stringr)
     library(tidytext)
     text <- "I try to highlight some words in the sentence. I love data science, but this task applied mostly to UI skills than data science."

# 
     #My idea is create array of some specific words and assign every word to the specific color we wanted to highlight in this sentence
     df <- data.frame(
       feature = c("highlight some words", "data science","applied", "UI skills"),
       bg_colour = c("pink", "yellow", "lightblue","lightgreen"),
       stringsAsFactors = FALSE
     )
# 
     Convert df to dictionary with defined color palette
     dict <- as_dict(df)

# highligh 
      highlight(text, dict)

 Let's try to highlight some words based on the Sentiment score. 
 
      text <-  "Good old-fashioned buy-and-hold investing might not be exciting enough to interest day traders. But it can nevertheless produce exciting longer-term       returns and beat out newfangled strategies."
      tokens <-  data.frame(text) %>% unnest_tokens(word, text)
      tokens
      af<- get_sentiments('afinn')
      af %>% summary

     #af<- get_sentiments('bing')
     #af %>% summary
     com_words <-tokens %>% inner_join(af)
     com_words
     df <- data.frame(
        feature = com_words$word,
        bg_colour = palette("default"),
        stringsAsFactors = FALSE
      )
     df
     #dict <- data.frame(com_w$word, bg_colour = c("pink", "yellow"),stringsAsFactors = FALSE)
      dict1 <- as_dict(df)
      highlight(text,dict1)

<img width="619" alt="Screen Shot 2021-05-29 at 11 52 45 PM" src="https://user-images.githubusercontent.com/16123495/120095561-7fd57b00-c0db-11eb-9a7f-ff944be3d4f0.png">

    #------------------------------------------------end--------------------
