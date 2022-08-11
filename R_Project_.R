# Read data from text and create data frame
isSkinDataSet <- read.table('c:/Users/veyse/Desktop/Machine Learning/Proje/Skin_NonSkin.txt',header = TRUE) 

unique_data <- isSkinDataSet[!duplicated(isSkinDataSet),]
isSkinDataSet$Skin <- as.factor(isSkinDataSet$Skin)



class(isSkinDataSet) # class of data.frame
View(isSkinDataSet)



library(gplots)

heat_data <- data.matrix(isSkinDataSet_train)

heatmap(heat_data)

str(isSkinDataSet)

table(isSkinDataSet$Skin)

#Data Partition
set.seed(123)
#Create partitions in the Iris data set (60% for training, 40% for testing/evaluation)
isSkinDataSet_sample <- sample(1:nrow(isSkinDataSet), size=nrow(isSkinDataSet)*0.6)
isSkinDataSet_train <- isSkinDataSet[isSkinDataSet_sample, ] #Select the 70% of rows
isSkinDataSet_test <- isSkinDataSet[-isSkinDataSet_sample, ] #Select the 30% of rows




table_count <- table(isSkinDataSet$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Skin-Nonskin Dataset  ", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)

table_count <- table(data$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution of the Skin-Nonskin Dataset", xlab="Skin Values",ylab = "Counts",beside = T,
                    col =c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)


table_count <- table(isSkinDataSet_train$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution", xlab="Skin Values",ylab = "Counts",beside = T,
                    col = c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)  
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)



table_count <- table(isSkinDataSet_test$Skin)
percent_vec <- c(table_count[1] * 100 / (table_count[1] + table_count[2]),table_count[2] * 100 / (table_count[1] + table_count[2]))
count_bp <- barplot(table_count, main="Value Distribution", xlab="Skin Values",ylab = "Counts",beside = T,
                    col = c('lightblue','lavender') )
text(count_bp, 0, round(table_count, 1),cex=2,pos=3)
text(count_bp, 0, round(percent_vec, 1) ,cex=2,pos=1,offset = -8)





summary(isSkinDataSet)



pairs(isSkinDataSet[1:3])





##Class imbalance problem


library(ROSE)

table(isSkinDataSet$Skin)
table(isSkinDataSet_train$Skin)

## OVERSAMPLING

over <- ovun.sample(Skin ~., data = isSkinDataSet_train, method = "over",N = 77610)$data

table(over$Skin)

summary(over)

## UNDERSAMPLING

under <- ovun.sample(Skin ~., data = isSkinDataSet_train, method = "under",N = 20412)$data

table(under$Skin)

summary(under)



## Both oversampling and undersampling

both <- ovun.sample(Skin ~. , data = isSkinDataSet_train, method = "both", p = 0.5, 
                    seed = 222,
                    N = 20000)$data

table(both$Skin)







