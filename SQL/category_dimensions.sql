CREATE TABLE category_dimension (
    category_code VARCHAR(20),
    root_cause VARCHAR(100),
    category_name VARCHAR(100)
);

INSERT INTO category_dimension
SELECT DISTINCT
    i.category AS category_code,
    r.root_cause,

    CASE
    
        WHEN r.root_cause = 'Network Failure' 
            THEN 'Network - Connectivity Issue'
        
        WHEN r.root_cause = 'Database Issue' 
            THEN 'Database - Performance Issue'
        WHEN r.root_cause = 'Data Corruption' 
            THEN 'Database - Data Integrity Issue'
        
        WHEN r.root_cause = 'Application Bug' 
            THEN 'Application - Functional Defect'
        WHEN r.root_cause = 'Job Scheduling Failure' 
            THEN 'Application - Batch Failure'
        
        WHEN r.root_cause = 'Configuration Error' 
            THEN 'Configuration - Misconfiguration'
        
        WHEN r.root_cause = 'Server Overload' 
            THEN 'Infrastructure - Capacity Issue'
        WHEN r.root_cause = 'Hardware Failure' 
            THEN 'Infrastructure - Hardware Failure'
        
        WHEN r.root_cause = 'Authentication Failure' 
            THEN 'Security - Login/Auth Issue'
        WHEN r.root_cause = 'Security Policy Block' 
            THEN 'Security - Policy Restriction'
        
        WHEN r.root_cause = 'API Timeout' 
            THEN 'Integration - API Timeout'
        WHEN r.root_cause = 'Integration Failure' 
            THEN 'Integration - System Failure'
        
        WHEN r.root_cause = 'Memory Leak' 
            THEN 'Performance - Memory Issue'
        
        WHEN r.root_cause = 'Disk Space Issue' 
            THEN 'Infrastructure - Storage Issue'
        
        WHEN r.root_cause = 'Third-Party Service Failure' 
            THEN 'External - Vendor Dependency'
        
        WHEN r.root_cause = 'Deployment Error' 
            THEN 'DevOps - Release Failure'
        
        WHEN r.root_cause IN ('Unknown System Error', 'Not Documented') 
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
	i.closed_code,
    r.root_cause,
	i.category,
    c.category_name,
	i.team_assigned,
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