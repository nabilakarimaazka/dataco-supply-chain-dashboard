SELECT *
FROM dataco-supply-chain-513701.staging.stg_orders
LIMIT 10;

-- A. Rentang tanggal & jumlah baris
SELECT
  MIN(order_date) AS tgl_awal,
  MAX(order_date) AS tgl_akhir,
  COUNT(*) AS jumlah_baris,
  COUNT(DISTINCT order_id) AS jumlah_order,
  COUNT(DISTINCT order_item_id) AS jumlah_item_unik
FROM dataco-supply-chain-513701.staging.stg_orders;

-- B. Distribusi status order
SELECT order_status, COUNT(*) AS jumlah
FROM dataco-supply-chain-513701.staging.stg_orders
GROUP BY order_status
ORDER BY jumlah DESC;

-- C. Daftar negara order (untuk diterjemahkan)
SELECT order_country, COUNT(*) AS jumlah
FROM dataco-supply-chain-513701.staging.stg_orders
GROUP BY order_country
ORDER BY jumlah DESC;

-- D. Tren order & sales per bulan
SELECT 
  DATE_TRUNC(order_date, MONTH) AS bulan,
  COUNT(DISTINCT order_id) AS jumlah_order,
  ROUND(SUM(net_sales), 0) AS net_sales
FROM dataco-supply-chain-513701.staging.stg_orders
GROUP BY bulan
ORDER BY bulan;
