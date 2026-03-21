CREATE TABLE category_dimension (
    category_code VARCHAR(50) PRIMARY KEY,
    category_group VARCHAR(100)
);

INSERT INTO category_dimension (category_code, category_group)
SELECT DISTINCT
    category AS category_code,
    CASE 
        -- Infrastructure & System
        WHEN category IN ('Category 61','Category 46','Category 28','Category 26','Category 24','Category 20','Category 17','Category 62','Category 63')
            THEN 'Infrastructure & System'

        -- Application & Software
        WHEN category IN ('Category 57','Category 34','Category 32','Category 43','Category 53','Category 55','Category 31')
            THEN 'Application & Software'

        -- Data & Database
        WHEN category IN ('Category 23','Category 13','Category 38')
            THEN 'Data & Database'

        -- Integration & API
        WHEN category IN ('Category 8','Category 12','Category 37')
            THEN 'Integration & API'

        -- Security & Access
        WHEN category IN ('Category 42','Category 44','Category 41','Category 14','Category 7')
            THEN 'Security & Access'

        -- Performance & Monitoring
        WHEN category IN ('Category 9','Category 45','Category 40','Category 22')
            THEN 'Performance & Monitoring'

        -- Operations & Process
        WHEN category IN ('Category 50','Category 54','Category 47','Category 56','Category 21','Category 25','Category 29','Category 30','Category 16')
            THEN 'Operations & Process'

        -- Default fallback
        ELSE 'General / Unknown'
    END AS category_group
FROM incident_data;

select * from category_dimension;


SELECT 
    i.incident_id,
    r.root_cause,
    c.category_group,
    a.team_assigned

FROM incident_data i

LEFT JOIN root_cause_mapping r
    ON i.closed_code = r.code

LEFT JOIN assigned_team a
    ON i.closed_code = a.closed_code
    AND i.team_assigned = a.group_code

LEFT JOIN category_dimension c
    ON i.category = c.category_code;

select a.root_cause,b.category_code 
from root_cause_mapping a
left Join category_dimension b
ON a.code= b.closed_code;


select distinct category_code, count(closed_code)
from category_dimension 
group by category_code




