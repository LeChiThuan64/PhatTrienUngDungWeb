-- NORD Computer / ecommerce
-- Import this file in phpMyAdmin (or mysql CLI) after starting MySQL in XAMPP.
-- Charset: utf8mb4

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';
SET time_zone = '+07:00';

CREATE DATABASE IF NOT EXISTS `ecommerce`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `ecommerce`;

DROP TABLE IF EXISTS `coupon_usage`;
DROP TABLE IF EXISTS `wishlist_items`;
DROP TABLE IF EXISTS `wishlists`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `order_items`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_items`;
DROP TABLE IF EXISTS `carts`;
DROP TABLE IF EXISTS `product_images`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `posts`;
DROP TABLE IF EXISTS `post_categories`;
DROP TABLE IF EXISTS `addresses`;
DROP TABLE IF EXISTS `contacts`;
DROP TABLE IF EXISTS `banners`;
DROP TABLE IF EXISTS `coupons`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `brands`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `email` VARCHAR(190) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(30) DEFAULT NULL,
  `role` ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
  `status` ENUM('active', 'inactive', 'banned') NOT NULL DEFAULT 'active',
  `email_verified_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` INT UNSIGNED DEFAULT NULL,
  `name` VARCHAR(120) NOT NULL,
  `slug` VARCHAR(160) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `image` VARCHAR(255) DEFAULT NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_categories_slug` (`slug`),
  KEY `idx_categories_parent` (`parent_id`),
  KEY `idx_categories_active` (`is_active`),
  CONSTRAINT `fk_categories_parent`
    FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `brands` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `slug` VARCHAR(160) NOT NULL,
  `logo` VARCHAR(255) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_brands_slug` (`slug`),
  KEY `idx_brands_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `products` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` INT UNSIGNED NOT NULL,
  `brand_id` INT UNSIGNED DEFAULT NULL,
  `name` VARCHAR(200) NOT NULL,
  `slug` VARCHAR(220) NOT NULL,
  `sku` VARCHAR(64) NOT NULL,
  `short_description` VARCHAR(500) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `price` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `compare_price` DECIMAL(12,2) DEFAULT NULL,
  `cost` DECIMAL(12,2) DEFAULT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  `weight` DECIMAL(8,2) DEFAULT NULL,
  `is_featured` TINYINT(1) NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_products_slug` (`slug`),
  UNIQUE KEY `uq_products_sku` (`sku`),
  KEY `idx_products_category` (`category_id`),
  KEY `idx_products_brand` (`brand_id`),
  KEY `idx_products_featured` (`is_featured`),
  KEY `idx_products_active_price` (`is_active`, `price`),
  CONSTRAINT `fk_products_category`
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_products_brand`
    FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `product_images` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `image_path` VARCHAR(255) NOT NULL,
  `alt_text` VARCHAR(200) DEFAULT NULL,
  `is_primary` TINYINT(1) NOT NULL DEFAULT 0,
  `sort_order` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_images_product` (`product_id`),
  CONSTRAINT `fk_product_images_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `carts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED DEFAULT NULL,
  `session_id` VARCHAR(128) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_carts_user` (`user_id`),
  KEY `idx_carts_session` (`session_id`),
  CONSTRAINT `fk_carts_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cart_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cart_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `quantity` INT UNSIGNED NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_cart_items_cart_product` (`cart_id`, `product_id`),
  KEY `idx_cart_items_product` (`product_id`),
  CONSTRAINT `fk_cart_items_cart`
    FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_items_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `coupons` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(40) NOT NULL,
  `type` ENUM('percent', 'fixed') NOT NULL DEFAULT 'percent',
  `value` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `min_order` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `max_discount` DECIMAL(12,2) DEFAULT NULL,
  `usage_limit` INT UNSIGNED DEFAULT NULL,
  `used_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `starts_at` DATETIME DEFAULT NULL,
  `expires_at` DATETIME DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_coupons_code` (`code`),
  KEY `idx_coupons_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `addresses` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `full_name` VARCHAR(120) NOT NULL,
  `phone` VARCHAR(30) NOT NULL,
  `address_line` VARCHAR(255) NOT NULL,
  `ward` VARCHAR(120) DEFAULT NULL,
  `district` VARCHAR(120) DEFAULT NULL,
  `city` VARCHAR(120) NOT NULL,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_addresses_user` (`user_id`),
  CONSTRAINT `fk_addresses_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `coupon_id` INT UNSIGNED DEFAULT NULL,
  `order_number` VARCHAR(32) NOT NULL,
  `status` ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
  `payment_status` ENUM('unpaid', 'paid', 'failed', 'refunded') NOT NULL DEFAULT 'unpaid',
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `discount` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `shipping_fee` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `total` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `shipping_name` VARCHAR(120) NOT NULL,
  `shipping_phone` VARCHAR(30) NOT NULL,
  `shipping_address` VARCHAR(255) NOT NULL,
  `shipping_city` VARCHAR(120) NOT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_orders_number` (`order_number`),
  KEY `idx_orders_user` (`user_id`),
  KEY `idx_orders_coupon` (`coupon_id`),
  KEY `idx_orders_status` (`status`),
  CONSTRAINT `fk_orders_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_orders_coupon`
    FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `order_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED DEFAULT NULL,
  `product_name` VARCHAR(200) NOT NULL,
  `sku` VARCHAR(64) NOT NULL,
  `quantity` INT UNSIGNED NOT NULL DEFAULT 1,
  `unit_price` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `total` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_items_order` (`order_id`),
  KEY `idx_order_items_product` (`product_id`),
  CONSTRAINT `fk_order_items_order`
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_items_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `payments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `method` VARCHAR(40) NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `status` ENUM('unpaid', 'paid', 'failed', 'refunded') NOT NULL DEFAULT 'unpaid',
  `transaction_id` VARCHAR(120) DEFAULT NULL,
  `paid_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_payments_order` (`order_id`),
  CONSTRAINT `fk_payments_order`
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `reviews` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED DEFAULT NULL,
  `rating` TINYINT UNSIGNED NOT NULL,
  `comment` TEXT DEFAULT NULL,
  `is_approved` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_reviews_product` (`product_id`),
  KEY `idx_reviews_user` (`user_id`),
  KEY `idx_reviews_order` (`order_id`),
  CONSTRAINT `fk_reviews_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_order`
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wishlists` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wishlists_user` (`user_id`),
  CONSTRAINT `fk_wishlists_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wishlist_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `wishlist_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wishlist_items` (`wishlist_id`, `product_id`),
  KEY `idx_wishlist_items_product` (`product_id`),
  CONSTRAINT `fk_wishlist_items_wishlist`
    FOREIGN KEY (`wishlist_id`) REFERENCES `wishlists` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_wishlist_items_product`
    FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `post_categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `slug` VARCHAR(160) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_post_categories_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `post_category_id` INT UNSIGNED DEFAULT NULL,
  `title` VARCHAR(220) NOT NULL,
  `slug` VARCHAR(240) NOT NULL,
  `excerpt` VARCHAR(500) DEFAULT NULL,
  `content` TEXT DEFAULT NULL,
  `thumbnail` VARCHAR(255) DEFAULT NULL,
  `is_published` TINYINT(1) NOT NULL DEFAULT 0,
  `published_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_posts_slug` (`slug`),
  KEY `idx_posts_author` (`user_id`),
  KEY `idx_posts_category` (`post_category_id`),
  KEY `idx_posts_published` (`is_published`, `published_at`),
  CONSTRAINT `fk_posts_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_posts_category`
    FOREIGN KEY (`post_category_id`) REFERENCES `post_categories` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `coupon_usage` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `coupon_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED DEFAULT NULL,
  `used_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_coupon_usage_coupon` (`coupon_id`),
  KEY `idx_coupon_usage_user` (`user_id`),
  KEY `idx_coupon_usage_order` (`order_id`),
  CONSTRAINT `fk_coupon_usage_coupon`
    FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_usage_user`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_usage_order`
    FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `banners` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(160) NOT NULL,
  `image` VARCHAR(255) NOT NULL,
  `link` VARCHAR(255) DEFAULT NULL,
  `position` VARCHAR(40) NOT NULL DEFAULT 'home_hero',
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `starts_at` DATETIME DEFAULT NULL,
  `ends_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_banners_position` (`position`, `is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `contacts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `email` VARCHAR(190) NOT NULL,
  `phone` VARCHAR(30) DEFAULT NULL,
  `subject` VARCHAR(180) DEFAULT NULL,
  `message` TEXT NOT NULL,
  `status` ENUM('new', 'read', 'replied') NOT NULL DEFAULT 'new',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_contacts_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `settings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `setting_key` VARCHAR(80) NOT NULL,
  `setting_value` TEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_settings_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Demo credentials:
-- Admin:    admin@example.com    / Admin@123
-- Customer: customer@example.com / Customer@123
-- Customer: minh@example.com     / Customer@123

INSERT INTO `users` (`name`, `email`, `password`, `phone`, `role`, `status`, `email_verified_at`) VALUES
('NORD Admin', 'admin@example.com',    '$2y$10$2AmGbiHdIjKliTMDIG/feOyXe6Vlj7CHMFXb.oFhobsGiqriu.bTe', '0901000001', 'admin',    'active', NOW()),
('Mai Nguyễn', 'customer@example.com', '$2y$10$N/0a3gqPotzaEZyv5QBH1uWgs7UsFWdi4E9AVtJBPzbasTgksAZge', '0902000002', 'customer', 'active', NOW()),
('Trần Minh',  'minh@example.com',     '$2y$10$N/0a3gqPotzaEZyv5QBH1uWgs7UsFWdi4E9AVtJBPzbasTgksAZge', '0903000003', 'customer', 'active', NOW());

INSERT INTO `categories` (`parent_id`, `name`, `slug`, `description`, `sort_order`, `is_active`) VALUES
(NULL, 'Laptop & Máy tính xách tay', 'laptop-may-tinh-xach-tay', 'Laptop văn phòng, laptop đồ họa chuyên nghiệp và laptop chơi game cấu hình cao.', 1, 1),
(NULL, 'Linh kiện máy tính', 'linh-kien-may-tinh', 'CPU, GPU, RAM, ổ cứng SSD, bo mạch chủ và nguồn máy tính chính hãng.', 2, 1),
(NULL, 'Màn hình máy tính', 'man-hinh-may-tinh', 'Màn hình đồ họa chuẩn màu, màn hình chơi game tần số quét cao, màn hình cong.', 3, 1),
(NULL, 'Bàn phím & Chuột', 'ban-phim-chuot', 'Bàn phím cơ Custom, chuột chơi game siêu nhẹ và chuột công thái học không dây.', 4, 1),
(NULL, 'Tai nghe & Âm thanh', 'tai-nghe-am-thanh', 'Tai nghe chơi game 7.1, tai nghe chống ồn ANC và loa máy tính Bluetooth.', 5, 1),
(NULL, 'Góc Gaming & Công thái học', 'goc-gaming-cong-thai-hoc', 'Ghế công thái học, bàn nâng hạ độ cao, arm màn hình và phụ kiện trang trí góc máy.', 6, 1);

INSERT INTO `brands` (`name`, `slug`, `description`, `is_active`) VALUES
('NORD Studio', 'nord-studio', 'Thương hiệu máy tính lắp ráp & góc làm việc tối giản cao cấp.', 1),
('Lumen Tech', 'lumen-tech', 'Chuyên các dòng màn hình đồ họa và hệ thống chiếu sáng góc máy.', 1),
('Casa Rig', 'casa-rig', 'Vỏ case máy tính, tản nhiệt nước và linh kiện PC bền bỉ.', 1),
('Verde Ergonomics', 'verde-ergonomics', 'Giải pháp nội thất công thái học bảo vệ sức khỏe người dùng.', 1),
('Atelier Gear', 'atelier-gear', 'Bàn phím cơ Custom, keycap PBT và phụ kiện audio chất lượng cao.', 1),
('Apex Gaming', 'apex-gaming', 'Thương hiệu phần cứng hiệu năng cao dành cho game thủ chuyên nghiệp.', 1);

INSERT INTO `products` (`category_id`, `brand_id`, `name`, `slug`, `sku`, `short_description`, `description`, `price`, `compare_price`, `stock`, `is_featured`, `is_active`) VALUES
(1, 1, 'Laptop NORD Oslo Pro 16', 'laptop-nord-oslo-pro-16', 'NORD-LP-001', 'Laptop vỏ nhôm, Intel Core i7-13700H, 16GB RAM, SSD 512GB.', 'Thân máy nhôm nguyên khối siêu mỏng nhẹ, màn hình IPS 2.5K 120Hz sắc nét. Tối ưu hoàn hảo cho công việc lập trình, thiết kế đồ họa và di chuyển hàng ngày.', 18990000.00, 21990000.00, 12, 1, 1),
(1, 6, 'Laptop Gaming Apex Storm 15', 'laptop-gaming-apex-storm-15', 'APEX-LP-002', 'Laptop Gaming AMD Ryzen 7 7840HS, RTX 4060 8GB, 16GB, 1TB SSD.', 'Màn hình 15.6 inch FHD 165Hz, hệ thống tản nhiệt buồng hơi kép tản nhiệt cực mát. Cân mượt mà mọi tựa game AAA hiện nay.', 24990000.00, 27500000.00, 8, 1, 1),
(2, 3, 'PC Gaming Kyoto Ultra Rig', 'pc-gaming-kyoto-ultra-rig', 'CASA-PC-003', 'PC đồng bộ Intel i5 13400F, RTX 4060, RAM 16GB DDR5, SSD 1TB.', 'Cấu hình tối ưu chơi game 2K và livestream. Vỏ case kính cường lực kèm 4 quạt ARGB yên tĩnh.', 15990000.00, 17500000.00, 6, 1, 1),
(2, 3, 'Card màn hình Casa RTX 4070 Super 12GB', 'vga-casa-rtx-4070-super-12gb', 'CASA-VG-004', 'Card đồ họa 3 quạt tản nhiệt, hỗ trợ Ray Tracing & DLSS 3.', 'Xung nhịp tăng cường cao, thiết kế khung kim loại chắc chắn giúp tản nhiệt tối ưu cho các tác vụ dựng phim 4K và chơi game heavy.', 18500000.00, NULL, 15, 0, 1),
(2, 1, 'Ổ cứng SSD NORD Speed V2 1TB NVMe', 'ssd-nord-speed-v2-1tb-nvme', 'NORD-SS-005', 'SSD PCIe 4.0 tốc độ đọc 7300MB/s, ghi 6000MB/s.', 'Tích hợp tản nhiệt nhôm nguyên khối giúp duy trì tốc độ đọc ghi ổn định trong thời gian dài.', 2290000.00, 2590000.00, 45, 0, 1),
(3, 2, 'Màn hình Lumen Arc Curved 27 2K 165Hz', 'man-hinh-lumen-arc-curved-27-2k-165hz', 'LUM-MN-006', 'Màn hình cong 27 inch 2K, tấm nền VA 1500R, 1ms, HDR400.', 'Độ cong 1500R ôm trọn góc nhìn, tần số quét 165Hz siêu mượt cho game bắn súng FPS và xem phim điện ảnh.', 4890000.00, 5290000.00, 20, 1, 1),
(3, 2, 'Màn hình Đồ họa Lumen ColorPro 32 4K', 'man-hinh-do-hoa-lumen-colorpro-32-4k', 'LUM-MN-007', 'Màn hình 32 inch 4K IPS, 99% DCI-P3, hỗ trợ sạc Type-C 90W.', 'Chuyên dụng cho nhà thiết kế đồ họa và dựng phim. Màu sắc chuẩn xác cân sẵn tại nhà máy, chân đế xoay dọc 90 độ.', 12990000.00, NULL, 10, 1, 1),
(4, 5, 'Bàn phím cơ Custom Atelier River 75%', 'ban-phim-co-custom-atelier-river-75', 'ATL-KB-008', 'Bàn phím cơ Hotswap 3 chế độ kết nối, vỏ nhôm CNC, Switch Lube sẵn.', 'Mạch Gasket Mount gõ siêu êm, keycap PBT Dye-sub dày dặn, viên pin 4000mAh dùng đến 2 tuần.', 2890000.00, 3200000.00, 30, 1, 1),
(4, 5, 'Chuột không dây Atelier Spline Pro 4K', 'chuot-khong-day-atelier-spline-pro-4k', 'ATL-MS-009', 'Chuột chơi game siêu nhẹ 49g, Cảm biến PAW3395, 4000Hz Polling Rate.', 'Thiết kế đối xứng vừa vặn tay cầm, switch quang học chống trùng click, đi kèm Receiver 4K không dây.', 1890000.00, NULL, 40, 0, 1),
(5, 5, 'Tai nghe Chống ồn Atelier Wool Fog ANC', 'tai-nghe-chong-on-atelier-wool-fog-anc', 'ATL-HP-010', 'Tai nghe Bluetooth chụp tai, chống ồn chủ động ANC, Pin 50 giờ.', 'Đệm tai bọc vải thoáng khí không bị nóng tai. Chuẩn âm thanh Hi-Res Audio mang lại chất âm chi tiết, ấm áp.', 1690000.00, 1990000.00, 25, 1, 1),
(5, 6, 'Tai nghe Gaming Apex Sound 7.1', 'tai-nghe-gaming-apex-sound-71', 'APEX-HP-011', 'Tai nghe chơi game âm thanh vòm 7.1, Micro khử ồn AI, LED RGB.', 'Giúp định vị tiếng chân chính xác trong game FPS. Đệm tai da PU cao cấp cách âm tuyệt đối.', 990000.00, NULL, 35, 0, 1),
(6, 4, 'Ghế Công thái học Verde Ergonomic Pro', 'ghe-cong-thai-hoc-verde-ergonomic-pro', 'VERD-CH-012', 'Ghế lưới toàn bộ thoáng khí, tựa lưng đôi đỡ thắt lưng linh hoạt.', 'Piston Class 4 an toàn, kê tay 4D điều chỉnh đa hướng, tựa đầu 3D bảo vệ đốt sống cổ tối đa.', 5490000.00, 6200000.00, 15, 1, 1),
(6, 4, 'Bàn Nâng Hạ Độ Cao Verde SmartDesk 1m4', 'ban-nang-ha-do-cao-verde-smartdesk-1m4', 'VERD-TB-013', 'Bàn nâng hạ động cơ đôi, mặt gỗ sồi 1m4 x 0.7m, nhớ 4 vị trí.', 'Động cơ nâng hạ êm ái tải trọng 100kg. Mặt bàn xử lý chống ẩm tích hợp khay giấu dây thông minh.', 6890000.00, 7500000.00, 10, 1, 1),
(3, 2, 'Đèn treo màn hình Lumen Paper Bar 45', 'den-treo-man-hinh-lumen-paper-bar-45', 'LUM-LP-014', 'Đèn treo màn hình bảo vệ mắt, điều khiển cảm ứng không dây.', 'Góc chiếu chuẩn chống chói màn hình, tùy chỉnh nhiệt độ màu từ 2700K - 6500K cho ngày và đêm.', 1290000.00, NULL, 50, 0, 1),
(6, 1, 'Vỏ case máy tính NORD Line Media Walnut', 'vo-case-may-tinh-nord-line-media-walnut', 'NORD-CS-015', 'Case PC mỏng nhẹ kết hợp gỗ óc chó thật, hỗ trợ tản nước 360mm.', 'Thiết kế góc máy phong cách Scandinavian tối giản, mặt trước trang trí thanh gỗ tự nhiên sang trọng.', 3290000.00, 3690000.00, 18, 0, 1);

INSERT INTO `product_images` (`product_id`, `image_path`, `alt_text`, `is_primary`, `sort_order`) VALUES
(1, 'products/laptop-nord-oslo-pro-16.jpg', 'Laptop NORD Oslo Pro 16 mặt trước', 1, 1),
(2, 'products/laptop-gaming-apex-storm-15.jpg', 'Laptop Gaming Apex Storm 15 góc nghiêng', 1, 1),
(3, 'products/pc-gaming-kyoto-ultra-rig.jpg', 'PC Gaming Kyoto Ultra Rig kèm đèn RGB', 1, 1),
(4, 'products/vga-casa-rtx-4070-super-12gb.jpg', 'Card màn hình Casa RTX 4070 Super', 1, 1),
(5, 'products/ssd-nord-speed-v2-1tb-nvme.jpg', 'Ổ cứng SSD NORD Speed V2', 1, 1),
(6, 'products/man-hinh-lumen-arc-curved-27.jpg', 'Màn hình Lumen Arc Curved 27 inch', 1, 1),
(7, 'products/man-hinh-lumen-colorpro-32.jpg', 'Màn hình Đồ họa Lumen ColorPro 32 inch 4K', 1, 1),
(8, 'products/ban-phim-co-atelier-river-75.jpg', 'Bàn phím cơ Custom Atelier River 75%', 1, 1),
(9, 'products/chuot-atelier-spline-pro-4k.jpg', 'Chuột không dây Atelier Spline Pro 4K', 1, 1),
(10, 'products/tai-nghe-atelier-wool-fog-anc.jpg', 'Tai nghe Chống ồn Atelier Wool Fog ANC', 1, 1),
(11, 'products/tai-nghe-gaming-apex-sound-71.jpg', 'Tai nghe Gaming Apex Sound 7.1', 1, 1),
(12, 'products/ghe-verde-ergonomic-pro.jpg', 'Ghế Công thái học Verde Ergonomic Pro', 1, 1),
(13, 'products/ban-nang-ha-verde-smartdesk-1m4.jpg', 'Bàn Nâng Hạ Độ Cao Verde SmartDesk', 1, 1),
(14, 'products/den-treo-man-hinh-lumen-paper-bar.jpg', 'Đèn treo màn hình Lumen Paper Bar 45', 1, 1),
(15, 'products/vo-case-nord-line-media-walnut.jpg', 'Vỏ case máy tính NORD Line Media Walnut', 1, 1);

INSERT INTO `coupons` (`code`, `type`, `value`, `min_order`, `max_discount`, `usage_limit`, `used_count`, `starts_at`, `expires_at`, `is_active`) VALUES
('XINCHAO10', 'percent', 10.00, 1000000.00, 500000.00, 200, 12, NOW(), DATE_ADD(NOW(), INTERVAL 90 DAY), 1),
('NORD500K', 'fixed', 500000.00, 5000000.00, NULL, 50, 5, NOW(), DATE_ADD(NOW(), INTERVAL 60 DAY), 1),
('GAMING15', 'percent', 15.00, 2000000.00, 800000.00, 80, 20, NOW(), DATE_ADD(NOW(), INTERVAL 45 DAY), 1),
('FREESHIP', 'fixed', 100000.00, 1000000.00, NULL, 500, 89, NOW(), DATE_ADD(NOW(), INTERVAL 120 DAY), 1);

INSERT INTO `banners` (`title`, `image`, `link`, `position`, `sort_order`, `is_active`) VALUES
('Đỉnh Cao Công Nghệ - Nâng Tầm Góc Máy 2026', 'banners/hero-computer-main.jpg', '/products.php?featured=1', 'home_hero', 1, 1),
('Màn Hình Đồ Họa 4K & Chiếu Sáng Chuẩn Màu', 'banners/hero-lumen-monitors.jpg', '/category.php?slug=man-hinh-may-tinh', 'home_hero', 2, 1),
('Ưu Đãi Laptop Gaming & Ghế Công Thái Học', 'banners/promo-gaming-desk.jpg', '/category.php?slug=goc-gaming-cong-thai-hoc', 'home_promo', 1, 1);

INSERT INTO `post_categories` (`name`, `slug`) VALUES
('Nhật ký Công nghệ', 'nhat-ky-cong-nghe'),
('Tư vấn Phần cứng', 'tu-van-phan-cung'),
('Hướng dẫn Setup Góc Máy', 'huong-dan-setup-goc-may');

INSERT INTO `posts` (`user_id`, `post_category_id`, `title`, `slug`, `excerpt`, `content`, `thumbnail`, `is_published`, `published_at`) VALUES
(1, 3, 'Cách Setup Góc Máy Tối Giản Cho Coder Và Designer', 'cach-setup-goc-may-toi-gian-cho-coder-va-designer', 'Một không gian làm việc gọn gàng sẽ tăng 200% khả năng tập trung. Hướng dẫn chi tiết cách giấu dây và phối màu.', 'Góc làm việc hiện đại không chỉ cần máy tính mạnh mà còn cần sự gọn gàng. Sử dụng bàn nâng hạ kết hợp arm màn hình kẹp bàn giúp giải phóng tối đa diện tích mặt bàn...', 'posts/setup-goc-may.jpg', 1, NOW()),
(1, 2, 'Top 5 Linh Kiện Cần Ưu Tiên Khi Build PC Năm 2026', 'top-5-linh-kien-can-uu-tien-khi-build-pc-2026', 'Nên đầu tư nhiều tiền vào CPU hay GPU? Chọn SSD chuẩn NVMe Gen 4 hay Gen 5?', 'Khi ngân sách có hạn, việc phân bổ ngân sách cho từng linh kiện quyết định hiệu năng tổng thể của dàn PC. Bài viết này phân tích chi tiết nên chọn RAM 16GB hay 32GB...', 'posts/build-pc-guide.jpg', 1, NOW()),
(1, 1, 'Trải Nghiệm Bàn Phím Cơ Custom: Tại Sao Lại Gây Nghiện?', 'trai-nghiem-ban-phim-co-custom-tai-sao-lai-gay-nghien', 'Âm thanh gõ phím êm ái, cảm xúc gõ khác biệt hoàn toàn so với bàn phím thông thường.', 'Bàn phím cơ Custom không chỉ là công cụ nhập liệu mà còn là thú chơi cá tính. Từ việc chọn Switch bôi trơn dầu lube, đến việc lót foam tiêu âm...', 'posts/custom-keyboard.jpg', 1, NOW());

INSERT INTO `addresses` (`user_id`, `full_name`, `phone`, `address_line`, `ward`, `district`, `city`, `is_default`) VALUES
(2, 'Mai Nguyễn', '0902000002', '12 Nguyễn Huệ', 'Phường Bến Nghé', 'Quận 1', 'Thành phố Hồ Chí Minh', 1),
(3, 'Trần Minh', '0903000003', '456 Lê Văn Việt', 'Phường Tăng Nhơn Phú A', 'TP. Thủ Đức', 'Thành phố Hồ Chí Minh', 1);

INSERT INTO `wishlists` (`user_id`) VALUES (2);

INSERT INTO `wishlist_items` (`wishlist_id`, `product_id`) VALUES (1, 1), (1, 6);

INSERT INTO `reviews` (`product_id`, `user_id`, `order_id`, `rating`, `comment`, `is_approved`) VALUES
(1, 2, NULL, 5, 'Laptop NORD Oslo Pro chạy siêu mượt, màn hình đẹp tuyệt vời, mở 20 tab Chrome không lag!', 1),
(8, 3, NULL, 5, 'Bàn phím Atelier River 75% gõ âm cực đầm và mượt. Khuyên anh em nên mua bản mạch Gasket này.', 1),
(12, 2, NULL, 4, 'Ghế ngồi rất đỡ lưng, đỡ mỏi cổ hẳn khi ngồi code liên tục 8 tiếng. Giao hàng nhanh.', 1);

INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('store_name', 'NORD Computer - Máy Tính & Hi-Tech'),
('store_email', 'support@nordcomputer.local'),
('store_phone', '0901000001'),
('store_address', 'Quận 1, Thành phố Hồ Chí Minh'),
('currency', 'VND'),
('free_shipping_min', '2000000');