## Get the Data
#Download the Data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
#Unzip the folder
unzip(zipfile="./data/Dataset.zip",exdir="./data")
#Assign path to the UCI HAR Dataset folder and get files
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)

##Read the Data from files in UCI HAR Dataset
#Read the files
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)

subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

featuresTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)

##Merge the data
#Merge the training and test data
activity <- rbind(activityTrain, activityTest)
subject <- rbind(subjectTrain, subjectTest)
features <- rbind(featuresTrain, featuresTest)

#Add column names to activity, subject, and features
names(activity) <- c("activity")
names(subject) <- c("subject")
featureColNames <- read.table(file.path(path, "features.txt"), header = FALSE)
names(features) <- featureColNames$V2

#merge activity, subject, and features
Data <- cbind(activity,subject,features)

##Extract only the measurements on the mean and standard deviation for each measurement
subFeatureColNames<-featureColNames$V2[grep("mean\\(\\)|std\\(\\)", featureColNames$V2)]
#Subset Data by subFeatureColNames and Subject and Activity
select <- c(as.character(subFeatureColNames),"subject","activity")
Data <- subset(Data, select = select)

##Apply descriptive labels to activities
activityLabels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])

##Label Data Set with Descrive Variable Names
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Create tidy data set with the average of each variable for each activity and each subject
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

library(knitr)
knit2html("codebook.Rmd");