-- DATA WRANGLING
-- Create a new temp table to store the data manipulations in SQL
SELECT
   order_id,
   customer_id,
   pizza_id,
   CASE
   WHEN exclusions LIKE '%null%' THEN ' '
   ELSE exclusions
   END AS exclusions,
   CASE
   WHEN extras LIKE '%null%' THEN ' '
       WHEN extras is null THEN ' '
   ELSE extras
   END AS extras,
   order_time
INTO t_customer_orders
FROM customer_orders;


SELECT * FROM customer_orders
SELECT * FROM t_customer_orders
SELECT * FROM runner_orders
-- runner_orders
SELECT 
    order_id,
    runner_id,
    CASE 
        WHEN pickup_time LIKE '%null%' or pickup_time LIKE '%NULL%' THEN ' '
        ELSE pickup_time
    END AS pickup_time,
    CASE 
        WHEN distance LIKE '%null%' THEN ' '
        WHEN distance LIKE '%km%' THEN TRIM('km' from distance)
        ELSE distance
    END as distance,
    CASE 
        WHEN duration LIKE '%null' THEN ' '
        WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
        WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
        WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
        ELSE duration
    END as duration,
    CASE 
        WHEN cancellation is NULL or cancellation LIKE '%null%' THEN ' '
        ELSE cancellation 
    END as cancellation
INTO t_runner_orders
FROM runner_orders

select * from t_runner_orders

ALTER TABLE t_runner_orders
ALTER COLUMN pickup_time DATETIME;
ALTER TABLE t_runner_orders
ALTER COLUMN distance FLOAT;
ALTER TABLE t_runner_orders
ALTER COLUMN duration int;
