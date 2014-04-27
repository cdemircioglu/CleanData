

##Read the training input files
xtraining = read.table("./train/X_train.txt",header=FALSE)
ytraining = read.table("./train/y_train.txt",header=FALSE)

##Extract subjects
subject_train <- read.table("./train/subject_train.txt",header=FALSE)

##Create the y column
xtraining["y"] <- NA
xtraining$y <- ytraining[,]

##Add subject
xtraining["Subject"] <- NA
xtraining$Subject <- subject_train[,]

##Read the training input files
xtesting = read.table("./test/X_test.txt",header=FALSE)
ytesting = read.table("./test/y_test.txt",header=FALSE)


##Extract subjects
subject_test <- read.table("./test/subject_test.txt",header=FALSE)

##Create the y column
xtesting["y"] <- NA
xtesting$y <- ytesting[,]

##Add subject
xtesting["Subject"] <- NA
xtesting$Subject <- subject_test[,]

##Merge training and testing
xfull <- rbind(xtraining,xtesting) #10299 records


##Extract features
features <- read.table("./features.txt",header=FALSE)

##Regex match for mean and std
matchvector <- c(".*mean\\(\\).*-X$", ".*std\\(\\).*-X$")

##Vector of matches names
matches <- unique(grep(paste(matchvector,collapse="|"), features$V2, value=TRUE))

##Match indexes
filteredmatches <- xfull[,c(unique(grep(paste(matchvector,collapse="|"), features$V2, value=FALSE)),562,563)]

##Names of columns
colnames(filteredmatches) <- c(unique(grep(paste(matchvector,collapse="|"), features$V2, value=TRUE)),"ActivityID","Subject")

##Get the activity labels from the activity table
activity <- read.table("./activity_labels.txt")
colnames(activity) <- c("ActivityID","Activity")

##Merge two tables
mergedtable <- merge(filteredmatches,activity,by="ActivityID")
mergedtable <- mergedtable[,2:19]

##Tidy dataset
tidydata <- aggregate(mergedtable[,1:16], list(mergedtable$Subject,mergedtable$Activity), mean)

##Assign colnames
colnames(tidydata) <- c("Subject", "Activity",unique(grep(paste(matchvector,collapse="|"), features$V2, value=TRUE)))

##Write to a file, suppress row names
write(tidydata, "tidydata.txt", row.names=FALSE, sep="\t")
