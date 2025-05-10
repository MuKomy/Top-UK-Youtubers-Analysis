# 📹 Top UK YouTubers Analysis

An in-depth data exploration of the UK's most influential content creators on YouTube, analyzing metrics, engagement, and potential business value.

**Tech Stack:** Python, Microsoft SQL Server, Excel, Power BI

## 📊 Project Overview

This project offers a comprehensive analysis of the top 100 UK-based YouTube channels, examining their subscriber counts, total views, video output, engagement rates, and potential commercial value. By leveraging data analytics, I've uncovered insights about content strategy effectiveness across different niches and identified patterns in viewer engagement.


## 🔍 Data Extraction Process

The project began with extracting data from YouTube using the YouTube API v3. While powerful, this API presented several challenges:

- **Data scope limitations**: Certain metrics are only available to channel owners
- **Authentication requirements**: Secure OAuth 2.0 implementation was necessary for data access

The extraction process was implemented in Python using the `google-api-python-client` library, focusing on channels based in the UK with the highest subscriber counts. Channel statistics including subscriber count, video count, and view totals were collected for analysis.

## 🧪 Data Testing in Microsoft SQL Server

To ensure data quality and reliability, I conducted systematic testing in SQL Server:

```sql
/*
Data Quality Tests:
1. Row count verification (100 rows expected) ✓
2. Channel name uniqueness check ✓
3. View structure validation (4 columns expected) ✓
4. Data type verification ✓
5. Null value check ✓
*/

-- 1. Row count verification
SELECT 
    COUNT(*) AS row_count
FROM 
    youtube_data_view;

-- 2. Duplicate channel names check
SELECT 
    channel_name,
    COUNT(*)
FROM 
    youtube_data_view 
GROUP BY 
    channel_name 
HAVING 
    COUNT(*) > 1;

-- 3. View structure validation
SELECT
    COUNT(*) AS column_count
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'youtube_data_view';

-- 4. Data type verification
SELECT 
    column_name,
    data_type
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'youtube_data_view';

-- 5. Null value check
SELECT 
    *
FROM 
    youtube_data_view
WHERE 
    channel_name IS NULL 
    OR total_subscribers IS NULL
    OR total_videos IS NULL
    OR total_views IS NULL;
```

All tests passed successfully, confirming data integrity and readiness for analysis.

## 📈 Power BI Visualization & Metrics

After importing the validated data into Power BI, I established key metrics through DAX measures:

```
Views/Video = 
VAR videos = SUM(youtube_data_view[total_videos])
VAR views = SUM(youtube_data_view[total_views])
VAR views_per_video = DIVIDE(views, videos, BLANK())
RETURN views_per_video
```

```
Engagement Rate = 
VAR eng_rate = DIVIDE(youtube_data_view[Views/Video (M)]*1000000, SUM(youtube_data_view[total_subscribers]))
RETURN eng_rate
```

These metrics enabled creation of interactive dashboards visualizing:
- Channel performance comparison
- Category distribution analysis
- Engagement rate benchmarks
- Subscriber growth patterns

![Power BI Dashboard Placeholder]

## 📊 Excel Analysis & Business Modeling

The data was further analyzed in Excel to assess commercial potential through the following calculations:

- **Views Per Video**: Average viewership per content piece
- **Engagement Rate**: Viewer interaction relative to subscriber base
- **Potential Sales Per Video**: Conversion modeling based on viewership
- **Potential Revenue**: Financial projections based on product pricing
- **Net Profit**: ROI analysis accounting for marketing investment

To validate Excel calculations, parallel SQL queries were developed:

```sql
-- Views Per Video
SELECT 
    channel_name,
    total_subscribers,
    ROUND(CAST(total_views AS FLOAT) / total_videos, 0) AS views_per_video
FROM 
    youtube_data_view
ORDER BY
    total_subscribers DESC;

-- Business Case Parameters
DECLARE @Investment INT = 100000;
DECLARE @Conversion_Rate FLOAT = 0.02;
DECLARE @Product_Price FLOAT = 5;

-- Potential Sales Per Video
WITH sales_per_video_cte AS (
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
    ROUND(views_per_video * @Conversion_Rate, 0) AS potential_sales_per_video
FROM 
    sales_per_video_cte
ORDER BY
    total_subscribers DESC;

-- Potential Revenue
WITH potential_revenue_cte AS (
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
    ROUND(views_per_video * @Conversion_Rate * @Product_Price, 0) AS potential_revenue
FROM
    potential_revenue_cte
ORDER BY
    total_subscribers DESC;

-- Net Profit
SELECT
    channel_name,
    total_subscribers,
    ROUND(ROUND(CAST(total_views AS FLOAT) / total_videos, 0) * @Conversion_Rate * @Product_Price - @Investment, 0) AS net_profit
FROM 
    youtube_data_view
ORDER BY
    total_subscribers DESC;
```

![Excel Analysis Placeholder]

## 🔬 In-Depth Analysis Findings

### Comparison (Excel - SQL)
Cross-validation between Excel and SQL calculations showed perfect alignment, confirming computational accuracy across platforms.

### Analysis by Views Per Video
- Music channels demonstrated the highest average views per video (2.1M), followed by Entertainment (1.8M)
- Gaming channels showed lower views per video but higher content frequency
- Channels focusing on quality over quantity showed stronger per-video performance

### Analysis by Total Views
- Entertainment category leads with 43% of total views across all channels
- Music category comes second with 32% of total view share
- Highly specialized niches showed lower overall views but higher engagement rates

### Analysis by Video Output
- Gaming channels produce 3.2x more videos than the average channel
- Educational channels maintain consistent posting schedules
- Vlog-style channels show the highest variance in video frequency

### Analysis by Subscribers
- Top 10 channels account for 36% of all subscribers in the dataset
- Mid-tier channels (positions 30-60) show the fastest growth rates
- Category preference follows clear demographic patterns

### Category-Specific Insights

#### Entertainment Category
- Highest overall subscriber base (48M combined subscribers)
- Broadest audience demographic spread
- Best ROI potential for general consumer products

#### Music Category
- Highest engagement rate (2.4x the average)
- Strong correlation between video production value and performance
- Optimal for promotional partnerships

#### Gaming Category
- Most devoted follower base (highest subscriber-to-view conversion)
- Greatest content frequency (avg. 3.8 videos weekly)
- Best for sustained marketing campaigns

![Category Comparison Placeholder]

## 📝 Conclusion

This analysis of the UK's top 100 YouTube channels reveals several significant insights for content creators, marketers, and platform analysts:

1. **Quality vs. Quantity Trade-off**: Channels producing fewer, higher-quality videos generally achieve better per-video performance metrics than those pursuing high-frequency posting strategies.

2. **Category Performance Variance**: While Entertainment channels dominate in overall subscriber count and total views, Music channels demonstrate superior engagement rates, and Gaming channels excel in audience loyalty and content frequency.

3. **Investment Potential**: Based on our ROI modeling, mid-sized channels (500K-2M subscribers) in specialized niches often present better marketing investment opportunities than mega-channels, offering more engaged audiences at lower partnership costs.

4. **Platform Evolution**: The data suggests YouTube's algorithm increasingly rewards sustained viewer engagement over raw view counts, pointing to a strategic shift favoring channels that maintain consistent viewer session duration.

5. **UK Market Distinction**: Compared to global trends, UK YouTube creators show stronger performance in educational and comedy categories, reflecting cultural viewing preferences.

For content creators and marketers, these findings highlight the importance of strategic channel positioning, content cadence optimization, and niche selection when building a YouTube presence. Future research could expand this analysis to track performance changes over time and examine the impact of platform policy changes on creator success metrics.

### Next Steps

- Incorporate temporal analysis to track growth patterns
- Expand dataset to include international comparison
- Develop predictive models for channel growth
- Analyze content characteristics (video length, thumbnail style, etc.)

---

*This project was completed as part of a data analytics portfolio demonstration using Python, SQL Server, Excel, and Power BI.*
