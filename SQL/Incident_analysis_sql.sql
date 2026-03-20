-- Creating table with the 
CREATE TABLE incidents (
    number VARCHAR(255),
    incident_state VARCHAR(255),
    active VARCHAR(255),
    reassignment_count VARCHAR(255),
    reopen_count VARCHAR(255),
    sys_mod_count VARCHAR(255),
    made_sla VARCHAR(255),
    caller_id VARCHAR(255),
    opened_by VARCHAR(255),
    opened_at VARCHAR(255),
    sys_created_by VARCHAR(255),
    sys_created_at VARCHAR(255),
    sys_updated_by VARCHAR(255),
    sys_updated_at VARCHAR(255),
    contact_type VARCHAR(255),
    location VARCHAR(255),
    category VARCHAR(255),
    subcategory VARCHAR(255),
    u_symptom VARCHAR(255),
    cmdb_ci VARCHAR(255),
    impact VARCHAR(255),
    urgency VARCHAR(255),
    priority VARCHAR(255),
    assignment_group VARCHAR(255),
    assigned_to VARCHAR(255),
    knowledge VARCHAR(255),
    u_priority_confirmation VARCHAR(255),
    notify VARCHAR(255),
    problem_id VARCHAR(255),
    rfc VARCHAR(255),
    vendor VARCHAR(255),
    caused_by VARCHAR(255),
    closed_code VARCHAR(255),
    resolved_by VARCHAR(255),
    resolved_at VARCHAR(255),
    closed_at VARCHAR(255)
);

select * from incidents;

-- Deleting all unnecessary columns
ALTER TABLE incidents
DROP COLUMN active,
DROP COLUMN reopen_count,
DROP COLUMN sys_mod_count,
DROP COLUMN made_sla,
DROP COLUMN caller_id,
DROP COLUMN opened_by,
DROP COLUMN sys_created_at,
DROP COLUMN sys_updated_by,
DROP COLUMN sys_updated_at,
DROP COLUMN contact_type,
DROP COLUMN location,
DROP COLUMN subcategory,
DROP COLUMN u_symptom,
DROP COLUMN cmdb_ci,
DROP COLUMN urgency,
DROP COLUMN priority,
DROP COLUMN assigned_to,
DROP COLUMN knowledge;

Begin;
ALTER TABLE incidents
DROP COLUMN reassignment_count,
DROP COLUMN sys_created_by,
DROP COLUMN u_priority_confirmation,
DROP COLUMN notify,
DROP COLUMN problem_id,
DROP COLUMN rfc,
DROP COLUMN vendor,
DROP COLUMN caused_by,
DROP COLUMN resolved_by,
DROP COLUMN closed_at;

SELECT * FROM incidents;

-- deleting all those values where resolved_at is '?'
delete from incidents
where resolved_at='?';

delete from incidents
where resolved_at= 'resolved_at'; -- deleting the header of excel which was converted into a row while importing data

-- changing datatype for created at and resolved at
ALTER TABLE incidents
ALTER COLUMN opened_at TYPE Timestamp
USING opened_at::Timestamp;

ALTER TABLE incidents
ALTER COLUMN resolved_at TYPE Timestamp
USING resolved_at::Timestamp;

select * from incidents;

-- aggregating duplicate data: For this, I'll create a different table usning the event log data as well as renaming the columns.
CREATE TABLE incident_data AS
SELECT
    number as incident_id,
    MIN(opened_at) AS created_at,
    MAX(resolved_at) AS resolved_at,
    MIN(impact) AS severity,
    MIN(category) AS category,
    MAX(assignment_group) AS team_assigned,
    MAX(closed_code) AS closed_code,
    MAX(incident_state) AS status
FROM incidents
GROUP BY number;

SELECT * FROM incident_data;

-- Replacing invalid values into valid.
select distinct closed_code from incident_data;
UPDATE incident_data
SET closed_code = 'Unknown'
WHERE closed_code= '?';

select distinct category from incident_data;
UPDATE incident_data
SET category = 'Other'
WHERE category= '?';

select distinct severity from incident_data;

select distinct status from incident_data;

select distinct team_assigned from incident_data;
UPDATE incident_data
SET team_assigned = 'Unknown'
WHERE team_assigned= '?';

Alter table incident_data
Drop column status; -- the status is resolved for all incidents so this column is unnessary

SELECT * FROM incident_data;

-- adding columns like resolved_time_hour, shift, created_hour, day_of_week, month, and priority.

ALTER TABLE incident_data
ADD COLUMN resolution_time_hour FLOAT,
ADD COLUMN shift VARCHAR(20),
ADD COLUMN created_hour INT,
ADD COLUMN day_of_week VARCHAR(20),
ADD COLUMN month VARCHAR(20),
ADD COLUMN priority VARCHAR(20);

-- Updating the columns, resolution_time_hour, created_hour, day_of_week, and month.
UPDATE incident_data
SET 
resolution_time_hour = EXTRACT(EPOCH FROM (resolved_at - created_at)) / 3600,
created_hour = EXTRACT(HOUR FROM created_at),
day_of_week = TO_CHAR(created_at, 'Day'),
month = TO_CHAR(created_at, 'Month');

-- for shift logic
UPDATE incident_data
SET
shift = CASE 
    WHEN EXTRACT(HOUR FROM created_at) BETWEEN 7 AND 14 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM created_at) BETWEEN 15 AND 22 THEN 'Evening'
    ELSE 'Night'
	END;

-- for priority logic
UPDATE incident_data
SET
priority = CASE 
    WHEN severity LIKE '1%' THEN '1-High'
    WHEN severity LIKE '2%' THEN '2-Medium'
    WHEN severity LIKE '3%' THEN '3-Low'
    ELSE 'Low'
	END;

-- one more column - SLA breach
ALTER TABLE incident_data ADD COLUMN sla_breach VARCHAR(10);

UPDATE incident_data
SET sla_breach = CASE 
    WHEN priority = '1-High' And resolution_time_hour<24  THEN 'Yes'
	WHEN priority = '2-Medium' And resolution_time_hour<84 THEN 'Yes'
	WHEN priority = '3-Low' And resolution_time_hour<168  THEN 'Yes'
    ELSE 'No'
END;
SELECT * FROM incident_data;












