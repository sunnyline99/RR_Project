## Required packages and settings

library("sandwich")
library("lmtest")
library("MASS")
library("mfx")
library("BaylorEdPsych")
library("htmltools")
library("LogisticDx")
library("aod")
library("logistf")
library("stargazer")

Sys.setenv(LANG = "en")
options(scipen = 5)

## Loading data and recoding names of variables / making sure that there is no missing observations
setwd("C:\\Users\\justy\\Desktop\\Info\\Inne\\DSC\\UW\\Semestr II\\Econometrics\\Project")
spam <- read.table("spambase.data", sep = ",")
names <- read.csv2("names.csv",header = FALSE)

names[49,1]<-"char_freq_semicolon"
names[50,1]<-"char_freq_bracket"
names[51,1]<-"char_freq_square_bracket"
names[52,1]<-"char_freq_exclamation"
names[53,1]<-"char_freq_dollar"
names[54,1]<-"char_freq_hashtag"


for(i in 1:57){
  colnames(spam)[i]<-names[i,1]
}

colnames(spam)[58] <-"spam"

spam = na.omit(spam)

## Data visualisations

perc_yes <- paste0(round(table(spam$spam[spam$spam==1])/length(spam$spam)*100, 2),"%")
perc_no <- paste0(round(table(spam$spam[spam$spam==0])/length(spam$spam)*100, 2), "%")

barplot(table(spam$spam),main="Number of spam/non-spam mails",names.arg = c(perc_no,perc_yes),col = c("#31d64f","#ed3b3b"), xlab = "Type of mail", ylab ="Frequency",
        legend("topright", legend=c("Non-spam", "Spam"), bty="n",fill=c("#ed3b3b","#31d64f")))


## General models: probit and logit


formula="spam ~"

for(i in 1:57){
  formula=paste(formula,"+",colnames(spam)[i])
}

print(formula)

myprobit <- glm(formula, data=spam, family=binomial(link="probit"))
summary(myprobit)


mylogit <- glm(formula, data=spam, family=binomial(link="logit"))
summary(myprobit)

stargazer(mylogit, myprobit, type="text")


## Testing joint significance of the models - likelihood ratio test - restriceted and unrestricted model

null_probit = glm(spam~1, data=spam, family=binomial(link="probit")) # restricted model
lrtest(myprobit, null_probit)


null_logit = glm(spam~1, data=spam, family=binomial(link="logit")) # restricted model
lrtest(mylogit, null_logit)


## Removing insignificant variables from model

p_probit <- summary(myprobit)$coefficients[,"Pr(>|z|)"]
p_logit <- summary(mylogit)$coefficients[,"Pr(>|z|)"]

spam_temp_logit <- spam
spam_temp_probit <- spam

while (any(p_probit>0.05)){
  count = 1
  worstp <- summary(myprobit)$coefficients[,4]==max(p_probit)
  for (i in worstp){
    ifelse(i==TRUE,numvar <- count-1,count<-count+1)
  }
  
  print(colnames(spam_temp_probit[numvar]))
  spam_temp_probit[,numvar] <- NULL
  
  
  formula="spam ~"
  
  
  for(i in 1:ncol(spam_temp_probit)-1){
    formula<-paste(formula,"+",colnames(spam_temp_probit)[i])
  }
  
  
  myprobit <- glm(formula, data=spam_temp_probit, family=binomial(link="probit"))
  p_probit <- summary(myprobit)$coefficients[,"Pr(>|z|)"]
  print(myprobit$aic)
  
}


while (any(p_logit>0.05)){
  count = 1
  worstp <- summary(mylogit)$coefficients[,4]==max(p_logit)
  for (i in worstp){
    ifelse(i==TRUE,numvar <- count-1,count<-count+1)
  }
  
  print(colnames(spam_temp_logit[numvar]))
  spam_temp_logit[,numvar] <- NULL
  
  
  formula="spam ~"
  
  
  for(i in 1:ncol(spam_temp_logit)-1){
    formula<-paste(formula,"+",colnames(spam_temp_logit)[i])
  }
  
  
  mylogit <- glm(formula, data=spam_temp_logit, family=binomial(link="logit"))
  p_logit <- summary(mylogit)$coefficients[,"Pr(>|z|)"]
  print(mylogit$aic)
  
}

stargazer(mylogit, myprobit, type="text")


## Linktest - making sure we have good specification H0: we have good specification (similar to ramsey reset test)

#setwd("C:\\Users\\justy\\Desktop\\Info\\Inne\\DSC\\UW\\Semestr II\\Econometrics\\Project")
source("linktest.R")
linktest_result_probit = linktest(myprobit)
summary(linktest_result_probit)


linktest_result_logit = linktest(mylogit)
summary(linktest_result_logit)


## Adding interaction terms and deleting insignificant ones for probit

formula_interactions="spam ~ word_freq_make + word_freq_address + word_freq_our + word_freq_over + word_freq_remove + word_freq_internet + word_freq_order + word_freq_free + word_freq_business + word_freq_you + word_freq_credit + word_freq_your + word_freq_000 + word_freq_money + word_freq_hp + word_freq_hpl + word_freq_george + word_freq_650 + word_freq_data + word_freq_85 + word_freq_technology + word_freq_pm + word_freq_meeting + word_freq_project + word_freq_re + word_freq_edu + word_freq_conference + char_freq_semicolon + char_freq_exclamation + char_freq_dollar + char_freq_hashtag + capital_run_length_longest + capital_run_length_total"

mylogit <- glm(formula_interactions, data=spam, family=binomial(link="probit"))

p <- summary(mylogit)$coefficients[,"Pr(>|z|)"]

j=1
while (any(p>0.05)){
  count = 1
  worstp <- summary(mylogit)$coefficients[,4]==max(p)
  for (i in worstp){
    ifelse(i==TRUE,numvar <- count-1,count<-count+1)
  }
  
  
  X = model.matrix(mylogit)
  X<-X[,-1]
  name <- colnames(X)[numvar]
  X<-X[, colnames(X) != name]
  
  colnam <- colnames(X)
  if(j!=1){
    colnam <- substr(colnam, 2, length(colnam))
  }
  colnames(X)<-colnam
  
  
  
  mylogit = glm(spam ~ X,data=spam, family=binomial(link="logit"))
  
  summary(mylogit)$coefficients
  
  p <- summary(mylogit)$coefficients[,"Pr(>|z|)"]
  print(mylogit$aic)
  print(numvar)
  j=2
  
}

## Again performing previous tests

stargazer(mylogit, type="text")

null_logit = glm(spam~1, data=spam, family=binomial(link="logit")) # restricted model
lrtest(mylogit, null_logit)

linktest_result_logit = linktest(mylogit)
summary(linktest_result_logit)




## Adding interaction terms and deleting insignificant ones for logit

formula_interactions="spam ~ word_freq_make * word_freq_address * word_freq_our + word_freq_over + word_freq_remove + word_freq_internet * word_freq_order * word_freq_free * word_freq_business + word_freq_you + word_freq_credit * word_freq_your + word_freq_000 + word_freq_money + word_freq_hp + word_freq_hpl + word_freq_george + word_freq_650 + word_freq_data + word_freq_85 + word_freq_technology + word_freq_pm + word_freq_meeting + word_freq_project + word_freq_re + word_freq_edu + word_freq_conference + char_freq_semicolon * char_freq_exclamation * char_freq_dollar * char_freq_hashtag + capital_run_length_longest + capital_run_length_total"
#formula_interactions="spam ~ word_freq_make + word_freq_address + word_freq_our + word_freq_over + word_freq_remove + word_freq_internet + word_freq_order + word_freq_free + word_freq_business + word_freq_you + word_freq_credit + word_freq_your + word_freq_000 + word_freq_money + word_freq_hp + word_freq_george + word_freq_data + word_freq_85 + word_freq_technology + word_freq_pm + word_freq_meeting + word_freq_project + word_freq_re + word_freq_edu + word_freq_conference"
mylogit <- glm(formula_interactions, data=spam, family=binomial(link="logit"))

p <- summary(mylogit)$coefficients[,"Pr(>|z|)"]

j=1
while (any(p>0.05)){
  count = 1
  worstp <- summary(mylogit)$coefficients[,4]==max(p)
  for (i in worstp){
    ifelse(i==TRUE,numvar <- count-1,count<-count+1)
  }
  
  
  X = model.matrix(mylogit)
  X<-X[,-1]
  name <- colnames(X)[numvar]
  X<-X[, colnames(X) != name]
  
  colnam <- colnames(X)
  if(j!=1){
    colnam <- substr(colnam, 2, length(colnam))
  }
  colnames(X)<-colnam
  
  
  
  mylogit = glm(spam ~ X,data=spam, family=binomial(link="logit"))
  
  summary(mylogit)$coefficients
  
  p <- summary(mylogit)$coefficients[,"Pr(>|z|)"]
  print(mylogit$aic)
  print(numvar)
  j=2
  
}

## Again performing previous tests

stargazer(mylogit, type = "html", out = "output.html")

null_logit = glm(spam~1, data=spam, family=binomial(link="logit")) # restricted model
lrtest(mylogit, null_logit)

linktest_result_logit = linktest(mylogit)
summary(linktest_result_logit)

gof.results = gof(mylogit)
gof.results$gof
library(DescTools)
PseudoR2(mylogit)

## We use atmean = FALSE, because the 

(meff = logitmfx(formula_interactions, data = spam, atmean=FALSE))


#Model based on literature
## Adding interaction terms and deleting insignificant ones for probit

formula_interactions="spam ~ word_freq_free +  word_freq_order +  word_freq_receive + char_freq_hashtag * char_freq_exclamation + 
word_freq_telnet +  word_freq_technology + word_freq_conference * word_freq_edu + word_freq_hp + 
word_freq_money + word_freq_credit +  word_freq_000 + char_freq_dollar + 
word_freq_your * word_freq_email * word_freq_address +  word_freq_people + word_freq_mail + word_freq_george + word_freq_our * word_freq_meeting"

mylogit <- glm(formula_interactions, data=spam, family=binomial(link="probit"))

p <- summary(mylogit)$coefficients[,"Pr(>|z|)"]

j=1
while (any(p>0.05)){
  count = 1
  worstp <- summary(mylogit)$coefficients[,4]==max(p)
  for (i in worstp){
    ifelse(i==TRUE,numvar <- count-1,count<-count+1)
  }
  
  
  X = model.matrix(mylogit)
  X<-X[,-1]
  name <- colnames(X)[numvar]
  X<-X[, colnames(X) != name]
  
  colnam <- colnames(X)
  if(j!=1){
    colnam <- substr(colnam, 2, length(colnam))
  }
  colnames(X)<-colnam
  
  
  
  mylogit = glm(spam ~ X,data=spam, family=binomial(link="logit"))
  
  summary(mylogit)$coefficients
  
  p <- summary(mylogit)$coefficients[,"Pr(>|z|)"]
  print(mylogit$aic)
  print(numvar)
  j=2
  
}

## Again performing previous tests
summary(mylogit)
#install.packages("sjPlot")
library("sjPlot")

sjPlotstargazer(mylogit, style = "aer", type = "html", out = "Theoretical.html")

summary(mylogit)
tab_model(mylogit, show.est = TRUE, show.aic = TRUE, show.aicc =  TRUE)

library(dplyr)
library(kableExtra)
library(broom)

tidy(mylogit) %>%  kbl(caption="Theoretical model",
                       format= "html",
                       align="r", file = "Table.doc") %>%
  kable_classic(full_width = F, html_font = "arial") %>% 
  save_kable(file = "my_latex_table.png")
null_logit = glm(spam~1, data=spam, family=binomial(link="logit")) # restricted model
lrtest(mylogit, null_logit)

linktest_result_logit = linktest(mylogit)
summary(linktest_result_logit)

me <- (meff = logitmfx(formula_interactions, data = spam, atmean=FALSE))
print(me)

stargazer(me, type = "html")
class(me)

null_logit = glm(spam~1, data=spam, family=binomial(link="logit")) # restricted model
lrtest(mylogit, null_logit)

gof.results = gof(mylogit)
gof.results$gof
PseudoR2(mylogit)


(meff = logitmfx(formula_interactions, data = spam, atmean=FALSE))
#Bad results: may be based on different results, interactions do not exist, does not take into account keywords signaling NOT spam

