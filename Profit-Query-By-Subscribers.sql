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