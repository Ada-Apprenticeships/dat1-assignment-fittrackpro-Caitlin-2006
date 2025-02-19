-- Initial SQLite setup
.open fittrackpro.db
.mode column
.mode box

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership
/*INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)
VALUES (11, 50.00, datetime('now'), 'Credit Card', 'Monthly membership fee');*/

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year
SELECT 
    CASE strftime('%m', payment_date)
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
    END AS month,
    SUM(amount) AS total_revenue
FROM 
    payments
WHERE 
    payment_type = 'Monthly membership fee'
    AND payment_date BETWEEN DATE('now', '-1 year') AND DATE('now')
GROUP BY 
    month
ORDER BY 
    strftime('%m', payment_date);
-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases
SELECT 
    payment_id,
    amount,
    payment_date,
    payment_method
FROM 
    payments
WHERE 
    payment_type = 'Day pass';