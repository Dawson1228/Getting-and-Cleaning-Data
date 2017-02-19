#checking if file exists, if not, then create directory
#download the file from the url

if(!file.exists("./dataSet")){dir.create("./dataSet")}   
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Get_data/Dataset.zip")

#unzip dataSet to /get_data directory
unzip(zipfile="./Get_data/Dataset.zip",exdir="./Get_data")

#Reading files
# Reading trainings tables:
x_train <- read.table("./Get_data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Get_data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Get_data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./Get_data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Get_data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Get_data/UCI HAR Dataset/test/subject_test.txt")



# Reading feature vector:
features <- read.table('./Get_data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./Get_data/UCI HAR Dataset/activity_labels.txt')


#Assign column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activity_Id"
colnames(subject_train) <- "subject_Id"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_Id"
colnames(subject_test) <- "subject_Id"

colnames(activityLabels) <- c('activity_Id','activity_Type')

#merging all data in one set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#read column names:
colNames <- colnames(setAllInOne)
#Create vector for defining ID, mean and standard deviation:
  
  Mean_and_StdV <- (grepl("activity-Id" , colNames) | 
                     grepl("subject-Id" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
  )

  # 3. Uses descriptive activity names to name the activities in the data set
  setForMeanAndStdv <- setAllInOne[ , mean_and_std == TRUE]
  
  #4 Appropriately labels the data set with descriptive variable names.
  setActivity_Names <- merge(setForMeanAndStdv, activityLabels,
                                by='activity_Id',
                                all.x=TRUE)
  
  #5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  secondTidyDSet <- aggregate(. ~subject_Id + activity_Id, setActivity_Names, mean)
  secondTidyDSet <- secTidySet[order(secondTidyDSet$subject_Id, secondTidyDSet$activity_Id),]
  
  #second tidy data set in txt format
  write.table(secondTidyDSet, "secondTidyDSet.txt", row.name=FALSE)
  read.table("secondTidyDSet.txt")
