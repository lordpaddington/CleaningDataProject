run_analysis <- function(input_path = "./UCI HAR Dataset/", output_file = "./averages.csv") {        
    
    # Read the features table
    features_path <- paste(input_path, "/features.txt", sep = "")
    features <- read.table(features_path, sep=" ", col.names = c("column","variable"))
    
    # Set the lengths for the features    
    col_width = seq(from=16,to=16,length.out=nrow(features))
    
    # Read and prepare a data set        
    load_dataset <- function(dataset_name) {
        file_path <- paste(input_path, dataset_name,"/X_", dataset_name, ".txt", sep = "")
        print(paste("Loading and processing data set:", file_path))
        data <- read.fwf(file_path, widths = col_width, buffersize = 500)        
        names(data) <- features[,2]    
        
        ## Extract the interesting variables        
        means <- grep("mean()",as.character(features[,2]))
        stds <- grep("std()",as.character(features[,2]))
        interesting <- sort(append(mean,std))
        data <- data[,as.numeric(interesting)]
        
        ## Add activity values
        act_path <- paste(input_path, dataset_name,"/y_", dataset_name, ".txt", sep = "")
        activity <- as.numeric(readLines(act_path))
        data <- cbind(data,activity)
        
        ## Add subjects
        subj_path <- paste(input_path, dataset_name,"/subject_", dataset_name, ".txt", sep = "")
        subject <- as.numeric(readLines(subj_path))
        print("Ready.")
        data <- cbind(data,subject)
    }
    
    a <- load_dataset("test")
    b <- load_dataset("train")    
    
    # Append the two data sets
    print("Combining the two data sets...")
    complete <- rbind(a,b)
    print("Ready.")
    
    # Label activities
    activities_path <- paste(input_path, "/activity_labels.txt", sep = "")
    activities <- read.table(activities_path, sep=" ", col.names = c("id","activity"))
    complete$activity <- activities[match(complete$activity, activities$id),2]
    
    # Create average data sets and save the results   
    output <- aggregate(complete[,1:79], by = list(subject = complete$subject, activity = complete$activity), mean)    
    output <- output[order(output$subject, output$activity),]
    write.csv(output, file = output_file, row.names = FALSE)
    
    print(paste("Script completed. Output is saved as:", output_file))    
}

