# Read data from text and create data frame
data  <- read.table('c:/Users/veyse/Desktop/Machine Learning/Proje/Skin_NonSkin.txt',header = TRUE)
isSkinDataSet <- data[!duplicated(data),]

class(isSkinDataSet) # class of data.frame
View(isSkinDataSet)

class(isSkinDataSet$Skin)
class(isSkinDataSet$B)
class(isSkinDataSet$G)
class(isSkinDataSet$R)


library(naivebayes)
library(dplyr)
library(ggplot2)
library(psych)
library(tidyverse)
library(caret)
library(caretEnsemble)
library(Amelia)
library(mice)
library(GGally)
library(rpart)
library(randomForest)
library(ROSE)

isSkinDataSet$Skin <- as.factor(isSkinDataSet$Skin)


str(isSkinDataSet)

#Check Target Feature's Count for All Values of B, G, R 
xtabs(~B + Skin , data = isSkinDataSet)
xtabs(~Skin + G, data = isSkinDataSet)
xtabs(~Skin + R, data = isSkinDataSet)

pairs.panels(isSkinDataSet)

pairs.panels(isSkinDataSet[1:3],
             gap = 0,
             bg = c("blue","white")[isSkinDataSet$Skin],
             pch = 21)


table_count <- table(isSkinDataSet$Skin)
count_bp <- barplot(table_count, main="Value Distribution of Skin-Nonskin Dataset", xlab="Skin Values",ylab = "Counts",beside = T,
        col = c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)        


table_count <- table(data$Skin)
count_bp <- barplot(table_count, main="Value Distribution of Skin-Nonskin Dataset", xlab="Skin Values",ylab = "Counts",beside = T,
                    col = c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3) 


#Check if any values are missing
missmap(isSkinDataSet)

#Check relations of descriptive features between themselves
isSkinDataSet %>%
  ggplot(aes(x = Skin, y = B, fill = Skin)) +
  geom_boxplot() + 
  ggtitle('Box Plot')

isSkinDataSet %>%
  ggplot(aes(x = Skin, y = G, fill = Skin)) +
  geom_boxplot() + 
  ggtitle('Box Plot')

isSkinDataSet %>%
  ggplot(aes(x = Skin, y = R, fill = Skin)) +
  geom_boxplot() + 
  ggtitle('Box Plot')

isSkinDataSet %>%
  ggplot(aes(x = Skin, y = R, fill = Skin)) +
  geom_point() + 
  ggtitle('Box Plot')

isSkinDataSet %>%
  ggplot(aes(x = B, fill = Skin)) +
  geom_density(alpha = 0.8, color = 'black') + 
  ggtitle('Density Plot for B')

isSkinDataSet %>%
  ggplot(aes(x = G, fill = Skin)) +
  geom_density(alpha = 0.8, color = 'black') + 
  ggtitle('Density Plot for G')

isSkinDataSet %>%
  ggplot(aes(x = R, fill = Skin)) +
  geom_density(alpha = 0.8, color = 'black') + 
  ggtitle('Density Plot for R')









set.seed(4985912) #Set the seed for reproducibility
#Create partitions in the Iris data set (60% for training, 40% for testing/evaluation)
isSkinDataSet_sample <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.6)
isSkinDataSet_train <- isSkinDataSet[isSkinDataSet_sample, ] #Select the 60% of rows
isSkinDataSet_test <- isSkinDataSet[-isSkinDataSet_sample, ] #Select the 40% of rows


table(isSkinDataSet_train$Skin)



table_count <- table(isSkinDataSet_train$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Skin-Nonskin Train Dataset  ", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)



table_count <- table(isSkinDataSet_test$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Skin-Nonskin Test Dataset  ", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)





#Kernel based densities may perform better when numerical variables are not normally distrubited.
naive_model <- naive_bayes(Skin ~., data = isSkinDataSet_train,usekernel  = T)
naive_model

plot(naive_model)


isSkinDataSet_train %>%
  filter(Skin == "1") %>%
  summarise(mean(G),sd(G))





#Confusion matrix - Test Data
p2 <- predict(naive_model, isSkinDataSet_test)
(tab2 <- table(p2, isSkinDataSet_test$Skin))
sum(diag(tab2)) / sum(tab2)
(tab2[1] / (tab2[1] + tab2[3])) # Precision
(tab2[1] / (tab2[1] + tab2[2])) # Recall
  




#Cross-validation version - Construct a new bayes for different partitions of the samples - 100 times

dt_acc <- numeric()
dt_precision <- numeric()
dt_recall <- numeric()

set.seed(1815850)

for(i in 1:100)
{
  sub <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.60)
  validate_train <- isSkinDataSet[sub, ]
  validate_test <- isSkinDataSet[-sub,]
  validate_naive_model <-  naive_bayes(Skin ~., data = validate_train, usekernel = T)
  p1 <- predict(validate_naive_model,validate_test)
  tab_valid <- table(p1,validate_test$Skin)
  dt_acc <- c(dt_acc, sum(diag(tab_valid)) / sum(tab_valid))
  dt_precision <- c(dt_precision, (tab_valid[1] / (tab_valid[1] + tab_valid[3])) )
  dt_recall <- c(dt_recall,(tab_valid[1] / (tab_valid[1] + tab_valid[2])))
}

mean(dt_acc) #Average accuracy of naive model after 100 iterations
plot(dt_acc, type="l", ylab="Accuracy Rate", xlab="Iterations", main="Accuracy Rate for SkinDataSet With Different Subsets of Data - Naive Bayes")

mean(dt_precision)
plot(dt_precision, type="l", ylab="Precision Rate", xlab="Iterations", main="Precision Rate for SkinDataSet With Different Subsets of Data - Naive Bayes")

mean(dt_recall)
plot(dt_recall, type="l", ylab="Recall Rate", xlab="Iterations", main="Recall Rate for SkinDataSet With Different Subsets of Data - Naive Bayes")

#Accuracy

#Precision
#Our model has a precision of 0.5-in other words, when it predicts a tumor is malignant, 
#it is correct 50% of the time.


#Recall
#Our model has a recall of 0.11-in other words, it correctly identifies 11% of all malignant tumors.






#.	Apply a cross-validation scheme while training and evaluating the model performance.
#.	Change model parameters to observe if there is a performance improvement on the classification task. 
#.	Report performance of the models by using different evaluation metrics e.g., accuracy, precision, recall, etc.
#.	Write down a project report which should describe the data set, pre-processing steps, machine learning models, parameter tuning, performance results with plots.
#.	Prepare a short presentation (8-10 minutes) to explain your data set, data cleaning stages, machine learning models, parameter tuning, results etc.












