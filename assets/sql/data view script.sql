CREATE VIEW youtube_data_view AS(
SELECT CAST(SUBSTRING(NOMBRE, 1,CHARINDEX('@',NOMBRE,1)-2)as nvarchar(100)) as channel_name,
	total_subscribers,
	total_videos,
	total_views
FROM youtube_data);
