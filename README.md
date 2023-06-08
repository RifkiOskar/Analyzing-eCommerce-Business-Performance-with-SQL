#  **Analyzing E-Commerce Business Performance with SQL**
<br>

**Tools** : PostgreSQL <br> 
**Visualization** : Microsoft Excel <br>
**Dataset** : Rakamin Academy - [Ecommerce Data](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/tree/master/csv)
<br>
<br>
**Table of Contents**
- [Problem Statement](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/blob/master/README.md#-stage-0:-problem-statement)
	- [Background Story](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/blob/master/README.md#background-story)
	- [Objective](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/blob/master/README.md#objective)
- [Data Preparation](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/blob/master/README.md#-stage-0:-problem-statement)
	- [Background Story](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/blob/master/README.md#background-story)
	- [Objective](https://github.com/RifkiOskar/Analyzing-eCommerce-Business-Performance-with-SQL/blob/master/README.md#objective)
<br>

## 📂 **Problem Statement**

### **Background Story**
Mengukur performa bisnis merupakan suatu hal yang sangat penting bagi sebuah perusahaan. Ini akan membantu dalam memantau, dan menilai keberhasilan atau kegagalan dari berbagai proses bisnis. Pengukuran performa bisnis dapat dilakukan dengan memperhitungkan beberapa metrik bisnis. Dalam poyek ini akan dilakukan analisis performa bisnis suatu perusahaan eCommerce dengan dengan metrik bisnis yaitu pertumbuhan pelanggan, kualitas produk, dan tipe pembayaran berdasarkan historical data selama tiga tahun.

### **Objective**
Mengumpulkan insight dari analisis dan dengan visualisasi berupa :
1. **Annual Customer Activity Growth**
2. **Annual Product Category Quality**
3. **Annual Payment Type Usage**
<br>

## 📂 **Data Preparation**

Dataset yang digunakan adalah dataset sebuah perusahaan eCommerce Brasil yang memiliki informasi pesanan dengan jumlah 99441 dari tahun 2016 hingga 2018. Terdapat fitur-titur yang membuat informasi seperti status pemesanan, lokasi, rincian item, jenis pembayaran, serta ulasan.

### **Create Database and ERD**
**Langkah-langkah yang dilakukan meliputi:**
1. Membuat workspace database di dalam pgAdmin dan membuat tabel menggunakan `CREATE TABLE` statement
2. Melakukan import data csv kedalam database
3. Menentukan Primary Key atau Foreign Key enggunakan statement `ALTER TABLE`
4. Membuat dan mengeksport ERD (Entity Relationship Diagram) <br>

<details>
  <summary>Click untuk melihat Queries</summary>
  
  ```sql
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
```
</details>
**Hasil ERD :**
<br>
<p align="center">
  <kbd><img src="assets/ERD 1.png" width=800px> </kbd> <br>
  Gambar 1. Entity Relationship Diagram
</p>
<br>
<br>
