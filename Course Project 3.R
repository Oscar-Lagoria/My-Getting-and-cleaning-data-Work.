if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="/home/robocop/Escritorio/coursera/getting and cleaning data")

setwd("/home/robocop/Escritorio/coursera/getting and cleaning data")

# 1- Merges the training and the test sets to create one data set.
## Reading trainig tables:

x_train <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/train/subject_train.txt")

## Reading testing tables:

x_test <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/test/subject_test.txt")

## Reading features vector:

features <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/features.txt")

## Reading activity labels:

activitylabels <- read.table("/home/robocop/Escritorio/coursera/getting and cleaning data/UCI HAR Dataset/activity_labels.txt")

## Assigning columns names:

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activitylabels) <- c("activityId","activityType")

## Merging all data in one set:

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# 2- Extracts only the measurements on the mean and standard deviation for each measurement. 

## Reading columns:

colnames <- colnames(setAllInOne)

## Vector:

mean_and_std <- (grepl("activityId" , colnames) | 
                   grepl("subjectId" , colnames) | 
                   grepl("mean.." , colnames) | 
                   grepl("std.." , colnames) 
)

## Subset from setALLinOne.

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# 3- Uses descriptive activity names to name the activities in the data set:

setWithActivityNames <- merge(setForMeanAndStd, activitylabels,
                              by='activityId',
                              all.x=TRUE)

# 4- Appropriately labels the data set with descriptive variable names.

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# 5- Second tidy data set:

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
