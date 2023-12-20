SELECT count(*) FROM departments;
SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT count(*) FROM customers;

--EXERCISE 1
SELECT customer_id, customer_fname, customer_lname, count(*) AS customer_order_count
FROM customers
	 JOIN orders
		ON customers.customer_id = orders.order_customer_id
WHERE to_char(orders.order_date, 'yyyy-MM') = '2014-01'
GROUP BY customer_id
ORDER BY 1 ASC;

--EXERCISE 2
SELECT c.*
FROM customers AS c
    LEFT OUTER JOIN orders AS o
        ON o.order_customer_id = c.customer_id
            AND to_char(order_date, 'yyyy-MM') = '2014-01'
WHERE o.order_customer_id IS NULL;

--EXERCISE 3
SELECT c.customer_id, 
c.customer_fname, 
c.customer_lname, 
coalesce(round(sum(oi.order_item_subtotal)::numeric, 2),0) AS customer_revenue
FROM customers AS c
	LEFT OUTER JOIN orders AS o
		ON o.order_customer_id = c.customer_id
			AND to_char(order_date, 'yyyy-MM') = '2014-01'
			AND o.order_status IN ('COMPLETE', 'CLOSED')
	LEFT OUTER JOIN order_items AS oi
		ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1;
		
		
--EXERCISE 4 
SELECT c.*, round(sum(oi.order_item_subtotal)::numeric,2) AS category_revenue
FROM categories AS c
	JOIN products AS p
		ON c.category_id = p.product_category_id
	JOIN order_items AS oi
		ON oi.order_item_product_id = p.product_id
	JOIN orders AS o
		ON oi.order_item_order_id = o.order_id
			AND order_status IN ('COMPLETE', 'CLOSED')
			AND to_char(order_date, 'yyyy-MM') = '2014-01'
GROUP BY c.category_id
ORDER BY c.category_id;