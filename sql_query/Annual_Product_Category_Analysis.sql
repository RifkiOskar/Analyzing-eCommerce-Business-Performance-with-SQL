-- Membuat table untuk pendapatan pertahun
CREATE TABLE total_revenue AS (
	SELECT
		date_part('year', od.order_purchase_timestamp) AS tahun,
		ROUND(CAST(SUM(oid.price + oid.freight_value) AS numeric),2) AS revenue
	FROM orders_dataset AS od
	JOIN order_items_dataset AS oid ON od.order_id = oid.order_id
	WHERE od.order_status = 'delivered'
	GROUP BY tahun
	ORDER BY tahun
)

-- Membuat table untuk cancel order pertahun
CREATE TABLE total_cancel AS (
	SELECT
		date_part('year', order_purchase_timestamp) AS tahun,
		COUNT(order_status) AS canceled
	FROM orders_dataset
	WHERE order_status like '%canceled%'
	GROUP BY tahun
	ORDER BY tahun
)

-- Membuat table top category yg menghasilkan revenue terbesar
CREATE TABLE top_category AS (
	SELECT
		tahun,
		top_category_product,
		revenue_product
	FROM (
		SELECT
			date_part('year', od.order_purchase_timestamp) AS tahun,
			pd.product_category_name AS top_category_product,
			ROUND(CAST(SUM(oid.price + oid.freight_value)AS numeric),2) AS revenue_product,
			RANK() OVER(PARTITION BY date_part('year', od.order_purchase_timestamp)
						ORDER BY SUM(oid.price + oid.freight_value)
						DESC
					   ) AS ranking
		FROM orders_dataset AS od
		JOIN order_items_dataset AS oid ON od.order_id = oid.order_id
		JOIN product_dataset AS pd ON oid.product_id = pd.product_id
		WHERE od.order_status like '%delivered%'
		GROUP BY tahun, top_category_product
		ORDER BY tahun
	) AS tmp
	WHERE ranking = 1
)

-- Membuat table category yg mengalami cancel paling banyak
CREATE TABLE top_cancel_category AS (
	SELECT
		tahun,
		top_cancel_product,
		total_top_cancel_product
	FROM (
		SELECT
			date_part('year', od.order_purchase_timestamp) AS tahun,
			pd.product_category_name as top_cancel_product,
			COUNT(od.order_id) as total_top_cancel_product,
			RANK() OVER(PARTITION BY date_part('year', od.order_purchase_timestamp)
						ORDER BY count(od.order_id)
						DESC
					   ) AS ranking
		FROM orders_dataset AS od
		JOIN order_items_dataset AS oid ON od.order_id = oid.order_id
		JOIN product_dataset AS pd ON oid.product_id = pd.product_id
		WHERE od.order_status like '%canceled%'
		GROUP BY tahun, top_cancel_product
		ORDER BY tahun
	) AS tmp
	WHERE ranking = 1
)

-- Menampilkan informasi yang dibutuhkan dari table yang sudah dibuat
SELECT
	tr.tahun,
	tr.revenue,
	tc.canceled,
	tcp.top_category_product,
	tcp.revenue_product,
	tcc.top_cancel_product,
	tcc.total_top_cancel_product
FROM total_revenue AS tr
JOIN total_cancel AS tc ON tr.tahun = tc.tahun
JOIN top_category AS tcp on tr.tahun = tcp.tahun
JOIN top_cancel_category AS tcc ON tr.tahun = tcc.tahun