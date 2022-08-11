
# Read data from text and create data frame
data <- read.table('c:/Users/veyse/Desktop/Machine Learning/Proje/Skin_NonSkin.txt',header = TRUE)
isSkinDataSet <- data[!duplicated(data),]


class(isSkinDataSet) # class of data.frame
View(isSkinDataSet)


isSkinDataSet$Skin <- as.factor(isSkinDataSet$Skin)


str(isSkinDataSet)

table(isSkinDataSet$Skin)

#Data Partition
set.seed(123)
#Create partitions in the Iris data set (60% for training, 40% for testing/evaluation)
isSkinDataSet_sample <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.6)
isSkinDataSet_train <- isSkinDataSet[isSkinDataSet_sample, ] #Select the 70% of rows
isSkinDataSet_test <- isSkinDataSet[-isSkinDataSet_sample, ] #Select the 30% of rows



table_count <- table(isSkinDataSet_train$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Train Dataset  ", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)



table_count <- table(isSkinDataSet_test$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Test Dataset  ", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)

library(randomForest)
library(caret)

set.seed(222)
rf <- randomForest(Skin ~., data = isSkinDataSet_train, ntree = 100,
                    mtry = 2,
                   
                   importance = T)

rf <- randomForest(Skin ~., data = isSkinDataSet_train)
                   
                

print(rf)



attributes(rf)




plot(rf)

#Tune mtry
t <- tuneRF(isSkinDataSet_train[,-4],isSkinDataSet_train[,4],
       stepFactor = 0.5,
       plot = T,
       ntreeTry = 100,
       trace = T,
       improve = 0.05)


#No. of nodes for the trees
hist(treesize(rf),
     main = 'No. of nodes for the Trees',
     col = 'green')


#Variable Importance
varImpPlot(rf,
           sort = T,
           n.var = 3,
           main = 'Variable Importance Graph')
#The first graph (Mean Decrease Accuracy) tests how worse the model performs
#without each of the variable.

#The second graph (Main Decrease Gini) measures how pure the nodes are at the end
#of the tree without each variable.

importance(rf)
varUsed(rf)


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
        validate_randomForest_model <-  randomForest(Skin ~., data = validate_train, ntree = 100,  mtry = 2)
                                                     
        p2 <- predict(validate_randomForest_model,validate_test)
        tab_valid <- table(p2,validate_test$Skin)
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

#Precision
#Our model has a precision of 0.5-in other words, when it predicts a tumor is malignant, 
#it is correct 50% of the time.


#Recall
#Our model has a recall of 0.11-in other words, it correctly identifies 11% of all malignant tumors.





