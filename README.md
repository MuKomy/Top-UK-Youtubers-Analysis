# Top UK YouTubers Analysis

An in-depth data exploration of the UK's most influential content creators on YouTube, analyzing metrics, engagement, and potential business value.

For content creators and marketers, these findings highlight the importance of strategic channel positioning, content cadence optimization, and niche selection when building a YouTube presence.

**Tech Stack:** Python, Microsoft SQL Server, Excel, Power BI
## Table of Contents

- [Project Overview](#-project-overview)
- [Data Extraction Process](#-data-extraction-process)
- [Data Testing in Microsoft SQL Server](#-data-testing-in-microsoft-sql-server)
- [Power BI Visualization & Metrics](#-power-bi-visualization--metrics)
- [Excel Analysis & Business Modeling](#-excel-analysis--business-modeling)
- [In-Depth Analysis Findings](#-in-depth-analysis-findings)
    - [Comparison (Excel - SQL)](#comparison-excel---sql)
    - [Analysis by Views Per Video](#analysis-by-views-per-video)
    - [Analysis by Total Views](#analysis-by-total-views)
    - [Analysis by Video Output](#analysis-by-video-output)
    - [Analysis by Subscribers](#analysis-by-subscribers)
    - [Category-Specific Insights](#category-specific-insights)
        - [Entertainment Category](#entertainment-category)
        - [Music Category](#music-category)
        - [Gaming Category](#gaming-category)
- [Conclusion](#-conclusion)
- [Skills Developed](#-skills-developed)


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
![data-testing-output.png](/assets/images/data-testing-output.png)

All tests passed successfully, confirming data integrity and readiness for analysis.

## 📈 Power BI Visualization & Metrics

After importing the validated data into Power BI, I established key metrics through DAX measures:

``` python
Views/Video = 
VAR videos = SUM(youtube_data_view[total_videos])
VAR views = SUM(youtube_data_view[total_views])
VAR views_per_video = DIVIDE(views, videos, BLANK())
RETURN views_per_video
```

``` python
Engagement Rate = 
VAR eng_rate = DIVIDE(youtube_data_view[Views/Video (M)]*1000000, SUM(youtube_data_view[total_subscribers]))
RETURN eng_rate
```

For the dashboard mockup i used mokkup.ai
![Mokkup Placeholder](/assets/images/mokkup.png)


### Final Dashboard
![Power BI Dashboard Placeholder](/assets/images/dashboard.png)

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



## 🔬 In-Depth Analysis Findings

### Comparison (Excel - SQL)
Cross-validation between Excel and SQL calculations showed perfect alignment, confirming computational accuracy across platforms.
I used these metrics as examples to check the profit metrics:

Investment:	 £100,000 

Investment Type:	Product Placement

Conversion Rate:	2%

Product Price:	 £5.00 


![Excel Analysis Placeholder](/assets/images/excel-sql-comparison.png)
![SQL Analysis Placeholder](/assets/images/sql-analysis-output.png)

### Analysis by Views Per Video
![Excel Analysis Placeholder](/assets/images/views-per-video.png)

- Mark Ronson has unmatched reach and impact, Jessie J & Dua Lipa have extraordinary  reach.
- If the marketing strategy doesn't coordinate well with these artists, then Mrwhosetheboss,  Sidemen & Gorillaz offer great ROI.
- *Mark Ronson's reach may be misleading due to the low number of videos(20) and the success of the song "Uptown Funk", which is the reason for his high engagement rate

### Analysis by Total Views
![Excel Analysis Placeholder](/assets/images/views.png)

- Pursue Dua Lipa as a flagship marketing channel if budget allows - the ROI potential significantly outperforms all other options.
- Woody & Kleiny offers the second-best performance among UK channels with strong audience engagement.
- DisneyChannelUK and DisneyJuniorUK offer specialized family audience targeting if relevant to your product.

### Analysis by Video Output
![Excel Analysis Placeholder](/assets/images/videos.png)

- Primary Content Split: Create a multi-video series across Jelly (entertainment focus) and BBC (news/credibility focus) for maximum reach across different audience segments.
- Sports Integration: Include Liverpool FC and/or Man City for sports audience penetration, especially if product has lifestyle or performance aspects.
- Youth & Culture Series: Partner with GRM Daily and YOGSCAST for younger, culturally engaged demographics.
  
### Analysis by Subscribers
![Excel Analysis Placeholder](/assets/images/subscribers.png)

- Top Tier: Dua Lipa & Sidemen & Dan Rhodes | Mid-Tier: DanTDM & NoCopyrightSounds  | Budget-Friendly: KSI & Mrwhosetheboss & Jelly & Ali-A
- I suggest using multiple youtubers from different tiers, for example:
- From Top- Tier: Sidemen, From Mid-Tier: DanTDM, From Budget-Friendly: KSI & Mrwhosetheboss

### Category-Specific Insights

#### Entertainment Category
![Excel Analysis Placeholder](/assets/images/entertainment.png)

- If maximizing potential revenue and overall audience reach is the priority, Dan Rhodes is the best option with 11M views and £1,015,315 profit.
- Sidemen - While not the highest in views, they have the best engagement rate at 82.6% with an exceptional profit of £1,633,831.
- Julius Dein & Niko Omilana - Excellent engagement (68.7% and 58.8% respectively) and high profit (£536,751 and £336,322).
- MoreSidemen - Strong engagement at 50.4% with solid £319,649 profit, making them another strong contender.

#### Music Category
![Excel Analysis Placeholder](/assets/images/music.png)

- Jessie J and Dua Lipa show astronomically high ROI, putting Engagement Rate into consideration, Jessie J shows to be the clear winner.
- And Little Mix & Gorillaz are also great options with Little Mix being the better investment option.

#### Gaming Category
![Excel Analysis Placeholder](/assets/images/gaming.png)

- If maximizing potential revenue and overall audience reach is the priority, DanTDM is the best option.
- LDShadowLady - While not the highest in views, she has the best engagement rate at with a strong profit.
- Grian & TommyInnit - Excellent engagement and high profit.

## 👨‍💻 Skills Developed
Through this comprehensive project, I've developed and demonstrated proficiency in several critical data analysis skills:

- API Data Extraction: Mastered the YouTube API v3 for data collection, including handling authentication, pagination, rate limiting, and structured data parsing in Python.
- SQL Data Management: Developed advanced SQL skills including data validation, integrity testing, complex query writing using CTEs, and statistical calculations through MSSQL Server.
- Data Transformation & Modeling: Implemented ETL processes transforming raw API data into structured analytical datasets suitable for multi-platform analysis.
- Business Intelligence Development: Created interactive Power BI dashboards featuring custom DAX measures and multi-dimensional visualizations revealing actionable insights.
- Financial Modeling: Applied business analytics principles to translate digital engagement metrics into commercial valuation models including ROI calculations, conversion modeling, and revenue forecasting.
- Data Validation & Testing: Implemented systematic data testing protocols ensuring integrity across platforms and calculations, including cross-validation between Excel and SQL.
- Statistical Analysis: Applied statistical methods to identify significant patterns, outliers, and correlations within digital engagement metrics.
- Data Visualization: Designed clear, compelling visualizations effectively communicating complex relationships and key performance indicators.
- Documentation: Developed detailed technical documentation explaining methodology, findings, and implementation details for both technical and non-technical audiences.

These skills provide a strong foundation for tackling increasingly complex data analytics challenges in digital marketing, content strategy, and business intelligence.
