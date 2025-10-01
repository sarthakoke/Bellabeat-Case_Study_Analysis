library(tidyverse) #collection of libraries for data manipulation and visualization
library(dplyr) #provides data manipulation functions
library(lubridate) #provides functions for working with dates and times
library(skimr) #provides functions for summarizing and exploring data
library(ggplot2) #provides a system for creating beautiful and complex data visualizations
library(cowplot) #provides functions for combining multiple ggplot2 plots into a single figure
library(readr) #provides functions for reading and importing data into R
library(plotly) #provides interactive visualizations
library(janitor) #provides functions for cleaning and preparing data

#Read the data from csv file and store it in a data frame
activity <- read_csv("D:/BellaBeat DataSet/Useful data/dailyActivity_merged.csv")
calories <- read_csv("D:/BellaBeat DataSet/Useful data/dailyCalories_merged.csv")
heartrate <- read_csv("D:/BellaBeat DataSet/Useful data/heartrate_seconds_merged.csv")
intensities <- read_csv("D:/BellaBeat DataSet/Useful data/dailyIntensities_merged.csv")
sleep <- read_csv("D:/BellaBeat DataSet/Useful data/sleepDay_merged.csv")
steps <- read_csv("D:/BellaBeat DataSet/Useful data/dailySteps_merged.csv")
steps_hourly <- read_csv("D:/BellaBeat DataSet/Useful data/hourlySteps_merged.csv")
weight <- read_csv("D:/BellaBeat DataSet/Useful data/weightLogInfo_merged.csv")

#Checking header of the data
head(activity)
head(calories)
head(intensities)
head(steps)
head(weight)

#Looking for NULL Values
colSums(is.na(activity))
colSums(is.na(calories))
colSums(is.na(intensities))
colSums(is.na(steps))
colSums(is.na(weight))



sum(duplicated(activity))
sum(duplicated(calories))
sum(duplicated(heartrate))
sum(duplicated(intensities))
sum(duplicated(sleep))
sum(duplicated(steps))
sum(duplicated(steps_hourly))
sum(duplicated(weight))

sleep <- sleep %>%
  distinct()

sum(duplicated(sleep))

n_distinct(activity$Id)
n_distinct(calories$Id)
n_distinct(heartrate$Id)
n_distinct(intensities$Id)
n_distinct(sleep$Id)
n_distinct(steps$Id)
n_distinct(steps_hourly$Id)
n_distinct(weight$Id)

clean_names(activity)
activity <- rename_with(activity, tolower)

clean_names(calories)
calories <- rename_with(calories, tolower)

clean_names(intensities)
intensities <- rename_with(intensities, tolower)

clean_names(sleep)
sleep <- rename_with(sleep, tolower)

clean_names(steps)
steps <- rename_with(steps, tolower)

clean_names(steps_hourly)
steps_hourly <- rename_with(steps_hourly, tolower)


activity <- activity %>%
  rename(date = activitydate) %>%
  mutate(date = as_date(date, format = "%m/%d/%Y"))


calories <- calories %>%
  rename(date = activityday) %>%
  mutate(date = as_date(date, format = "%m/%d/%Y"))


heartrate <- heartrate %>%
  rename(date_time = Time) %>%
  mutate(date_time = mdy_hms(date))
heartrate <- heartrate %>%
  separate(date_time, into = c("date", "time"), sep= " ") %>%
  mutate(date = ymd(date))


intensities <- intensities %>%
  rename(date = activityday) %>%
  mutate(date = as_date(date, format = "%m/%d/%Y"))


sleep <- sleep %>%
  rename(date = sleepday) %>%
  mutate(date = mdy_hms(date))


steps <- steps %>%
  rename(date = activityday) %>%
  mutate(date = as_date(date, format = "%m/%d/%Y"))


steps_hourly <- steps_hourly %>%
  rename(date_time = activityhour) %>%
  mutate(date_time = mdy_hms(date_time))
steps_hourly <- steps_hourly %>%
  separate(date_time, into = c("date", "time"), sep= " ") %>%
  mutate(date = ymd(date))
steps_hourly <- steps_hourly %>%
  drop_na(time)

activity_sleep <- merge(activity, sleep, by = c("id", "date"))
calories_intensities <- merge(calories, intensities, by = c("id", "date"))
calories_intensities$totalminutes <- calories_intensities$lightlyactiveminutes + calories_intensities$fairlyactiveminutes + calories_intensities$veryactiveminutes
calories_steps <- merge(calories, steps, by = c("id", "date"))


#PLOTS

ggplot(data = calories_intensities, mapping = aes(x = totalminutes, y = calories)) +
  geom_jitter(color = "darkgreen") +  # Change the color of the points
  geom_smooth(method = lm, color = "red") +  # Change the color of the line
  labs(
    title = "Active Minutes vs Calories",
    x = "Active Minutes",  # Change the x-axis label
    y = "Calories Burned"  # Change the y-axis label
  ) +
  theme_bw()  # Use a black and white theme
#This plot suggests a positive relationship between total active minutes and calories burned. This means that as the total active minutes increase, the number of calories burned also increases, which is a common understanding in physical activities.


ggplot(data = calories_steps, mapping = aes(x = steptotal, y = calories)) +
  geom_point(color = "blue") +  # Change the color of the points
  geom_smooth(method = lm, color = "red") +  # Change the color of the line
  labs(
    title = "Total Steps vs Calories",
    x = "Total Steps",  # Change the x-axis label
    y = "Calories"  # Change the y-axis label
  ) +
  theme_minimal()  # Use a minimal theme
#This analysis reinforces the findings from the initial graph, demonstrating that an increase in physical activity leads to a higher calorie expenditure.


ggplot(data = activity, mapping = aes(x = totalsteps, y = totaldistance)) +
  geom_point(color = "darkorange") +  # Change the color of the points
  geom_smooth(method = lm, color = "darkblue") +  # Change the color of the line
  labs(
    title = "Total Steps vs Total Distance",
    x = "Total Steps",  # Change the x-axis label
    y = "Total Distance Covered"  # Change the y-axis label
  ) +
  theme_light()  # Use a light theme
#This compelling graph serves as a testament to the tracker’s functionality, demonstrating a clear correlation between the number of steps taken and the distance travelled. It underscores the fact that as the step count increases, so does the distance covered, validating the accuracy and reliability of the tracking system.


ggplot(data = activity_sleep, mapping = aes(x = totalminutesasleep, y = sedentaryminutes)) +
  geom_point(color = "purple") +  # Change the color of the points
  geom_smooth(method = lm, color = "darkgreen") +  # Change the color of the line
  labs(
    title = "Total Minutes Asleep vs Sedentary Minutes",
    x = "Total Minutes Asleep",  # Change the x-axis label
    y = "Sedentary Minutes"  # Change the y-axis label
  ) +
  theme_classic()  # Use a classic theme
#The plot strikingly illustrates a negative correlation between sedentary minutes and sleep duration. This suggests that individuals with longer periods of inactivity tend to sleep less. A possible interpretation could be that these individuals are more engaged in work or other non-physical activities.


steps_hourly %>%
  group_by(time) %>%
  summarize(avg_steps = mean(steptotal)) %>%
  ggplot() +
  geom_bar(mapping = aes(x = time, y = avg_steps), stat = "identity", fill = "steelblue") +
  geom_text(aes(x = time, y = avg_steps, label=round(avg_steps, 1)), vjust=-0.3, size=2) +  # Add labels to bars
  labs(
    title = "Average Steps Hourly",
    x = "Time (Hourly)",  # Change the x-axis label
    y = "Average Steps",  # Change the y-axis label
  ) +
  theme_minimal() +  # Use a minimal theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Adjust the angle and alignment of x-axis text
#This bar chart vividly illustrates the rhythm of our daily life. It's fascinating to observe that the highest step counts typically occur during lunch breaks and post-office hours. This pattern underscores the balance we strive to maintain between work, leisure, and health
