CREATE TABLE incident_group_mapping (
    closed_code VARCHAR(20),
    group_code VARCHAR(20)
);

INSERT INTO incident_group_mapping (closed_code, group_code)
select distinct closed_code, team_assigned
from incident_data
group by closed_code, team_assigned
order by closed_code asc;

select * from incident_group_mapping;

CREATE TABLE assigned_team (
    closed_code VARCHAR(20),
    group_code VARCHAR(20),
    team_assigned VARCHAR(100)
);

INSERT INTO assigned_team
SELECT 
    closed_code,
    group_code,
    CASE
        WHEN closed_code = 'code 1' THEN 'Network Operations Team'

        WHEN closed_code = 'code 2' THEN 'Database Administration Team'

        WHEN closed_code = 'code 3' THEN 'Application Support Team'

        WHEN closed_code = 'code 4' THEN 'IT Support Team'

        WHEN closed_code = 'code 5' THEN 'Infrastructure Operations Team'

        WHEN closed_code = 'code 6' THEN 'Security Operations Team'

        WHEN closed_code = 'code 7' THEN 'Integration Support Team'

        WHEN closed_code = 'code 8' THEN 'Performance Engineering Team'

        WHEN closed_code = 'code 9' THEN 'Infrastructure Operations Team'

        WHEN closed_code = 'code 10' THEN 'Vendor Management Team'

        WHEN closed_code = 'code 11' THEN 'Database Administration Team'

        WHEN closed_code = 'code 12' THEN 'Security Operations Team'

        WHEN closed_code = 'code 13' THEN 'Application Support Team'

        WHEN closed_code = 'code 14' THEN 'Integration Support Team'

        WHEN closed_code = 'code 15' THEN 'DevOps Team'

        WHEN closed_code = 'code 16' THEN 'Infrastructure Operations Team'

        WHEN closed_code = 'code 17' OR closed_code = 'Unknown'
             THEN 'Service Desk Team'
        
        ELSE 'Other Team'
    END AS team_assigned
FROM incident_group_mapping;

SELECT * FROM assigned_team; 

SELECT 
distinct a.incident_id, 
b.root_cause, 
c.team_assigned
FROM incident_data a
JOIN root_cause_mapping b
   ON a.closed_code=b.code 
JOIN assigned_team c
   ON a.closed_code= c.closed_code;



