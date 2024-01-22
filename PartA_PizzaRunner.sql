--use pizza_runner
-- SET A : Pizza Metrics
SELECT * FROM t_customer_orders
SELECT * FROM t_runner_orders
SELECT * FROM pizza_names
--Q1) How many pizzas were ordered?
SELECT count(pizza_id) as total_pizza_orders FROM t_customer_orders;

-- Q2) How many unique customer orders were made?

SELECT count(DISTINCT order_id) as customer_orders FROM t_customer_orders

-- Q3) How many successful orders were delivered by each runner?

SELECT 
    runner_id, 
    count(runner_id) as successful_order
FROM t_runner_orders
where distance <> 0
group by runner_id

-- Q4) How many of each type of pizza was delivered?
SELECT 
    p.pizza_name,
    count(p.pizza_id) as total_pizza
FROM pizza_names p
JOIN t_customer_orders t 
on p.pizza_id = t.pizza_id
JOIN t_runner_orders r 
on t.order_id = r.order_id
WHERE r.cancellation = ' '
GROUP BY p.pizza_name;

-- Q5) How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
    c.customer_id, 
    SUM(IIF(p.pizza_name = 'Meatlovers',1,0)) as meat_lovers,
    SUM(IIF(p.pizza_name = 'Vegetarian',1,0)) as vegetarian
FROM pizza_names p
JOIN t_customer_orders c 
on p.pizza_id = c.pizza_id
GROUP BY c.customer_id, p.pizza_name;

-- Q6) What was the maximum number of pizzas delivered in a single order?
WITH CTE AS(
SELECT
    c.order_id, 
    COUNT(c.pizza_id) as pizza_count
FROM t_customer_orders c 
JOIN t_runner_orders r 
on c.order_id = r.order_id
GROUP BY c.order_id
)
SELECT MAX(pizza_count) as max_in_order FROM CTE

-- Q7) For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select 
    c.customer_id,
    SUM(
        CASE 
            WHEN c.exclusions = ' ' and c.extras = ' ' THEN  1
            ELSE 0
        END
    ) as 'no changes',
        SUM(
        CASE 
            WHEN c.exclusions <> ' ' or c.extras <> ' ' THEN  1
            ELSE 0
        END
    ) as 'changes'
 from t_customer_orders c
JOIN t_runner_orders r 
on c.order_id = r.order_id
WHERE r.distance !=0
GROUP BY c.customer_id

-- Q8) How many pizzas were delivered that had both exclusions and extras?

SELECT 
    count(c.pizza_id) as count_pizza
FROM t_customer_orders c
JOIN t_runner_orders r 
on c.order_id = r.order_id
WHERE exclusions <> ' ' and extras <> ' ' and r.cancellation = ' '


-- Q9) What was the total volume of pizzas ordered for each hour of the day?

SELECT
     DATEPART(hour, order_time) as each_hour,
     count(pizza_id) as total_volume
FROM t_customer_orders
GROUP BY DATEPART(hour, order_time)
order by each_hour

-- Q10) What was the volume of orders for each day of the week?

SELECT
     DATENAME(WEEKDAY, order_time) as day_of_Week,
     count(pizza_id) as total_volume
FROM t_customer_orders
GROUP BY DATENAME(WEEKDAY, order_time)
order by day_of_Week
