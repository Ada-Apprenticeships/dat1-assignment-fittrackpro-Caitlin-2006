-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role
SELECT staff_id, first_name, last_name, position
FROM staff
ORDER BY position;

-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 
SELECT
    /* Get the staff id from the staff table */
    s.staff_id,
    /* Concatenate the first name and last name of the staff member to create the trainer name */
    CONCAT(s.first_name, ' ', s.last_name) AS trainer_name,
    /* Count the number of personal training sessions for each staff member */
    COUNT(pts.session_id) AS session_count
FROM
    /* Start with the staff table */
    staff s
    /* Left join the staff table with the personal training sessions table on the staff id */
    /* Also filter for sessions scheduled in the next 30 days */
    LEFT JOIN personal_training_sessions pts ON s.staff_id = pts.staff_id AND pts.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
/* Filter for staff members with the position 'Trainer' */
WHERE
    s.position = 'Trainer'
/* Group the results by staff id, first name, and last name */
GROUP BY
    s.staff_id, s.first_name, s.last_name
/* Filter the grouped results to include only staff members with at least one scheduled session */
HAVING
    COUNT(pts.session_id) > 0;