CREATE TABLE root_cause_mapping (
code VARCHAR(20),
root_cause VARCHAR(100)
);

INSERT INTO root_cause_mapping VALUES
('code 1','Network Failure'),
('code 2','Database Issue'),
('code 3','Application Bug'),
('code 4','Configuration Error'),
('code 5','Server Overload'),
('code 6','Authentication Failure'),
('code 7','API Timeout'),
('code 8','Memory Leak'),
('code 9','Disk Space Issue'),
('code 10','Third-Party Service Failure'),
('code 11','Data Corruption'),
('code 12','Security Policy Block'),
('code 13','Job Scheduling Failure'),
('code 14','Integration Failure'),
('code 15','Deployment Error'),
('code 16','Hardware Failure'),
('code 17','Unknown System Error'),
('Unknown','Not Documented');

select * from root_cause_mapping;

select a.incident_id, b.root_cause
from incident_data a
Join root_cause_mapping b
on a.closed_code = b.code;
