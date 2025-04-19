# Instagram Analytics: SQL & Power BI Project
Codebasics Virtual Internship Challenge | AtliQ Technologies

# Project Overview
This project analyzes a Tech Influencer's Instagram activity using SQL for data extraction and Power BI for visualization. The goal was to derive actionable insights to optimize content strategy and engagement.

# LinkedIn Post: Read my summary here
📹 Presentation Video: Watch here (https://www.linkedin.com/posts/himanshu-yaduvanshi_codebasicsvirtualinternship-dataanalytics-activity-7319398917287165953-2jpk?utm_source=share&utm_medium=member_desktop&rcm=ACoAAChbic4BEPZR4e5xsne-FfY0ccvE7CUmF4Y)

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

# SQL Challenge 
1. Unique Post Types
2. Highest/Lowest Impressions by Post Type
3. Weekend Posts (March-April)
4. Account Statistics (Monthly)
5. July Likes by Category (CTE)
6. Unique Post Categories per Month
7. Reach % by Post Type
8. Quarterly Comments & Saves
9. Top 3 Dates by New Followers (Monthly)
10. Stored Procedure: Shares by Post Type (Weekly)

