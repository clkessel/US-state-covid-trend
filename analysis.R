#R Script to create visual of US State COVID new case data

library(dplyr)
library(ggplot2)
library(lubridate) #for working with dates
library(scales)

#set working directory
setwd(paste(getwd(),"/data",sep=""))

#read data and examine structure
covid_data <- read.csv('United_States_COVID-19_Cases_and_Deaths_by_State_over_Time_-_ARCHIVED.csv')
str(covid_data)
head(covid_data)

#examine state column...how many unique state values are there (looking for 50 but there are 60)
covid_data %>% select(state) %>% unique() %>% count()
#remove non-US state abbreviations and re-check totals
covid_data <- covid_data %>% filter(!state %in% c("RMI", "PR", "VI", "RMI", "MP", "DC", "GU", "FSM", "AS", "PW"))
covid_data %>% select(state) %>% unique() %>% count()
#incorporate NYC values into NY state values
covid_data$state[covid_data$state == "NYC"] <- "NY"
covid_data %>% select(state) %>% unique() %>% count()

#data wrangling
#examine new_case data field...after removing the non-US states, there are 32 entries with new_case values less than 0!
covid_data %>% filter(new_case < 0)

##add month-year column
##drop unnecessary columns
#convert submission_date to date format
str(covid_data$submission_date)
covid_data$submission_date <- mdy(covid_data$submission_date)
####need to convert to date 

#check data frame structure


#display visual
covid_data %>% filter(new_case >= 0) %>% ggplot(aes(x=format(submission_date, "%Y-%m"), y=state, fill=sqrt(new_case))) +
  geom_tile(color = "black") + 
  scale_x_discrete(position = "top") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  guides(fill = guide_colourbar(barwidth = 0.5, barheight = 20, title="Sqrt New Cases")) +
  xlab("") + ylab("") +
  scale_fill_gradient(trans = "sqrt", labels = label_comma()) + 
  scale_size(guide = guide_legend(direction = "horizontal"))
#scale_fill_gradientn(trans = "sqrt", colors = hcl.colors(20, "RdYlGn")) +
#guides(fill=guide_legend(title="New Cases (sqrt)")) +


