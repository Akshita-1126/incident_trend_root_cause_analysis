-- Business Question 1:
-- Identify teams with highest average resolution time to detect inefficiency.

SELECT 
    team_assigned,
    AVG(resolution_time_hours) AS avg_resolution_time
FROM incident_dataset
WHERE resolution_time_hours IS NOT NULL
GROUP BY team_assigned
ORDER BY avg_resolution_time DESC;

-- Business Question 2:
-- Find root causes responsible for longest resolution times.

SELECT 
    root_cause,
    AVG(resolution_time_hours) AS avg_resolution_time
FROM incident_dataset
WHERE resolution_time_hours IS NOT NULL
GROUP BY root_cause
ORDER BY avg_resolution_time DESC;

-- Business Question 3:
-- Measure backlog and operational inefficiency.

SELECT 
    COUNT(*) AS total_incidents,
    SUM(CASE WHEN resolved_at IS NULL THEN 1 ELSE 0 END) AS unresolved_incidents,
    ROUND(
        100.0 * SUM(CASE WHEN resolved_at IS NULL THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS unresolved_percentage
FROM incident_dataset;

-- Business Question 4:
-- Identify workload distribution across teams.

SELECT 
    team_assigned,
    COUNT(*) AS total_incidents
FROM incident_dataset
GROUP BY team_assigned
ORDER BY total_incidents DESC;

-- Business Question 5:
-- Identify lack of ownership clarity for root causes.

SELECT 
    root_cause,
    COUNT(DISTINCT team_assigned) AS teams_handling
FROM incident_dataset
GROUP BY root_cause
HAVING COUNT(DISTINCT team_assigned) > 1
ORDER BY teams_handling DESC;

-- Business Question 6:
-- Identify teams dealing with complex or severe issues.

SELECT 
    team_assigned,
    COUNT(*) AS high_duration_incidents
FROM incident_dataset
WHERE resolution_time_hours > 168
GROUP BY team_assigned
ORDER BY high_duration_incidents DESC;

-- Business Question 7:
-- Identify categories where incidents are often unresolved or delayed.

SELECT 
    category,
    COUNT(*) AS total_incidents,
    SUM(CASE WHEN is_resolved = 'No' THEN 1 ELSE 0 END) AS unresolved_count
FROM incident_dataset
GROUP BY category
ORDER BY unresolved_count DESC;

-- Business Question 8:
-- Detect frequent issues that are not being resolved effectively.

SELECT root_cause, 
	count(*) as total_incidents,
	SUM(CASE WHEN is_resolved = 'No' THEN 1 ELSE 0 END) AS unresolved_count
FROM incident_dataset
GROUP BY root_cause
ORDER BY unresolved_count DESC;

-- Business Question 9:
-- Identify teams with pending workload.

SELECT team_assigned, COUNT(*) AS unresolved_incidents
FROM incident_dataset
WHERE is_resolved = 'No'
GROUP BY team_assigned
ORDER BY unresolved_incidents DESC;

-- Business Question 10:
-- Identify categories driving most of the incidents.

SELECT 
    category,
    COUNT(*) AS total_incidents
FROM incident_dataset
GROUP BY category
ORDER BY total_incidents DESC
LIMIT 5;

-- Business Question 11:
-- Measure how far extreme incidents exceed expected resolution time (e.g., 168 hrs SLA).

SELECT 
    AVG(resolution_time_hours - 168) AS avg_delay_beyond_sla
FROM incident_dataset
WHERE resolution_time_hours > 168;


