-- BELOW IS FROM SECTION 1 OF 6 FOR THE CAPSTONE

-- QUESTION 1

-- # of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

-- # of distinct sources
SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

-- campaigns with their sources
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
GROUP BY utm_campaign;

-- QUESTION 2

-- distinct page names
SELECT DISTINCT page_name
FROM page_visits;

-- QUESTION 3

-- # of first touches per campaign
WITH first_touch AS
	(SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch AS ft
  JOIN page_visits AS pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1
ORDER BY 3 DESC;

-- QUESTION 4

-- # of last touches per campaign
WITH last_touch AS
	(SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- QUESTION 5

-- # of visitors that made a purchase
SELECT COUNT(DISTINCT user_id) as 'visitors',
	page_name
FROM page_visits
WHERE page_name LIKE "4 - purchase";

-- QUESTION 6

-- # of last touches on the purchase page for each campaign

WITH last_touch AS
	(SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name LIKE '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
