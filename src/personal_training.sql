-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
SELECT 
    /* Get the session id from the personal training sessions table */
    pts.session_id,
    /* Concatenate the first name and last name of the member from the members table */
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    /* Get the session date, start time and end time from the personal training sessions table */
    pts.session_date,
    pts.start_time,
    pts.end_time
FROM 
    /* Start with the personal training sessions table */
    personal_training_sessions pts
/* Join the personal training sessions table with the staff table on the staff id */
JOIN 
    staff s ON pts.staff_id = s.staff_id
/* Join the result with the members table on the member id */
JOIN 
    members m ON pts.member_id = m.member_id
/* Filter for sessions conducted by the staff member 'Ivy Irwin' */
WHERE 
    s.first_name = 'Ivy' AND s.last_name = 'Irwin';