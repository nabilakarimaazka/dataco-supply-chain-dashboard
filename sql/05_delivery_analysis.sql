-- =====================================================
-- 05_delivery_analysis.sql
-- Tujuan : analisis ketepatan pengiriman (halaman 2 dashboard)
-- Sumber : mart.fct_orders (hanya order valid)
-- =====================================================

-- 1) Late rate per shipping mode x janji x realisasi hari
--    Temuan: First Class selalu 2 hari vs janji 1 hari (100% telat),
--            Second Class 2-6 hari vs janji 2 hari (~80% telat),
--            Standard 2-6 hari vs janji 4 hari (~40% telat).
SELECT
  shipping_mode,
  ship_days_scheduled,
  ship_days_actual,
  COUNT(*)                 AS jumlah_item,
  ROUND(AVG(is_late), 4)   AS late_rate
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale
GROUP BY shipping_mode, ship_days_scheduled, ship_days_actual
ORDER BY shipping_mode, ship_days_scheduled, ship_days_actual;

-- 2) What-if: janji First Class 1 -> 2 hari, Second Class 2 -> 4 hari
--    Harapan: late_rate_aktual = 0.5728, late_rate_whatif = 0.3410
SELECT
  ROUND(AVG(is_late), 4) AS late_rate_aktual,
  ROUND(AVG(IF(
    ship_days_actual > GREATEST(
      ship_days_scheduled,
      CASE shipping_mode WHEN 'First Class' THEN 2
                         WHEN 'Second Class' THEN 4
                         ELSE 0 END),
    1, 0)), 4)           AS late_rate_whatif
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale;

-- 3) Stabilitas late rate per kuartal (rata ~55-57%, tidak ada tren)
SELECT
  DATE_TRUNC(order_date, QUARTER) AS kuartal,
  ROUND(AVG(is_late), 4)          AS late_rate
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale
GROUP BY kuartal
ORDER BY kuartal;

-- 4) Late rate per negara (>= 50 order) -> selisih antar negara = noise sampel kecil
SELECT
  order_country,
  COUNT(DISTINCT order_id) AS jumlah_order,
  ROUND(AVG(is_late), 4)   AS late_rate
FROM `dataco-supply-chain-513701.mart.fct_orders`
WHERE is_valid_sale
GROUP BY order_country
HAVING COUNT(DISTINCT order_id) >= 50
ORDER BY jumlah_order DESC;
