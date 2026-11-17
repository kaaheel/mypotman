-- POTMAN Production MySQL Database Schema & Seed Data
-- Compatible with MySQL 5.7, 8.0, 8.4, and MariaDB 10.3+
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

-- --------------------------------------------------------
-- Table: users
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: password_reset_tokens
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: sessions
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: cache
DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: cache_locks
DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: jobs
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: job_batches
DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: failed_jobs
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: customers
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `saved_address` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `saved_city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `saved_state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_orders` int(11) NOT NULL DEFAULT 0,
  `total_spent` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customers_phone_index` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: products
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtitle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_price` decimal(12,2) NOT NULL,
  `tag` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` decimal(3,1) NOT NULL DEFAULT 4.9,
  `review_count` int(11) NOT NULL DEFAULT 25,
  `categories` json DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gallery_images` json DEFAULT NULL,
  `finishes` json DEFAULT NULL,
  `sizes` json DEFAULT NULL,
  `drainage_options` json DEFAULT NULL,
  `specs` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: inventory_skus
DROP TABLE IF EXISTS `inventory_skus`;
CREATE TABLE `inventory_skus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `product_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finish` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `drainage` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 15,
  `reserved_quantity` int(11) NOT NULL DEFAULT 0,
  `low_stock_threshold` int(11) NOT NULL DEFAULT 3,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventory_skus_product_id_index` (`product_id`),
  CONSTRAINT `inventory_skus_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: coupons
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "fixed",
  `value` decimal(12,2) NOT NULL,
  `min_spend` decimal(12,2) NOT NULL DEFAULT 0.00,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `expires_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: orders
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `idempotency_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL UNIQUE,
  `customer_id` bigint(20) unsigned DEFAULT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipping_address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipping_city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipping_state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipping_notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_zone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "Zone 1 (Lagos)",
  `tracking_waybill` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `shipping_fee` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL,
  `payment_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "paid",
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "paystack",
  `payment_reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fulfillment_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "packing",
  `lock_version` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_customer_id_foreign` (`customer_id`),
  KEY `orders_customer_email_index` (`customer_email`),
  KEY `orders_tracking_waybill_index` (`tracking_waybill`),
  CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: order_items
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `product_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finish` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "Sand",
  `drainage` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "Indoor (Sealed base)",
  `size` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "Standard",
  `unit_price` decimal(12,2) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `total_price` decimal(12,2) NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: transactions
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `gateway` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "paystack",
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "NGN",
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT "pending",
  `gateway_response` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_order_id_foreign` (`order_id`),
  CONSTRAINT `transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: order_status_logs
DROP TABLE IF EXISTS `order_status_logs`;
CREATE TABLE `order_status_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `from_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_status_logs_order_id_foreign` (`order_id`),
  CONSTRAINT `order_status_logs_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `migrations` (`migration`, `batch`) VALUES
("0001_01_01_000000_create_users_table", 1),
("0001_01_01_000001_create_cache_table", 1),
("0001_01_01_000002_create_jobs_table", 1),
("2026_11_15_000001_create_orders_and_order_items_tables", 1),
("2026_11_15_000002_create_commerce_engines_tables", 1);

-- --------------------------------------------------------
-- Seed Data: products
INSERT INTO `products` (`id`, `slug`, `name`, `subtitle`, `description`, `base_price`, `tag`, `rating`, `review_count`, `categories`, `image_url`, `gallery_images`, `finishes`, `sizes`, `drainage_options`, `specs`, `is_active`, `created_at`, `updated_at`) VALUES ('kano-bowl', 'kano-bowl', 'Kano Bowl', 'Low-profile travertine stone composite', 'A wide, low-profile bowl planter cast in lightweight stone composite. Designed to anchor lush greenery cleanly on wood, marble, or tiled floors.', '42000', 'Bestseller', '4.9', '38', '["indoor","statement"]', '/images/products/kano-bowl-studio.jpg', '["\/images\/products\/kano-bowl-studio.jpg","\/images\/craft\/mineral-macro-studio.jpg","\/images\/lifestyle\/space-residence.jpg","\/images\/craft\/crated-packaging-studio.jpg"]', '[{"name":"Sand","hex":"#C8B9A4","label":"Warm Travertine Stone"},{"name":"Ink","hex":"#20231F","label":"Volcanic Basalt Black"},{"name":"Sage","hex":"#879080","label":"Muted Botanical Patina"},{"name":"Clay","hex":"#B8755D","label":"Rich Terracotta Earth"}]', '[{"name":"Standard (45cm Dia \u00d7 28cm H)","additionalCost":0},{"name":"Grande (55cm Dia \u00d7 34cm H)","additionalCost":14000}]', '["Indoor (Sealed base)","Outdoor (Drainage hole)"]', '[{"label":"Material","value":"Resin-free crushed limestone composite"},{"label":"Dimensions","value":"45 cm diameter \u00d7 28 cm height"},{"label":"Weight","value":"6.2 kg (50% lighter than solid poured concrete)"},{"label":"Origin","value":"Made in Nigeria"},{"label":"Warranty","value":"3-year structural guarantee"}]', '1', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `products` (`id`, `slug`, `name`, `subtitle`, `description`, `base_price`, `tag`, `rating`, `review_count`, `categories`, `image_url`, `gallery_images`, `finishes`, `sizes`, `drainage_options`, `specs`, `is_active`, `created_at`, `updated_at`) VALUES ('zuma-tall', 'zuma-tall', 'Zuma Tall', 'Sculptural volcanic basalt hourglass', 'A tall hourglass planter proportioned for fiddle leaf figs, olive trees, and statement corners in living rooms, entryways, and patios.', '58000', 'Icon', '5', '29', '["statement","indoor","outdoor"]', '/images/products/zuma-tall-studio.jpg', '["\/images\/products\/zuma-tall-studio.jpg","\/images\/craft\/mineral-macro-studio.jpg","\/images\/lifestyle\/space-hospitality.jpg","\/images\/craft\/crated-packaging-studio.jpg"]', '[{"name":"Ink","hex":"#20231F","label":"Volcanic Basalt Black"},{"name":"Sand","hex":"#C8B9A4","label":"Warm Travertine Stone"},{"name":"Sage","hex":"#879080","label":"Muted Botanical Patina"},{"name":"Clay","hex":"#B8755D","label":"Rich Terracotta Earth"}]', '[{"name":"Standard (36cm Dia \u00d7 82cm H)","additionalCost":0},{"name":"Monumental (42cm Dia \u00d7 100cm H)","additionalCost":20000}]', '["Indoor (Sealed base)","Outdoor (Drainage hole)"]', '[{"label":"Material","value":"Resin-free crushed limestone composite"},{"label":"Dimensions","value":"36 cm diameter \u00d7 82 cm height"},{"label":"Weight","value":"9.8 kg"},{"label":"Origin","value":"Made in Nigeria"},{"label":"Warranty","value":"3-year structural guarantee"}]', '1', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `products` (`id`, `slug`, `name`, `subtitle`, `description`, `base_price`, `tag`, `rating`, `review_count`, `categories`, `image_url`, `gallery_images`, `finishes`, `sizes`, `drainage_options`, `specs`, `is_active`, `created_at`, `updated_at`) VALUES ('oko-statement', 'oko-statement', 'Oko Statement', '32-rib fluted earthen clay cylinder', 'A wide fluted cylinder with 32 clean vertical ribs. Cast in weatherproof stone composite for patios, verandas, and open interiors.', '76000', 'New Release', '4.9', '22', '["outdoor","statement"]', '/images/products/oko-statement-studio.jpg', '["\/images\/products\/oko-statement-studio.jpg","\/images\/craft\/mineral-macro-studio.jpg","\/images\/lifestyle\/space-courtyard.jpg","\/images\/craft\/crated-packaging-studio.jpg"]', '[{"name":"Clay","hex":"#B8755D","label":"Rich Terracotta Earth"},{"name":"Sand","hex":"#C8B9A4","label":"Warm Travertine Stone"},{"name":"Ink","hex":"#20231F","label":"Volcanic Basalt Black"},{"name":"Sage","hex":"#879080","label":"Muted Botanical Patina"}]', '[{"name":"Standard (48cm Dia \u00d7 65cm H)","additionalCost":0},{"name":"Colossus (56cm Dia \u00d7 78cm H)","additionalCost":24000}]', '["Indoor (Sealed base)","Outdoor (Drainage hole)"]', '[{"label":"Material","value":"Resin-free mineral stone with natural oxides"},{"label":"Dimensions","value":"48 cm diameter \u00d7 65 cm height"},{"label":"Weight","value":"11.4 kg"},{"label":"Origin","value":"Made in Nigeria"},{"label":"Warranty","value":"3-year structural guarantee"}]', '1', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `products` (`id`, `slug`, `name`, `subtitle`, `description`, `base_price`, `tag`, `rating`, `review_count`, `categories`, `image_url`, `gallery_images`, `finishes`, `sizes`, `drainage_options`, `specs`, `is_active`, `created_at`, `updated_at`) VALUES ('mineral-care-wax', 'mineral-care-wax', 'Organic Mineral Sealant Wax', '100ml stone sealer & patina balm', 'Specially blended natural beeswax and mineral oils formulated to protect and nourish raw composite limestone vessels.', '6500', 'Care Essential', '4.9', '45', '["accessory","care"]', '/images/craft/mineral-macro-studio.jpg', '["\/images\/craft\/mineral-macro-studio.jpg"]', '[{"name":"Natural","hex":"#EAE6DF","label":"Clear Matte"}]', '[{"name":"Standard (100ml)","additionalCost":0}]', '["Not Applicable"]', '[{"label":"Volume","value":"100 ml tin"},{"label":"Application","value":"2-3 applications per year"}]', '1', '2026-11-15 16:23:36', '2026-11-15 16:23:36');

-- Seed Data: inventory_skus
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('1', 'KA-SAN-STA', 'kano-bowl', 'Sand', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('2', 'KA-SAN-GRA', 'kano-bowl', 'Sand', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('3', 'KA-INK-STA', 'kano-bowl', 'Ink', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('4', 'KA-INK-GRA', 'kano-bowl', 'Ink', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('5', 'KA-SAG-STA', 'kano-bowl', 'Sage', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('6', 'KA-SAG-GRA', 'kano-bowl', 'Sage', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('7', 'KA-CLA-STA', 'kano-bowl', 'Clay', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('8', 'KA-CLA-GRA', 'kano-bowl', 'Clay', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('9', 'ZU-SAN-STA', 'zuma-tall', 'Sand', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('10', 'ZU-SAN-GRA', 'zuma-tall', 'Sand', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('11', 'ZU-INK-STA', 'zuma-tall', 'Ink', 'Standard', 'Indoor (Sealed base)', '14', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:26:55');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('12', 'ZU-INK-GRA', 'zuma-tall', 'Ink', 'Grande', 'Indoor (Sealed base)', '14', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:26:55');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('13', 'ZU-SAG-STA', 'zuma-tall', 'Sage', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('14', 'ZU-SAG-GRA', 'zuma-tall', 'Sage', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('15', 'ZU-CLA-STA', 'zuma-tall', 'Clay', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('16', 'ZU-CLA-GRA', 'zuma-tall', 'Clay', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('17', 'OK-SAN-STA', 'oko-statement', 'Sand', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('18', 'OK-SAN-GRA', 'oko-statement', 'Sand', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('19', 'OK-INK-STA', 'oko-statement', 'Ink', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('20', 'OK-INK-GRA', 'oko-statement', 'Ink', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('21', 'OK-SAG-STA', 'oko-statement', 'Sage', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('22', 'OK-SAG-GRA', 'oko-statement', 'Sage', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('23', 'OK-CLA-STA', 'oko-statement', 'Clay', 'Standard', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('24', 'OK-CLA-GRA', 'oko-statement', 'Clay', 'Grande', 'Indoor (Sealed base)', '15', '0', '3', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `inventory_skus` (`id`, `sku`, `product_id`, `finish`, `size`, `drainage`, `stock_quantity`, `reserved_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES ('25', 'WAX-100ML', 'mineral-care-wax', 'Natural', 'Standard (100ml)', 'Not Applicable', '50', '0', '10', '2026-11-15 16:23:36', '2026-11-15 16:23:36');

-- Seed Data: coupons
INSERT INTO `coupons` (`id`, `code`, `type`, `value`, `min_spend`, `usage_limit`, `used_count`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES ('1', 'POTMAN10', 'percent', '10', '30000', '500', '15', '2027-05-15 16:23:36', '1', '2026-11-15 16:23:36', '2026-11-15 16:26:55');
INSERT INTO `coupons` (`id`, `code`, `type`, `value`, `min_spend`, `usage_limit`, `used_count`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES ('2', 'WELCOME5K', 'fixed', '5000', '40000', '200', '8', '2027-02-15 16:23:36', '1', '2026-11-15 16:23:36', '2026-11-15 16:23:36');
INSERT INTO `coupons` (`id`, `code`, `type`, `value`, `min_spend`, `usage_limit`, `used_count`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES ('3', 'STUDIO20', 'percent', '20', '150000', '50', '2', '2027-01-15 16:23:36', '1', '2026-11-15 16:23:36', '2026-11-15 16:23:36');

SET FOREIGN_KEY_CHECKS=1;
