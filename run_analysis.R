library(data.table)
library(plyr)
library(dplyr)
library(lubridate)
library(tidyr)


# Download the zip file and unzip it
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file.url, destfile = "data.zip")
unzip("data.zip")

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

# Clean the features dataset
featuresTake <- grep("-mean|-std", features[, 2])
featuresNeeded <- features[grep("-mean|-std", features[, 2]), ]
colnames(featuresNeeded) <- c("V1", "feature.name")

featuresFinal <- mutate(featuresNeeded,
                        feature.name = gsub("-mean", "Mean", feature.name),
                        feature.name = gsub("-std", "Std", feature.name),
                        feature.name = gsub("-", "", feature.name),
                        feature.name = gsub("\\()", "", feature.name))

# Load Train Datasets

train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainTake <- train[featuresTake]

trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

trainAll <- cbind(trainSubjects, trainActivities, trainTake)



# Load Test Datasets

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testTake <- test[featuresTake]

testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

testAll <- cbind(testSubjects, testActivities, testTake)


# Merge Datasets and rename columns

dataAll <- rbind(trainAll, testAll)
colnames(dataAll) <- c("subjects", "activity", featuresFinal$feature.name)

dataAll1 <- merge(dataAll, activityLabels, by.x = "activity", by.y = "V1")
dataAll1$activity <- NULL

# Rename column V2 as activity
dataAll1 <- rename(dataAll1, activity = V2)

# Reordering Dataset
partData1 <- select(dataAll1, subjects, activity)
partData2 <- select(dataAll1, -c(subjects, activity))

dataAllNew <- cbind(partData1, partData2)

# Tidy Data
longdata <- gather(dataAllNew, feature.name, val, -(subjects:activity))

# Calculate average value for each variable, for each activity and each subject
aggdata <- longdata %>% group_by(subjects, activity, feature.name) %>%
           summarize(avgval = mean(val)) %>%
           arrange(subjects, activity, feature.name)

tidydata <- spread(aggdata, feature.name, avgval)

# Write the tidy dataset
write.table(tidydata, "tidy.txt", row.names = FALSE)


