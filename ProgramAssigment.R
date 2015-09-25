library(data.table)
library(dplyr)
setwd("C:/Users/soloveynv/Documents/R Scripts/GettingAndCleaningData_Course-Project")
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "CourseDataset.zip"
if (!file.exists(destFile)){
  download.file(URL, destfile = destFile, mode='wb')
}
if (!file.exists("./UCI HAR Dataset")){
  unzip(destFile)
}
dateDownloaded <- date()
setwd("./UCI HAR Dataset")
ActivityTest <- read.table("./test/y_test.txt", header = F)
ActivityTrain <- read.table("./train/y_train.txt", header = F)

FeaturesTest <- read.table("./test/X_test.txt", header = F)
FeaturesTrain <- read.table("./train/X_train.txt", header = F)

SubjectTest <- read.table("./test/subject_test.txt", header = F)
SubjectTrain <- read.table("./train/subject_train.txt", header = F)

ActivityLabels <- read.table("./activity_labels.txt", header = F)

FeaturesNames <- read.table("./features.txt", header = F)


FeaturesData <- rbind(FeaturesTest, FeaturesTrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)
ActivityData <- rbind(ActivityTest, ActivityTrain)

names(ActivityData) <- "Activity"
names(ActivityLabels) <- c("ActivityN", "Activity")

#ActivityData <- join(ActivityData, ActivityLabels, "ActivityN")#[, 2]

names(SubjectData) <- "Subject"
names(FeaturesData) <- FeaturesNames$V2
#names(ActivityData) <- 


DataSet <- cbind(SubjectData, ActivityData)
DataSet <- cbind(DataSet, FeaturesData)


