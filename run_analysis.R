# Getting and Cleaning Data Course Project
#Johns Hopkins University Coursera
# Author: Joe Panzik
# Date Created: May 6, 2020

###BEFORE YOU RUN###
#Make sure unzipped Samsung data folder "UCI HAR Dataset" is in your working directory

##Project flow
#1) Check for "data.table" package and install if missing. Call "data.table" from library
#2) Load the key for the activity labels from "activity_labels.txt"
      #Neaten appearance of the label names
#3) Load list of features from "features.txt"
#4) Search for and keep features that have "mean()" or "std()" as desired quantities.
      #Neaten appearance of desired feature variable names
#5) Load the training data "X_train.txt" and filter for desired features.
      #Add column names
      #Append the corresponding Participant number and activity number for each row of observations
#6) Load the test data "X_test.txt" and filter for desired features.
      #Add column names
      #Append the corresponding Participant number and activity number for each row of observations
#7) Merge the training and test data frames
      #Reorder merged data frame by participant number then activity
      #Replace activity numbers with character description
#8) Determine mean value for each variable based on participant number AND activity
#9) Write the tidy data that has 1 mean value of the desired features for each activity for each person (30 participants x 6 activities/per participant)
      #Written to "tidydata" directory (created if not present)
      #Written to a .txt and .csv file for replication and easy of importing later



#Check to see if you have the data.table package. Install if not present.
if("data.table" %in% rownames(installed.packages()) == FALSE) {install.packages("data.table")}

#Check to see if you have the dplyr package. Install if not present.
if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr")}

#Call data.table and dplyr from library
library(data.table); library(dplyr)


##Load activity labels
#Load activity labels from "activity_labels.txt" with column names "classLabels" & "activityName"
activityLabels <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityKey", "ActivityName"))

#Neaten "activityName" strings to be all lowercase
activityLabels$ActivityName <- tolower(activityLabels$ActivityName)

#Neaten to remove "_" from string
activityLabels$ActivityName <- sub("_","", activityLabels$ActivityName)



#Load Features & select desired features
#Load features from "features.txt" with column names "index" & "featureNames"
features <- fread("UCI HAR Dataset/features.txt", col.names = c("index", "featureNames"))

#Look through "featuresNames" for values that are the "mean()" or std()" measurements based on descriptions in "features_info.txt"
#Returns the indices for those occurences and stores them in "featuresDesired"
featuresDesired <- grep("(mean|std)\\(\\)", features[, featureNames])

#Takes the indices of where the "mean()" and "std()" values are and only takes those rows in "features"
#finalFeatures only has one column: "featureName" values that correspond to the indices stored in "featuresDesired"
finalFeatures <- features[featuresDesired, featureNames]

#Removes "()" in each element of "finalFeatures"
finalFeatures <- gsub('[()]', '', finalFeatures)

#Neatens labels by changing feature names that start with "t' to "Time"
finalFeatures <-sub("^t","Time", finalFeatures)

#Neatens labels by changing feature names that start with "f' to "Fft"
finalFeatures <-sub("^f","Fft", finalFeatures)

#Neatens labels by changing feature names with "-mean" to "Mean"
finalFeatures <-sub("-mean","Mean", finalFeatures)

#Neatens labels by changing feature names with "-std" to "Std"
finalFeatures <-sub("-std","Std", finalFeatures)

#Neatens labels by removing "-" from feature names
finalFeatures <-gsub("-","", finalFeatures)

#Neatens labels by changing repetitive "BodyBody" to "Body" in feature names
finalFeatures <-sub("BodyBody","Body", finalFeatures)

#Adds "Mag" to the end of strings that have "Mag" in them
finalFeatures[grep("Mag", finalFeatures,)] <- paste0(finalFeatures[grep("Mag", finalFeatures,)],"Mag")

#Removes the first "Mag" in the strings. This process has moved "Mag" from the middle to the end of the string.
finalFeatures <-sub("Mag","", finalFeatures)

#Adds "Jerk" to the end of strings that have "Jerk" in them
finalFeatures[grep("Jerk", finalFeatures,)] <- paste0(finalFeatures[grep("Jerk", finalFeatures,)],"Jerk")

#Removes the first "Jerk" in the strings. This process has moved "Jerk" from the middle to the end of the string.
finalFeatures <-sub("Jerk","", finalFeatures)


##Load train data sets
#Load train data to "train"
train <- fread("UCI HAR Dataset/train/X_train.txt")

#Each variable (column) in "train" represents one of the 561 features in "features.txt"
#Only take columns of features we want to look at (indices in "featuresDesired")
train <- subset(train,select=featuresDesired)

#Change the names of the columns in "train" to what features they represent using "finalFeatures"
colnames(train) <- finalFeatures

#Read in the information about what type of activity each row represents (WALKING, SITTING, etc.; related to "activityLabels")
trainActivities <- fread("UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))

#Read in the information about the participant ID each row represents
trainParticipants <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = c("ParticipantNum"))

#Combine the activity and participant ID information to the beginning of "train" data frames as columns with new variables
train <- cbind(trainParticipants, trainActivities, train)



##Load test data sets
#Load test data to "test"
test <- fread("UCI HAR Dataset/test/X_test.txt")

#Each variable (column) in "test" represents one of the 561 features in "features.txt"
#Only take columns of features we want to look at (indices in "featuresDesired")
test <- subset(test,select=featuresDesired)

#Change the names of the columns in "test" to what features they represent using "finalFeatures"
colnames(test) <- finalFeatures

#Read in the information about what type of activity each row represents (WALKING, SITTING, etc.; related to "activityLabels")
testActivities <- fread("UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))

#Read in the information about the participant ID each row represents
testParticipants <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = c("ParticipantNum"))

#Combine the activity and participant ID information to the beginning of "test" data frames as columns with new variables
test <- cbind(testParticipants, testActivities, test)



##Merge and Neaten train and test data sets
#Merge train and test data sets
merged <- rbind(train,test)

#Reorder rows by "ParticipantNum" and "Activity"
merged <- merged[order(ParticipantNum, Activity),]

#Convert the number codes in "Activity" to the character descriptions from "activityLabels$ActivityName"
merged$Activity <- factor(merged$Activity,levels=activityLabels$ActivityKey,labels=activityLabels$ActivityName)

#Calculates the average of each variable for each activity performed by each participant. Removes NA values
#Output has 1 average measurement for each activity of each participant
averagedData <- merged %>%
    group_by(ParticipantNum, Activity) %>% 
    summarise_all(mean, na.rm=TRUE)

#Checks to see if "tidydata" directory exists. Creates directory if not.
if(!file.exists("./tidydata")){dir.create("./tidydata")}

#Write "averagedData" data table to "tidyData.txt"
write.table(averagedData, "./tidydata/tidyData.txt", sep = " ", dec = ".", row.names = FALSE, col.names = TRUE)

#Write "averagedData" data table to "tidyData.csv" (Just as another format that might be easier to import to other platforms)
write.csv(averagedData, "./tidydata/tidyData.csv",row.names = FALSE,)

