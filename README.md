# R geom_tile() view of U.S. State COVID new cases over time

In this code sample, we are going to explore the Center for Disease Control (CDC) "United States COVID-19 Cases and Deaths by State over Time" dataset.  The dataset can be found at the following URL, along with the numerous CDC data sets publically available: https://data.cdc.gov/browse.  The dataset is archived and hasn't been updated since October of 2022, but it does contain U.S. state COVID new case data from January 2020 - October 2022, which is sufficient for the purposes of this exercise.  At the end of this analysis, we hope to capture U.S. state new case trends over time in a single visual.

I have the "United States COVID-19 Cases and Deaths by State over Time" data downloaded to a folder called 'data' in my R project folder.  I set the working directory, load the data, and examine its structure like this:

```
setwd(paste(getwd(),"/data",sep=""))
covid_data <- read.csv('United_States_COVID-19_Cases_and_Deaths_by_State_over_Time_-_ARCHIVED.csv')
str(emp_data)
```

By examining the structure of the object, we can see it is a data frame with 2,180,296 observations and 20 variables.  Since each observation represents an employee, we know the total observation equals the total number of government employees in this data set.

```
'data.frame':	60060 obs. of  15 variables
```
|     variable        |                       structure                            |
|---------------------|------------------------------------------------------------|
| $ submission_date: |chr  "03/11/2021" "12/01/2021" "01/02/2022" "11/22/2021" ...|
| $ state          : |chr  "KS" "ND" "AS" "AL" ...|
| $ tot_cases      : |int  297229 163565 11 841461 251425 0 173 173967 0 602931 ...|
| $ conf_cases     : |int  241035 135705 NA 620483 NA 0 NA 144788 NA NA ...|
| $ prob_cases     : |int  56194 27860 NA 220978 NA 0 NA 29179 NA NA ...|
| $ new_case       : |int  0 589 0 703 0 0 14 667 0 1509 ...|
| $ pnew_case      : |int  0 220 0 357 0 0 NA 274 0 0 ...|
| $ tot_death      : |int  4851 1907 0 16377 1252 0 3 2911 0 8318 ...|
| $ conf_death     : |int  NA NA NA 12727 NA 0 NA 2482 NA NA ...|
| $ prob_death     : |int  NA NA NA 3650 NA 0 NA 429 NA NA ...|
| $ new_death      : |int  0 9 0 7 0 0 0 8 0 6 ...|
| $ pnew_death     : |int  0 0 0 3 0 0 NA 3 0 0 ...|
| $ created_at     : |chr  "03/12/2021 03:20:13 PM" "12/02/2021 02:35:20 PM" "01/03/2022 03:18:16 PM" "11/22/2021 12:00:00 AM" ...|
| $ consent_cases  : |chr  "Agree" "Agree" "" "Agree" ...|
| $ consent_deaths : |chr  "N/A" "Not agree" "" "Agree" ...|
### 1) How many General Schedule (GS) government employees are there?

From the structur
