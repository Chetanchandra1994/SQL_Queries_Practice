-- create database interview_prep;

use interview_prep;


-- Create Network_Performance table
CREATE TABLE Network_Performance (
    City VARCHAR(100),
    Region VARCHAR(100),
    Download_Speed FLOAT,
    Upload_Speed FLOAT,
    Weather_Condition VARCHAR(100)
);

ALTER TABLE Network_Performance
ADD Area VARCHAR(100);


-- Insert sample data into Network_Performance table
INSERT INTO Network_Performance (City, Region, Download_Speed, Upload_Speed, Weather_Condition)
VALUES
    ('London', 'South East', 50, 20, 'Clear'),
    ('Manchester', 'North West', 40, 15, 'Rainy'),
    ('Birmingham', 'West Midlands', 45, 18, 'Clear');

-- Create Population_Data table
CREATE TABLE Population_Data (
    City VARCHAR(100),
    Population_Current INT,
    Population_Last_Year INT,
    Report_Date DATE
);

-- Insert sample data into Population_Data table
INSERT INTO Population_Data (City, Population_Current, Population_Last_Year, Report_Date)
VALUES
    ('London', 9000000, 8500000, '2023-01-01'),
    ('Manchester', 3000000, 2800000, '2023-01-01'),
    ('Birmingham', 2500000, 2300000, '2023-01-01');

-- Create Broadband_Usage table
CREATE TABLE Broadband_Usage (
    Customer_ID INT,
    Usage_Date DATE,
    Usage FLOAT
);

-- Insert sample data into Broadband_Usage table
INSERT INTO Broadband_Usage (Customer_ID, Usage_Date, Usage)
VALUES
    (1, '2023-01-01', 50),
    (1, '2023-02-01', 60),
    (1, '2023-03-01', 70),
    (2, '2023-01-01', 30),
    (2, '2023-02-01', 35),
    (2, '2023-03-01', 40);

-- Create Customer_Complaints table
CREATE TABLE Customer_Complaints (
    Complaint_ID INT,
    Complaint_Category VARCHAR(100),
    Complaint_Type VARCHAR(100)
);

-- Insert sample data into Customer_Complaints table
INSERT INTO Customer_Complaints (Complaint_ID, Complaint_Category, Complaint_Type)
VALUES
    (1, 'Broadband', 'Slow Internet'),
    (2, 'Broadband', 'Connection Drops'),
    (3, 'Broadband', 'Billing Issues');

-- Create Infrastructure_Deployment table
CREATE TABLE Infrastructure_Deployment (
    City VARCHAR(100),
    Installation_Date DATE,
    Cable_Type VARCHAR(100),
    Cable_Length FLOAT
);

-- Insert sample data into Infrastructure_Deployment table
INSERT INTO Infrastructure_Deployment (City, Installation_Date, Cable_Type, Cable_Length)
VALUES
    ('London', '2023-01-01', 'Fiber Optic', 100),
    ('Manchester', '2023-01-01', 'Copper', 80),
    ('Birmingham', '2023-01-01', 'Fiber Optic', 120);



-- For Network_Performance table
ALTER TABLE Network_Performance
ADD Download_Speed FLOAT; -- Assuming Download_Speed is a numeric column, adjust data type if needed

-- For Population_Data table
ALTER TABLE Population_Data
ADD Population_Density FLOAT; -- Assuming Population_Density is a numeric column, adjust data type if needed

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create Broadband Usage table
CREATE TABLE Broadband_Usage (
    Customer_ID INT,
    Usage_Date DATE,
    Usage FLOAT
);


-- Insert sample data into Broadband_Usage table
INSERT INTO Broadband_Usage (Customer_ID, Usage_Date, Usage)
VALUES
    (1, '2023-01-15', 100),
    (1, '2023-02-15', 120),
    (1, '2023-03-15', 150),
    (2, '2023-01-15', 80),
    (2, '2023-02-15', 90),
    (2, '2023-03-15', 110);

-- Create Broadband Data table
CREATE TABLE Broadband_Data (
    City VARCHAR(100),
    Broadband_Coverage_Percentage FLOAT
);

-- Insert sample data into Broadband_Data table
INSERT INTO Broadband_Data (City, Broadband_Coverage_Percentage)
VALUES
    ('London', 90),
    ('Manchester', 85),
    ('Birmingham', 80);

-- Create Economic Indicators table
CREATE TABLE Economic_Indicators (
    City VARCHAR(100),
    Average_Income FLOAT
);

-- Insert sample data into Economic_Indicators table
INSERT INTO Economic_Indicators (City, Average_Income)
VALUES
    ('London', 50000),
    ('Manchester', 45000),
    ('Birmingham', 42000);

-- Create Network Equipment table
CREATE TABLE Network_Equipment (
    City VARCHAR(100),
    Equipment_Installation_Date DATE
);

-- Insert sample data into Network_Equipment table
INSERT INTO Network_Equipment (City, Equipment_Installation_Date)
VALUES
    ('London', '2010-01-01'),
    ('London', '2015-01-01'),
    ('Manchester', '2012-01-01'),
    ('Manchester', '2016-01-01'),
    ('Birmingham', '2013-01-01'),
    ('Birmingham', '2017-01-01');

-- Create Customer Demographics table
CREATE TABLE CustomerDemographics (
    Age_Group VARCHAR(10),
    Total_Data_Consumed FLOAT
);

-- Insert sample data into CustomerDemographics table
INSERT INTO CustomerDemographics (Age_Group, Total_Data_Consumed)
VALUES
    ('18-30', 500),
    ('31-45', 700),
    ('45+', 400);

-- Create Search Trends table
CREATE TABLE Search_Trends (
    City VARCHAR(100),
    Keyword VARCHAR(100)
);

-- Insert sample data into Search_Trends table
INSERT INTO Search_Trends (City, Keyword)
VALUES
    ('London', 'broadband speed'),
    ('Manchester', 'broadband plans'),
    ('Birmingham', 'fiber optic broadband');

------------------------------------------------------------------------------------------------------------------------------------------------------

/*
Here are scenario-based SQL questions and answers:

1.	Scenario: As part of the project, you need to analyze the network performance data to identify areas with low broadband speeds. Write a SQL query to calculate the average download speed for each geographical region.
Answer:
*/

SELECT Region, AVG(Download_Speed) AS Avg_Download_Speed
FROM Network_Performance
GROUP BY Region;

/*
2.	Scenario: Your project team wants to understand the relationship between broadband speed and population density in different cities. Write a SQL query to join the network performance data with population density data and calculate the correlation between broadband speed and population density for each city.
Answer:
*/

SELECT 
    np.City,
    SUM((np.Download_Speed - np.Mean_Download_Speed) * (pd.Population_Density - pd.Mean_Population_Density)) / 
    SQRT(SUM(POWER(np.Download_Speed - np.Mean_Download_Speed, 2)) * SUM(POWER(pd.Population_Density - pd.Mean_Population_Density, 2))) AS Pearson_Correlation
FROM 
    (
        SELECT 
            City, 
            AVG(Download_Speed) AS Mean_Download_Speed
        FROM 
            Network_Performance
        GROUP BY 
            City
    ) AS np
JOIN 
    (
        SELECT 
            City, 
            AVG(Population_Density) AS Mean_Population_Density
        FROM 
            Population_Data
        GROUP BY 
            City
    ) AS pd ON np.City = pd.City
GROUP BY 
    np.City;



/*
3.	Scenario: The project team needs to identify areas where the deployment of fiber-optic broadband infrastructure is most urgently needed. Write a SQL query to rank areas based on the number of households with below-average broadband speeds.
Answer:
*/

WITH Avg_Speed AS (
    SELECT 
        Region, 
        AVG(Download_Speed) AS Avg_Download_Speed
    FROM 
        Network_Performance
    GROUP BY 
        Region
)
SELECT 
    np.City, 
    COUNT(*) AS Below_Avg_Speed_Households
FROM 
    Network_Performance np
JOIN 
    Avg_Speed AS avg_speed ON np.Region = avg_speed.Region
WHERE 
    np.Download_Speed < avg_speed.Avg_Download_Speed
GROUP BY 
    np.City
ORDER BY 
    Below_Avg_Speed_Households DESC;

/*
4.	Scenario: Your project requires analyzing customer complaints related to broadband services. Write a SQL query to extract the top 5 most common types of broadband-related complaints from the customer complaints dataset.
Answer:
*/

SELECT 
    Complaint_Type, 
    COUNT(*) AS Num_of_Complaints
FROM 
    Customer_Complaints
WHERE 
    Complaint_Category = 'Broadband'
GROUP BY 
    Complaint_Type
ORDER BY 
    Num_of_Complaints DESC;
 

/*
5.	Scenario: The project team needs to track the progress of broadband infrastructure deployment over time. Write a SQL query to calculate the total length of fiber-optic cables installed each month.
Answer:
*/

SELECT 
    DATEADD(month, DATEDIFF(month, 0, Installation_Date), 0) AS Month_Year, 
    SUM(Cable_Length) AS Total_Cable_Length
FROM 
    Infrastructure_Deployment
WHERE 
    Cable_Type = 'Fiber Optic'
GROUP BY 
    DATEADD(month, DATEDIFF(month, 0, Installation_Date), 0)
ORDER BY 
    DATEADD(month, DATEDIFF(month, 0, Installation_Date), 0);


/*
6.	Scenario: As part of the project, you are tasked with identifying areas where the network infrastructure is outdated and needs upgrading. Write a SQL query to identify the top 10 cities with the highest average age of network equipment.
Answer:
*/

SELECT 
    City, 
    AVG(DATEDIFF(YEAR, Equipment_Installation_Date, GETDATE())) AS Avg_Equipment_Age
FROM 
    Network_Equipment
GROUP BY 
    City
ORDER BY 
    Avg_Equipment_Age DESC;

/*
7.	Scenario: Your project requires analyzing the usage patterns of different broadband plans across various customer segments. Write a SQL query to calculate the total data consumption for each broadband plan type (e.g., Basic, Standard, Premium) in the past month.
Answer:
*/

SELECT 
    Broadband_Plan_Type, 
    SUM(Data_Consumed) AS Total_Data_Consumed
FROM 
    Usage_Data
WHERE 
    Usage_Date >= DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0)
    AND Usage_Date < DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
GROUP BY 
    Broadband_Plan_Type;


/*
8.	Scenario: The project team wants to analyze the impact of network outages on customer satisfaction. Write a SQL query to calculate the average duration of network outages for each outage type (e.g., Maintenance, Fault) in hours.
Answer:
*/

SELECT 
    Outage_Type, 
    AVG(DATEDIFF(HOUR, Outage_Start_Time, Outage_End_Time)) AS Avg_Outage_Duration_Hours
FROM 
    Network_Outages
GROUP BY 
    Outage_Type;

/*
9.	Scenario: Your project requires identifying potential areas for expanding broadband coverage based on population growth trends. Write a SQL query to calculate the percentage change in population for each city over the past year.
Answer:
*/

SELECT 
    City, 
    ((Population_Current - Population_Last_Year) / Population_Last_Year) * 100 AS Population_Growth_Percentage
FROM 
    Population_Data
WHERE 
    YEAR(Report_Date) = YEAR(CURRENT_DATE) AND MONTH(Report_Date) = MONTH(CURRENT_DATE)
ORDER BY 
    Population_Growth_Percentage DESC;

/*
10.	Scenario: Your project requires analyzing the correlation between broadband service availability and local economic indicators. Write a SQL query to join broadband coverage data with economic indicators data and calculate the correlation coefficient between broadband coverage percentage and average income for each city.
Answer:
*/

SELECT 
    bd.City, 
    CORR(bd.Broadband_Coverage_Percentage, ei.Average_Income) AS Correlation_Coefficient
FROM 
    Broadband_Data bd
JOIN 
    Economic_Indicators ei ON bd.City = ei.City
GROUP BY 
    bd.City;

/*
11.	Scenario: Your project involves forecasting future broadband usage based on historical data. Write a SQL query to calculate the month-over-month percentage change in broadband usage for each customer.
Answer:
*/

SELECT 
    Customer_ID, 
    Usage_Month, 
    (Usage - LAG(Usage) OVER (PARTITION BY Customer_ID ORDER BY Usage_Month)) / LAG(Usage) OVER (PARTITION BY Customer_ID ORDER BY Usage_Month) * 100 AS Monthly_Percentage_Change
FROM 
    Broadband_Usage
ORDER BY 
    Customer_ID, Usage_Month;

/*
12.	Scenario: Your project requires analyzing the impact of weather conditions on network performance. Write a SQL query to calculate the average network latency during rainy days compared to clear days.
Answer:
*/

SELECT 
    Weather_Condition, 
    AVG(Network_Latency) AS Avg_Network_Latency
FROM 
    Network_Performance
WHERE 
    Weather_Condition IN ('Rainy', 'Clear')
GROUP BY 
    Weather_Condition;

/*
13.	Scenario: Your project team wants to identify potential areas for installing additional network infrastructure based on the density of broadband users. Write a SQL query to calculate the number of broadband users per square kilometer for each city.
Answer:
*/

SELECT 
    City, 
    SUM(Broadband_Users) / City_Area AS Users_Per_Square_Km
FROM 
    Broadband_Usage bu
JOIN 
    City_Geography cg ON bu.City = cg.City
GROUP BY 
    City;
 
/*
14.	Scenario: Your project involves analyzing customer churn patterns to improve retention strategies. Write a SQL query to identify customers who have churned in the past month and their reasons for leaving.
Answer:
*/

SELECT 
    Customer_ID, 
    Reason_For_Churn
FROM 
    Customer_Churn
WHERE 
    Churn_Date >= DATEADD(MONTH, -1, GETDATE());

/* 
15.	Scenario: Your project requires identifying potential areas with high demand for broadband services based on search trends. Write a SQL query to analyze search queries related to broadband services and identify the top 5 most searched keywords.
Answer:
*/

SELECT 
    Keyword, 
    COUNT(*) AS Search_Count
FROM 
    Search_Trends
WHERE 
    Keyword LIKE '%broadband%'
GROUP BY 
    Keyword
ORDER BY 
    Search_Count DESC
LIMIT 5;


/*
Here are some SQL questions and answers for a data analyst role in a telecom project, involving CTEs, joins, merge, subquery, substring, and date functions:
1.	Question: Write a SQL query to calculate the total data consumption for each broadband plan type (e.g., Basic, Standard, Premium) in the past month, using a common table expression (CTE) to filter data.
Answer:
*/

WITH RecentUsage AS (
    SELECT 
        Broadband_Plan_Type, 
        SUM(Data_Consumed) AS Total_Data_Consumed
    FROM 
        Usage_Data
    WHERE 
        DATE_TRUNC('month', Usage_Date) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
    GROUP BY 
        Broadband_Plan_Type
)
SELECT * FROM RecentUsage;

/*
2.	Question: Write a SQL query to join the broadband coverage data with the economic indicators data and calculate the correlation coefficient between broadband coverage percentage and average income for each city, using a subquery.
Answer:
*/

SELECT 
    bd.City, 
    CORR(bd.Broadband_Coverage_Percentage, ei.Average_Income) AS Correlation_Coefficient
FROM 
    (SELECT * FROM Broadband_Data) bd
JOIN 
    (SELECT * FROM Economic_Indicators) ei ON bd.City = ei.City
GROUP BY 
    bd.City;

/*
3.	Question: Write a SQL query to retrieve the top 5 cities with the highest average age of network equipment, using a subquery to calculate the average age.
Answer:
*/

SELECT 
    City, 
    AVG(DATEDIFF(YEAR, Equipment_Installation_Date, GETDATE())) AS Avg_Equipment_Age
FROM 
    Network_Equipment
GROUP BY 
    City
ORDER BY 
    Avg_Equipment_Age DESC
LIMIT 5;

/*
4.	Question: Write a SQL query to calculate the month-over-month percentage change in broadband usage for each customer, using the substring function to extract the month and year from the usage date.
Answer:
*/

SELECT 
    Customer_ID, 
    Usage_Month, 
    (Usage - LAG(Usage) OVER (PARTITION BY Customer_ID ORDER BY Usage_Month)) / LAG(Usage) OVER (PARTITION BY Customer_ID ORDER BY Usage_Month) * 100 AS Monthly_Percentage_Change
FROM 
    (SELECT *, SUBSTRING(Usage_Date, 1, 7) AS Usage_Month FROM Broadband_Usage) bu
ORDER BY 
    Customer_ID, Usage_Month;

/*
5.	Question: Write a SQL query to merge the broadband usage data with the customer demographics data and calculate the total data consumption for each age group, using a merge operation.
Answer:
*/

MERGE INTO CustomerDemographics AS tgt
USING (
    SELECT 
        Age_Group, 
        SUM(Data_Consumed) AS Total_Data_Consumed
    FROM 
        (SELECT *, CASE WHEN Age BETWEEN 18 AND 30 THEN '18-30'
                       WHEN Age BETWEEN 31 AND 45 THEN '31-45'
                       ELSE '45+' END AS Age_Group FROM Broadband_Usage) bu
    GROUP BY 
        Age_Group
) AS src
ON 
    tgt.Age_Group = src.Age_Group
WHEN MATCHED THEN
    UPDATE SET Total_Data_Consumed = src.Total_Data_Consumed
WHEN NOT MATCHED THEN
    INSERT (Age_Group, Total_Data_Consumed) 
    VALUES (src.Age_Group, src.Total_Data_Consumed);

/*
6.	Question: Write a SQL query to identify potential areas with high demand for broadband services based on search trends, using a join operation with a subquery.
Answer:
*/

SELECT 
    Keyword, 
    COUNT(*) AS Search_Count
FROM 
    Search_Trends st
JOIN 
    (SELECT DISTINCT City FROM Broadband_Coverage WHERE Broadband_Coverage_Percentage > 80) bc ON st.City = bc.City
WHERE 
    Keyword LIKE '%broadband%'
GROUP BY 
    Keyword
ORDER BY 
    Search_Count DESC
LIMIT 5;


