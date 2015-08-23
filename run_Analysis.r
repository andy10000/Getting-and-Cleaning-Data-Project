###############################################################################

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets into a single data set.
# 2. Assign column names to new data set
# 3. Extract only the measurements on the mean and standard deviation for each measurement.
# 4. Assign activity description to mean and standard deviation variables
# 4. Clean data
# 5. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

###############################################################################

# Clean up workspace
rm(list = ls())

# Load dyplyr package
library(dplyr)

# Read in the data from files
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
features <- read.table("features.txt")
activity <- read.table("activity_labels.txt",col.names = c("activity_id", "activity_name"))

# Merge training & test set 
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)

# Assign column names to data 
colnames(x_data) = features[,2]

# Keep only columns referring to mean() or std() values
mean_col_idx <- grep("mean",names(x_data),ignore.case=TRUE)
mean_col_names <- names(x_data)[mean_col_idx]
std_col_idx <- grep("std",names(x_data),ignore.case=TRUE)
std_col_names <- names(x_data)[std_col_idx]
mean_std_data <- x_data[,c(mean_col_names, std_col_names)]

# Combine y_data with x_data to create final merged data set
all_data <- cbind(y_data, mean_std_data)

# Rename column "V1" in all_data to activity_id
names(all_data)[names(all_data)=="V1"] <- "activity_id"

##Merge the activitiy with all_data values 
##to get one dataset with descriptive activity names
final_data <- merge(activity, all_data, by = "activity_id")

#Create a file with the new tidy dataset
write.table(final_data, "./tidy_movement_data.txt", row.name=FALSE)

