-- Menampilkan detail jumlah penggunaan masing-masing tipe pembayaran setiap tahunnya
SELECT
	tipe_pembayaran,
	SUM(CASE WHEN tahun = '2016' THEN total ELSE 0 END) AS year_2016,
	SUM(CASE WHEN tahun = '2017' THEN total ELSE 0 END) AS year_2017,
	SUM(CASE WHEN tahun = '2018' THEN total ELSE 0 END) AS year_2018
FROM (
	SELECT
		op.payment_type AS tipe_pembayaran,
		count(op.order_id) AS total,
		date_part('year', od.order_purchase_timestamp) AS tahun
	FROM order_payments_dataset AS op
	JOIN orders_dataset AS od ON op.order_id = od.order_id
	GROUP BY tipe_pembayaran, tahun
) AS sub
GROUP BY tipe_pembayaran
ORDER BY year_2016