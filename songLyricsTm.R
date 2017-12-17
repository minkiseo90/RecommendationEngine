setwd("C:/추천시스템/songlyrics")

install.packages("tm")
install.packages("SnowballC")
library(tm)
library(SnowballC)

#import data
songLyric<-read.csv("songdata.csv", header=TRUE)
head(songLyric, 4)

#corpus
songLyric.corp <- VCorpus(VectorSource(songLyric$text))
inspect(songLyric.corp[[10]])
#전처리
songLyric.corpus1<-tm_map(songLyric.corp, removeNumbers)
songLyric.corpus1<- tm_map(songLyric.corpus1, content_transformer(tolower))
replacePunctuation <- content_transformer(function(x) {return (gsub("[[:punct:]]"," ", x))})
songLyric.corpus1<-tm_map(songLyric.corpus1, replacePunctuation)
inspect(songLyric.corpus1[[10]])
myStopwords <- c(stopwords("SMART"), stopwords("en"), "\n")
songLyric.corpus1 <- tm_map(songLyric.corpus1, removeWords, myStopwords)
inspect(songLyric.corpus1[[10]])

songLyric.corpus1  <- tm_map(songLyric.corpus1 , stripWhitespace)   
songLyric.corpus1  <- tm_map(songLyric.corpus1 , stemDocument)
songLyric.corpus1  <- tm_map(songLyric.corpus1 , PlainTextDocument)
attributes(songLyric.corpus1)

#dataframe <- data.frame(text=sapply(songLyric.corpus1, identity), stringsAsFactors=F)
#write.csv(dataframe, "songTemp.csv")

###TF-IDF
tdmat <- TermDocumentMatrix(songLyric.corpus1, control=list(weighting = function(x) weightTfIdf(x, TRUE), wordLengths=c(3,Inf)))
dim(tdmat)
tdmat <- removeSparseTerms(tdmat, 0.95)
dim(tdmat)
inspect(tdmat[1:9,1])
tfidf<-as.matrix(x=as.matrix(tdmat))

write.csv(tfidf,"tfidf.csv")
