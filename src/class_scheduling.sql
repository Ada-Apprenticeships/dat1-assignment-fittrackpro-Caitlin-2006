-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT 
    /* Get the class id from the classes table */
    c.class_id,
    /* Get the name of the class */
    c.name AS class_name,
    /* Concatenate the first and last name of the instructor */
    s.first_name || ' ' || s.last_name AS instructor_name
FROM 
    /* Start with the classes table */
    classes c
/* Join the classes table with the class schedule table on the class id */
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
/* Join the result with the staff table on the staff id */
JOIN 
    staff s ON cs.staff_id = s.staff_id
/* Order the results by class id */
ORDER BY 
    c.class_id;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT 
    /* Get the class id and name of the class from the classes table */
    c.class_id,
    c.name,
    /* Get the start time and end time of the class schedule */
    cs.start_time,
    cs.end_time,
    /* Calculate the available spots for each class by subtracting the registered attendees from the capacity */
    (c.capacity - COUNT(ca.class_attendance_id)) AS available_spots
FROM 
    /* Start with the classes table */
    classes c
/* Join the classes table with the class schedule table on the class id */
JOIN 
    class_schedule cs ON c.class_id = cs.class_id
/* Left join the result with the class attendance table on the schedule id */
/* This will include classes with no registered attendees */
LEFT JOIN 
    class_attendance ca ON cs.schedule_id = ca.schedule_id 
                      AND ca.attendance_status = 'Registered'
/* Filter for classes on the specific date (2025-02-01) */
WHERE 
    DATE(cs.start_time) = '2025-02-01'
/* Group the results by class id, class name, start time, end time, and capacity */
GROUP BY 
    c.class_id, c.name, cs.start_time, cs.end_time, c.capacity
/* Order the results by the start time */
ORDER BY 
    cs.start_time;

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class

/*INSERT INTO class_attendance (attendance_status, schedule_id, member_id)
Values('Registered', 3,11);*/

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration

DELETE FROM class_attendance
WHERE 
    schedule_id = 7 
    AND member_id = 2;

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes
SELECT
    /* Get the class id  and name from the classes table */
    c.class_id,
    c.name AS class_name, 
    /* Count the number of registered attendees for each class */
    COUNT(ca.class_attendance_id) AS registration_count
FROM
    /* Start with the classes table */
    classes c
    /* Join the classes table with the class schedule table on the class id */
    INNER JOIN 
        class_schedule cs ON c.class_id = cs.class_id
    /* Left join the result with the class attendance table on the schedule id */
    /* This will include classes with no registered attendees */
    LEFT JOIN 
        class_attendance ca ON cs.schedule_id = ca.schedule_id AND ca.attendance_status = 'Registered'
/* Group the results by class id and class name */
GROUP BY
    c.class_id, c.name
/* Order the results by the registration count in descending order */
ORDER BY
    registration_count DESC
/* Limit the output to the top 3 classes with the highest registration count */
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT 
    /* Calculate the average of the class count from the subquery */
    AVG(class_count) AS average_classes_per_member
FROM (
    SELECT 
        /* Get the member id from the members table */
        m.member_id,
        /* Count the number of class attendances for each member */
        COUNT(ca.class_attendance_id) AS class_count
    FROM 
        /* Start with the members table */
        members m
    /* Left join the members table with the class attendance table on the member id */
    /* This will include members with no class attendances */
    LEFT JOIN 
        class_attendance ca ON m.member_id = ca.member_id
    /* Group the results by member id */
    GROUP BY 
        m.member_id
);