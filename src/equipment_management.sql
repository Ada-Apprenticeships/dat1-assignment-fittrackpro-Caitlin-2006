-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance
SELECT 
    /* Get the equipment id, name and next maintenance date */
    equipment_id,
    name,
    next_maintenance_date
FROM 
    /* Get data from the equipment table */
    equipment
WHERE 
    /* Filter equipment where the next maintenance date is between the current date and the next 30 days */
    next_maintenance_date BETWEEN DATE('now') AND DATE('now', '+30 days');

-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock
SELECT 
    type AS equipment_type,
    COUNT(*) AS count
FROM 
    equipment
GROUP BY 
    type;

-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)
SELECT 
    /* Get the type of equipment */
    type AS equipment_type,
    /* Calculate the average age of equipment in days, rounded to 2 decimal places */
    ROUND(AVG(JULIANDAY('now') - JULIANDAY(purchase_date)), 2) AS avg_age_days
FROM 
    /* Get data from the equipment table */
    equipment
/* Group the results by the equipment type */
GROUP BY 
    type;