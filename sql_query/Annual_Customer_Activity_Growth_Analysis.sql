-- Rata2 jumlah customer aktif perbulan (Monthly Active User) disetiap tahunnya
WITH monthly_active_user AS (
	SELECT 
	tahun, 
	FLOOR(avg(customer_total)) as rata2_customer_aktif
FROM (
		SELECT
			date_part('year', od.order_purchase_timestamp) AS tahun,
			date_part('month', od.order_purchase_timestamp) AS bulan,
			COUNT(DISTINCT cd.customer_unique_id) AS customer_total
		FROM
			orders_dataset AS od
		JOIN
			customers_dataset AS cd
		ON
			od.customer_id = cd.customer_id
		GROUP BY tahun, bulan
	) AS tmp
GROUP BY tahun
),

total_new_customer AS(
	SELECT 
	date_part('year', pembelian_pertama) AS tahun,
	count(customer) AS total_customer_baru
FROM (
		SELECT
			cd.customer_unique_id AS customer,
			MIN(od.order_purchase_timestamp) AS pembelian_pertama
		FROM 
			customers_dataset AS cd
		JOIN 
			orders_dataset AS OD
		ON
			cd.customer_id = od.customer_id
		GROUP BY customer
	) AS tmp
GROUP BY tahun
ORDER BY tahun
),

repeat_order AS (
	SELECT 
	tahun, 
	COUNT(customer) AS total_repeat_order_customer
FROM(
		SELECT
			date_part('year', od.order_purchase_timestamp) AS tahun,
			cd.customer_unique_id AS customer,
			COUNT(od.order_id) AS total_order
		FROM 
			orders_dataset AS od
		JOIN
			customers_dataset as cd
		ON
			od.customer_id = cd.customer_id
		GROUP BY tahun, customer
		HAVING COUNT(od.order_id) > 1
	)tmp
GROUP BY tahun
ORDER BY tahun
),

freq_order AS (
	SELECT
	tahun,
	ROUND(AVG(freq),3) AS rata2_frekuensi
FROM(
		SELECT 
			date_part('year', od.order_purchase_timestamp) AS tahun,
			cd.customer_unique_id as customer,
			COUNT(od.order_id) as freq
		FROM
			orders_dataset as od
		JOIN
			customers_dataset as cd
		ON
			od.customer_id = cd.customer_id
		GROUP BY tahun, customer
	) tmp
GROUP BY tahun
)

SELECT DISTINCT
	mau.tahun,
	mau.rata2_customer_aktif,
	tnc.total_customer_baru,
	ro.total_repeat_order_customer,
	fo.rata2_frekuensi
FROM
	monthly_active_user AS mau
JOIN
	total_new_customer AS tnc ON tnc.tahun = mau.tahun
JOIN
	repeat_order AS ro ON ro.tahun = mau.tahun
JOIN
	freq_order AS fo ON fo.tahun = mau.tahun