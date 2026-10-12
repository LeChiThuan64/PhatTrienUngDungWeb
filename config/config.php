<?php
/**
 * Application configuration.
 * Change these values when deploying from localhost to a real server.
 */

declare(strict_types=1);


define('APP_NAME', 'NORD Home');
define('APP_TAGLINE', 'Phong cách sống hiện đại, tinh tế và tiện nghi');
define('APP_ENV', 'development'); // development | production
define('APP_VERSION', '0.1.0-foundation');

define('TIMEZONE', 'Asia/Ho_Chi_Minh');
date_default_timezone_set(TIMEZONE);

define('BASE_PATH', dirname(__DIR__));

$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$host = $_SERVER['HTTP_HOST'] ?? 'localhost';
$scriptName = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '/');
$scriptFilename = realpath($_SERVER['SCRIPT_FILENAME'] ?? '');
$appRoot = realpath(BASE_PATH);
$basePath = '';

if ($scriptFilename !== false && $appRoot !== false) {
    $appRoot = rtrim(str_replace('\\', '/', $appRoot), '/');
    $scriptFilename = str_replace('\\', '/', $scriptFilename);
    $appPrefix = $appRoot . '/';

    if (strncasecmp($scriptFilename, $appPrefix, strlen($appPrefix)) === 0) {
        $relativeScript = substr($scriptFilename, strlen($appPrefix));
        $uriSuffix = '/' . str_replace('\\', '/', $relativeScript);

        if (
            strlen($scriptName) >= strlen($uriSuffix)
            && strncasecmp(substr($scriptName, -strlen($uriSuffix)), $uriSuffix, strlen($uriSuffix)) === 0
        ) {
            $basePath = substr($scriptName, 0, -strlen($uriSuffix));
        }
    }
}

define('BASE_URL', $scheme . '://' . $host . $basePath);


// define('DB_HOST', 'localhost');
// define('DB_NAME', 'ecommerce');
// define('DB_USER', 'root');
// define('DB_PASS', '');
// define('DB_CHARSET', 'utf8mb4');
// xampp 
// define('DB_HOST', '127.0.0.1');
// define('DB_PORT', '3307');
// define('DB_NAME', 'ecommerce');
// define('DB_USER', 'root');
// define('DB_PASS', '');
// define('DB_CHARSET', 'utf8mb4');
//docker
define('DB_HOST', getenv('DB_HOST') ?: '127.0.0.1');
define('DB_PORT', getenv('DB_PORT') ?: '3307');
define('DB_NAME', getenv('DB_NAME') ?: 'ecommerce');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('DB_PASS') ?: '');
define('DB_CHARSET', 'utf8mb4');

define('UPLOAD_PATH', BASE_PATH . DIRECTORY_SEPARATOR . 'uploads');
define('UPLOAD_URL', BASE_URL . '/uploads');
define('UPLOAD_PRODUCTS', UPLOAD_PATH . DIRECTORY_SEPARATOR . 'products');
define('UPLOAD_POSTS', UPLOAD_PATH . DIRECTORY_SEPARATOR . 'posts');
define('UPLOAD_BANNERS', UPLOAD_PATH . DIRECTORY_SEPARATOR . 'banners');
define('MAX_UPLOAD_BYTES', 5 * 1024 * 1024);
define('ALLOWED_IMAGE_MIMES', [
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    'image/gif' => 'gif',
]);

define('CURRENCY_CODE', 'VND');
define('CURRENCY_LOCALE', 'vi_VN');
define('ITEMS_PER_PAGE', 12);

define('SESSION_NAME', 'NORDSESSID');
define('SESSION_LIFETIME', 60 * 60 * 24 * 7);
