run_analysis <- function()
{
        ##[Download functions commented out because of OS dependance.]
        ##url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        #download.file(url, destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
        unzip("getdata-projectfiles-UCI HAR Dataset.zip")

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
        #Find the column numbers containing Std, std, Mean or mean.
        std_mean_col_indices <- which(grepl("((S|s)td)|((M|m)ean)",sensor_labels))
        #subset on those colums
        sensor_data <- sensor_data[,std_mean_col_indices]
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
        #Get means of sensor variables (columns 1-86) by Activity and Subject
        sensor_data_means <- aggregate(sensor_data[1:86],
                                       list(Activity = sensor_data$Activity, 
                                            Subject = sensor_data$Subject),
                                       mean)
        #Write final tidy data set to file
        write.table(sensor_data_means, 
                    file = "sensor_data_means.txt", 
                    row.names = FALSE)
        
}