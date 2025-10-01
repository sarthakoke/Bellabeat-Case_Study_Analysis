--Looking for Distinct Number of Users in all the Files
SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..daily_activity
--33 Users

SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..daily_sleep
--24 Users

SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..heartrate
--7 Users

SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..hourly_calories
--33 Users

SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..hourly_intensities
--33 Users

SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..hourly_steps
--33 Users

SELECT COUNT (DISTINCT Id) AS Total_Ids 
FROM FitBitProject..weight_log
--8 Users

--Insufficient data in the ‘weight_log’ and ‘heartrate’ datasets hinders the progression of our analysis

SELECT Id,
COUNT(Id) AS Days_of_Activity
FROM FitBitProject..daily_activity
GROUP BY Id

--SELECT 
--    Id,
--    COUNT(Date) AS Total_Activity_Days,
--    AVG(TotalSteps) AS Average_Steps,
--    AVG(TotalDistance) AS Average_Distance,
--    AVG(Calories) AS Average_Calories,
--    SUM(VeryActiveMinutes) AS Total_VeryActive_Minutes,
--    SUM(FairlyActiveMinutes) AS Total_FairlyActive_Minutes,
--    SUM(LightlyActiveMinutes) AS Total_LightlyActive_Minutes,
--    SUM(SedentaryMinutes) AS Total_Sedentary_Minutes
--FROM 
--    FitBitProject..daily_activity
--GROUP BY 
--    Id

--1) Total Activity Days Distribution (Table)
SELECT 
  Total_Activity_Days, COUNT(*) AS Frequency
FROM 
  (SELECT 
    Id, COUNT(Date) AS Total_Activity_Days
  FROM 
    FitBitProject..daily_activity
  GROUP BY 
    Id) AS SubQuery
GROUP BY 
  Total_Activity_Days
ORDER BY 
  Total_Activity_Days DESC

--During the specified data collection period from April 12, 2016, to May 12, 2016, we observed that 64% of users consistently logged their data using their BellaBeat Tracker. Furthermore, when we consider users who missed logging their data for only 1 to 3 days, the proportion of users demonstrating consistent usage increases significantly to 82%. This indicates a high level of engagement with the BellaBeat Tracker over this one-month period.

--In the subsequent phase of our analysis, we aimed to categorize users based on their usage of the FitBit Fitness Tracker. We established three distinct categories of users:

--Consistent Users: These are individuals who utilized their tracker for a substantial duration ranging from 25 to 31 days.
--Intermittent Users: This group includes users who wore their tracker for a moderate duration, specifically between 15 to 24 days.
--Occasional Users: These users represent the lowest usage group, having worn their tracker for a period of 0 to 14 days.

SELECT Id,
COUNT(Id) AS Total_Logged_Uses,
CASE
	WHEN COUNT(Id) BETWEEN 25 AND 31 THEN 'Consistent User'
	WHEN COUNT(Id) BETWEEN 15 and 24 THEN 'Intermittent User'
	WHEN COUNT(Id) BETWEEN 0 and 14 THEN 'Occasional User'
END Fitbit_User_Type
FROM FitBitProject..daily_activity
GROUP BY Id

--2) User Distribuition (Pie Chart)
select Fitbit_User_Type,count(*) As No_of_Users
from(SELECT Id,
COUNT(Id) AS Total_Logged_Uses,
CASE
	WHEN COUNT(Id) BETWEEN 25 AND 31 THEN 'Consistent User'
	WHEN COUNT(Id) BETWEEN 15 and 24 THEN 'Intermittent User'
	WHEN COUNT(Id) BETWEEN 0 and 14 THEN 'Occasional User'
END Fitbit_User_Type
FROM FitBitProject..daily_activity
GROUP BY Id) AS SubQuery
Group By Fitbit_User_Type

--Next, I am interested in examining the minimum, maximum, and average values of total steps, total distance, calories, and activity levels, categorized by each unique Id.

SELECT Id,
MIN(TotalSteps) AS Min_Total_Steps,
MAX(TotalSteps) AS Max_Total_Steps, 
AVG(TotalSteps) AS Avg_Total_Stpes,
MIN(TotalDistance) AS Min_Total_Distance, 
MAX(TotalDistance) AS Max_Total_Distance, 
AVG(TotalDistance) AS Avg_Total_Distance,
MIN(Calories) AS Min_Total_Calories,
MAX(Calories) AS Max_Total_Calories,
AVG(Calories) AS Avg_Total_Calories,
MIN(VeryActiveMinutes) AS Min_Very_Active_Minutes,
MAX(VeryActiveMinutes) AS Max_Very_Active_Minutes,
AVG(VeryActiveMinutes) AS Avg_Very_Active_Minutes,
MIN(FairlyActiveMinutes) AS Min_Fairly_Active_Minutes,
MAX(FairlyActiveMinutes) AS Max_Fairly_Active_Minutes,
AVG(FairlyActiveMinutes) AS Avg_Fairly_Active_Minutes,
MIN(LightlyActiveMinutes) AS Min_Lightly_Active_Minutes,
MAX(LightlyActiveMinutes) AS Max_Lightly_Active_Minutes,
AVG(LightlyActiveMinutes) AS Avg_Lightly_Active_Minutes,
MIN(SedentaryMinutes) AS Min_Sedentary_Minutes,
MAX(SedentaryMinutes) AS Max_Sedentary_Minutes,
AVG(SedentaryMinutes) AS Avg_Sedentary_Minutes
From FitBitProject..daily_activity
Group BY Id
order by 1

SELECT Id, 
avg(VeryActiveMinutes) AS Avg_Very_Active_Minutes,
avg(FairlyActiveMinutes) AS Avg_Fairly_Active_Minutes,
avg(LightlyActiveMinutes) AS Avg_Lightly_Active_Minutes,
avg(SedentaryMinutes) AS Avg_Sedentary_Minutes
From FitBitProject..daily_activity
GROUP BY Id
order by 5 desc

--3) Average Category Based Active Minutes
SELECT --WeekDay,
	ROUND (avg(VeryActiveMinutes), 2) AS Avg_Very_Active_Minutes,
	ROUND (avg(FairlyActiveMinutes), 2) AS Avg_Fairly_Active_Minutes,
	ROUND (avg(LightlyActiveMinutes), 2) AS Avg_Lightly_Active_Minutes,
	ROUND (avg(SedentaryMinutes), 2) AS Avg_Sedentary_Minutes
	,ROUND (avg(TotalActiveMinutes), 2) AS Avg_Total_Active_Minutes
From FitBitProject..daily_activity
--GROUP BY WeekDay

--4) Weekly Average Active Minutes(Bar Graphs)
SELECT 
    WeekDay AS Day_In_Week,
    ROUND(avg(VeryActiveMinutes), 2) AS Average_Highly_Active_Minutes,
    ROUND(avg(FairlyActiveMinutes), 2) AS Average_Moderate_Active_Minutes,
    ROUND(avg(LightlyActiveMinutes), 2) AS Average_Low_Active_Minutes,
    ROUND(avg(SedentaryMinutes), 2) AS Average_Inactive_Minutes,
	ROUND (avg(TotalActiveMinutes), 2) AS Avg_Active_Minutes
FROM FitBitProject..daily_activity
GROUP BY WeekDay
--Users spend most of their time in sedentary activities, with no significant variation in activity levels throughout the week. It seems users are consistent in their active minute output each day. Bellabeat could capitalize on this by encouraging users to aim for higher goals, particularly in very active or fairly active minutes. This could potentially increase overall daily activity levels.

--According to the CDC, adults need 150 minutes of moderate-intensity physical activity each week. This can be achieved through various forms of exercise, including those categorized as “Very Active” and “Fairly Active”.
SELECT 
    Id,
	ROUND ((avg(VeryActiveMinutes) + avg(FairlyActiveMinutes)), 2) AS Avg_Total_Active_Minutes
FROM FitBitProject..daily_activity
GROUP BY Id
order by 1 desc

--BETWEEN '4/12/2016' AND '5/12/2016'

SELECT Id, 
avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) AS Total_Avg_Active_Minutes,
CASE 
WHEN avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) >= 150 THEN 'Meets CDC Recommendation'
WHEN avg(VeryActiveMinutes) + avg(FairlyActiveMinutes) <150 THEN 'Does Not Meet CDC Recommendation'
END CDC_Recommendations
FROM FitBitProject..daily_activity
GROUP BY Id

--Lets Try to use sum of VeryActiveMinutes, FairlyActiveMinutes & LightlyActiveMinutes as TotalActiveMinutes
SELECT Id, 
avg(TotalActiveMinutes) AS Total_Avg_Active_Minutes,
CASE 
WHEN avg(TotalActiveMinutes) >= 150 THEN 'Meets CDC Recommendation'
WHEN avg(TotalActiveMinutes) <150 THEN 'Does Not Meet CDC Recommendation'
END CDC_Recommendations
FROM FitBitProject..daily_activity
GROUP BY Id

Select CDC_Recommendations, Count(*) as No_of_Users
from(SELECT Id, 
avg(TotalActiveMinutes) AS Total_Avg_Active_Minutes,
CASE 
WHEN avg(TotalActiveMinutes) >= 150 THEN 'Meets CDC Recommendation'
WHEN avg(TotalActiveMinutes) <150 THEN 'Does Not Meet CDC Recommendation'
END CDC_Recommendations
FROM FitBitProject..daily_activity
GROUP BY Id) as SubQuery
GROUP BY CDC_Recommendations

--BETWEEN '4/17/2016' AND '4/23/2016'

Select CDC_Recommendations, Count(*) as No_of_Users
from(SELECT Id, 
avg(TotalActiveMinutes) AS Total_Avg_Active_Minutes,
CASE 
WHEN avg(TotalActiveMinutes) >= 150 THEN 'Meets CDC Recommendation'
WHEN avg(TotalActiveMinutes) <150 THEN 'Does Not Meet CDC Recommendation'
END CDC_Recommendations
FROM FitBitProject..daily_activity
WHERE Date BETWEEN '4/17/2016' AND '4/23/2016'
GROUP BY Id) as SubQuery
GROUP BY CDC_Recommendations


--BETWEEN '5/1/2016' AND '5/7/2016'

Select CDC_Recommendations, Count(*) as No_of_Users
from(SELECT Id, 
avg(TotalActiveMinutes) AS Total_Avg_Active_Minutes,
CASE 
WHEN avg(TotalActiveMinutes) >= 150 THEN 'Meets CDC Recommendation'
WHEN avg(TotalActiveMinutes) <150 THEN 'Does Not Meet CDC Recommendation'
END CDC_Recommendations
FROM FitBitProject..daily_activity
WHERE Date BETWEEN '5/1/2016' AND '5/7/2016'
GROUP BY Id) as SubQuery
GROUP BY CDC_Recommendations

--Upon comparing the activity data from April and May, I observed no substantial changes in the weekly activity duration. However, it’s important to note that these data points are only a week apart, and the overall data collection period is relatively short. The dataset summary (BellaBeat Tracker Data) indicates that data was collected from March 12, 2016, to May 12, 2016. However, for most users, data tracking didn’t start until April 12, 2016. This suggests that we only have one month’s worth of data to analyze. This limited timeframe may not be sufficient to observe any significant changes in user habits from the time they started using the wearable device until the end of the data collection period.
SELECT 
Time
FROM FitBitProject..heartrate
GROUP BY Time
--ORDER BY Total_Steps_By_Hour DESC

SELECT CONVERT(VARCHAR, Time, 108) AS FormattedTime
FROM FitBitProject..heartrate

Select WeekDay, avg(Value) as Average_Heartrate
From FitBitProject..heartrate
group by weekday

--User Type by Number of Steps
SELECT Id,
avg(TotalSteps) AS Avg_Total_Steps,
CASE
WHEN avg(TotalSteps) < 5000 THEN 'Sedentary Lifestyle'
WHEN avg(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Lightly Active Lifestyle'
WHEN avg(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Moderately Active Lifestyle'
WHEN avg(TotalSteps) BETWEEN 10000 AND 12499 THEN 'Active Lifestyle'
WHEN avg(TotalSteps) >= 12500 THEN 'Highly Active Lifestyle'
END User_Type
FROM FitBitProject..daily_activity
GROUP BY Id

--5) User Distribution according to their Total_Steps Per Day (Pie Chart)
Select User_type, Count(*) As Number_of_Users
from(SELECT Id,
avg(TotalSteps) AS Avg_Total_Steps,
CASE
WHEN avg(TotalSteps) < 5000 THEN 'Sedentary Lifestyle'
WHEN avg(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Lightly Active Lifestyle'
WHEN avg(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Moderately Active Lifestyle'
WHEN avg(TotalSteps) BETWEEN 10000 AND 12499 THEN 'Active Lifestyle'
WHEN avg(TotalSteps) >= 12500 THEN 'Highly Active Lifestyle'
END User_Type
FROM FitBitProject..daily_activity
GROUP BY Id) As SubQuery
Group By User_Type

--Upon analyzing the data, we can categorize our users into two main groups: ‘Moderately Active Lifestyle & Sedentary Lifestyle’ users and ‘Active Lifestyle’ users. 
--The distribution is almost evenly split, with 17 users (52%) falling into the ‘Moderately Active Lifestyle & Sedentary Lifestyle’ category and 16 users (48%) classified as ‘Active Lifestyle’.
--This distribution aligns closely with our earlier findings when we examined active minutes. 
--When we excluded the ‘LightlyActiveMinutes’ from our analysis, we found that 17 users (52%) adhered to the CDC’s recommendation of engaging in 150 active minutes per week. 
--Conversely, 13 users (39%) fell short of these guidelines. Additionally, we found that data was unavailable for 3 users (9%) for that particular week.



--Calories, Steps & Active Minutes by ID
SELECT Id, 
Sum(TotalSteps) AS Sum_total_steps,
SUM(Calories) AS Sum_Calories, 
SUM(TotalActiveMinutes) AS Sum_Active_Minutes
FROM FitBitProject..daily_activity
GROUP BY Id

--6)Total Steps by Day (Bar Chart)
SELECT WeekDay,
ROUND (avg(TotalSteps), 2) AS Average_Total_Steps
FROM FitBitProject..daily_activity
GROUP BY WeekDay
ORDER BY Average_Total_Steps DESC 

--Upon executing the query, the variation in the average number of steps taken each day was found to be minimal. However, it was observed that Saturdays recorded the highest average step count, followed closely by the early weekdays, specifically Monday and Tuesday. This pattern could potentially suggest that users tend to engage in more physical activity immediately after the weekend. Interestingly, Sunday registered the lowest total steps, with Friday not far ahead, possibly indicating a period of rest for most users. Furthermore, the high activity level on Saturdays could be attributed to users having more free time for physical activities and movement. This analysis provides valuable insights into user behavior and activity patterns throughout the week.


--7)Total Steps by Hour (Bar Chart)
SELECT 
CONVERT(VARCHAR, Time, 108) AS Time_Of_the_Day,
SUM(StepTotal) AS Total_Steps_By_Hour
FROM FitBitProject..hourly_steps
GROUP BY Time
ORDER BY Total_Steps_By_Hour DESC

----Let's Analyse Sleep Data (Compare the Sleep Data to Activity levels)
--Date and Total Sleep Minutes
SELECT 
Date,
SUM(TotalMinutesAsleep) AS Total_Minutes_Asleep
FROM FitBitProject..daily_sleep
WHERE Date IS NOT NULL
GROUP BY Date
ORDER BY 2 DESC

--8)Average Sleep Hours, Step Total and Calories by user Id.
SELECT a.Id,
avg(a.TotalSteps) AS AvgTotalSteps,
avg(a.Calories) AS AvgCalories,
avg(s.TotalMinutesAsleep) AS AvgTotalMinutesAsleep,
ROUND((AVG(CAST(s.TotalMinutesAsleep AS DECIMAL))/60), 2) AS AvgTotalHoursAsleep
FROM FitBitProject..daily_activity AS a
INNER JOIN FitBitProject..daily_sleep AS s ON a.Id=s.Id
GROUP BY a.Id
--The graph indicates that a majority of users who achieved a minimum of 7 hours of sleep tended to have a higher step count. However, it’s noteworthy that most users did not meet the recommended daily average of 10,000 steps.


----Total Step vs Total Calories
--SELECT SUM(HC.Calories) AS TotalCalories, SUM(HS.StepTotal) AS TotalSteps
--FROM FitBitProject..hourly_calories HC
--JOIN FitBitProject..hourly_steps HS ON HC.Id = HS.Id AND HC.Date=HS.Date And HC.Time= HS.Time
--Group by HS.StepTotal
--order by 1 DESC

--SELECT SUM(HS.StepTotal) AS TotalSteps, SUM(HC.Calories) AS TotalCalories
--FROM FitBitProject..hourly_steps HS 
--JOIN FitBitProject..hourly_calories HC ON HS.Id = HC.Id AND HS.Date=HC.Date And HS.Time= HC.Time
--Group by HC.Calories
--order by 1 DESC

----9)Total Step vs Total Calories
select SUM(Calories) as TotalCalories, SUM(TotalSteps) As TotalSteps
from FitBitProject..daily_activity
group by Calories

----10)TotalActiveMinutes vs Total Calories
select SUM(Calories) as TotalCalories, SUM(TotalActiveMinutes) As TotalActiveMinutes
from FitBitProject..daily_activity
group by Calories

----11)TotalDistance vs Total Calories
select SUM(Calories) as TotalCalories, SUM(TotalDistance) As TotalDistance
from FitBitProject..daily_activity
group by Calories

