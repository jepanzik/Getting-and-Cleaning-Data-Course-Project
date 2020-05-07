---
Title: "CodeBook"
Author: "J.E. Panzik"
Date: "5/7/2020"
---


This file is a description of the "run_analysis.R" code processes and all variables

### run_analysis.R Overview
1. Check for "data.table" package and install if missing. Call "data.table" from library
2. Load the key for the activity labels from "activity_labels.txt"
      * Neaten appearance of the label names  
3. Load list of features from "features.txt"
4. Search for and keep features that have "mean()" or "std()" as desired quantities.
      * Neaten appearance of desired feature variable names  
5. Load the training data "X_train.txt" and filter for desired features.
      * Add column names  
      * Append the corresponding Participant number and activity number for each row of observations  
6. Load the test data "X_test.txt" and filter for desired features.
      * Add column names  
      * Append the corresponding Participant number and activity number for each row of observations  
7. Merge the training and test data frames
      * Reorder merged data frame by participant number then activity
      * Replace activity numbers with character description
8. Determine mean value for each variable based on participant number AND activity
9. Write the tidy data that has 1 mean value of the desired features for each activity for each person (30 participants x 6 activities/per participant)
      * Written to "tidydata" directory (created if not present)
      * Written to a .txt and .csv file for replication and easy of importing later

## Variables

### Participants and Activity Information

**ParticipantNum**

* ID number assigned to each participant  
* **Values** Range from 1 to 30 (there were a total of 30 participants/subjects)


**Activity**

* These correspond the to activities that participants were performing while measurements were taken  
* Activites were originally coded as integer values for each action  
* **Values**  
    * Example: action (original coded number)  
    * walking (1)  
    * walking upstairs (2)
    * walkingdownstairs (3)
    * sitting (4)
    * standing (5)
    * laying (6)


### Values Measured and Collected by Samsung Galaxy S II
Variable description taken from "features_info.txt" file

Variables within the data appear as such: TimeBodyAccMeanX

* Descriptor (**Time**BodyGyroMeanMagJerk) (**Time**BodyAccMeanX)  
    * Indicate whether is was a measurement collected at certain time intervals or as a Fast Fourier Transform
    * **Time** indicates measurements were taken at a constant rate of 50 Hz (once every 0.02 seconds)
    * **Fft** indicates it is a Fast Fourier Transform measurement taken on the signals  
    <br/>
* Descriptor (Time**Body**GyroMeanMagJerk) (Time**Body**AccMeanX)  
    * Seprates signal into whether it is the acceleration of the person's body, or gravitational acceleration of the phone  
    * Separated using a low pass Butterworth filter with a corner frequency of 0.3 Hz  
    * **Body** indicates the acceleration of the person's body  
    * **Gravity** indicates the gravitational acceleration of the phone  
    <br/>
* Descriptor (TimeBody**Gyro**MeanMagJerk) (TimeBody**Acc**MeanX)  
    * Distinguishes between measurements taken from the phone's accelerometer or the gyroscope  
    * **Acc** indicates measurements taken from the accelerometer
    * **Gyro** indicates the measurements were taken from the gyroscope  
    <br/>
* Descriptor (TimeBodyGyro**Mean**MagJerk) (TimeBodyAcc**Mean**X)  
    * Describes the magnitude of the resultant vector from 
    * **Mean** indicates it is the average value of the measurements
    * **Std** indicates it is the standard deviation of the measurements  
    <br/>
* Descriptor (TimeBodyGyroMean**Mag**Jerk) (TimeBodyAccMean**X**)  
    * Indicates what Cartesian axis the measurements correspond to
    * **X** indicates it is the x-axis value
    * **Y** indicates it is the y-axis value
    * **Z** indicates it is the Z-axis value
    * **Mag** indicates it is the magnitude of the full vector from X, Y, Z  
    <br/>
* Descriptor (TimeBodyGyroMeanMag**Jerk**) (TimeBodyAccMeanX)  
    * Linear and angular accelerations were used to determine if there were sudden changes in motion (jerks)
    * **Jerk** indicates a measurement of a jerk signal  
   