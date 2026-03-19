CREATE TABLE category_dimension (
    closed_code Varchar(20), -- primary key
    category_code VARCHAR(20),
    category_name VARCHAR(100)
);

INSERT INTO category_dimension
SELECT DISTINCT
    r.code AS closed_code,
	i.category AS category_code,
    CASE
	    WHEN i.category = 'Other' 
		    THEN 'General - Other Issue' -- when category itself is not defined.
    
        WHEN r.code = 'code 1' 
            THEN 'Network - Connectivity Issue'
        
        WHEN r.code  = 'code 2' 
            THEN 'Database - Performance Issue'
        WHEN r.code = 'code 11' 
            THEN 'Database - Data Integrity Issue'
        
        WHEN r.code = 'code 3' 
            THEN 'Application - Functional Defect'
        WHEN r.code = 'code 13' 
            THEN 'Application - Batch Failure'
        
        WHEN r.code = 'code 4' 
            THEN 'Configuration - Misconfiguration'
        
        WHEN r.code = 'code 5' 
            THEN 'Infrastructure - Capacity Issue'
        WHEN r.code = 'code 16' 
            THEN 'Infrastructure - Hardware Failure'
        
        WHEN r.code = 'code 6' 
            THEN 'Security - Login/Auth Issue'
        WHEN r.code = 'code 12' 
            THEN 'Security - Policy Restriction'
        
        WHEN r.code = 'code 7' 
            THEN 'Integration - API Timeout'
        WHEN r.code = 'code 14' 
            THEN 'Integration - System Failure'
        
        WHEN r.code = 'code 8' 
            THEN 'Performance - Memory Issue'
        
        WHEN r.code = 'code 9' 
            THEN 'Infrastructure - Storage Issue'
        
        WHEN r.code = 'code 10' 
            THEN 'External - Vendor Dependency'
        
        WHEN r.code = 'code 15' 
            THEN 'DevOps - Release Failure'
        
        WHEN r.code IN ('code 17', 'Unknown') 
            THEN 'General - Unknown Issue'
        
        ELSE 'General - Other Issue'
        
    END AS category_name

FROM incident_data i
JOIN root_cause_mapping r
    ON i.closed_code = r.code;

select * from category_dimension;

select a.incident_id, a.closed_code,
b.root_cause, 
a.category,
c.category_name,
a.team_assigned,
d.team_assigned

from incident_data a

Left Join root_cause_mapping b
     on a.closed_code=b.code
	 
left  Join category_mapping c
     on a.category=c.category_code
	 
left Join assigned_team d
     on a.closed_code=d.closed_code
	 And a.team_assigned= d.group_code;

SELECT 
    i.incident_id,
    r.root_cause,
    c.category_name,
    a.team_assigned

FROM incident_data i

LEFT JOIN root_cause_mapping r
    ON i.closed_code = r.code

LEFT JOIN assigned_team a
    ON i.closed_code = a.closed_code
    AND i.team_assigned = a.group_code

LEFT JOIN category_dimension c
    ON i.category = c.category_code
    AND r.root_cause = c.root_cause;

select category_name, closed_code, category_code from category_dimension 
where category_name= 'General - Other Issue';

Truncate table category_dimension;
