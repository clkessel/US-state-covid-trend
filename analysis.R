#R Script to create visual of US State COVID new case data

library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)

#set working directory, read data, and examine structure
setwd(paste(getwd(),"/data",sep=""))
covid_data <- read.csv('United_States_COVID-19_Cases_and_Deaths_by_State_over_Time_-_ARCHIVED.csv')
str(covid_data)

#examine state column...how many unique state values are there (looking for 50 but there are 60)
covid_data %>% select(state) %>% unique() %>% count()
#remove non-US state abbreviations
covid_data <- covid_data %>% filter(!state %in% c("RMI", "PR", "VI", "RMI", "MP", "DC", "GU", "FSM", "AS", "PW"))
#incorporate NYC values into NY state values
covid_data$state[covid_data$state == "NYC"] <- "NY"
#recheck total...should be 50 now
covid_data %>% select(state) %>% unique() %>% count()

#submission_date column was 'chr' before, format to 'date' and re-check
covid_data$submission_date <- mdy(covid_data$submission_date)
str(covid_data$submission_date)

#basic line plot, no state data
covid_data_line <-covid_data %>% group_by(format(submission_date, "%Y-%m")) %>% summarize(monthly_total=sum(new_case))
str(covid_data_line)
colnames(covid_data_line) <- c("month", "total")
covid_data_line %>%  ggplot(aes(x=month, y=total, group=1)) + ggtitle("U.S. Covid new case totals by month (Jan 2020 - Oct 2022)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position = "none") + 
  scale_y_continuous(labels = comma) + geom_line()

#basic line plot with each state a different color
covid_data_lines <-covid_data %>% group_by(format(submission_date, "%Y-%m"), state) %>% summarize(monthly_total=sum(new_case))
colnames(covid_data_lines) <- c("month", "state", "total")
covid_data_lines %>%  ggplot(aes(x=month, y=total, color = state, group=state)) + ggtitle("U.S. Covid new case totals by month by state (Jan 2020 - Oct 2022)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position = "right") + 
  scale_y_continuous(labels = comma) + geom_line()

#tile plot with 2 x vertical intercepts
covid_data %>% filter(new_case >= 0) %>%  ggplot(aes(x=format(submission_date, "%Y-%m"), y=state, fill=sqrt(new_case))) +
  geom_tile(color = "black") + 
  scale_x_discrete(position = "top") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), legend.position = "none") + 
  guides(fill = guide_colourbar(barwidth = 20, barheight = .5)) +
  xlab("") + ylab("") + ggtitle("U.S. Covid New Case by State (Jan 2020 - Oct 2022)") +
  scale_fill_gradient(low = "#000099", high = "#FFFFFF") + geom_vline(xintercept = c("2020-12", "2022-01"), color = "red")
