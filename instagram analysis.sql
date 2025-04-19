#1. How many unique post types are found in the 'fact_content' table?

select distinct post_type from fact_content;

#2. What are the highest and lowest recorded impressions for each post type?

select post_type, max(impressions) as highest_impressions , min(impressions) as lowest_impressions from fact_content
group by post_type;

#3. Filter all the posts that were published on a weekend in the month of March and April
#and export them to a separate csv file.

select fc.* from fact_content fc
right join dim_dates d on
fc.date = d.date
where month_name in ("april","march")
and weekday_or_weekend  = "Weekend";

#4 Create a report to get the statistics for the account. The final output includes the following fields:
# . month_name
#• total_profile_visits
#• total_new_followers

select month_name, sum(profile_visits) as total_profile_visits ,sum(new_followers) as total_new_followers
from fact_account a 
join dim_dates d on
a.date = d.date
group by month_name;

#5 Write a CTE that calculates the total number of 'likes’ for each 'post_category' during 
#the month of 'July' and subsequently, arrange the 'post_category' values in descending order 
#according to their total likes.

with cte as ( select c.post_category , sum(c.likes) as total_likes
from fact_content c join dim_dates d
on c.date = d.date
where month_name = "july"
group by c.post_category)
select post_category , total_likes
from cte order by total_likes desc;

#6. Create a report that displays the unique post_category names alongside
# their respective counts for each month. The output should have three columns:
#month_name
#post_category_names
#post_category_count
#Example:
#'April', 'Earphone,Laptop,Mobile,Other Gadgets,Smartwatch', '5'
# 'February', 'Earphone,Laptop,Mobile,Smartwatch', '4'

select d.month_name , group_concat(distinct c.post_category , ',') AS post_category_name,
 count(distinct c.post_category) as post_category_count
from fact_content c join dim_dates d
on c.date = d.date
group by d.month_name
order by d.month_name;

#7.What is the percentage breakdown of total reach by post type? The final output includes the following fields:
#post_type
#total_reach
#reach_percentage

select post_type ,
 sum(reach) as total_reach,
 round(sum(reach)*100 / (select sum(reach) from fact_content) ,2) as reach_percentage
 from fact_content 
 group by post_type
 order by post_type;
 
 #8.Create a report that includes the quarter, total comments, and total saves recorded for each post category. Assign the following quarter groupings:
#(January, February, March) → “Q1”
#(April, May, June) → “Q2”
#(July, August, September) → “Q3”
 #The final output columns should consist of:
#post_category
#quarter
#total_comments
#total_saves

 with cte as ( select c.post_category,
 case
    when d.month_name in ("January","February","March") then "Q1"
    when d.month_name in ("April","May","June") then "Q2"
    when d.month_name in ("July","August","September") then "Q3"
    else "Q4" 
    end as quarter,
    c.comments, c.saves
    from fact_content c join
    dim_dates d on c.date = d.date
    )
    select post_category,
    quarter,
    sum(comments) as total_comments,
    sum(saves) as total_saves
    from cte 
    group by post_category, quarter
    order by post_category, quarter;
    
#List the top three dates in each month with the highest number of new followers.
# The final output should include the following columns:
#month
#date
#new_followers

select month_name,
date,
new_followers from (
select d.month_name ,
a.date,
a.new_followers,
row_number() over (partition by d.month_name order by a.new_followers desc) as rn
 from dim_dates d
join fact_account a on d.date = a.date ) ranked
where rn <=3
order by month_name, new_followers;

#10.Create a stored procedure that takes the 'Week_no' as input and generates a report displaying
# the total shares for each 'Post_type'. The output of the procedure should consist of two columns:
#post_type
#total_shares

delimiter //    
CREATE PROCEDURE GetWeekData( in week_no varchar(255))
BEGIN
    SELECT c.post_type,
           SUM(c.shares) AS total_shares
    FROM fact_content c
    JOIN dim_dates d ON c.date = d.date
    WHERE d.week_no = week_no
    GROUP BY c.post_type;
END //


      
 
  
 
