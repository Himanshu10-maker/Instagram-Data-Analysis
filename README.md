# Instagram Analytics: SQL & Power BI Project
Codebasics Virtual Internship Challenge | AtliQ Technologies

# Project Overview
This project analyzes a Tech Influencer's Instagram activity using SQL for data extraction and Power BI for visualization. The goal was to derive actionable insights to optimize content strategy and engagement.

# LinkedIn Post: Read my summary here
📹 Presentation Video: Watch here (optional link)

# Technologies Used
Database: MySQL (via MySQL Workbench)

SQL Techniques:

Basic to Advanced Queries

CTEs, Window Functions (RANK(), PARTITION BY)

Stored Procedures

Data Aggregation & Filtering

Visualization: Power BI

# Database Schema

Tables & Columns
1. dim_date
Column	Description
Date	Record date
Month Name	Month name (e.g., "January")
`Weekday	Weekend`	Day type (Weekday/Weekend)

2. fact_account
Column	Description
Profile Visits	Daily profile visits
New Followers	Daily follower growth

3. fact_content
Column	Description
Post Category	Content theme (e.g., "Mobile")
Post Type	IG Reel, Carousel, etc.
Impressions	Post views
Likes/Comments/Saves	Engagement metrics
(Full schema details in Schema Documentation)

# SQL Challenge Solutions
📝 Questions & Solutions
1. Unique Post Types

sql
SELECT DISTINCT post_type FROM fact_content;
2. Highest/Lowest Impressions by Post Type

sql
SELECT 
  post_type, 
  MAX(impressions) AS max_impressions, 
  MIN(impressions) AS min_impressions
FROM fact_content
GROUP BY post_type;
3. Weekend Posts (March-April)

sql
SELECT fc.*
FROM fact_content fc
JOIN dim_date dd ON fc.date = dd.date
WHERE dd.`Weekday | Weekend` = 'Weekend'
  AND dd.`Month Name` IN ('March', 'April')
INTO OUTFILE 'weekend_posts_mar_apr.csv'
FIELDS TERMINATED BY ',';
4. Account Statistics (Monthly)

sql
SELECT 
  dd.`Month Name` AS month_name,
  SUM(fa.`Profile Visits`) AS total_profile_visits,
  SUM(fa.`New Followers`) AS total_new_followers
FROM fact_account fa
JOIN dim_date dd ON fa.date = dd.date
GROUP BY dd.`Month Name`;
5. July Likes by Category (CTE)

sql
WITH july_likes AS (
  SELECT 
    post_category,
    SUM(likes) AS total_likes
  FROM fact_content
  WHERE MONTH(date) = 7
  GROUP BY post_category
)
SELECT * FROM july_likes
ORDER BY total_likes DESC;
6. Unique Post Categories per Month

sql
SELECT 
  dd.`Month Name` AS month_name,
  GROUP_CONCAT(DISTINCT fc.post_category) AS post_category_names,
  COUNT(DISTINCT fc.post_category) AS post_category_count
FROM fact_content fc
JOIN dim_date dd ON fc.date = dd.date
GROUP BY dd.`Month Name`;
7. Reach % by Post Type

sql
SELECT 
  post_type,
  SUM(reach) AS total_reach,
  ROUND(SUM(reach) * 100.0 / (SELECT SUM(reach) FROM fact_content), 2) AS reach_percentage
FROM fact_content
GROUP BY post_type;
8. Quarterly Comments & Saves

sql
SELECT 
  post_category,
  CASE 
    WHEN dd.`Month Name` IN ('January', 'February', 'March') THEN 'Q1'
    WHEN dd.`Month Name` IN ('April', 'May', 'June') THEN 'Q2'
    WHEN dd.`Month Name` IN ('July', 'August', 'September') THEN 'Q3'
  END AS quarter,
  SUM(comments) AS total_comments,
  SUM(saves) AS total_saves
FROM fact_content fc
JOIN dim_date dd ON fc.date = dd.date
GROUP BY post_category, quarter;
9. Top 3 Dates by New Followers (Monthly)

sql
WITH ranked_followers AS (
  SELECT 
    dd.`Month Name` AS month,
    fa.date,
    fa.`New Followers`,
    RANK() OVER (PARTITION BY dd.`Month Name` ORDER BY fa.`New Followers` DESC) AS rank_val
  FROM fact_account fa
  JOIN dim_date dd ON fa.date = dd.date
)
SELECT month, date, `New Followers` AS new_followers
FROM ranked_followers
WHERE rank_val <= 3;
10. Stored Procedure: Shares by Post Type (Weekly)

sql
DELIMITER //
CREATE PROCEDURE GetSharesByWeek(IN week_num INT)
BEGIN
  SELECT 
    fc.post_type,
    SUM(fc.shares) AS total_shares
  FROM fact_content fc
  JOIN dim_date dd ON fc.date = dd.date
  WHERE dd.`Week No` = week_num
  GROUP BY fc.post_type;
END //
DELIMITER ;


