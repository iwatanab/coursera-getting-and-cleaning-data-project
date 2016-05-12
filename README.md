# Getting and Cleaning Data - Course Assignment

The R script, `run_analysis.R`, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Read the Data from files in UCI HAR Dataset
3. Merge Test and Train data in the activity, subject and feature
5. Merges the three datasets
6. Converts the `activity` column into a factor
7. Extract only the measurements on the mean and standard deviation for each measurement
8. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair.

The end result is shown in the file `tidy.txt`.