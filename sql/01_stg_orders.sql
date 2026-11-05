CREATE OR REPLACE VIEW `dataco-supply-chain-513701.staging.stg_orders` AS
SELECT
  -- ID
  `Order Id`                         AS order_id,
  `Order Item Id`                    AS order_item_id,
  `Customer Id`                      AS customer_id,
  `Product Card Id`                  AS product_id,
  `Category Id`                      AS category_id,
  `Department Id`                    AS department_id,

  -- Waktu
  `order date _DateOrders_`          AS order_ts,
  DATE(`order date _DateOrders_`)    AS order_date,
  `shipping date _DateOrders_`       AS shipping_ts,
  DATE(`shipping date _DateOrders_`) AS shipping_date,

  -- Pengiriman
  `Shipping Mode`                    AS shipping_mode,
  `Delivery Status`                  AS delivery_status,
  `Days for shipping _real_`         AS ship_days_actual,
  `Days for shipment _scheduled_`    AS ship_days_scheduled,
  `Days for shipping _real_` - `Days for shipment _scheduled_` AS ship_delay_days,
  `Late_delivery_risk`               AS is_late,

  -- Order & pembayaran
  `Type`                             AS payment_type,
  `Order Status`                     AS order_status,

  -- Customer
  `Customer Segment`                 AS customer_segment,
  `Customer City`                    AS customer_city,
  `Customer State`                   AS customer_state,
  `Customer Country`                 AS customer_country,

  -- Lokasi order / pasar
  `Market`                           AS market,
  `Order Region`                     AS order_region,
  `Order Country`                    AS order_country,
  `Order State`                      AS order_state,
  `Order City`                       AS order_city,
  `Latitude`                         AS store_latitude,
  `Longitude`                        AS store_longitude,

  -- Produk
  `Department Name`                  AS department_name,
  `Category Name`                    AS category_name,
  `Product Name`                     AS product_name,
  `Product Price`                    AS product_price,

  -- Angka penjualan
  `Order Item Quantity`              AS quantity,
  `Sales`                            AS gross_sales,
  `Order Item Discount`              AS discount_amount,
  `Order Item Discount Rate`         AS discount_rate,
  `Order Item Total`                 AS net_sales,
  `Order Profit Per Order`           AS profit,
  `Order Item Profit Ratio`          AS profit_ratio
FROM `dataco-supply-chain-513701.raw.dataco_orders`;