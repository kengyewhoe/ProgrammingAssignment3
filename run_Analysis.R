#Here are the data for the project:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#1.You should create one R script called run_analysis.R that does the following.
#2.Merges the training and the test sets to create one data set.
#3.Extracts only the measurements on the mean and standard deviation for each measurement.
#4.Uses descriptive activity names to name the activities in the data set
#5.Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Good luck!

#installing and loading required packages
library(data.table)
library(dplyr)

#loading data
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')
features <- read.table('./UCI HAR Dataset/features.txt')

#Loading test data
  x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Loading train data
  x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Merging train and test data
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_train, y_test)
subject <- rbind(subject_train,subject_test)

colnames(x_data)<- t(features[2])
colnames(y_data) <- "Activity"
colnames(subject) <- "Subject"
FullData <- cbind(subject , y_data, x_data)

# Extracting mean and std
selectedCols <- grep("-(mean|std).*", as.character(features[,2]))
selectedColNames <- features[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

# Giving descriptive names
x_data <- x_data[selectedCols]
colnames(FullData) <- c("Subject", "Activity", selectedColNames)

FullData$Activity <- factor(FullData$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
FullData$Subject <- as.factor(FullData$Subject)

# Generating tidy data set
meltedData <- melt(FullData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)
write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)



