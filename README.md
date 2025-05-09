# Top UK Youtubers
tools used python, microsoft excel, microsoft sql server, power bi

data extraction - python
## Data Extraction


explain some and constraints with youtube api v3


## Data Testing in Microsoft SQL Server
``` sql
/*
data testing
1.row count should be 100  (passed)
2.channel_name column has no duplicates  (passed)
3.the view has 4 rows (passed)
4.data type check, channel_name should be nvarchar,
total_views,total_videos_total_subscribers should all be integers  (passed)
5.check for nulls  (passed)

*/

-- 1.row count should be 100 (passed)
select 
	count(*) as row_count
from 
	youtube_data_view
;


-- 2.duplicate channel_names (passed)
select 
	channel_name,
	count(*)
from 
	youtube_data_view 
GROUP BY 
	channel_name 
HAVING 
	count(*) >1
;


--3.the view has 4 rows (passed)

SELECT
    COUNT(*) AS column_count
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'youtube_data_view '
;

--4. data type check (passed)

select 
	column_name,
	data_type
from 
	INFORMATION_SCHEMA.columns
where 
	table_name = 'youtube_data_view'
;


--5.check for nulls (passed)

select 
	*
from 
	youtube_data_view
where 
	channel_name IS NULL 
	OR total_subscribers IS NULL
	OR total_videos IS NULL
	OR total_views IS NULL
;

```

importing into power bi
setting up measures 

further validating with power bi
visualizing with power bi

importing into excel
checking for errors between msqls and excel
```sql
--Views Per Video
SELECT 
	channel_name,
	total_subscribers,
	ROUND(CAST(total_views AS FLOAT) / total_videos, 0) AS views_per_video
FROM 
	youtube_data_view
ORDER BY
	total_subscribers DESC
;

-- Case
DECLARE @Investment INT =100000;
DECLARE @Conversion_Rate FLOAT =0.02;
DECLARE @Product_Price FLOAT = 5;
--Potential Sales Per Video
WITH sales_per_video_cte AS(
SELECT 
	channel_name,
	total_subscribers,
	ROUND(CAST(total_views AS FLOAT) / total_videos, 0)  AS views_per_video
FROM 
	youtube_data_view
)
SELECT 
	channel_name,
	total_subscribers,
	ROUND(views_per_video * @Conversion_Rate,0) as potential_sales_per_video
FROM 
	sales_per_video_cte
ORDER BY
	total_subscribers DESC
;


-- Potential Revenue
WITH potential_revenue_cte AS(
SELECT 
	channel_name,
	total_subscribers,
	ROUND(CAST(total_views AS FLOAT) / total_videos, 0) AS views_per_video
FROM 
	youtube_data_view
)
SELECT 
	channel_name,
	total_subscribers,
	ROUND(views_per_video* @Conversion_Rate * @Product_Price,0) as potential_revenue
FROM
	potential_revenue_cte
ORDER BY
	total_subscribers DESC
;

-- Net Profit
SELECT
	channel_name,
	total_subscribers,
	ROUND(ROUND(CAST(total_views AS FLOAT) / total_videos, 0) * @Conversion_Rate * @Product_Price - @Investment,0) as net_profit
FROM youtube_data_view
ORDER BY
	total_subscribers DESC
;
```

analysing using excel
feedback
