# Read data from text and create data frame
unique_data <- read.table('c:/Users/veyse/Desktop/Machine Learning/Proje/Skin_NonSkin.txt',header = TRUE) 

isSkinDataSet <- unique_data[!duplicated(unique_data),]



# Convert integer into factor for target feature values
isSkinDataSet$Skin <- as.factor(isSkinDataSet$Skin)


str(isSkinDataSet)

table(isSkinDataSet$Skin)

#Data Partition
set.seed(1234)
#Create partitions in the Iris data set (60% for training, 40% for testing/evaluation)
isSkinDataSet_sample <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.6)
isSkinDataSet_train <- isSkinDataSet[isSkinDataSet_sample, ] #Select the 60% of rows
isSkinDataSet_test <- isSkinDataSet[-isSkinDataSet_sample, ] #Select the 40% of rows


table_count <- table(isSkinDataSet_train$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Train Dataset  ", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)


table_count <- table(isSkinDataSet_test$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Test Dataset", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)


library(party)

tree <- ctree(Skin ~., data = isSkinDataSet_train )
tree

plot(tree)


#predict

predict1 <- predict(tree,isSkinDataSet_test)

tab2 <- table(predict1,isSkinDataSet_test$Skin)
sum(diag(tab2)) / sum(tab2)
(tab2[1] / (tab2[1] + tab2[3])) # Precision
(tab2[1] / (tab2[1] + tab2[2])) # Recall

# Cross Validation For Party Library

#Cross-validation version - Construct a new bayes for different partitions of the samples - 100 times

dt_acc <- numeric()
dt_precision <- numeric()
dt_recall <- numeric()

set.seed(1815850)

for(i in 1:100)
{
  sub <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.60, replace = T)
  validate_train <- isSkinDataSet[sub, ]
  validate_test <- isSkinDataSet[-sub,]
  validate_tree <- ctree(Skin ~., data = validate_train )
  validate_predict <- predict(validate_tree,validate_test)
  tab_valid <- table(validate_predict,validate_test$Skin)
  dt_acc <- c(dt_acc, sum(diag(tab_valid)) / sum(tab_valid))
  dt_precision <- c(dt_precision, (tab_valid[1] / (tab_valid[1] + tab_valid[3])) )
  dt_recall <- c(dt_recall,(tab_valid[1] / (tab_valid[1] + tab_valid[2])))
}

mean(dt_acc) #Average accuracy of naive model after 100 iterations
plot(dt_acc, type="l", ylab="Accuracy Rate", xlab="Iterations", main="Accuracy Rate for SkinDataSet With Different Subsets of Data")

mean(dt_precision)
plot(dt_precision, type="l", ylab="Precision Rate", xlab="Iterations", main="Precision Rate for SkinDataSet With Different Subsets of Data")

mean(dt_recall)
plot(dt_recall, type="l", ylab="Recall Rate", xlab="Iterations", main="Recall Rate for SkinDataSet With Different Subsets of Data")

#Accuracy





#with rpart
library(rpart)

tree1 <- rpart(Skin ~. , isSkinDataSet_train)

library(rpart.plot)

rpart.plot(tree1)

predict2 <- predict(tree1, isSkinDataSet_test, type = 'class')

table(predicted = predict2, actual = isSkinDataSet_test$Skin)


# Cross Validation For rpart Library


dt_acc <- numeric()
dt_precision <- numeric()
dt_recall <- numeric()

set.seed(1815850)

for(i in 1:100)
{
  sub <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.60, replace = T)
  validate_train <- isSkinDataSet[sub, ]
  validate_test <- isSkinDataSet[-sub,]
  validate_tree <- rpart(Skin ~. , validate_train)
  validate_predict <- predict(validate_tree,validate_test, type = 'class')
  tab_valid <- table(validate_predict,validate_test$Skin)
  dt_acc <- c(dt_acc, sum(diag(tab_valid)) / sum(tab_valid))
  dt_precision <- c(dt_precision, (tab_valid[1] / (tab_valid[1] + tab_valid[3])) )
  dt_recall <- c(dt_recall,(tab_valid[1] / (tab_valid[1] + tab_valid[2])))
}

mean(dt_acc) #Average accuracy of naive model after 100 iterations
plot(dt_acc, type="l", ylab="Accuracy Rate", xlab="Iterations", main="Accuracy Rate for SkinDataSet With Different Subsets of Data")

mean(dt_precision)
plot(dt_precision, type="l", ylab="Precision Rate", xlab="Iterations", main="Precision Rate for SkinDataSet With Different Subsets of Data")

mean(dt_recall)
plot(dt_recall, type="l", ylab="Recall Rate", xlab="Iterations", main="Recall Rate for SkinDataSet With Different Subsets of Data")

#Accuracy



