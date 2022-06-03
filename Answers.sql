/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?


SELECT s.customer_id ,sum(m.price) total_amount
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?


SELECT customer_id ,COUNT(DISTINCT(order_date)) visits
FROM dannys_diner.sales
GROUP BY customer_id;


-- 3. What was the first item from the menu purchased by each customer?

SELECT sub.customer_id,
		sub.product_name
FROM
      (SELECT s.customer_id,
              m.product_name,
              ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) order_num
      FROM dannys_diner.sales s
      JOIN dannys_diner.menu m
      ON s.product_id = m.product_id) sub
WHERE sub.order_num = 1 ;



-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?


SELECT m.product_name,
       COUNT(*) times_sold
FROM dannys_diner.sales s
JOIN dannys_diner.menu m
ON s.product_id = m.product_id
GROUP BY m.product_name
LIMIT 1;



-- 5. Which item was the most popular for each customer?


SELECT sub.customer_id ,sub.product_name ,sub.times_bought
FROM
    (SELECT s.customer_id,
           m.product_name,
           COUNT(*) times_bought,
           MAX(COUNT(*)) OVER(PARTITION BY s.customer_id ) best
    FROM dannys_diner.sales s
    JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    GROUP BY s.customer_id,m.product_name
    ORDER BY s.customer_id ,times_bought DESC) sub
WHERE sub.times_bought = sub.best
;


-- 6. Which item was purchased first by the customer after they became a member?


SELECT sub.customer_id , sub.product_name
FROM
    (SELECT s.customer_id , m.product_name, s.order_date,
           ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date)     	order_num
    FROM dannys_diner.sales s
    JOIN dannys_diner.members b
    ON s.customer_id = b.customer_id
    JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    WHERE s.order_date >= b.join_date) sub
WHERE order_num = 1;
