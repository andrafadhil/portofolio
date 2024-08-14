-- Berapa total order untuk setiap pelanggan, dikelompokkan berdasarkan customer_id dan nama pelanggan
SELECT fs.customer_id,dc.customer_name, count(*) as total_order
FROM fact_sales fs
INNER JOIN dim_customer dc
ON fs.customer_id = dc.customer_id
GROUP BY fs.customer_id, dc.customer_name
ORDER BY total_order DESC
LIMIT 10 ;

-- Mencari bulan dengan penjualan tertinngi
SELECT MONTHNAME(order_date) AS bulan,
       SUM(totalprice_rupiah) AS total_pendapatan
FROM fact_sales 
GROUP BY MONTHNAME(order_date)
ORDER BY total_pendapatan DESC;

-- Produk mana yang memberikan kontribusi terbesar terhadap pendapatan
SELECT dp.product_name,
	   SUM(fs.totalprice_rupiah) AS total_pendapatan,
       ROW_NUMBER() OVER(ORDER BY SUM(fs.totalprice_rupiah) DESC) as rank_product
FROM dim_product dp
INNER JOIN fact_sales fs ON dp.product_id = fs.product_id
GROUP BY dp.product_name
LIMIT 10;

-- Produk yang paling laris tahun 2019
SELECT dp.product_name,
	   SUM(fs.totalprice_rupiah) AS total_pendapatan
FROM dim_product dp
INNER JOIN fact_sales fs ON dp.product_id = fs.product_id
WHERE YEAR(fs.order_date) = 2019
GROUP BY dp.product_name
ORDER BY total_pendapatan DESC
LIMIT 10;

-- Mencari informasi detail customer yg memiliki pembelian >= 150juta di BeeCycle
SELECT dc.customer_id, dc.customer_name, dc.maritalstatus, dc.gender, total_belanja
FROM dim_customer dc
INNER JOIN (SELECT
        fs.customer_id,
        SUM(fs.totalprice_rupiah) AS total_belanja
    FROM
        fact_sales fs
    GROUP BY
        fs.customer_id
    HAVING
        total_belanja >= 150000000
) AS sub ON dc.customer_id = sub.customer_id
ORDER BY total_belanja DESC;

-- Siapa saja 10 pelanggan dengan total belanja tertinggi
SELECT dc.customer_name,
	   SUM(fs.totalprice_rupiah) AS total_belanja,
	   COUNT(distinct fs.order_detail_id) AS total_order
FROM fact_sales fs
INNER JOIN dim_customer dc
ON fs.customer_id = dc.customer_id
GROUP BY dc.customer_name
ORDER BY total_belanja DESC, total_order;

-- Top 10 product yang paling sering dibeli 
SELECT dp.product_name, dp.model_name, dp.color, dp.sub_category, dp.category,
	   COUNT(distinct fs.order_detail_id) as jumlah_transaksi
FROM dim_product dp
INNER JOIN fact_sales fs ON dp.product_id = fs.product_id
GROUP BY 1,2,3,4,5
ORDER BY jumlah_transaksi DESC
LIMIT 10;

-- Ingin mengetahui kelompok umur yang sering berbelanja di beecycle
WITH customer_age AS (
SELECT customer_id,
	   2023 - YEAR(birthdate) AS umur,
       gender
FROM dim_customer
)
SELECT
  CASE
    WHEN umur BETWEEN 23 AND 35 THEN 'Dewasa Muda'
    WHEN umur BETWEEN 36 AND 56 THEN 'Dewasa Produktif'
	WHEN umur BETWEEN 57 AND 68 THEN 'Pra-Pensiun dan Pensiun'
    ELSE 'Lainnya'
  END AS age_group,
  gender,
  COUNT(DISTINCT fs.order_detail_id) AS jumlah_transaksi
FROM customer_age as ca
JOIN fact_sales AS fs ON ca.customer_id = fs.customer_id
GROUP BY age_group, gender
ORDER BY jumlah_transaksi DESC;

-- Negara mana yang menghasilkan pendapatan tertinggi berdasarkan total penjualan
SELECT distinct dt.country,SUM(fs.totalprice_rupiah) total_pendapatan_country
FROM fact_sales fs
INNER JOIN dim_territory dt ON fs.territory_id = dt.territory_id
GROUP BY 1
ORDER BY total_pendapatan_country DESC;








  
    

