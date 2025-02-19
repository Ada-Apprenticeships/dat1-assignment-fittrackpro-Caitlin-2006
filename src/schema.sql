-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );

-- TODO: Create the following tables:
-- 1. locations
-- 2. members
-- 3. staff
-- 4. equipment
-- 5. classes
-- 6. class_schedule
-- 7. memberships
-- 8. attendance
-- 9. class_attendance
-- 10. payments
-- 11. personal_training_sessions
-- 12. member_health_metrics
-- 13. equipment_maintenance_log

DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL CHECK(length(name) > 1),
    address VARCHAR(255) NOT NULL CHECK(length(address) > 1),
    phone_number VARCHAR(15) CHECK(phone_number LIKE '___-____'),
    email VARCHAR(100) NOT NULL CHECK(email LIKE '%@%'),
    opening_hours VARCHAR(50) NOT NULL CHECK(opening_hours GLOB '[0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]') --GLOB is used to match patterns, LIKE doesnt work here--
);

/*INSERT INTO locations (name, address, phone_number, email, opening_hours) 
VALUES ('Edge Case Location 3', '789 Invalid Rd', '123-4567', 'invalid@example.com', '8AM to 8PM');

INSERT INTO locations (name, address, phone_number, email, opening_hours) 
VALUES ('Sunset Location 2', '456 Rainbow Ave', '123-7654', 'invalidemail', '09:00-19:00');*/

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(100) NOT NULL CHECK(length(first_name) > 1),
    last_name VARCHAR(100) NOT NULL CHECK(length(last_name) > 1),
    email VARCHAR(100) NOT NULL CHECK(email LIKE '%@%'),
    phone_number VARCHAR(15) CHECK(phone_number LIKE '___-____'),
    date_of_birth DATE NOT NULL CHECK(date_of_birth LIKE '____-__-__'),
    join_date DATE NOT NULL CHECK(join_date LIKE '____-__-__'),
    emergency_contact_name VARCHAR(100) NOT NULL CHECK(length(emergency_contact_name) > 1),
    emergency_contact_phone VARCHAR(15) CHECK(emergency_contact_phone LIKE '___-____')
);

/*INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES ('Invalid', 'Member', 'invalidmember@example.com', '123', '1990-01-01', '2023-01-01', 'Emergency Contact', '123-456-7890');

INSERT INTO members (first_name, last_name, email, phone_number, date_of_birth, join_date, emergency_contact_name, emergency_contact_phone)
VALUES ('Future', 'McMullen', 'futuremcmullen@example.com', '123-4566', '2050-01-01', '2023-01-01', 'ICE', '156-7654');*/

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(100) NOT NULL CHECK(length(first_name) > 1),
    last_name VARCHAR(100) NOT NULL CHECK(length(last_name) > 1),
    email VARCHAR(100) NOT NULL CHECK(email LIKE '%@%'),
    phone_number VARCHAR(15) CHECK(phone_number LIKE '___-____'),
    position VARCHAR(20) NOT NULL CHECK(position IN ('Manager', 'Trainer', 'Receptionist','Maintenance')),
    hire_date DATE NOT NULL CHECK(hire_date LIKE '____-__-__'),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

/*INSERT INTO staff (first_name, last_name, email, phone_number, position, hire_date, location_id)
VALUES ('Jake', 'Smith', jakesmith@google.com,'234-3456', 'Manager', '23-01-01', 1);*/

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL CHECK(length(name) > 1),
    type VARCHAR(20) CHECK(type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL CHECK(purchase_date LIKE '____-__-__'),
    last_maintenance_date DATE NOT NULL CHECK(last_maintenance_date LIKE '____-__-__'),
    next_maintenance_date DATE NOT NULL CHECK(next_maintenance_date LIKE '____-__-__'),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

/*INSERT INTO equipment (name, type, purchase_date, last_maintenance_date, next_maintenance_date, location_id)
VALUES ('Future Equipment', 'Cardio', '2050-01-01', '2023-01-01', '2024-01-01', 1);*/

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL CHECK(length(name) > 1),
    description TEXT NOT NULL CHECK(length(description) > 1),
    capacity INTEGER NOT NULL CHECK(capacity > 0),
    duration INTEGER NOT NULL CHECK(duration > 0),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

/*INSERT INTO classes (name, description, capacity, duration, location_id)
VALUES ('Negative Capacity Class', 'This class has negative capacity', -10, 60, 1);*/

/*INSERT INTO classes (name, description, capacity, duration, location_id)
VALUES ('C', 'D', 1, 30, 1);*/


CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER,
    staff_id INTEGER,
    start_time DATETIME NOT NULL CHECK(start_time < end_time),
    end_time DATETIME NOT NULL CHECK(end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

/*INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES (1, 1, '2023-01-01 20:00:00', '2023-01-01 19:00:00');*/

/*INSERT INTO class_schedule (class_id, staff_id, start_time, end_time)
VALUES (1, 1, '2023-05-15 09:00:00', '2023-05-15 09:00:00'); */

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER,
    type VARCHAR(20) NOT NULL CHECK(type IN ('Basic', 'Premium')),
    start_date DATE NOT NULL CHECK(start_date LIKE '____-__-__'),
    end_date DATE NOT NULL CHECK(end_date LIKE '____-__-__'),
    status VARCHAR(20) CHECK(status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

/*INSERT INTO memberships (member_id, type, start_date, end_date, status)
VALUES (1, 'Basic', '2050-01-01', '2050-12-31', 'Active');*/

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time DATETIME NOT NULL CHECK(check_in_time < check_out_time),
    check_out_time DATETIME CHECK(check_out_time > check_in_time),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

/*INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (1, 1, '2023-01-01 20:00:00', '2023-01-01 19:00:00');*/

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR(20) CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

/*INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (1, 1, 'Registered');*/

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER,
    amount DECIMAL(10, 2) NOT NULL CHECK(amount > 0),
    payment_date DATETIME NOT NULL CHECK(payment_date LIKE '____-__-__ __:__:__'),
    payment_method VARCHAR(50) CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(50) CHECK(payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

/*INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (1, -50.00, '2023-01-01 10:00:00', 'Credit Card', 'Monthly membership fee');*/

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER,
    staff_id INTEGER,
    session_date DATE NOT NULL CHECK(session_date LIKE '____-__-__'),
    start_time DATETIME NOT NULL CHECK(start_time < end_time),
    end_time DATETIME NOT NULL CHECK(end_time > start_time),
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

/*INSERT INTO personal_training_sessions (member_id, staff_id, session_date, start_time, end_time, notes)
VALUES (1, 1, '2050-01-01', '10:00:00', '11:00:00', 'Future session');*/

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER,
    measurement_date DATE NOT NULL CHECK(measurement_date LIKE '____-__-__'),
    weight DECIMAL(5, 2) NOT NULL CHECK(weight > 0),
    body_fat_percentage DECIMAL(5, 2) NOT NULL CHECK(body_fat_percentage > 0),
    muscle_mass DECIMAL(5, 2) NOT NULL CHECK(muscle_mass > 0),
    bmi DECIMAL(5, 2) NOT NULL CHECK(bmi > 0),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

/*INSERT INTO member_health_metrics (member_id, measurement_date, weight, body_fat_percentage, muscle_mass, bmi)
VALUES (1, '2023-01-01', -80.50, 20.00, 50.00, 25.00);

INSERT INTO member_health_metrics (member_id, measurement_date, weight, body_fat_percentage, muscle_mass, bmi)
VALUES (12, '2022-03-01', 80.50, 0.1, 67.00, 15.00);*/


CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER,
    maintenance_date DATE NOT NULL CHECK(maintenance_date LIKE '____-__-__'),
    description TEXT NOT NULL,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal