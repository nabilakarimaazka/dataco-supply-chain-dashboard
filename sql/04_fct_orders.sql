-- Filter : order_date Jan 2015 - Sep 2017 (data setelahnya anomali)
CREATE OR REPLACE TABLE dataco-supply-chain-513701.mart.fct_orders
CLUSTER BY market, category_name
AS 
SELECT 
  -- ID
  s.order_id,
  s.order_item_id,
  s.customer_id,
  s.product_id,

  -- Waktu
  s.order_date,
  s.shipping_date,

  -- Pengiriman
  s.shipping_mode,
  s.delivery_status,
  s.ship_days_actual,
  s.ship_days_scheduled,
  s.ship_delay_days,
  s.is_late,

  -- Status
  s.payment_type,
  s.order_status,
  s.order_status NOT IN ('CANCELED', 'SUSPECTED_FRAUD') AS is_valid_sale,

  -- Customer & Lokasi
  s.customer_segment,
  s.market,
  s.order_region,
  COALESCE(m.country_en, s.order_country) AS order_country,
  m.country_iso2                          AS order_country_iso2,
  s.order_state,
  s.order_city,

  -- Produk
  s.department_name,
  s.category_name,
  s.product_name,
  ROUND(s.product_price, 2)   AS product_price,

  -- Angka
  s.quantity,
  ROUND(s.gross_sales, 2)     AS gross_sales,
  ROUND(s.discount_amount, 2) AS discount_amount,
  ROUND(s.discount_rate, 4)   AS discount_rate,
  ROUND(s.net_sales, 2)       AS net_sales,
  ROUND(s.profit, 2)          AS profit,
  ROUND(s.profit_ratio, 4)    AS profit_ratio
FROM dataco-supply-chain-513701.staging.stg_orders s
LEFT JOIN dataco-supply-chain-513701.raw.country_mapping m
  ON s.order_country = m.country_es
WHERE s.order_date BETWEEN '2015-01-01' AND '2017-09-30';


SELECT
  MIN(order_date) AS tgl_awal,
  MAX(order_date) AS tgl_akhir,
  COUNT(*) AS jumlah_baris,
  COUNTIF(is_valid_sale) AS baris_valid,
  COUNTIF(order_country_iso2 IS NULL) AS iso_kosong
FROM dataco-supply-chain-513701.mart.fct_orders;
