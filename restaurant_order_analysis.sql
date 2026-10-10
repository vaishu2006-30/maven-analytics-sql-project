USE restaurant_db;

-- View the menu_items table and write a query to find the number of items on the menu
SELECT COUNT(*) AS number_of_items
FROM menu_items;

-- What are the least and most expensive items on the menu?
SELECT *
FROM menu_items
ORDER BY price;

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price;

-- How many dishes are in each category? What is the average dish price within each category?
SELECT 
    category,
    COUNT(*) AS number_of_dishes,
    AVG(price) AS average_price
FROM menu_items
GROUP BY category;

-- View the order_details table. What is the date range of the table?
SELECT 
    MIN(order_date) AS start_date,
    MAX(order_date) AS end_date
FROM order_details;

-- How many orders were made within this date range? How many items were ordered within this date range?
SELECT 
    COUNT(DISTINCT order_id) AS number_of_orders,
    COUNT(*) AS number_of_items
FROM order_details;

-- Which orders had the most number of items?
SELECT 
    order_id,
    COUNT(*) AS number_of_items
FROM order_details
GROUP BY order_id
ORDER BY number_of_items DESC;

-- How many orders had more than 12 items?
SELECT COUNT(*) AS orders_more_than_12
FROM (
    SELECT order_id
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(*) > 12
) AS order_counts;

-- Combine the menu_items and order_details tables into a single table
SELECT *
FROM order_details
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id;

-- What were the least and most ordered items? What categories were they in?
SELECT 
    menu_items.item_name,
    menu_items.category,
    COUNT(*) AS times_ordered
FROM order_details
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id
GROUP BY menu_items.item_name, menu_items.category
ORDER BY times_ordered DESC;

-- What were the top 5 orders that spent the most money?
SELECT 
    order_details.order_id,
    SUM(menu_items.price) AS total_spent
FROM order_details
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id
GROUP BY order_details.order_id
ORDER BY total_spent DESC
LIMIT 5;

-- View the details of the highest spend order. Which specific items were purchased?
SELECT 
    order_details.order_id,
    menu_items.item_name,
    menu_items.category,
    menu_items.price
FROM order_details
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id
WHERE order_details.order_id = (
    SELECT order_id
    FROM order_details
    JOIN menu_items
    ON order_details.item_id = menu_items.menu_item_id
    GROUP BY order_details.order_id
    ORDER BY SUM(menu_items.price) DESC
    LIMIT 1
);

-- BONUS: View the details of the top 5 highest spend orders
SELECT 
    order_details.order_id,
    menu_items.item_name,
    menu_items.category,
    menu_items.price
FROM order_details
JOIN menu_items
ON order_details.item_id = menu_items.menu_item_id
WHERE order_details.order_id IN (
    SELECT order_id
    FROM order_details
    JOIN menu_items
    ON order_details.item_id = menu_items.menu_item_id
    GROUP BY order_details.order_id
    ORDER BY SUM(menu_items.price) DESC
    LIMIT 5
)
ORDER BY order_details.order_id;

-- How much was the most expensive order in the dataset?
SELECT 
    MAX(total_spent) AS most_expensive_order
FROM (
    SELECT 
        order_id,
        SUM(menu_items.price) AS total_spent
    FROM order_details
    JOIN menu_items
    ON order_details.item_id = menu_items.menu_item_id
    GROUP BY order_id
) AS order_totals;