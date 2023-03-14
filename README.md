# U.S. State new Covid cases with geom_tile()

In this code sample, we are going to explore the Center for Disease Control (CDC) "United States COVID-19 Cases and Deaths by State over Time" dataset.  The dataset can be found at the following URL, along with the numerous CDC data sets publically available: https://data.cdc.gov/browse.  While the dataset is archived and hasn't been updated since October of 2022, but it does contain U.S. state COVID new case data from January 2020 - October 2022, which is sufficient for the purposes of this exercise.  At the end of this analysis, we hope to see how new COVID cases trended at the state level over time in a single visual.

I have the "United States COVID-19 Cases and Deaths by State over Time" data downloaded to a folder called 'data' in my R project folder.  I set the working directory, load the data, and examine its structure like this:

```
setwd(paste(getwd(),"/data",sep=""))
covid_data <- read.csv('United_States_COVID-19_Cases_and_Deaths_by_State_over_Time_-_ARCHIVED.csv')
str(emp_data)
```

By examining the structure of the object, we can see it is a data frame with 60,060 observations of 15 variables.  

```
'data.frame':	60060 obs. of  15 variables
```

|          variable        |                       structure                            |
|---|---|
| $ submission_date        |chr  "03/11/2021" "12/01/2021" "01/02/2022" "11/22/2021" ...|
| $ state          :       |chr  "KS" "ND" "AS" "AL" ...|
| $ tot_cases      :       |int  297229 163565 11 841461 251425 0 173 173967 0 602931 ...|
| $ conf_cases     :       |int  241035 135705 NA 620483 NA 0 NA 144788 NA NA ...|
| $ prob_cases     :       |int  56194 27860 NA 220978 NA 0 NA 29179 NA NA ...|
| $ new_case       :       |int  0 589 0 703 0 0 14 667 0 1509 ...|
| $ pnew_case      :       |int  0 220 0 357 0 0 NA 274 0 0 ...|
| $ tot_death      :       |int  4851 1907 0 16377 1252 0 3 2911 0 8318 ...|
| $ conf_death     :       |int  NA NA NA 12727 NA 0 NA 2482 NA NA ...|
| $ prob_death     :       |int  NA NA NA 3650 NA 0 NA 429 NA NA ...|
| $ new_death      :       |int  0 9 0 7 0 0 0 8 0 6 ...|
| $ pnew_death     :       |int  0 0 0 3 0 0 NA 3 0 0 ...|
| $ created_at     :       |chr  "03/12/2021 03:20:13 PM" "12/02/2021 02:35:20 PM" "01/03/2022 03:18:16 PM" "11/22/2021 12:00:00 AM" ...|
| $ consent_cases  :       |chr  "Agree" "Agree" "" "Agree" ...|
| $ consent_deaths :       |chr  "N/A" "Not agree" "" "Agree" ...|

If we look at the state variable, we notice right away that there abbreviations that aren't the 50 U.S. States.  We can get a quick count of the unique values in that column like this:

```
covid_data %>% select(state) %>% unique() %>% count()
1 60
```

Upon consulting the CDC documentation found on the download page, we learn the state variable actually represents 60 public health jurisdictions.  Some of the public health jurisdictions don't fit into the 50 U.S. States so we will discard those.  Others, such "NYC", while not a state, contains entries that are a subset of an actual state that we will want to fold into the state total.  We discard the "state" entries we want to discard and reassign the "NYC" state entries to become part of "NY" like this:

```
covid_data <- covid_data %>% filter(!state %in% c("RMI", "PR", "VI", "RMI", "MP", "DC", "GU", "FSM", "AS", "PW"))
covid_data$state[covid_data$state == "NYC"] <- "NY"
```
Now when we count the unique values in the state column, we obtain a value we'd expect: 50.  The next thing we want to do is examine the submission_date column, since that is what we will use for our timeframe.  We noticed it is currently a string in the Month-Day-Year format from our examination earlier, so in order to convert that to a DateTime object, we use the following function from the lubridate library:

```
covid_data$submission_date <- mdy(covid_data$submission_date)
```
Now if we examine the structure of this variable, we get a more useable format:

```
str(covid_data$submission_date)
Date[1:60060], format: "2021-03-11" "2021-12-01" "2022-01-02" "2021-11-22" "2022-05-30" "2020-05-17" "2020-04-03" "2021-09-04" "2021-05-09" ...
```

The last variable we'll be dealing with is the new_case variable.  While it does contain occassional negative entries which indicate an update to previously reported new COVID cases, these should be included and will be added to the rest of the data when we aggregate on a monthly basis.  After considering that, we should be ready to move on to plotting.

### Finding a plot that works

As we stated in the beginning, we are interested in seeing how new COVID cases trended at the state level over time.  A simple line plot most likely won't suffice, but we'll plot one just for reference.  First I update the dataframe by grouping by submission_date Month-Year combinations and summarize with new case totals.  Then I use ggplot for a simple line plot like this:

```
covid_data_line <-covid_data %>% group_by(format(submission_date, "%Y-%m")) %>% summarize(monthly_total=sum(new_case))
colnames(covid_data_line) <- c("month", "total")
covid_data_line %>%  ggplot(aes(x=month, y=total, group=1)) + ggtitle("U.S. Covid new case totals by month (Jan 2020 - Oct 2022)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position = "none") + 
  scale_y_continuous(labels = comma) + geom_line()
```

![image](https://user-images.githubusercontent.com/123432368/224873083-eb8468a8-1f7e-4220-9dc3-e01624d6fd5a.png)


As we suspected, while this graph does provide a good view of what amounts to new COVID cases for all 50 states, it doesn't provide any information on the individual states.  If we adjust our line plot slightly by incorporating states, we can get the next level of detail like this:

```
covid_data_lines <-covid_data %>% group_by(format(submission_date, "%Y-%m"), state) %>% summarize(monthly_total=sum(new_case))
colnames(covid_data_lines) <- c("month", "state", "total")
covid_data_lines %>%  ggplot(aes(x=month, y=total, color = state, group=state)) + ggtitle("U.S. Covid new case totals by month by state (Jan 2020 - Oct 2022)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position = "right") + 
  scale_y_continuous(labels = comma) + geom_line()
```

![image](https://user-images.githubusercontent.com/123432368/224873253-b03a495a-8c61-4cd4-a866-538ecbd921ac.png)


While the above plot does provide information at the state level, with 50 individual line plots the detail gets lost in the quantity of data being presented.  Ultimately what we care about is how new cases were trending, so an overall count isn't necessarily as important as it is to see increases and decreases at the state level in a single visual.  The geom_tile() layer, sometimes referred to as a "heatmap", provides a way to achieve the effect we want, and we can accomplish this with the following code:

```
covid_data %>% filter(new_case >= 0) %>%  ggplot(aes(x=format(submission_date, "%Y-%m"), y=state, fill=sqrt(new_case))) +
  geom_tile(color = "black") + 
  scale_x_discrete(position = "top") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position = "none") + 
  guides(fill = guide_colourbar(barwidth = 20, barheight = .5)) +
  xlab("") + ylab("") + ggtitle("U.S. Covid New Case by State (Jan 2020 - Oct 2022)") +
  scale_fill_gradient(low = "#000099", high = "#FFFFFF") + geom_vline(xintercept = c("2020-12", "2022-01"), color = "red")
```

![image](https://user-images.githubusercontent.com/123432368/224873327-b861ce23-54f0-4444-99c5-b9fca09523b7.png)





