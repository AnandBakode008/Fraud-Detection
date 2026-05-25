-- Create Table 1 Users
create table Users(user_id varchar primary key,login_id	 varchar ,device_id varchar,  
merchant_id varchar,	name varchar,age int,gender varchar,account_created_date timestamp,
location varchar,avg_monthly_spend numeric);

--Import Data From CSV File 
copy  Users from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\User.csv'
Delimiter ',' CSV Header; 


-- Create Table 2 Blacklist
Create  Table  Blacklist(blacklist_id varchar	,merchant_id varchar,	device_id varchar, 
user_id varchar,ip_address varchar	,reason varchar,	added_on timestamp);

--Import Data From CSV File 
copy Blacklist from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\blacklist.csv' 
Delimiter ',' CSV Header;


-- Create Table 3  Transaction_Features
Create table Transactions_Features (transaction_id varchar, user_id varchar,device_id varchar,
amount_score numeric, txn_count_last_24h numeric, txn_amount_last_24h numeric,avg_amount_30d numeric,
device_change_flag numeric,location_change_flag numeric  , international_risk_flag numeric);

--Import Data From CSV File 
Copy Transactions_Features from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\transaction_features.csv' 
Delimiter ',' CSV Header;

-- Create Table 4  devices

create table devices(device_id varchar,
user_id varchar,
device_type varchar,
os varchar,
ip_address varchar,
is_compromised int
);

--Import Data From CSV File 

copy devices from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\Devices.csv' delimiter ',' csv header;


-- Create Table 5  transactions

create table transactions(transaction_id varchar,
user_id varchar,
device_id varchar,
transaction_date date,
amount float,
merchant_id varchar,
merchant_category varchar,
payment_method varchar,
location varchar,
is_international int,
label int
);


--Import Data From CSV File 

copy transactions from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\Transactions.csv' 
delimiter ',' csv header;


-- Create Table 6  merchant
create table merchant(
merchant_id varchar,
merchant_name varchar,
merchant_category varchar,
city varchar,
is_blacklisted int
);

--Import Data From CSV File 
copy merchant from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\Merchant.csv' delimiter ',' csv header;

-- Create Table 7  login_activity

create table login_activity(
login_id varchar,
user_id varchar,
device_id varchar,
login_time timestamp,
ip_address varchar,
location varchar,
login_status varchar);

--Import Data From CSV File 

copy login_activity from 'D:\Projects\Group Projects\Fraud Detection\CSV Files\login_activity.csv'
delimiter ',' csv header;


-- 1. User Demographics
 Select name, age, location 
 from users
 where age > 60;


-- 2. High-Value Transactions
     SELECT transaction_id, amount 
	 FROM transactions
	 WHERE amount > 45000;


-- 3. Compromised Devices
     SELECT DISTINCT device_id
     FROM devices
     WHERE is_compromised = 1;

-- 4. Merchant Search
     SELECT *
	 FROM merchant
	 WHERE city IN ('Ranchi', 'Mumbai');

-- 5. Failed Login Attempts
     SELECT *
	 FROM login_activity
	 WHERE login_status = 'Failed';


-- 6. Total Spend per User
SELECT 
    u.name,
    SUM(t.amount) AS total_spent
FROM users u
JOIN transactions t
ON u.user_id = t.user_id
GROUP BY u.name
ORDER BY total_spent DESC;


-- 7. Merchant Category Analysis

SELECT 
    merchant_category,
    ROUND(AVG(amount)::numeric,2) AS avg_transaction_amount
FROM transactions
GROUP BY merchant_category
ORDER BY avg_transaction_amount DESC;


-- 8. Suspicious Device Activity
SELECT 
    u.name,
    d.device_type,
    d.is_compromised
FROM users u
JOIN devices d
ON u.user_id = d.user_id
WHERE d.device_type = 'Linux Desktop'
AND d.is_compromised = 1;


-- 9. Blacklist Reason Count
SELECT 
    reason,
    COUNT(*) AS total_count
FROM blacklist
GROUP BY reason
ORDER BY total_count DESC;


-- 10. International Risk Users
SELECT DISTINCT
    u.name,
    t.merchant_category
FROM users u
JOIN transactions t
ON u.user_id = t.user_id
WHERE t.is_international = 1;


-- 11. Spending vs Average Monthly Spend

SELECT 
    t.transaction_id,
    u.name,
    t.amount,
    u.avg_monthly_spend
FROM users u
JOIN transactions t
ON u.user_id = t.user_id
WHERE t.amount > u.avg_monthly_spend;


-- 12. Login Location Mismatch
WITH latest_login AS (
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY user_id
        ORDER BY login_time DESC
    ) AS rn
    FROM login_activity
)

SELECT 
    u.user_id,
    u.name,
    u.location AS registered_location,
    l.location AS latest_login_location
FROM users u
JOIN latest_login l
ON u.user_id = l.user_id
WHERE l.rn = 1
AND u.location <> l.location;

-- 13. Frequent Transactors with Device Change
SELECT 
    tf.user_id,
    tf.txn_count_last_24h,
    tf.device_change_flag
FROM transactions_features tf
WHERE tf.txn_count_last_24h > 30
AND tf.device_change_flag = 1;


-- 14. Blacklisted Merchants Percentage by City

SELECT 
    city,
    ROUND(
        100.0 * SUM(
            CASE 
                WHEN is_blacklisted = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
    2) AS blacklist_percentage
FROM merchant
GROUP BY city
ORDER BY blacklist_percentage DESC;


-- 15. Full Picture Audit Report
SELECT 
    t.transaction_id,
    u.name,
    d.device_type,
    m.merchant_name,
    b.reason AS blacklist_reason
FROM transactions t

LEFT JOIN users u
ON t.user_id = u.user_id

LEFT JOIN devices d
ON t.device_id = d.device_id

LEFT JOIN merchant m
ON t.merchant_id = m.merchant_id

LEFT JOIN blacklist b
ON t.user_id = b.user_id
OR t.device_id = b.device_id
OR t.merchant_id = b.merchant_id;



-- 16. Top 10 Users with Highest Fraud Transactions

SELECT 
    u.name,
    COUNT(*) AS fraud_transactions
FROM users u
JOIN transactions t
ON u.user_id = t.user_id
WHERE t.label = 1
GROUP BY u.name
ORDER BY fraud_transactions DESC
LIMIT 10;

-- 17. Fraud Rate by Payment Method
SELECT 
    payment_method,
    
    COUNT(*) AS total_transactions,

    SUM(
        CASE 
            WHEN label = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_count,

    ROUND(
        100.0 * SUM(
            CASE 
                WHEN label = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
    2) AS fraud_rate_percentage

FROM transactions
GROUP BY payment_method
ORDER BY fraud_rate_percentage DESC;


-- 18. Users Using Multiple Devices

SELECT 
    u.name,
    COUNT(DISTINCT d.device_id) AS total_devices
FROM users u
JOIN devices d
ON u.user_id = d.user_id
GROUP BY u.name
HAVING COUNT(DISTINCT d.device_id) > 3
ORDER BY total_devices DESC;

-- 19. Most Risky Merchant Categories
SELECT 
    merchant_category,

    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN label = 1 THEN 1
            ELSE 0
        END
    ) AS fraud_transactions,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN label = 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
    2) AS fraud_percentage

FROM transactions
GROUP BY merchant_category
ORDER BY fraud_percentage DESC;


-- 20. Users with Failed Logins and Fraud Transactions
SELECT DISTINCT
    u.name,
    COUNT(l.login_id) AS failed_logins,
    COUNT(t.transaction_id) AS fraud_transactions
FROM users u

JOIN login_activity l
ON u.user_id = l.user_id

JOIN transactions t
ON u.user_id = t.user_id

WHERE l.login_status = 'Failed'
AND t.label = 1

GROUP BY u.name
ORDER BY fraud_transactions DESC;