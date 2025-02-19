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
    /* Assign the month part of the payment date to a readable month name */
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
    /* Calculate the total revenue by summing the amount */
    SUM(amount) AS total_revenue
FROM 
    /* Get data from the payments table */
    payments
/* Filter for payments with the type 'Monthly membership fee' */
WHERE 
    payment_type = 'Monthly membership fee'
    /* Filter for payments made between 1 year ago and today */
    AND payment_date BETWEEN DATE('now', '-1 year') AND DATE('now')
/* Group the results by the month */
GROUP BY 
    month
/* Order the results by the month in ascending order */
ORDER BY 
    strftime('%m', payment_date);

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases
SELECT 
    /* Get the payment id,amount,payment date and payment method from the payments table */
    payment_id,
    amount,
    payment_date,
    payment_method
FROM 
    /* Get data from the payments table */
    payments
/* Filter for payments with the type 'Day pass' */
WHERE 
    payment_type = 'Day pass';