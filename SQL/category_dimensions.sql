CREATE TABLE category_mapping (
    category_code VARCHAR(20),
    category_name VARCHAR(100)
);

INSERT INTO category_mapping
SELECT DISTINCT
    a.category AS category_code,
    
    CASE
    
        -- Network
        WHEN b.root_cause = 'Network Failure' 
            THEN 'Network - Connectivity Issue'
        
        -- Database
        WHEN b.root_cause = 'Database Issue' 
            THEN 'Database - Performance Issue'
        WHEN b.root_cause = 'Data Corruption' 
            THEN 'Database - Data Integrity Issue'
        
        -- Application
        WHEN b.root_cause = 'Application Bug' 
            THEN 'Application - Functional Defect'
        WHEN b.root_cause = 'Job Scheduling Failure' 
            THEN 'Application - Batch Failure'
        
        -- Configuration
        WHEN b.root_cause = 'Configuration Error' 
            THEN 'Configuration - Misconfiguration'
        
        -- Infrastructure
        WHEN b.root_cause = 'Server Overload' 
            THEN 'Infrastructure - Capacity Issue'
        WHEN b.root_cause = 'Hardware Failure' 
            THEN 'Infrastructure - Hardware Failure'
        
        -- Security
        WHEN b.root_cause = 'Authentication Failure' 
            THEN 'Security - Login/Auth Issue'
        WHEN b.root_cause = 'Security Policy Block' 
            THEN 'Security - Policy Restriction'
        
        -- Integration / API
        WHEN b.root_cause = 'API Timeout' 
            THEN 'Integration - API Timeout'
        WHEN b.root_cause = 'Integration Failure' 
            THEN 'Integration - System Failure'
        
        -- Performance
        WHEN b.root_cause = 'Memory Leak' 
            THEN 'Performance - Memory Issue'
        
        -- Storage
        WHEN b.root_cause = 'Disk Space Issue' 
            THEN 'Infrastructure - Storage Issue'
        
        -- External
        WHEN b.root_cause = 'Third-Party Service Failure' 
            THEN 'External - Vendor Dependency'
        
        -- DevOps
        WHEN b.root_cause = 'Deployment Error' 
            THEN 'DevOps - Release Failure'
        
        -- Unknown
        WHEN b.root_cause IN ('Unknown System Error', 'Not Documented') 
            THEN 'General - Unknown Issue'
        
        ELSE 'General - Other Issue'
        
    END AS category_name

FROM incident_data a
Join root_cause_mapping b
on a.closed_code= b.code;

select * from category_mapping;