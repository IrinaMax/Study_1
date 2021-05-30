# devtools::install_github("JBGruber/highlightr")
library(highlightr)
library(tidytext)
library(syuzhet)
library(stringr)
library(tidytext)
text <- "I try to highlight some words in the sentence. I love data science, but this is definetely not a  data science procedure..."

# create function with  array of some specific words and colors we wanted to highlight it

df <- data.frame(feature = c("highlight some words", "data science","definetely", "procedure"),
  bg_colour = c("pink", "yellow", "lightblue","lightgreen"),
  stringsAsFactors = FALSE
)
# convert df to dict
dict <- as_dict(df)
# highligh 
highlight(text, dict)
#-------------------------
#text <- "Good old-fashioned buy-and-hold investing might not be exciting enough to interest day traders."
text <-  "Good old-fashioned buy-and-hold investing might not be exciting enough to interest day traders. But it can nevertheless produce exciting longer-term returns and beat out newfangled strategies."
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



#------------------------------------------------end--------------------
