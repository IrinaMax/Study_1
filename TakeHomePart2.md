# How we can highlight some words in the test using library highlightr
 
     #devtools::install_github("JBGruber/highlightr")
     library(highlightr)
     library(tidytext)
     library(syuzhet)
     library(stringr)
     library(tidytext)
Let's take sentence from Wikipedia about data science and try to highlite some words.

     text <-  "Data science is an interdisciplinary field that uses scientific methods, processes, 
              algorithms and systems to extract knowledge and insights from structured and unstructured data,
              and apply knowledge and actionable insights from data."
# 
My idea is create array of some specific words and assign every word to the particular color we wanted to highlight in this sentence
    
    df <- data.frame(
          feature = c("data", "scientific methods", "structured and unstructured","actionable insights", " processes"),
          bg_colour = c("pink", "yellow", "lightblue","lightgreen", "gray"),
          stringsAsFactors = FALSE
     ) 
 Convert df to dictionary with defined color palette
 
     # 
     dict <- as_dict(df)

# Combine the text and dictionary
      highlight(text, dict)
![Screen Shot 2021-05-30 at 11 10 29 PM](https://user-images.githubusercontent.com/16123495/120147971-5f212a00-c19c-11eb-83eb-2a05085bb804.png)

 Let's try to highlight some words based on the Sentiment score. I will use for this example Lexicon "afinn". My idea is the same: find common words in lexicon form the text , created dictionary and highlight them base on the palette in this case I just appointed "default". But we can priretize some words by stronger color.
 
      text <-  "Good old-fashioned buy-and-hold investing might not be exciting enough to interest day traders. But it can nevertheless produce exciting longer-term       returns and beat out newfangled strategies."
      tokens <-  data.frame(text) %>% unnest_tokens(word, text)
      tokens
      af<- get_sentiments('afinn')
      af %>% summary

     #bn<- get_sentiments('bing')   # can be the other lexicon used as well
     #bn %>% summary
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

![Screen Shot 2021-05-30 at 11 28 19 PM](https://user-images.githubusercontent.com/16123495/120149579-c809a180-c19e-11eb-984f-6730541b96de.png)


    #------------------------------------------------end--------------------
