setwd("C:/Users/soloveynv/Documents/R Scripts")
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "CourseDataset.zip"
if (!file.exists(destFile)){
  download.file(URL, destfile = destFile, mode='wb')
  unzip(destFile)
}
dateDownloaded <- date()
setwd("C:/Users/soloveynv/Documents/R Scripts/UCI HAR Dataset")
