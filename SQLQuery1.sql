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