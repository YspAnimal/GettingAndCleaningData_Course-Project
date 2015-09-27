#Sorry for my English!!!
#Load packages
library(data.table)
library(dplyr)
#set my working directory
setwd("C:/RScripts/GettingAndCleaningData_Course-Project")
#Download file, unzip it, fix date and time of downloading
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "CourseDataset.zip"
if (!file.exists(destFile)){
  download.file(URL, destfile = destFile, mode='wb')
}
if (!file.exists("./UCI HAR Dataset")){
  unzip(destFile)
}
dateDownloaded <- date()

#Start reading files
setwd("./UCI HAR Dataset")

#Reading Activity files
ActivityTest <- read.table("./test/y_test.txt", header = F)
ActivityTrain <- read.table("./train/y_train.txt", header = F)

#Reading features files
FeaturesTest <- read.table("./test/X_test.txt", header = F)
FeaturesTrain <- read.table("./train/X_train.txt", header = F)

#Reading subject files
SubjectTest <- read.table("./test/subject_test.txt", header = F)
SubjectTrain <- read.table("./train/subject_train.txt", header = F)

#reading Activity Labels information
ActivityLabels <- read.table("./activity_labels.txt", header = F)

#Reading features information
FeaturesNames <- read.table("./features.txt", header = F)

#Merging dataframes: Features Test&Train,Activity Test&Train, Subject Test&Train
FeaturesData <- rbind(FeaturesTest, FeaturesTrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)
ActivityData <- rbind(ActivityTest, ActivityTrain)

#Rename colums in ActivityData & ActivityLabels dataframes
names(ActivityData) <- "ActivityN"
names(ActivityLabels) <- c("ActivityN", "Activity")

#Get factor of Activity names
Activity <- left_join(ActivityData, ActivityLabels, "ActivityN")[, 2]

#Rename colums in SubjectData
names(SubjectData) <- "Subject"
#Rename colums in FeaturesData use column from FeaturesNames
names(FeaturesData) <- FeaturesNames$V2

#Create one large Dataset: SubjectData + Activity + Fatures dataset
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)

#Extract only the measurements on the mean and standard deviation
subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeaturesNames))
DataSet <- subset(DataSet, select=DataNames)

#Rename columns of large dataset uses descriptive activity names
names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))

#Create a second, independent tidy data set with the average of each variable for each activity and each subject
SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]

#Save this tidy dataset to local file 
write.table(SecondDataSet, file = "tidydata.txt",row.name=FALSE)

