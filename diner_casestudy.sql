#case Study Questions
#Each of the following case study questions can be answered using a single SQL statement:

#What is the total amount each customer spent at the restaurant?
SELECT product_id, SUM(price) AS total_price
FROM menu
GROUP BY product_id;

SELECT s.customer_id, SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id;

#################
# How many days has each customer visited the restaurant?

SELECT s.customer_id, COUNT(DISTINCT s.order_date) AS visit_days
FROM sales AS s
JOIN members AS m ON s.customer_id = m.customer_id
GROUP BY s.customer_id;

# What was the first item from the menu purchased by each customer?

SELECT s.customer_id, MIN(s.order_date) AS first_purchase_date, m.product_name AS first_item
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id;

##### What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name, COUNT(s.product_id) AS purchase_count
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.product_id
ORDER BY purchase_count DESC
LIMIT 1;

### Which item was the most popular for each customer?

SELECT s.customer_id, m.product_name AS most_popular_item
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY COUNT(s.product_id) DESC;

# Which item was purchased first by the customer after they became a member?

SELECT m.product_name, s.customer_id
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date > mem.join_date
ORDER BY s.order_date ASC
LIMIT 1;

### Which item was purchased just before the customer became a member?

SELECT m.product_name, s.customer_id
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
ORDER BY s.order_date DESC
LIMIT 1;

## What is the total number of items and the amount spent for each member before they became a member?

SELECT s.customer_id, COUNT(s.product_id) AS total_items, SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id;

## In the first week after a customer joins the program (including their join date), they earn 2x points on all items, not just sushi. How many points do customer A and B have at the end of January?
SELECT s.customer_id, SUM(
    CASE
        WHEN s.order_date <= DATE_ADD(mem.join_date, INTERVAL 1 WEEK) THEN m.price * 2 * 10
        ELSE m.price * 10
    END
) AS total_points
FROM sales AS s
JOIN menu AS m ON s.product_id = m.product_id
JOIN members AS mem ON s.customer_id = mem.customer_id
WHERE MONTH(s.order_date) = 1
GROUP BY s.customer_id;

