-- Buat databases dengan cara click kanan databases -> create -> databases -> isi nama db.
-- Setelah databases sudah dibuat dan mau generate csv ke sql, lakukan create table terlebih dahulu.
-- By GUI untuk membuat table dengan cara click dropdown schema -> click kanan table -> create table.

-- By SQL dengan cara sebagai berikut dengan mengikuti kolom yang ada difile csv.
CREATE TABLE product_dataset (
	product_id VARCHAR,
	product_category_name VARCHAR,
	product_name_length FLOAT,
	product_description_length FLOAT,
	product_photos_qty FLOAT,
	product_weight_g FLOAT,
	product_length_cm FLOAT,
	product_height_cm FLOAT,
	product_width_cm FLOAT
);

CREATE TABLE geolocation_dataset (
	geolocation_zip_code_prefix VARCHAR,
	geolocation_lat FLOAT,
	geolocation_lng FLOAT,
	geolocation_city VARCHAR,
	geolocation_state VARCHAR
);

CREATE TABLE customers_dataset (
	customer_id VARCHAR,
	customer_unique_id VARCHAR,
	customer_zip_code_prefix VARCHAR,
	customer_city VARCHAR,
	customer_state VARCHAR
);

CREATE TABLE sellers_dataset (
	seller_id VARCHAR,
	seller_zip_code_prefix VARCHAR,
	seller_city VARCHAR,
	seller_state VARCHAR
);

CREATE TABLE orders_dataset (
	order_id VARCHAR,
	customer_id VARCHAR,
	order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_reviews_dataset (
	review_id VARCHAR,
	order_id VARCHAR,
	review_score INT,
	review_comment_title VARCHAR,
	review_comment_message VARCHAR,
	review_creation_date TIMESTAMP,
	review_answer_date TIMESTAMP
);

CREATE TABLE order_payments_dataset (
	order_id VARCHAR,
	payment_sequential INT,
	payment_type VARCHAR,
	payment_installments INT,
	payment_value FLOAT
);

CREATE TABLE order_items_dataset (
	order_id VARCHAR,
	order_item_id INT,
	product_id VARCHAR,
	seller_id VARCHAR,
	shipping_limit_date TIMESTAMP,
	price FLOAT,
	freight_value FLOAT
);

-- MEMBUAT PRIMARY KEY PADA SETIAP TABLE
ALTER TABLE product_dataset ADD CONSTRAINT product_dataset_pkey PRIMARY KEY(product_id);
ALTER TABLE customers_dataset ADD CONSTRAINT customer_dataset_pkey PRIMARY KEY(customer_id);
ALTER TABLE sellers_dataset ADD CONSTRAINT seller_dataset_pkey PRIMARY KEY(seller_id);
ALTER TABLE orders_dataset ADD CONSTRAINT order_dataset_pkey PRIMARY KEY(order_id);
-- TABLE geolocation_dataset tidak bisa primary key untuk kolom zip_code, karna terdapat double data

-- MEMBUAT FOREIGN KEY UNTUK RELASI ANTAR TABLE
ALTER TABLE order_items_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (product_id) REFERENCES product_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (seller_id) REFERENCES sellers_dataset;
ALTER TABLE order_reviews_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_payments_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE orders_dataset ADD FOREIGN KEY (customer_id) REFERENCES customers_dataset;

-- KEMUDIAN BUAT ERD DENGAN CARA CLICK KANAN DATABASES -> ERD FOR DATABASES