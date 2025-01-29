-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT * FROM members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT(*) AS total_members FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
SELECT member_id, COUNT(*) AS registration_count
FROM class_attendance
GROUP BY member_id
ORDER BY registration_count DESC

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class