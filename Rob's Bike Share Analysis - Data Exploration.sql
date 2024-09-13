/*
Rob's Bike Share Data Exploration

Skills Used: CTEs, Joins, Union
*/

-- Create a CTE combining the 2 years of store data

WITH bike_share_yrs AS (
	SELECT *
		FROM bike_share_yr_0
			UNION 
	SELECT *
		FROM bike_share_yr_1)

-- Join the CTE with the cost table
  
SELECT dteday,
	   season,
	   bike_share_yrs.yr,
	   weekday,
	   hr,
	   rider_type,
	   riders,
	   price,
	   COGS,
	   riders*price AS revenue,
	   riders*price - COGS AS profit
	FROM bike_share_yrs
LEFT JOIN cost_table
	ON cost_table.yr = bike_share_yrs.yr;
