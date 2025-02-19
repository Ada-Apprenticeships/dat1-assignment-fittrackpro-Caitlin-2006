-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (7, 1, datetime('now'));

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT 
    /*Get the date part of the check in time column and call it visit date */
    DATE(check_in_time) AS visit_date,
    /*Get the time part of the check in time column and call it check in time */
    TIME(check_in_time) AS check_in_time,
    /*Get the time part of the check out time column and call it check out time */
    TIME(check_out_time) AS check_out_time
FROM 
    /*Get data from the attendance table */
    attendance
WHERE 
    /*Filter the records where member id is 5 */
    member_id = 5
ORDER BY 
    /*Sort the results by the check in time */
    check_in_time;

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT 
    /* Get the day of the week from the check in time as a string */
    CASE strftime('%w', check_in_time)
    /* Give it a reference for which number refers to which day of the week */
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    /* Count the number of rows for each day of the week */
    COUNT(*) AS visit_count
FROM 
    /* Get data from the attendance table */
    attendance
/* Group the results by the day of the week */
GROUP BY 
    day_of_week
/* Sort the results in descending order */
ORDER BY 
    visit_count DESC;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
SELECT 
    /* Get the name of the location from the locations table */
    l.name AS location_name,
    /* Calculate the average daily attendance for each location */
    AVG(daily_attendance) AS avg_daily_attendance
FROM (
    SELECT 
    /* Get the location id, visit date, and count of attendance id for each day and location*/
        location_id,
        DATE(check_in_time) AS visit_date,
        COUNT(attendance_id) AS daily_attendance
    FROM 
        attendance
    /* Group the attendance data by location id and visit date */
    GROUP BY 
        location_id, visit_date
) AS daily_counts
/* Join the daily attendance counts with the locations table */
JOIN 
    locations l ON daily_counts.location_id = l.location_id
/* Group the results by the location name */
GROUP BY 
    l.name;