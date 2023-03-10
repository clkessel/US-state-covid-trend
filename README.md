# R geom_tile() view of U.S. State COVID new cases over time

In this code sample, we are going to explore the Center for Disease Control (CDC) "United States COVID-19 Cases and Deaths by State over Time" dataset.  The dataset can be found at the following URL, along with the numerous CDC data sets publically available: https://data.cdc.gov/browse.  The dataset is archived and hasn't been updated since October of 2022, but it does contain U.S. state COVID new case data from January 2020 - October 2022, which is sufficient for the purposes of this analysis.  At the end of this exploration, we hope to capture U.S. state new case trends over time in a single visual.

I have the September 2022 data downloaded to a folder called 'data' in my R project folder.  I set the working directory, load the data, and examine its structure like this:

```
setwd(paste(getwd(),"/data",sep=""))
emp_data <- read.csv('FACTDATA_SEP2022.TXT')
str(emp_data)
```

As you will see from the above code, I am reading from the 'FACTDATA_SEP2022.TXT' file that contains the employee data, but the .zip file also contains 17 additional files.  After consulting the data dictionary (also freely available for download), these 17 additional files are referred to as Dimension Translation Files and they provide additional detail on the field values found in the 'FACTDATA_SEP2022.TXT' file.

By examining the structure of the object, we can see it is a data frame with 2,180,296 observations and 20 variables.  Since each observation represents an employee, we know the total observation equals the total number of government employees in this data set.

```
'data.frame':	2180296 obs. of  20 variables:
```

|variable    |               structure             |
|------------|-------------------------------------|
|$ AGYSUB    | chr  "AA00" "AA00" "AA00" "AA00" ...|
|$ LOC       | chr  "11" "11" "11" "11" ...|
|$ AGELVL    | chr  "F" "I" "E" "F" ...|
|$ EDLVL     | chr  "13" "15" "15" "15" ...|
|$ GSEGRD    | chr  "" "" "15" "13" ...|
|$ LOSLVL    | chr  "F" "H" "E" "E" ...|
|$ OCC       | chr  "0340" "0905" "0905" "0905" ...|
|$ PATCO     | int  2 1 1 1 1 1 2 1 2 1 ...|
|$ PP        | chr  "ES" "ES" "99" "99" ...|
|$ PPGRD     | chr  "ES-**" "ES-**" "GS-15" "GS-13" ...|
|$ SALLVL    | chr  "S" "S" "O" "L" ...|
|$ STEMOCC   | chr  "XXXX" "XXXX" "XXXX" "XXXX" ...|
|$ SUPERVIS  | chr  "2" "2" "8" "8" ...|
|$ TOA       | chr  "50" "50" "30" "30" ...|
|$ WORKSCH   | chr  "F" "F" "F" "F" ...|
|$ WORKSTAT  | int  1 1 1 1 1 1 2 1 1 2 ...|
|$ DATECODE  | int  202209 202209 202209 202209 202209 202209 202209 202209 202209 202209 ...|
|$ EMPLOYMENT| int  1 1 1 1 1 1 1 1 1 1 ...|
|$ SALARY    | int  199500 193000 158383 121065 138856 143064 203700 110384 74950 74950 ...|
|$ LOS       | num  19.3 29.7 11 13.9 10.3 8 20.5 3 1 1 ...|

### 1) How many General Schedule (GS) government employees are there?

From the structur
