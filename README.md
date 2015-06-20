---
title: "Getting and Cleaning Data Project"
author: "Luke Diliberto"
date: "Friday, June 19, 2015"
output: html_document
---
This markdown summarizes the steps for downloading, cleaning and generating a tidy data set from the the raw data located at
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip..

Details on the original data set and the research context can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Included with this submission is "run_analysis.R." Provided the above-linked data has been downloaded to the user's working directoy, this R function file will automatically generate the final tidy data set containing the sensor means. Please also see the code book included in this submission for details on each variable in the final tidy data set. 

To summarize, we organize sensor measurements from a cell phone that were collected while subjects performed different activities. The original research project separates out the data into "training" and "testing" data and also factors out the subject and activity information into separate files for machine learning purposes. 

The challenge is to stitch these data back together from 8 different files:

* sensor data from the train and test sets (X_train.txt and X_test.txt)
* column names for each of the sensor data variables (features.txt)
* integer subject IDs -- who was performing the activity for each measurement -- (subject_train.txt and subject_test.txt)
* an integer activity key for each measurement -- what activity was being performed during the measurement -- (y_train.txt, y_train.txt)
* a file that links the numeric key for each activity to a description of the acitivty (activity_labels.txt)

##Note on selected sensor data. 
Our primary interest are sensor variables that measure mean and standard deviation values. To err on the side of caution, I have included every variable with mean and std (or Mean and Std) in its variable name. Because removing unneeded variables downstream is easier than adding new data, especially absent a unique key, the overinclusiveness of this choice is justified. 

##1. Merge the training and the test sets to create one data set.
        Download and Unzip the data:
```{r}
        ##[Download functions commented out because of OS dependance.]
        ##url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        ##download.file(url, destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
        unzip("getdata-projectfiles-UCI HAR Dataset.zip")
```
        Load sensor measurement data and sensor variable names (columns headings)
```{r}
        # -Load in sensor measurement names (feautures.txt)
        sensor_labels <- read.table("UCI HAR Dataset/features.txt", 
                                    stringsAsFactors = FALSE)
        sensor_labels <- sensor_labels[,2]
        #Load in sensor measurement data and assign the sensor labels to the column names
        sensor_data <- rbind(read.table("UCI HAR Dataset/test/X_test.txt", 
                                        stringsAsFactors = FALSE,
                                        col.names=sensor_labels),
                             read.table("UCI HAR Dataset/train/X_train.txt", 
                                        stringsAsFactors = FALSE,
                                        col.names=sensor_labels))
```

##2. Extract only mean and standard deviation measurements for each sensor variable. 
        See introduction paragraph in readme for rationale regarding method of culling.
```{r}
        #Find the column numbers containing Std, std, Mean or mean.
        std_mean_col_indices <- which(grepl("((S|s)td)|((M|m)ean)",sensor_labels))
        #subset on those colums
        sensor_data <- sensor_data[,std_mean_col_indices]
```

##3. Insert Subject and Activity columns, match Activity descriptions to integer codes.
```{r}
        #Create Subject Data Frame and append as column to Sensor Data 
        subject_data <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt", 
                                         col.names='Subject'),
                              read.table("UCI HAR Dataset/train/subject_train.txt", 
                                         col.names='Subject'))
        sensor_data <- cbind(sensor_data,subject_data)

        #Create Activity Data Frame and append as column to Sensor Data
        activity_data <- rbind(read.table("UCI HAR Dataset/test/y_test.txt", 
                                          col.names='ActivityKey'),
                               read.table("UCI HAR Dataset/train/y_train.txt", 
                                          col.names='ActivityKey'))
        sensor_data <- cbind(sensor_data,activity_data)
        #Import descriptive labels for Activities and replace numeric keys with descriptions
        activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                                      col.names=c('ActivityKey','Activity'))
library(dplyr)
        sensor_data <- inner_join(sensor_data,activity_labels)
        sensor_data <- select(sensor_data, -ActivityKey)
 
```

##4. Appropriately label the data set with descriptive variable names. 
The variable labels for the sensor data have been carried over from the features.txt file. The provided codebook documents and explains the variable naming conventions.

##5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
This data is tidy because it contains one variable per column and one observation (the mean of the original sensor variable) per row.
```{r}
        #Get means of sensor variables (columns 1-86) by Activity and Subject
        sensor_data_means <- aggregate(sensor_data[1:86],
                                       list(Activity = sensor_data$Activity, 
                                            Subject = sensor_data$Subject),
                                       mean)
        #Write final tidy data set to file
        write.table(sensor_data_means, 
                    file = "sensor_data_means.txt", 
                    row.names = FALSE)
```

