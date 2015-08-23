Getting and Cleaning Data - Project
 
#Instructions for project
#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:

#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Get the data
# install the plyr package if you do not already have it. 

library(plyr);

#1.Download the file (if it does not exist) and place the file in the data folder

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#2.Unzip the downloaded file from step 1

unzip(zipfile="./data/Dataset.zip",exdir="./data")

#3.unzipped files are in the folderUCI HAR Dataset.  
# Note the path of the file

relPath <- file.path("./data" , "UCI HAR Dataset")
 
 
#2.Read data from the files into the variables

# Capture test and train activities

testActivities  <- read.table(file.path(relPath, "test" , "Y_test.txt" ),header = FALSE)
trainActivities <- read.table(file.path(relPath, "train", "Y_train.txt"),header = FALSE)

# Capture test and train activities

testSubjects  <- read.table(file.path(relPath, "test" , "subject_test.txt"),header = FALSE)
trainSubjects <- read.table(file.path(relPath, "train", "subject_train.txt"),header = FALSE)

# Capture test and train features

testFeatures  <- read.table(file.path(relPath, "test" , "X_test.txt" ),header = FALSE)
trainFeatures <- read.table(file.path(relPath, "train", "X_train.txt"),header = FALSE)
 
  
# Merge test and training data sets 


dataSubject <- rbind(trainSubjects, testSubjects)
dataActivity<- rbind(trainActivities, testActivities)
dataFeatures<- rbind(trainFeatures, testFeatures)

# Set Variable Names

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(relPath, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

# Merge columns and store in a dataframe called Data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)
 
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# Create a subset of the data frame Data by selected names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )

Data<-subset(Data,select=selectedNames)
 
activityLabels <- read.table(file.path(relPath, "activity_labels.txt"),header = FALSE)

#factorize Variable activity in the data frame using English like names for variables

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
 
#create Tidy Data Set as required

Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

 
