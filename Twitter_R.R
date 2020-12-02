install.packages("twitteR")|require("twitteR")
library("twitteR")
install.packages("ROAuth")
library("ROAuth")
cred <- OAuthFactory$new(consumerKey='O8jNvjq2eg8Jv64T3NrHb0RAk',
                         consumerSecret='00oixuuM1Ejebxyq6yne1dEvWe7mFVxvg7hHbGKunPUMgomnqy',
                         requestURL='https://api.twitter.com/oauth/request_token',
                         accessURL='https://api.twitter.com/oauth/access_token',
                         authURL='https://api.twitter.com/oauth/authorize')
#cred$handshake(cainfo="cacert.pem")
save(cred, file="twitter authentication.Rdata")

load("twitter authentication.Rdata")

install.packages("base64enc")
library(base64enc)

install.packages("httpuv")
library(httpuv)

setup_twitter_oauth("O8jNvjq2eg8Jv64T3NrHb0RAk", 
                    "00oixuuM1Ejebxyq6yne1dEvWe7mFVxvg7hHbGKunPUMgomnqy",
                    "529590041-W2VMazDgqCCOY5HL0zM56WianvtLPd6GdI2nhxYz",
                    "sm1IKeDbcML2TBKKrkyzzIZxX8OgWyRMbiBPkT5tlUil0")

#registerTwitterOAuth(cred)

Tweets <- userTimeline('SRKUniverse', n = 1000)

TweetsDF <- twListToDF(Tweets)
write.csv(TweetsDF, "Tweets.csv")

getwd()
#Tweets <- userTimeline('Twitter page', n = 1000, cainfo="cacert.pem")
#TweetsDF <- twListToDF(Tweets)
#write.csv(TweetsDF, "Official Channel Tweets.csv")
#handleTweets <- searchTwitter('@TwitterHandle', n = 10000, since = '2015-04-01', cainfo="cacert.pem") 
#handleTweetsDF <- twListToDF(handleTweets)
#handleTweetsMessages <- unique(handleTweetsDF$text)
#handleTweetsMessages <- as.data.frame(handleTweetsMessages)
#write.csv(handleTweetsDF, "TefalHandleTweets.csv")