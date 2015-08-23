
Getting and Cleaning Data -   Project

The program in this directory (run_analysis.R) implements the course project for the Getting and Cleaning Data  course. 

Here are the steps in the program to accomplish the creation of a tidy data set:

Downloads the dataset if it does not already exist. Create the data directory if it is not already present
Load the activities and features from the data files
Loads both the training and test datasets, keeping only those columns which reflect a mean or standard deviation
Loads the activity and subject data for each dataset, and merges those columns with the dataset
Merges the two datasets
Converts the activity and subject columns into factors
Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
The tidy dataset is written to tidy.txt.
