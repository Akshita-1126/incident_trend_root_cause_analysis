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
where resolved_at='resolved_at';

delete from incidents
where number= 'number';

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

Drop Table incident_data; --dropped the old table

SELECT * FROM incident_data;







SELECT created_at
FROM incident_data
WHERE created_at !~ '^\d{4}-\d{2}-\d{2}';










