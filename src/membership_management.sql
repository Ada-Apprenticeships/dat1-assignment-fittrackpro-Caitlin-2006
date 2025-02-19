-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT 
    /* Get the member id, first name and last name from the members table */
    m.member_id,
    m.first_name,
    m.last_name,
    /* Get the type of membership from the memberships table */
    ms.type AS membership_type,
    /* Get the join date of the members table */
    m.join_date
FROM 
    /* Start with the members table */
    members m
/* Join the members table with the memberships table on the member id */
JOIN 
    memberships ms ON m.member_id = ms.member_id
/* Filter for memberships that have an 'Active' status */
WHERE 
    ms.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
SELECT 
    /* Get the type of membership from the memberships table */
    ms.type AS membership_type,
    /* Calculate the average visit duration in minutes, rounded to 2 decimal places */
    ROUND(AVG(JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 24 * 60, 2) AS avg_visit_duration_minutes
FROM 
    /* Start with the memberships table */
    memberships ms
/* Join the memberships table with the attendance table on the member id */
/* Only include members with attendance records */
INNER JOIN 
    attendance a ON ms.member_id = a.member_id
/* Filter for attendance records where the check out time is not null */
WHERE 
    a.check_out_time IS NOT NULL
/* Group the results by the membership type */
GROUP BY 
    ms.type;

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
SELECT 
    /* Get the member id,first name, last name, email from the members table */
    m.member_id,
    m.first_name,
    m.last_name,
    m.email,
    /* Get the end date of the membership */
    ms.end_date
FROM 
    /* Start with the members table */
    members m
/* Join the members table with the memberships table on the member id */
/* Only include members with membership records */
INNER JOIN 
    memberships ms ON m.member_id = ms.member_id
/* Filter for memberships where the end date is between the current date and 1 year from now */
WHERE 
    ms.end_date BETWEEN DATE('now') AND DATE('now', '+1 year')
/* Order the results by the membership end date in ascending order */
ORDER BY 
    ms.end_date;