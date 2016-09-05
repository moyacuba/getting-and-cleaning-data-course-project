# activate 'dplyr' features
library(dplyr)

# Process raw files

## reading meta data files
### objetive of:
### 3. Uses descriptive activity names to name the activities in the data set
### and
### 4. Appropriately labels the data set with descriptive variable names.

features <- read.table("./features.txt", header = FALSE, col.names = c("measurementIndex", "measurementName")) %>% tbl_df %>% mutate(measurementName=as.character(measurementName))
activity_labels <- read.table("./activity_labels.txt", header = FALSE, col.names = c("activityId", "activity")) %>% tbl_df 

## reading measurements using the col names from read in features$measurementName 
### objetive of:
### 1. Merges the training and the test sets to create one data set.
### and
### 4. Appropriately labels the data set with descriptive variable names.
X_all <- rbind(read.table("./test/X_test.txt", header = FALSE, col.names = features$measurementName), read.table("./train/X_train.txt", header = FALSE, col.names = features$measurementName)) %>% tbl_df

## filtering measurements bout mean and std; dots in regular expression avoid freqMean and other kind of vars
### objetive of:
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
x_filteredMenStd <- select(X_all, matches("\\.mean\\.|\\.std\\.", ignore.case = TRUE))

## reading the activity and subject values for the observation' set's tidy format
### objetive of:
### 1. Merges the training and the test sets to create one data set.
### and
### 3. Uses descriptive activity names to name the activities in the data set
y_all <- rbind(read.table("./test/y_test.txt", header = FALSE, col.names = c("activityId")), read.table("./train/y_train.txt", header = FALSE, col.names = c("activityId"))) %>% tbl_df
subject_all <-rbind(read.table("./test/subject_test.txt", header = FALSE, col.names = c("subject")), read.table("./train/subject_train.txt", header = FALSE, col.names = c("subject"))) %>% tbl_df

## joining and merging the observation values 
### objetive of:
### 4. Appropriately labels the data set with descriptive variable names.
tidyRawData <- merge(cbind(x_filteredMenStd, y_all, subject_all), activity_labels) %>% select(-activityId)

## obtaining the mean of each variable in the group activity-subject
### objetive of:
### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidySummary <- tidyRawData %>% group_by(activity, subject) %>% summarise_each(funs(mean))

