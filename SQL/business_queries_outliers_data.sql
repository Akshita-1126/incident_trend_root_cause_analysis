-- Business Question 1:
-- Identify teams contributing the most to extreme resolution delays.

SELECT 
    team_assigned,
    COUNT(*) AS outlier_incidents
FROM outliers_data
GROUP BY team_assigned
ORDER BY outlier_incidents DESC
LIMIT 5;

-- Business Question 2:
-- Find root causes that result in unusually long resolution times.

SELECT 
    root_cause,
    COUNT(*) AS outlier_count,
    AVG(resolution_time_hours) AS avg_resolution_time
FROM outliers_data
GROUP BY root_cause
ORDER BY avg_resolution_time DESC;

-- Business Question 3:
-- Detect categories with high occurrence of extreme delays.

SELECT 
    category,
    COUNT(*) AS outlier_count
FROM outliers_data
GROUP BY category
ORDER BY outlier_count DESC;

-- Business Question 4:
-- Identify if extreme incidents occur more frequently at certain hours.

SELECT 
    hour,
    COUNT(*) AS outlier_count
FROM outliers_data
GROUP BY hour
ORDER BY outlier_count DESC;

-- Business Question 5:
-- Find if certain days have more severe incidents.

SELECT 
    day_of_week,
    COUNT(*) AS outlier_count
FROM outliers_data
GROUP BY day_of_week
ORDER BY outlier_count DESC;

-- Business Question 6:
-- Identify teams dealing with the most time-consuming incidents.

SELECT 
    team_assigned,
    MAX(resolution_time_hours) AS max_resolution_time,
    AVG(resolution_time_hours) AS avg_resolution_time
FROM outliers_data
GROUP BY team_assigned
ORDER BY max_resolution_time DESC;

-- Business Question 7:
-- Measure how significant extreme incidents are compared to total workload.

SELECT 
    (SELECT COUNT(*) FROM outliers_data) * 100.0 / 
    (SELECT COUNT(*) FROM incident_dataset) AS outlier_percentage;

-- Business Question 8:
-- Identify critical combinations causing extreme delays.

SELECT 
    root_cause,
    team_assigned,
    COUNT(*) AS incident_count
FROM outliers_data
GROUP BY root_cause, team_assigned
ORDER BY incident_count DESC
LIMIT 10;

-- Business Question 9:
-- Check if outliers are mostly unresolved or delayed incidents.

SELECT 
    CASE 
        WHEN resolved_at IS NULL THEN 'Unresolved'
        ELSE 'Resolved'
    END AS status,
    COUNT(*) AS count
FROM outliers_data
GROUP BY status;

-- Business Question 10:
-- Measure how far extreme incidents exceed .

SELECT 
    AVG(resolution_time_hours - 1000) AS avg_delay_beyond_sla
FROM outliers_data
WHERE resolution_time_hours > 1000;
