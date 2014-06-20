# The "run_analysis.R" script.

The purpose of this script is to clean and process the [smartphone accelerometer data set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) available from the UCI Machine Learning Repository. See the link for detailed description of the source data set.

The output of the script is a tidy data set in csv format, containing the averages of the mean and standard deviation measurements, grouped by subject and activity type. For detailed description of the data, see the **codebook.md** file in the repository.

## Usage

```
run_analysis(input_path = "./UCI HAR Dataset/", output_file = "./averages.csv")
```

The script assumes that the source data is downloaded and unzipped to a local directory. By default, this is the **UCI HAR Dataset** directory in the R working directory. In the first parameter, it's possible to change this.

The output file will be placed in the R working directory as **averages.csv**. To save it in a different file, change the *output_file* parameter.

## How it works?

The script does the following:
1. Reads the *features.txt* file to get the variable names of the raw data.
2. Calls a nested function two times, once for the *test* anc once for the *training* data. The nested function executes the following steps:
   1. Reads the specified raw data set and labels its columns according to the features file.
   2. Extracts only the variables with measurements of the means and standard deviations.
   3. Reads the *activity* values and adds them as a column to the main data set.
   4. Reads the *subject* values and adds them as a column to the main data set.
3. Once both data set is loaded and pre-processed, the script combines them into a single data set.
4. Labels the raw activity values with meaningful descriptions, based on the *activity_labels.txt* file.
5. Creates an aggregated data set containing the averages of the means and standard deviations, grouped by subjects and activities.
6. Writes this data set into the output file (by default: averages.csv).
