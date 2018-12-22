getwd()
setwd('D:/R/wordcloud')
install.packages('KoNLP')
#자바를 인식하지 못할경우 경로지정
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_191')
install.packages('wordcloud')
install.packages('stringr')
install.packages('RColorBrewer')
library(KoNLP)
library(wordcloud)
library(stringr)
library(RColorBrewer)

useSejongDic()

#사전에 등록되지않은 단어 등록 
mergeUserDic(data.frame(readLines("addtext.txt"),"ncn"))

#텍스트 불러오기
txt <- readLines("카톡.txt", encoding = "UTF-8")
txt

#명사형 추출
place <- sapply(txt,extractNoun,USE.NAMES = F)
place

#우선 30개만 확인해보자
head(unlist(place),30)

#문자(한글,영어)를 제외한 기호들 삭제
cdata <- unlist(place)
place <- str_replace_all(cdata,"[^[:alpha:]]","")

#a~z, A~Z 0~9 사이의 모든 문자 삭제
cdata <- unlist(place)
place <- str_replace_all(cdata,"[A-Za-z0-9]","")

head(unlist(place),30)
#한글자는 필요없어!@
place <- Filter(function(x) {nchar(x) >= 2}, unlist(place))
head(unlist(place),30)


head(sort(place,decreasing=T),30)

#의미없는 문자 제거
place <- gsub(" ","",place)

#생각보다 의미없는 문자가 많으니 메모장에 적어두고 불러오자
gsubtext <- readLines("카톡gsub.txt")
gsubtext
#제거할 문자는 총 몇개?
cnt_txt <-length(gsubtext)
cnt_txt

#반복문을 사용하여 한번에!
i <- 1 #초기값
for(i in 1:cnt_txt){
  place <- gsub(gsubtext[i],"",place)
}

place

#테이블형태로 보자
write(unlist(place),"text3.txt")
rev <- read.table("text3.txt")
rev

#총 몇개나 될까
nrow(rev)

#단어의 빈도수 측정
wordcount <- table(rev)
wordcount
head(sort(wordcount,decreasing=T),30)

#파레트색상 //library(RColorBrewer)
palete <- brewer.pal(5,"Set2")

#워드클라우드
wordcloud(names(wordcount),freq=wordcount,scale=c(4,.5),rot.per=0.25,min.freq = 2,random.order = F, random.color = T, colors = palete)
