-- Mencari avarage transaksi berdasarkan bulan urutkan dari paling besar
SELECT MONTH(transaction_date) AS month, 
	   avg(transaction_qty) as avg_transaksi
FROM coffe 
GROUP BY MONTH(transaction_date)
ORDER BY avg_transaksi DESC;

-- Mencari total penjuaalan di setiap lokasi
SELECT store_location, SUM(transaction_qty * unit_price) as total_penjualan
FROM coffe 
GROUP BY store_location 
ORDER BY total_penjualan;

-- Mencari harga rata rata di berbagai lokasi
SELECT store_location, avg(unit_price) as avg_harga_lokasi
FROM coffe 
GROUP BY store_location 
ORDER BY avg_harga_lokasi DESC;

-- Di hari apa penjualan kopi paling tinggi
SELECT DAYNAME(transaction_date) as hari,
	   COUNT(*) as jumlah_order
FROM coffe 
GROUP BY hari
ORDER BY jumlah_order DESC ;

-- Product category yang paling sering terjual urutkan dari yang terbesar 
SELECT product_category, count(*) as top_product
FROM coffe
GROUP BY product_category
ORDER BY top_product desc;

-- Mencari tipe produk paling laris disetiap cabang 
WITH rank_sales AS (
    SELECT 
        store_location, 
        product_type, 
        SUM(transaction_qty) AS total_sales,
        RANK() OVER (PARTITION BY store_location ORDER BY SUM(transaction_qty) DESC) AS sales_rank
    FROM coffe 
    GROUP BY store_location, product_type   
)
SELECT * FROM rank_sales
WHERE sales_rank = 1;









