-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT * FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members
SET phone_number = '555-9876', email = 'emily.jones.updated@email.com'
WHERE member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT(*) AS total_members FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
SELECT 
    /* Get the member id, first name, last name from the members table */
    m.member_id,
    m.first_name,
    m.last_name,
    /* Count the number of class attendances for each member */
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    /* Start with the members table */
    members m
/* Join the members table with the class attendance table on the member id */
JOIN 
    class_attendance ca ON m.member_id = ca.member_id
/* Group the results by member id, first name, and last name */
GROUP BY 
    m.member_id, m.first_name, m.last_name
/* Order the results by the registration count in descending order */
ORDER BY 
    registration_count DESC
/* Limit the output to the member with the highest registration count */
LIMIT 1;

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
SELECT 
    /* Get the member id, first name, last name from the members table */
    m.member_id,
    m.first_name,
    m.last_name,
    /* Count the number of class attendances for each member */
    COUNT(ca.class_attendance_id) AS registration_count
FROM 
    members m
/* Left join the members table with the class attendance table on the member id */
LEFT JOIN 
    class_attendance ca ON m.member_id = ca.member_id
/* Group the results by member id, first name, and last name */
GROUP BY 
    m.member_id, m.first_name, m.last_name
/* Order the results by the registration count in ascending order */
ORDER BY 
    registration_count ASC
/* Limit the output to the member with the lowest registration count */
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
SELECT
    /* Count the distinct member IDs, divide the count by the total number of distinct members from the members table */
    (CAST(
        COUNT(DISTINCT member_id) AS FLOAT) / 
    (SELECT 
        COUNT(DISTINCT member_id) FROM members)) * 100 AS percentage_attended
FROM 
    /* Get the data from the class_attendance table */
    class_attendance;