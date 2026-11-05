-- 06_profitability_analysis.sql
-- Tujuan : analisis diskon, margin & item rugi (halaman 3 dashboard)

-- 1) Margin & porsi item rugi per band diskon
--    Temuan: diskon tidak menggerus margin (~11-13%)
SELECT
  CASE
    WHEN discount_rate = 0    THEN '1) 0%'
    WHEN discount_rate < 0.05 THEN '2) <5%'
    WHEN discount_rate < 0.10 THEN '3) 5-10%'
    WHEN discount_rate < 0.15 THEN '4) 10-15%'
    WHEN discount_rate < 0.20 THEN '5) 15-20%'
    ELSE '6) 20%+'
  END                                      AS discount_band,
  COUNT(*)                                 AS jumlah_item,
  ROUND(SUM(profit) / SUM(net_sales), 4)   AS profit_margin,
  ROUND(AVG(IF(profit < 0, 1, 0)), 4)      AS loss_item_rate
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale
GROUP BY discount_band
ORDER BY discount_band;

-- 2) Kebocoran profit: total laba positif vs total rugi
--    Harapan: positif 6,991,339 | rugi -3,461,393 | net 3,529,946 | rasio 0.495
SELECT
  ROUND(SUM(IF(profit > 0, profit, 0)), 0)                      AS laba_positif,
  ROUND(SUM(IF(profit < 0, profit, 0)), 0)                      AS total_rugi,
  ROUND(SUM(profit), 0)                                         AS net_profit,
  ROUND(-SUM(IF(profit < 0, profit, 0)) / SUM(IF(profit > 0, profit, 0)), 3) AS rasio_rugi_vs_laba
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale;

-- 3) Margin & loss rate per kategori (sebagian kategori kecil tidak stabil antar kuartal)
SELECT
  category_name,
  ROUND(SUM(net_sales), 0)                 AS net_sales,
  ROUND(SUM(profit) / SUM(net_sales), 4)   AS profit_margin,
  ROUND(AVG(IF(profit < 0, 1, 0)), 4)      AS loss_item_rate
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale
GROUP BY category_name
ORDER BY net_sales DESC;
