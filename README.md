## Assignment: Getting and Cleaning Data Course Project

The R script run_analysis.R performs the following tasks and generates tidy.txt

### Loading and Cleaning activity and features data

1. Download the zip file from the URL and unzip it
2. Load activity labels and features information in R
3. Select mean and standard deviation feature measurements
4. Clean and rename feature measurements. The variable names can be found in CodeBook.md file


### Loading and Cleaning train and test data

1. Load train and test datasets
2. Select value that represent mean or standard deviations
3. Load activity and subject data for each dataset and combine it with respective datasets
4. Merge train and test data to create one dataset
3. Rename column names


### Creating Tidy data
1. Use gather() from tidyr package to create a long data set
2. Group the data by subjects, activity and feature name
3. Calculate the average value for each variable, each activity and each subject
4. Use spread() to create tidy dataset called tidy.txt