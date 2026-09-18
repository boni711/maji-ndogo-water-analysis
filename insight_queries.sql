-- ============================================================
-- Maji Ndogo Water Services — Insight Queries
-- Database: md_water_services
-- ============================================================

-- ------------------------------------------------------------
-- 1. Database Setup & Exploration
-- Insight: Mapped the core relational schema across locations,
-- visits, and water sources to establish baseline categorization
-- across rural and urban zones.
-- ------------------------------------------------------------
SELECT
    l.province_name,
    l.town_name,
    l.location_type,
    COUNT(DISTINCT l.location_id) AS num_locations,
    COUNT(DISTINCT v.record_id)   AS num_visits,
    COUNT(DISTINCT ws.source_id)  AS num_water_sources
FROM location l
LEFT JOIN visits v        ON l.location_id = v.location_id
LEFT JOIN water_source ws ON v.source_id  = ws.source_id
GROUP BY l.province_name, l.town_name, l.location_type
ORDER BY l.province_name, l.location_type;


-- ------------------------------------------------------------
-- 2. Data Cleaning & Standardisation
-- Insight: Identified dirty data in employee records and
-- standardized contact information, ensuring accurate audit
-- logs and preventing duplicate team profiles during reporting.
-- ------------------------------------------------------------

-- Find dirty/whitespace-padded emails and phone numbers
SELECT assigned_employee_id, employee_name, email, phone_number
FROM employee
WHERE email        != TRIM(email)
   OR phone_number  != TRIM(phone_number);

-- Standardise: trim contact fields, rebuild a canonical email from the employee's name
SELECT
    assigned_employee_id,
    employee_name,
    TRIM(phone_number) AS cleaned_phone,
    CONCAT(
        LOWER(REPLACE(SUBSTRING_INDEX(TRIM(employee_name), ' ', 1), ' ', '')), '.',
        LOWER(REPLACE(SUBSTRING_INDEX(TRIM(employee_name), ' ', -1), ' ', '')),
        '@ndogowater.gov'
    ) AS standardised_email
FROM employee;

-- Apply the cleanup
UPDATE employee
SET phone_number = TRIM(phone_number),
    email         = TRIM(email);


-- ------------------------------------------------------------
-- 3. Population & Water Source Distribution
-- Insight: Quantified overall population coverage, revealing
-- that over half of the region relied on shared public taps or
-- unimproved sources rather than direct in-home connections.
-- ------------------------------------------------------------
SELECT
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served,
    ROUND(
        100 * SUM(number_of_people_served)
        / (SELECT SUM(number_of_people_served) FROM water_source),
        2
    ) AS pct_of_population
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;


-- ------------------------------------------------------------
-- 4. Queue Times & Data Integrity Audits
-- Insight: Uncovered extreme operational bottlenecks (queue
-- times exceeding 60 minutes) and flagged potential corruption
-- or misreporting where field staff quality scores conflicted
-- with independent auditor reports.
-- ------------------------------------------------------------

-- Extreme queue times
SELECT
    v.record_id,
    l.town_name,
    l.province_name,
    v.time_in_queue
FROM visits v
JOIN location l ON v.location_id = l.location_id
WHERE v.time_in_queue > 60
ORDER BY v.time_in_queue DESC;

-- Surveyor score vs. independent auditor score
-- NOTE: assumes an `auditor_report` table (location_id, true_water_source_score)
-- loaded separately, per the standard Maji Ndogo course dataset.
SELECT
    e.assigned_employee_id,
    e.employee_name,
    wq.subjective_quality_score AS surveyor_score,
    ar.true_water_source_score  AS auditor_score,
    (wq.subjective_quality_score - ar.true_water_source_score) AS score_gap
FROM water_quality wq
JOIN visits v          ON wq.record_id = v.record_id
JOIN employee e        ON v.assigned_employee_id = e.assigned_employee_id
JOIN auditor_report ar ON v.location_id = ar.location_id
WHERE ABS(wq.subjective_quality_score - ar.true_water_source_score) >= 2
ORDER BY score_gap DESC;
