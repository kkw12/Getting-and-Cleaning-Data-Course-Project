##import data

# File URL to download
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Local data file for zip
zipdatafile<-"./gettingandcleaningdatafile.zip"

# Directory
dirFile<-"./UCI HAR Dataset"

# Download the dataset(.zip) which does not exist
if(file.exists(zipdatafile)==FALSE){ 
  download.file(url, destfile=zipdatafile)}

# Unzip data file
if(file.exists(dirFile)==FALSE){
  unzip(zipdatafile)
}

## first assigment: merge the training and the test sets to create one data set:

Xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
Xtest<-read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
subjecttrain<-read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
subjecttest<-read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)

#merge test and training data by adding rows. 
x<-rbind(Xtrain,Xtest)
y<-rbind(ytrain,ytest)
s<-rbind(subjecttrain,subjecttest)

#clean memory by removing file
remove(Xtrain,Xtest,ytrain,ytest,subjecttrain,subjecttest)

##Second assignment: extract only the measurements on the mean and standard deviation 
##for each measurement

#step 1 assign labels these can be found in features.txt (561 names for 561 observation in x)
features<-read.table("./UCI HAR Dataset/features.txt")

#find mean and standard deviation (mean and std) in the second column
vector<-grep("mean|std",features[,2])

#apply result of vector to x
x<-x[,vector]

#add names to x
names(x)<-features[vector,2]

##Third assignment: Use descriptive activity names to name the activities in the 
##data set

##Fourth assignment: Label the dataset with descriptive activity names

#find activity names
activities<-read.table("./UCI HAR Dataset/activity_labels.txt")

#assign activity names to y
y[,1]<-activities[y[,1],2]
 
#give y and s names
names(y)<-"Activity"
names(s)<-"Subject"

#combine x, y, s by adding columns
dataset<-cbind(y,s,x)

##Fifth assignment:5.From the data set in step 4, creates a second, independent 
##tidy data set with the average of each variable for each activity and each subject. 

#aggregate function applied to determine mean for each activity and subject
yy<-aggregate(dataset,by = dataset[c("Activity","Subject")], FUN="mean")

#remove 3rd and 4rd column as mean cannot be applied to these columns
datasetmean<-yy[,-c(3,4)]

##FINAL: create tidy csv file

#write to csv to workdirectie destination
write.csv(dataset,"tidydataset.csv")
write.csv(datasetmean,"tidydatasetmean.csv")
